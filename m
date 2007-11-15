Return-Path: <linux-kernel-owner+w=401wt.eu-S1765717AbXKORRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765717AbXKORRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760559AbXKORQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:16:58 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:50513
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760235AbXKORQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:16:56 -0500
Date: Thu, 15 Nov 2007 09:15:08 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bk@suse.de, khali@linux-fr.org, Boaz Harrosh <bharrosh@panasas.com>,
       James <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.24-rc2-mm1
Message-ID: <20071115171508.GQ6089@one-eyed-alien.net>
Mail-Followup-To: Gabriel C <nix.or.die@googlemail.com>,
	Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, bk@suse.de, khali@linux-fr.org,
	Boaz Harrosh <bharrosh@panasas.com>,
	James <James.Bottomley@HansenPartnership.com>
References: <473A678C.2020507@googlemail.com> <20071114034924.GA26048@kroah.com> <20071114043923.GK6089@one-eyed-alien.net> <473A88B3.3010303@googlemail.com> <20071114082332.GM6089@one-eyed-alien.net> <473ABE7D.6060703@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FcSpk3Icpd/Pbul4"
Content-Disposition: inline
In-Reply-To: <473ABE7D.6060703@googlemail.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2007 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Thu, 15 Nov 2007 09:15:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--FcSpk3Icpd/Pbul4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2007 at 10:23:09AM +0100, Gabriel C wrote:
> Matthew Dharm wrote:
> > On Wed, Nov 14, 2007 at 06:33:39AM +0100, Gabriel C wrote:
> >> Matthew Dharm wrote:
> >>> On Tue, Nov 13, 2007 at 07:49:24PM -0800, Greg KH wrote:
> >>>> Matt, are these the errors you were worried about with the patch we =
were
> >>>> just talking about tha tis in my tree?
> >>> I can't tell from these logs.
> >> There is the dmesg with CONFIG_USB_STORAGE_DEBUG :
> >>
> >> http://194.231.229.228/dmesg-2.6.24-rc2-mm1
> >=20
> > Good news: This isn't the bug Greg was worried about.
> >=20
> > Bad news: Something is seriously strange here.  Note the following from=
 the
> > logs:
> >=20
> > Nov 14 06:07:43 lara [   41.890614] usb-storage: Bulk Status S 0x534253=
55 T 0xd R 0 Stat 0x0
> > Nov 14 06:07:43 lara [   41.890616] usb-storage: -- unexpectedly short =
transfer
> >=20
> > Note the 'R' value of zero -- this is the residue value.  It indicates a
> > complete transfer, and that matches the log lines immediately previous
> > which indicate a 4K transfer which completed properly.
> >=20
> > If residue is zero, then srb->resid should be zero.  Take a look in
> > linux/usb/storage/transport.c in usb_stor_Bulk_transport()
> >=20
> > If srb->resid is zero, then you should NEVER get the "unexpectedly short
> > transfer" message.  Look at usb_stor_invoke_transport() in the same fil=
e.
>=20
> That code got replaced recently but I have no idea about it.
>=20
> ( http://git.kernel.org/?p=3Dlinux/kernel/git/jejb/scsi-misc-2.6.git;a=3D=
shortlog  see the patches from Boaz Harrosh)=20
>=20
> srb->resid got replaced by scsi_get_resid() it I see that right.
>=20
> I'm CC'ing the author , he will know I think.

The replacement looks, to my eye, to be logically correct.  The patch was
pretty clean.

Then again, I haven't looked at what is "under the hood" of the accessor
functions.  Perhaps there is a side-effect somewhere in there?

Perhaps a quick debugging test -- print the value of scsi_get_resid(srb)
just after it's initialized to zero at the top of
usb_stor_invoke_transport(), and then just after the call to
us->transport().

The first print should show a value of zero.  The debug log says that the
transport should have left it as zero.  If it's actually coming back from
us->transport() as a non-zero value, then we'll need to check all the
modifications to usb_stor_Bulk_transport to see where srb->resid is being
changed.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

A:  The most ironic oxymoron wins ...
DP: "Microsoft Works"
A:  Uh, okay, you win.
					-- A.J. & Dust Puppy
User Friendly, 1/18/1998

--FcSpk3Icpd/Pbul4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHPH6cHL9iwnUZqnkRAoqcAJ9hlKyjoi5c5fyyDKhu4tPJxqODgQCdGCaF
eXRF3h87NcS01OBYNrnP9Nc=
=ainC
-----END PGP SIGNATURE-----

--FcSpk3Icpd/Pbul4--
