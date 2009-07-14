Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbZGNQ6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbZGNQ6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbZGNQ6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:58:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:56433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792AbZGNQ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:58:43 -0400
Date: Tue, 14 Jul 2009 18:59:18 +0200
From: Kurt Garloff <garloff@suse.de>
To: Linux kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] Resend: Consider SRAT rev on ia64
Message-ID: <20090714165918.GG31657@tpkurt2.suse.de>
Mail-Followup-To: Kurt Garloff <garloff@suse.de>,
	Linux kernel list <linux-kernel@vger.kernel.org>
References: <20090518093352.GC15531@tpkurt2.garloff.de> <20090622140522.GA5378@sgi.com> <20090714165508.GD31657@tpkurt2.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tAmVnWIZ6lqEAvSf"
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


--tAmVnWIZ6lqEAvSf
Content-Type: multipart/mixed; boundary="TKDEsImF70pdVIl+"
Content-Disposition: inline


--TKDEsImF70pdVIl+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregard reserved fields.

ia64 did handle the PXM fields almost consistently, but depending on=20
sgi's sn2 platform. This patch leaves the sn2 logic in, but does also
use 16/32 bits for PXM if the SRAT has rev 2 or higher.

The patch also adds __init to the two pxm accessor functions, as they
access __initdata now and are called from an __init function only anyway.

Note that the code only uses 16 bits for the PXM field in the processor
proximity field; the patch does not address this as 16 bits are more than
enough.

This is patch 3/3.

Signed-off-by: Kurt Garloff <garloff@suse.de>
--=20
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.

--TKDEsImF70pdVIl+
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="03_srat-pxm-rev-ia64.diff"
Content-Transfer-Encoding: quoted-printable

=46rom: Kurt Garloff <garloff@suse.de>
Subject: Use SRAT table rev to use 8bit or 16/32bit PXM fields (ia64)
References: bnc#503038

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregard reserved fields.

ia64 did handle the PXM fields almost consistently, but depending on=20
sgi's sn2 platform. This patch leaves the sn2 logic in, but does also
use 16/32 bits for PXM if the SRAT has rev 2 or higher.

The patch also adds __init to the two pxm accessor functions, as they
access __initdata now and are called from an __init function only anyway.

Note that the code only uses 16 bits for the PXM field in the processor
proximity field; the patch does not address this as 16 bits are more than
enough.

This is patch 3/3.

Signed-off-by: Kurt Garloff <garloff@suse.de>

diff -r a28eb89d1fe1 arch/ia64/kernel/acpi.c
--- a/arch/ia64/kernel/acpi.c	Tue Jul 14 02:00:45 2009 +0000
+++ b/arch/ia64/kernel/acpi.c	Tue Jul 14 16:44:35 2009 +0200
@@ -456,22 +456,24 @@
 static struct acpi_table_slit __initdata *slit_table;
 cpumask_t early_cpu_possible_map =3D CPU_MASK_NONE;
=20
-static int get_processor_proximity_domain(struct acpi_srat_cpu_affinity *p=
a)
+static int __init
+get_processor_proximity_domain(struct acpi_srat_cpu_affinity *pa)
 {
 	int pxm;
=20
 	pxm =3D pa->proximity_domain_lo;
-	if (ia64_platform_is("sn2"))
+	if (ia64_platform_is("sn2") || acpi_srat_revision >=3D 2)
 		pxm +=3D pa->proximity_domain_hi[0] << 8;
 	return pxm;
 }
=20
-static int get_memory_proximity_domain(struct acpi_srat_mem_affinity *ma)
+static int __init
+get_memory_proximity_domain(struct acpi_srat_mem_affinity *ma)
 {
 	int pxm;
=20
 	pxm =3D ma->proximity_domain;
-	if (!ia64_platform_is("sn2"))
+	if (!ia64_platform_is("sn2") && acpi_srat_revision <=3D 1)
 		pxm &=3D 0xff;
=20
 	return pxm;

--TKDEsImF70pdVIl+--

--tAmVnWIZ6lqEAvSf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFKXLlmxmLh6hyYd04RApX0AKDGWHnPZS1WhgsU56eEDlhENwX/mwCgoF+W
SWmIMVShud0O9xDYxLfwRZE=
=vd4H
-----END PGP SIGNATURE-----

--tAmVnWIZ6lqEAvSf--
