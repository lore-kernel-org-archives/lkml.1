Return-Path: <linux-kernel-owner+w=401wt.eu-S2993234AbXDSLqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993234AbXDSLqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 07:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993236AbXDSLqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 07:46:11 -0400
Received: from mail06.syd.optusnet.com.au ([211.29.132.187]:47665 "EHLO
	mail06.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993234AbXDSLqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 07:46:10 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Renice X for cpu schedulers
Date: Thu, 19 Apr 2007 21:59:35 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070417062621.GL2986@holomorphy.com> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu>
In-Reply-To: <20070419063810.GA22418@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 5849
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704192159.35546.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, there are 3 known schedulers currently being "promoted" as solid 
replacements for the mainline scheduler which address most of the issues with 
mainline (and about 10 other ones not currently being promoted). The main way 
they do this is through attempting to maintain solid fairness. There is 
enough evidence mounting now from the numerous test cases fixed by much 
fairer designs that this is the way forward for a general purpose cpu 
scheduler which is what linux needs. 

Interactivity of just about everything that needs low latency (ie audio and 
video players) are easily managed by maintaining low latency between wakeups 
and scheduling of all these low cpu users. The one fly in the ointment for 
linux remains X. I am still, to this moment, completely and utterly stunned 
at why everyone is trying to find increasingly complex unique ways to manage 
X when all it needs is more cpu[1]. Now most of these are actually very good 
ideas about _extra_ features that would be desirable in the long run for 
linux, but given the ludicrous simplicity of renicing X I cannot fathom why 
people keep promoting these alternatives. At the time of 2.6.0 coming out we 
were desparately trying to get half decent interactivity within a reasonable 
time frame to release 2.6.0 without rewiring the whole scheduler. So I 
tweaked the crap out of the tunables that were already there[2].

So let's hear from the 3 people who generated the schedulers under the 
spotlight. These are recent snippets and by no means the only time these 
comments have been said. Without sounding too bold, we do know a thing or two 
about scheduling.

CFS:
On Thursday 19 April 2007 16:38, Ingo Molnar wrote:
> hmmmm. How about the following then: default to nice -10 for all
> (SCHED_NORMAL) kernel threads and all root-owned tasks. Root _is_
> special: root already has disk space reserved to it, root has special
> memory allocation allowances, etc. I dont see a reason why we couldnt by
> default make all root tasks have nice -10. This would be instantly loved
> by sysadmins i suspect ;-)
>
> (distros that go the extra mile of making Xorg run under non-root could
> also go another extra one foot to renice that X server to -10.)

Nicksched:
On Wednesday 18 April 2007 15:00, Nick Piggin wrote:
> What's wrong with allowing X to get more than it's fair share of CPU
> time by "fiddling with nice levels"? That's what they're there for.

and

Staircase-Deadline:
On Thursday 19 April 2007 09:59, Con Kolivas wrote:
> Remember to renice X to -10 for nicest desktop behaviour :)


[1]The one caveat I can think of is that when you share X sessions across 
multiple users -with a fair cpu scheduler-, having them all nice 0 also makes 
the distribution of cpu across the multiple users very even and smooth, 
without the expense of burning away the other person's cpu time they'd like 
for compute intensive non gui things. If you make a scheduler that always 
favours X this becomes impossible. I've had enough users offlist ask me to 
help them set up multiuser environments just like this with my schedulers 
because they were unable to do it with mainline, even with SCHED_BATCH, short 
of nicing everything +19. This makes the argument for not favouring X within 
the scheduler with tweaks even stronger.

[2] Nick was promoting renicing X with his Nicksched alternative at the time 
of 2.6.0 and while we were not violently opposed to renicing X, Nicksched was 
still very new on the scene and didn't have the luxury of extended testing 
and reiteration in time for 2.6 and he put the project on hold for some time 
after that. The correctness of his views on renicing certainly have become 
more obvious over time.


So yes go ahead and think up great ideas for other ways of metering out cpu 
bandwidth for different purposes, but for X, given the absurd simplicity of 
renicing, why keep fighting it? Again I reiterate that most users of SD have 
not found the need to renice X anyway except if they stick to old habits of 
make -j4 on uniprocessor and the like, and I expect that those on CFS and 
Nicksched would also have similar experiences.

-- 
-ck
