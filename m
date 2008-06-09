Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYFISKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYFISKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYFISKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:10:03 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:50877 "EHLO
	mail17-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYFISKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:10:01 -0400
X-Greylist: delayed 1145 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 14:10:00 EDT
X-BigFish: VPS-30(z6f5iz14c3M1417L7efVzz10d3izz5eeeTz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K27IW0-04-5VT-01
From: Barry Kasindorf <barry.kasindorf@amd.com>
To: linux-kernel@vger.kernel.org, barry.kasindorf@amd.com
Cc: Barry Kasindorf <barry.kasindorf@amd.com>
Message-Id: <20080609175030.2844.77365.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver: Setup routines
X-OriginalArrivalTime: 09 Jun 2008 17:50:25.0832 (UTC) FILETIME=[4C22FA80:01C8CA59]
Date: 9 Jun 2008 13:50:25 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset supports the new profiling hardware available in the latest AMD CPUs in the oProfile driver.

These new AMD processors CPUs support Instruction Based Sampling (IBS). See

	 Instruction-Based Sampling: A New Performance Analysis Technique
         for AMD Family 10h Processors, November 19, 2007
         http://developer.amd.com/assets/AMD_IBS_paper_EN.pdf

for more information about IBS.

IBS support requires changes to the oProfile driver to gather this information and initialize the new MSRs associated with these new features.

This patch adds 2 new types of Profiling samples IBS_FETCH and IBS_OP to the per CPU buffers and the event buffers of the oProfile driver.

It also adds new control entries to /dev/oprofile to control IBS sampling.

These changes are backward compatible with the previous PMC only version of the driver, and a separate patch is available to oProfile 0.9.3 to use this new data.

These changes have been extensively tested at AMD on Family10h systems.

Barry Kasindorf barry.kasindorf@amd.com

Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>

---
 nmi_int.c    |   49 +++++++++++++++++++++++++++++++++++++++++++++----
 op_counter.h |   16 +++++++++++++---
 2 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cc48d3f..32a5e8e 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -218,6 +218,11 @@ static int nmi_setup(void)
 		}

 	}
+
+	/* setup AMD Family10h+ IBS irq if needed */
+	if (IBS_avail())
+		setup_ibs_nmi();
+
 	on_each_cpu(nmi_save_registers, NULL, 0, 1);
 	on_each_cpu(nmi_cpu_setup, NULL, 0, 1);
 	nmi_enabled = 1;
@@ -275,6 +280,10 @@ static void nmi_shutdown(void)
 	unregister_die_notifier(&profile_exceptions_nb);
 	model->shutdown(msrs);
 	free_msrs();
+
+	/* clear AMD Family10h+ IBS irq if needed */
+	if (IBS_avail())
+		clear_ibs_nmi();
 }

 static void nmi_cpu_start(void *dummy)
@@ -301,15 +310,14 @@ static void nmi_stop(void)
 }

 struct op_counter_config counter_config[OP_MAX_COUNTER];
+struct op_ibs_config ibs_config;

 static int nmi_create_files(struct super_block *sb, struct dentry *root)
 {
 	unsigned int i;
-
+	struct dentry *dir;
 	for (i = 0; i < model->num_counters; ++i) {
-		struct dentry *dir;
 		char buf[4];
-
 		/* quick little hack to _not_ expose a counter if it is not
 		 * available for use.  This should protect userspace app.
 		 * NOTE:  assumes 1:1 mapping here (that counters are organized
@@ -328,6 +336,33 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 		oprofilefs_create_ulong(sb, dir, "user", &counter_config[i].user);
 	}

+	/* Setup AMD Family10h+ IBS control if needed */
+	if (IBS_avail()) {
+		char buf[12];
+
+		/* setup some reasonable defaults */
+		ibs_config.max_cnt_fetch = 250000;
+		ibs_config.FETCH_enabled = 0;
+		ibs_config.max_cnt_op = 250000;
+		ibs_config.OP_enabled = 0;
+		ibs_config.dispatched_ops = 1;
+		snprintf(buf,  sizeof(buf), "ibs_fetch");
+		dir = oprofilefs_mkdir(sb, root, buf);
+		oprofilefs_create_ulong(sb, dir, "ran_enable",
+					&ibs_config.rand_en);
+		oprofilefs_create_ulong(sb, dir, "enable",
+					&ibs_config.FETCH_enabled);
+		oprofilefs_create_ulong(sb, dir, "max_count",
+					&ibs_config.max_cnt_fetch);
+		snprintf(buf,  sizeof(buf), "ibs_uops");
+		dir = oprofilefs_mkdir(sb, root, buf);
+		oprofilefs_create_ulong(sb, dir, "enable",
+					&ibs_config.OP_enabled);
+		oprofilefs_create_ulong(sb, dir, "max_count",
+					&ibs_config.max_cnt_op);
+		oprofilefs_create_ulong(sb, dir, "dispatched_ops",
+					&ibs_config.dispatched_ops);
+	}
 	return 0;
 }

@@ -419,9 +454,15 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 			break;
 		case 0x10:
 			model = &op_athlon_spec;
-			cpu_type = "x86-64/family10";
+			cpu_type = "x86-64/family10h";
+			break;
+		case 0x11:
+			model = &op_athlon_spec;
+			cpu_type = "x86-64/family11h";
 			break;
 		}
+		/* set global if IBS profiling is available */
+		check_IBS_avail(family);
 		break;

 	case X86_VENDOR_INTEL:
diff --git a/arch/x86/oprofile/op_counter.h b/arch/x86/oprofile/op_counter.h
index 2880b15..ddab57c 100644
--- a/arch/x86/oprofile/op_counter.h
+++ b/arch/x86/oprofile/op_counter.h
@@ -6,12 +6,12 @@
  *
  * @author John Levon
  */
-
+
 #ifndef OP_COUNTER_H
 #define OP_COUNTER_H
-
+
 #define OP_MAX_COUNTER 8
-
+
 /* Per-perfctr configuration as set via
  * oprofilefs.
  */
@@ -26,4 +26,14 @@ struct op_counter_config {

 extern struct op_counter_config counter_config[];

+struct op_ibs_config {
+	unsigned long OP_enabled;
+	unsigned long FETCH_enabled;
+	unsigned long max_cnt_fetch;
+	unsigned long max_cnt_op;
+	unsigned long rand_en;
+	unsigned long dispatched_ops;
+};
+
+extern struct op_ibs_config ibs_config;
 #endif /* OP_COUNTER_H */


