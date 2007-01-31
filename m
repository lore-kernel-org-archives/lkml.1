Return-Path: <linux-kernel-owner+w=401wt.eu-S932669AbXAaDmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbXAaDmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932663AbXAaDlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:41:44 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65448 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932623AbXAaDkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:40:45 -0500
Message-Id: <20070131033805.815147778@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:19 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 09/23] clocksource: add block notifier
Content-Disposition: inline; filename=clocksource_add_block_notify_on_new_clock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a call back interface for register/rating change events. This is also used
later in this series to signal other interesting events.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 include/linux/clocksource.h |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/timekeeping.h |    3 +++
 kernel/time/clocksource.c   |   10 ++++++++++
 3 files changed, 50 insertions(+)

Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -13,6 +13,7 @@
 #include <linux/time.h>
 #include <linux/list.h>
 #include <linux/sysdev.h>
+#include <linux/notifier.h>
 
 #include <asm/div64.h>
 #include <asm/io.h>
@@ -23,6 +24,42 @@ typedef u64 cycle_t;
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
 
+/*
+ * Allows inlined calling for notifier routines.
+ */
+extern struct atomic_notifier_head clocksource_list_notifier;
+
+/*
+ * Block notifier flags.
+ */
+#define CLOCKSOURCE_NOTIFY_REGISTER	1
+#define CLOCKSOURCE_NOTIFY_RATING	2
+#define CLOCKSOURCE_NOTIFY_FREQ		4
+
+/**
+ * clocksource_notifier_register - Registers a list change notifier
+ * @nb:		pointer to a notifier block
+ *
+ * Returns zero always.
+ */
+static inline int clocksource_notifier_register(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&clocksource_list_notifier, nb);
+}
+
+/**
+ * clocksource_freq_change - Allows notification of dynamic frequency changes.
+ *
+ * Signals that a clocksource is dynamically changing it's frequency.
+ * This could happen if a clocksource becomes more/less stable.
+ */
+static inline void clocksource_freq_change(struct clocksource *c)
+{
+	atomic_notifier_call_chain(&clocksource_list_notifier,
+				   CLOCKSOURCE_NOTIFY_FREQ, c);
+}
+
+
 /**
  * struct clocksource - hardware abstraction for a free running counter
  *	Provides mostly state-free accessors to the underlying hardware.
Index: linux-2.6.19/include/linux/timekeeping.h
===================================================================
--- linux-2.6.19.orig/include/linux/timekeeping.h
+++ linux-2.6.19/include/linux/timekeeping.h
@@ -8,6 +8,9 @@ static inline int change_clocksource(voi
 {
 	return 0;
 }
+
+static inline void change_clocksource(void) { }
+
 #endif /* !CONFIG_GENERIC_TIME */
 
 #endif /* _LINUX_TIMEKEEPING_H */
Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -49,6 +49,8 @@ static DEFINE_SPINLOCK(clocksource_lock)
 static char override_name[32];
 static int finished_booting;
 
+ATOMIC_NOTIFIER_HEAD(clocksource_list_notifier);
+
 /* clocksource_done_booting - Called near the end of bootup
  *
  * Hack to avoid lots of clocksource churn at boot time
@@ -193,6 +195,10 @@ int clocksource_register(struct clocksou
 	 */
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
+
+	atomic_notifier_call_chain(&clocksource_list_notifier,
+ 				   CLOCKSOURCE_NOTIFY_REGISTER, c);
+
 	return ret;
 }
 EXPORT_SYMBOL(clocksource_register);
@@ -218,6 +224,10 @@ void clocksource_rating_change(struct cl
 
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
+
+	atomic_notifier_call_chain(&clocksource_list_notifier,
+				   CLOCKSOURCE_NOTIFY_RATING, c);
+
 }
 EXPORT_SYMBOL(clocksource_rating_change);
 

-- 
