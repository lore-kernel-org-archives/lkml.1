Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbZEKQ53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbZEKQ53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZEKQ5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:57:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43461 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751579AbZEKQ5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:57:18 -0400
Date: Mon, 11 May 2009 17:56:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090511175645.2fb8aa49@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510905110928g12545518y143f7f73b3ae494a@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	<20090510170016.1e3a4d97@infradead.org>
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
	<m1pregmkld.fsf@fess.ebiederm.org>
	<ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com>
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk>
	<ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com>
	<20090511141057.24a5f8ed@lxorguk.ukuu.org.uk>
	<ac3eb2510905110714m5877da13q19b42d1c8565777c@mail.gmail.com>
	<20090511165317.3da5326f@lxorguk.ukuu.org.uk>
	<ac3eb2510905110928g12545518y143f7f73b3ae494a@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Once. You may want to move a few bits later. You only need null,
> > zero and console to get started. Thats three fixed device nodes.
> 
> And random, rtc, tty for a custom console, and whatever not, in the
> non-trivial case. Not to mention non-x86 boxes.

Don't need those initially. But they are static so no cost.

> Maybe your root disk shows up after the "create them in final-dev"?

Doesn't matter if it does. I'm going to attach the tmpfs when it
eventually turns up, and in the case where I'm still waiting for it I do
not have a performance problem by definition.

> > On a 1 second budget I can create 3000 device nodes (which should cover
> > most user systems quite adequately) and have 0.9 seconds left to do other
> > work.
> 
> Sure. But that does not solve the problem of missing device nodes or
> the requirement of shipping all possible combinations.

Yes it does. If I have an enumerable list of what is present then I have
lots of time to turn that list into nodes. The only thing that matters is
the list. It doesn't matter if I do

	get static list
	open listener port
	create static list
	go from listener

or

	open listener port (buffered from boot time)
	go from listener

conceptually thats simply

	script <pipe

with the other end of the pipe the kernel. That's pretty fast be it
netlink or whatever.

> > If you have an environment using any of those features then not having
> > that management is not a win - its a bug.
> 
> Bugs happen, it's a reality. We don't needlessly make it harder to
> work around a bug. We have many tings to make the kernel

You are *introducing* a bug, your very design is faulty as it can't do
what users need and what udev can.

> self-contained. With your argument, we should remove all partition
> scanning from the kernel too.

I would really like to do that because it causes untold pain with faulty
devices and also on SAN networks. However we have to have a workable
migration path for it. It's on the long term todo list and as md matures
it becomes the natural path. It also trivially makes partition scanning
asynchronous. Right now the partition code can prevent you booting a
machine with a failed device and in a few cases actually stop you
recovering the media.

> We add the 210 to a separate tmpfs which is the subject of this mail,
> and that supports ACLs just fine. We don't add any device nodes to
> sysfs.

>From user space I can create 30,000 tmpfs nodes a second so why exactly
must the kernel do this for me. In the case you are trying to replace I
have to do the following

	read one message from the kernel (one syscall - could even get
	batching so its < 1)
	parse it (on a 1GHz plus processor with the data in cache)
	make one setfsuid sycall
	make one mknod syscall

> The kernel _is_ the naming policy already, claiming anything different
> is just a lie. If you go and rename /sys/block/sda in the kernel, no
> current udev system will provide a /dev/sda node anymore. It's that
> since forever.

Permissions, selinux labels, acls ? The kernel is none of those, even if
it dabbles a bit more than it should in naming policy. Not everyone btw
slavishly follows the kernel naming policy.

> Udev still has the last say, and can overwrite the kernel policy,

*overwrite* - this is racy. In the secure system case the initial policy
has to have the right labels and security.

> nothing will change, but that does not happen today, and will not
> happen in the future for 98% of the devices.

Even if I agreed with you then the other 2% of the Linux userbase is
millions of devices....

> Just grep in drivers/block/ and estimate how many nodes you will need
> to provide. General purpose distros don't do that today, and don't
> want to go back to the time they needed to that.

I only need to provide those that are present but I must have a way of
getting the list of what is present.

> Naming happens in the kernel for udev systems since forever.
> Permissions happens in udev, and we keep that. All kernel created
> nodes are 0600 root:root. If a device exists in the kernel, we will

0600 root:root isn't sufficient for a secure environment

> see its node, if it goes away the node goes away, just like sysfs, and
> just like we do with udev in /dev today.

That also isn't sufficient for a secure environment.

> It isn't slow. It's just that bootstrapping/re-constructing something
> later can obviously never be faster than doing it when the device is
> created.

But that doesn't imply it has to be done in kernel space ? Caring about
speed is one thing but here are some other speed ups we could trivially do

- turn off memory protection
- stop supporting paging/swap
- require co-operative multi-tasking

Speed is not everything you have to balance speed, flexibility (that
means real flexibility not 'hey it does everything *I* want')

In this case the difference between the kernel creating the node and
userspace turning a message into a node is utterly miniscule. If it isn't
then *that* needs fixing.

Creating the device nodes from the kernel as devfs showed us before isn't
the right interface.

> > "from my perspective" - bingo...
> Sure, what else can I say, I have only my one, just like you have yours.

Yep and the kernel has to be the sum of a lot of perspectives, not "and
screw you" to the 2% who are inconvenient.

> > So I'd like
> >  - my device file system to do SELinux and ACLs (and Tomoyo and ...)
> >  - ability to set labels and security contexts and permissions
> >  - device nodes in one place only
> >  - ability to use security models which take stuff away from root (so
> >   chmodding the sysfs node 000 doesn't cut the mustard)
> >  - a guarantee I can't race the policy application and node creation on
> >   hotplug. In other words the creator sets up its security contexts and
> >   the like then does the node create.
> 
> You can do all that just like you do today, no change at all.

No I can't because you create nodes root:root:0600 with no labels before
I can get at them.

> > sh < /sys/initial-device-list
> 
> And you still need to cope with the races, and bring up the event
> listener before that. This is less reliable and always slower than the

Or buffer the events instead - trivial enough

> kernel provided nodes, besides that your /sys/initial-device-list will

But it is vastly more flexible, handles permissions properly and does
what everyone needs as well as fixing the races.

> > If you put the devices into sysfs I get burger and fries the way you like
> > If you put the list of devices into sysfs I get to decide how I want it.
> 
> Come on, nobody puts nodes in sysfs. Where did you get that idea from?

s/sysfs/tmpfs/
> 
> > We have enough fixed nodes to run a recovery shell in the initrd or boot
> > with init=/bin/sh so the recovery argument doesn't seem to hold water.
> 
> Unless you got a box that does not work anymore, than it's the most
> important thing you can have.

If my box is so busted that the initrd shell (busybox I would
pick), /dev/zero and /dev/console are missing then I am so screwed that I
will need rescue media or to have a "safe mode" alternative kernel boot
already in the grub menu.. which I have even if the distros can't figure
out that one.

> > The performance for reading one sysfs file (even without sysfs
> > optimisation) and writing 3000 device nodes to disk is more than
> > acceptable so if you don't mind I'd prefer my burger with extra onions ;)
> 
> Sure, if I can have a beer too. :)

Well I'm sorry I hardcoded a lack of beer into the serial layer to save a
microsecond, you'll have to go without.... It works for me so clearly
your usage pattern isn't interesting.

See the problem ?

Alan
