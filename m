Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbZIUXDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbZIUXDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 19:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZIUXDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 19:03:46 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52809 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754181AbZIUXDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 19:03:45 -0400
X-Sasl-enc: ooOV5k5Pt9k/pmwa4E+qjnuCv4oSrwy8gW7CyQWxMrJX 1253574227
Message-ID: <4AB80646.6020008@imap.cc>
Date: Tue, 22 Sep 2009 01:03:34 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Matthias Geissert <matthias.geissert@web.de>, Greg KH <greg@kroah.com>,
       USB list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of Bug 8094 -  ipaq oops on connecting "Vodafone VPA-II"
 ?
References: <Pine.LNX.4.44L0.0909202152420.15304-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0909202152420.15304-100000@netrider.rowland.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig93D456C34221B56F54BB677F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig93D456C34221B56F54BB677F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 21.09.2009 03:59 schrieb Alan Stern:
> Here's a patch which ought to fix the oops.  I trust it won't cause=20
> any existing devices to start misbehaving.  Tilman and Matthias, please=
=20
> verify that this works okay on your systems.

It does fix the oops for me. The lines:

ipaq 2-2:1.0: usb_probe_interface
ipaq 2-2:1.0: usb_probe_interface - got id
ipaq 2-2:1.0: PocketPC PDA converter detected

are now followed by

ipaq: probe of 2-2:1.0 failed with error -5

and I end up with only a single

usb 2-2: PocketPC PDA converter now attached to ttyUSB0

instead of two (ttyUSB0 and ttyUSB1) previously.

The device still doesn't work because now rndis_host (which without
the patch didn't even get a chance to look at the interface) complains:

rndis_host 2-2:1.0: usb_probe_interface
rndis_host 2-2:1.0: usb_probe_interface - got id
rndis_host: probe of 2-2:1.0 failed with error -16

But that's a different story which I'll investigate a bit further
on my own before (if necessary) starting a discussion here.

So from my point of view the patch is fine.

Thanks,
Tilman

> A better approach might be to test the bInterfaceClass value, but I=20
> don't know if that would work; there might be some devices using a=20
> strange value.
>=20
> Alan Stern
>=20
>=20
>=20
> Index: usb-2.6/drivers/usb/serial/ipaq.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb-2.6.orig/drivers/usb/serial/ipaq.c
> +++ usb-2.6/drivers/usb/serial/ipaq.c
> @@ -966,6 +966,15 @@ static int ipaq_calc_num_ports(struct us
>  static int ipaq_startup(struct usb_serial *serial)
>  {
>  	dbg("%s", __func__);
> +
> +	/* Some of the devices in ipaq_id_table[] are composite, and we
> +	 * shouldn't bind to all the interfaces.  This test will rule out
> +	 * some obviously invalid possibilities.
> +	 */
> +	if (serial->num_bulk_in < serial->num_ports ||
> +			serial->num_bulk_out < serial->num_ports)
> +		return -ENODEV;
> +
>  	if (serial->dev->actconfig->desc.bConfigurationValue !=3D 1) {
>  		/*
>  		 * FIXME: HP iPaq rx3715, possibly others, have 1 config that
>=20

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig93D456C34221B56F54BB677F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKuAZQQ3+did9BuFsRAvK7AJ9t3elPQlg6/5+v8yzk4yJiGPMNRwCeNh8R
hO2PiLXI/bz7s4TOyM4DFzo=
=XqQi
-----END PGP SIGNATURE-----

--------------enig93D456C34221B56F54BB677F--
