Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbYDAPxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbYDAPxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYDAPxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:53:31 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:41198
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447AbYDAPxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:53:30 -0400
Date: Tue, 1 Apr 2008 08:53:23 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Sergey Dolgov <solkaa@gmail.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: usb-storage, error reading the last 8 sectors, regression in 2.6.25-rc7
Message-ID: <20080401155323.GB31604@one-eyed-alien.net>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>, Sergey Dolgov <solkaa@gmail.com>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20080401143420.GB20920@one-eyed-alien.net> <Pine.LNX.4.44L0.0804011040260.4253-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0804011040260.4253-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 01 Apr 2008 08:53:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 01, 2008 at 10:42:51AM -0400, Alan Stern wrote:
> On Tue, 1 Apr 2008, Matthew Dharm wrote:
>=20
> > On Tue, Apr 01, 2008 at 10:28:52AM -0400, Alan Stern wrote:
> > > On Tue, 1 Apr 2008, Oliver Neukum wrote:
> > >=20
> > > > Am Dienstag, 1. April 2008 03:58:31 schrieb Alan Stern:
> > > > > Nevertheless, it's clear that the problem has nothing to do with =
the=20
> > > > > USB stack. =A0The real source of the problem lies in the device i=
tself,=20
> > > > > for reporting a bogus error when in fact nothing went wrong. =A0T=
hat may=20
> > > > > also explain why you don't always see the problem -- sometimes th=
e=20
> > > > > device works the way it ought to.
> > > >=20
> > > > Reminds me of the devices that can read the last sector but only if=
 it is read
> > > > by itself. Do you reckon this device may have the "opposite" quirk?
> > >=20
> > > Could be something like that.
> >=20
> > Didn't I see some SCSI patches go by to implement exactly this change?
> > That is, only read the last sector by itself?
>=20
> You are getting the two problems mixed up.  The older problem, which
> the SCSI patche addressed, was that the device would fail when
> accessing the last sector unless the transfer was 1 sector long.
>=20
> This problem is different.  When performing an 8-sector read that=20
> includes the last sector, the device succeeds.  When performing a=20
> 7-sector read starting from the same place (so not including the last=20
> sector), the device fails.

I thought the patch I saw unconditionally re-wrote any access that included
the last sector into two accesses -- everything but the last sector, and
the last sector.

In other words, the patch attempted to avoid problems on devices that
couldn't access the last sector unless the transfer was 1 sector long by
ONLY accessing the last sector in a single transfer.

If I'm remembering correctly, that would explain the behavior change which
lead to the exposure of the bad behavior of this new device.  This new
device worked with the old code, but not with the new code.

Basically, by avoiding a common error condition in device firmware, we've
found a device that has exactly the opposite bug.

Presuming someone can find the patch in the archive, reverting it would
produce a good test case; it should restore this device to a working state.
Maybe we need some auto-detect logic here; try the new way, if it fails,
revert to the old behavior.  That's probably the safe order, as a lot of
the devices with the more 'classic' bug just die completely, whereas this
one appears to be recoverable.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Sir, for the hundreth time, we do NOT carry 600-round boxes of belt-fed=20
suction darts!
					-- Salesperson to Greg
User Friendly, 12/30/1997

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH8lpzHL9iwnUZqnkRAvJrAJwI7eHZPMaQER2fvaRG8yBcecmSuACgme9j
xcAoq/8QjVzyjLbzrq9BRUI=
=y/B1
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
