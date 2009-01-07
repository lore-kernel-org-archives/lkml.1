Return-Path: <linux-kernel-owner+w=401wt.eu-S1763449AbZAGXB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763449AbZAGXB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762948AbZAGW6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:58:15 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:22328 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762626AbZAGW6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:58:10 -0500
X-BigFish: VPS6(zzzzzz2b68kz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KD4IGC-01-LSR-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 9/9] oprofile: make new cpu buffer functions part of the api
Date: Wed, 7 Jan 2009 23:45:25 +0100
Message-ID: <1231368325-19246-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
References: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:57:46.0632 (UTC) FILETIME=[5B48C080:01C9711B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates the new functions

 oprofile_write_reserve()
 oprofile_add_data()
 oprofile_write_commit()

and makes them part of the oprofile api.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   57 ++++++++++++++++----------------------
 drivers/oprofile/cpu_buffer.c    |   17 +++++++++--
 drivers/oprofile/cpu_buffer.h    |    8 +----
 include/linux/oprofile.h         |   18 ++++++++++++
 4 files changed, 57 insertions(+), 43 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index cf310ae..8fdf06e 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -22,7 +22,6 @@
 
 #include "op_x86_model.h"
 #include "op_counter.h"
-#include "../../../drivers/oprofile/cpu_buffer.h"
 
 #define NUM_COUNTERS 4
 #define NUM_CONTROLS 4
@@ -61,14 +60,6 @@ static unsigned long reset_value[NUM_COUNTERS];
 #define IBS_OP_LOW_VALID_BIT		(1ULL<<18)	/* bit 18 */
 #define IBS_OP_LOW_ENABLE		(1ULL<<17)	/* bit 17 */
 
-/*
- * The function interface needs to be fixed, something like add
- * data. Should then be added to linux/oprofile.h.
- */
-extern
-void oprofile_add_data(struct op_entry *entry, struct pt_regs * const regs,
-		       unsigned long pc, int code, int size);
-
 #define IBS_FETCH_SIZE	6
 #define IBS_OP_SIZE	12
 
@@ -174,16 +165,16 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 		rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 		if (high & IBS_FETCH_HIGH_VALID_BIT) {
 			rdmsrl(MSR_AMD64_IBSFETCHLINAD, msr);
-			oprofile_add_data(&entry, regs, msr, IBS_FETCH_CODE,
-					  IBS_FETCH_SIZE);
-			op_cpu_buffer_add_data(&entry, (u32)msr);
-			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
-			op_cpu_buffer_add_data(&entry, low);
-			op_cpu_buffer_add_data(&entry, high);
+			oprofile_write_reserve(&entry, regs, msr,
+					       IBS_FETCH_CODE, IBS_FETCH_SIZE);
+			oprofile_add_data(&entry, (u32)msr);
+			oprofile_add_data(&entry, (u32)(msr >> 32));
+			oprofile_add_data(&entry, low);
+			oprofile_add_data(&entry, high);
 			rdmsrl(MSR_AMD64_IBSFETCHPHYSAD, msr);
-			op_cpu_buffer_add_data(&entry, (u32)msr);
-			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
-			op_cpu_buffer_write_commit(&entry);
+			oprofile_add_data(&entry, (u32)msr);
+			oprofile_add_data(&entry, (u32)(msr >> 32));
+			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
 			high &= ~IBS_FETCH_HIGH_VALID_BIT;
@@ -197,26 +188,26 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 		rdmsr(MSR_AMD64_IBSOPCTL, low, high);
 		if (low & IBS_OP_LOW_VALID_BIT) {
 			rdmsrl(MSR_AMD64_IBSOPRIP, msr);
-			oprofile_add_data(&entry, regs, msr, IBS_OP_CODE,
-					  IBS_OP_SIZE);
-			op_cpu_buffer_add_data(&entry, (u32)msr);
-			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			oprofile_write_reserve(&entry, regs, msr,
+					       IBS_OP_CODE, IBS_OP_SIZE);
+			oprofile_add_data(&entry, (u32)msr);
+			oprofile_add_data(&entry, (u32)(msr >> 32));
 			rdmsrl(MSR_AMD64_IBSOPDATA, msr);
-			op_cpu_buffer_add_data(&entry, (u32)msr);
-			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			oprofile_add_data(&entry, (u32)msr);
+			oprofile_add_data(&entry, (u32)(msr >> 32));
 			rdmsrl(MSR_AMD64_IBSOPDATA2, msr);
-			op_cpu_buffer_add_data(&entry, (u32)msr);
-			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			oprofile_add_data(&entry, (u32)msr);
+			oprofile_add_data(&entry, (u32)(msr >> 32));
 			rdmsrl(MSR_AMD64_IBSOPDATA3, msr);
-			op_cpu_buffer_add_data(&entry, (u32)msr);
-			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			oprofile_add_data(&entry, (u32)msr);
+			oprofile_add_data(&entry, (u32)(msr >> 32));
 			rdmsrl(MSR_AMD64_IBSDCLINAD, msr);
-			op_cpu_buffer_add_data(&entry, (u32)msr);
-			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
+			oprofile_add_data(&entry, (u32)msr);
+			oprofile_add_data(&entry, (u32)(msr >> 32));
 			rdmsrl(MSR_AMD64_IBSDCPHYSAD, msr);
-			op_cpu_buffer_add_data(&entry, (u32)msr);
-			op_cpu_buffer_add_data(&entry, (u32)(msr >> 32));
-			op_cpu_buffer_write_commit(&entry);
+			oprofile_add_data(&entry, (u32)msr);
+			oprofile_add_data(&entry, (u32)(msr >> 32));
+			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
 			high = 0;
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index b846af6..2e03b6d 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -364,10 +364,11 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 /*
  * Add samples with data to the ring buffer.
  *
- * Use op_cpu_buffer_add_data(&entry, val) to add data and
- * op_cpu_buffer_write_commit(&entry) to commit the sample.
+ * Use oprofile_add_data(&entry, val) to add data and
+ * oprofile_write_commit(&entry) to commit the sample.
  */
-void oprofile_add_data(struct op_entry *entry, struct pt_regs * const regs,
+void
+oprofile_write_reserve(struct op_entry *entry, struct pt_regs * const regs,
 		       unsigned long pc, int code, int size)
 {
 	struct op_sample *sample;
@@ -395,6 +396,16 @@ fail:
 	cpu_buf->sample_lost_overflow++;
 }
 
+int oprofile_add_data(struct op_entry *entry, unsigned long val)
+{
+	return op_cpu_buffer_add_data(entry, val);
+}
+
+int oprofile_write_commit(struct op_entry *entry)
+{
+	return op_cpu_buffer_write_commit(entry);
+}
+
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 525cc4d..63f81c4 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -35,13 +35,7 @@ struct op_sample {
 	unsigned long data[0];
 };
 
-struct op_entry {
-	struct ring_buffer_event *event;
-	struct op_sample *sample;
-	unsigned long irq_flags;
-	unsigned long size;
-	unsigned long *data;
-};
+struct op_entry;
 
 struct oprofile_cpu_buffer {
 	unsigned long buffer_size;
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 1ce9fe5..1d9518b 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -164,4 +164,22 @@ void oprofile_put_buff(unsigned long *buf, unsigned int start,
 unsigned long oprofile_get_cpu_buffer_size(void);
 void oprofile_cpu_buffer_inc_smpl_lost(void);
  
+/* cpu buffer functions */
+
+struct op_sample;
+
+struct op_entry {
+	struct ring_buffer_event *event;
+	struct op_sample *sample;
+	unsigned long irq_flags;
+	unsigned long size;
+	unsigned long *data;
+};
+
+void oprofile_write_reserve(struct op_entry *entry,
+			    struct pt_regs * const regs,
+			    unsigned long pc, int code, int size);
+int oprofile_add_data(struct op_entry *entry, unsigned long val);
+int oprofile_write_commit(struct op_entry *entry);
+
 #endif /* OPROFILE_H */
-- 
1.6.0.1


