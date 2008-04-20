Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYDTSte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYDTSte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYDTSt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:49:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33769 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYDTStY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:49:24 -0400
Date: Sun, 20 Apr 2008 11:48:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420114845.77bf3fed@laptopd505.fenrus.org>
In-Reply-To: <480B7CB2.3080002@firstfloor.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080420104444.GI1595@cs181133002.pp.htv.fi>
	<87y778aezh.fsf@basil.nowhere.org>
	<200804201144.33308.dhazelton@enter.net>
	<480B7CB2.3080002@firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 19:26:10 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Daniel Hazelton wrote:
> 
> > Andi, you're the only one I've seen seriously pounding the "50k
> > threads" thing. I don't think anyone is really fooled by the
> > straw-man, so I'd suggest you drop it.
> 
> Ok, perhaps we can settle this properly. Like historicans. We study
> the original sources.
> 
> The primary resource is the original commit adding the 4k stack code.
> You cannot find this in latest git because it predates 2.6.12, but it
> is available in one of the historic trees imported from BitKeeper like
> git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
> 
> Here's the log:
> >>
> commit 95f238eac82907c4ccbc301cd5788e67db0715ce
> Author: Andrew Morton <akpm@osdl.org>
> Date:   Sun Apr 11 23:18:43 2004 -0700
> 
>     [PATCH] ia32: 4Kb stacks (and irqstacks) patch
> 
>     From: Arjan van de Ven <arjanv@redhat.com>
> 
>     Below is a patch to enable 4Kb stacks for x86. The goal of this
> is to
> 
>     1) Reduce footprint per thread so that systems can run many more
> threads (for the java people)
> 
>     2) Reduce the pressure on the VM for order > 0 allocations. We see
> real life
>        workloads (granted with 2.4 but the fundamental fragmentation
> issue isn't
>        solved in 2.6 and isn't solvable in theory) where this can be a
> problem.
>        In addition order > 0 allocations can make the VM "stutter" and
> give more
>        latency due to having to do much much more work trying to
> defragment
> 
> ...
> <<
> 
> This gives us two reasons as you can see, one of them many threads
> and another mostly only relevant to 2.4
> 
> Now I was also assuming that nobody took (1) really serious and

I'm sorry but I really hope nobody shares your assumption here.
These are real customer workloads; java based "many things going on" at a time
showed several thousands of threads fin the system (a dozen or two per request, multiplied
by the number of outstanding connections) for *real customers*.
That you don't take that serious, fair, you can take serious whatever you want.


> attacked (2) in earlier thread; in particular in

yes you did attack. But lets please use more friendly conversation here than words like
"attack". This is not a war, and we really shouldn't be hostile in this forum, neither
in words nor in intention.

> 
> http://article.gmane.org/gmane.linux.kernel/665584
> 
> >>
> Actually the real reason the 4K stacks were introduced IIRC was that
> the VM is not very good at allocation of order > 0 pages and that only
> using order 0 and not order 1 in normal operation prevented some
> stalls.
> 
> This rationale also goes back to 2.4 (especially some of the early 2.4
> VMs were not very good) and the 2.6 VM is generally better and on
> x86-64 I don't see much evidence that these stalls are a big problem
> (but then x86-64 also has more lowmem).
> <<

What you didn't atta^Waddress was the observation that fragmentation is fundamentally unsolvable.
Yes 2.4 sucked a lot more than 2.6 does. But even 2.6 will (and does) have fragmentation issues.
We don't have effective physical address based reclaim yet for higher order allocs.

> 
> http://thread.gmane.org/gmane.linux.kernel/665420:
> 
> >>
> no, the primary motivation Arjan and me started working on 4K stacks
> and implemented it was what Denys mentioned: i had a testcase that ran
> 50,000 threads before it ran out of memory - i wanted it to run
> 100,000 threads. The improved order-0 behavior was just icing on the
> cake.
> 
> 	Ingo
> <<
> 
> and then from Arjan:
> 
> http://thread.gmane.org/gmane.linux.kernel/665420
> 
> >>
> > no, the primary motivation Arjan and me started working on 4K stacks
> > and implemented it was what Denys mentioned: i had a testcase that
> 
> well that and the fact that RH had customers who had major issues at
> fewer threads
> with 8Kb versus fragmentation.
> <<
> 
> So both the primary authors of the patch state that 50k threads
> was the main reason. I didn't believe it at first either, but after
> these forceful corrections I do now.

I'm sorry but I fail to entirely understand where your "So" or the rest of your 
conclusion comes from in terms of "both the authors". Which part of "fewer threads" and
"8kb versus fragmentation" did you misunderstand to get to your conclusion?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
