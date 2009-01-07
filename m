Return-Path: <linux-kernel-owner+w=401wt.eu-S1763182AbZAGW7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763182AbZAGW7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760174AbZAGW6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:58:05 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:64646 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758656AbZAGW6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:58:01 -0500
X-BigFish: VPS-1(zz541Lzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KD4IG3-01-LSF-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/9] oprofile: add op_cpu_buffer_write_reserve()
Date: Wed, 7 Jan 2009 23:45:17 +0100
Message-ID: <1231368325-19246-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
References: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:57:46.0382 (UTC) FILETIME=[5B229AE0:01C9711B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function prepares the cpu buffer to write a sample.

Struct op_entry is used during operations on the ring buffer while
struct op_sample contains the data that is stored in the ring
buffer. Struct entry can be uninitialized. The function reserves a
data array that is specified by size. Use op_cpu_buffer_write_commit()
after preparing the sample. In case of errors a null pointer is
returned, otherwise the pointer to the sample.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |   43 ++++++++++++++++++++++++++++------------
 drivers/oprofile/cpu_buffer.h |    9 ++++++-
 2 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index ac79f66..934ff15 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -1,11 +1,12 @@
 /**
  * @file cpu_buffer.c
  *
- * @remark Copyright 2002 OProfile authors
+ * @remark Copyright 2002-2009 OProfile authors
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
  * @author Barry Kasindorf <barry.kasindorf@amd.com>
+ * @author Robert Richter <robert.richter@amd.com>
  *
  * Each CPU has a local buffer that stores PC value/event
  * pairs. We also log context switches when we notice them.
@@ -143,20 +144,36 @@ void end_cpu_work(void)
 	flush_scheduled_work();
 }
 
-int op_cpu_buffer_write_entry(struct op_entry *entry)
+/*
+ * This function prepares the cpu buffer to write a sample.
+ *
+ * Struct op_entry is used during operations on the ring buffer while
+ * struct op_sample contains the data that is stored in the ring
+ * buffer. Struct entry can be uninitialized. The function reserves a
+ * data array that is specified by size. Use
+ * op_cpu_buffer_write_commit() after preparing the sample. In case of
+ * errors a null pointer is returned, otherwise the pointer to the
+ * sample.
+ *
+ */
+struct op_sample
+*op_cpu_buffer_write_reserve(struct op_entry *entry, unsigned long size)
 {
-	entry->event = ring_buffer_lock_reserve(op_ring_buffer_write,
-						sizeof(struct op_sample),
-						&entry->irq_flags);
+	entry->event = ring_buffer_lock_reserve
+		(op_ring_buffer_write, sizeof(struct op_sample) +
+		 size * sizeof(entry->sample->data[0]), &entry->irq_flags);
 	if (entry->event)
 		entry->sample = ring_buffer_event_data(entry->event);
 	else
 		entry->sample = NULL;
 
 	if (!entry->sample)
-		return -ENOMEM;
+		return NULL;
 
-	return 0;
+	entry->size = size;
+	entry->data = entry->sample->data;
+
+	return entry->sample;
 }
 
 int op_cpu_buffer_write_commit(struct op_entry *entry)
@@ -192,14 +209,14 @@ op_add_sample(struct oprofile_cpu_buffer *cpu_buf,
 	      unsigned long pc, unsigned long event)
 {
 	struct op_entry entry;
-	int ret;
+	struct op_sample *sample;
 
-	ret = op_cpu_buffer_write_entry(&entry);
-	if (ret)
-		return ret;
+	sample = op_cpu_buffer_write_reserve(&entry, 0);
+	if (!sample)
+		return -ENOMEM;
 
-	entry.sample->eip = pc;
-	entry.sample->event = event;
+	sample->eip = pc;
+	sample->event = event;
 
 	return op_cpu_buffer_write_commit(&entry);
 }
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 65b763a..2d4bfde 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -1,10 +1,11 @@
 /**
  * @file cpu_buffer.h
  *
- * @remark Copyright 2002 OProfile authors
+ * @remark Copyright 2002-2009 OProfile authors
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
+ * @author Robert Richter <robert.richter@amd.com>
  */
 
 #ifndef OPROFILE_CPU_BUFFER_H
@@ -31,12 +32,15 @@ void end_cpu_work(void);
 struct op_sample {
 	unsigned long eip;
 	unsigned long event;
+	unsigned long data[0];
 };
 
 struct op_entry {
 	struct ring_buffer_event *event;
 	struct op_sample *sample;
 	unsigned long irq_flags;
+	unsigned long size;
+	unsigned long *data;
 };
 
 struct oprofile_cpu_buffer {
@@ -68,7 +72,8 @@ static inline void op_cpu_buffer_reset(int cpu)
 	cpu_buf->last_task = NULL;
 }
 
-int op_cpu_buffer_write_entry(struct op_entry *entry);
+struct op_sample
+*op_cpu_buffer_write_reserve(struct op_entry *entry, unsigned long size);
 int op_cpu_buffer_write_commit(struct op_entry *entry);
 struct op_sample *op_cpu_buffer_read_entry(int cpu);
 unsigned long op_cpu_buffer_entries(int cpu);
-- 
1.6.0.1


