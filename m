Return-Path: <linux-kernel-owner+w=401wt.eu-S933144AbXAWWN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144AbXAWWN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933143AbXAWWMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:12:09 -0500
Received: from www.osadl.org ([213.239.205.134]:35821 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933144AbXAWWAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:51 -0500
Message-Id: <20070123211204.224433000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 10/46] Simplify the registration of clocksources
Content-Disposition: inline; filename=clocksource-change-registration.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Enqueue clocksources in rating order to make selection of the
clocksource easier. Also check the match with an user override
at enqueue time.

Preparatory patch for the generic clocksource verification.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/time/clocksource.c |  118 ++++++++++++++++++++++------------------------
 1 file changed, 57 insertions(+), 61 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/kernel/time/clocksource.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/time/clocksource.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/time/clocksource.c
@@ -47,6 +47,7 @@ extern struct clocksource clocksource_ji
  */
 static struct clocksource *curr_clocksource = &clocksource_jiffies;
 static struct clocksource *next_clocksource;
+static struct clocksource *clocksource_override;
 static LIST_HEAD(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
 static char override_name[32];
@@ -83,60 +84,46 @@ struct clocksource *clocksource_get_next
 }
 
 /**
- * select_clocksource - Finds the best registered clocksource.
+ * select_clocksource - Selects the best registered clocksource.
  *
  * Private function. Must hold clocksource_lock when called.
  *
- * Looks through the list of registered clocksources, returning
- * the one with the highest rating value. If there is a clocksource
- * name that matches the override string, it returns that clocksource.
+ * Select the clocksource with the best rating, or the clocksource,
+ * which is selected by userspace override.
  */
 static struct clocksource *select_clocksource(void)
 {
-	struct clocksource *best = NULL;
-	struct list_head *tmp;
-
-	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *src;
+	if (list_empty(&clocksource_list))
+		return NULL;
 
-		src = list_entry(tmp, struct clocksource, list);
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
-	}
+	if (clocksource_override)
+		return clocksource_override;
 
-	return best;
+	return list_entry(clocksource_list.next, struct clocksource, list);
 }
 
-/**
- * is_registered_source - Checks if clocksource is registered
- * @c:		pointer to a clocksource
- *
- * Private helper function. Must hold clocksource_lock when called.
- *
- * Returns one if the clocksource is already registered, zero otherwise.
+/*
+ * Enqueue the clocksource sorted by rating
  */
-static int is_registered_source(struct clocksource *c)
+static int clocksource_enqueue(struct clocksource *c)
 {
-	int len = strlen(c->name);
-	struct list_head *tmp;
+	struct list_head *tmp, *entry = &clocksource_list;
 
 	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *src;
+		struct clocksource *cs;
 
-		src = list_entry(tmp, struct clocksource, list);
-		if (strlen(src->name) == len &&	!strcmp(src->name, c->name))
-			return 1;
+		cs = list_entry(tmp, struct clocksource, list);
+		if (cs == c)
+			return -EBUSY;
+		/* Keep track of the place, where to insert */
+		if (cs->rating >= c->rating)
+			entry = tmp;
 	}
+	list_add(&c->list, entry);
+
+	if (strlen(c->name) == strlen(override_name) &&
+	    !strcmp(c->name, override_name))
+		clocksource_override = c;
 
 	return 0;
 }
@@ -149,42 +136,32 @@ static int is_registered_source(struct c
  */
 int clocksource_register(struct clocksource *c)
 {
-	int ret = 0;
 	unsigned long flags;
+	int ret = 0;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	/* check if clocksource is already registered */
-	if (is_registered_source(c)) {
-		printk("register_clocksource: Cannot register %s. "
-		       "Already registered!", c->name);
-		ret = -EBUSY;
-	} else {
-		/* register it */
- 		list_add(&c->list, &clocksource_list);
-		/* scan the registered clocksources, and pick the best one */
+	ret = clocksource_enqueue(c);
+	if (!ret)
 		next_clocksource = select_clocksource();
-	}
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(clocksource_register);
 
 /**
- * clocksource_reselect - Rescan list for next clocksource
+ * clocksource_change_rating - Change the rating of a registered clocksource
  *
- * A quick helper function to be used if a clocksource changes its
- * rating. Forces the clocksource list to be re-scanned for the best
- * clocksource.
  */
-void clocksource_reselect(void)
+void clocksource_change_rating(struct clocksource *cs, int rating)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
+	list_del(&cs->list);
+	clocksource_enqueue(cs);
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
-EXPORT_SYMBOL(clocksource_reselect);
 
 #ifdef CONFIG_SYSFS
 /**
@@ -220,7 +197,11 @@ sysfs_show_current_clocksources(struct s
 static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 					  const char *buf, size_t count)
 {
+	struct clocksource *ovr = NULL;
+	struct list_head *tmp;
 	size_t ret = count;
+	int len;
+
 	/* strings from sysfs write are not 0 terminated! */
 	if (count >= sizeof(override_name))
 		return -EINVAL;
@@ -228,17 +209,32 @@ static ssize_t sysfs_override_clocksourc
 	/* strip of \n: */
 	if (buf[count-1] == '\n')
 		count--;
-	if (count < 1)
-		return -EINVAL;
 
 	spin_lock_irq(&clocksource_lock);
 
-	/* copy the name given: */
-	memcpy(override_name, buf, count);
+	if (count > 0)
+		memcpy(override_name, buf, count);
 	override_name[count] = 0;
 
-	/* try to select it: */
-	next_clocksource = select_clocksource();
+	len = strlen(override_name);
+	if (len) {
+		ovr = clocksource_override;
+		/* try to select it: */
+		list_for_each(tmp, &clocksource_list) {
+			struct clocksource *cs;
+
+			cs = list_entry(tmp, struct clocksource, list);
+			if (strlen(cs->name) == len &&
+			    !strcmp(cs->name, override_name))
+				ovr = cs;
+		}
+	}
+
+	/* Reselect, when the override name has changed */
+	if (ovr != clocksource_override) {
+		clocksource_override = ovr;
+		next_clocksource = select_clocksource();
+	}
 
 	spin_unlock_irq(&clocksource_lock);
 

--

