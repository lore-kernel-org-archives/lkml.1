Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZD1T5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZD1T5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZD1T5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:57:35 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:57556 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbZD1T5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:57:35 -0400
Date: Tue, 28 Apr 2009 21:57:30 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer
Message-ID: <20090428215730.24fa60c5@mjolnir.ossman.eu>
In-Reply-To: <200904141627.26276.wolfgang.mues@auerswald.de>
References: <200904081155.53173.wolfgang.mues@auerswald.de>
	<20090411001030.56e247c4@mjolnir.ossman.eu>
	<200904141627.26276.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-7862-1240948651-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-7862-1240948651-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Apr 2009 16:27:26 +0200
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> Hello Pierre,
>=20
> Am Samstag, 11. April 2009 schrieb Pierre Ossman:
> > NAK. Writes cannot be retried safely as upper layers rely on the fact
> > that writes fail in a linear manner (a stupid assumption IMO, but
> > that's the way things are).
>=20
> Hmmm.... so this patch has to be improved. I think the (original) code in=
=20
> mmc_blk_issue_rq() is somewhat questionable. As far as I understand the c=
ode,=20
> in the case of an error, brq.data.bytes_xfered is not examined, so the co=
de=20
> starts over from the very first sector of the request, and rereads all=20
> sectors (one after the another).
>=20

That would be a bug, yes.

> So if there is a non-recoverable write error, this code must stop and do =
not=20
> continue to write, right?

Yes.

> But if there is a read error, it is OK and advisable to try to read the r=
est=20
> of the sectors?

We're working on the assumption that reads do not modify any state in
the card, so those should be safe to retry any number of times. :)

> If there is a write error in the middle of a request, is it OK to do
> __blk_end_request(req, 0, brq.data.bytes_xfered);
> and try to retry from this point, and stop if there is a non-recoverable =
write=20
> error?

Afraid not. The reason is that bytes_xfered is not guaranteed to be
exact. It gives you a lower bound, but not an upper one.

> > > +		/* Invalid response. This is most likely a transmission
> > > +		 * error from card to host.
> > > +		 */
> > > +		case -EINVAL:
> >
> > EINVAL is actually "host controller driver/hardware does not support
> > this type of request".
>=20
> "Hardware" is including the hardware of the SD card. This should NEVER ha=
ppen,=20
> because block.c issues only valid requests, which are translated to manda=
tory=20
> commands for the mmc/sd card.
>=20
> So if there is an EINVAL result from the lower layers, it comes from=20
> transmission errors (card has not understand the command, or host has not=
=20
> understand the response).
>=20
> If EINVAL is coming from the HOST CONTROLER, a retry will not harm anyone.
>=20
> I have seen EINVAL results due to spikes on the SD lines.
>=20
> Please correct me if I am wrong.
>=20

You're wrong in that EINVAL should not be sent for any kind of runtime
hardware errors like that. But I might have missed some instances during
reviews, so there might be drivers that give that error message for
things they shouldn't.

=46rom include/mmc/core.h:

 * EINVAL       Request cannot be performed because of restrictions
 *              in hardware and/or the driver

I can't really see a case where EINVAL should be a transient condition,
so there shouldn't be any point retrying a request that gives that
error.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-7862-1240948651-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkn3X6wACgkQ7b8eESbyJLhiWwCeJbBduYrVh67w9f2m+IxHqjmL
S1IAoPh/ov2KrplkuMXRwpbkEJgNbh6b
=bQTe
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-7862-1240948651-0001-2--
