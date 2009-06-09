Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbZFISIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbZFISIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZFISIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:08:10 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:40002 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbZFISIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:08:09 -0400
Date: Tue, 9 Jun 2009 20:07:50 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "David Brownell" <david-b@pacbell.net>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Message-ID: <20090609200750.2fa38dfe@mjolnir.ossman.eu>
In-Reply-To: <200905251659.17396.wolfgang.mues@auerswald.de>
References: <200905250243.46984.david-b@pacbell.net>
	<200905251218.18262.wolfgang.mues@auerswald.de>
	<20090525135012.13be624c@mjolnir.ossman.eu>
	<200905251659.17396.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-13902-1244570888-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-13902-1244570888-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 25 May 2009 16:59:17 +0200
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> Pierre,
>=20
> Am Montag, 25. Mai 2009 schrieb Pierre Ossman:
> > I don't remember why
> > mmc_spi is looking at responses to begin with.
>=20
> Because responses are very different.
>=20
> First of all, responses in SD mode and SPI mode are different.
>=20

MMC and SD aren't identical either, but we don't delegate that to the
host drivers.

> Second, responses in SD mode are CRC-7 protected, so that it is easy to c=
heck=20
> for transmission errors.
>=20
> SPI mode responses (R1...) are without any CRC.
>=20

This however is more relevant. But OTOH, I don't think mmc_spi has a
better idea if the status can be trusted or not than a higher layer.

> Third, if you have SD mode, you use a hardware host controller which mana=
ges=20
> all command/data/response actions, and what you typically get is the cont=
ent=20
> of the status register of the host controller (which is different from the
> error code of the SD card).
>=20
> So it is very natural that every host controller driver mapps the respons=
es=20
> from the host controller to a common representation (=3D=3D error code). =
The=20
> error codes with special meanings for MMC/SD are summed up in mmc/core.h .
>=20

But the other drivers don't attempt to interpret the response from the
card. They just give the response back up and let the next layer deal
with it.

> The SPI host driver is a recent addition to the linux kernel, and the fac=
t=20
> that SPI responses are not CRC-protected was not accounted for in the cod=
e.
>=20
> As it makes no sense to code the retry logic in every driver, the prefere=
d way=20
> is to code the retry logic in block.c. The non-SPI-mode-drivers will prof=
it=20
> from this logic, because they are getting retries for EILSEQ (CRC error) =
and
> ETIMEDOUT (card has not understand the command).

Indeed. But I don't like the fact that we're hiding interpretation of
responses down in the driver. It should be up to the layer issuing the
MMC request how the response should be interpreted.

But that's an issue that can be left for another day...

>=20
> The biggest problem in the error codes is that EINVAL is used by the SPI=
=20
> driver both for recoverable and for non-recoverable errors, which has to =
be=20
> splitted IMHO.
>=20

Indeed. I'll queue up the patch.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-13902-1244570888-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoupQYACgkQ7b8eESbyJLhHSwCfaHYqiQf8KqScYKerKKqSzy7T
4WUAoJFUIYuHHEAlVn4kYkR68QB4xuDv
=QJ5X
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-13902-1244570888-0001-2--
