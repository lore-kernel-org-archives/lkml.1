Return-Path: <linux-kernel-owner+w=401wt.eu-S934208AbXG2PVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208AbXG2PVJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765573AbXG2PDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:03:42 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47949 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765462AbXG2PDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:03:20 -0400
Date: Sun, 29 Jul 2007 17:02:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/sched.c: make code static
Message-ID: <20070729150257.GD16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global code static:
- arch_reinit_sched_domains()
- struct attr_sched_mc_power_savings
- struct attr_sched_smt_power_savings

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 6 Jul 2007

 include/linux/cpu.h |    2 -
 kernel/sched.c      |   46 ++++++++++++++++++++++----------------------
 2 files changed, 23 insertions(+), 25 deletions(-)

--- linux-2.6.22-rc6-mm1/include/linux/cpu.h.old	2007-07-05 16:13:11.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/linux/cpu.h	2007-07-05 16:18:03.000000000 +0200
@@ -41,8 +41,6 @@
 extern int cpu_add_sysdev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_sysdev_attr_group(struct attribute_group *attrs);
 
-extern struct sysdev_attribute attr_sched_mc_power_savings;
-extern struct sysdev_attribute attr_sched_smt_power_savings;
 extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 
 #ifdef CONFIG_HOTPLUG_CPU
--- linux-2.6.22-rc6-mm1/kernel/sched.c.old	2007-07-05 16:11:34.000000000 +0200
+++ linux-2.6.22-rc6-mm1/kernel/sched.c	2007-07-05 16:30:40.000000000 +0200
@@ -6127,7 +6127,7 @@
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-int arch_reinit_sched_domains(void)
+static int arch_reinit_sched_domains(void)
 {
 	int err;
 
@@ -6156,24 +6156,6 @@
 	return ret ? ret : count;
 }
 
-int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
-{
-	int err = 0;
-
-#ifdef CONFIG_SCHED_SMT
-	if (smt_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_smt_power_savings.attr);
-#endif
-#ifdef CONFIG_SCHED_MC
-	if (!err && mc_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_mc_power_savings.attr);
-#endif
-	return err;
-}
-#endif
-
 #ifdef CONFIG_SCHED_MC
 static ssize_t sched_mc_power_savings_show(struct sys_device *dev, char *page)
 {
@@ -6184,8 +6166,8 @@
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
-	    sched_mc_power_savings_store);
+static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
+		   sched_mc_power_savings_store);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
@@ -6198,8 +6180,26 @@
 {
 	return sched_power_savings_store(buf, count, 1);
 }
-SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
-	    sched_smt_power_savings_store);
+static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
+		   sched_smt_power_savings_store);
+#endif
+
+int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
+{
+	int err = 0;
+
+#ifdef CONFIG_SCHED_SMT
+	if (smt_capable())
+		err = sysfs_create_file(&cls->kset.kobj,
+					&attr_sched_smt_power_savings.attr);
+#endif
+#ifdef CONFIG_SCHED_MC
+	if (!err && mc_capable())
+		err = sysfs_create_file(&cls->kset.kobj,
+					&attr_sched_mc_power_savings.attr);
+#endif
+	return err;
+}
 #endif
 
 /*

