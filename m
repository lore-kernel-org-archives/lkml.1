Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZF3OOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZF3OOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZF3OOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:14:18 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:54149 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbZF3OOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:14:14 -0400
Date: Tue, 30 Jun 2009 16:14:08 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer
 - 3rd try
Message-ID: <20090630161408.123ef1c2@mjolnir.ossman.eu>
In-Reply-To: <200905281028.29256.wolfgang.mues@auerswald.de>
References: <200905261311.45725.wolfgang.mues@auerswald.de>
	<20090527214933.64eafeb5@mjolnir.ossman.eu>
	<200905281028.29256.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-30033-1246371255-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-30033-1246371255-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

(I haven't compared to your latest versions some some of my comments
here might not be relevant for the existing patch)

On Thu, 28 May 2009 10:28:29 +0200
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> Am Mittwoch, 27. Mai 2009 schrieb Pierre Ossman:
> > FYI, the situation that we must avoid to not screw up the assumptions
> > of the filesystems is to end up with a situation like this on the card:
> >
> >  NNNNBNNNOOOO
> >
> >  N =3D block with new data
> >  O =3D block with previous data
> >  B =3D block with damaged data
> >
> > This could in theory happen when the card has some internal problem
> > (e.g. bad flash cell) as well go through these states:
> >
> >  NNNNNNNNOOOO (first write, response to stop command is lost)
> >  NNNNBNNNOOOO (second write, card has internal problem halfway through)
>=20
> For SPI and for any controller which gives you a correct bytes_xfered, th=
is=20
> will only be NNNNNNNNNNNNBOOOOOOOOOOO, because after each transfered sect=
or,=20
> you get a response from the card. So you will not start from the beginnin=
g=20
> any more.
>=20
> If a host controller does not give a correct bytes_xfered, you might end =
in=20
> the scenario you have pointed out, only after exhausting all retries. Thi=
s is=20
> equivalent to a bad of multiple sectors. NBNBNBNB000 =3D=3D NBBBBBBBOOO.
>=20

Hmm... unfortunately this is the norm as I don't think any of the other
drivers provide a proper bytes_xfered. That also means that the verdict
for this patch is NAK for now.

> I think we should code according to the expectations of the user.
> A nonrecoverable write results in a data loss for the user. And I think t=
hat=20
> the wish of the user to get the newly aquired data down to the card has=20
> preceedence against the possible loss of some old data on the card. Remem=
ber=20
> that the "old data" will be unused sectors most of the time. In embedded=
=20
> systems, the user often has no chance to repeat the storage process or ch=
oose=20
> another medium, and the data ist lost if the write to SD card fails.
>=20

The argument was that this method probably worked fine for classical
file systems, but it wrecked havoc if it was done in the log area of
journaling file systems.

I'd like to reiterate that I like the idea and I really think the
kernel should be able to do this. If you can get the VFS and block layer
people to look at this and sign off on it, then we can move forward and
include this. I don't hive time for that particular crusade myself though.

> >
> > I think we can keep the logic where it uses single blocks for the
> > remainder of the request.
>=20
> But this will increase wear leveling problems for the rest of the request.
> And this is for a mean value of 64 sectors!
>=20
> Why on earth should we do this if it is so easy to avoid?
>=20
> As transmission errors are seldom, we get a request splitted out in 3 blo=
cks:=20
> n blocks before the error, one single-block transfer, m blocks after the=
=20
> error. And you almost will not notice a slowdown in transmission speed.
>=20

That code was not written for transmission errors but for media errors.
That means that if block 8 is the bad one, your method (provided
bytex_xfered is useless, which is the norm) means that it will transfer
n blocks, 1 block, n-1 blocks, 1 block, etc. failing every second
attempt until it gets to the actually damaged sector.

> >
> > Perhaps this fix can be moved into its own patch? I think it might keep
> > things cleaner.
>=20
> Which fix? The code was only moved and restructured. No new behaviour.
>=20

Never mind, I wasn't paying proper attention. :)

