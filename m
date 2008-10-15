Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYJOVDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYJOVDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYJOVCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:02:53 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:24401 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYJOVCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:02:52 -0400
X-BigFish: VPS11(zz78fbpzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0K8ST49-01-4G9-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/8] OProfile: Rework oprofile_add_ibs_sample() function
Date: Wed, 15 Oct 2008 22:09:03 +0200
Message-ID: <1224101350-12877-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <20081015110444.GA28703@elte.hu>
References: <20081015110444.GA28703@elte.hu>
X-OriginalArrivalTime: 15 Oct 2008 21:02:38.0799 (UTC) FILETIME=[5B3215F0:01C92F09]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code looks much more cleaner now.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    5 ++-
 drivers/oprofile/cpu_buffer.c    |   48 ++++++++++++--------------------------
 2 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index d9faf60..54632e0 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -67,8 +67,9 @@ static unsigned long reset_value[NUM_COUNTERS];
 
 /* The function interface needs to be fixed, something like add
    data. Should then be added to linux/oprofile.h. */
-extern void oprofile_add_ibs_sample(struct pt_regs *const regs,
-				    unsigned int * const ibs_sample, u8 code);
+extern void
+oprofile_add_ibs_sample(struct pt_regs *const regs,
+			unsigned int * const ibs_sample, int ibs_code);
 
 struct ibs_fetch_sample {
 	/* MSRC001_1031 IBS Fetch Linear Address Register */
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index e1bd5a9..d6c6827 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -257,21 +257,23 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 
 #ifdef CONFIG_OPROFILE_IBS
 
-#define MAX_IBS_SAMPLE_SIZE	14
-static int log_ibs_sample(struct oprofile_cpu_buffer *cpu_buf,
-	unsigned long pc, int is_kernel, unsigned  int *ibs, int ibs_code)
+#define MAX_IBS_SAMPLE_SIZE 14
+
+void oprofile_add_ibs_sample(struct pt_regs *const regs,
+			     unsigned int * const ibs_sample, int ibs_code)
 {
+	int is_kernel = !user_mode(regs);
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 	struct task_struct *task;
 
 	cpu_buf->sample_received++;
 
 	if (nr_available_slots(cpu_buf) < MAX_IBS_SAMPLE_SIZE) {
+		/* we can't backtrace since we lost the source of this event */
 		cpu_buf->sample_lost_overflow++;
-		return 0;
+		return;
 	}
 
-	is_kernel = !!is_kernel;
-
 	/* notice a switch from user->kernel or vice versa */
 	if (cpu_buf->last_is_kernel != is_kernel) {
 		cpu_buf->last_is_kernel = is_kernel;
@@ -281,7 +283,6 @@ static int log_ibs_sample(struct oprofile_cpu_buffer *cpu_buf,
 	/* notice a task switch */
 	if (!is_kernel) {
 		task = current;
-
 		if (cpu_buf->last_task != task) {
 			cpu_buf->last_task = task;
 			add_code(cpu_buf, (unsigned long)task);
@@ -289,36 +290,17 @@ static int log_ibs_sample(struct oprofile_cpu_buffer *cpu_buf,
 	}
 
 	add_code(cpu_buf, ibs_code);
-	add_sample(cpu_buf, ibs[0], ibs[1]);
-	add_sample(cpu_buf, ibs[2], ibs[3]);
-	add_sample(cpu_buf, ibs[4], ibs[5]);
+	add_sample(cpu_buf, ibs_sample[0], ibs_sample[1]);
+	add_sample(cpu_buf, ibs_sample[2], ibs_sample[3]);
+	add_sample(cpu_buf, ibs_sample[4], ibs_sample[5]);
 
 	if (ibs_code == IBS_OP_BEGIN) {
-	add_sample(cpu_buf, ibs[6], ibs[7]);
-	add_sample(cpu_buf, ibs[8], ibs[9]);
-	add_sample(cpu_buf, ibs[10], ibs[11]);
-	}
-
-	return 1;
-}
-
-void oprofile_add_ibs_sample(struct pt_regs *const regs,
-				unsigned int * const ibs_sample, u8 code)
-{
-	int is_kernel = !user_mode(regs);
-	unsigned long pc = profile_pc(regs);
-
-	struct oprofile_cpu_buffer *cpu_buf =
-			 &per_cpu(cpu_buffer, smp_processor_id());
-
-	if (!backtrace_depth) {
-		log_ibs_sample(cpu_buf, pc, is_kernel, ibs_sample, code);
-		return;
+		add_sample(cpu_buf, ibs_sample[6], ibs_sample[7]);
+		add_sample(cpu_buf, ibs_sample[8], ibs_sample[9]);
+		add_sample(cpu_buf, ibs_sample[10], ibs_sample[11]);
 	}
 
-	/* if log_sample() fails we can't backtrace since we lost the source
-	* of this event */
-	if (log_ibs_sample(cpu_buf, pc, is_kernel, ibs_sample, code))
+	if (backtrace_depth)
 		oprofile_ops.backtrace(regs, backtrace_depth);
 }
 
-- 
1.6.0.1


