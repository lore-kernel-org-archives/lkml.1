Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbYLKQxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbYLKQxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbYLKQtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:49:17 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:37303 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbYLKQtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:49:13 -0500
X-BigFish: VPS1(zzzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBQ1DH-02-VNA-01
From: Robert Richter <robert.richter@amd.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/9] oprofile: adding cpu_buffer_write_commit()
Date: Thu, 11 Dec 2008 17:41:56 +0100
Message-ID: <1229013723-8191-3-git-send-email-robert.richter@amd.com>
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
 drivers/oprofile/cpu_buffer.c |   18 +-----------------
 drivers/oprofile/cpu_buffer.h |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 7e5e650..d6f5de6 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -148,22 +148,6 @@ static unsigned long nr_available_slots(struct oprofile_cpu_buffer const *b)
 	return tail + (b->buffer_size - head) - 1;
 }
 
-static void increment_head(struct oprofile_cpu_buffer *b)
-{
-	unsigned long new_head = b->head_pos + 1;
-
-	/*
-	 * Ensure anything written to the slot before we increment is
-	 * visible
-	 */
-	wmb();
-
-	if (new_head < b->buffer_size)
-		b->head_pos = new_head;
-	else
-		b->head_pos = 0;
-}
-
 static inline void
 add_sample(struct oprofile_cpu_buffer *cpu_buf,
 	   unsigned long pc, unsigned long event)
@@ -171,7 +155,7 @@ add_sample(struct oprofile_cpu_buffer *cpu_buf,
 	struct op_sample *entry = cpu_buffer_write_entry(cpu_buf);
 	entry->eip = pc;
 	entry->event = event;
-	increment_head(cpu_buf);
+	cpu_buffer_write_commit(cpu_buf);
 }
 
 static inline void
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 0870699..e608976 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -59,6 +59,23 @@ struct op_sample *cpu_buffer_write_entry(struct oprofile_cpu_buffer *cpu_buf)
 }
 
 static inline
+void cpu_buffer_write_commit(struct oprofile_cpu_buffer *b)
+{
+	unsigned long new_head = b->head_pos + 1;
+
+	/*
+	 * Ensure anything written to the slot before we increment is
+	 * visible
+	 */
+	wmb();
+
+	if (new_head < b->buffer_size)
+		b->head_pos = new_head;
+	else
+		b->head_pos = 0;
+}
+
+static inline
 struct op_sample *cpu_buffer_read_entry(struct oprofile_cpu_buffer *cpu_buf)
 {
 	return &cpu_buf->buffer[cpu_buf->tail_pos];
-- 
1.6.0.1


