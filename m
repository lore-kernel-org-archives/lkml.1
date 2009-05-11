Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZEKOO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZEKOO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZEKOOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:14:49 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57064 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZEKOOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:14:48 -0400
MIME-Version: 1.0
In-Reply-To: <20090511141057.24a5f8ed@lxorguk.ukuu.org.uk>
References: <20090509143742.GA27663@kroah.com> <20090510221901.30c1c5a5@lxorguk.ukuu.org.uk> 
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com> 
	<20090510170016.1e3a4d97@infradead.org> <ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com> 
	<m1pregmkld.fsf@fess.ebiederm.org> <ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com> 
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk> <ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com> 
	<20090511141057.24a5f8ed@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 16:14:28 +0200
Message-ID: <ac3eb2510905110714m5877da13q19b42d1c8565777c@mail.gmail.com>
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

On Mon, May 11, 2009 at 15:10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> And I did, and it's obvious that creating a single file along with the
>> ~10 we already create in /sys, instead of running through /sys or
>> /proc later and reconstruct what we missed, is always, and in every
>> case faster and simpler. It gets rid of a bunch of things we need to
>
> Arjan's numbers for sysfs are 0.06 seconds if I remember the mail
> correctly. That doesn't account for any meaningful speedup.

Sure it does. It is great, and it started a huge effort for many
people to think about the current way to do it. It is very welcome and
it counts a lot, and there is no doubt, that most of the gains we get
today are due to Arjans work in that area.

But he does not use an initramfs, and distros insist to do that. And
that basically means you need to prepare /dev two times, and also prep
the system to cope to bootup without an initramfs, because people, me
included, don't want one on their own boxes. So comparing these
numbers does not really work too well for distros which need to
support so much more than root=/dev/sda2.

>> > - That dumping more crap in kernel without policy and management is a
>> >  good idea
>>
>> What exactly do you find is "crap"? What do you mean with "management"?
>
> Device spaces have user controlled naming rules, user controlled
> permissions, user controlled labelling and the like. That is policy, and
> the administering of that is management.

I see. But that does not change at all. It's just that you can also
bring up the box without the complex management we need to do today.
That is worth so much, in case you need to rescue it. For the real
system nothing will change, but the hard dependency on userspace
starts _after_ the basics of the box are running, at a point you can
probably start fixing things. Today you always need a rescue disk.

> That was one of the things that killed devfs eventually, and it's not a
> problem your proposal or devfs solved.

Oh, that old devfs was killed for many good reasons, sure. The biggest
reason alone to kill it, was the dumb new naming scheme, which broke
everything and got us almost nothing. But it also allowed us to boot
the box without the large dependencies, that part we like to have
back, even today.

>> > - That the other proposals are worse than yours.
>>
>> I also did, in exactly this thread.
>
> Sorry, but I can't find any convincing evidence in the mails. I see
> unhelpful things like you calling Arjan's numbers "made up", despite the
> fact he has spent months working on speeding up boot and has probably the
> most detailed analysis and data sets anyone does.

No, sorry, if that reads that way. I called Eric's "seconds" made-up.
Arjan even mentioned several times in this thread that he does not
complain about the speed of udev. But we can not really compare
Arjan's numbers because he uses a "shortcut", distros can't do for a
general purpose system.

> I think you actually hit the nail on the head a lot earlier when you
> asked Arjan  "How will you solve the dynamic device numbers". Which is
> that we could fix them ....
>
> What is the real underlying concern and what problem should we fix.

Sure, I don't object, but it's far more than disks. You need to change
more subsystems using dynamic numbers. I just stated, that distros can
not go for any static nodes with the current kernel, mainly for
correctness reasons, let alone, that there are many more block devices
to boot from than sd* nodes, which you really don't want to add all of
them statically.

>  We have at least six takes on this
>
> 1.      What problem ?

The reliability on a complex userspace to bring up the basics of a
box. The speed is a nice side-effect, and was the actual motivation.
Just as all of Arjan's async work is motivated by speed, but it also
makes things more efficient, and more flexible.
As mentioned, we create 12.000 files in sysfs, now we just add 210 and
decouple the kernel initial bootup from a complex userspace
dependency, all for the sake of robustness, that is also faster and
very flexible.

> 2.      The udev userspace setup you are using sucks so fix it

I personally wrote most of the "sucking" stuff, so anybody should let
me know, what can be fixed and how.

> 3.      Udev sucks because it can't get the early boot events so has to
> do it the hard way - so queue them

No, that problem is solved by exporting all of it in sysfs already
today. But that does not provide any of the robustness and reliability
gains the kernel-provided nodes do.

> 4.      Udev sucks because it can't get the early boot events so create
> a single table for it to read

Same as 3.), solved by reading today's sysfs.

> 5.      Make the new big block numbers stable

Might be nice to have, but we still can't include all of the possible
block driver names and nodes in initramfs. Distros can just not manage
that, and don't do it today.

> 6.      Recreate devfs in a new but more clean form

I thought we did here. :)

> I don't buy take #1 so I would like to understand
>
> - Why Arjan's systems boot very fast and yours don't

Mine does too. But general purpose systems have different problems to solve.

> - Why you think sysfs changes will help when the stats say its 0.06 of a
>  second and udev is not it appears taking much time anyway

Which sysfs changes?

> - How you think you've solved the devfs problems about persistency and
>  the like and what performance cost that has. That killed devfs in the
>  end.

What problem? It will not be different from what we do today and what
udev does. It will be just more reliable, and the point userspace
dependencies to manage /dev will be later, at a point, you can already
interact with the system.

> But even more I'd like to know wtf we don't just fix the stability of the
> big block device numbering by attaching them to the existing block device
> nodes using minors > 256 which are currently unused in this space.
> Historically it didn't happen because Al Viro jumped up and down about
> the initial proposal but its cleaner than a new devfs and it solves the
> problem for everyone.

Sounds good to me, I have no objections.

> Given most distros use udev sorting udev out is obviously useful but its
> not the 0.06 seconds - its the rest of the time that matters. If a sysfs
> table of devices or buffering the events until it starts sorts that then
> we have a far better model.

Sysfs itself is already information and buffer enough today, we have
all the information we need already, I think. What changes are you
proposing here?

> Udev tackles all the hard stuff - policy in user space, event triggering
> for management etc, that your new devfs simply doesn't address. Fixing
> udev isn't so much fun

Let me know what specifically needs to be fixed, I'll do it right
away, I wrote and maintain most of it, so I should be pretty quick to
act here. I work on it almost every day, and I mostly don't find it
non-funny. :)

>  but it does actually get us something featureful
> and useful that does what people want.

Actually, many people asked for more robustness and less complexity to
bring up a box, not for more special hacks in udev, initramfs, the
boot scripts. That's what we try to solve here, and what we did, from
my perspective.

Thanks,
Kay
