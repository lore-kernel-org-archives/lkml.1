Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbYLKQzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbYLKQzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbYLKQth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:49:37 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:25475 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbYLKQtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:49:35 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBQ1DJ-02-VND-01
From: Robert Richter <robert.richter@amd.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/9] oprofile: adding cpu buffer r/w access functions
Date: Thu, 11 Dec 2008 17:41:55 +0100
Message-ID: <1229013723-8191-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:56.0978 (UTC) FILETIME=[5BD44720:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for changes in the cpu buffer implementation.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |   20 +++++++++-----------
 drivers/oprofile/cpu_buffer.c  |    2 +-
 drivers/oprofile/cpu_buffer.h  |   12 ++++++++++++
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 7d61ae8..44f676c 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -331,10 +331,8 @@ static void add_trace_begin(void)
 
 #define IBS_FETCH_CODE_SIZE	2
 #define IBS_OP_CODE_SIZE	5
-#define IBS_EIP(offset)				\
-	(((struct op_sample *)&cpu_buf->buffer[(offset)])->eip)
-#define IBS_EVENT(offset)				\
-	(((struct op_sample *)&cpu_buf->buffer[(offset)])->event)
+#define IBS_EIP(cpu_buf)	((cpu_buffer_read_entry(cpu_buf))->eip)
+#define IBS_EVENT(cpu_buf)	((cpu_buffer_read_entry(cpu_buf))->event)
 
 /*
  * Add IBS fetch and op entries to event buffer
@@ -349,10 +347,10 @@ static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
 
 	increment_tail(cpu_buf);	/* move to RIP entry */
 
-	rip = IBS_EIP(cpu_buf->tail_pos);
+	rip = IBS_EIP(cpu_buf);
 
 #ifdef __LP64__
-	rip += IBS_EVENT(cpu_buf->tail_pos) << 32;
+	rip += IBS_EVENT(cpu_buf) << 32;
 #endif
 
 	if (mm) {
@@ -376,8 +374,8 @@ static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
 	add_event_entry(offset);	/* Offset from Dcookie */
 
 	/* we send the Dcookie offset, but send the raw Linear Add also*/
-	add_event_entry(IBS_EIP(cpu_buf->tail_pos));
-	add_event_entry(IBS_EVENT(cpu_buf->tail_pos));
+	add_event_entry(IBS_EIP(cpu_buf));
+	add_event_entry(IBS_EVENT(cpu_buf));
 
 	if (code == IBS_FETCH_CODE)
 		count = IBS_FETCH_CODE_SIZE;	/*IBS FETCH is 2 int64s*/
@@ -386,8 +384,8 @@ static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
 
 	for (i = 0; i < count; i++) {
 		increment_tail(cpu_buf);
-		add_event_entry(IBS_EIP(cpu_buf->tail_pos));
-		add_event_entry(IBS_EVENT(cpu_buf->tail_pos));
+		add_event_entry(IBS_EIP(cpu_buf));
+		add_event_entry(IBS_EVENT(cpu_buf));
 	}
 }
 
@@ -584,7 +582,7 @@ void sync_buffer(int cpu)
 #else
 	while (get_slots(cpu_buf)) {
 #endif
-		struct op_sample *s = &cpu_buf->buffer[cpu_buf->tail_pos];
+		struct op_sample *s = cpu_buffer_read_entry(cpu_buf);
 
 		if (is_code(s->eip)) {
 			switch (s->event) {
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 2c4d541..7e5e650 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -168,7 +168,7 @@ static inline void
 add_sample(struct oprofile_cpu_buffer *cpu_buf,
 	   unsigned long pc, unsigned long event)
 {
-	struct op_sample *entry = &cpu_buf->buffer[cpu_buf->head_pos];
+	struct op_sample *entry = cpu_buffer_write_entry(cpu_buf);
 	entry->eip = pc;
 	entry->event = event;
 	increment_head(cpu_buf);
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index d3cc262..0870699 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -52,6 +52,18 @@ DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
 void cpu_buffer_reset(struct oprofile_cpu_buffer *cpu_buf);
 
+static inline
+struct op_sample *cpu_buffer_write_entry(struct oprofile_cpu_buffer *cpu_buf)
+{
+	return &cpu_buf->buffer[cpu_buf->head_pos];
+}
+
+static inline
+struct op_sample *cpu_buffer_read_entry(struct oprofile_cpu_buffer *cpu_buf)
+{
+	return &cpu_buf->buffer[cpu_buf->tail_pos];
+}
+
 /* transient events for the CPU buffer -> event buffer */
 #define CPU_IS_KERNEL 1
 #define CPU_TRACE_BEGIN 2
-- 
1.6.0.1


