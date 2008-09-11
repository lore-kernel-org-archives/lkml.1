Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYIKDbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYIKDbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 23:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYIKDal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 23:30:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:33114 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbYIKDak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 23:30:40 -0400
Date: Wed, 10 Sep 2008 20:30:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       peterz@infradead.org, tglx@tglx.de
Subject: [PATCH 3/3] hrtimer: peek at the timer queue just before going idle
Message-ID: <20080910203025.0b88cc7e@infradead.org>
In-Reply-To: <20080910202803.42b5f251@infradead.org>
References: <20080910202803.42b5f251@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: peek at the timer queue just before going idle

As part of going idle, we already look at the time of the next timer event to determine
which C-state to select etc.

This patch adds functionality that causes the timers that are past their
soft expire time, to fire at this time, before we calculate the next wakeup
time. This functionality will thus avoid wakeups by running timers before
going idle rather than specially waking up for it.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/cpuidle/cpuidle.c |    7 +++++++
 include/linux/hrtimer.h   |    5 +++++
 kernel/hrtimer.c          |   30 ++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 5ce07b5..2e31484 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -16,6 +16,7 @@
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
 #include <linux/ktime.h>
+#include <linux/hrtimer.h>
 
 #include "cpuidle.h"
 
@@ -60,6 +61,12 @@ static void cpuidle_idle_call(void)
 		return;
 	}
 
+	/*
+	 * run any timers that can be run now, at this point
+	 * before calculating the idle duration etc.
+	 */
+	hrtimer_peek_ahead_timers();
+
 	/* ask the governor for the next state */
 	next_state = cpuidle_curr_governor->select(dev);
 	if (need_resched())
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 301c2c8..1ca3978 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -326,6 +326,11 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
 
+
+DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
+extern void hrtimer_peek_ahead_timers(void);
+
+
 /* Exported timer functions: */
 
 /* Initialize timers: */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b1dacd3..d152c46 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1381,6 +1381,36 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 		raise_softirq(HRTIMER_SOFTIRQ);
 }
 
+/**
+ * hrtimer_peek_ahead_timers -- run soft-expired timers now
+ *
+ * hrtimer_peek_ahead_timers will peek at the timer queue of
+ * the current cpu and check if there are any timers for which
+ * the soft expires time has passed. If any such timers exist,
+ * they are run immediately and then removed from the timer queue.
+ *
+ */
+void hrtimer_peek_ahead_timers(void)
+{
+	unsigned long flags;
+	struct tick_device *td;
+	struct clock_event_device *dev;
+
+	if (hrtimer_hres_active())
+		return;
+
+	local_irq_save(flags);
+	td = &__get_cpu_var(tick_cpu_device);
+	if (!td)
+		goto out;
+	dev = td->evtdev;
+	if (!dev)
+		goto out;
+	hrtimer_interrupt(dev);
+out:
+	local_irq_restore(flags);	
+}
+
 static void run_hrtimer_softirq(struct softirq_action *h)
 {
 	run_hrtimer_pending(&__get_cpu_var(hrtimer_bases));
-- 
1.5.5.1


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
