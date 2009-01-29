Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbZA2RXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbZA2RXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZA2RXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:23:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbZA2RXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:23:11 -0500
Date: Thu, 29 Jan 2009 09:21:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
In-Reply-To: <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>  <200901290955.38940.rusty@rustcorp.com.au>  <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>  <20090128173039.cbc29e81.akpm@linux-foundation.org> <1233218954.7835.11.camel@twins>
 <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Jan 2009, Steven Rostedt wrote:
> 
> The caller must wait till the LOCK bit is cleared before setting
> it. When it is cleared, there is no IPI function using it.
> A spinlock is used to synchronize the setting of the bit between
> callers. Since only one callee can be called at a time, and it
> is the only thing to clear it, the IPI does not need to use
> any locking.

That spinlock cannot be right. It is provably wrong for so many reasons..

Think about it. We're talking about a per-CPU lock, which already makes no 
sense: we're only locking against our own CPU, and we've already disabled 
preemption for totally unrelated reasons.

And the only way locking can make sense against our own CPU is if we lock 
against interrupts - but the lock isn't actually irq-safe, so if you are 
trying to lock against interrupts, you are (a) doing it wrong (you should 
disable interrupts, not use a spinlock) and (b) causing a deadlock if it 
ever happens.

In other words: no way in hell does that make any sense what-so-ever.

Just remove it. As it is, it can only hurt. There's no possible point to 
it.

Now, if people actually do send IPI's from interrupts (and it does happen 
- cross-cpu wakeups etc), then that implies that you do want to then make 
the whole thing irq-safe. But the *spinlock* is pointless.

But to be irq-safe, you now need to protect the _whole_ region against 
interrupts, because otherwise an incoming interrupt will hit while the 
CSD_FLAG_LOCK bit is set, perhaps _before_ the actual IPI has been sent, 
and now nothing will ever clear it. So the interrupt handler that tries to 
send an IPI will now spin forever.

So NAK on this patch. I think the approach is correct, but the 
implementation is buggy.

			Linus
