Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXHUJgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXHUJgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 05:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbXHUJfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 05:35:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57282 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbXHUJfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 05:35:11 -0400
Date: Tue, 21 Aug 2007 11:34:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070821093434.GB12025@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <200708211017.02998.borntraeger@de.ibm.com> <20070821084243.GB1144@elte.hu> <1187687476.7623.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187687476.7623.8.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4999]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> > hm, does on s390 scheduler_tick() get driven in virtual time or in 
> > real time? The very latest scheduler code will enforce a minimum 
> > rate of sched_clock() across two scheduler_tick() calls (in rc3 and 
> > later kernels). If sched_clock() "slows down" but scheduler_tick() 
> > still has a real-time frequency then that impacts the quality of 
> > scheduling. So scheduler_tick() and sched_clock() must really have 
> > the same behavior (either both are virtual or both are real), so 
> > that scheduling becomes invariant to steal-time.
> 
> scheduler_tick() is based on the HZ timer which uses the TOD clock = 
> real time. sched_clock() currently uses the TOD clock as well so in 
> regard to the new scheduler we currently do not have a problem. We 
> have a problem with cpu time accounting, the change to the /proc code 
> breaks the precise accounting on s390. To solve the cpu time 
> accounting we need to change sched_clock() to the cpu timer = virtual 
> time. To change the scheduler_tick() as well requires another patch 
> and I fear it would complicate things in the s390 backend.

my feeling is that it gives us generally higher-quality scheduling if we 
drive all things scheduler via virtual time. Do you agree with that?

> And if you say that the scheduling becomes invariant to steal-time, 
> how is the cpu time accounting via sum_exec supposed to work if it 
> does not take steal-time into account ?

right now there are two distinct and independent things: scheduler 
behavior (the scheduling decisions the scheduler makes) and accounting 
behavior.

the 'invariant' i mentioned only covers scheduler behavior, not 
accounting behavior. Accounting is separate in theory, but coupled in 
practice now via sum_exec_runtime.

Before we do a patch to decouple them again, lets make sure we agree on 
the direction to take here. There are two ways to account within a 
virtual machine: either in real time or in virtual time.

it seems you'd like accounting to be sensitive to 'external load' - i.e. 
you'd like an 'internal' top to show the 'real' CPU accounting, right? 

Wouldnt it be more consistent if a virtual box would not show any 
dependency on external load? (i.e. it would slow down all of its 
internal functionality transparently, without exposing it via /proc. The 
only way to observe that would be the TOD interfaces: gettimeofday and 
real-time clock driven POSIX timers. Even timer_list could be driven via 
virtual time - although that would probably break user expectations, 
right?) Or would accounting-in-virtual-time break user expectations too? 
(most of the other hypervisors let guests account in virtual time.)

	Ingo
