Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbYIAXQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbYIAXQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYIAXP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:15:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:40551 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYIAXPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:15:24 -0400
Date: Mon, 1 Sep 2008 16:13:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 11/13] hrtimer: turn hrtimers into range timers
Message-ID: <20080901161336.10a71c9f@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
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
Subject: [PATCH] hrtimer: turn hrtimers into range timers

this patch turns hrtimers into range timers; they have 2 expire points
1) the soft expire point
2) the hard expire point

the kernel will do it's regular best effort attempt to get the timer run
at the hard expire point. However, if some other time fires after the soft
expire point, the kernel now has the freedom to fire this timer at this point,
and thus grouping the events and preventing a power-expensive wakeup in the
future.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/hrtimer.h |   31 ++++++++++++++++++++++++++++++-
 kernel/hrtimer.c        |   43 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 485a634..c26b1a5 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -112,6 +112,7 @@ enum hrtimer_cb_mode {
 struct hrtimer {
 	struct rb_node			node;
 	ktime_t				_expires;
+	ktime_t				_softexpires;
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
 	unsigned long			state;
@@ -220,20 +221,37 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 static inline void hrtimer_set_expires(struct hrtimer *timer, ktime_t time)
 {
 	timer->_expires = time;
+	timer->_softexpires = time;
 }
+
+static inline void hrtimer_set_expires_range(struct hrtimer *timer, ktime_t time, ktime_t delta)
+{
+	timer->_softexpires = time;
+	timer->_expires = ktime_add_safe(time, delta);
+}
+
+static inline void hrtimer_set_expires_range_ns(struct hrtimer *timer, ktime_t time, unsigned long delta)
+{
+	timer->_softexpires = time;
+	timer->_expires = ktime_add_ns(time, delta);
+}
+
 static inline void hrtimer_set_expires_tv64(struct hrtimer *timer, s64 tv64)
 {
 	timer->_expires.tv64 = tv64;
+	timer->_softexpires.tv64 = tv64;
 }
 
 static inline void hrtimer_add_expires(struct hrtimer *timer, ktime_t time)
 {
 	timer->_expires = ktime_add_safe(timer->_expires, time);
+	timer->_softexpires = ktime_add_safe(timer->_softexpires, time);
 }
 
 static inline void hrtimer_add_expires_ns(struct hrtimer *timer, unsigned long ns)
 {
 	timer->_expires = ktime_add_ns(timer->_expires, ns);
+	timer->_softexpires = ktime_add_ns(timer->_softexpires, ns);
 }
 
 static inline ktime_t hrtimer_get_expires(const struct hrtimer *timer)
@@ -241,10 +259,19 @@ static inline ktime_t hrtimer_get_expires(const struct hrtimer *timer)
 	return timer->_expires;
 }
 
+static inline ktime_t hrtimer_get_softexpires(const struct hrtimer *timer)
+{
+	return timer->_expires;
+}
+
 static inline s64 hrtimer_get_expires_tv64(const struct hrtimer *timer)
 {
 	return timer->_expires.tv64;
 }
+static inline s64 hrtimer_get_softexpires_tv64(const struct hrtimer *timer)
+{
+	return timer->_softexpires.tv64;
+}
 
 static inline s64 hrtimer_get_expires_ns(const struct hrtimer *timer)
 {
@@ -334,7 +361,7 @@ static inline int hrtimer_start_expires(struct hrtimer *timer,
 
 static inline int hrtimer_restart(struct hrtimer *timer)
 {
-	return hrtimer_start(timer, timer->_expires, HRTIMER_MODE_ABS);
+	return hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
 }
 
 /* Query timers: */
@@ -391,6 +418,8 @@ extern long hrtimer_nanosleep_restart(struct restart_block *restart_block);
 extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
 				 struct task_struct *tsk);
 
+extern int schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
+						const enum hrtimer_mode mode);
 extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
 
 /* Soft interrupt function to run the hrtimer queues: */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ae307fe..dc1ded0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1309,7 +1309,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 
 			timer = rb_entry(node, struct hrtimer, node);
 
-			if (basenow.tv64 < hrtimer_get_expires_tv64(timer)) {
+			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer)) {
 				ktime_t expires;
 
 				expires = ktime_sub(hrtimer_get_expires(timer),
@@ -1681,14 +1681,20 @@ void __init hrtimers_init(void)
 }
 
 /**
- * schedule_hrtimeout - sleep until timeout
+ * schedule_hrtimeout_range - sleep until timeout
  * @expires:	timeout value (ktime_t)
+ * @delta:	slack in expires timeout (ktime_t)
  * @mode:	timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
  *
  * Make the current task sleep until the given expiry time has
  * elapsed. The routine will return immediately unless
  * the current task state has been set (see set_current_state()).
  *
+ * The @delta argument gives the kernel the freedom to schedule the
+ * actual wakeup to a time that is both power and performance friendly.
+ * The kernel give the normal best effort behavior for "@expires+@delta",
+ * but may decide to fire the timer earlier, but no earlier than @expires.
+ *
  * You can set the task state as follows -
  *
  * %TASK_UNINTERRUPTIBLE - at least @timeout time is guaranteed to
@@ -1702,7 +1708,7 @@ void __init hrtimers_init(void)
  *
  * Returns 0 when the timer has expired otherwise -EINTR
  */
-int __sched schedule_hrtimeout(ktime_t *expires,
+int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
 			       const enum hrtimer_mode mode)
 {
 	struct hrtimer_sleeper t;
@@ -1726,7 +1732,7 @@ int __sched schedule_hrtimeout(ktime_t *expires,
 	}
 
 	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, mode);
-	hrtimer_set_expires(&t.timer, *expires);
+	hrtimer_set_expires_range_ns(&t.timer, *expires, delta);
 
 	hrtimer_init_sleeper(&t, current);
 
@@ -1744,4 +1750,33 @@ int __sched schedule_hrtimeout(ktime_t *expires,
 
 	return !t.task ? 0 : -EINTR;
 }
+EXPORT_SYMBOL_GPL(schedule_hrtimeout_range);
+
+/**
+ * schedule_hrtimeout - sleep until timeout
+ * @expires:	timeout value (ktime_t)
+ * @mode:	timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
+ *
+ * Make the current task sleep until the given expiry time has
+ * elapsed. The routine will return immediately unless
+ * the current task state has been set (see set_current_state()).
+ *
+ * You can set the task state as follows -
+ *
+ * %TASK_UNINTERRUPTIBLE - at least @timeout time is guaranteed to
+ * pass before the routine returns.
+ *
+ * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
+ * delivered to the current task.
+ *
+ * The current task state is guaranteed to be TASK_RUNNING when this
+ * routine returns.
+ *
+ * Returns 0 when the timer has expired otherwise -EINTR
+ */
+int __sched schedule_hrtimeout(ktime_t *expires,
+			       const enum hrtimer_mode mode)
+{
+	return schedule_hrtimeout_range(expires, 0, mode);
+}
 EXPORT_SYMBOL_GPL(schedule_hrtimeout);
-- 
1.5.5.1

