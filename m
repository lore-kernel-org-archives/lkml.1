Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYGVT02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYGVT02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbYGVTX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:23:59 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:25251 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYGVTXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:55 -0400
X-BigFish: VPS29(zzzz10d3izzz32i87il68o)
X-Spam-TCS-SCL: 7:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VE-02-3LZ-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 22/24] x86/oprofile: Add CONFIG_OPROFILE_IBS option
Date: Tue, 22 Jul 2008 21:09:06 +0200
Message-ID: <1216753748-11261-23-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:41.0120 (UTC) FILETIME=[72F36C00:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/Kconfig                        |   14 ++++++++++++++
 arch/x86/oprofile/op_model_athlon.c |   33 +++++++++++++++++++++++----------
 drivers/oprofile/buffer_sync.c      |    6 ++++++
 drivers/oprofile/cpu_buffer.c       |    4 ++++
 4 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index ad89a33..62be4e2 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -13,6 +13,20 @@ config OPROFILE
 
 	  If unsure, say N.
 
+config OPROFILE_IBS
+	bool "OProfile AMD IBS support (EXPERIMENTAL)"
+	default n
+	depends on OPROFILE && SMP && X86
+	help
+          Instruction-Based Sampling (IBS) is a new profiling
+          technique that provides rich, precise program performance
+          information. IBS is introduced by AMD Family10h processors
+          (AMD Opteron Quad-Core processor “Barcelona”) to overcome
+          the limitations of conventional performance counter
+          sampling.
+
+	  If unsure, say N.
+
 config HAVE_OPROFILE
 	def_bool n
 
diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 9c8c8c5..fb6015c 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -47,6 +47,10 @@
 #define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
 #define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
 
+static unsigned long reset_value[NUM_COUNTERS];
+
+#ifdef CONFIG_OPROFILE_IBS
+
 /* IbsFetchCtl bits/masks */
 #define IBS_FETCH_HIGH_VALID_BIT	(1UL << 17)	/* bit 49 */
 #define IBS_FETCH_HIGH_ENABLE		(1UL << 16)	/* bit 48 */
@@ -104,7 +108,6 @@ struct ibs_op_sample {
 */
 static void clear_ibs_nmi(void);
 
-static unsigned long reset_value[NUM_COUNTERS];
 static int ibs_allowed;	/* AMD Family10h and later */
 
 struct op_ibs_config {
@@ -118,6 +121,8 @@ struct op_ibs_config {
 
 static struct op_ibs_config ibs_config;
 
+#endif
+
 /* functions for op_amd_spec */
 
 static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
@@ -188,6 +193,8 @@ static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
 	}
 }
 
+#ifdef CONFIG_OPROFILE_IBS
+
 static inline int
 op_amd_handle_ibs(struct pt_regs * const regs,
 		  struct op_msrs const * const msrs)
@@ -261,6 +268,8 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 	return 1;
 }
 
+#endif
+
 static int op_amd_check_ctrs(struct pt_regs * const regs,
 			     struct op_msrs const * const msrs)
 {
@@ -277,7 +286,9 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 		}
 	}
 
+#ifdef CONFIG_OPROFILE_IBS
 	op_amd_handle_ibs(regs, msrs);
+#endif
 
 	/* See op_model_ppro.c */
 	return 1;
@@ -294,6 +305,8 @@ static void op_amd_start(struct op_msrs const * const msrs)
 			CTRL_WRITE(low, high, msrs, i);
 		}
 	}
+
+#ifdef CONFIG_OPROFILE_IBS
 	if (ibs_allowed && ibs_config.fetch_enabled) {
 		low = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
 		high = IBS_FETCH_HIGH_ENABLE;
@@ -305,6 +318,7 @@ static void op_amd_start(struct op_msrs const * const msrs)
 		high = 0;
 		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
 	}
+#endif
 }
 
 
@@ -323,6 +337,7 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 		CTRL_WRITE(low, high, msrs, i);
 	}
 
+#ifdef CONFIG_OPROFILE_IBS
 	if (ibs_allowed && ibs_config.fetch_enabled) {
 		low = 0;		/* clear max count and enable */
 		high = 0;
@@ -334,6 +349,7 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 		high = 0;
 		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
 	}
+#endif
 }
 
 static void op_amd_shutdown(struct op_msrs const * const msrs)
@@ -350,17 +366,10 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 	}
 }
 
-#ifndef CONFIG_SMP
+#ifndef CONFIG_OPROFILE_IBS
 
 /* no IBS support */
 
-static void setup_ibs(void)
-{
-	ibs_allowed = 0;
-}
-
-static void clear_ibs_nmi(void) {}
-
 static int op_amd_init(struct oprofile_operations *ops)
 {
 	return 0;
@@ -441,8 +450,12 @@ static void setup_ibs(void)
 	if (!ibs_allowed)
 		return;
 
-	if (pfm_amd64_setup_eilvt())
+	if (pfm_amd64_setup_eilvt()) {
 		ibs_allowed = 0;
+		return;
+	}
+
+	printk(KERN_INFO "oprofile: AMD IBS detected\n");
 }
 
 
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index e1782d2..ed98227 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -328,6 +328,8 @@ static void add_trace_begin(void)
 	add_event_entry(TRACE_BEGIN_CODE);
 }
 
+#ifdef CONFIG_OPROFILE_IBS
+
 #define IBS_FETCH_CODE_SIZE	2
 #define IBS_OP_CODE_SIZE	5
 #define IBS_EIP(offset)				\
@@ -390,6 +392,8 @@ static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
 	}
 }
 
+#endif
+
 static void add_sample_entry(unsigned long offset, unsigned long event)
 {
 	add_event_entry(offset);
@@ -586,6 +590,7 @@ void sync_buffer(int cpu)
 			} else if (s->event == CPU_TRACE_BEGIN) {
 				state = sb_bt_start;
 				add_trace_begin();
+#ifdef CONFIG_OPROFILE_IBS
 			} else if (s->event == IBS_FETCH_BEGIN) {
 				state = sb_bt_start;
 				add_ibs_begin(cpu_buf,
@@ -594,6 +599,7 @@ void sync_buffer(int cpu)
 				state = sb_bt_start;
 				add_ibs_begin(cpu_buf,
 					IBS_OP_CODE, in_kernel, mm);
+#endif
 			} else {
 				struct mm_struct *oldmm = mm;
 
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index c9ac4e1..aba905b 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -253,6 +253,8 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 	oprofile_add_ext_sample(pc, regs, event, is_kernel);
 }
 
+#ifdef CONFIG_OPROFILE_IBS
+
 #define MAX_IBS_SAMPLE_SIZE	14
 static int log_ibs_sample(struct oprofile_cpu_buffer *cpu_buf,
 	unsigned long pc, int is_kernel, unsigned  int *ibs, int ibs_code)
@@ -318,6 +320,8 @@ void oprofile_add_ibs_sample(struct pt_regs *const regs,
 		oprofile_ops.backtrace(regs, backtrace_depth);
 }
 
+#endif
+
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
-- 
1.5.5.4


