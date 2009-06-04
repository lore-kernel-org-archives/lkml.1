Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZFDS3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZFDS3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZFDS3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:29:10 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:57069 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZFDS3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:29:10 -0400
Date: Thu, 4 Jun 2009 20:29:00 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Stefan Bader <stefan.bader@canonical.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] mmc: prevent dangling block device from accessing stale
 queues
Message-ID: <20090604202900.57f31d6a@mjolnir.ossman.eu>
In-Reply-To: <4A280BD4.9080908@canonical.com>
References: <4A280BD4.9080908@canonical.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-10066-1244140147-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-10066-1244140147-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 04 Jun 2009 20:00:52 +0200
Stefan Bader <stefan.bader@canonical.com> wrote:

> Kernel: 2.6.30-rc7 based
> Worked in 2.6.28 (probably only because things went at a different speed)
>=20
> Testcase: Use ext3/ext4 on a SD card partitioned with one primary DOS par=
tition=20
> and leave it mounted while suspend/resume.
>=20
> Result: After resume the partition table of the SD card has been erased.
>=20
> The detailed description can be found at:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/383668
>=20
> In essence the mmc block device frees the generic request queue before th=
e last=20
> user of the gendisk has stopped using it leaving an invalid queue pointer=
 which=20
> get unfortunately re-used before more requests come in for the old device.
>=20
> The bugfix will cause more I/O error messages and might not be the ultima=
te way=20
> things should work, but it prevents data from getting lost.
>=20

You seem to have dug a bit further than I've had time for. Do you have
anything substantial to back this up:

> +	/*
> +	 * Calling blk_cleanup_queue() would be too soon here. As long as
> +	 * the gendisk has a reference to it and is not released we should
> +	 * keep the queue. It has been shutdown and will not accept any new
> +	 * requests, so that should be safe.
> +	 */

?

It would seem that gendisk is making some bad assumptions and needs to
be changed if that is the case.

This part from the launchpad report also seems incredibly broken:

> What makes the whole thing a disaster is the fact that the block device q=
ueue objects are taken from a slub cache. Which means on resume, the newly =
created block device will get the same queue object as the old one, initial=
izes it and
> after the tasks have been resumed, ext3 feels obliged to write out the in=
validated superblocks (still not sure why it goes for sector 0) which will =
happily migrate to the new block device and cause confusion.

Jens, comments?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-10066-1244140147-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkooEnIACgkQ7b8eESbyJLh/LQCgw3EIZBBoKsW505JXQ1O94CZX
ZGcAoPe7A4sMZbDCMMEoRhY0G3vlGoU+
=jWf2
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-10066-1244140147-0001-2--
