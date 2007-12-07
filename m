Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbXLGIrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbXLGIrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 03:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbXLGIq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 03:46:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47487 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXLGIqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 03:46:55 -0500
Date: Fri, 7 Dec 2007 09:45:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Robert Love <rml@tech9.net>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071207084559.GA11162@elte.hu>
References: <20071207021952.6f0ac922@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207021952.6f0ac922@morte>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Stefano Brivio <stefano.brivio@polimi.it> wrote:

> This patch fixes a regression introduced by:
> 
> commit bb29ab26863c022743143f27956cc0ca362f258c
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Mon Jul 9 18:51:59 2007 +0200
> 
> This caused the jiffies counter to leap back and forth on cpufreq 
> changes on my x86 box. I'd say that we can't always assume that TSC 
> does "small errors" only, when marked unstable. On cpufreq changes 
> these errors can be huge.

ah, printk_clock() still uses sched_clock(), not jiffies. So it's not 
the jiffies counter that goes back and forth, it's sched_clock() - so 
this is a printk timestamps anomaly, not related to jiffies. I thought 
we have fixed this bug in the printk code already: sched_clock() is a 
'raw' interface that should not be used directly - the proper interface 
is cpu_clock(cpu). Does the patch below help?

	Ingo

----------------------->
Subject: sched: fix CONFIG_PRINT_TIME's reliance on sched_clock()
From: Ingo Molnar <mingo@elte.hu>

Stefano Brivio reported weird printk timestamp behavior during
CPU frequency changes:

  http://bugzilla.kernel.org/show_bug.cgi?id=9475

fix CONFIG_PRINT_TIME's reliance on sched_clock() and use cpu_clock()
instead.

Reported-and-bisected-by: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/printk.c |    2 +-
 kernel/sched.c  |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: linux/kernel/printk.c
===================================================================
--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -680,7 +680,7 @@ asmlinkage int vprintk(const char *fmt, 
 					loglev_char = default_message_loglevel
 						+ '0';
 				}
-				t = printk_clock();
+				t = cpu_clock(printk_cpu);
 				nanosec_rem = do_div(t, 1000000000);
 				tlen = sprintf(tbuf,
 						"<%c>[%5lu.%06lu] ",
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -599,7 +599,12 @@ unsigned long long cpu_clock(int cpu)
 
 	local_irq_save(flags);
 	rq = cpu_rq(cpu);
-	update_rq_clock(rq);
+	/*
+	 * Only call sched_clock() if the scheduler has already been
+	 * initialized (some code might call cpu_clock() very early):
+	 */
+	if (rq->idle)
+		update_rq_clock(rq);
 	now = rq->clock;
 	local_irq_restore(flags);
 
