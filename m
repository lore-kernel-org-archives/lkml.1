Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZCUST3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZCUST3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 14:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZCUSTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 14:19:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53739 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbZCUSTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 14:19:20 -0400
Date: Sat, 21 Mar 2009 19:18:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090321181858.GA21155@elte.hu>
References: <20090320183849.GA3657@elte.hu> <20090320191926.GJ6698@linux.vnet.ibm.com> <20090320192721.GI6224@elte.hu> <20090320194617.GA5934@nowhere> <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere> <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com> <20090321100129.GC7201@elte.hu> <20090321165804.GA21366@elte.hu> <20090321173206.GB5956@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321173206.GB5956@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> >  [<ffffffff8029ea13>] rcu_pending+0x2c/0x5e
> >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> >  [<ffffffff8026abef>] update_process_times+0x3c/0x77
> >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> >  [<ffffffff802875dd>] tick_periodic+0x6e/0x70
> 
> 
> Still hanging in the timer interrupt.
> I guess it makes the timer interrupt servicing too slow and then
> once it is serviced, another one is raised.
> 
> But the cause is perhaps more complex
> 
> I think you have had too much hanging of this type. I'm preparing 
> a fix that checks periodically if the function graph tracer is 
> spending too much time in an interrupt.
> 
> I guess I could count the number of function executed between the 
> irq entry and its exit.
> 
> That's the best: if we are hanging in an interrupt, it could be 
> whatever interrupt and the jiffies could not be progressing so I 
> can't rely on time but only on number of functions executed.
> 
> May be 10000 calls is a good threshold before killing the function 
> graph inside an interrupt?

i think the problem isnt even the IRQ handler - but the fact that 
the (timer) irq handler gets re-triggered - so all we do is 
processing timer IRQs.

Your patch would detect a timer IRQ hanging - but it would not 
detect the 'system makes no progress because there's always anoter 
pending timer IRQ to execute' situation.

So i think we need a "function trace watchdog" - which kills the 
tracer if we do more than 100,000,000 entries since we started the 
self-test, or so.

	Ingo
