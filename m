Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbXHUKet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbXHUKet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbXHUKed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:34:33 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:10710 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbXHUKeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:34:31 -0400
Subject: Re: [accounting regression since rc1]  scheduler updates
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20070821093434.GB12025@elte.hu>
References: <20070812163225.GA11996@elte.hu>
	 <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu>
	 <200708211017.02998.borntraeger@de.ibm.com> <20070821084243.GB1144@elte.hu>
	 <1187687476.7623.8.camel@localhost>  <20070821093434.GB12025@elte.hu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 21 Aug 2007 12:38:16 +0200
Message-Id: <1187692696.24279.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 11:34 +0200, Ingo Molnar wrote:
> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > > hm, does on s390 scheduler_tick() get driven in virtual time or in 
> > > real time? The very latest scheduler code will enforce a minimum 
> > > rate of sched_clock() across two scheduler_tick() calls (in rc3 and 
> > > later kernels). If sched_clock() "slows down" but scheduler_tick() 
> > > still has a real-time frequency then that impacts the quality of 
> > > scheduling. So scheduler_tick() and sched_clock() must really have 
> > > the same behavior (either both are virtual or both are real), so 
> > > that scheduling becomes invariant to steal-time.
> > 
> > scheduler_tick() is based on the HZ timer which uses the TOD clock = 
> > real time. sched_clock() currently uses the TOD clock as well so in 
> > regard to the new scheduler we currently do not have a problem. We 
> > have a problem with cpu time accounting, the change to the /proc code 
> > breaks the precise accounting on s390. To solve the cpu time 
> > accounting we need to change sched_clock() to the cpu timer = virtual 
> > time. To change the scheduler_tick() as well requires another patch 
> > and I fear it would complicate things in the s390 backend.
> 
> my feeling is that it gives us generally higher-quality scheduling if we 
> drive all things scheduler via virtual time. Do you agree with that?

Yes, I'm in favour of converting sched_clock to use virtual time. It
makes sense to me.

> > And if you say that the scheduling becomes invariant to steal-time, 
> > how is the cpu time accounting via sum_exec supposed to work if it 
> > does not take steal-time into account ?
> 
> right now there are two distinct and independent things: scheduler 
> behavior (the scheduling decisions the scheduler makes) and accounting 
> behavior.
> 
> the 'invariant' i mentioned only covers scheduler behavior, not 
> accounting behavior. Accounting is separate in theory, but coupled in 
> practice now via sum_exec_runtime.

Hmm, ok. But the fact is that right now the accounting via
sum_exec_runtime is broken in regard to virtual cpus, isn't it?

> Before we do a patch to decouple them again, lets make sure we agree on 
> the direction to take here. There are two ways to account within a 
> virtual machine: either in real time or in virtual time.
> 
> it seems you'd like accounting to be sensitive to 'external load' - i.e. 
> you'd like an 'internal' top to show the 'real' CPU accounting, right? 

Yes, we want utime and stime represent the time spent on the physical
cpu. To make up for the missing time the steal time field has been
introduced.

> Wouldnt it be more consistent if a virtual box would not show any 
> dependency on external load? (i.e. it would slow down all of its 
> internal functionality transparently, without exposing it via /proc. The 
> only way to observe that would be the TOD interfaces: gettimeofday and 
> real-time clock driven POSIX timers. Even timer_list could be driven via 
> virtual time - although that would probably break user expectations, 
> right?) Or would accounting-in-virtual-time break user expectations too? 
> (most of the other hypervisors let guests account in virtual time.

No, imho it is less consistent if the virtual box shows virtual time. If
you look at the top output as a user and it shows that some process used
x% of cpu what does it tell you? With virtual cpus next to nothing, you
have to normalize the numbers with the %steal while the process was
running. But even then it still is not a good number because the %steal
changes while a process is running. The only good solution is to use
virtual time for all cputime values.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


