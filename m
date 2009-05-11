Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZEKQ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZEKQ2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZEKQ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:28:42 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:34069 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbZEKQ2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:28:41 -0400
MIME-Version: 1.0
In-Reply-To: <20090511165317.3da5326f@lxorguk.ukuu.org.uk>
References: <20090509143742.GA27663@kroah.com> <20090510170016.1e3a4d97@infradead.org> 
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com> 
	<m1pregmkld.fsf@fess.ebiederm.org> <ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com> 
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk> <ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com> 
	<20090511141057.24a5f8ed@lxorguk.ukuu.org.uk> <ac3eb2510905110714m5877da13q19b42d1c8565777c@mail.gmail.com> 
	<20090511165317.3da5326f@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 18:28:20 +0200
Message-ID: <ac3eb2510905110928g12545518y143f7f73b3ae494a@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 17:53, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> But he does not use an initramfs, and distros insist to do that. And
>> that basically means you need to prepare /dev two times, and also prep
>
> Once. You may want to move a few bits later. You only need null,
> zero and console to get started. Thats three fixed device nodes.

And random, rtc, tty for a custom console, and whatever not, in the
non-trivial case. Not to mention non-x86 boxes.

> If we have stable block numbers you might need more than one extra if you
> have to search for a UUID/label and it moved from where you cached
> it. Without stable block numbers you can't cache the node but most create
> lots of nodes to go looking. Do I understand that bit right ?

Look at drivers/block/, you need all of the names then, to get it
booting from a non-sd node.

> However you still only create it once as you have zero, console and null
> on the initrd already and do
>
>        mkdir final-dev
>        mount tmpfs
>        create them in final-dev
>        mount root
>        move final-dev
>
> Tell me if I'm going astray here as I want to clearly understand the
> problem.

Maybe your root disk shows up after the "create them in final-dev"?

Initramfs logic works by just waiting for the device node udev creates
asynchronously. When it's there, we go ahead. To make sure you don't
miss it, you have to start udev before you copy the nodes over.

> Another data point: On a fairly typical PC on a single CPU we can do over
> 30,000 mknods per second on tmpfs. I've just benched it. So you can
> create those block nodes very fast indeed.
>
> On a 1 second budget I can create 3000 device nodes (which should cover
> most user systems quite adequately) and have 0.9 seconds left to do other
> work.

Sure. But that does not solve the problem of missing device nodes or
the requirement of shipping all possible combinations.

>> > Device spaces have user controlled naming rules, user controlled
>> > permissions, user controlled labelling and the like. That is policy, and
>> > the administering of that is management.
>>
>> I see. But that does not change at all. It's just that you can also
>> bring up the box without the complex management we need to do today.
>
> If you have an environment using any of those features then not having
> that management is not a win - its a bug.

Bugs happen, it's a reality. We don't needlessly make it harder to
work around a bug. We have many tings to make the kernel
self-contained. With your argument, we should remove all partition
scanning from the kernel too.

>> > That was one of the things that killed devfs eventually, and it's not a
>> > problem your proposal or devfs solved.
>>
>> Oh, that old devfs was killed for many good reasons, sure. The biggest
>> reason alone to kill it, was the dumb new naming scheme, which broke
>
> The "naming scheme" ? It was not the naming scheme but the inability to
> make it do stuff the way users wanted. If the naming scheme had been
> trivially configurable then the distro would simply have shipped a
> different naming scheme.

Yeah, but it did not even create the current names by default. So it
was the main reason distros did not use is.

>> As mentioned, we create 12.000 files in sysfs, now we just add 210 and
>
> setfacl -m u:alan:r /sys/devices/virtual/dmi/id/bios_vendor
> setfacl: /sys/devices/virtual/dmi/id/bios_vendor: Operation not supported
>
> Sysfs doesn't even support per user ACLs which means its not much use for
> tty devices or a lot of other things where you want to give access to a
> piece of hardware to groups of users or use SELinux to control root more
> tightly.

We add the 210 to a separate tmpfs which is the subject of this mail,
and that supports ACLs just fine. We don't add any device nodes to
sysfs.

>> decouple the kernel initial bootup from a complex userspace
>> dependency, all for the sake of robustness, that is also faster and
>> very flexible.
>
> It isn't flexible. You can't set the naming policy, you can't set the
> permissions, you can't control the labelling. It might be a convenient
> way to implement a very specific narrow set up.

The kernel _is_ the naming policy already, claiming anything different
is just a lie. If you go and rename /sys/block/sda in the kernel, no
current udev system will provide a /dev/sda node anymore. It's that
since forever.

Udev still has the last say, and can overwrite the kernel policy,
nothing will change, but that does not happen today, and will not
happen in the future for 98% of the devices.

>> No, that problem is solved by exporting all of it in sysfs already
>> today. But that does not provide any of the robustness and reliability
>> gains the kernel-provided nodes do.
>
> What is robust and reliable about having another set of nodes that an
> existing distro won't know about and existing tools don't know about that
> has permissions and labels that bypass the security as configured by the
> system administrator ????

