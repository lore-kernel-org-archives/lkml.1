Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYGVTcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYGVTcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755754AbYGVTZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:25:32 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:45903 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbYGVTZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:25:30 -0400
X-BigFish: VPS20(zz541Lzz10d3izzz32i87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9WV-02-3OL-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/24] x86/oprofile: Introduce model specific init/exit functions
Date: Tue, 22 Jul 2008 21:08:48 +0200
Message-ID: <1216753748-11261-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:38.0980 (UTC) FILETIME=[71ACE240:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements model specific OProfile init/exit functions for
x86 CPUs. Though there is more rework needed at the initialization
code, this new introduced functions allow it to keep model specific
code in the corresponding op_model_*.c files.

The function interface is the same as for oprofile_arch_init/exit().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c         |   11 ++++++++++-
 arch/x86/oprofile/op_model_athlon.c |   18 +++++++++++++++---
 arch/x86/oprofile/op_x86_model.h    |    2 ++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cf28a02..b96cfd3 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -1,10 +1,11 @@
 /**
  * @file nmi_int.c
  *
- * @remark Copyright 2002 OProfile authors
+ * @remark Copyright 2002-2008 OProfile authors
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
+ * @author Robert Richter <robert.richter@amd.com>
  */
 
 #include <linux/init.h>
@@ -397,6 +398,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	__u8 vendor = boot_cpu_data.x86_vendor;
 	__u8 family = boot_cpu_data.x86;
 	char *cpu_type;
+	int ret = 0;
 
 	if (!cpu_has_apic)
 		return -ENODEV;
@@ -452,6 +454,11 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		return -ENODEV;
 	}
 
+	if (model->init)
+		ret = model->init(ops);
+	if (ret)
+		return ret;
+
 	init_sysfs();
 	using_nmi = 1;
 	ops->create_files = nmi_create_files;
@@ -468,4 +475,6 @@ void op_nmi_exit(void)
 {
 	if (using_nmi)
 		exit_sysfs();
+	if (model->exit)
+		model->exit();
 }
diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 3d53487..dd8b1dc 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -1,14 +1,15 @@
 /*
- * @file op_model_athlon.h
+ * @file op_model_athlon.c
  * athlon / K7 / K8 / Family 10h model-specific MSR operations
  *
- * @remark Copyright 2002 OProfile authors
+ * @remark Copyright 2002-2008 OProfile authors
  * @remark Read the file COPYING
  *
  * @author John Levon
  * @author Philippe Elie
  * @author Graydon Hoare
- */
+ * @author Robert Richter <robert.richter@amd.com>
+*/
 
 #include <linux/oprofile.h>
 #include <asm/ptrace.h>
@@ -178,7 +179,18 @@ static void athlon_shutdown(struct op_msrs const * const msrs)
 	}
 }
 
+static int op_amd_init(struct oprofile_operations *ops)
+{
+	return 0;
+}
+
+static void op_amd_exit(void)
+{
+}
+
 struct op_x86_model_spec const op_athlon_spec = {
+	.init = op_amd_init,
+	.exit = op_amd_exit,
 	.num_counters = NUM_COUNTERS,
 	.num_controls = NUM_CONTROLS,
 	.fill_in_addresses = &athlon_fill_in_addresses,
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 45b605f..ee9ca96 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -32,6 +32,8 @@ struct pt_regs;
  * various x86 CPU models' perfctr support.
  */
 struct op_x86_model_spec {
+	int (*init)(struct oprofile_operations *ops);
+	void (*exit)(void);
 	unsigned int const num_counters;
 	unsigned int const num_controls;
 	void (*fill_in_addresses)(struct op_msrs * const msrs);
-- 
1.5.5.4


