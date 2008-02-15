Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYBOPpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYBOPpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYBOPp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:45:28 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:4222 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbYBOPpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:45:25 -0500
Date: Fri, 15 Feb 2008 16:45:03 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com
Subject: Re: [PATCH] Use directly kmalloc() and kfree() in init/initramfs.c
Message-ID: <20080215164503.245752e6@crazy>
In-Reply-To: <Pine.LNX.4.64.0802151546230.30301@fbirervta.pbzchgretzou.qr>
References: <20080215121330.3f790783@crazy>
	<Pine.LNX.4.64.0802151546230.30301@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/o2pe_2hz+fq5buQM_hwEcmN";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/o2pe_2hz+fq5buQM_hwEcmN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le Fri, 15 Feb 2008 15:46:47 +0100 (CET),
Jan Engelhardt <jengelh@computergmbh.de> a =C3=A9crit :

> Remove the cast while you are at it, thanks :)

Right, thanks for the comment. Here is an updated patch. Who will pick
it up ? There doesn't seem to be a maintainer for the initramfs code
(not in MAINTAINERS, not in the init/initramfs.c file itself).

Thanks,

Thomas

---

Instead of using the malloc() and free() wrappers needed by the
lib/inflate.c code for allocations, simply use kmalloc() and kfree() in
the initramfs code. This is needed for a further lib/inflate.c-related
cleanup patch that will remove the malloc() and free() functions.

Take that opportunity to remove the useless kmalloc() return value
cast.

Based of work done by Matt Mackall <mpm@selenic.com>.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 init/initramfs.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux/init/initramfs.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/init/initramfs.c
+++ linux/init/initramfs.c
@@ -57,7 +57,7 @@
 			continue;
 		return (*p)->name;
 	}
-	q =3D (struct hash *)malloc(sizeof(struct hash));
+	q =3D kmalloc(sizeof(struct hash), GFP_KERNEL);
 	if (!q)
 		panic("can't allocate link hash entry");
 	q->major =3D major;
@@ -77,7 +77,7 @@
 		while (*p) {
 			q =3D *p;
 			*p =3D q->next;
-			free(q);
+			kfree(q);
 		}
 	}
 }
@@ -445,10 +445,10 @@
 {
 	int written;
 	dry_run =3D check_only;
-	header_buf =3D malloc(110);
-	symlink_buf =3D malloc(PATH_MAX + N_ALIGN(PATH_MAX) + 1);
-	name_buf =3D malloc(N_ALIGN(PATH_MAX));
-	window =3D malloc(WSIZE);
+	header_buf =3D kmalloc(110, GFP_KERNEL);
+	symlink_buf =3D kmalloc(PATH_MAX + N_ALIGN(PATH_MAX) + 1, GFP_KERNEL);
+	name_buf =3D kmalloc(N_ALIGN(PATH_MAX), GFP_KERNEL);
+	window =3D kmalloc(WSIZE, GFP_KERNEL);
 	if (!window || !header_buf || !symlink_buf || !name_buf)
 		panic("can't allocate buffers");
 	state =3D Start;
@@ -484,10 +484,10 @@
 		buf +=3D inptr;
 		len -=3D inptr;
 	}
-	free(window);
-	free(name_buf);
-	free(symlink_buf);
-	free(header_buf);
+	kfree(window);
+	kfree(name_buf);
+	kfree(symlink_buf);
+	kfree(header_buf);
 	return message;
 }
=20


--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/o2pe_2hz+fq5buQM_hwEcmN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtbOC9lPLMJjT96cRAv71AKC1nDwG7qOr/5IRaM30FoKRYJBj7wCeO/sW
cqwZgnuQ4Khj6xRDlF9KjeM=
=qCsI
-----END PGP SIGNATURE-----

--Sig_/o2pe_2hz+fq5buQM_hwEcmN--
