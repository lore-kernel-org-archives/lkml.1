Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbZGNQ55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbZGNQ55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbZGNQ54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:57:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:56418 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbZGNQ54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:57:56 -0400
Date: Tue, 14 Jul 2009 18:58:30 +0200
From: Kurt Garloff <garloff@suse.de>
To: Linux kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] Resend: x86-64: Handle SRAT v1 and v2 consistently
Message-ID: <20090714165830.GF31657@tpkurt2.suse.de>
Mail-Followup-To: Kurt Garloff <garloff@suse.de>,
	Linux kernel list <linux-kernel@vger.kernel.org>
References: <20090518093352.GC15531@tpkurt2.garloff.de> <20090622140522.GA5378@sgi.com> <20090714165508.GD31657@tpkurt2.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyqLL/JqMvClXZi1"
Content-Disposition: inline
In-Reply-To: <20090714165508.GD31657@tpkurt2.suse.de>
X-Operating-System: Linux 2.6.27.23-0.1-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
Organization: SUSE Linux Products GmbH (a Novell company), Nuernberg, GF:
	Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyqLL/JqMvClXZi1
Content-Type: multipart/mixed; boundary="m0vRWufqUC70IDnR"
Content-Disposition: inline


--m0vRWufqUC70IDnR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregard reserved fields.

x86-64 was rather inconsistent prior to this patch; it used 8 bits=20
for the pxm field in cpu_affinity, but 32 bits in mem_affinity.
This patch makes it consistent: Either use 8 bits consistently (SRAT
rev 1 or lower) or 32 bits (SRAT rev 2 or higher).

This is patch 2/3.

Signed-off-by: Kurt Garloff <garloff@suse.de>
--=20
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.

--m0vRWufqUC70IDnR
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="02_srat-pxm-rev-x86-64.diff"
Content-Transfer-Encoding: quoted-printable

=46rom: Kurt Garloff <garloff@suse.de>
Subject: Use SRAT table rev to use 8bit or 32bit PXM fields (x86-64)
References: bnc#503038

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregard reserved fields.

x86-64 was rather inconsistent prior to this patch; it used 8 bits=20
for the pxm field in cpu_affinity, but 32 bits in mem_affinity.
This patch makes it consistent: Either use 8 bits consistently (SRAT
rev 1 or lower) or 32 bits (SRAT rev 2 or higher).

This is patch 2/3.

Signed-off-by: Kurt Garloff <garloff@suse.de>

diff -r a28eb89d1fe1 arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c	Tue Jul 14 02:00:45 2009 +0000
+++ b/arch/x86/mm/srat_64.c	Tue Jul 14 16:44:35 2009 +0200
@@ -154,6 +154,8 @@
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) =3D=3D 0)
 		return;
 	pxm =3D pa->proximity_domain_lo;
+	if (acpi_srat_revision >=3D 2)
+		pxm |=3D *((unsigned int*)pa->proximity_domain_hi) << 8;
 	node =3D setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -255,6 +257,8 @@
 	start =3D ma->base_address;
 	end =3D start + ma->length;
 	pxm =3D ma->proximity_domain;
+	if (acpi_srat_revision <=3D 1)
+		pxm &=3D 0xff;
 	node =3D setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");


--m0vRWufqUC70IDnR--

--oyqLL/JqMvClXZi1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFKXLk2xmLh6hyYd04RAosiAKC+LzkIGCOLAqotaD6c3Aj47H3yVwCfeb7b
Gyyk839X3zqGebh3ENBuFUw=
=kani
-----END PGP SIGNATURE-----

--oyqLL/JqMvClXZi1--
