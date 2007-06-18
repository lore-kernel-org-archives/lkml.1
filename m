Return-Path: <linux-kernel-owner+w=401wt.eu-S1764780AbXFRS1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764780AbXFRS1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761421AbXFRS1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:27:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32930 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760595AbXFRS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:27:05 -0400
Date: Mon, 18 Jun 2007 11:25:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Miklos Szeredi <miklos@szeredi.hu>, cebbert@redhat.com, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <20070618180041.GA13483@elte.hu>
Message-ID: <alpine.LFD.0.98.0706181112060.14121@woody.linux-foundation.org>
References: <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu>
 <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu>
 <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu>
 <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu>
 <20070618081204.GA11153@elte.hu> <alpine.LFD.0.98.0706180857120.14121@woody.linux-foundation.org>
 <20070618180041.GA13483@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Jun 2007, Ingo Molnar wrote:
> 
> ok. Do we have an guarantee that cpu_relax() is also an smp_rmb()?

The common use for cpu_relax() is basically for code that does

	while (*ptr != val)
		cpu_relax();

so yes, an architecture that doesn't notice writes by other CPU's on its 
own had *better* have an implied read barrier in its "cpu_relax()" 
implementation. For example, the irq handling code does

	while (desc->status & IRQ_INPROGRESS)
		cpu_relax();

which is explicitly about waiting for another CPU to get out of their 
interrupt handler. And one classic use for it in drivers is obviously the

	while (time_before (jiffies, next))
		cpu_relax();

kind of setup (and "jiffies" may well be updated on another CPU: the fact 
that it is "volatile" is just a *compiler* barrier just like cpu_relax() 
itself will also be, not a "smp_rmb()" kind of hardware barrier).

So we could certainly add the smp_rmb() to make it more explicit, and it 
wouldn't be *wrong*.

But quite frankly, I'd personally rather not - if it were to make a 
difference in some situation, it would just be papering over a bug in 
cpu_relax() itself.

The whole point of cpu_relax() is about busy-looping, after all. And the 
only thing you really *can* busy-loop on in a CPU is basically a memory 
value.

So the smp_rmb() would I think distract from the issue, and at best paper 
over some totally separate bug.

> hm, this might still go into a non-nice busy loop on SMP: one cpu runs 
> the strace, another one runs two tasks, one of which is runnable but not 
> on the runqueue (the one we are waiting for). In that case we'd call 
> yield() on this CPU in a loop

Sure. I agree - we can get into a loop that calls yield(). But I think a 
loop that calls yield() had better be ok - we're explicitly giving the 
scheduler the ability to to schedule anything else that is relevant. 

So I think yield()'ing is fundamentally different from busy-looping any 
other way. 

Would it be better to be able to have a wait-queue, and actually *sleep* 
on it, and not even busy-loop using yield? Yeah, possibly. I cannot 
personally bring myself to care about that kind of corner-case situation, 
though.

			Linus
