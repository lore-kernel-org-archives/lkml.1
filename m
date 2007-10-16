Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbXJPQfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbXJPQfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbXJPQfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:35:12 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:35473
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070AbXJPQfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:35:10 -0400
Date: Tue, 16 Oct 2007 09:33:48 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>,
       bbpetkov@yahoo.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usb+sysfs: duplicate filename 'bInterfaceNumber'
Message-ID: <20071016163348.GB24082@one-eyed-alien.net>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>,
	bbpetkov@yahoo.de,
	Kernel development list <linux-kernel@vger.kernel.org>,
	USB development list <linux-usb-devel@lists.sourceforge.net>
References: <a8e1da0710152222t44de6c8at75d3dd874faf58be@mail.gmail.com> <Pine.LNX.4.44L0.0710161046330.4418-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0710161046330.4418-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2007 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 16 Oct 2007 09:33:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 16, 2007 at 10:55:54AM -0400, Alan Stern wrote:
> On Tue, 16 Oct 2007, Dave Young wrote:
>=20
> > > I finally duplicated this on one of my machines here at boot time, wi=
th
> > > USB built into the kernel.  I'll work tomorrow on tracking this down
> > > further...
> > Hi,
> > I add some printk messages, dump_stack and some others, here is the
> > dmesg dump with debug info(lines begin with "hidave"):
>=20
> Okay, good, the extra printk messages show exactly where the problem=20
> lies.
>=20
> In usb_set_configuration(), each new interfaces is registered and then
> usb_create_sysfs_intf_files() gets called for that interface.  This
> makes sense, because obviously we can't create sysfs files for an
> interface before it is registered.
>=20
> The problem is that during registration drivers get probed, and drivers=
=20
> sometimes call usb_set_interface() from their probe method.  This=20
> routine also calls usb_create_sysfs_intf_files(), and the result is=20
> that the sysfs files get created twice:
>=20
> 	First by usb_set_interface, from the driver probe;
>=20
> 	Then by usb_set_configuration, when registration is
> 	finished.
>=20
> I can think of two possible ways around the problem.  One is to add a=20
> bit to the usb_interface structure, recording whether the sysfs files=20
> have been created.  The other is always to remove the files just before=
=20
> trying to create them.

I haven't looked at this code at all, but neither approach feels right to
me.

How does this work at all?  Even if you load a driver later, wouldn't it
call usb_set_interface(), which would call usb_create_sysfs_intf_files()
and hit the same issue?

Heck, why do both call usb_create_sysfs_intf_file()?  I would guess if
you're *changing* the active configuration you would need to do that, but
why in usb_set_interface() at all?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I say, what are all those naked people doing?
					-- Big client to Stef
User Friendly, 12/14/1997

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHFOfsHL9iwnUZqnkRAt5lAJ49jhKFScgOI9sWpqMWd0xlAFz54QCfUcRL
3UEcJFm5k2VHdelFAWrAJuU=
=JqwZ
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
