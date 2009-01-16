Return-Path: <linux-kernel-owner+w=401wt.eu-S1765546AbZAPXLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765546AbZAPXLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbZAPXLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:11:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51484 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZAPXLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:11:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] PM: Fix compilation warning in kernel/power/main.c
Date: Sat, 17 Jan 2009 00:10:45 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-tst; KDE/4.1.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901170010.45699.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reorder the code in kernel/power/main.c to fix compilation warning
triggered by unsetting CONFIG_SUSPEND.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/main.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -57,16 +57,6 @@ int pm_notifier_call_chain(unsigned long
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
-static int suspend_test(int level)
-{
-	if (pm_test_level == level) {
-		printk(KERN_INFO "suspend debug: Waiting for 5 seconds.\n");
-		mdelay(5000);
-		return 1;
-	}
-	return 0;
-}
-
 static const char * const pm_tests[__TEST_AFTER_LAST] = {
 	[TEST_NONE] = "none",
 	[TEST_CORE] = "core",
@@ -125,14 +115,24 @@ static ssize_t pm_test_store(struct kobj
 }
 
 power_attr(pm_test);
-#else /* !CONFIG_PM_DEBUG */
-static inline int suspend_test(int level) { return 0; }
-#endif /* !CONFIG_PM_DEBUG */
+#endif /* CONFIG_PM_DEBUG */
 
 #endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_SUSPEND
 
+static int suspend_test(int level)
+{
+#ifdef CONFIG_PM_DEBUG
+	if (pm_test_level == level) {
+		printk(KERN_INFO "suspend debug: Waiting for 5 seconds.\n");
+		mdelay(5000);
+		return 1;
+	}
+#endif /* !CONFIG_PM_DEBUG */
+	return 0;
+}
+
 #ifdef CONFIG_PM_TEST_SUSPEND
 
 /*

