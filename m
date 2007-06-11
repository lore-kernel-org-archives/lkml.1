Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbXFKDlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbXFKDlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 23:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763419AbXFKDkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 23:40:51 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:52758 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbXFKDku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 23:40:50 -0400
Subject: Re: A kexec approach to hibernation
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <87k5un9l4n.fsf@jbms.ath.cx>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl>
	 <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl>
	 <87k5un9l4n.fsf@jbms.ath.cx>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EvMCEZAb/h2RRCH0fASm"
Date: Mon, 11 Jun 2007 13:40:48 +1000
Message-Id: <1181533248.17758.55.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EvMCEZAb/h2RRCH0fASm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Fri, 2007-06-01 at 21:54 -0400, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>=20
> >> But kernel threads also rely on userspace, due to e.g. fuse and usermo=
de
> >> helpers.
>=20
> > Yes, I know that and I think these issues are solvable within the curre=
nt
> > approach.
>=20
> It seems like it would be very hard to get writing of an image to a
> fuse filesystem working under the current scheme.
>=20
> Trying to image a system while it is running seems fundamentally broken.
> As another example, I believe currently although devices are "quiesced"
> or stopped while the atomic snapshot is made, they are all then started
> again afterward while the image is written to disk.  As a result, the
> network drivers will continue acking TCP packets that are received after
> the snapshot, but these packets will be lost.

Trying to image a system to a fuse filesystem is indeed fundamentally
broken. The problem is really that we have to make choices about what we
will and won't support.

We can have suspending to fuse filesystems, but only if we have running
userspace (which in turn implies either limiting the image to half of
memory or compressing a larger image as it's copied so that it fits in
the remaining space). We could have fuse from kexec, but then setting it
up will be... interesting.

We can have suspending to a network, but yes, we will want/need to be
selective about how network connections are handled.

I agree that the best solution seems to be selective resuming of devices
for writing the atomic copy. I had a patch to do that long ago, but it
wasn't a popular idea at the time. Since then I've focused more on
minimising the Suspend2 patch, so it's been dropped.

> You might claim then that the solution is to simply keep the network
> driver quiesced or stopped.  But then it is impossible to write the
> image over the network.  The way to get around this problem is to write
> the image over the network using a fresh network stack.

Or teach the driver stack about the difference/reset it. Remember that
even if you get a fresh network stack, you'll still be getting packets
for the old stack. Getting a new ip (assuming one is available) won't
stop other connections getting killed, either because we send resets
from the kexec'd kernel, or because they timeout looking for the old ip.

I can see that kexec does provide a nice, clean separation of context
from that of the kernel being hibernated. But it also deprives us of the
ability to easily use context in the hibernating kernel such as
encrypted devices and network connections & configuration. Do you have
some way in mind that could be utilised to overcome these limitations?

[..]

> Some people get away with it, but fundamentally it is broken to do so.
> (The fact that the current software suspend implementations tell the
> filesystems to sync to disk increases its chances of working.)  You are
> accessing a filesystem that is in an unknown state.  Consider that the
> user might make a change to grub.conf, but the kernel caches the write.
> If the filesystem containing grub.conf is left mounted, the write might
> never reach disk before the system is hibernated.  As a result, when
> grub attempts to read it, it doesn't get the expected data.
>=20
> >> >> This shouldn't be a significant problem in practice.
> >>=20
> >> > I don't agree here.
> >>=20
> >> I think hibernate-script already includes support for modifying grub's
> >> configuration.
>=20
> > Yes.  It does that _before_ the hibernation begins. ;-)
>=20
> Either way, it doesn't make much difference.  Inside of
> hibernate-script, you need logic like:
>=20
> if /boot is not mounted: mount /boot
> make change
> umount /boot
>=20
> If you do it from the "save kernel", you need logic like:
> mount /dev/boot-device /boot  (no fstab on "save kernel", most likely)
> make change
> umount /boot.

Doesn't the unmount do everything required to sync the data?

> [snip]
>=20
> >> As far as I understand it, the swsusp resume path involves the boot
> >> kernel loading the entire image from disk to available memory, then
> >> shutting down all the devices, and copying the memory into place, and
> >> then jumping to the original kernel, which reinitializes devices and
> >> starts tasks running.  This isn't very different from what I was
> >> proposing as the alternative anyway, except that: memory is copied onc=
e,
> >> which is pretty fast, but means that only up to half of the total memo=
ry
> >> can be saved.
>=20
> > No that's not correct.  Actually, during the restore we _can_ load much=
 more
> > than 50% of RAM, everything needed for that is already in place. :-)
>=20
> I suppose you do that by using more sophisticated logic to atomically
> copy the pages to their final location after loading them from disk.  In
> particular, I suppose you must order the page copies carefully to avoid
> clobbering pages that have not yet been copied.  Seems reasonable.  In
> that case, there is indeed probably no reason to not use that approach
> for resuming.

For Suspend2, I do something similar but simpler. If a page can be
loaded directly to the final address, do so. The only pages that need to
be loaded to another address and then restored are those that are used
by the loading kernel. We don't have to worry about copying pages back
in a particular order.

> [snip]
>=20
> >> The whole reason to want to checkpoint filesystems was so that the
> >> original kernel would remain a fully-functional system with a
> >> fully-functional userspace that can continue to access the filesystems
> >> while the hibernate image is being written.  In addition to the lack o=
f
> >> checkpoint support, however, there are a number of other issues that
> >> this would create: Even if you can checkpoint filesystems, you can't
> >> checkpoint the entire world.  The kernel will keep acking network
> >> packets, and userspace as well will send any normal replies.  If a
> >> document was sent off to be printed right before the checkpoint, it
> >> might end up printing while the image is being saved, and then printed
> >> again when the system resumes.
>=20
> > That's correct.
>=20
> >> Fundamentally, I don't think checkpointing is the right answer.  What =
is
> >> desired is a fully functional system with a fully functional userspace
> >> during the image writing.  But we don't want this to be the _same_
> >> system that is actually being imaged.
> >>=20
> >> That is why I think the kexec solution is the elegant solution.
>=20
> > Frankly, I think it's tricky. ;-)
>=20
> To me, it seems a lot easier to get right than the current approaches.

But you can't get what you said you wanted - a fully functional system
with a fully functional userspace isn't possible. You're running a
different kernel and can't safely mount filesystems that were mounted by
the first kernel. You'll have to set up a limited userspace that runs
from some sort of initrd/ramfs and will end up (so far as I can see now)
with similar restrictions to what we have now with uswsusp or suspend2's
userui. (Reads more... oh, I see you said that below :>)

> > Moreover, I think it would require some problems that we don't even
> > anticipate to be solved.
>=20
> Possibly.  The alternative, though, seems to be to add hack after hack
> to get certain functionality to work.

As I argued above, both systems involve some degree of 'hack'. Kexec
only seems clean until you release that you wanted some of the context
you just switched away from.

Regards,

Nigel

--=-EvMCEZAb/h2RRCH0fASm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGbMRAN0y+n1M3mo0RAqzDAKDpH03JZWg6eBiiGFBUsANF+4vtWgCdEFVL
GizC7eIcyHB3ByU3gT05rAg=
=wlBu
-----END PGP SIGNATURE-----

--=-EvMCEZAb/h2RRCH0fASm--

