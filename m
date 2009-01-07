Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbZAGWZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbZAGWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762215AbZAGWXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:19 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:49560 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762094AbZAGWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:15 -0500
X-BigFish: VPS1(zzzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KD4GU3-02-XT4-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 03/18] oprofile: remove ring buffer inline functions in cpu_buffer.h
Date: Wed, 7 Jan 2009 23:17:20 +0100
Message-ID: <1231366655-17837-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0288 (UTC) FILETIME=[7F215580:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves ring buffer inline functions to cpu_buffer.c.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |   48 +++++++++++++++++++++++++++++++++++++-
 drivers/oprofile/cpu_buffer.h |   50 +++-------------------------------------
 2 files changed, 50 insertions(+), 48 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index e52c085..cd67d4d 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -45,8 +45,8 @@
  * can be changed to a single buffer solution when the ring buffer
  * access is implemented as non-locking atomic code.
  */
-struct ring_buffer *op_ring_buffer_read;
-struct ring_buffer *op_ring_buffer_write;
+static struct ring_buffer *op_ring_buffer_read;
+static struct ring_buffer *op_ring_buffer_write;
 DEFINE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
 static void wq_sync_buffer(struct work_struct *work);
@@ -145,6 +145,50 @@ void end_cpu_work(void)
 	flush_scheduled_work();
 }
 
+int op_cpu_buffer_write_entry(struct op_entry *entry)
+{
+	entry->event = ring_buffer_lock_reserve(op_ring_buffer_write,
+						sizeof(struct op_sample),
+						&entry->irq_flags);
+	if (entry->event)
+		entry->sample = ring_buffer_event_data(entry->event);
+	else
+		entry->sample = NULL;
+
+	if (!entry->sample)
+		return -ENOMEM;
+
+	return 0;
+}
+
+int op_cpu_buffer_write_commit(struct op_entry *entry)
+{
+	return ring_buffer_unlock_commit(op_ring_buffer_write, entry->event,
+					 entry->irq_flags);
+}
+
+struct op_sample *op_cpu_buffer_read_entry(int cpu)
+{
+	struct ring_buffer_event *e;
+	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
+	if (e)
+		return ring_buffer_event_data(e);
+	if (ring_buffer_swap_cpu(op_ring_buffer_read,
+				 op_ring_buffer_write,
+				 cpu))
+		return NULL;
+	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
+	if (e)
+		return ring_buffer_event_data(e);
+	return NULL;
+}
+
+unsigned long op_cpu_buffer_entries(int cpu)
+{
+	return ring_buffer_entries_cpu(op_ring_buffer_read, cpu)
+		+ ring_buffer_entries_cpu(op_ring_buffer_write, cpu);
+}
+
 static inline int
 add_sample(struct oprofile_cpu_buffer *cpu_buf,
 	   unsigned long pc, unsigned long event)
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 83d491e..cd28abc 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -54,8 +54,6 @@ struct oprofile_cpu_buffer {
 	struct delayed_work work;
 };
 
-extern struct ring_buffer *op_ring_buffer_read;
-extern struct ring_buffer *op_ring_buffer_write;
 DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
 /*
@@ -72,50 +70,10 @@ static inline void op_cpu_buffer_reset(int cpu)
 	cpu_buf->last_task = NULL;
 }
 
-static inline int op_cpu_buffer_write_entry(struct op_entry *entry)
-{
-	entry->event = ring_buffer_lock_reserve(op_ring_buffer_write,
-						sizeof(struct op_sample),
-						&entry->irq_flags);
-	if (entry->event)
-		entry->sample = ring_buffer_event_data(entry->event);
-	else
-		entry->sample = NULL;
-
-	if (!entry->sample)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static inline int op_cpu_buffer_write_commit(struct op_entry *entry)
-{
-	return ring_buffer_unlock_commit(op_ring_buffer_write, entry->event,
-					 entry->irq_flags);
-}
-
-static inline struct op_sample *op_cpu_buffer_read_entry(int cpu)
-{
-	struct ring_buffer_event *e;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
-	if (e)
-		return ring_buffer_event_data(e);
-	if (ring_buffer_swap_cpu(op_ring_buffer_read,
-				 op_ring_buffer_write,
-				 cpu))
-		return NULL;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
-	if (e)
-		return ring_buffer_event_data(e);
-	return NULL;
-}
-
-/* "acquire" as many cpu buffer slots as we can */
-static inline unsigned long op_cpu_buffer_entries(int cpu)
-{
-	return ring_buffer_entries_cpu(op_ring_buffer_read, cpu)
-		+ ring_buffer_entries_cpu(op_ring_buffer_write, cpu);
-}
+int op_cpu_buffer_write_entry(struct op_entry *entry);
+int op_cpu_buffer_write_commit(struct op_entry *entry);
+struct op_sample *op_cpu_buffer_read_entry(int cpu);
+unsigned long op_cpu_buffer_entries(int cpu);
 
 /* transient events for the CPU buffer -> event buffer */
 #define CPU_IS_KERNEL 1
-- 
1.6.0.1


