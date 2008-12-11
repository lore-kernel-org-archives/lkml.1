Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbYLKQzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbYLKQzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbYLKQtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:49:23 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:38522 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbYLKQtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:49:20 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBQ1DL-01-7Q7-01
From: Robert Richter <robert.richter@amd.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 8/9] oprofile: fix lost sample counter
Date: Thu, 11 Dec 2008 17:42:02 +0100
Message-ID: <1229013723-8191-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:57.0197 (UTC) FILETIME=[5BF5B1D0:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of lost samples could be greater than the number of
received samples. This patches fixes this. The implementation
introduces return values for add_sample() and add_code().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |   83 ++++++++++++++++++++++++++---------------
 1 files changed, 53 insertions(+), 30 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 7f7fc95..6109096 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -145,32 +145,31 @@ void end_cpu_work(void)
 	flush_scheduled_work();
 }
 
-static inline void
+static inline int
 add_sample(struct oprofile_cpu_buffer *cpu_buf,
 	   unsigned long pc, unsigned long event)
 {
 	struct op_entry entry;
+	int ret;
 
-	if (cpu_buffer_write_entry(&entry))
-		goto Error;
+	ret = cpu_buffer_write_entry(&entry);
+	if (ret)
+		return ret;
 
 	entry.sample->eip = pc;
 	entry.sample->event = event;
 
-	if (cpu_buffer_write_commit(&entry))
-		goto Error;
+	ret = cpu_buffer_write_commit(&entry);
+	if (ret)
+		return ret;
 
-	return;
-
-Error:
-	cpu_buf->sample_lost_overflow++;
-	return;
+	return 0;
 }
 
-static inline void
+static inline int
 add_code(struct oprofile_cpu_buffer *buffer, unsigned long value)
 {
-	add_sample(buffer, ESCAPE_CODE, value);
+	return add_sample(buffer, ESCAPE_CODE, value);
 }
 
 /* This must be safe from any context. It's safe writing here
@@ -201,17 +200,25 @@ static int log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
 	/* notice a switch from user->kernel or vice versa */
 	if (cpu_buf->last_is_kernel != is_kernel) {
 		cpu_buf->last_is_kernel = is_kernel;
-		add_code(cpu_buf, is_kernel);
+		if (add_code(cpu_buf, is_kernel))
+			goto fail;
 	}
 
 	/* notice a task switch */
 	if (cpu_buf->last_task != task) {
 		cpu_buf->last_task = task;
-		add_code(cpu_buf, (unsigned long)task);
+		if (add_code(cpu_buf, (unsigned long)task))
+			goto fail;
 	}
 
-	add_sample(cpu_buf, pc, event);
+	if (add_sample(cpu_buf, pc, event))
+		goto fail;
+
 	return 1;
+
+fail:
+	cpu_buf->sample_lost_overflow++;
+	return 0;
 }
 
 static int oprofile_begin_trace(struct oprofile_cpu_buffer *cpu_buf)
@@ -266,37 +273,49 @@ void oprofile_add_ibs_sample(struct pt_regs * const regs,
 	int is_kernel = !user_mode(regs);
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 	struct task_struct *task;
+	int fail = 0;
 
 	cpu_buf->sample_received++;
 
 	/* notice a switch from user->kernel or vice versa */
 	if (cpu_buf->last_is_kernel != is_kernel) {
+		if (add_code(cpu_buf, is_kernel))
+			goto fail;
 		cpu_buf->last_is_kernel = is_kernel;
-		add_code(cpu_buf, is_kernel);
 	}
 
 	/* notice a task switch */
 	if (!is_kernel) {
 		task = current;
 		if (cpu_buf->last_task != task) {
+			if (add_code(cpu_buf, (unsigned long)task))
+				goto fail;
 			cpu_buf->last_task = task;
-			add_code(cpu_buf, (unsigned long)task);
 		}
 	}
 
-	add_code(cpu_buf, ibs_code);
-	add_sample(cpu_buf, ibs_sample[0], ibs_sample[1]);
-	add_sample(cpu_buf, ibs_sample[2], ibs_sample[3]);
-	add_sample(cpu_buf, ibs_sample[4], ibs_sample[5]);
+	fail = fail || add_code(cpu_buf, ibs_code);
+	fail = fail || add_sample(cpu_buf, ibs_sample[0], ibs_sample[1]);
+	fail = fail || add_sample(cpu_buf, ibs_sample[2], ibs_sample[3]);
+	fail = fail || add_sample(cpu_buf, ibs_sample[4], ibs_sample[5]);
 
 	if (ibs_code == IBS_OP_BEGIN) {
-		add_sample(cpu_buf, ibs_sample[6], ibs_sample[7]);
-		add_sample(cpu_buf, ibs_sample[8], ibs_sample[9]);
-		add_sample(cpu_buf, ibs_sample[10], ibs_sample[11]);
+		fail = fail || add_sample(cpu_buf, ibs_sample[6], ibs_sample[7]);
+		fail = fail || add_sample(cpu_buf, ibs_sample[8], ibs_sample[9]);
+		fail = fail || add_sample(cpu_buf, ibs_sample[10], ibs_sample[11]);
 	}
 
+	if (fail)
+		goto fail;
+
 	if (backtrace_depth)
 		oprofile_ops.backtrace(regs, backtrace_depth);
+
+	return;
+
+fail:
+	cpu_buf->sample_lost_overflow++;
+	return;
 }
 
 #endif
@@ -318,13 +337,17 @@ void oprofile_add_trace(unsigned long pc)
 	 * broken frame can give an eip with the same value as an
 	 * escape code, abort the trace if we get it
 	 */
-	if (pc == ESCAPE_CODE) {
-		cpu_buf->tracing = 0;
-		cpu_buf->backtrace_aborted++;
-		return;
-	}
+	if (pc == ESCAPE_CODE)
+		goto fail;
+
+	if (add_sample(cpu_buf, pc, 0))
+		goto fail;
 
-	add_sample(cpu_buf, pc, 0);
+	return;
+fail:
+	cpu_buf->tracing = 0;
+	cpu_buf->backtrace_aborted++;
+	return;
 }
 
 /*
-- 
1.6.0.1


