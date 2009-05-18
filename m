Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbZERJsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbZERJsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbZERJdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:33:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757464AbZERJdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:33:35 -0400
Date: Mon, 18 May 2009 11:33:52 +0200
From: Kurt Garloff <garloff@suse.de>
To: Linux kernel list <linux-kernel@vger.kernel.org>
Cc: Norbert Eicker <N.Eicker@fz-juelich.de>,
       Greg Kroah-Hartman <GregKH@suse.de>,
       Alexey Starikovskiy <AStarikovskiy@suse.cz>,
       Len Brown <LenB@kernel.org>
Subject: [PATCH 0/3]: Discard reserved PXM bits for SRAT v1
Message-ID: <20090518093352.GC15531@tpkurt2.garloff.de>
Mail-Followup-To: Kurt Garloff <garloff@suse.de>,
	Linux kernel list <linux-kernel@vger.kernel.org>,
	Norbert Eicker <N.Eicker@fz-juelich.de>,
	Greg Kroah-Hartman <GregKH@suse.de>,
	Alexey Starikovskiy <AStarikovskiy@suse.cz>,
	Len Brown <LenB@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
X-Operating-System: Linux 2.6.27.21-5.1-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
Organization: SUSE Linux Products GmbH (a Novell company), Nuernberg, GF:
	Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

ACPI specification says that the OS must disregard reserved bits.
The x86_64 SRAT parser does not discard the upper 24 bits of the
proximity_domain (pxm) in the acpi_srat_mem_affinity entries for
SRAT v1 tables. (v2 has 32 bits wide fields.)
This can lead to problems with poor BIOS implementations that failed
to set resreved bytes to zero. (The ACPI spec is a bit vague here
unfortunately.)

This was also inconsistent: On x86-64 (srat_64.c), the=20
_cpu_affinity does only use the low 8 bits of pxm, while the
full 32 bits of _mem_affinity are consumed.
In srat_32.c (x86), only 8bits are used (which is OK, a 32bit system
with >256 PXMs does not seem reasonable at all).
On ia64, the support of more than 8 bits was consistent between
mem and cpu affinity entries, however it dependent on "sn2" platform.

The patch series has the following goals:
* Make the kernel support consistently 8bits or 32bits for the
  proximity domain
* Make this dependent on the SRAT version; v1 =3D> 8bits, v2 =3D> 32bits.

Overview over the patches:
- [1/3] Store the SRAT table version value in acpi_srat_revision=20
- [2/3] x86-64: Discard the upper 24 bits in mem_affinity if rev <=3D 1
        and use upper 24bits in cpu_affinity if rev >=3D 2
- [3/3] ia64: Also use upper 8/24bits if rev >=3D 2 (but leave logic to
        enable on sn2 as well -- I don't know if sn2 reports v1 or v2
        SRAT) Also add two __init decls in ia64 pxm accessors.

Patch has been tested on x86-64 against an 2.6.27.x kernel.
(Patch is against current git.)

Thanks for James, Greg, Alexey, Norbert for comments, review and testing.

Please review and apply!

Greg, I believe this is a candidate for -stable.
--=20
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFKESuAxmLh6hyYd04RAhvdAJ4zMo2obWTdsSqSTRyoz/+0ezmVjACfSJwt
2VUE10ncsS3Bt6xVBushcs0=
=YOzQ
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--
