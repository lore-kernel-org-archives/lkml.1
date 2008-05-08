Return-Path: <linux-kernel-owner+w=401wt.eu-S1763465AbYEHRpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465AbYEHRpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYEHRnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:33466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761202AbYEHRnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:21 -0400
Date: Thu, 8 May 2008 10:42:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 05/16] sched: fix hrtick_start_fair and CPU-Hotplug
Message-ID: <20080508174205.GF855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched-fix-hrtick_start_fair-and-cpu-hotplug.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Peter Zijlstra <peterz@infradead.org>

commit: b328ca182f01c2a04b85e0ee8a410720b104fbcc upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -876,6 +876,7 @@ static inline void resched_rq(struct rq 
 enum {
 	HRTICK_SET,		/* re-programm hrtick_timer */
 	HRTICK_RESET,		/* not a new slice */
+	HRTICK_BLOCK,		/* stop hrtick operations */
 };
 
 /*
@@ -887,6 +888,8 @@ static inline int hrtick_enabled(struct 
 {
 	if (!sched_feat(HRTICK))
 		return 0;
+	if (unlikely(test_bit(HRTICK_BLOCK, &rq->hrtick_flags)))
+		return 0;
 	return hrtimer_is_hres_active(&rq->hrtick_timer);
 }
 
@@ -969,7 +972,63 @@ static enum hrtimer_restart hrtick(struc
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
+	int cpu = (int)(long)hcpu;
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
@@ -1006,6 +1065,10 @@ static inline void init_rq_hrtick(struct
 void hrtick_resched(void)
 {
 }
+
+static inline void init_hrtick(void)
+{
+}
 #endif
 
 /*
@@ -7094,6 +7157,7 @@ void __init sched_init_smp(void)
 	put_online_cpus();
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
+	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)

-- 
