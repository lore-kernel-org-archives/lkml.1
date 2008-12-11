Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYLKQxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYLKQxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbYLKQtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:49:16 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:24095 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbYLKQtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:49:13 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBQ1DJ-02-VNH-01
From: Robert Richter <robert.richter@amd.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/9] oprofile: adding cpu_buffer_entries()
Date: Thu, 11 Dec 2008 17:41:57 +0100
Message-ID: <1229013723-8191-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:57.0009 (UTC) FILETIME=[5BD90210:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for changes in the cpu buffer implementation.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |   31 ++-----------------------------
 drivers/oprofile/cpu_buffer.h  |   27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 44f676c..aed286c 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -464,33 +464,6 @@ static inline int is_code(unsigned long val)
 }
 
 
-/* "acquire" as many cpu buffer slots as we can */
-static unsigned long get_slots(struct oprofile_cpu_buffer *b)
-{
-	unsigned long head = b->head_pos;
-	unsigned long tail = b->tail_pos;
-
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
-	if (head >= tail)
-		return head - tail;
-
-	return head + (b->buffer_size - tail);
-}
-
-
 /* Move tasks along towards death. Any tasks on dead_tasks
  * will definitely have no remaining references in any
  * CPU buffers at this point, because we use two lists,
@@ -576,11 +549,11 @@ void sync_buffer(int cpu)
 	/* Remember, only we can modify tail_pos */
 
 #ifndef CONFIG_OPROFILE_IBS
-	available = get_slots(cpu_buf);
+	available = cpu_buffer_entries(cpu_buf);
 
 	for (i = 0; i < available; ++i) {
 #else
-	while (get_slots(cpu_buf)) {
+	while (cpu_buffer_entries(cpu_buf)) {
 #endif
 		struct op_sample *s = cpu_buffer_read_entry(cpu_buf);
 
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index e608976..6055b56 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -81,6 +81,33 @@ struct op_sample *cpu_buffer_read_entry(struct oprofile_cpu_buffer *cpu_buf)
 	return &cpu_buf->buffer[cpu_buf->tail_pos];
 }
 
+/* "acquire" as many cpu buffer slots as we can */
+static inline
+unsigned long cpu_buffer_entries(struct oprofile_cpu_buffer *b)
+{
+	unsigned long head = b->head_pos;
+	unsigned long tail = b->tail_pos;
+
+	/*
+	 * Subtle. This resets the persistent last_task
+	 * and in_kernel values used for switching notes.
+	 * BUT, there is a small window between reading
+	 * head_pos, and this call, that means samples
+	 * can appear at the new head position, but not
+	 * be prefixed with the notes for switching
+	 * kernel mode or a task switch. This small hole
+	 * can lead to mis-attribution or samples where
+	 * we don't know if it's in the kernel or not,
+	 * at the start of an event buffer.
+	 */
+	cpu_buffer_reset(b);
+
+	if (head >= tail)
+		return head - tail;
+
+	return head + (b->buffer_size - tail);
+}
+
 /* transient events for the CPU buffer -> event buffer */
 #define CPU_IS_KERNEL 1
 #define CPU_TRACE_BEGIN 2
-- 
1.6.0.1


