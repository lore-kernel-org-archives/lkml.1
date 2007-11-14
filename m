Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbXKNIXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbXKNIXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 03:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbXKNIXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 03:23:47 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:52523
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbXKNIXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:23:46 -0500
Date: Wed, 14 Nov 2007 00:23:32 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bk@suse.de, khali@linux-fr.org
Subject: Re: 2.6.24-rc2-mm1
Message-ID: <20071114082332.GM6089@one-eyed-alien.net>
Mail-Followup-To: Gabriel C <nix.or.die@googlemail.com>,
	Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, bk@suse.de, khali@linux-fr.org
References: <473A678C.2020507@googlemail.com> <20071114034924.GA26048@kroah.com> <20071114043923.GK6089@one-eyed-alien.net> <473A88B3.3010303@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M2Pxvdb9QxnGd/3e"
Content-Disposition: inline
In-Reply-To: <473A88B3.3010303@googlemail.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2007 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Wed, 14 Nov 2007 00:23:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--M2Pxvdb9QxnGd/3e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2007 at 06:33:39AM +0100, Gabriel C wrote:
> Matthew Dharm wrote:
> > On Tue, Nov 13, 2007 at 07:49:24PM -0800, Greg KH wrote:
> >> Matt, are these the errors you were worried about with the patch we we=
re
> >> just talking about tha tis in my tree?
> >=20
> > I can't tell from these logs.
>=20
> There is the dmesg with CONFIG_USB_STORAGE_DEBUG :
>=20
> http://194.231.229.228/dmesg-2.6.24-rc2-mm1

Good news: This isn't the bug Greg was worried about.

Bad news: Something is seriously strange here.  Note the following from the
logs:

Nov 14 06:07:43 lara [   41.890614] usb-storage: Bulk Status S 0x53425355 T=
 0xd R 0 Stat 0x0
Nov 14 06:07:43 lara [   41.890616] usb-storage: -- unexpectedly short tran=
sfer

Note the 'R' value of zero -- this is the residue value.  It indicates a
complete transfer, and that matches the log lines immediately previous
which indicate a 4K transfer which completed properly.

If residue is zero, then srb->resid should be zero.  Take a look in
linux/usb/storage/transport.c in usb_stor_Bulk_transport()

If srb->resid is zero, then you should NEVER get the "unexpectedly short
transfer" message.  Look at usb_stor_invoke_transport() in the same file.

In fact, every transfer I look at shows this error.  I didn't exhaustivly
check every single one in the log, but a quick scan suggests that they all
are bogus; good transfer, CSW residue of 0, and "unexpectedly short"
message.

Maybe I'm too tired at this hour, but I just don't see how this is
possible.  Then again, I'm looking at 2.6.22 codebase (it's what I have
handy).

Hrm... does this tree have the "srb accessor" patches in it?  I'm wondering
if somewhere the init srb->resid to 0 before invoking the transport got
lost....

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Somebody call an exorcist!
					-- Dust Puppy
User Friendly, 5/16/1998

--M2Pxvdb9QxnGd/3e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHOrCEHL9iwnUZqnkRAgllAJ9k27+ieWtBHKw88yQM622Qaq8GXwCcCkyb
GmzXw+Zq4nSafhWCv/+HHIU=
=VdL7
-----END PGP SIGNATURE-----

--M2Pxvdb9QxnGd/3e--
