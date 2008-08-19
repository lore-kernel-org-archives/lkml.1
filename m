Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYHSJ0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYHSJ0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYHSJ0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:26:38 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:36227 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354AbYHSJ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:26:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIFAFwtqkjCTsYx/2dsb2JhbACBYrMrgVg
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 1/3] gpiolib: make gpio_to_chip() public
Date: Tue, 19 Aug 2008 11:26:28 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, "Greg Kroah-Hartman" <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, linux-kernel@vger.kernel.org,
       Timur Tabi <timur@freescale.com>
References: <20080808161717.GA19095@polina.dev.rtsoft.ru> <200808181644.45480.laurentp@cse-semaphore.com> <20080818153300.GA10163@oksana.dev.rtsoft.ru>
In-Reply-To: <20080818153300.GA10163@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1695237.BSJEQFJojn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808191126.33133.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1695237.BSJEQFJojn
Content-Type: text/plain;
  charset="windows-1251"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 18 August 2008, Anton Vorontsov wrote:
> On Mon, Aug 18, 2008 at 04:44:36PM +0200, Laurent Pinchart wrote:
> > On Monday 18 August 2008, Anton Vorontsov wrote:
> > > On Mon, Aug 18, 2008 at 03:58:46PM +0200, Laurent Pinchart wrote:
> > > [...]
> > > > > Not exactly. But you can do this way, if you need to preserve
> > > > > a direction. What I did is a bit different though.
> > > > >=20
> > > > > qe_gpio_set_dedicated() actually just restores a mode that
> > > > > firmware had set up, including direction (since direction could
> > > > > be a part of dedicated configuration).
> > > > >=20
> > > > > That is, upon GPIO controller registration, we save all registers,
> > > > > then driver can set up a pin to a GPIO mode via standard API, and
> > > > > then it can _revert_ a pin to a dedicated function via
> > > > > qe_gpio_set_dedicated() call. Dedicated function is specified by
> > > > > the firmware (or board file), we're just restoring it.
> > > >=20
> > > > The semantic of the set_dedicated() operation needs to be clearly
> > > > defined then.
> > >=20
> > > It is. We set up a dedicated function that firmware (or board file)
> > > has configured.
> >=20
> > A comment in the source would help.
> >=20
> > > > I can live with this behaviour, but it might not be
> > > > acceptable for everybody.
> > >=20
> > > For example?
> > >=20
> > > > Your patch requires the firmware to set a pin in dedicated mode at
> > > > bootup in order to be used later in dedicated mode.
> > >=20
> > > Yes. On a PowerPC this is always true: firmware should set up PIO
> > > config. Linux' board file could fixup the firmware though.
> >=20
> > That's not what I meant. What if the hardware requires to pin to be
> > configured in GPIO mode with a fixed value until the SOC-specific
> > driver that will drive the GPIO is loaded ? That's not possible
> > with your API.
>=20
> Yes, this isn't possible with this API. Because you can do this
> with standard GPIO API! ;-)
>=20
> Just call gpio_direction_*() in the board file, before probing the
> hardware.

You'd have to do that after the GPIO drivers saved the pin registers.

> > Until a SOC peripheral is initialized by its associated Linux driver,
> > the behaviour of a GPIO pin in dedicated mode will be undefined.
>=20
> Huh?! Then all current software is simply broken: we're setting pinmux
> config _prior_ to controller initialization.

Undefined behaviour doesn't mean broken behaviour :-) Signals coming from S=
OC peripherals are mostly undefined until the peripheral is initialized. Fo=
r most hardware that doesn't matter much, but it might in some cases. For i=
nstance the state of the RTS signal on a serial port probably doesn't matte=
r before we start serial communication, but some boards might require that =
RTS is deasserted before the controller is initialized. We can just ignore =
the issue for now and wait until it bites us.

> > The firmware/board code will probably want to set the pin as a GPIO
> > output with a fixed value until the driver initializes the hardware.
>=20
> Probably? Do you have any such hardware?

Nope. I was referring to the hardware such as in the above example.

> > > Another option would be to add some argument to the set_dedicated
> > > call, thus the software could specify arbitrary dedicated
> > > function (thus no need to save/restore anything). But this would
> > > be SOC-model specific, thus no driver can use this argument anyway.
> >=20
> > Drivers that require dedicated mode are SOC-specific anyway.
>=20
> I didn't say "SOC-specific". I said "SOC-model specific", which
> means that the driver would be not portable even across QE chips
> (i.e. MPC8323 vs. MPC8360, you can assume that the "CLK12" function
> is having same PAR/ODR/DAT/DIR bits).

If I'm not mistaken, the PAR bit is used to select between GPIO and dedicat=
ed mode by definition. It should be safe to assume that setting a GPIO in d=
edicated mode requires the PAR bit to be set. But as I stated above, we can=
 ignore that for now until a hardware use case comes up.

> > > > If, for some
> > > > reason (driver not loaded, ...), no GPIO user shows up for that
> > > > pin, it will stay configured in dedicated mode.
> > >=20
> > > Yes.
> > >=20
> > > > It might be better to set the PAR bit unconditionally in
> > >=20
> > > Why it might be better?
> >=20
> > Because, as explained a few lines down, the board initialization code
> > will be able to configure a pin in a known state (PAR not set) at boot
> > time until a driver requests the pin to be switched to dedicated mode.
>=20
> You can do this as I described above. But prior to this, yes, you have
> to configure the pins and let Linux save these values. There is no other
> way to pass this information, unfortunately.

Ok.

I started implementing CPM2 dedicated mode support to be used in the CPM UA=
RT driver for RTS/CTS flow control, and soon realized there was a show stop=
per. The CPM UART driver is mostly CPM1/CPM2 agnostic. I can't use a functi=
on such as cpm2_gpio32_set_dedicated, as that wouldn't work on a CPM1 (at l=
east not on all its ports). I could call the right function depending on wh=
ich port the GPIO is on, but that's really hackish and would defeat the pur=
pose of using GPIOs. What we really need there is a set_dedicated/set_optio=
n/set_whatever function in the GPIO API :-/

=2D-=20
Laurent Pinchart
CSE Semaphore Belgium

Chaussee de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
=46 +32 (2) 387 42 75

--nextPart1695237.BSJEQFJojn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkiqkckACgkQ8y9gWxC9vpceWACfUW3rS3oHtefEa4ZPz+2NGjbE
1mAAn37NoerqMJpKp3gFQlrhHHwDO2sN
=tyTF
-----END PGP SIGNATURE-----

--nextPart1695237.BSJEQFJojn--
