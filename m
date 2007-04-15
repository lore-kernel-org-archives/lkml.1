Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbXDOD22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbXDOD22 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 23:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbXDOD22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 23:28:28 -0400
Received: from mail35.syd.optusnet.com.au ([211.29.133.51]:52712 "EHLO
	mail35.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbXDOD20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 23:28:26 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Bill Huey (hui) <billh@gnuppy.monkey.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Sun, 15 Apr 2007 13:27:13 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu>
In-Reply-To: <20070413202100.GA9957@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3360
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704151327.13589.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 April 2007 06:21, Ingo Molnar wrote:
> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler
> [CFS]
>
> i'm pleased to announce the first release of the "Modular Scheduler Core
> and Completely Fair Scheduler [CFS]" patchset:
>
>    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
>
> This project is a complete rewrite of the Linux task scheduler. My goal
> is to address various feature requests and to fix deficiencies in the
> vanilla scheduler that were suggested/found in the past few years, both
> for desktop scheduling and for server scheduling workloads.

The casual observer will be completely confused by what on earth has happened 
here so let me try to demystify things for them.

1. I tried in vain some time ago to push a working extensable pluggable cpu 
scheduler framework (based on wli's work) for the linux kernel. It was 
perma-vetoed by Linus and Ingo (and Nick also said he didn't like it) as 
being absolutely the wrong approach and that we should never do that. Oddly 
enough the linux-kernel-mailing list was -dead- at the time and the 
discussion did not make it to the mailing list. Every time I've tried to 
forward it to the mailing list the spam filter decided to drop it so most 
people have not even seen this original veto-forever discussion.

2. Since then I've been thinking/working on a cpu scheduler design that takes 
away all the guesswork out of scheduling and gives very predictable, as fair 
as possible, cpu distribution and latency while preserving as solid 
interactivity as possible within those confines. For weeks now, Ingo has said 
that the interactivity regressions were showstoppers and we should address 
them, never mind the fact that the so-called regressions were purely "it 
slows down linearly with load" which to me is perfectly desirable behaviour. 
While this was not perma-vetoed, I predicted pretty accurately your intent 
was to veto it based on this.

People kept claiming scheduling problems were few and far between but what was 
really happening is users were terrified of lkml and instead used 1. windows 
and 2. 2.4 kernels. The problems were there.

So where are we now? Here is where your latest patch comes in.

As a solution to the many scheduling problems we finally all agree exist, you 
propose a patch that adds 1. a limited pluggable framework and 2. a fairness 
based cpu scheduler policy... o_O

So I should be happy at last now that the things I was promoting you are also 
promoting, right? Well I'll fill in the rest of the gaps and let other people 
decide how I should feel.

> as usual, any sort of feedback, bugreports, fixes and suggestions are
> more than welcome,

In the last 4 weeks I've spent time lying in bed drugged to the eyeballs and 
having trips in and out of hospitals for my condition. I appreciate greatly 
the sympathy and patience from people in this regard. However at one stage I 
virtually begged for support with my attempts and help with the code. Dmitry 
Adamushko is the only person who actually helped me with the code in the 
interim, while others poked sticks at it. Sure the sticks helped at times but 
the sticks always seemed to have their ends kerosene doused and flaming for 
reasons I still don't get. No other help was forthcoming.

Now that you're agreeing my direction was correct you've done the usual Linux 
kernel thing - ignore all my previous code and write your own version. Oh 
well, that I've come to expect; at least you get a copyright notice in the 
bootup and somewhere in the comments give me credit for proving it's 
possible. Let's give some other credit here too. William Lee Irwin provided 
the major architecture behind plugsched at my request and I simply finished 
the work and got it working. He is also responsible for many IRC discussions 
I've had about cpu scheduling fairness, designs, programming history and code 
help. Even though he did not contribute code directly to SD, his comments 
have been invaluable.

So let's look at the code.

kernel/sched.c
kernel/sched_fair.c
kernel/sched_rt.c

It turns out this is not a pluggable cpu scheduler framework at all, and I 
guess you didn't really promote it as such. It's a "modular scheduler core". 
Which means you moved code from sched.c into sched_fair.c and sched_rt.c. 
This abstracts out each _scheduling policy's_ functions into struct 
sched_class and allows each scheduling policy's functions to be in a separate 
file etc.

Ok so what it means is that instead of whole cpu schedulers being able to be 
plugged into this framework we can plug in only cpu scheduling policies.... 
hrm... So let's look on

-#define SCHED_NORMAL		0

Ok once upon a time we rename SCHED_OTHER which every other unix calls the 
standard policy 99.9% of applications used into a more meaningful name, 
SCHED_NORMAL. That's fine since all it did was change the description 
internally for those reading the code. Let's see what you've done now:

+#define SCHED_FAIR		0

You've renamed it again. This is, I don't know what exactly to call it, but an 
interesting way of making it look like there is now more choice. Well, 
whatever you call it, everything in linux spawned from init without 
specifying a policy still gets policy 0. This is SCHED_OTHER still, renamed 
SCHED_NORMAL and now SCHED_FAIR.

You encouraged me to create a sched_sd.c to add onto your design as well. 
Well, what do I do with that? I need to create another scheduling policy for 
that code to even be used. A separate scheduling policy requires a userspace 
change to even benefit from it. Even if I make that sched_sd.c patch, people 
cannot use SD as their default scheduler unless they hack SCHED_FAIR 0 to 
read SCHED_SD 0 or similar. The same goes for original staircase cpusched, 
nicksched, zaphod, spa_ws, ebs and so on.

So what you've achieved with your patch is - replaced the current scheduler 
with another one and moved it into another file. There is no choice, and no 
pluggability, just code trumping. 

Do I support this? In this form.... no.

It's not that I don't like your new scheduler. Heck it's beautiful like most 
of your _serious_ code. It even comes with a catchy name that's bound to give 
people hard-ons (even though many schedulers aim to be completely fair, yours 
has been named that for maximum selling power). The complaint I have is that 
you are not providing quite what you advertise (on the modular front), or 
perhaps you're advertising it as such to make it look more appealing; I'm not 
sure.

Since we'll just end up with your code, don't pretend SCHED_NORMAL is anything 
different, and that this is anything other than your NIH (Not Invented Here) 
cpu scheduling policy rewrite which will probably end up taking it's position 
in mainline after yet another truckload of regression/performance tests and 
so on. I haven't seen an awful lot of comparisons with SD yet, just people 
jumping on your bandwagon which is fine I guess. Maybe a few tiny tests 
showing less than 5% variation in their fairness from what I can see. Either 
way, I already feel you've killed off SD... like pretty much everything else 
I've done lately. At least I no longer have to try and support my code mostly 
by myself.

In the interest of putting aside any ego concerns since this is about linux 
and not me...

Because...  You are a hair's breadth away from producing something that I 
would support, which _does_ do what you say and produces the pluggability 
we're all begging for with only tiny changes to the code you've already done. 
Make Kconfig let you choose which sched_*.c gets built into the kernel, and 
make SCHED_OTHER choose which SCHED_* gets chosen as the default from Kconfig 
and even choose one of the alternative built in ones with boot parametersyour 
code has more clout than mine will (ie do exactly what plugsched does). Then 
we can have 7 schedulers in linux kernel within a few weeks. Oh no! This is 
the very thing Linus didn't want in specialisation with the cpu schedulers! 
Does this mean this idea will be vetoed yet again? In all likelihood, yes.

I guess I have lots to put into -ck still... sigh.

> 	Ingo

-- 
-ck
