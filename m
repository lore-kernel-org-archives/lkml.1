Return-Path: <linux-kernel-owner+w=401wt.eu-S1765050AbYDOOBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765050AbYDOOBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbYDOOB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:01:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58782 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752883AbYDOOB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:01:28 -0400
Date: Tue, 15 Apr 2008 09:01:27 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] reduce calls to hrtimer_get_softirq_time
Message-ID: <20080415140127.GA32476@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that hrtimer_run_queues() is calling hrtimer_get_softirq_time()
more often than it needs to.  This can cause frequent contention on
systems with large numbers of processors/cores.

With this patch, hrtimer_run_queues only calls hrtimer_get_softirq_time()
if there is a pending timer in one of the hrtimer bases, and only once.

This also combines hrtimer_run_queues() and the inline run_hrtimer_queue()
into one function.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

Index: linux/kernel/hrtimer.c
===================================================================
--- linux.orig/kernel/hrtimer.c	2008-04-14 14:03:08.000000000 -0500
+++ linux/kernel/hrtimer.c	2008-04-14 15:35:19.594941220 -0500
@@ -1238,51 +1238,52 @@ void hrtimer_run_pending(void)
 /*
  * Called from hardirq context every jiffy
  */
-static inline void run_hrtimer_queue(struct hrtimer_cpu_base *cpu_base,
-				     int index)
+void hrtimer_run_queues(void)
 {
 	struct rb_node *node;
-	struct hrtimer_clock_base *base = &cpu_base->clock_base[index];
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_clock_base *base;
+	int index;
+	int gst = 1;
 
-	if (!base->first)
+	if (hrtimer_hres_active())
 		return;
 
-	if (base->get_softirq_time)
-		base->softirq_time = base->get_softirq_time();
+	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
+		base = &cpu_base->clock_base[index];
 
-	spin_lock(&cpu_base->lock);
-
-	while ((node = base->first)) {
-		struct hrtimer *timer;
-
-		timer = rb_entry(node, struct hrtimer, node);
-		if (base->softirq_time.tv64 <= timer->expires.tv64)
-			break;
-
-		if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
-			__remove_hrtimer(timer, base, HRTIMER_STATE_PENDING, 0);
-			list_add_tail(&timer->cb_entry,
-					&base->cpu_base->cb_pending);
+		if (!base->first)
 			continue;
+
+		if (gst) {
+			hrtimer_get_softirq_time(cpu_base);
+			gst = 0;
 		}
 
-		__run_hrtimer(timer);
-	}
-	spin_unlock(&cpu_base->lock);
-}
+		if (base->get_softirq_time)
+			base->softirq_time = base->get_softirq_time();
 
-void hrtimer_run_queues(void)
-{
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-	int i;
+		spin_lock(&cpu_base->lock);
 
-	if (hrtimer_hres_active())
-		return;
+		while ((node = base->first)) {
+			struct hrtimer *timer;
 
-	hrtimer_get_softirq_time(cpu_base);
+			timer = rb_entry(node, struct hrtimer, node);
+			if (base->softirq_time.tv64 <= timer->expires.tv64)
+				break;
+
+			if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
+				__remove_hrtimer(timer, base,
+					HRTIMER_STATE_PENDING, 0);
+				list_add_tail(&timer->cb_entry,
+					&base->cpu_base->cb_pending);
+				continue;
+			}
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
-		run_hrtimer_queue(cpu_base, i);
+			__run_hrtimer(timer);
+		}
+		spin_unlock(&cpu_base->lock);
+	}
 }
 
 /*
