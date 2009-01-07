Return-Path: <linux-kernel-owner+w=401wt.eu-S1763313AbZAGXBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763313AbZAGXBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762906AbZAGW6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:58:13 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:64956 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762219AbZAGW6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:58:09 -0500
X-BigFish: VPS6(zzzzzz2b68kz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KD4IG8-02-ZH7-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 6/9] oprofile: use new data sample format for ibs
Date: Wed, 7 Jan 2009 23:45:22 +0100
Message-ID: <1231368325-19246-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
References: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:57:46.0523 (UTC) FILETIME=[5B381EB0:01C9711B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new ring buffer implementation allows the storage of samples with
different size. This patch implements the usage of the new sample
format to store ibs samples in the cpu buffer. Until now, writing to
the cpu buffer could lead to incomplete sampling sequences since IBS
samples were transfered in multiple samples. Due to a full buffer,
data could be lost at any time. This can't happen any more since the
complete data is reserved in advance and then stored in a single
sample.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |  119 +++++++++++++-------------------------
 drivers/oprofile/buffer_sync.c   |   53 ++++-------------
 drivers/oprofile/cpu_buffer.c    |   39 +++++++-----
 drivers/oprofile/cpu_buffer.h    |    2 -
 4 files changed, 76 insertions(+), 137 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index f101724..cf310ae 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -22,6 +22,7 @@
 
 #include "op_x86_model.h"
 #include "op_counter.h"
+#include "../../../drivers/oprofile/cpu_buffer.h"
 
 #define NUM_COUNTERS 4
 #define NUM_CONTROLS 4
@@ -60,51 +61,16 @@ static unsigned long reset_value[NUM_COUNTERS];
 #define IBS_OP_LOW_VALID_BIT		(1ULL<<18)	/* bit 18 */
 #define IBS_OP_LOW_ENABLE		(1ULL<<17)	/* bit 17 */
 
-/* Codes used in cpu_buffer.c */
-/* This produces duplicate code, need to be fixed */
-#define IBS_FETCH_BEGIN         (1UL << 4)
-#define IBS_OP_BEGIN            (1UL << 5)
-
 /*
  * The function interface needs to be fixed, something like add
  * data. Should then be added to linux/oprofile.h.
  */
-extern void
-oprofile_add_ibs_sample(struct pt_regs * const regs,
-			unsigned int * const ibs_sample, int ibs_code);
-
-struct ibs_fetch_sample {
-	/* MSRC001_1031 IBS Fetch Linear Address Register */
-	unsigned int ibs_fetch_lin_addr_low;
-	unsigned int ibs_fetch_lin_addr_high;
-	/* MSRC001_1030 IBS Fetch Control Register */
-	unsigned int ibs_fetch_ctl_low;
-	unsigned int ibs_fetch_ctl_high;
-	/* MSRC001_1032 IBS Fetch Physical Address Register */
-	unsigned int ibs_fetch_phys_addr_low;
-	unsigned int ibs_fetch_phys_addr_high;
-};
+extern
+void oprofile_add_data(struct op_entry *entry, struct pt_regs * const regs,
+		       unsigned long pc, int code, int size);
 
-struct ibs_op_sample {
-	/* MSRC001_1034 IBS Op Logical Address Register (IbsRIP) */
-	unsigned int ibs_op_rip_low;
-	unsigned int ibs_op_rip_high;
-	/* MSRC001_1035 IBS Op Data Register */
-	unsigned int ibs_op_data1_low;
-	unsigned int ibs_op_data1_high;
-	/* MSRC001_1036 IBS Op Data 2 Register */
-	unsigned int ibs_op_data2_low;
-	unsigned int ibs_op_data2_high;
-	/* MSRC001_1037 IBS Op Data 3 Register */
-	unsigned int ibs_op_data3_low;
-	unsigned int ibs_op_data3_high;
-	/* MSRC001_1038 IBS DC Linear Address Register (IbsDcLinAd) */
-	unsigned int ibs_dc_linear_low;
-	unsigned int ibs_dc_linear_high;
-	/* MSRC001_1039 IBS DC Physical Address Register (IbsDcPhysAd) */
-	unsigned int ibs_dc_phys_low;
-	unsigned int ibs_dc_phys_high;
-};
+#define IBS_FETCH_SIZE	6
+#define IBS_OP_SIZE	12
 
 static int has_ibs;	/* AMD Family10h and later */
 
@@ -197,9 +163,9 @@ static inline int
 op_amd_handle_ibs(struct pt_regs * const regs,
 		  struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
-	struct ibs_fetch_sample ibs_fetch;
-	struct ibs_op_sample ibs_op;
+	u32 low, high;
+	u64 msr;
+	struct op_entry entry;
 
 	if (!has_ibs)
 		return 1;
@@ -207,21 +173,19 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 	if (ibs_config.fetch_enabled) {
 		rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 		if (high & IBS_FETCH_HIGH_VALID_BIT) {
-			ibs_fetch.ibs_fetch_ctl_high = high;
-			ibs_fetch.ibs_fetch_ctl_low = low;
-			rdmsr(MSR_AMD64_IBSFETCHLINAD, low, high);
-			ibs_fetch.ibs_fetch_lin_addr_high = high;
-			ibs_fetch.ibs_fetch_lin_addr_low = low;
-			rdmsr(MSR_AMD64_IBSFETCHPHYSAD, low, high);
-			ibs_fetch.ibs_fetch_phys_addr_high = high;
-			ibs_fetch.ibs_fetch_phys_addr_low = low;
-
-			oprofile_add_ibs_sample(regs,
-						(unsigned int *)&ibs_fetch,
-						IBS_FETCH_BEGIN);
+			rdmsrl(MSR_AMD64_IBSFETCHLINAD, msr);
+			oprofile_add_data(&entry, regs, msr, IBS_FETCH_CODE,
+					  IBS_FETCH_SIZE);
+			op_cpu_buffer_add_data(&entry, (u32)msr);
+			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			op_cpu_buffer_add_data(&entry, low);
+			op_cpu_buffer_add_data(&entry, high);
+			rdmsrl(MSR_AMD64_IBSFETCHPHYSAD, msr);
+			op_cpu_buffer_add_data(&entry, (u32)msr);
+			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			op_cpu_buffer_write_commit(&entry);
 
 			/* reenable the IRQ */
-			rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 			high &= ~IBS_FETCH_HIGH_VALID_BIT;
 			high |= IBS_FETCH_HIGH_ENABLE;
 			low &= IBS_FETCH_LOW_MAX_CNT_MASK;
@@ -232,30 +196,29 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 	if (ibs_config.op_enabled) {
 		rdmsr(MSR_AMD64_IBSOPCTL, low, high);
 		if (low & IBS_OP_LOW_VALID_BIT) {
-			rdmsr(MSR_AMD64_IBSOPRIP, low, high);
-			ibs_op.ibs_op_rip_low = low;
-			ibs_op.ibs_op_rip_high = high;
-			rdmsr(MSR_AMD64_IBSOPDATA, low, high);
-			ibs_op.ibs_op_data1_low = low;
-			ibs_op.ibs_op_data1_high = high;
-			rdmsr(MSR_AMD64_IBSOPDATA2, low, high);
-			ibs_op.ibs_op_data2_low = low;
-			ibs_op.ibs_op_data2_high = high;
-			rdmsr(MSR_AMD64_IBSOPDATA3, low, high);
-			ibs_op.ibs_op_data3_low = low;
-			ibs_op.ibs_op_data3_high = high;
-			rdmsr(MSR_AMD64_IBSDCLINAD, low, high);
-			ibs_op.ibs_dc_linear_low = low;
-			ibs_op.ibs_dc_linear_high = high;
-			rdmsr(MSR_AMD64_IBSDCPHYSAD, low, high);
-			ibs_op.ibs_dc_phys_low = low;
-			ibs_op.ibs_dc_phys_high = high;
+			rdmsrl(MSR_AMD64_IBSOPRIP, msr);
+			oprofile_add_data(&entry, regs, msr, IBS_OP_CODE,
+					  IBS_OP_SIZE);
+			op_cpu_buffer_add_data(&entry, (u32)msr);
+			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			rdmsrl(MSR_AMD64_IBSOPDATA, msr);
+			op_cpu_buffer_add_data(&entry, (u32)msr);
+			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			rdmsrl(MSR_AMD64_IBSOPDATA2, msr);
+			op_cpu_buffer_add_data(&entry, (u32)msr);
+			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			rdmsrl(MSR_AMD64_IBSOPDATA3, msr);
+			op_cpu_buffer_add_data(&entry, (u32)msr);
+			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			rdmsrl(MSR_AMD64_IBSDCLINAD, msr);
+			op_cpu_buffer_add_data(&entry, (u32)msr);
+			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			rdmsrl(MSR_AMD64_IBSDCPHYSAD, msr);
+			op_cpu_buffer_add_data(&entry, (u32)msr);
+			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			op_cpu_buffer_write_commit(&entry);
 
 			/* reenable the IRQ */
-			oprofile_add_ibs_sample(regs,
-						(unsigned int *)&ibs_op,
-						IBS_OP_BEGIN);
-			rdmsr(MSR_AMD64_IBSOPCTL, low, high);
 			high = 0;
 			low &= ~IBS_OP_LOW_VALID_BIT;
 			low |= IBS_OP_LOW_ENABLE;
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index f9031d3..d692fdc 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -318,29 +318,18 @@ static void add_trace_begin(void)
 
 #ifdef CONFIG_OPROFILE_IBS
 
-#define IBS_FETCH_CODE_SIZE	2
-#define IBS_OP_CODE_SIZE	5
-
-/*
- * Add IBS fetch and op entries to event buffer
- */
-static void add_ibs_begin(int cpu, int code, struct mm_struct *mm)
+static void add_data(struct op_entry *entry, struct mm_struct *mm)
 {
-	unsigned long pc;
-	int i, count;
-	unsigned long cookie = 0;
+	unsigned long code, pc, val;
+	unsigned long cookie;
 	off_t offset;
-	struct op_entry entry;
-	struct op_sample *sample;
 
-	sample = op_cpu_buffer_read_entry(&entry, cpu);
-	if (!sample)
+	if (!op_cpu_buffer_get_data(entry, &code))
+		return;
+	if (!op_cpu_buffer_get_data(entry, &pc))
+		return;
+	if (!op_cpu_buffer_get_size(entry))
 		return;
-	pc = sample->eip;
-
-#ifdef __LP64__
-	pc += sample->event << 32;
-#endif
 
 	if (mm) {
 		cookie = lookup_dcookie(mm, pc, &offset);
@@ -362,24 +351,8 @@ static void add_ibs_begin(int cpu, int code, struct mm_struct *mm)
 	add_event_entry(code);
 	add_event_entry(offset);	/* Offset from Dcookie */
 
-	/* we send the Dcookie offset, but send the raw Linear Add also*/
-	add_event_entry(sample->eip);
-	add_event_entry(sample->event);
-
-	if (code == IBS_FETCH_CODE)
-		count = IBS_FETCH_CODE_SIZE;	/*IBS FETCH is 2 int64s*/
-	else
-		count = IBS_OP_CODE_SIZE;	/*IBS OP is 5 int64s*/
-
-	for (i = 0; i < count; i++) {
-		sample = op_cpu_buffer_read_entry(&entry, cpu);
-		if (!sample)
-			return;
-		add_event_entry(sample->eip);
-		add_event_entry(sample->event);
-	}
-
-	return;
+	while (op_cpu_buffer_get_data(entry, &val))
+		add_event_entry(val);
 }
 
 #endif
@@ -572,10 +545,8 @@ void sync_buffer(int cpu)
 				add_user_ctx_switch(new, cookie);
 			}
 #ifdef CONFIG_OPROFILE_IBS
-			if (flags & IBS_FETCH_BEGIN)
-				add_ibs_begin(cpu, IBS_FETCH_CODE, mm);
-			if (flags & IBS_OP_BEGIN)
-				add_ibs_begin(cpu, IBS_OP_CODE, mm);
+			if (op_cpu_buffer_get_size(&entry))
+				add_data(&entry, mm);
 #endif
 			continue;
 		}
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 1b65907..ddba9d0 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -363,31 +363,38 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 
 #ifdef CONFIG_OPROFILE_IBS
 
-void oprofile_add_ibs_sample(struct pt_regs * const regs,
-			     unsigned int * const ibs_sample, int ibs_code)
+/*
+ * Add samples with data to the ring buffer.
+ *
+ * Use op_cpu_buffer_add_data(&entry, val) to add data and
+ * op_cpu_buffer_write_commit(&entry) to commit the sample.
+ */
+void oprofile_add_data(struct op_entry *entry, struct pt_regs * const regs,
+		       unsigned long pc, int code, int size)
 {
+	struct op_sample *sample;
 	int is_kernel = !user_mode(regs);
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
-	int fail = 0;
 
 	cpu_buf->sample_received++;
 
-	/* backtraces disabled for ibs */
-	fail = fail || op_add_code(cpu_buf, 0, is_kernel, current);
+	/* no backtraces for samples with data */
+	if (op_add_code(cpu_buf, 0, is_kernel, current))
+		goto fail;
 
-	fail = fail || op_add_sample(cpu_buf, ESCAPE_CODE,   ibs_code);
-	fail = fail || op_add_sample(cpu_buf, ibs_sample[0], ibs_sample[1]);
-	fail = fail || op_add_sample(cpu_buf, ibs_sample[2], ibs_sample[3]);
-	fail = fail || op_add_sample(cpu_buf, ibs_sample[4], ibs_sample[5]);
+	sample = op_cpu_buffer_write_reserve(entry, size + 2);
+	if (!sample)
+		goto fail;
+	sample->eip = ESCAPE_CODE;
+	sample->event = 0;		/* no flags */
 
-	if (ibs_code == IBS_OP_BEGIN) {
-		fail = fail || op_add_sample(cpu_buf, ibs_sample[6], ibs_sample[7]);
-		fail = fail || op_add_sample(cpu_buf, ibs_sample[8], ibs_sample[9]);
-		fail = fail || op_add_sample(cpu_buf, ibs_sample[10], ibs_sample[11]);
-	}
+	op_cpu_buffer_add_data(entry, code);
+	op_cpu_buffer_add_data(entry, pc);
+
+	return;
 
-	if (fail)
-		cpu_buf->sample_lost_overflow++;
+fail:
+	cpu_buf->sample_lost_overflow++;
 }
 
 #endif
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index f343760..525cc4d 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -115,7 +115,5 @@ int op_cpu_buffer_get_data(struct op_entry *entry, unsigned long *val)
 #define IS_KERNEL		(1UL << 1)
 #define TRACE_BEGIN		(1UL << 2)
 #define USER_CTX_SWITCH		(1UL << 3)
-#define IBS_FETCH_BEGIN		(1UL << 4)
-#define IBS_OP_BEGIN		(1UL << 5)
 
 #endif /* OPROFILE_CPU_BUFFER_H */
-- 
1.6.0.1


