Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYCJBUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYCJBUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 21:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYCJBUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 21:20:20 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:56020
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbYCJBUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 21:20:18 -0400
Date: Sun, 9 Mar 2008 18:20:14 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-usb@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  mass storage : emulation of sat scsi_pass_thru with ATACB
Message-ID: <20080310012014.GG2820@one-eyed-alien.net>
Mail-Followup-To: matthieu castet <castet.matthieu@free.fr>,
	linux-usb@vger.kernel.org,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <47D2CD95.9070701@free.fr> <20080308183125.GB2820@one-eyed-alien.net> <47D2F23A.4020103@free.fr> <20080308212148.GC2820@one-eyed-alien.net> <47D39E14.9050900@free.fr> <20080309184524.GF2820@one-eyed-alien.net> <47D459DA.20207@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4f28nU6agdXSinmL"
Content-Disposition: inline
In-Reply-To: <47D459DA.20207@free.fr>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Sun, 09 Mar 2008 18:20:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4f28nU6agdXSinmL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 09, 2008 at 10:42:50PM +0100, matthieu castet wrote:
> Hi
>=20
> here an update version of the patch

We're getting very close here.

> + 	/* this value can change, but most(all ?) manufacturers keep the=20
> cypress
> +	 * default : 0x24
> +	 */

Line wrap problem.  This happens a few times in your patch, but this was
the first one I noticed.

> +	srb->cmnd[0] =3D 0x24;
> +	srb->cmnd[1] =3D 0x24;
> +	srb->cmnd[2] =3D 0;
> +
> +	srb->cmnd[3] =3D 0xff - 1;
> +	srb->cmnd[4] =3D 1;

What are these magic constants?  Symbolic names or comments would be
apropriate here.

> +	if (srb->cmnd[12] =3D=3D ATA_CMD_ID_ATA || srb->cmnd[12] =3D=3D=20
> ATA_CMD_ID_ATAPI)
> +		srb->cmnd[2] |=3D (1<<7);

What does this block do?  In general, you could use some more comments
about the code flow...

> +	/* if the device doesn't support ATACB
> +	 * abort and register usb_stor_transparent_scsi_command
> +	 * callback
> +	 */
> +	if (srb->result =3D=3D SAM_STAT_CHECK_CONDITION &&
> +			memcmp(srb->sense_buffer, usb_stor_sense_invalidCDB,
> +				sizeof(usb_stor_sense_invalidCDB)) =3D=3D 0) {
> +		us->subclass =3D US_SC_SCSI;
> +		us->proto_handler =3D usb_stor_transparent_scsi_command;
> +		goto end;
> +	}

This is an interesting section of code.  Do you have reason to believe that
some of the units you've claimed via unusual_devs.h do not support this
protocol, or are you just being forward-looking?

Either way, some debug printout would be good here...

> --- linux-2.6.24.2.orig/include/linux/usb_usual.h	2008-03-09=20
> 21:15:01.000000000 +0100
> +++ linux-2.6.24.2/include/linux/usb_usual.h	2008-03-09=20
> 21:24:12.000000000 +0100
> @@ -81,8 +81,9 @@
>  #define US_SC_8070	0x05		/* Removable media */
>  #define US_SC_SCSI	0x06		/* Transparent */
>  #define US_SC_ISD200    0x07		/* ISD200 ATA */
> +#define US_SC_CYP_ATACB 0x08		/* Cypress ATACB */
>  #define US_SC_MIN	US_SC_RBC
> -#define US_SC_MAX	US_SC_ISD200
> +#define US_SC_MAX	US_SC_CYP_ATACB
>=20
>  #define US_SC_DEVICE	0xff		/* Use device's value */

I thought we changed this so that the non-spec protocols started from 0xfe
and worked their way down?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  They kicked your ass, didn't they?
S:  They were cheating!
					-- The Chief and Stef
User Friendly, 11/19/1997

--4f28nU6agdXSinmL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH1IzOHL9iwnUZqnkRAsboAKC0i1WgHW/6YbzXvtB+V/bpu5jtowCePghO
5tjCTNaFxzEalxQtpaiB6jg=
=gLt2
-----END PGP SIGNATURE-----

--4f28nU6agdXSinmL--
