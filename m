Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYHHR0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYHHR0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbYHHR0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:26:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756279AbYHHRZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:25:59 -0400
Date: Fri, 8 Aug 2008 10:25:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] printk vs rq->lock and xtime lock
In-Reply-To: <1218215454.8625.133.camel@twins>
Message-ID: <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>
References: <20080324122424.671168000@chello.nl>  <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>  <1206382547.6437.131.camel@lappy>  <20080324115738.85c72bb5.akpm@linux-foundation.org>  <1218202249.8625.106.camel@twins> 
 <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org> <1218215454.8625.133.camel@twins>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Aug 2008, Peter Zijlstra wrote:
> 
> Sure, but the RCU callback period is at least 3 jiffies and much longer
> when busy - I'm not sure how long before we force a grace period, we do
> that to avoid DoS, right Paul?

I really don't think it matters. klogd is going to write the thing to 
_disk_ (or network), and three jiffies really don't matter. If we can fill 
the buffer in that kind of time, we're screwed for other reasons anyway.

> So this version would have a much higher risk of overflowing the console
> buffer and making klogd miss bits. Then again, I really don't care about
> klogd at _all_, I've been running with the wakeup patched out for ages.

Well, I'd care a _bit_ about klogd, but not enough to worry about a couple 
of jiffies. We want to wake it up at some point, but...

> Gah, the below doesn't boot - because I guess we start using rcu before
> its properly set up.. should I poke at it more?

I'd certainly prefer this kind of approach. However, may I suggest:

 - doing the "waitqueue_active(&log_wait)" before even bothering to do the 
   RCU call. That, btw, will automatically mean that we wouldn't ever call 
   the RCU code before anything is initialized.

 - get rid of the "oops_in_progress" thing, since I think the whole point 
   of that was to avoid getting the lock recursively in the first place.

 - I'd worry about the "spin_lock_irqsave(&klogd_wakeup_state.lock)". What 
   if the printk happens from call_rcu()? This is exactly what we're 
   trying to get away from - having some parts of the kernel not able to 
   printk() because of subtle locking issues.

For that last thing, maybe we can just make it a percpu thing and just 
disable irq's?

			Linus
