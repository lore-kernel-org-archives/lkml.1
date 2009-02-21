Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZBUP6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZBUP6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 10:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZBUP6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 10:58:07 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50459 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbZBUP6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 10:58:05 -0500
Date: Sat, 21 Feb 2009 16:57:57 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 02/11] sdhci: Add support for bus-specific IO memory
 accessors
Message-ID: <20090221165757.22747648@mjolnir.ossman.eu>
In-Reply-To: <20090213144039.GA19572@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
	<20090206180645.GB11548@oksana.dev.rtsoft.ru>
	<20090208215020.46ca5724@mjolnir.drzeus.cx>
	<20090213144039.GA19572@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-15097-1235231881-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-15097-1235231881-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Feb 2009 17:40:39 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

>=20
> No, on eSDHC the registers are big-endian, 32-bit width, with, for
> example, two 16-bit "logical" registers packed into it.
>=20
> That is,
>=20
>  0x4  0x5 0x6  0x7
> |~~~~~~~~:~~~~~~~~|
> | BLKCNT : BLKSZ  |
> |________:________|
>  31              0
>=20
> ( The register looks wrong, right? BLKSZ should be at 0x4. But imagine
>   that you swapped bytes in this 32 bit register... then the registers
>   and their byte addresses will look normal. )
>=20
> So if we try to issue readw(SDHCI_BLOCK_SIZE), i.e. readw(0x4):
>=20
> - We'll read BLKCNT, while we wanted BLKSZ. This is because the
>   address bits should be translated before we try word or byte
>   reads/writes.
> - On powerpc read{l,w}() convert the read value from little-endian
>   to big-endian byte order, which is wrong for our case (the
>   register is big-endian already).
>=20
> That means that we have to convert address, but we don't want to
> convert the result of read/write ops.
>=20

*cries*

Now this is just incredibly horrible. Why the hell did they try to use
the sdhci interface and then do stupid things like this?

> > > +static inline void sdhci_writel(struct sdhci_host *host, u32 val, in=
t reg)
> > > +{
> > > +	host->writel(host, val, reg);
> > > +}
> >=20
> > Having to override these are worst case scenario
>=20
> Hm. It's not a worst case scenario, it's a normal scenario for
> eSDHC. Why should we treat eSDHC as a second-class citizen?
>=20

Because it's complete and utter crap. Freescale has completely ignored
the basic register interface requirements of the SDHCI spec. Treating
eSDHC as a second-class citizen is generous IMO.

> > as far as I'm
> > concerned, so I'd prefer something like:
> >=20
> > if (!host->ops->writel)
> > 	writel(host->ioaddr + reg, val);
> > else
> > 	host->ops->writel(host, val, reg);
>=20
> Surely the overhead isn't measurable... but why we purposely make
> things worse?
>=20

We can most likely do some micro-optimisation do make the compare part
cheaper, but the point was to avoid a function call for all the
properly implemented controllers out there. We could have a flag so
that it only has to check host->flags, which will most likely be in the
cache anyway.

Overhead for eSDHC is not a concern in my book, what is interesting is
how much this change slows things down for other controllers.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-15097-1235231881-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmgJIgACgkQ7b8eESbyJLgKBACggVet9H6aVhm8mkuYX6pn7irj
axoAoO68JlKdSD1UavnXbJk5Utf4Wv8X
=Sft+
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-15097-1235231881-0001-2--
