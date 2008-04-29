Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYD2Jq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYD2Jq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbYD2Jqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:46:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59623 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbYD2Jqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:46:49 -0400
Date: Tue, 29 Apr 2008 11:46:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: ego@in.ibm.com, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG-REPORT] hrtick_start_fair and CPU-Hotplug
Message-ID: <20080429094608.GB23198@elte.hu>
References: <20080429065211.GB7859@in.ibm.com> <1209452359.13978.26.camel@twins> <1209456166.13978.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209456166.13978.30.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> > This looks like its not cancelled at all and migrates the it to 
> > another cpu. I'll see what I can come up with.

thanks - i've queued up the patch below. Once this goes upstream it 
would be a backport candidate as wel.

	Ingo

-------------------------->
Subject: sched: fix hrtick_start_fair and CPU-Hotplug
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 29 Apr 2008 10:02:46 +0200

Gautham R Shenoy reported:

 > While running the usual CPU-Hotplug stress tests on linux-2.6.25,
 > I noticed the following in the console logs.
 >
 > This is a wee bit difficult to reproduce. In the past 10 runs I hit this
 > only once.
 >
 > ------------[ cut here ]------------
 >
 > WARNING: at kernel/sched.c:962 hrtick+0x2e/0x65()
 >
 > Just wondering if we are doing a good job at handling the cancellation
 > of any per-cpu scheduler timers during CPU-Hotplug.

This looks like its indeed not cancelled at all and migrates the it to
another cpu. Fix it via a proper hotplug notifier mechanism.

Reported-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1238,6 +1238,7 @@ static inline void resched_rq(struct rq 
 enum {
 	HRTICK_SET,		/* re-programm hrtick_timer */
 	HRTICK_RESET,		/* not a new slice */
+	HRTICK_BLOCK,		/* stop hrtick operations */
 };
 
 /*
@@ -1249,6 +1250,8 @@ static inline int hrtick_enabled(struct 
 {
 	if (!sched_feat(HRTICK))
 		return 0;
+	if (unlikely(test_bit(HRTICK_BLOCK, &rq->hrtick_flags)))
+		return 0;
 	return hrtimer_is_hres_active(&rq->hrtick_timer);
 }
 
@@ -1331,7 +1334,63 @@ static enum hrtimer_restart hrtick(struc
 	return HRTIMER_NORESTART;
 }
 
-static inline void init_rq_hrtick(struct rq *rq)
+static void hotplug_hrtick_disable(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	rq->hrtick_flags = 0;
+	__set_bit(HRTICK_BLOCK, &rq->hrtick_flags);
+	spin_unlock_irqrestore(&rq->lock, flags);
+
+	hrtick_clear(rq);
+}
+
+static void hotplug_hrtick_enable(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	__clear_bit(HRTICK_BLOCK, &rq->hrtick_flags);
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+static int
+hotplug_hrtick(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	int cpu = (int)hcpu;
+
+	switch (action) {
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		hotplug_hrtick_disable(cpu);
+		return NOTIFY_OK;
+
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		hotplug_hrtick_enable(cpu);
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static void init_hrtick(void)
+{
+	hotcpu_notifier(hotplug_hrtick, 0);
+}
+
+static void init_rq_hrtick(struct rq *rq)
 {
 	rq->hrtick_flags = 0;
 	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
@@ -1368,6 +1427,10 @@ static inline void init_rq_hrtick(struct
 void hrtick_resched(void)
 {
 }
+
+static inline void init_hrtick(void)
+{
+}
 #endif
 
 /*
@@ -8020,6 +8083,7 @@ void __init sched_init_smp(void)
 	put_online_cpus();
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
+	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed_ptr(current, &non_isolated_cpus) < 0)
