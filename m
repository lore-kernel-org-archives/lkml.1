Return-Path: <linux-kernel-owner+w=401wt.eu-S1759334AbXHULZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbXHULZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbXHULZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:25:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53169 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592AbXHULZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:25:43 -0400
Date: Tue, 21 Aug 2007 13:25:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070821112529.GB648@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <200708211017.02998.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708211017.02998.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am Montag, 20. August 2007 schrieb Ingo Molnar:
> > could you send that precise sched_clock() patch? It should be an order 
> > of magnitude simpler than the high-precision stime/utime tracking you 
> > already do, and it's needed for quality scheduling anyway.
> 
> I have a question about that. I just played with sched_clock, and even 
> when I intentionally slow down sched_clock by a factor of 2, my cpu 
> bound process gets 100 % in top. If this is intentional, I dont 
> understand how a virtualized sched_clock would fix the accounting 
> change?

could you try the patch below, does it work any better?

	Ingo

---
 kernel/sched.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -333,6 +333,14 @@ static void __update_rq_clock(struct rq 
 #ifdef CONFIG_SCHED_DEBUG
 	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
 #endif
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+	/*
+	 * Trust sched_clock on s390:
+	 */
+	if (unlikely(delta > rq->clock_max_delta))
+		rq->clock_max_delta = delta;
+	clock += delta;
+#else
 	/*
 	 * Protect against sched_clock() occasionally going backwards:
 	 */
@@ -355,6 +363,7 @@ static void __update_rq_clock(struct rq 
 			clock += delta;
 		}
 	}
+#endif
 
 	rq->prev_clock_raw = now;
 	rq->clock = clock;