> > > +
> > > +		/* Wait until card is ready for new data. This information is
> > > +		 * only available in non-SPI mode. In SPI mode, the busy
> > > +		 * handling is done in the SPI driver.
> > > +		 */
> >
> > Strictly speaking it should be handled in all drivers. Some hardware
> > doesn't do it properly though so we have this safeguard.
>=20
> IMHO no driver and framework is doing this correct. It should not be done=
=20
> after a write request, but before the _next_ request. All I have done her=
e=20
> was to add some documentation about SPI, and leave the previous code inta=
ct.

Why on the next request? For performance reasons? The downside to that
is increased complexity. The current system means that the card is
always in an idle state after each request.

(the hardware handling also gets trickier as the host controller also
is kept in some "active" state until busy ends)

> > > +		/* Do retries for all sort of transmission errors */
> > > +		switch (error) {
> > >
> > > -		/*
> > > -		 * A block was successfully transferred.
> > > +		case 0:	/* no error: continue, reset error variables */
> > > +			disable_multi =3D 0;
> > > +			retries =3D 3;
> > > +			break;
> > > +
> > > +		/* Card has not understand command. As we do only send
> > > +		 * valid commands, this must be a transmission error. */
> > > +		case -EPROTO:	/* fall through */
> >
> > This indicates a layering problem. The host driver should not be aware
> > of anything but pure bit errors.
> >
> > Also, this special meaning should be documented in core.h should we
> > decide to keep it.
>=20
> This is not MY error code. EPROTO is send from mmc_spi_writeblock(), and =
I=20
> have listed it here because it is a transmission error.
>=20
> So there seems to be contrary objections: Matt Flemming has requested tha=
t the=20
> exact cause of error is reported by the driver (because otherwise the cal=
ler=20
> will loose information), and you requested to distinguish only between=20
> transmission errors and the rest.
>=20
> Matt Flemming has pointed out that further changes in the code will reque=
st to=20
> get the exact cause of error in the block layer, and that error codes mig=
ht=20
> have interpreted different according to the command class, so IMHO it is=
=20
> better to transport the exact error cause into block.c and do the error=20
> handling here, according to the type of request.
>=20

Right. As much as possible of the result should be parsed by the same
layer that assembles the request. So I think EPROTO should be left out
here and we can look at getting better integration with mmc_spi
responses in another patch.

> >
> > This looks wrong. What happened to the original logic of retrying reads
> > on any error?
>=20
> You mean error codes like EINVAL, ENOMEDIUM, ENODEV?
> I there any sense in retrying non-recoverable errors? Or should I list th=
e=20
> non-recoverable errors inside the switch (and do nothing), and do a retry=
 for=20
> read calls on any other error code, so a new coded driver with a new erro=
r=20
> code will get a read retry (but no write retry!) for this new code regard=
less=20
> of making sense?
>=20

Yes. E.g. some limited hardware might not be able to report a timeout
properly so the driver will report EIO for many types of errors. We
should be robust enough to handle that.

> > And chunk seems unrelated to the rest of the patch.=20
>=20
> Ah... no. This is part of sending the STOP command in case of an error.
> And sending the STOP command in case of an error is needed for a working =
retry=20
> of write commands in SPI mode. Without a STOP command, you can not retry =
a=20
> broken write sequence because the card missed the STOP token.=20
>=20

Ok, "unrelated" might be a bit strong. But it isn't necessary to commit
them together. For the sake of keeping the patch small, I think this
should be a separate patch which will be committed before the retry
changes.

> > Could you also move those modifications to its own patch?
>=20
> Why? It is meaningless without a retry logic for block writes.
>=20

See above. Reduces the size of this patch.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-30033-1246371255-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpKHbQACgkQ7b8eESbyJLgnQgCglA9sXQFwgZ92GcAP/vW+AzRA
PI8An3HLftYYDKWBZT3yvxavs9/Jwgpa
=2KvI
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-30033-1246371255-0001-2--
