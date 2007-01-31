Return-Path: <linux-kernel-owner+w=401wt.eu-S932752AbXAaDro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752AbXAaDro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932711AbXAaDnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:43:45 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:1188 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932692AbXAaDnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:43:40 -0500
Message-Id: <20070131033804.547473058@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:15 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Subject: [PATCH 05/23] clocksource: drop simplify-the-registration-of-clocksources.patch
Content-Disposition: inline; filename=drop-simplify-the-registration-of-clocksources.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Drop.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 include/linux/clocksource.h |    3 -
 kernel/time/clocksource.c   |  118 ++++++++++++++++++++++----------------------
 2 files changed, 61 insertions(+), 60 deletions(-)

Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -198,7 +198,4 @@ static inline void update_vsyscall(struc
 }
 #endif
 
-#define clocksource_reselect()	clocksource_change_rating(&clocksource_tsc, clocksource_tsc.rating)
-extern void clocksource_change_rating(struct clocksource *cs, int rating);
-
 #endif /* _LINUX_CLOCKSOURCE_H */
Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -47,7 +47,6 @@ extern struct clocksource clocksource_ji
  */
 static struct clocksource *curr_clocksource = &clocksource_jiffies;
 static struct clocksource *next_clocksource;
-static struct clocksource *clocksource_override;
 static LIST_HEAD(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
 static char override_name[32];
@@ -84,46 +83,60 @@ struct clocksource *clocksource_get_next
 }
 
 /**
- * select_clocksource - Selects the best registered clocksource.
+ * select_clocksource - Finds the best registered clocksource.
  *
  * Private function. Must hold clocksource_lock when called.
  *
- * Select the clocksource with the best rating, or the clocksource,
- * which is selected by userspace override.
+ * Looks through the list of registered clocksources, returning
+ * the one with the highest rating value. If there is a clocksource
+ * name that matches the override string, it returns that clocksource.
  */
 static struct clocksource *select_clocksource(void)
 {
-	if (list_empty(&clocksource_list))
-		return NULL;
+	struct clocksource *best = NULL;
+	struct list_head *tmp;
+
+	list_for_each(tmp, &clocksource_list) {
+		struct clocksource *src;
 
-	if (clocksource_override)
-		return clocksource_override;
+		src = list_entry(tmp, struct clocksource, list);
+		if (!best)
+			best = src;
+
+		/* check for override: */
+		if (strlen(src->name) == strlen(override_name) &&
+		    !strcmp(src->name, override_name)) {
+			best = src;
+			break;
+		}
+		/* pick the highest rating: */
+		if (src->rating > best->rating)
+		 	best = src;
+	}
 
-	return list_entry(clocksource_list.next, struct clocksource, list);
+	return best;
 }
 
-/*
- * Enqueue the clocksource sorted by rating
+/**
+ * is_registered_source - Checks if clocksource is registered
+ * @c:		pointer to a clocksource
+ *
+ * Private helper function. Must hold clocksource_lock when called.
+ *
+ * Returns one if the clocksource is already registered, zero otherwise.
  */
-static int clocksource_enqueue(struct clocksource *c)
+static int is_registered_source(struct clocksource *c)
 {
-	struct list_head *tmp, *entry = &clocksource_list;
+	int len = strlen(c->name);
+	struct list_head *tmp;
 
 	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *cs;
+		struct clocksource *src;
 
-		cs = list_entry(tmp, struct clocksource, list);
-		if (cs == c)
-			return -EBUSY;
-		/* Keep track of the place, where to insert */
-		if (cs->rating >= c->rating)
-			entry = tmp;
+		src = list_entry(tmp, struct clocksource, list);
+		if (strlen(src->name) == len &&	!strcmp(src->name, c->name))
+			return 1;
 	}
-	list_add(&c->list, entry);
-
-	if (strlen(c->name) == strlen(override_name) &&
-	    !strcmp(c->name, override_name))
-		clocksource_override = c;
 
 	return 0;
 }
@@ -136,32 +149,42 @@ static int clocksource_enqueue(struct cl
  */
 int clocksource_register(struct clocksource *c)
 {
-	unsigned long flags;
 	int ret = 0;
+	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	ret = clocksource_enqueue(c);
-	if (!ret)
+	/* check if clocksource is already registered */
+	if (is_registered_source(c)) {
+		printk("register_clocksource: Cannot register %s. "
+		       "Already registered!", c->name);
+		ret = -EBUSY;
+	} else {
+		/* register it */
+ 		list_add(&c->list, &clocksource_list);
+		/* scan the registered clocksources, and pick the best one */
 		next_clocksource = select_clocksource();
+	}
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(clocksource_register);
 
 /**
- * clocksource_change_rating - Change the rating of a registered clocksource
+ * clocksource_reselect - Rescan list for next clocksource
  *
+ * A quick helper function to be used if a clocksource changes its
+ * rating. Forces the clocksource list to be re-scanned for the best
+ * clocksource.
  */
-void clocksource_change_rating(struct clocksource *cs, int rating)
+void clocksource_reselect(void)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	list_del(&cs->list);
-	clocksource_enqueue(cs);
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
+EXPORT_SYMBOL(clocksource_reselect);
 
 #ifdef CONFIG_SYSFS
 /**
@@ -197,11 +220,7 @@ sysfs_show_current_clocksources(struct s
 static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 					  const char *buf, size_t count)
 {
-	struct clocksource *ovr = NULL;
-	struct list_head *tmp;
 	size_t ret = count;
-	int len;
-
 	/* strings from sysfs write are not 0 terminated! */
 	if (count >= sizeof(override_name))
 		return -EINVAL;
@@ -209,32 +228,17 @@ static ssize_t sysfs_override_clocksourc
 	/* strip of \n: */
 	if (buf[count-1] == '\n')
 		count--;
+	if (count < 1)
+		return -EINVAL;
 
 	spin_lock_irq(&clocksource_lock);
 
-	if (count > 0)
-		memcpy(override_name, buf, count);
+	/* copy the name given: */
+	memcpy(override_name, buf, count);
 	override_name[count] = 0;
 
-	len = strlen(override_name);
-	if (len) {
-		ovr = clocksource_override;
-		/* try to select it: */
-		list_for_each(tmp, &clocksource_list) {
-			struct clocksource *cs;
-
-			cs = list_entry(tmp, struct clocksource, list);
-			if (strlen(cs->name) == len &&
-			    !strcmp(cs->name, override_name))
-				ovr = cs;
-		}
-	}
-
-	/* Reselect, when the override name has changed */
-	if (ovr != clocksource_override) {
-		clocksource_override = ovr;
-		next_clocksource = select_clocksource();
-	}
+	/* try to select it: */
+	next_clocksource = select_clocksource();
 
 	spin_unlock_irq(&clocksource_lock);
 

-- 
