Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbYLKQwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbYLKQwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbYLKQtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:49:13 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:50348 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599AbYLKQtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:49:10 -0500
X-BigFish: VPS1(zzzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KBQ1DI-02-VNC-01
From: Robert Richter <robert.richter@amd.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/9] oprofile: moving cpu_buffer_reset() to cpu_buffer.h
Date: Thu, 11 Dec 2008 17:41:58 +0100
Message-ID: <1229013723-8191-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:57.0056 (UTC) FILETIME=[5BE02E00:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for changes in the cpu buffer implementation.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |    1 +
 drivers/oprofile/cpu_buffer.c  |   12 ------------
 drivers/oprofile/cpu_buffer.h  |   28 +++++++++++++---------------
 3 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index aed286c..944a583 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -548,6 +548,7 @@ void sync_buffer(int cpu)
 
 	/* Remember, only we can modify tail_pos */
 
+	cpu_buffer_reset(cpu);
 #ifndef CONFIG_OPROFILE_IBS
 	available = cpu_buffer_entries(cpu_buf);
 
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index d6f5de6..5cf7efe 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -124,18 +124,6 @@ void end_cpu_work(void)
 	flush_scheduled_work();
 }
 
-/* Resets the cpu buffer to a sane state. */
-void cpu_buffer_reset(struct oprofile_cpu_buffer *cpu_buf)
-{
-	/*
-	 * reset these to invalid values; the next sample collected
-	 * will populate the buffer with proper values to initialize
-	 * the buffer
-	 */
-	cpu_buf->last_is_kernel = -1;
-	cpu_buf->last_task = NULL;
-}
-
 /* compute number of available slots in cpu_buffer queue */
 static unsigned long nr_available_slots(struct oprofile_cpu_buffer const *b)
 {
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 6055b56..895763f 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -50,7 +50,19 @@ struct oprofile_cpu_buffer {
 
 DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
-void cpu_buffer_reset(struct oprofile_cpu_buffer *cpu_buf);
+/*
+ * Resets the cpu buffer to a sane state.
+ *
+ * reset these to invalid values; the next sample collected will
+ * populate the buffer with proper values to initialize the buffer
+ */
+static inline void cpu_buffer_reset(int cpu)
+{
+	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
+
+	cpu_buf->last_is_kernel = -1;
+	cpu_buf->last_task = NULL;
+}
 
 static inline
 struct op_sample *cpu_buffer_write_entry(struct oprofile_cpu_buffer *cpu_buf)
@@ -88,20 +100,6 @@ unsigned long cpu_buffer_entries(struct oprofile_cpu_buffer *b)
 	unsigned long head = b->head_pos;
 	unsigned long tail = b->tail_pos;
 
-	/*
-	 * Subtle. This resets the persistent last_task
-	 * and in_kernel values used for switching notes.
-	 * BUT, there is a small window between reading
-	 * head_pos, and this call, that means samples
-	 * can appear at the new head position, but not
-	 * be prefixed with the notes for switching
-	 * kernel mode or a task switch. This small hole
-	 * can lead to mis-attribution or samples where
-	 * we don't know if it's in the kernel or not,
-	 * at the start of an event buffer.
-	 */
-	cpu_buffer_reset(b);
-
 	if (head >= tail)
 		return head - tail;
 
-- 
1.6.0.1


