Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXAaDlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXAaDlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932663AbXAaDkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:40:47 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65417 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932612AbXAaDk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:40:26 -0500
Message-Id: <20070131033809.923199123@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:32 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 22/23] clocksource: new clock lookup method
Content-Disposition: inline; filename=clocksource_unstable_api_calls.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the current clocksource API so that clocks
can be masked if they have specific negative qualities. For 
instance, if a clock is not atomic you can choose not to include 
it in the list you select from, atomic in this case being lockless. 

The following qualities can be masked off,

#define CLOCKSOURCE_NOT_CONTINUOUS      1
#define CLOCKSOURCE_UNSTABLE            2
#define CLOCKSOURCE_NOT_ATOMIC          4
#define CLOCKSOURCE_UNDER_32BITS        8
#define CLOCKSOURCE_64BITS              16
#define CLOCKSOURCE_PM_AFFECTED         32

I modify the .flags to accomplish this.

The reasoning behind this is that it's not interesting to have a
positive "rating" value, and have a positive flags value. 

For instance, if the clock has a high rating you assume it's continuous.
The selection process isn't helped by stating "continuous" in the flags.

The point is to list all the negative side effects that some clocks have
which the programmer knows in advance that their code can not tolerate.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 include/linux/clocksource.h |   35 +++++++++++++++++++++++++-------
 kernel/time/clocksource.c   |   47 ++++++++++++++++++--------------------------
 kernel/time/jiffies.c       |    1 
 kernel/time/timekeeping.c   |   11 ++++++----
 4 files changed, 55 insertions(+), 39 deletions(-)

Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -30,6 +30,11 @@ extern struct clocksource clocksource_ji
 extern struct sys_device clocksource_sys_device;
 
 /*
+ * Read function type.
+ */
+typedef cycle_t (*clock_read_t)(void);
+
+/*
  * Allows inlined calling for notifier routines.
  */
 extern struct atomic_notifier_head clocksource_list_notifier;
@@ -40,6 +45,7 @@ extern struct atomic_notifier_head clock
 #define CLOCKSOURCE_NOTIFY_REGISTER	1
 #define CLOCKSOURCE_NOTIFY_RATING	2
 #define CLOCKSOURCE_NOTIFY_FREQ		4
+#define CLOCKSOURCE_NOTIFY_UNSTABLE	8
 
 /*
  * Defined so the initcall can be changes without touching
@@ -119,12 +125,6 @@ struct clocksource {
 	s64 error;
 };
 
-/*
- * Clock source flags bits::
- */
-#define CLOCK_SOURCE_IS_CONTINUOUS	0x01
-#define CLOCK_SOURCE_MUST_VERIFY	0x02
-
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)(bits<64 ? ((1ULL<<bits)-1) : -1)
 
@@ -235,6 +235,9 @@ static inline void clocksource_calculate
 	c->xtime_interval = (u64)c->cycle_interval * c->mult;
 }
 
+/*
+ * Clocksource flags
+ */
 #define CLOCKSOURCE_NOT_CONTINUOUS	1
 #define CLOCKSOURCE_UNSTABLE		2
 #define CLOCKSOURCE_NOT_ATOMIC		4
@@ -243,9 +246,25 @@ static inline void clocksource_calculate
 #define CLOCKSOURCE_PM_AFFECTED		32
 
 /* used to install a new clocksource */
+extern void clocksource_mark_unstable(struct clocksource *);
+extern struct clocksource *clocksource_get_unstable(void);
 extern int clocksource_register(struct clocksource*);
 extern void clocksource_rating_change(struct clocksource*);
