Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbXFDLGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbXFDLGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbXFDLGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:06:00 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:60812 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbXFDLF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:05:59 -0400
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
In-Reply-To: <20070604110209.GJ4363@elf.ucw.cz>
References: <4658B7DD.3060309@tmr.com>
	 <1180392482.4149.15.camel@nigel.suspend2.net>
	 <20070529112952.GA23046@elf.ucw.cz> <200705291403.09773.rjw@sisk.pl>
	 <20070529124052.GH23046@elf.ucw.cz>
	 <1180444425.20718.33.camel@nigel.suspend2.net>
	 <20070604110209.GJ4363@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5IXzqLTGtRBY0KxGj6Wz"
Date: Mon, 04 Jun 2007 21:05:57 +1000
Message-Id: <1180955157.4356.2.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5IXzqLTGtRBY0KxGj6Wz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Mon, 2007-06-04 at 13:02 +0200, Pavel Machek wrote:
> Hi!
>=20
> > > > They are already.
> > >=20
> > > ...but will that place still be safe when we use other version of
> > > kernel?
> >=20
> > They'll be in the image too, won't they? Failing that, the information
> > could be stored in the image header.
> >=20
> > > Anyway, pagedirs are on the safe place, right? That means that we
> > > swsusp should no longer clash with page allocation debugging...=20
> >=20
> > You mean DEBUG_PAGEALLOC? That can be overcome easily - I have code in
> > current Suspend2 that works with DEBUG_PAGEALLOC. I handle the page
> > fault, mapping the page and setting a flag in the fault handler to tell
> > the atomic copy code to unmap the page again once it has been copied.
>=20
> I meant debug_pagealloc, but no, I do not think we want to make page
> fault handler more complex. Switching to 1:1 mapping tables should be
> enough.
> 								Pavel

@@ -311,6 +315,20 @@ fastcall void __kprobes do_page_fault(struct pt_regs *=
regs,
=20
 	si_code =3D SEGV_MAPERR;
=20
+	/* During a Suspend2 atomic copy, with DEBUG_SLAB, we will
+	 * get page faults where slab has been unmapped. Map them
+	 * temporarily and set the variable that tells Suspend2 to
+	 * unmap afterwards.
+	 */
+
+	if (unlikely(suspend2_running && !suspend2_faulted)) {
+		struct page *page =3D NULL;
+		suspend2_faulted =3D 1;
+		page =3D virt_to_page(address);
+		kernel_map_pages(page, 1, 1);
+		return;
+	}
+
 	/*
 	 * We fault-in kernel-space virtual memory on-demand. The
 	 * 'reference' page table is init_mm.pgd.

Regards,

Nigel

--=-5IXzqLTGtRBY0KxGj6Wz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGY/IVN0y+n1M3mo0RAuiZAJ0Xym7evDWEjnrDwTPiDvJ7MDIIaACeLw+R
TUQTNOrjypuEWBrj+YdzDhA=
=uTb5
-----END PGP SIGNATURE-----

--=-5IXzqLTGtRBY0KxGj6Wz--

