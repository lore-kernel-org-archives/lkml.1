Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYD2ID3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYD2ID3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYD2IDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:03:02 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41815 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbYD2IDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:03:00 -0400
Subject: Re: [BUG-REPORT] hrtick_start_fair and CPU-Hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: ego@in.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1209452359.13978.26.camel@twins>
References: <20080429065211.GB7859@in.ibm.com>
	 <1209452359.13978.26.camel@twins>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 10:02:46 +0200
Message-Id: <1209456166.13978.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 08:59 +0200, Peter Zijlstra wrote:
> On Tue, 2008-04-29 at 12:22 +0530, Gautham R Shenoy wrote:
> > Hello!
> > 
> > While running the usual CPU-Hotplug stress tests on linux-2.6.25,
> > I noticed the following in the console logs.
> > 
> > This is a wee bit difficult to reproduce. In the past 10 runs I hit this
> > only once.
> > 
> > ------------[ cut here ]------------
> > 
> > WARNING: at kernel/sched.c:962 hrtick+0x2e/0x65()
> 
> > I am not well versed with this part of the code, so just wondering if we
> > are doing a good job at handling the cancellation of any per-cpu
> > scheduler timers during CPU-Hotplug.
> 
> This looks like its not cancelled at all and migrates the it to another
> cpu. I'll see what I can come up with.


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -1201,6 +1201,7 @@ static inline void resched_rq(struct rq 
 enum {
 	HRTICK_SET,		/* re-programm hrtick_timer */
 	HRTICK_RESET,		/* not a new slice */
+	HRTICK_BLOCK,		/* stop hrtick operations */
 };
 
 /*
@@ -1212,6 +1213,8 @@ static inline int hrtick_enabled(struct 
 {
 	if (!sched_feat(HRTICK))
 		return 0;
+	if (unlikely(test_bit(HRTICK_BLOCK, &rq->hrtick_flags)))
+		return 0;
 	return hrtimer_is_hres_active(&rq->hrtick_timer);
 }
 
@@ -1294,7 +1297,63 @@ static enum hrtimer_restart hrtick(struc
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
@@ -1331,6 +1390,10 @@ static inline void init_rq_hrtick(struct
 void hrtick_resched(void)
 {
 }
+
+static inline void init_hrtick(void)
+{
+}
 #endif
 
 /*
@@ -7964,6 +8027,7 @@ void __init sched_init_smp(void)
 	put_online_cpus();
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
+	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed_ptr(current, &non_isolated_cpus) < 0)