Which "other" set? There is only one set of names, that is the kernel
provided name. There is no bypass anywhere.

>> > 5.      Make the new big block numbers stable
>>
>> Might be nice to have, but we still can't include all of the possible
>> block driver names and nodes in initramfs. Distros can just not manage
>> that, and don't do it today.
>
> Even if we have to create a lot of nodes it shouldn't be slow - mknod
> syscalls on tmpfs are as we've just established - quite acceptably quick.
> Yes I think stable numbers would be smart.

Just grep in drivers/block/ and estimate how many nodes you will need
to provide. General purpose distros don't do that today, and don't
want to go back to the time they needed to that.

>> Mine does too. But general purpose systems have different problems to solve.
>
> I'm of the opinion your system isn't general purpose - its Kay purpose.
> If it can become truely general purpose and replace or improve udev with
> something far better then great but can it ?

I don't understand this question. What do you mean?

>> What problem?
>
> The problem I've been pointing out all along - security, naming,
> permissions, persistency.

Naming happens in the kernel for udev systems since forever.
Permissions happens in udev, and we keep that. All kernel created
nodes are 0600 root:root. If a device exists in the kernel, we will
see its node, if it goes away the node goes away, just like sysfs, and
just like we do with udev in /dev today.

>> Let me know what specifically needs to be fixed, I'll do it right
>> away, I wrote and maintain most of it, so I should be pretty quick to
>> act here. I work on it almost every day, and I mostly don't find it
>> non-funny. :)
>
> So if you maintain it why is it so slow ? (that isn't an accusation of
> incompetence btw I want to understand the bottlenecks) - what percentage
> is CPU wait, what is I/O wait, wtf are we doing with all that wall time
> and serialized probing ? You've still not provided any useful data on
> timings. If you had four or five pet programmers and were told "fix udev"
> what would you direct them to sort out ? The numbers you've posted
> contain no breakdown. Yes its faster than the old system for your
> specific case but there is no "why" in the data.

It isn't slow. It's just that bootstrapping/re-constructing something
later can obviously never be faster than doing it when the device is
created.

I don't know of any obvious fixes to udev, otherwise I would have
implemented them.

> There isn't any reason it should magically go faster in kernel. We don't
> run the CPU at a different speed in kernel and syscalls are cheap.

Yes, we are in the context of the device, and create the node on top
of many other things we do. At the time userspace runs, we need to
recover all that information, which is not as robust, and not as
cheap. The recover/bootstrap point is a hard blocking point for other
stuff that can run at the same time otherwise.

>> >  but it does actually get us something featureful
>> > and useful that does what people want.
>>
>> Actually, many people asked for more robustness and less complexity to
>> bring up a box, not for more special hacks in udev, initramfs, the
>> boot scripts. That's what we try to solve here, and what we did, from
>> my perspective.
>
> "from my perspective" - bingo...

Sure, what else can I say, I have only my one, just like you have yours.

> Which is the devfs problem - its easy to solve a problem for one
> perspective or one user only. But we'd have an awful lot of devfs clones
> in the kernel if we kept doing that.
>
> So I'd like
>  - my device file system to do SELinux and ACLs (and Tomoyo and ...)
>  - ability to set labels and security contexts and permissions
>  - device nodes in one place only
>  - ability to use security models which take stuff away from root (so
>   chmodding the sysfs node 000 doesn't cut the mustard)
>  - a guarantee I can't race the policy application and node creation on
>   hotplug. In other words the creator sets up its security contexts and
>   the like then does the node create.

You can do all that just like you do today, no change at all.

> Putting device nodes into sysfs can't do most if any of that

Nobody talked about that.

> Putting the data to create those initial device nodes into sysfs *can*
> make it customisable this way. It also means your initrd can be more
> robust because the device creation logic is very very simple.
>
> sh < /sys/initial-device-list

And you still need to cope with the races, and bring up the event
listener before that. This is less reliable and always slower than the
kernel provided nodes, besides that your /sys/initial-device-list will
be the same amount of code we need for the node creation right away,
without any of the other benefits, and will require another
special-case tool we don't use today.

> might be slightly extreme but you need little more when not using fancy
> feature sets. We've just established by benchmarking that the mknod paths
> are fast enough.
>
> It's a question of API and layering
>
> If you put the devices into sysfs I get burger and fries the way you like
> If you put the list of devices into sysfs I get to decide how I want it.

Come on, nobody puts nodes in sysfs. Where did you get that idea from?

> We have enough fixed nodes to run a recovery shell in the initrd or boot
> with init=/bin/sh so the recovery argument doesn't seem to hold water.

Unless you got a box that does not work anymore, than it's the most
important thing you can have.

> The performance for reading one sysfs file (even without sysfs
> optimisation) and writing 3000 device nodes to disk is more than
> acceptable so if you don't mind I'd prefer my burger with extra onions ;)

Sure, if I can have a beer too. :)

Thanks,
Kay
