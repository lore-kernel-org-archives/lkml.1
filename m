Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZFDTVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZFDTVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZFDTVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:21:08 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:60019 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZFDTVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:21:07 -0400
Date: Thu, 4 Jun 2009 21:21:03 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] mmc: prevent dangling block device from accessing stale
 queues
Message-ID: <20090604212103.33570174@mjolnir.ossman.eu>
In-Reply-To: <4A2819DA.7040603@canonical.com>
References: <4A280BD4.9080908@canonical.com>
	<20090604202900.57f31d6a@mjolnir.ossman.eu>
	<4A2819DA.7040603@canonical.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-10512-1244143267-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-10512-1244143267-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 04 Jun 2009 21:00:42 +0200
Stefan Bader <stefan.bader@canonical.com> wrote:

> Pierre Ossman wrote:
> >=20
> > You seem to have dug a bit further than I've had time for. Do you have
> > anything substantial to back this up:
> >=20
> >> +	/*
> >> +	 * Calling blk_cleanup_queue() would be too soon here. As long as
> >> +	 * the gendisk has a reference to it and is not released we should
> >> +	 * keep the queue. It has been shutdown and will not accept any new
> >> +	 * requests, so that should be safe.
> >> +	 */
> >=20
>=20
> This is mostly based on the debug output. But it seems hard to get around=
 of it=20
> without having a way to increment the refcount of the queue. It is probab=
ly not=20
> the most common use case to remove a device while it is mounted.
> Hm, not sure this is what you wanted to know... On the launchpad report t=
here=20
> are logs which I took with lots of printk's enabled. This shows that afte=
r=20
> resume the queue receives a request from mmcblk0 (which no longer exists)=
 but=20
> uses the same pointer as mmcblk1 which was just created.
>=20

I was hoping you had dug around in the block layer and had some idea
why gendisk requires someone else to keep the queue around for it. Is
it just a simple case of a missing reference, or is there some
architectural problem?

> > This part from the launchpad report also seems incredibly broken:
> >=20
> >> What makes the whole thing a disaster is the fact that the block devic=
e queue objects are taken from a slub cache. Which means on resume, the new=
ly created block device will get the same queue object as the old one, init=
ializes it and
> >> after the tasks have been resumed, ext3 feels obliged to write out the=
 invalidated superblocks (still not sure why it goes for sector 0) which wi=
ll happily migrate to the new block device and cause confusion.
>=20
> I don't think that part is that much broken. It is more a unfortunate res=
ult of=20
> the previous events. Maybe the part of ext3 writing to sector 0 is a bit=
=20
> worrying as I would only expect it to update the mount information which =
I hink=20
> is somewhere around sector 10.
>=20

The incredibly broken part is how requests for the old queue wind up on
the new queue. Such a thing should never be possible.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-10512-1244143267-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkooHqMACgkQ7b8eESbyJLgkdwCfdBfsBFikn59iXGMSosNHDYBX
esIAoMtSPtDDCR3mKz69V9BAAWx1HqCH
=Wo2p
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-10512-1244143267-0001-2--
