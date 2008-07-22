Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbYGVDDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbYGVDDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 23:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbYGVDCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 23:02:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:57605 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbYGVDCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 23:02:54 -0400
Subject: [RFC] Imprecise timers.
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       arjan@infradead.org
Content-Type: text/plain
Organization: Intel Corporation
Date: Mon, 21 Jul 2008 23:02:36 -0400
Message-Id: <1216695757.18980.16.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many users of timers don't really care too much about exactly when their
timer fires -- and waking a CPU to satisfy such a timer is a waste of
power. This patch implements a 'range' timer which will fire at a 'convenient'
moment within given constraints.

It's implemented by a deferrable timer at the beginning of the range,
which will run some time later when the CPU happens to be awake. And a
non-deferrable timer at the hard deadline, to ensure it really does
happen by then.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 include/linux/timer.h |  101 ++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/timer.c        |   18 +++++---
 2 files changed, 110 insertions(+), 9 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index d4ba792..163137c 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -23,22 +23,60 @@ struct timer_list {
 #endif
 };
 
+/* This can probably be optimised somehow, but for now we do it the
+   simple way: two timers, one deferrable and one for the deadline. */
+struct range_timer {
+	struct timer_list early;
+	struct timer_list deadline;
+	void (*function)(unsigned long);
+	unsigned long data;
+};
+
 extern struct tvec_base boot_tvec_bases;
+/*
+ * Note that all tvec_bases are 2 byte aligned and lower bit of
+ * base in timer_list is guaranteed to be zero. Use the LSB for
+ * the new flag to indicate whether the timer is deferrable
+ */
+#define TBASE_DEFERRABLE_FLAG		(0x1)
 
-#define TIMER_INITIALIZER(_function, _expires, _data) {		\
+#define __TIMER_INITIALIZER(_function, _expires, _data, _base) {\
 		.entry = { .prev = TIMER_ENTRY_STATIC },	\
 		.function = (_function),			\
 		.expires = (_expires),				\
 		.data = (_data),				\
-		.base = &boot_tvec_bases,			\
+		.base = (struct tvec_base *)(_base),		\
 	}
+#define TIMER_INITIALIZER(_function, _expires, _data)		\
+	__TIMER_INITIALIZER(_function, _expires, _data, &boot_tvec_bases)
+
+#define TIMER_INITIALIZER_DEFERRABLE(_function, _expires, _data)	\
+	__TIMER_INITIALIZER(_function, _expires, _data,			\
+		(unsigned long)&boot_tvec_bases + TBASE_DEFERRABLE_FLAG)
+
+void range_timer_func(unsigned long timer);
 
 #define DEFINE_TIMER(_name, _function, _expires, _data)		\
 	struct timer_list _name =				\
 		TIMER_INITIALIZER(_function, _expires, _data)
 
+#define DEFINE_RANGE_TIMER(_name, _function, _expires, _deadline, _data)\
+	struct range_timer _name = {					\
+		.early = TIMER_INITIALIZER_DEFERRABLE(range_timer_func,	\
+			(_expires), (unsigned long)&(_name)),		\
+		.deadline = TIMER_INITIALIZER(range_timer_func,		\
+			(_deadline), (unsigned long)(&(_name))),	\
+		.function = (_function),				\
+		.data = (_data),					\
+	}
+
 void init_timer(struct timer_list *timer);
 void init_timer_deferrable(struct timer_list *timer);
+static inline void init_range_timer(struct range_timer *timer)
+{
+	init_timer_deferrable(&timer->early);
+	init_timer(&timer->deadline);
+}
 
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
 extern void init_timer_on_stack(struct timer_list *timer);
@@ -51,6 +89,19 @@ static inline void init_timer_on_stack(struct timer_list *timer)
 }
 #endif
 
+static inline void setup_range_timer(struct range_timer *timer,
+				     void (*function)(unsigned long),
+				     unsigned long data)
+{
+	timer->early.function = range_timer_func;
+	timer->early.data = (unsigned long)timer;
+	timer->deadline.function = range_timer_func;
+	timer->deadline.data = (unsigned long)timer;
+	timer->function = function;
+	timer->data = data;
+
+	init_range_timer(timer);
+}
 static inline void setup_timer(struct timer_list * timer,
 				void (*function)(unsigned long),
 				unsigned long data)
@@ -83,12 +134,54 @@ static inline int timer_pending(const struct timer_list * timer)
 {
 	return timer->entry.next != NULL;
 }
+static inline int range_timer_pending(const struct range_timer *timer)
+{
+	return timer_pending(&timer->early) || timer_pending(&timer->deadline);
+}
 
 extern void add_timer_on(struct timer_list *timer, int cpu);
 extern int del_timer(struct timer_list * timer);
 extern int __mod_timer(struct timer_list *timer, unsigned long expires);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
 
+static inline void add_range_timer_on(struct range_timer *timer, int cpu)
+{
+	add_timer_on(&timer->early, cpu);
+	add_timer_on(&timer->deadline, cpu);
+}
+static inline int del_range_timer(struct range_timer *timer)
+{
+	return del_timer(&timer->early) | del_timer(&timer->deadline);
+}
+static inline int __mod_range_timer(struct range_timer *timer,
+				    unsigned long expires,
+				    unsigned long deadline)
+{
+	int ret;
+	WARN_ON(deadline < expires);
+	/* We need them on the same CPU */
+	preempt_disable();
+	ret = __mod_timer(&timer->early, expires);
+	ret |= __mod_timer(&timer->deadline, deadline);
+	preempt_enable();
+
+	return ret;
+}
+
+static inline int mod_range_timer(struct range_timer *timer,
+				  unsigned long expires,
+				  unsigned long deadline)
+{
+	int ret;
+	WARN_ON(deadline < expires);
+	/* We need them on the same CPU */
+	preempt_disable();
+	ret = mod_timer(&timer->early, expires);
+	ret |= mod_timer(&timer->deadline, deadline);
+	preempt_enable();
+
+	return ret;
+}
 /*
  * The jiffies value which is added to now, when there is no timer
  * in the timer wheel:
@@ -174,6 +267,10 @@ static inline void add_timer(struct timer_list *timer)
 # define del_timer_sync(t)		del_timer(t)
 #endif
 
+static inline int del_range_timer_sync(struct range_timer *timer)
+{
+	return del_timer_sync(&timer->early) | del_timer_sync(&timer->deadline);
+}
 #define del_singleshot_timer_sync(t) del_timer_sync(t)
 
 extern void init_timers(void);
diff --git a/kernel/timer.c b/kernel/timer.c
index 03bc7f1..e114f08 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -81,13 +81,6 @@ struct tvec_base boot_tvec_bases;
 EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
 
-/*
- * Note that all tvec_bases are 2 byte aligned and lower bit of
- * base in timer_list is guaranteed to be zero. Use the LSB for
- * the new flag to indicate whether the timer is deferrable
- */
-#define TBASE_DEFERRABLE_FLAG		(0x1)
-
 /* Functions below help us manage 'deferrable' flag */
 static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
 {
@@ -1525,3 +1518,14 @@ unsigned long msleep_interruptible(unsigned int msecs)
 }
 
 EXPORT_SYMBOL(msleep_interruptible);
+
+void range_timer_func(unsigned long t)
+{
+	struct range_timer *timer = (void *)t;
+
+	del_timer(&timer->early);
+	del_timer(&timer->deadline);
+
+	timer->function(timer->data);
+}
+EXPORT_SYMBOL_GPL(range_timer_func);
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


