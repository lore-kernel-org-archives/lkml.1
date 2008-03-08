Return-Path: <linux-kernel-owner+w=401wt.eu-S1751780AbYCHVYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbYCHVYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYCHVVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:21:53 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:57357
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938AbYCHVVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:21:50 -0500
Date: Sat, 8 Mar 2008 13:21:48 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-usb@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  mass storage : emulation of sat scsi_pass_thru with ATACB
Message-ID: <20080308212148.GC2820@one-eyed-alien.net>
Mail-Followup-To: matthieu castet <castet.matthieu@free.fr>,
	linux-usb@vger.kernel.org,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <47D2CD95.9070701@free.fr> <20080308183125.GB2820@one-eyed-alien.net> <47D2F23A.4020103@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GZVR6ND4mMseVXL/"
Content-Disposition: inline
In-Reply-To: <47D2F23A.4020103@free.fr>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Sat, 08 Mar 2008 13:21:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 08, 2008 at 09:08:26PM +0100, matthieu castet wrote:
> Hi Matthew,
>=20
> thanks for your comments
>=20
> Matthew Dharm wrote:
> >Why are you using an initializer instead of a new protocol code?
> Because using a new protocol code means I need to patch all the place=20
> where there is a comparison between us->subclass and US_SC_SCSI.
> After all I am US_SC_SCSI with a special case for ATA12 & ATA16 commands.
> I don't translate all scsi to atacb (that's what does US_SC_ISD200).

Yet, you call invoke_transport directly, just like any other protocol
handler.

The proper way to do this is as a separate protocol handler.  If you want
to make it clear that you are only intercepting a couple of command types,
then don't call invoke_transport() directly, call the transparent scsi
protocol handler (which, of course, does the same thing but provides
clearer layering).

Oh, and you should add some "unlikely" tags to these if() conditionals.

> >Actually, why do you even have a separate 'dispatcher' function?  Why not
> >just one protocol handler function which checks the command at the top a=
nd
> >calls invoke_transport there?
> What do you means by having a separate 'dispatcher' function?
> You means why I have 2 functions emulate_pass_thru_with_atacb and=20
> usb_stor_transparent_scsi_command_atacb ?
> I did 2 functions for having a code more clean.
>=20
> You suggest something like
> void usb_stor_transparent_scsi_command_atacb(struct scsi_cmnd *srb,
>                        struct us_data *us)
> {
>     if (srb->cmnd[0] !=3D ATA_16 && srb->cmnd[0] !=3D ATA_12) {
>         usb_stor_invoke_transport(srb, us);
>         return;
>     }
>     copy emulate_pass_thru_with_atacb code here
> }

Yes, modulo my comment above about calling the transparent scsi protocol
handler instead of invoke_transport directly.

> >Also, unless ATACB is a new standard (and I don't think it is, as the
> >Cypress datasheet uses the term 'vendor specific'), then your functions
> >need renaming.  Instead of 'emulate_pass_thru_with_atacb', how about
> >something like 'cypress_atacb' --  since it's already a protocol handler,
> >everyone already knows it's for passing commands.
> But 'emulate_pass_thru_with_atacb' only handle ATA pass_thru scsi=20
> commands. It doesn't translate all scsi commands to atacb like=20
> 'cypress_atacb' could suggest.
> That's why I put 'usb_stor_transparent_scsi_command_atacb' saying it is=
=20
> transparent_scsi_command + atacb support.

Yes, but your name suggests that ATACB is a new industry standard which is
implemented by more than a few chips from one specific vendor.  That's not
acceptable.

Try 'cypress_atacb_passthrough' instead?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

P:  Nine more messages in admin.policy.
M: I know, I'm typing as fast as I can!
					-- Pitr and Mike
User Friendly, 11/27/97

--GZVR6ND4mMseVXL/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH0wNsHL9iwnUZqnkRArNSAKCWaxCollYuZyYU6ezRL5CWZSQmVwCgiM2A
JsidgsAtU2dUStOp+zyawQ0=
=8poH
-----END PGP SIGNATURE-----

--GZVR6ND4mMseVXL/--
