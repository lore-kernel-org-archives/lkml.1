Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbXFKPDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbXFKPDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbXFKPBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:01:43 -0400
Received: from alnrmhc16.comcast.net ([206.18.177.56]:35888 "EHLO
	alnrmhc16.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbXFKPBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:01:38 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: nigel@nigel.suspend2.net
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: A kexec approach to hibernation
In-Reply-To: <1181533248.17758.55.camel@nigel.suspend2.net> (Nigel
	Cunningham's message of "Mon\, 11 Jun 2007 13\:40\:48 +1000")
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl>
	<87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl>
	<87k5un9l4n.fsf@jbms.ath.cx>
	<1181533248.17758.55.camel@nigel.suspend2.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 11 Jun 2007 11:01:35 -0400
Message-ID: <87abv6o7qo.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham <nigel@nigel.suspend2.net> writes:

[snip]

> Trying to image a system to a fuse filesystem is indeed fundamentally
> broken. The problem is really that we have to make choices about what we
> will and won't support.

> We can have suspending to fuse filesystems, but only if we have
> running userspace (which in turn implies either limiting the image to
> half of memory or compressing a larger image as it's copied so that it
> fits in the remaining space).

> We could have fuse from kexec, but then setting it
> up will be... interesting.

> We can have suspending to a network, but yes, we will want/need to be
> selective about how network connections are handled.

> I agree that the best solution seems to be selective resuming of devices
> for writing the atomic copy. I had a patch to do that long ago, but it
> wasn't a popular idea at the time.

I'd argue that the kexec approach does provide a fairly clean way to
selectively load device drivers --- simply leave out or keep as unloaded
modules the drivers that you don't want to load under the "save" and
"load" kernels.

>> You might claim then that the solution is to simply keep the network
>> driver quiesced or stopped.  But then it is impossible to write the
>> image over the network.  The way to get around this problem is to write
>> the image over the network using a fresh network stack.

> Or teach the driver stack about the difference/reset it. Remember that
> even if you get a fresh network stack, you'll still be getting packets
> for the old stack. Getting a new ip (assuming one is available) won't
> stop other connections getting killed, either because we send resets
> from the kexec'd kernel, or because they timeout looking for the old
> ip.

I could be mistaken, but I think that bringing up the network interface
with a different IP address would prevent it from reseting existing TCP
connections, because it would never receive the packets for those
existing connections.  

> I can see that kexec does provide a nice, clean separation of context
> from that of the kernel being hibernated. But it also deprives us of the
> ability to easily use context in the hibernating kernel such as
> encrypted devices and network connections & configuration. Do you have
> some way in mind that could be utilised to overcome these limitations?

The reason I don't think this need to "re-setup" the context for
suspending should a significant problem in practice is that the setup
required under the "save kernel" should be exactly the same as that
required under the "load kernel".  In particular, it should likely be
possible to re-use exactly the same code (in the initrd/initramfs) to
locate the desired device, and/or perform any necessary device mapper
commands to create the necessary devices.  In the more complex case,
this "setup" might require setting up a network connection and/or
mounting a fuse filesystem.

> [snip]

>> if /boot is not mounted: mount /boot
>> make change
>> umount /boot
>> 
>> If you do it from the "save kernel", you need logic like:
>> mount /dev/boot-device /boot  (no fstab on "save kernel", most likely)
>> make change
>> umount /boot.

> Doesn't the unmount do everything required to sync the data?

Yes it does.  The issue is that some people might not have /boot as a
separate partition, and have it as part of the root filesystem instead,
for instance.  In that case, grub is effectively accessing a dirty
mounted filesystem.  In practice, sync basically takes care of it, but
in theory it shouldn't really be done.

> [snip]

>> I suppose you do that by using more sophisticated logic to atomically
>> copy the pages to their final location after loading them from disk.  In
>> particular, I suppose you must order the page copies carefully to avoid
>> clobbering pages that have not yet been copied.  Seems reasonable.  In
>> that case, there is indeed probably no reason to not use that approach
>> for resuming.

> For Suspend2, I do something similar but simpler. If a page can be
> loaded directly to the final address, do so. The only pages that need
> to be loaded to another address and then restored are those that are
> used by the loading kernel.  We don't have to worry about copying
> pages back in a particular order.

What about the pages that couldn't be loaded back to their final address
because their final address is used by another page that couldn't be
loaded to its final address?  Maybe you have some way to avoid this from
happening, it is just something that occurred to me.  (It isn't
important anyway though.)

I suppose in any case, we can see that resuming would be essentially the
same under the kexec approach as under the current approach.

> [snip]

>> To me, it seems a lot easier to get right than the current approaches.

> But you can't get what you said you wanted - a fully functional system
> with a fully functional userspace isn't possible. You're running a
> different kernel and can't safely mount filesystems that were mounted by
> the first kernel. You'll have to set up a limited userspace that runs
> from some sort of initrd/ramfs and will end up (so far as I can see now)
> with similar restrictions to what we have now with uswsusp or suspend2's
> userui. (Reads more... oh, I see you said that below :>)

Well, it is fully functional in the sense that everything works as
advertised.  I don't know exactly how uswsusp works, but the kexec
approach would have the advantage that you don't have to follow any
special rules like:

 - better not write to the mounted filesystems, or you'll corrupt things

 - better not try to talk to any other processes, because they're frozen
   and you'll just hang

 - better not fork any other processes, because only specially listed
   processes get to run (maybe this isn't the case, I don't know).

Essentially, with the current approaches, you end up with two
independent userspaces anyway, but you just try to run them under a
single kernel (and really it would be preferable to have two independent
kernel spaces as well in the case of certain device drivers, but of
course this cannot be done under one kernel, hence the reason for
kexec).

>> > Moreover, I think it would require some problems that we don't even
>> > anticipate to be solved.
>> 
>> Possibly.  The alternative, though, seems to be to add hack after hack
>> to get certain functionality to work.

> As I argued above, both systems involve some degree of 'hack'. Kexec
> only seems clean until you release that you wanted some of the context
> you just switched away from.

(Perhaps see my comments above.)

Also, perhaps see the reply to Pavel about the need to reserve memory,
which I'm about to write. ;)

Please don't take my comments in this thread too harshly.  I'm not
trying to undermine that work that you and the other hibernate
developers have done.  I just think this kexec approach is an
interesting idea, and I brought it up so that it might get explored.  I
still don't know if it actually makes sense (although I've managed to
mostly convince myself), and discussing it with you and the other
hibernate developers helps in figuring that out.  If I didn't strongly
advocate it, it wouldn't get any thought.

-- 
Jeremy Maitin-Shepard
