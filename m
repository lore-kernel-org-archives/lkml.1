Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbXD0TCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbXD0TCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbXD0S7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:59:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:35397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757077AbXD0S7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:59:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 43/46] s2ram: add arch irq disable/enable hooks
Date: Fri, 27 Apr 2007 11:53:57 -0700
Message-Id: <11777002022552-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777001971761-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
 <11777001413571-git-send-email-gregkh@suse.de>
 <11777001442148-git-send-email-gregkh@suse.de>
 <1177700148815-git-send-email-gregkh@suse.de>
 <11777001521006-git-send-email-gregkh@suse.de>
 <1177700156641-git-send-email-gregkh@suse.de>
 <1177700160896-git-send-email-gregkh@suse.de>
 <11777001642551-git-send-email-gregkh@suse.de>
 <11777001682584-git-send-email-gregkh@suse.de>
 <1177700172258-git-send-email-gregkh@suse.de>
 <11777001773804-git-send-email-gregkh@suse.de>
 <11777001803098-git-send-email-gregkh@suse.de>
 <11777001852549-git-send-email-gregkh@suse.de>
 <11777001891914-git-send-email-gregkh@suse.de>
 <11777001931075-git-send-email-gregkh@suse.de>
 <11777001971761-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

After some more discussion this patch replaces it:

From: Johannes Berg <johannes@sipsolutions.net>
Subject: suspend: add arch irq disable/enable hooks

For powermac, we need to do some things between suspending devices and
device_power_off, for example setting the decrementer. This patch
allows architectures to define arch_s2ram_{en,dis}able_irqs in their
asm/suspend.h to have control over this step.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/pm.h  |   18 ++++++++++++++++++
 kernel/power/main.c |   18 +++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index b0ab623..9bd86db 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -166,6 +166,24 @@ extern struct pm_ops *pm_ops;
 extern int pm_suspend(suspend_state_t state);
 
 
+/**
+ * arch_suspend_disable_irqs - disable IRQs for suspend
+ *
+ * Disables IRQs (in the default case). This is a weak symbol in the common
+ * code and thus allows architectures to override it if more needs to be
+ * done. Not called for suspend to disk.
+ */
+extern void arch_suspend_disable_irqs(void);
+
+/**
+ * arch_suspend_enable_irqs - enable IRQs after suspend
+ *
+ * Enables IRQs (in the default case). This is a weak symbol in the common
+ * code and thus allows architectures to override it if more needs to be
+ * done. Not called for suspend to disk.
+ */
+extern void arch_suspend_enable_irqs(void);
+
 /*
  * Device power management
  */
diff --git a/kernel/power/main.c b/kernel/power/main.c
index a064dfd..3062e94 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -111,13 +111,24 @@ static int suspend_prepare(suspend_state_t state)
 	return error;
 }
 
+/* default implementation */
+void __attribute__ ((weak)) arch_suspend_disable_irqs(void)
+{
+	local_irq_disable();
+}
+
+/* default implementation */
+void __attribute__ ((weak)) arch_suspend_enable_irqs(void)
+{
+	local_irq_enable();
+}
 
 int suspend_enter(suspend_state_t state)
 {
 	int error = 0;
-	unsigned long flags;
 
-	local_irq_save(flags);
+	arch_suspend_disable_irqs();
+	BUG_ON(!irqs_disabled());
 
 	if ((error = device_power_down(PMSG_SUSPEND))) {
 		printk(KERN_ERR "Some devices failed to power down\n");
@@ -126,7 +137,8 @@ int suspend_enter(suspend_state_t state)
 	error = pm_ops->enter(state);
 	device_power_up();
  Done:
-	local_irq_restore(flags);
+	arch_suspend_enable_irqs();
+	BUG_ON(irqs_disabled());
 	return error;
 }
 
-- 
1.5.1.2

