Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYGVTZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYGVTZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbYGVTX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:23:57 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:25014 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYGVTXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:52 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VD-01-8PP-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 17/24] OProfile: Enable IBS for AMD CPUs
Date: Tue, 22 Jul 2008 21:09:01 +0200
Message-ID: <1216753748-11261-18-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:40.0370 (UTC) FILETIME=[7280FB20:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c         |   14 ++++++++------
 arch/x86/oprofile/op_model_athlon.c |   18 +++++++++++++++++-
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 4e42b50..f46d8fc 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -454,6 +454,14 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		return -ENODEV;
 	}
 
+	/* default values, can be overwritten by model */
+	ops->create_files = nmi_create_files;
+	ops->setup = nmi_setup;
+	ops->shutdown = nmi_shutdown;
+	ops->start = nmi_start;
+	ops->stop = nmi_stop;
+	ops->cpu_type = cpu_type;
+
 	if (model->init)
 		ret = model->init(ops);
 	if (ret)
@@ -461,12 +469,6 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 
 	init_sysfs();
 	using_nmi = 1;
-	ops->create_files = nmi_create_files;
-	ops->setup = nmi_setup;
-	ops->shutdown = nmi_shutdown;
-	ops->start = nmi_start;
-	ops->stop = nmi_stop;
-	ops->cpu_type = cpu_type;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
 	return 0;
 }
diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 2650b12..0d83903 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -446,13 +446,25 @@ static void clear_ibs_nmi(void)
 		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
 }
 
+static int (*create_arch_files)(struct super_block * sb, struct dentry * root);
+
 static int setup_ibs_files(struct super_block * sb, struct dentry * root)
 {
 	char buf[12];
 	struct dentry *dir;
+	int ret = 0;
+
+	/* architecture specific files */
+	if (create_arch_files)
+		ret = create_arch_files(sb, root);
+
+	if (ret)
+		return ret;
 
 	if (!ibs_allowed)
-		return 0;
+		return ret;
+
+	/* model specific files */
 
 	/* setup some reasonable defaults */
 	ibs_config.max_cnt_fetch = 250000;
@@ -482,11 +494,15 @@ static int setup_ibs_files(struct super_block * sb, struct dentry * root)
 
 static int op_amd_init(struct oprofile_operations *ops)
 {
+	setup_ibs();
+	create_arch_files = ops->create_files;
+	ops->create_files = setup_ibs_files;
 	return 0;
 }
 
 static void op_amd_exit(void)
 {
+	clear_ibs_nmi();
 }
 
 struct op_x86_model_spec const op_amd_spec = {
-- 
1.5.5.4


