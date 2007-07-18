Return-Path: <linux-kernel-owner+w=401wt.eu-S1760730AbXGRHeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730AbXGRHeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756526AbXGRHcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:32:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52605 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbXGRHcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:32:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 4/5] Freezer: Introduce freezer-firendly waiting macros
Date: Wed, 18 Jul 2007 09:37:02 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dtor@insightbb.com>
References: <200707180929.31511.rjw@sisk.pl>
In-Reply-To: <200707180929.31511.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707180937.03633.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce freezer-friendly wrappers around wait_event_interruptible() and
wait_event_interruptible_timeout(), originally defined in <linux/wait.h>, to
be used in freezable kernel threads.  Make some of the freezable kernel threads
use them.

This is necessary for the freezer to stop sending signals to kernel threads,
which is implemented in the next patch.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/input/gameport/gameport.c         |    3 --
 drivers/input/serio/serio.c               |    3 --
 drivers/input/touchscreen/ucb1400_ts.c    |    3 --
 drivers/media/dvb/dvb-core/dvb_frontend.c |    3 +-
 drivers/usb/core/hub.c                    |    3 --
 drivers/usb/storage/usb.c                 |    5 ---
 include/linux/freezer.h                   |   42 ++++++++++++++++++++++++++++--
 7 files changed, 47 insertions(+), 15 deletions(-)

Index: linux-2.6.22-rc6-mm1/include/linux/freezer.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/freezer.h
+++ linux-2.6.22-rc6-mm1/include/linux/freezer.h
@@ -4,6 +4,7 @@
 #define FREEZER_H_INCLUDED
 
 #include <linux/sched.h>
+#include <linux/wait.h>
 
 #ifdef CONFIG_PM
 /*
@@ -126,7 +127,37 @@ static inline void set_freezable(void)
 	current->flags &= ~PF_NOFREEZE;
 }
 
-#else
+/*
+ * Freezer-friendly wrappers around wait_event_interruptible() and
+ * wait_event_interruptible_timeout(), originally defined in <linux/wait.h>
+ */
+
+#define wait_event_freezable(wq, condition)				\
+({									\
+	int __ret;							\
+	do {								\
+		__ret = wait_event_interruptible(wq, 			\
+				(condition) || freezing(current));	\
+		if (__ret && !freezing(current))			\
+			break;						\
+		else if (!(condition))					\
+			__ret = -ERESTARTSYS;				\
+	} while (try_to_freeze());					\
+	__ret;								\
+})
+
+
+#define wait_event_freezable_timeout(wq, condition, timeout)		\
+({									\
+	long __ret = timeout;						\
+	do {								\
+		__ret = wait_event_interruptible_timeout(wq,		\
+				(condition) || freezing(current),	\
+				__ret); 				\
+	} while (try_to_freeze());					\
+	__ret;								\
+})
+#else /* CONFIG_PM */
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
 static inline void set_freeze_flag(struct task_struct *p) {}
@@ -143,6 +174,13 @@ static inline void freezer_do_not_count(
 static inline void freezer_count(void) {}
 static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 static inline void set_freezable(void) {}
-#endif
+
+#define wait_event_freezable(wq, condition)				\
+		wait_event_interruptible(wq, condition)
+
+#define wait_event_freezable_timeout(wq, condition, timeout)		\
+		wait_event_interruptible_timeout(wq, condition, timeout)
+
+#endif /* CONFIG_PM */
 
 #endif	/* FREEZER_H_INCLUDED */
Index: linux-2.6.22-rc6-mm1/drivers/input/gameport/gameport.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/input/gameport/gameport.c
+++ linux-2.6.22-rc6-mm1/drivers/input/gameport/gameport.c
@@ -448,9 +448,8 @@ static int gameport_thread(void *nothing
 	set_freezable();
 	do {
 		gameport_handle_event();
-		wait_event_interruptible(gameport_wait,
+		wait_event_freezable(gameport_wait,
 			kthread_should_stop() || !list_empty(&gameport_event_list));
-		try_to_freeze();
 	} while (!kthread_should_stop());
 
 	printk(KERN_DEBUG "gameport: kgameportd exiting\n");
Index: linux-2.6.22-rc6-mm1/drivers/input/serio/serio.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/input/serio/serio.c
+++ linux-2.6.22-rc6-mm1/drivers/input/serio/serio.c
@@ -387,9 +387,8 @@ static int serio_thread(void *nothing)
 	set_freezable();
 	do {
 		serio_handle_event();
-		wait_event_interruptible(serio_wait,
+		wait_event_freezable(serio_wait,
 			kthread_should_stop() || !list_empty(&serio_event_list));
-		try_to_freeze();
 	} while (!kthread_should_stop());
 
 	printk(KERN_DEBUG "serio: kseriod exiting\n");
Index: linux-2.6.22-rc6-mm1/drivers/input/touchscreen/ucb1400_ts.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/input/touchscreen/ucb1400_ts.c
+++ linux-2.6.22-rc6-mm1/drivers/input/touchscreen/ucb1400_ts.c
@@ -334,10 +334,9 @@ static int ucb1400_ts_thread(void *_ucb)
 			timeout = msecs_to_jiffies(10);
 		}
 
-		wait_event_interruptible_timeout(ucb->ts_wait,
+		wait_event_freezable_timeout(ucb->ts_wait,
 			ucb->irq_pending || ucb->ts_restart || kthread_should_stop(),
 			timeout);
-		try_to_freeze();
 	}
 
 	/* Send the "pen off" if we are stopping with the pen still active */
Index: linux-2.6.22-rc6-mm1/drivers/media/dvb/dvb-core/dvb_frontend.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ linux-2.6.22-rc6-mm1/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -528,7 +528,8 @@ static int dvb_frontend_thread(void *dat
 		up(&fepriv->sem);	    /* is locked when we enter the thread... */
 restart:
 		timeout = wait_event_interruptible_timeout(fepriv->wait_queue,
-			dvb_frontend_should_wakeup(fe) || kthread_should_stop(),
+			dvb_frontend_should_wakeup(fe) || kthread_should_stop()
+				|| freezing(current),
 			fepriv->delay);
 
 		if (kthread_should_stop() || dvb_frontend_is_exiting(fe)) {
Index: linux-2.6.22-rc6-mm1/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/usb/core/hub.c
+++ linux-2.6.22-rc6-mm1/drivers/usb/core/hub.c
@@ -2729,10 +2729,9 @@ static int hub_thread(void *__unused)
 	set_freezable();
 	do {
 		hub_events();
-		wait_event_interruptible(khubd_wait,
+		wait_event_freezable(khubd_wait,
 				!list_empty(&hub_event_list) ||
 				kthread_should_stop());
-		try_to_freeze();
 	} while (!kthread_should_stop() || !list_empty(&hub_event_list));
 
 	pr_debug("%s: khubd exiting\n", usbcore_name);
Index: linux-2.6.22-rc6-mm1/drivers/usb/storage/usb.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/usb/storage/usb.c
+++ linux-2.6.22-rc6-mm1/drivers/usb/storage/usb.c
@@ -913,12 +913,9 @@ static int usb_stor_scan_thread(void * _
 	if (delay_use > 0) {
 		printk(KERN_DEBUG "usb-storage: waiting for device "
 				"to settle before scanning\n");
-retry:
-		wait_event_interruptible_timeout(us->delay_wait,
+		wait_event_freezable_timeout(us->delay_wait,
 				test_bit(US_FLIDX_DISCONNECTING, &us->flags),
 				delay_use * HZ);
-		if (try_to_freeze())
-			goto retry;
 	}
 
 	/* If the device is still connected, perform the scanning */
