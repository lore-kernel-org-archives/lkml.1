Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbZAGXAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbZAGXAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762737AbZAGW6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:58:11 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:22163 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761610AbZAGW6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:58:07 -0500
X-BigFish: VPS1(zzzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KD4IG8-01-LSO-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/9] oprofile: add op_cpu_buffer_get_data()
Date: Wed, 7 Jan 2009 23:45:21 +0100
Message-ID: <1231368325-19246-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
References: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:57:46.0491 (UTC) FILETIME=[5B333CB0:01C9711B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function provides access to attached data of a sample. It returns
the size of data including the current value. Also,
op_cpu_buffer_get_size() is available to check if there is data
attached.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |    6 ++++--
 drivers/oprofile/cpu_buffer.h  |   20 ++++++++++++++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index d969bb1..f9031d3 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -524,6 +524,7 @@ void sync_buffer(int cpu)
 {
 	struct mm_struct *mm = NULL;
 	struct mm_struct *oldmm;
+	unsigned long val;
 	struct task_struct *new;
 	unsigned long cookie = 0;
 	int in_kernel = 1;
@@ -559,10 +560,11 @@ void sync_buffer(int cpu)
 					state = sb_sample_start;
 				add_kernel_ctx_switch(flags & IS_KERNEL);
 			}
-			if (flags & USER_CTX_SWITCH) {
+			if (flags & USER_CTX_SWITCH
+			    && op_cpu_buffer_get_data(&entry, &val)) {
 				/* userspace context switch */
+				new = (struct task_struct *)val;
 				oldmm = mm;
-				new = (struct task_struct *)sample->data[0];
 				release_mm(oldmm);
 				mm = take_tasks_mm(new);
 				if (mm != oldmm)
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index e178dd2..f343760 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -90,6 +90,26 @@ int op_cpu_buffer_add_data(struct op_entry *entry, unsigned long val)
 	return entry->size;
 }
 
+/* returns the size of data in the entry */
+static inline
+int op_cpu_buffer_get_size(struct op_entry *entry)
+{
+	return entry->size;
+}
+
+/* returns 0 if empty or the size of data including the current value */
+static inline
+int op_cpu_buffer_get_data(struct op_entry *entry, unsigned long *val)
+{
+	int size = entry->size;
+	if (!size)
+		return 0;
+	*val = *entry->data;
+	entry->size--;
+	entry->data++;
+	return size;
+}
+
 /* extra data flags */
 #define KERNEL_CTX_SWITCH	(1UL << 0)
 #define IS_KERNEL		(1UL << 1)
-- 
1.6.0.1


