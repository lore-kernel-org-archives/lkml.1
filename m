Return-Path: <linux-kernel-owner+w=401wt.eu-S1764713AbXF1JYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764713AbXF1JYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 05:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761138AbXF1JYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 05:24:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58184 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259AbXF1JYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 05:24:41 -0400
Date: Thu, 28 Jun 2007 11:23:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070628092340.GB23566@elte.hu>
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46834BB8.1020007@garzik.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> Tasklets fill a niche not filled by either workqueues (slower, 
> requiring context switches, and possibly much latency is all wq's 
> processes are active) [...]

... workqueues are also possibly much more scalable (percpu workqueues 
are easy without changing anything in your code but the call where you 
create the workqueue).

the context-switch argument i'll believe if i see numbers. You'll 
probably need in excess of tens of thousands of irqs/sec to even be able 
to measure its overhead. (workqueues are driven by nice kernel threads 
so there's no TLB overhead, etc.)

the only remaining argument is latency: but workqueues are already 
pretty high-prio (with a default priority of nice -5) - and you can 
increase it even further. You can make it SCHED_FIFO prio 98 if latency 
is so important. Tasklets on the other hand are _unconditionally_ 
high-priority. So this argument is more of an arms-race argument: "i 
want _my_ processing to be done immediately!". The fact that workqueues 
can be preempted and that their priorities can be adjusted flexibly is 
an optional _bonus_, not a disadvantage. If low-prio workqueues hurts 
your workflow, make them high-prio.

> And moving code -back- into hardirq is just the wrong thing to do, 
> usually.

agreed - except if the in-tasklet processing is really thin and there's 
already a softirq layer in the workflow. (which the case was for the 
example that was cited.) In such a case moving either to the hardirq or 
to the softirq looks like the right thing - instead of the tasklet 
intermediary.

	Ingo
