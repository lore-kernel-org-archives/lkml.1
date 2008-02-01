Return-Path: <linux-kernel-owner+w=401wt.eu-S935237AbYBAEtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935237AbYBAEtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYBAEmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:42:36 -0500
Received: from mga05.intel.com ([192.55.52.89]:61252 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759450AbYBAEmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:42:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516576"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 14/37] PM: Convert PM notifiers to out-of-line code
Date: Thu, 31 Jan 2008 23:36:45 -0500
Message-Id: <8ff7d174bef41a219ea7a2d4e99cfd4e8aae0c8c.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1008b) converts the PM notifier routines from inline
calls to out-of-line code.  It also prevents pm_chain_head from
being created when CONFIG_PM_SLEEP isn't enabled, and EXPORTs the
notifier registration and unregistration routines.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/linux/suspend.h |   13 ++-----------
 kernel/power/main.c     |   28 ++++++++++++++++++++++++++--
 kernel/power/power.h    |   12 ++++--------
 3 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 40280df..51283e0 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -213,17 +213,8 @@ void save_processor_state(void);
 void restore_processor_state(void);
 
 /* kernel/power/main.c */
-extern struct blocking_notifier_head pm_chain_head;
-
-static inline int register_pm_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_register(&pm_chain_head, nb);
-}
-
-static inline int unregister_pm_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_unregister(&pm_chain_head, nb);
-}
+extern int register_pm_notifier(struct notifier_block *nb);
+extern int unregister_pm_notifier(struct notifier_block *nb);
 
 #define pm_notifier(fn, pri) {				\
 	static struct notifier_block fn##_nb =			\
diff --git a/kernel/power/main.c b/kernel/power/main.c
index fc717b8..0a9f269 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -24,13 +24,37 @@
 
 #include "power.h"
 
-BLOCKING_NOTIFIER_HEAD(pm_chain_head);
-
 DEFINE_MUTEX(pm_mutex);
 
 unsigned int pm_flags;
 EXPORT_SYMBOL(pm_flags);
 
+#ifdef CONFIG_PM_SLEEP
+
+/* Routines for PM-transition notifications */
+
+static BLOCKING_NOTIFIER_HEAD(pm_chain_head);
+
+int register_pm_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&pm_chain_head, nb);
+}
+EXPORT_SYMBOL_GPL(register_pm_notifier);
+
+int unregister_pm_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&pm_chain_head, nb);
+}
+EXPORT_SYMBOL_GPL(unregister_pm_notifier);
+
+int pm_notifier_call_chain(unsigned long val)
+{
+	return (blocking_notifier_call_chain(&pm_chain_head, val, NULL)
+			== NOTIFY_BAD) ? -EINVAL : 0;
+}
+
+#endif /* CONFIG_PM_SLEEP */
+
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
diff --git a/kernel/power/power.h b/kernel/power/power.h
index f9f0d4d..a9732fd 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -172,14 +172,10 @@ static inline int suspend_devices_and_enter(suspend_state_t state)
 }
 #endif /* !CONFIG_SUSPEND */
 
-/* kernel/power/common.c */
-extern struct blocking_notifier_head pm_chain_head;
-
-static inline int pm_notifier_call_chain(unsigned long val)
-{
-	return (blocking_notifier_call_chain(&pm_chain_head, val, NULL)
-			== NOTIFY_BAD) ? -EINVAL : 0;
-}
+#ifdef CONFIG_PM_SLEEP
+/* kernel/power/main.c */
+extern int pm_notifier_call_chain(unsigned long val);
+#endif
 
 #ifdef CONFIG_HIGHMEM
 unsigned int count_highmem_pages(void);
-- 
1.5.4.rc5.16.gc0279

