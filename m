Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbYJOVFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbYJOVFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYJOVDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:03:10 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4725 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbYJOVDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:03:01 -0400
X-BigFish: VPS1(zzzzzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K8ST4E-02-I7A-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 7/8] x86/oprofile: reordering functions in nmi_int.c
Date: Wed, 15 Oct 2008 22:09:09 +0200
Message-ID: <1224101350-12877-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <20081015110444.GA28703@elte.hu>
References: <20081015110444.GA28703@elte.hu>
X-OriginalArrivalTime: 15 Oct 2008 21:02:38.0940 (UTC) FILETIME=[5B4799C0:01C92F09]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes. The intension is to remove static function
declarations.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |  147 +++++++++++++++++++++----------------------
 1 files changed, 71 insertions(+), 76 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 57f6c90..370d832 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -28,85 +28,9 @@ static struct op_x86_model_spec const *model;
 static DEFINE_PER_CPU(struct op_msrs, cpu_msrs);
 static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
 
-static int nmi_start(void);
-static void nmi_stop(void);
-static void nmi_cpu_start(void *dummy);
-static void nmi_cpu_stop(void *dummy);
-
 /* 0 == registered but off, 1 == registered and on */
 static int nmi_enabled = 0;
 
-#ifdef CONFIG_SMP
-static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
-				 void *data)
-{
-	int cpu = (unsigned long)data;
-	switch (action) {
-	case CPU_DOWN_FAILED:
-	case CPU_ONLINE:
-		smp_call_function_single(cpu, nmi_cpu_start, NULL, 0);
-		break;
-	case CPU_DOWN_PREPARE:
-		smp_call_function_single(cpu, nmi_cpu_stop, NULL, 1);
-		break;
-	}
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block oprofile_cpu_nb = {
-	.notifier_call = oprofile_cpu_notifier
-};
-#endif
-
-#ifdef CONFIG_PM
-
-static int nmi_suspend(struct sys_device *dev, pm_message_t state)
-{
-	/* Only one CPU left, just stop that one */
-	if (nmi_enabled == 1)
-		nmi_cpu_stop(NULL);
-	return 0;
-}
-
-static int nmi_resume(struct sys_device *dev)
-{
-	if (nmi_enabled == 1)
-		nmi_cpu_start(NULL);
-	return 0;
-}
-
-static struct sysdev_class oprofile_sysclass = {
-	.name		= "oprofile",
-	.resume		= nmi_resume,
-	.suspend	= nmi_suspend,
-};
-
-static struct sys_device device_oprofile = {
-	.id	= 0,
-	.cls	= &oprofile_sysclass,
-};
-
-static int __init init_sysfs(void)
-{
-	int error;
-
-	error = sysdev_class_register(&oprofile_sysclass);
-	if (!error)
-		error = sysdev_register(&device_oprofile);
-	return error;
-}
-
-static void exit_sysfs(void)
-{
-	sysdev_unregister(&device_oprofile);
-	sysdev_class_unregister(&oprofile_sysclass);
-}
-
-#else
-#define init_sysfs() do { } while (0)
-#define exit_sysfs() do { } while (0)
-#endif /* CONFIG_PM */
-
 static int profile_exceptions_notify(struct notifier_block *self,
 				     unsigned long val, void *data)
 {
@@ -361,6 +285,77 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 	return 0;
 }
 
+#ifdef CONFIG_SMP
+static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
+				 void *data)
+{
+	int cpu = (unsigned long)data;
+	switch (action) {
+	case CPU_DOWN_FAILED:
+	case CPU_ONLINE:
+		smp_call_function_single(cpu, nmi_cpu_start, NULL, 0);
+		break;
+	case CPU_DOWN_PREPARE:
+		smp_call_function_single(cpu, nmi_cpu_stop, NULL, 1);
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block oprofile_cpu_nb = {
+	.notifier_call = oprofile_cpu_notifier
+};
+#endif
+
+#ifdef CONFIG_PM
+
+static int nmi_suspend(struct sys_device *dev, pm_message_t state)
+{
+	/* Only one CPU left, just stop that one */
+	if (nmi_enabled == 1)
+		nmi_cpu_stop(NULL);
+	return 0;
+}
+
+static int nmi_resume(struct sys_device *dev)
+{
+	if (nmi_enabled == 1)
+		nmi_cpu_start(NULL);
+	return 0;
+}
+
+static struct sysdev_class oprofile_sysclass = {
+	.name		= "oprofile",
+	.resume		= nmi_resume,
+	.suspend	= nmi_suspend,
+};
+
+static struct sys_device device_oprofile = {
+	.id	= 0,
+	.cls	= &oprofile_sysclass,
+};
+
+static int __init init_sysfs(void)
+{
+	int error;
+
+	error = sysdev_class_register(&oprofile_sysclass);
+	if (!error)
+		error = sysdev_register(&device_oprofile);
+	return error;
+}
+
+static void exit_sysfs(void)
+{
+	sysdev_unregister(&device_oprofile);
+	sysdev_class_unregister(&oprofile_sysclass);
+}
+
+#else
+#define init_sysfs() do { } while (0)
+#define exit_sysfs() do { } while (0)
+#endif /* CONFIG_PM */
+
 static int p4force;
 module_param(p4force, int, 0);
 
-- 
1.6.0.1


