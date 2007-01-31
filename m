Return-Path: <linux-kernel-owner+w=401wt.eu-S932521AbXAaDiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbXAaDiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXAaDiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:38:19 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65156 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932521AbXAaDiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:38:18 -0500
Message-Id: <20070131033805.183466048@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:17 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 07/23] clocksource: rating sorted list
Content-Disposition: inline; filename=clocksource_priority_sorted_list.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Converts the original plain list into a sorted list based on the clock rating.
Later in my tree this allows some of the variables to be dropped since the
highest rated clock is always at the front of the list. This also does some
other nice things like allow the sysfs files to print the clocks in a more
interesting order. It's forward looking.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/kernel/tsc.c      |    2 
 arch/x86_64/kernel/tsc.c    |    2 
 include/linux/clocksource.h |    8 +-
 kernel/time/clocksource.c   |  132 +++++++++++++++++++++++++++++---------------
 4 files changed, 96 insertions(+), 48 deletions(-)

Index: linux-2.6.19/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.19/arch/i386/kernel/tsc.c
@@ -325,7 +325,7 @@ static int tsc_update_callback(void)
 	/* check to see if we should switch to the safe clocksource: */
 	if (clocksource_tsc.rating != 0 && check_tsc_unstable()) {
 		clocksource_tsc.rating = 0;
-		clocksource_reselect();
+		clocksource_rating_change(&clocksource_tsc);
 		change = 1;
 	}
 
Index: linux-2.6.19/arch/x86_64/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/x86_64/kernel/tsc.c
+++ linux-2.6.19/arch/x86_64/kernel/tsc.c
@@ -229,7 +229,7 @@ static int tsc_update_callback(void)
 	/* check to see if we should switch to the safe clocksource: */
 	if (clocksource_tsc.rating != 50 && check_tsc_unstable()) {
 		clocksource_tsc.rating = 50;
-		clocksource_reselect();
+		clocksource_rating_change(&clocksource_tsc);
 		change = 1;
 	}
 	return change;
Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -12,6 +12,8 @@
 #include <linux/timex.h>
 #include <linux/time.h>
 #include <linux/list.h>
+#include <linux/sysdev.h>
+
 #include <asm/div64.h>
 #include <asm/io.h>
 
@@ -189,9 +191,9 @@ static inline void clocksource_calculate
 
 
 /* used to install a new clocksource */
-int clocksource_register(struct clocksource*);
-void clocksource_reselect(void);
-struct clocksource* clocksource_get_next(void);
+extern struct clocksource *clocksource_get_next(void);
+extern int clocksource_register(struct clocksource*);
+extern void clocksource_rating_change(struct clocksource*);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -35,7 +35,7 @@
  * next_clocksource:
  *	pending next selected clocksource.
  * clocksource_list:
- *	linked list with the registered clocksources
+ *	rating sorted linked list with the registered clocksources
  * clocksource_lock:
  *	protects manipulations to curr_clocksource and next_clocksource
  *	and the clocksource_list
@@ -80,69 +80,105 @@ struct clocksource *clocksource_get_next
 }
 
 /**
- * select_clocksource - Finds the best registered clocksource.
+ * __is_registered - Returns a clocksource if it's registered
+ * @name:		name of the clocksource to return
  *
  * Private function. Must hold clocksource_lock when called.
  *
- * Looks through the list of registered clocksources, returning
- * the one with the highest rating value. If there is a clocksource
- * name that matches the override string, it returns that clocksource.
+ * Returns the clocksource if registered, zero otherwise.
+ * If no clocksources are registered the jiffies clock is
+ * returned.
  */
-static struct clocksource *select_clocksource(void)
+static struct clocksource * __is_registered(char * name)
 {
-	struct clocksource *best = NULL;
 	struct list_head *tmp;
 
 	list_for_each(tmp, &clocksource_list) {
 		struct clocksource *src;
 
 		src = list_entry(tmp, struct clocksource, list);
-		if (!best)
-			best = src;
-
-		/* check for override: */
-		if (strlen(src->name) == strlen(override_name) &&
-		    !strcmp(src->name, override_name)) {
-			best = src;
-			break;
-		}
-		/* pick the highest rating: */
-		if (src->rating > best->rating)
-		 	best = src;
+		if (!strcmp(src->name, name))
+			return src;
 	}
 
-	return best;
+	return 0;
 }
 
 /**
- * is_registered_source - Checks if clocksource is registered
- * @c:		pointer to a clocksource
+ * __get_clock - Finds a specific clocksource
+ * @name:		name of the clocksource to return
  *
- * Private helper function. Must hold clocksource_lock when called.
+ * Private function. Must hold clocksource_lock when called.
  *
- * Returns one if the clocksource is already registered, zero otherwise.
+ * Returns the clocksource if registered, zero otherwise.
+ * If the @name is null the highest rated clock is returned.
  */
