Return-Path: <linux-kernel-owner+w=401wt.eu-S1763374AbZAGW6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763374AbZAGW6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759988AbZAGW6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:58:03 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:20418 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026AbZAGW6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:58:00 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KD4IG3-02-ZH3-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/9] oprofile: modify op_cpu_buffer_read_entry()
Date: Wed, 7 Jan 2009 23:45:18 +0100
Message-ID: <1231368325-19246-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
References: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:57:46.0398 (UTC) FILETIME=[5B250BE0:01C9711B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements the support of samples with attached data.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |   23 +++++++++++++----------
 drivers/oprofile/cpu_buffer.c  |   14 +++++++++++---
 drivers/oprofile/cpu_buffer.h  |    2 +-
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 21fd249..908202a 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -329,9 +329,10 @@ static void add_ibs_begin(int cpu, int code, struct mm_struct *mm)
 	int i, count;
 	unsigned long cookie = 0;
 	off_t offset;
+	struct op_entry entry;
 	struct op_sample *sample;
 
-	sample = op_cpu_buffer_read_entry(cpu);
+	sample = op_cpu_buffer_read_entry(&entry, cpu);
 	if (!sample)
 		return;
 	pc = sample->eip;
@@ -370,7 +371,7 @@ static void add_ibs_begin(int cpu, int code, struct mm_struct *mm)
 		count = IBS_OP_CODE_SIZE;	/*IBS OP is 5 int64s*/
 
 	for (i = 0; i < count; i++) {
-		sample = op_cpu_buffer_read_entry(cpu);
+		sample = op_cpu_buffer_read_entry(&entry, cpu);
 		if (!sample)
 			return;
 		add_event_entry(sample->eip);
@@ -528,6 +529,8 @@ void sync_buffer(int cpu)
 	sync_buffer_state state = sb_buffer_start;
 	unsigned int i;
 	unsigned long available;
+	struct op_entry entry;
+	struct op_sample *sample;
 
 	mutex_lock(&buffer_mutex);
 
@@ -537,19 +540,19 @@ void sync_buffer(int cpu)
 	available = op_cpu_buffer_entries(cpu);
 
 	for (i = 0; i < available; ++i) {
-		struct op_sample *s = op_cpu_buffer_read_entry(cpu);
-		if (!s)
+		sample = op_cpu_buffer_read_entry(&entry, cpu);
+		if (!sample)
 			break;
 
-		if (is_code(s->eip)) {
-			switch (s->event) {
+		if (is_code(sample->eip)) {
+			switch (sample->event) {
 			case 0:
 			case CPU_IS_KERNEL:
 				/* kernel/userspace switch */
-				in_kernel = s->event;
+				in_kernel = sample->event;
 				if (state == sb_buffer_start)
 					state = sb_sample_start;
-				add_kernel_ctx_switch(s->event);
+				add_kernel_ctx_switch(sample->event);
 				break;
 			case CPU_TRACE_BEGIN:
 				state = sb_bt_start;
@@ -566,7 +569,7 @@ void sync_buffer(int cpu)
 			default:
 				/* userspace context switch */
 				oldmm = mm;
-				new = (struct task_struct *)s->event;
+				new = (struct task_struct *)sample->event;
 				release_mm(oldmm);
 				mm = take_tasks_mm(new);
 				if (mm != oldmm)
@@ -581,7 +584,7 @@ void sync_buffer(int cpu)
 			/* ignore sample */
 			continue;
 
-		if (add_sample(mm, s, in_kernel))
+		if (add_sample(mm, sample, in_kernel))
 			continue;
 
 		/* ignore backtraces if failed to add a sample */
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 934ff15..400f7fc 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -182,20 +182,28 @@ int op_cpu_buffer_write_commit(struct op_entry *entry)
 					 entry->irq_flags);
 }
 
-struct op_sample *op_cpu_buffer_read_entry(int cpu)
+struct op_sample *op_cpu_buffer_read_entry(struct op_entry *entry, int cpu)
 {
 	struct ring_buffer_event *e;
 	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
 	if (e)
-		return ring_buffer_event_data(e);
+		goto event;
 	if (ring_buffer_swap_cpu(op_ring_buffer_read,
 				 op_ring_buffer_write,
 				 cpu))
 		return NULL;
 	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
 	if (e)
-		return ring_buffer_event_data(e);
+		goto event;
 	return NULL;
+
+event:
+	entry->event = e;
+	entry->sample = ring_buffer_event_data(e);
+	entry->size = (ring_buffer_event_length(e) - sizeof(struct op_sample))
+		/ sizeof(entry->sample->data[0]);
+	entry->data = entry->sample->data;
+	return entry->sample;
 }
 
 unsigned long op_cpu_buffer_entries(int cpu)
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 2d4bfde..d7c0545 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -75,7 +75,7 @@ static inline void op_cpu_buffer_reset(int cpu)
 struct op_sample
 *op_cpu_buffer_write_reserve(struct op_entry *entry, unsigned long size);
 int op_cpu_buffer_write_commit(struct op_entry *entry);
-struct op_sample *op_cpu_buffer_read_entry(int cpu);
+struct op_sample *op_cpu_buffer_read_entry(struct op_entry *entry, int cpu);
 unsigned long op_cpu_buffer_entries(int cpu);
 
 /* transient events for the CPU buffer -> event buffer */
-- 
1.6.0.1


