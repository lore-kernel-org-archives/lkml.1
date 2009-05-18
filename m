Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbZERJwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbZERJwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758839AbZERJra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:47:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:54028 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942AbZERJr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:47:28 -0400
Date: Mon, 18 May 2009 11:47:45 +0200
From: Kurt Garloff <garloff@suse.de>
To: Linux kernel list <linux-kernel@vger.kernel.org>,
       Norbert Eicker <N.Eicker@fz-juelich.de>,
       Greg Kroah-Hartman <GregKH@suse.de>,
       Alexey Starikovskiy <AStarikovskiy@suse.cz>,
       Len Brown <LenB@kernel.org>, xb <xavier.bru@bull.net>
Subject: Re: [PATCH 2/3]: x86-64: Handle SRAT v1 and v2 consistently
Message-ID: <20090518094745.GF15531@tpkurt2.garloff.de>
Mail-Followup-To: Kurt Garloff <garloff@suse.de>,
	Linux kernel list <linux-kernel@vger.kernel.org>,
	Norbert Eicker <N.Eicker@fz-juelich.de>,
	Greg Kroah-Hartman <GregKH@suse.de>,
	Alexey Starikovskiy <AStarikovskiy@suse.cz>,
	Len Brown <LenB@kernel.org>, xb <xavier.bru@bull.net>
References: <20090518093352.GC15531@tpkurt2.garloff.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EemXnrF2ob+xzFeB"
Content-Disposition: inline
In-Reply-To: <20090518093352.GC15531@tpkurt2.garloff.de>
X-Operating-System: Linux 2.6.27.21-5.1-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
Organization: SUSE Linux Products GmbH (a Novell company), Nuernberg, GF:
	Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EemXnrF2ob+xzFeB
Content-Type: multipart/mixed; boundary="Cgrdyab2wu3Akvjd"
Content-Disposition: inline


--Cgrdyab2wu3Akvjd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

x86-64 was rather inconsistent prior to this patch; it used 8 bits=20
for the pxm field in cpu_affinity, but 32 bits in mem_affinity.
This patch makes it consistent: Either use 8 bits consistently (SRAT
rev 1 or lower) or 32 bits (SRAT rev 2 or higher).

This is patch 2/3.
--=20
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.

--Cgrdyab2wu3Akvjd
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="srat-pxm-rev-x86-64.diff"
Content-Transfer-Encoding: quoted-printable

=46rom: Kurt Garloff <garloff@suse.de>
Subject: Use SRAT table rev to use 8bit or 32bit PXM fields (x86-64)
References: bnc#503038

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregrard reserved fields.

x86-64 was rather inconsistent prior to this patch; it used 8 bits=20
for the pxm field in cpu_affinity, but 32 bits in mem_affinity.
This patch makes it consistent: Either use 8 bits consistently (SRAT
rev 1 or lower) or 32 bits (SRAT rev 2 or higher).

This is patch 2/3.

Signed-off-by: Kurt Garloff <garloff@suse.de>

diff -r a4ed8abcc815 arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c	Sat May 16 13:41:28 2009 -0700
+++ b/arch/x86/mm/srat_64.c	Mon May 18 10:45:40 2009 +0200
@@ -164,6 +164,8 @@
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) =3D=3D 0)
 		return;
 	pxm =3D pa->proximity_domain_lo;
+	if (acpi_srat_revision >=3D 2)
+		pxm |=3D *((unsigned int*)pa->proximity_domain_hi) << 8;
 	node =3D setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -275,6 +277,8 @@
 	start =3D ma->base_address;
 	end =3D start + ma->length;
 	pxm =3D ma->proximity_domain;
+	if (acpi_srat_revision <=3D 1)
+		pxm &=3D 0xff;
 	node =3D setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");


--Cgrdyab2wu3Akvjd--

--EemXnrF2ob+xzFeB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFKES7BxmLh6hyYd04RAlciAKDM5+R4vggAwJKXxm2rDmvqAd0XRQCg04DL
KpR3F7nsfclKD6h1gOjfS24=
=4WN9
-----END PGP SIGNATURE-----

--EemXnrF2ob+xzFeB--
