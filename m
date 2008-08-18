Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYHROpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYHROpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbYHROou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:44:50 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:18452 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856AbYHROos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:44:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisFANsmqUjCTsYx/2dsb2JhbACBYrI6gVg
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 1/3] gpiolib: make gpio_to_chip() public
Date: Mon, 18 Aug 2008 16:44:36 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, "Greg Kroah-Hartman" <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, linux-kernel@vger.kernel.org,
       Timur Tabi <timur@freescale.com>
References: <20080808161717.GA19095@polina.dev.rtsoft.ru> <200808181558.50182.laurentp@cse-semaphore.com> <20080818143343.GA30812@oksana.dev.rtsoft.ru>
In-Reply-To: <20080818143343.GA30812@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1295929.rOlv2Qjvov";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808181644.45480.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1295929.rOlv2Qjvov
Content-Type: text/plain;
  charset="windows-1251"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 18 August 2008, Anton Vorontsov wrote:
> On Mon, Aug 18, 2008 at 03:58:46PM +0200, Laurent Pinchart wrote:
> [...]
> > > Not exactly. But you can do this way, if you need to preserve
> > > a direction. What I did is a bit different though.
> > >=20
> > > qe_gpio_set_dedicated() actually just restores a mode that
> > > firmware had set up, including direction (since direction could
> > > be a part of dedicated configuration).
> > >=20
> > > That is, upon GPIO controller registration, we save all registers,
> > > then driver can set up a pin to a GPIO mode via standard API, and
> > > then it can _revert_ a pin to a dedicated function via
> > > qe_gpio_set_dedicated() call. Dedicated function is specified by
> > > the firmware (or board file), we're just restoring it.
> >=20
> > The semantic of the set_dedicated() operation needs to be clearly
> > defined then.
>=20
> It is. We set up a dedicated function that firmware (or board file)
> has configured.

A comment in the source would help.

> > I can live with this behaviour, but it might not be
> > acceptable for everybody.
>=20
> For example?
>=20
> > Your patch requires the firmware to set a pin in dedicated mode at
> > bootup in order to be used later in dedicated mode.
>=20
> Yes. On a PowerPC this is always true: firmware should set up PIO
> config. Linux' board file could fixup the firmware though.

That's not what I meant. What if the hardware requires to pin to be configu=
red in GPIO mode with a fixed value until the SOC-specific driver that will=
 drive the GPIO is loaded ? That's not possible with your API.

Until a SOC peripheral is initialized by its associated Linux driver, the b=
ehaviour of a GPIO pin in dedicated mode will be undefined. The firmware/bo=
ard code will probably want to set the pin as a GPIO output with a fixed va=
lue until the driver initializes the hardware.

> Another option would be to add some argument to the set_dedicated
> call, thus the software could specify arbitrary dedicated
> function (thus no need to save/restore anything). But this would
> be SOC-model specific, thus no driver can use this argument anyway.

Drivers that require dedicated mode are SOC-specific anyway.

> > If, for some
> > reason (driver not loaded, ...), no GPIO user shows up for that
> > pin, it will stay configured in dedicated mode.
>=20
> Yes.
>=20
> > It might be better to set the PAR bit unconditionally in
>=20
> Why it might be better?

Because, as explained a few lines down, the board initialization code will =
be able to configure a pin in a known state (PAR not set) at boot time unti=
l a driver requests the pin to be switched to dedicated mode.

> That way you may set up wrong _GPIO_=20
> mode, because you didn't set PAR bit (when PAR bit set
> DIR/ODR/DAT bits are losing their meanings).
>=20
> > qe_gpio_set_dedicated() instead of restoring its value. That way
> > the board initialization code could just set the DIR, DAT and ODR
> > bits for dedicated mode but still configure the pin in GPIO mode.

=2D-=20
Laurent Pinchart
CSE Semaphore Belgium

Chaussee de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
=46 +32 (2) 387 42 75

--nextPart1295929.rOlv2Qjvov
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkipit0ACgkQ8y9gWxC9vpe+QQCfWz6zaXaM0LxM9zcMnSOJKSx/
2toAnAiBcyCkeicsC6KM84XmvGhLGMqP
=mHXR
-----END PGP SIGNATURE-----

--nextPart1295929.rOlv2Qjvov--
