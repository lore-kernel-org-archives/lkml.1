Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZG1RVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZG1RVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZG1RSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:36 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:35592 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbZG1RSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:07 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DR-04-A2S-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 16/26] x86/oprofile: Moving nmi_cpu_switch() in nmi_int.c
Date: Tue, 28 Jul 2009 19:07:16 +0200
Message-ID: <1248800846-25422-17-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:49.0931 (UTC) FILETIME=[5558ABB0:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves some code in nmi_int.c to get a single separate
multiplexing code section.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |  144 +++++++++++++++++++++----------------------
 1 files changed, 70 insertions(+), 74 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index f38c5cf..998c7dc 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -97,6 +97,29 @@ static void nmi_cpu_save_registers(struct op_msrs *msrs)
 	}
 }
 
+static void nmi_cpu_start(void *dummy)
+{
+	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
+	model->start(msrs);
+}
+
+static int nmi_start(void)
+{
+	on_each_cpu(nmi_cpu_start, NULL, 1);
+	return 0;
+}
+
+static void nmi_cpu_stop(void *dummy)
+{
+	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
+	model->stop(msrs);
+}
+
+static void nmi_stop(void)
+{
+	on_each_cpu(nmi_cpu_stop, NULL, 1);
+}
+
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 
 static DEFINE_PER_CPU(int, switch_index);
@@ -171,6 +194,53 @@ static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs)
 	}
 }
 
+static void nmi_cpu_switch(void *dummy)
+{
+	int cpu = smp_processor_id();
+	int si = per_cpu(switch_index, cpu);
+	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
+
+	nmi_cpu_stop(NULL);
+	nmi_cpu_save_mpx_registers(msrs);
+
+	/* move to next set */
+	si += model->num_counters;
+	if ((si > model->num_virt_counters) || (counter_config[si].count == 0))
+		per_cpu(switch_index, cpu) = 0;
+	else
+		per_cpu(switch_index, cpu) = si;
+
+	model->switch_ctrl(model, msrs);
+	nmi_cpu_restore_mpx_registers(msrs);
+
+	nmi_cpu_start(NULL);
+}
+
+
+/*
+ * Quick check to see if multiplexing is necessary.
+ * The check should be sufficient since counters are used
+ * in ordre.
+ */
+static int nmi_multiplex_on(void)
+{
+	return counter_config[model->num_counters].count ? 0 : -EINVAL;
+}
+
+static int nmi_switch_event(void)
+{
+	if (!model->switch_ctrl)
+		return -ENOSYS;		/* not implemented */
+	if (nmi_multiplex_on() < 0)
+		return -EINVAL;		/* not necessary */
+
+	on_each_cpu(nmi_cpu_switch, NULL, 1);
+
+	atomic_inc(&multiplex_counter);
+
+	return 0;
+}
+
 #else
 
 inline int op_x86_phys_to_virt(int phys) { return phys; }
@@ -325,29 +395,6 @@ static void nmi_shutdown(void)
 	put_cpu_var(cpu_msrs);
 }
 
-static void nmi_cpu_start(void *dummy)
-{
-	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
-	model->start(msrs);
-}
-
-static int nmi_start(void)
-{
-	on_each_cpu(nmi_cpu_start, NULL, 1);
-	return 0;
-}
-
-static void nmi_cpu_stop(void *dummy)
-{
-	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
-	model->stop(msrs);
-}
-
-static void nmi_stop(void)
-{
-	on_each_cpu(nmi_cpu_stop, NULL, 1);
-}
-
 static int nmi_create_files(struct super_block *sb, struct dentry *root)
 {
 	unsigned int i;
@@ -379,57 +426,6 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 	return 0;
 }
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-
-static void nmi_cpu_switch(void *dummy)
-{
-	int cpu = smp_processor_id();
-	int si = per_cpu(switch_index, cpu);
-	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
-
-	nmi_cpu_stop(NULL);
-	nmi_cpu_save_mpx_registers(msrs);
-
-	/* move to next set */
-	si += model->num_counters;
-	if ((si > model->num_virt_counters) || (counter_config[si].count == 0))
-		per_cpu(switch_index, cpu) = 0;
-	else
-		per_cpu(switch_index, cpu) = si;
-
-	model->switch_ctrl(model, msrs);
-	nmi_cpu_restore_mpx_registers(msrs);
-
-	nmi_cpu_start(NULL);
-}
-
-
-/*
- * Quick check to see if multiplexing is necessary.
- * The check should be sufficient since counters are used
- * in ordre.
- */
-static int nmi_multiplex_on(void)
-{
-	return counter_config[model->num_counters].count ? 0 : -EINVAL;
-}
-
-static int nmi_switch_event(void)
-{
-	if (!model->switch_ctrl)
-		return -ENOSYS;		/* not implemented */
-	if (nmi_multiplex_on() < 0)
-		return -EINVAL;		/* not necessary */
-
-	on_each_cpu(nmi_cpu_switch, NULL, 1);
-
-	atomic_inc(&multiplex_counter);
-
-	return 0;
-}
-
-#endif
-
 #ifdef CONFIG_SMP
 static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
 				 void *data)
-- 
1.6.3.3


