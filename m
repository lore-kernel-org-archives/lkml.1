Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbXEURwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbXEURwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbXEURvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:51:55 -0400
Received: from mx33.mail.ru ([194.67.23.194]:8537 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329AbXEURvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:51:54 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Date: Mon, 21 May 2007 21:51:28 +0400
User-Agent: KMail/1.9.6
Cc: Uwe Bugla <uwe.bugla@gmx.de>, Ken Chen <kenchen@google.com>,
       Ray Lee <ray-lk@madrabbit.org>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <464F42F3.1080300@madrabbit.org> <200705211851.00187.uwe.bugla@gmx.de> <1179767466.3320.48.camel@lov.localdomain>
In-Reply-To: <1179767466.3320.48.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart56183359.CUtqt26RI9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705212151.44667.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart56183359.CUtqt26RI9
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 21 May 2007, Kay Sievers wrote:
> On Mon, 2007-05-21 at 18:50 +0200, Uwe Bugla wrote:
> > Am Montag, 21. Mai 2007 18:37 schrieben Sie:
> > > On 5/21/07, Ken Chen <kenchen@google.com> wrote:
> > > > yes and no. in that commit, I automatically create n+1 device when
> > > > loop device n is created, allergically was tested to be fine with
> > > > casual usage of "losetup" and "mount -o loop".  However, there is a
> > > > bug in that commit when loop.c was compiled as a module.  And when =
Al
> > > > fixed it, he also removed that magic "n+1" trick.
> > > >
> > > > Nevertheless, yes, I'm guilty of introducing the new behavior.
> > >
> > > The easiest way is to reinstate max_loop and create "max_loop" device
> > > up front at module load time.  However, that will lose all the "fancy
> > > on-demand device instantiation feature".
> > >
> > > So I propose we do the following:
> > >
> > > 1. have the module honor "max_loop" parameter and create that many
> > > device upfront on module load (max_loop will also be a hard max) iff
> > > user specify the parameter.
> > > 2. if max_loop is not specified, default create 8 loop device.  User
> > > can extent more loop device by create device node themselves and have
> > > kernel automatically instantiate loop device on-demand.
> >
> > Sorry, Ken:
> > My question on point 2 would be: Does "User can extent more loop device
> > by create device node themselves and......." correspond or conflict to
> > working with udev?
>
> Udev shouldn't care if the kernel tells udev about the new device, and
> the node with the correct dev_t is already there, it will leave it as it
> is, and only apply the configured user,group,mode values.
>
> The loop tools should probably extended to be able to request new
> devices from the kernel in a different way than open().
>

Except as already mentioned it will introduce races between tool requesting=
=20
new device and udev creating new node. We already had this with raw devices=
=2E=20
My comparison with /dev/pts was incorrect because it is using internal=20
filesystem that creates devices synchronously.

May be all such cases has to be converted to use common file system.

mount -t nodefs -o device=3Dpts none /dev/pts
mount -t nodefs -o device=3Dloop none /dev/loop

--nextPart56183359.CUtqt26RI9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGUdwhR6LMutpd94wRAgtYAJ9eFHViNa8sZSd9jdfaiSGgUBRGYgCgq6BI
v5VS/ircspcexdIzz4t7WoI=
=+J1r
-----END PGP SIGNATURE-----

--nextPart56183359.CUtqt26RI9--
