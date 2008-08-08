Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbYHHVOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbYHHVOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbYHHVOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:14:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754945AbYHHVOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:14:11 -0400
Date: Fri, 8 Aug 2008 14:13:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: a.p.zijlstra@chello.nl, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net, rostedt@goodmis.org
Subject: Re: [PATCH] printk: robustify printk
Message-Id: <20080808141340.a191c12e.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808081352490.3462@nehalem.linux-foundation.org>
References: <1218202249.8625.106.camel@twins>
	<alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
	<1218215454.8625.133.camel@twins>
	<alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>
	<1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
	<alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
	<1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
	<20080808121428.646a8b3c.akpm@linux-foundation.org>
	<1218223269.29098.12.camel@lappy.programming.kicks-ass.net>
	<20080808123747.0db1c5dd.akpm@linux-foundation.org>
	<20080808203241.GH6760@linux.vnet.ibm.com>
	<1218227859.29098.24.camel@lappy.programming.kicks-ass.net>
	<20080808134657.fe439e56.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0808081352490.3462@nehalem.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 13:57:26 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 8 Aug 2008, Andrew Morton wrote:
> > 
> > Why are we fixing this, btw?  The problem has been there forever and
> > people who hack the wakeup code could/should know about it anyway.  All
> > they need to do is to disable klogd during development.  Did the
> > problem recently become worse for some reason?
> 
> It hasn't beemn there forever at all.
> 
> Yes, there used to be reliance on the actual _scheduler_ locks. Doign a 
> wake_up() would cause runqueue locks etc to be taken.
> 
> But the xtime deadlock is fairly recent, and only happened with CFQ, I 
> think.
> 
> And _that_ is the irritating one. I personally wouldn't mind at all if 
> there is some printk() dependency on the core runqueue rq->lock or on the 
> RCU locking thing. But look at xtime_lock. THAT is a disaster.
> 
> Just grep for it. 
> 
> 

<actually reads stuff>

Yes, not being able to do printk inside xtime_lock would be a disaster.
We decided that about 1.5 years ago last time we added then fixed this
bug (at the time I think I identified multiple already-present printks
inside xtime_lock, on error paths).  Did we go and re-add this bug recently
or did we just never fix it?   Doesn't matter, I guess.

> So I personally actually like the RCU version best. Yes, it still depends 
> on really core locking. But it's really core and low-level and _confined_ 
> locking, where a comment in a single place would probably suffice. Compare 
> that to all the places where we take the xtime_lock for writing!

Sure, the cant-printk-in-rcupreempt.c limitation should be quite
acceptable.
