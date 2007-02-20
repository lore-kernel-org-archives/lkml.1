Return-Path: <linux-kernel-owner+w=401wt.eu-S964872AbXBTN1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872AbXBTN1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964873AbXBTN1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:27:24 -0500
Received: from styx.suse.cz ([82.119.242.94]:51497 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964872AbXBTN1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:27:23 -0500
Subject: [PATCH] free pages in remove_arg_zero()
From: Petr =?iso-8859-2?Q?Tesa=F8=EDk?= <ptesarik@suse.cz>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wfpWRqaPKM2XEYUx4ya8"
Organization: SuSE CR
Date: Tue, 20 Feb 2007 14:29:04 +0100
Message-Id: <1171978145.22720.21.camel@golias.tesarici.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wfpWRqaPKM2XEYUx4ya8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello,

I've found a bug when executing scripts:

When a script is loaded, load_script() replaces argv[0] with the
name of the interpreter and the filename passed to the exec syscall.
However, there is no guarantee that the length of the interpreter
name plus the length of the filename is greater than the length of
the original argv[0]. If the difference happens to cross a page boundary,
setup_arg_pages() will call install_arg_page() with an address outside
the VMA.

Therefore, remove_arg_zero() must free all pages which would be unused
after the argument is removed.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

--- linux-sles9.orig/fs/exec.c
+++ linux-sles9/fs/exec.c
@@ -1000,6 +1000,8 @@ void remove_arg_zero(struct linux_binprm
 				continue;
 			offset =3D 0;
 			kunmap_atomic(kaddr, KM_USER0);
+			__free_page(page);
+			bprm->page[bprm->p/PAGE_SIZE - 1] =3D NULL;
 inside:
 			page =3D bprm->page[bprm->p/PAGE_SIZE];
 			kaddr =3D kmap_atomic(page, KM_USER0);


--=-wfpWRqaPKM2XEYUx4ya8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Toto je =?iso-8859-2?Q?digit=E1ln=EC?=
	=?ISO-8859-1?Q?_podepsan=E1?= =?iso-8859-2?Q?_=E8=E1st?=
	=?ISO-8859-1?Q?_zpr=E1vy?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBF2vegjpY2ODFi2ogRAqMLAJ9w9oi2DXzKMBp7MvK4l2qJExIyPwCfW4K/
8LT+UQlhr3SaPeIl9ILfUMw=
=Smaj
-----END PGP SIGNATURE-----

--=-wfpWRqaPKM2XEYUx4ya8--

