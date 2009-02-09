Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZBIAY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZBIAY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 19:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZBIAYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 19:24:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:50278 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753531AbZBIAYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 19:24:45 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+L64gpZu6LA6Gwvf8pKegwf6ECpiXF59iyRDXSe3
	4ZeU4MWjHJvYFw
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: patch acpi-remove-locking-from-pm1x_sts-register-reads.patch added to 2.6.28-stable tree
Date: Mon, 9 Feb 2009 01:24:43 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, stable@kernel.org
References: <20090208211932.4CAB349019@coco.kroah.org>
In-Reply-To: <20090208211932.4CAB349019@coco.kroah.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1892655.AxkGIgYmW7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902090124.44228.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1892655.AxkGIgYmW7
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

On Sonntag, 8. Februar 2009, gregkh@suse.de wrote:
>=20
> This is a note to let you know that we have just queued up the patch titl=
ed
>=20
>     Subject: ACPI: remove locking from PM1x_STS register reads
>=20
> to the 2.6.28-stable tree.  Its filename is
>=20
>     acpi-remove-locking-from-pm1x_sts-register-reads.patch
[...]
> From a2b7b01c072435b7832ab392167545a1b38cabc3 Mon Sep 17 00:00:00 2001
> From: Len Brown <len.brown@intel.com>
> Date: Wed, 28 Jan 2009 12:47:15 -0500
> Subject: ACPI: remove locking from PM1x_STS register reads
>=20
> From: Len Brown <len.brown@intel.com>
>=20
> commit a2b7b01c072435b7832ab392167545a1b38cabc3 upstream.
>=20
> PM1a_STS and PM1b_STS are twins that get OR'd together
> on reads, and all writes are repeated to both.
>=20
> The fields in PM1x_STS are single bits only,
> there are no multi-bit fields.
>=20
> So it is not necessary to lock PM1x_STS reads against
> writes because it is impossible to read an intermediate
> value of a single bit.  It will either be 0 or 1,
> even if a write is in progress during the read.
> Reads are asynchronous to writes no matter if a lock
> is used or not.
>=20
> Signed-off-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

This patch fails to compile on 2.6.28.4 + queue-2.6.28 (and 2.6.27 as=20
well):


  BUILD   arch/x86/boot/bzImage
Root device is (254, 1)
Setup is 11676 bytes (padded to 11776 bytes).
System is 2175 kB
CRC d4d9303a
Kernel: arch/x86/boot/bzImage is ready  (#1)
ERROR: "acpi_get_register_unlocked" [drivers/acpi/processor.ko] undefined!
make[4]: *** [__modpost] Error 1
make[3]: *** [modules] Error 2


because it seems to depend on the larger changes started in, but not=20
limited to:


=46rom ecfbbc7b46f74ca48b9f42132739114c9e70f8e4 Mon Sep 17 00:00:00 2001
=46rom: Bob Moore <robert.moore@intel.com>
Date: Wed, 31 Dec 2008 02:55:32 +0800
Subject: [PATCH] ACPICA: New: acpi_read and acpi_write public interfaces

Changed the acpi_hw_low_level_read and acpi_hw_low_level_write functions to
the public acpi_read and acpi_write to allow direct access to
ACPI registers.  Removed the "width" parameter since the width
can be obtained from the input GAS structure. Updated the FADT
initialization to setup the GAS structures with the proper
widths. Some widths are still hardcoded because many FADTs have
incorrect register lengths.

Signed-off-by: Bob Moore <robert.moore@intel.com
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>


acpi_get_register_unlocked() seems to be a new feature and lots of h/w=20
interfaces have been converted to use it for 2.6.29-git, a quick grep=20
reveals:


=46rom 7db5d82d0278b506441ab6025f0c6ce2f2aa3019 Mon Sep 17 00:00:00 2001
=46rom: Bob Moore <robert.moore@intel.com>
Date: Tue, 30 Dec 2008 11:04:48 +0800
Subject: [PATCH] ACPICA: Move all public H/W interfaces to new hwxface

=46rom 95b482a8d31116f3f5c2a5089569393234d06385 Mon Sep 17 00:00:00 2001
=46rom: Len Brown <len.brown@intel.com>
Date: Fri, 9 Jan 2009 00:13:17 -0500
Subject: [PATCH] ACPICA: create acpica/ directory

=46rom 9fdd54f206722ecee7fd7ba9dba26140450e7c32 Mon Sep 17 00:00:00 2001
=46rom: Len Brown <len.brown@intel.com>
Date: Fri, 6 Feb 2009 12:24:17 -0500
Subject: [PATCH] ACPI: delete CPU_IDLE=3Dn code


and this patch, amounting to rather large changes in total.

>  drivers/acpi/processor_idle.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -446,7 +446,7 @@ static void acpi_processor_idle(void)
> =20
>  		pr->power.bm_activity <<=3D diff;
> =20
> -		acpi_get_register(ACPI_BITREG_BUS_MASTER_STATUS, &bm_status);
> +		acpi_get_register_unlocked(ACPI_BITREG_BUS_MASTER_STATUS, &bm_status);
>  		if (bm_status) {
>  			pr->power.bm_activity |=3D 0x1;
>  			acpi_set_register(ACPI_BITREG_BUS_MASTER_STATUS, 1);
> @@ -1382,7 +1382,7 @@ static int acpi_idle_bm_check(void)
>  {
>  	u32 bm_status =3D 0;
> =20
> -	acpi_get_register(ACPI_BITREG_BUS_MASTER_STATUS, &bm_status);
> +	acpi_get_register_unlocked(ACPI_BITREG_BUS_MASTER_STATUS, &bm_status);
>  	if (bm_status)
>  		acpi_set_register(ACPI_BITREG_BUS_MASTER_STATUS, 1);
>  	/*

Regards
	Stefan Lippers-Hollmann

--nextPart1892655.AxkGIgYmW7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmPd8wACgkQORbEMfgJlPZDMwCeJ02A3GPZg089DKw50dtU4nRm
ZMgAoLjNOc0XsuLkyy2NdUVUrNW0TZcS
=3TRv
-----END PGP SIGNATURE-----

--nextPart1892655.AxkGIgYmW7--
