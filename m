Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZEKPAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZEKPAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZEKPAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:00:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46414 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbZEKPAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:00:09 -0400
MIME-Version: 1.0
In-Reply-To: <20090511064904.3e1d6c34@infradead.org>
References: <20090509143742.GA27663@kroah.com> <20090510170016.1e3a4d97@infradead.org> 
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com> 
	<m1pregmkld.fsf@fess.ebiederm.org> <ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com> 
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk> <ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com> 
	<20090511060528.31e0f20c@infradead.org> <ac3eb2510905110628y65c9a2b8s576bfa4f17ef52e1@mail.gmail.com> 
	<20090511064904.3e1d6c34@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 16:59:47 +0200
Message-ID: <ac3eb2510905110759v296ff487paa59d7a7539e9e01@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 15:49, Arjan van de Ven <arjan@infradead.org> wrote:
>> On Mon, May 11, 2009 at 15:05, Arjan van de Ven <arjan@infradead.org>
>> wrote:
>> > On Mon, 11 May 2009 13:34:52 +0200
>> > Kay Sievers <kay.sievers@vrfy.org> wrote:
>> >>
>> >> > - That the other proposals are worse than yours.
>> >>
>> >> I also did, in exactly this thread.
>> >
>> > no you have not. But I'd like you to ;)
>>
>> I did. It's reliability, the race for new devices coming in when you
>> start reading your list and finishing creating the nodes. You will
>> miss these device, which we don't want to work around with another
>> hack. You will have to bring up the machinery that listens to events
>> for new devices, before synthesizing the stuff that is already there.
>
> and this is hard because ?

No, I just object to the "it's free" statement. :)

> (and you are right, while this is not an issue without initramfs,
> because the kernel doesn't return until all probing activity has
> finished, it might be a problem for initramfs, because that executes
> before all the probing is done. But it's not a hard issue, just a
> sequencing issue)

Right, and we would like to get the freedom of doing anything in
parallel to that step. If it's done race-free, it's not really cheap
anymore.

> I personally don't think the 0.06 seconds are a problem, but I got the
> impression that you were trying to optimize this path with your patch.
> (After all, it is pretty much the cost of the thing you're optimizing)

Nah, I wanted to de-couple userspace dependencies to get a working
/dev, so userspace can go ahead and do as many tasks as possible, as
early as possible, without the restrictions to wait for another
process to synthesize a working /dev first. We are optimizing for
robustness and simplicity, and not for speed, that's just the
side-effect, and what motivated us.

>> And the main point is the reliability, let all the weird speed
>> arguments and made-up numbers alone.
>
> I'm sorry, but you're either trying to be obnoxious or telling us your
> own numbers are made up. Since I doubt the former, and neither my nor
> Erics numbers are made up, I'll assume the later...

Sorry, if that was reading wrong. I meant replies like:

"I think your justification for this ``feature'' is strongly flawed.
You claim to save 2 seconds of a process that should take less than a
tenth of a second. You claim flexibility while removing user space
from the policy loop. You claim speed increases when comparing to a
dog slow non-tuned implementation."

I don't even know from what we could save 2 full seconds today.

>> You depend on whatever rather
>> complex userspace to bring your box. And people complain about that
>> for years, and for good reason.
>
> prior to sysfs people depended on MAKEDEV (and the fact that they chose
> to not use tmpfs but a real fs for /dev) for this. It's not that much
> different today. Using tmpfs for /dev is a local choice. It's fully
> optional in fact.. and that's a good thing.

Sure, that's good.

>> On my box we create 12152 files in /sys on bootup, and with devtmps
>> the same code creates 218 simple device nodes with the same call, and
>> this makes bootup reliable, more self-contained, and as a nice side
>> effect makes it faster. Just focus on init=/bin/sh, if you want to see
>> the reason behind all this.
>
> init=/bin/sh is an interesting subcase, sure. It means in the "before
> your patch" scenario that people get the "real /dev directory", and not
> the tmpfs overmount. It's a distro choice what to put there. Fedora puts
> nothing there, Moblin puts only all static-allocated device nodes there.
> I don't know what openSuSE puts there.

Usually it contained a few nodes, but I've seen an empty /dev too.

> People who use init=/bin/sh don't expect a full system, yet they expect
> a certain amount of system that allows them to do system recovery I
> suppose. I don't consider the delta between "static nodes only" and
> "devshmfs" to be significant here. In a recovery scenario, if you WANT
> something dynamic you start the thing to do dynamic by hand. Otherwise
> you want something predictable.

I think it fits nicely to sysfs, and solves the init=/bin/sh problem
quit nicely, and is more "predictable" than the usual /dev content, in
the light of the current state of dynamic numbers.

It's not worth too much to have something predictably non-working. :)

>> We focused on the speed here, because we want to solve the initramfs
>> problem, a problem you solved by getting rid of it entirely, which is
>> what I do on all my own boxes too, but what the distro guys
>> never want to accept.
>
> Now you've lost me. I am missing the link between this and initramfs
> entirely. How you do /dev has extremely little to do with initramfs or
> not. Sure you need the rootfs device node before you can mount root for
> the initramfs case, just like you need the rootfs device node before
> you can fsck it in the non-initramfs case.

Yeah, and random tools you want to start as early as possible, you
need to delay until /dev is working.

> In both cases you want all
> the device nodes as fast as you can,

Which can never be faster than using devtmpfs. :)

> but within the system policy of
> ownership, permissions, selinux contexts, tmpfs mount options etc.

That's what udev still does, and will continue to do so. It's just
de-coupled from bringing up the mandatory basics of the system. All
the policy still lives in udev as it does today, it can just be
applied in the background unlike today.

> And Eric showed that that is a 0.06 second thing.. not a big deal in
> the grand scheme of things, even if you want to boot the whole system
> in 2 seconds like we do.

Yeah, and I object to just another userspace hack which makes things
even more complex as they already are. And it will always be slower
and less robust than the devtmpfs thing too.

> Also you're rather generalizing with "the distro guys"... the Moblin
> distribution already does this for the cases where it is possible. I
> wouldn't be surprised if other distros figured out how to detect this
> case and ditch the initramfs when it's possible, while keeping it and
> doing it cheaply when it's required to have an initramfs.

Yeah, that might be nice to have, but there are not many boxes that
can not get a disk added, and you need a reliable way to cope with
that, and today that is initramfs. It's great that Moblin can do that,
but I meant general purpose distros, which can not know much of the
environment in advance they will run on.

Thanks,
Kay
