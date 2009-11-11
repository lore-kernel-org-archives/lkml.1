Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbZKKVtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbZKKVtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759368AbZKKVtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:49:24 -0500
Received: from flounder.pepperfish.net ([87.237.62.181]:56477 "EHLO
	flounder.pepperfish.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759366AbZKKVtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:49:23 -0500
Date: Wed, 11 Nov 2009 21:49:15 +0000
From: Vincent Sanders <vince@simtec.co.uk>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: akpm@linux-foundation.org, lethal@linux-sh.org, dilinger@debian.org,
       linux-kernel@vger.kernel.org, Simtec Linux Team <linux@simtec.co.uk>
Subject: Re: SM501: Implement acceleration features
Message-ID: <20091111214915.GA5182@kyllikki.org>
References: <20091110171810.584051931@fluff.org.uk> <20091111005825.801e180e.krzysztof.h1@wp.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20091111005825.801e180e.krzysztof.h1@wp.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2009 at 12:58:25AM +0100, Krzysztof Helt wrote:
> On Tue, 10 Nov 2009 17:18:10 +0000
> Ben Dooks <ben@simtec.co.uk> wrote:
>=20
> > From: Vincent Sanders <vince@simtec.co.uk>
> >=20
> > This patch provides the acceleration entry points for the SM501
> > framebuffer driver.
> >=20
> > This patch provides the sync, copyarea and fillrect entry points,
> > using the SM501's 2D acceleration engine to perform the operations
> > in-chip rather than across the bus.
> >=20
> > Signed-off-by: Vincent Sanders <vince@simtec.co.uk>
> > Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
> > Signed-off-by: Ben Dooks <ben@simtec.co.uk>
> >=20
> > ---
> >  drivers/video/sm501fb.c    |  238 ++++++++++++++++++++++++++++++++++++=
++++++---
> >  include/linux/sm501-regs.h |    2=20
> >  2 files changed, 226 insertions(+), 14 deletions(-)
> >=20
> > Index: b/drivers/video/sm501fb.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- a/drivers/video/sm501fb.c	2009-11-03 11:19:44.000000000 +0000
> > +++ b/drivers/video/sm501fb.c	2009-11-03 11:19:46.000000000 +0000
>=20

I have snipped all but small amount for context

> > +	/* wait for the 2d engine to be ready */
> > +	while ((count > 0) &&
> > +	       (readl(fbi->regs + SM501_SYSTEM_CONTROL) &
> > +		SM501_SYSCTRL_2D_ENGINE_STATUS) !=3D 0)
> > +		count--;
> > +
>=20
> You may add cpu_relax() inside this loop.
>=20

ok, would need to test this thoroughly as the SM501 has some...odd
behaviours (see later on).

> > +
> > +	if (sm501fb_sync(info))
> > +		return;
> > +
>=20
> Please check if you need to wait for the blit engine before writting
> to any register.  Usually, the values in the bit engine registers
> are shadowed after the engine is started (ie. the blitting operation
> is started) and the next set of values can be written into the regs.

indeed, if it were sane I would agree, it isnt in all circumstances, see la=
ter

>=20
> > +	}
> > +
> > +	/* 2d compare mask */
> > +	writel(0xffffffff, fbi->regs2d + SM501_2D_COLOR_COMPARE_MASK);
> > +
> > +	/* 2d mask */
> > +	writel(0xffffffff, fbi->regs2d + SM501_2D_MASK);
>=20
> All writes above do not use any copyarea specific value. They should
> be done only once in the sm501fb_set_par() function. It is enough to
> initialize the blitting engine when a mode is set (xres/yres and bpp
> values are known then). The only exception is when these values are
> reset by every blit operation.

not reset, but possibly corrupted depending on bus attachment.

>=20
> > +
> > +	/* source and destination x y */
> > +	writel((sx << 16) | sy, fbi->regs2d + SM501_2D_SOURCE);
> > +	writel((dx << 16) | dy, fbi->regs2d + SM501_2D_DESTINATION);
> > +
> > +	/* w/h */
> > +	writel((width << 16) | height, fbi->regs2d + SM501_2D_DIMENSION);
> > +
> > +	/* do area move */
> > +	writel(0x800000cc | rtl, fbi->regs2d + SM501_2D_CONTROL);
> > +}
> > +
>=20
> The same comments apply for the fillrect() method.
>=20

I will explain at the end

> > =20
> >  static struct fb_ops sm501fb_ops_crt =3D {
> >  	.owner		=3D THIS_MODULE,
> > @@ -1256,9 +1424,10 @@ static struct fb_ops sm501fb_ops_crt =3D {
> >  	.fb_setcolreg	=3D sm501fb_setcolreg,
> >  	.fb_pan_display	=3D sm501fb_pan_crt,
> >  	.fb_cursor	=3D sm501fb_cursor,
> > -	.fb_fillrect	=3D cfb_fillrect,
> > -	.fb_copyarea	=3D cfb_copyarea,
> > +	.fb_fillrect	=3D sm501fb_fillrect,
> > +	.fb_copyarea	=3D sm501fb_copyarea,
> >  	.fb_imageblit	=3D cfb_imageblit,
> > +	.fb_sync	=3D sm501fb_sync,
> >  };
> > =20
>=20
> You may want to try if setting the info->flags bit FBINFO_READS_FAST
> gives you a faster scrolling on the fb device. This flags says that
> you prefer to use the copyarea function over the imageblit function
> for scrolling. The latter is not accelerated in this driver.

thanks! will try that.

To clarify the idiocy and nasty issues with the SM501/2 range (this
isnt for the weak stomached) :-(

The Silicon Motion SM501 has three revisions (A, B and C. Revision C
is confusingly renamed as SM502 but keeps the 501 identifiers) it
also has the unusual ability to be connected to the host both by PCI
and local 32bit parallel bus in several flavours, Also in both bus mastering
and non bus mastering modes.

Revisions prior to C had a number of subtle bugs related to their
external memory interfaces and the interaction with interrupts which
means posted writes and reads of the irq status register may not
actually match up with reality. There are additional constraints on
clock domains and internal bus configurations which we already address
elsewhere in the driver.

The *only* reliable way to be sure if any of the asynchronous engines
are ready to use is to poll the 2D engine status bit in the system
controller register (not the one in the 2d engine itself!) and if its
in local bus mode be sure your bus timings are conservative enough not
to lock the device up solid with it driving i/o lines against the CPU
(not that the magic smoke escapes or anything :-(. Hopefully this
explains why we wait explicitly for the device as we do (Oh and
revision C fixes those problems but introduces others because of its
weaker bus drive)

Next I discovered that although the 2d engine nominally has a shadowed
register set, what actually happens if you attempt an operation while
the engine is busy is: play a guessing game as to whether the device
will lock up solid, corrupt both requests or work fine.

Finally the revision C introduces an amusing issue where certain
operations followed by certain other operations cause register
corruption. To avoid this issue I specifically program all registers
to do with an operation each time. There is a compromise between the
overhead of a couple of register writes against *much* less complexity
than either the conditional execution depending of current device
configuration or working out which operations may follow which and
fixing up as appropriate (I have coded both these approaches and it was
ugly in comparison).

Thankyou for your review, I hope I explained why I have dones some of
these seemingly odd things. If you think there is another approach I
should take based on this explanation please let me know.

--=20
Vincent Sanders
Simtec Electronics

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFK+zFaiUwwPOvjHvURAoKhAKCYhUER5JE+7XpitOGBf8cAfRVuJQCginzz
Os+IQP3kCQLBUIrOsLJ5HEo=
=GglU
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