-static int is_registered_source(struct clocksource *c)
+static inline struct clocksource * __get_clock(char * name)
+{
+
+	if (unlikely(list_empty(&clocksource_list)))
+		return &clocksource_jiffies;
+
+	if (!name)
+		return list_entry(clocksource_list.next,
+				  struct clocksource, list);
+
+	return __is_registered(name);
+}
+
+/**
+ * select_clocksource - Finds the best registered clocksource.
+ *
+ * Private function. Must hold clocksource_lock when called.
+ *
+ * Looks through the list of registered clocksources, returning
+ * the one with the highest rating value. If there is a clocksource
+ * name that matches the override string, it returns that clocksource.
+ */
+static struct clocksource *select_clocksource(void)
+{
+	if (!*override_name)
+		return list_entry(clocksource_list.next,
+				  struct clocksource, list);
+
+	return __get_clock(override_name);
+}
+
+/*
+ * __sorted_list_add - Sorted clocksource add
+ * @c:			clocksource to add
+ *
+ * Adds a clocksource to the clocksource_list in sorted order.
+ */
+static void __sorted_list_add(struct clocksource *c)
 {
-	int len = strlen(c->name);
 	struct list_head *tmp;
 
 	list_for_each(tmp, &clocksource_list) {
 		struct clocksource *src;
 
 		src = list_entry(tmp, struct clocksource, list);
-		if (strlen(src->name) == len &&	!strcmp(src->name, c->name))
-			return 1;
+
+		if (c->rating > src->rating) {
+			list_add_tail(&c->list, &src->list);
+			return;
+		}
 	}
 
-	return 0;
+	/*
+	 * If it's bigger/smaller than all the other entries put it
+	 * at the end.
+	 */
+	list_add_tail(&c->list, &clocksource_list);
 }
 
 /**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
  *
- * Returns -EBUSY if registration fails, zero otherwise.
+ * Returns -EBUSY clock is already registered,
+ * Returns -EINVAL if clocksource is invalid,
+ * Return zero otherwise.
  */
 int clocksource_register(struct clocksource *c)
 {
@@ -150,14 +186,13 @@ int clocksource_register(struct clocksou
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	/* check if clocksource is already registered */
-	if (is_registered_source(c)) {
-		printk("register_clocksource: Cannot register %s. "
+	if (unlikely(!list_empty(&c->list) && __is_registered(c->name))) {
+		printk("register_clocksource: Cannot register %s clocksource. "
 		       "Already registered!", c->name);
 		ret = -EBUSY;
 	} else {
-		/* register it */
- 		list_add(&c->list, &clocksource_list);
+		INIT_LIST_HEAD(&c->list);
+ 		__sorted_list_add(c);
 		/* scan the registered clocksources, and pick the best one */
 		next_clocksource = select_clocksource();
 	}
@@ -167,21 +202,31 @@ int clocksource_register(struct clocksou
 EXPORT_SYMBOL(clocksource_register);
 
 /**
- * clocksource_reselect - Rescan list for next clocksource
+ * clocksource_rating_change - Allows dynamic rating changes for register
+ *                           clocksources.
  *
- * A quick helper function to be used if a clocksource changes its
- * rating. Forces the clocksource list to be re-scanned for the best
- * clocksource.
+ * Signals that a clocksource is dynamically changing it's rating.
+ * This could happen if a clocksource becomes more/less stable.
  */
-void clocksource_reselect(void)
+void clocksource_rating_change(struct clocksource *c)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&clocksource_lock, flags);
+	if (unlikely(list_empty(&c->list)))
+		return;
+
+  	spin_lock_irqsave(&clocksource_lock, flags);
+
+	/*
+	 * Re-register the clocksource with it's new rating.
+	 */
+	list_del_init(&c->list);
+	__sorted_list_add(c);
+
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
-EXPORT_SYMBOL(clocksource_reselect);
+EXPORT_SYMBOL(clocksource_rating_change);
 
 #ifdef CONFIG_SYSFS
 /**
@@ -247,7 +292,8 @@ static ssize_t sysfs_override_clocksourc
  * @dev:	unused
  * @buf:	char buffer to be filled with clocksource list
  *
- * Provides sysfs interface for listing registered clocksources
+ * Provides sysfs interface for listing registered clocksources.
+ * Output in priority sorted order.
  */
 static ssize_t
 sysfs_show_available_clocksources(struct sys_device *dev, char *buf)

-- 