-extern struct clocksource * clocksource_get_clock(char*);
+extern struct clocksource * clocksource_get_clock(char*, unsigned long);
+
+
+/**
+ * clocksource_get_masked_clock - Finds highest rated clocksource w/o mask
+ * @mask:		Clocksource features that are not wanted.
+ *
+ * Returns the highest rated clocksource that doesn't have any of the bits set
+ * in mask. If none are register the jiffies clock is returned. If all the clocks
+ * have the mask bits set, then NULL is returned.
+ */
+static inline struct clocksource * clocksource_get_masked_clock(unsigned long mask)
+{
+	return clocksource_get_clock(NULL, mask);
+}
 
 /**
  * clocksource_get_best_clock - Finds highest rated clocksource
@@ -255,7 +274,7 @@ extern struct clocksource * clocksource_
  */
 static inline struct clocksource * clocksource_get_best_clock(void)
 {
-	return clocksource_get_clock(NULL);
+	return clocksource_get_clock(NULL, 0);
 }
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -51,7 +51,8 @@ ATOMIC_NOTIFIER_HEAD(clocksource_list_no
  * If no clocksources are registered the jiffies clock is
  * returned.
  */
-static struct clocksource * __is_registered(char * name)
+static inline
+struct clocksource * __is_registered(char * name, unsigned long mask)
 {
 	struct list_head *tmp;
 
@@ -59,7 +60,11 @@ static struct clocksource * __is_registe
 		struct clocksource *src;
 
 		src = list_entry(tmp, struct clocksource, list);
-		if (!strcmp(src->name, name))
+		if (name) {
+			if (!strcmp(src->name, name))
+				return src;
+
+		} else if (!(src->flags & mask))
 			return src;
 	}
 
@@ -75,32 +80,34 @@ static struct clocksource * __is_registe
  * Returns the clocksource if registered, zero otherwise.
  * If the @name is null the highest rated clock is returned.
  */
-static inline struct clocksource * __get_clock(char * name)
+static inline struct clocksource * __get_clock(char * name, unsigned long mask)
 {
 
 	if (unlikely(list_empty(&clocksource_list)))
 		return &clocksource_jiffies;
 
-	if (!name)
+	if (!name && !mask)
 		return list_entry(clocksource_list.next,
 				  struct clocksource, list);
 
-	return __is_registered(name);
+	return __is_registered(name, mask);
 }
 
 /**
  * clocksource_get_clock - Finds a specific clocksource
  * @name:		name of the clocksource to return
+ * @mask:		Clocks with these flags set will
+ *			be ignored.
  *
  * Returns the clocksource if registered, zero otherwise.
  */
-struct clocksource * clocksource_get_clock(char * name)
+struct clocksource * clocksource_get_clock(char * name, unsigned long mask)
 {
 	struct clocksource * ret;
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	ret = __get_clock(name);
+	ret = __get_clock(name, mask);
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 	return ret;
 }
@@ -111,7 +118,7 @@ struct clocksource * clocksource_get_clo
  *
  * Adds a clocksource to the clocksource_list in sorted order.
  */
-static void __sorted_list_add(struct clocksource *c)
+static inline void __sorted_list_add(struct clocksource *c)
 {
 	struct list_head *tmp;
 
@@ -158,31 +165,17 @@ int clocksource_register(struct clocksou
 EXPORT_SYMBOL(clocksource_register);
 
 /**
- * clocksource_rating_change - Allows dynamic rating changes for register
- *                           clocksources.
+ * clocksource_mark_unstable - Mark the clocks as unstable.
  *
- * Signals that a clocksource is dynamically changing it's rating.
- * This could happen if a clocksource becomes more/less stable.
+ * This signals that this clock has become unstable.
  */
-void clocksource_rating_change(struct clocksource *c)
+void clocksource_mark_unstable(struct clocksource *c)
 {
-	unsigned long flags;
-
-  	spin_lock_irqsave(&clocksource_lock, flags);
-
-	/*
-	 * Re-register the clocksource with it's new rating.
-	 */
-	list_del_init(&c->list);
-	__sorted_list_add(c);
-
-	spin_unlock_irqrestore(&clocksource_lock, flags);
+	c->flags |= CLOCKSOURCE_UNSTABLE;
 
 	atomic_notifier_call_chain(&clocksource_list_notifier,
-				   CLOCKSOURCE_NOTIFY_RATING, c);
-
+				   CLOCKSOURCE_NOTIFY_UNSTABLE, c);
 }
-EXPORT_SYMBOL(clocksource_rating_change);
 
 #ifdef CONFIG_SYSFS
 /**
Index: linux-2.6.19/kernel/time/jiffies.c
===================================================================
--- linux-2.6.19.orig/kernel/time/jiffies.c
+++ linux-2.6.19/kernel/time/jiffies.c
@@ -62,6 +62,7 @@ struct clocksource clocksource_jiffies =
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
 	.shift		= JIFFIES_SHIFT,
+	.flags		= CLOCKSOURCE_NOT_CONTINUOUS, /* not free running */
 };
 
 static int __init init_jiffies_clocksource(void)
Index: linux-2.6.19/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.19.orig/kernel/time/timekeeping.c
+++ linux-2.6.19/kernel/time/timekeeping.c
@@ -181,9 +181,12 @@ static void timekeeping_change_clocksour
 	u64 nsec;
 
 	if (!*override_name)
-		new = clocksource_get_clock(NULL);
+		/*
+		 * Mask off unstable clocks.
+		 */
+		new = clocksource_get_masked_clock(CLOCKSOURCE_UNSTABLE);
 	else
-		new = clocksource_get_clock(override_name);
+		new = clocksource_get_clock(override_name, 0);
 
 	if (clock != new) {
 		now = clocksource_read(new);
@@ -216,7 +219,7 @@ int timekeeping_is_continuous(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		ret = clock->flags & CLOCK_SOURCE_IS_CONTINUOUS;
+		ret = !(clock->flags & CLOCKSOURCE_NOT_CONTINUOUS);
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -231,7 +234,7 @@ clocksource_callback(struct notifier_blo
 
 	switch (op) {
 		case CLOCKSOURCE_NOTIFY_FREQ:
-		case CLOCKSOURCE_NOTIFY_RATING:
+		case CLOCKSOURCE_NOTIFY_UNSTABLE:
 			atomic_inc(&clock_check);
 	}
 

-- 
