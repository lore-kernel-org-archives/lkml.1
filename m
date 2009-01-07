Return-Path: <linux-kernel-owner+w=401wt.eu-S1762182AbZAGWXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762182AbZAGWXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762117AbZAGWXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:14 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:20814 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761595AbZAGWXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:12 -0500
X-BigFish: VPS1(zzzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KD4GU8-01-K3P-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/18] oprofile: rename kernel-wide identifiers
Date: Wed, 7 Jan 2009 23:17:18 +0100
Message-ID: <1231366655-17837-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0350 (UTC) FILETIME=[7F2ACB60:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames kernel-wide identifiers to something more oprofile
specific names.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c     |   12 ++++++------
 drivers/oprofile/event_buffer.c   |    4 ++--
 drivers/oprofile/oprof.c          |    4 ++--
 drivers/oprofile/oprof.h          |    8 ++++----
 drivers/oprofile/oprofile_files.c |   27 ++++++++++++++-------------
 5 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 6109096..fcf96f6 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -66,7 +66,7 @@ void free_cpu_buffers(void)
 
 unsigned long oprofile_get_cpu_buffer_size(void)
 {
-	return fs_cpu_buffer_size;
+	return oprofile_cpu_buffer_size;
 }
 
 void oprofile_cpu_buffer_inc_smpl_lost(void)
@@ -81,7 +81,7 @@ int alloc_cpu_buffers(void)
 {
 	int i;
 
-	unsigned long buffer_size = fs_cpu_buffer_size;
+	unsigned long buffer_size = oprofile_cpu_buffer_size;
 
 	op_ring_buffer_read = ring_buffer_alloc(buffer_size, OP_BUFFER_FLAGS);
 	if (!op_ring_buffer_read)
@@ -238,7 +238,7 @@ void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 
-	if (!backtrace_depth) {
+	if (!oprofile_backtrace_depth) {
 		log_sample(cpu_buf, pc, is_kernel, event);
 		return;
 	}
@@ -251,7 +251,7 @@ void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 	 * source of this event
 	 */
 	if (log_sample(cpu_buf, pc, is_kernel, event))
-		oprofile_ops.backtrace(regs, backtrace_depth);
+		oprofile_ops.backtrace(regs, oprofile_backtrace_depth);
 	oprofile_end_trace(cpu_buf);
 }
 
@@ -308,8 +308,8 @@ void oprofile_add_ibs_sample(struct pt_regs * const regs,
 	if (fail)
 		goto fail;
 
-	if (backtrace_depth)
-		oprofile_ops.backtrace(regs, backtrace_depth);
+	if (oprofile_backtrace_depth)
+		oprofile_ops.backtrace(regs, oprofile_backtrace_depth);
 
 	return;
 
diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index 191a320..2b7ae36 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -73,8 +73,8 @@ int alloc_event_buffer(void)
 	unsigned long flags;
 
 	spin_lock_irqsave(&oprofilefs_lock, flags);
-	buffer_size = fs_buffer_size;
-	buffer_watershed = fs_buffer_watershed;
+	buffer_size = oprofile_buffer_size;
+	buffer_watershed = oprofile_buffer_watershed;
 	spin_unlock_irqrestore(&oprofilefs_lock, flags);
 
 	if (buffer_watershed >= buffer_size)
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index cd37590..3cffce9 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -23,7 +23,7 @@
 struct oprofile_operations oprofile_ops;
 
 unsigned long oprofile_started;
-unsigned long backtrace_depth;
+unsigned long oprofile_backtrace_depth;
 static unsigned long is_setup;
 static DEFINE_MUTEX(start_mutex);
 
@@ -172,7 +172,7 @@ int oprofile_set_backtrace(unsigned long val)
 		goto out;
 	}
 
-	backtrace_depth = val;
+	oprofile_backtrace_depth = val;
 
 out:
 	mutex_unlock(&start_mutex);
diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
index 5df0c21..c288d3c 100644
--- a/drivers/oprofile/oprof.h
+++ b/drivers/oprofile/oprof.h
@@ -21,12 +21,12 @@ void oprofile_stop(void);
 
 struct oprofile_operations;
 
-extern unsigned long fs_buffer_size;
-extern unsigned long fs_cpu_buffer_size;
-extern unsigned long fs_buffer_watershed;
+extern unsigned long oprofile_buffer_size;
+extern unsigned long oprofile_cpu_buffer_size;
+extern unsigned long oprofile_buffer_watershed;
 extern struct oprofile_operations oprofile_ops;
 extern unsigned long oprofile_started;
-extern unsigned long backtrace_depth;
+extern unsigned long oprofile_backtrace_depth;
 
 struct super_block;
 struct dentry;
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index d820199..5d36ffc 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -14,17 +14,18 @@
 #include "oprofile_stats.h"
 #include "oprof.h"
 
-#define FS_BUFFER_SIZE_DEFAULT		131072
-#define FS_CPU_BUFFER_SIZE_DEFAULT	8192
-#define FS_BUFFER_WATERSHED_DEFAULT	32768	/* FIXME: tune */
+#define BUFFER_SIZE_DEFAULT		131072
+#define CPU_BUFFER_SIZE_DEFAULT		8192
+#define BUFFER_WATERSHED_DEFAULT	32768	/* FIXME: tune */
 
-unsigned long fs_buffer_size;
-unsigned long fs_cpu_buffer_size;
-unsigned long fs_buffer_watershed;
+unsigned long oprofile_buffer_size;
+unsigned long oprofile_cpu_buffer_size;
+unsigned long oprofile_buffer_watershed;
 
 static ssize_t depth_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
-	return oprofilefs_ulong_to_user(backtrace_depth, buf, count, offset);
+	return oprofilefs_ulong_to_user(oprofile_backtrace_depth, buf, count,
+					offset);
 }
 
 
@@ -125,16 +126,16 @@ static const struct file_operations dump_fops = {
 void oprofile_create_files(struct super_block *sb, struct dentry *root)
 {
 	/* reinitialize default values */
-	fs_buffer_size =	FS_BUFFER_SIZE_DEFAULT;
-	fs_cpu_buffer_size =	FS_CPU_BUFFER_SIZE_DEFAULT;
-	fs_buffer_watershed =	FS_BUFFER_WATERSHED_DEFAULT;
+	oprofile_buffer_size =		BUFFER_SIZE_DEFAULT;
+	oprofile_cpu_buffer_size =	CPU_BUFFER_SIZE_DEFAULT;
+	oprofile_buffer_watershed =	BUFFER_WATERSHED_DEFAULT;
 
 	oprofilefs_create_file(sb, root, "enable", &enable_fops);
 	oprofilefs_create_file_perm(sb, root, "dump", &dump_fops, 0666);
 	oprofilefs_create_file(sb, root, "buffer", &event_buffer_fops);
-	oprofilefs_create_ulong(sb, root, "buffer_size", &fs_buffer_size);
-	oprofilefs_create_ulong(sb, root, "buffer_watershed", &fs_buffer_watershed);
-	oprofilefs_create_ulong(sb, root, "cpu_buffer_size", &fs_cpu_buffer_size);
+	oprofilefs_create_ulong(sb, root, "buffer_size", &oprofile_buffer_size);
+	oprofilefs_create_ulong(sb, root, "buffer_watershed", &oprofile_buffer_watershed);
+	oprofilefs_create_ulong(sb, root, "cpu_buffer_size", &oprofile_cpu_buffer_size);
 	oprofilefs_create_file(sb, root, "cpu_type", &cpu_type_fops);
 	oprofilefs_create_file(sb, root, "backtrace_depth", &depth_fops);
 	oprofilefs_create_file(sb, root, "pointer_size", &pointer_size_fops);
-- 
1.6.0.1


