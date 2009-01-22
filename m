Return-Path: <linux-kernel-owner+w=401wt.eu-S1760324AbZAVRzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbZAVRzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbZAVRun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:50:43 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39034 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760112AbZAVRuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:50:32 -0500
Message-Id: <20090122175027.881139000@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 22 Jan 2009 11:49:24 -0600
From: steiner@sgi.com
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 07/14] Add statistics to the GRU context management functions
References: <20090122174917.563627000@sgi.com>
Content-Disposition: inline; filename=uv_outofline_mcs_instructions_statistics
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add statistics to the GRU context management functions.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gruhandles.c |   12 +++++++++++
 drivers/misc/sgi-gru/gruprocfs.c  |   39 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/sgi-gru/grutables.h  |    8 +++++++
 3 files changed, 59 insertions(+)

Index: linux/drivers/misc/sgi-gru/gruhandles.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.c	2009-01-15 08:18:08.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gruhandles.c	2009-01-15 08:18:09.000000000 -0600
@@ -35,6 +35,16 @@
 /* Extract the status field from a kernel handle */
 #define GET_MSEG_HANDLE_STATUS(h)	(((*(unsigned long *)(h)) >> 16) & 3)
 
+struct mcs_op_statistic mcs_op_statistics[mcsop_last];
+
+static void update_mcs_stats(enum mcs_op op, unsigned long clks)
+{
+	atomic_long_inc(&mcs_op_statistics[op].count);
+	atomic_long_add(clks, &mcs_op_statistics[op].total);
+	if (mcs_op_statistics[op].max < clks)
+		mcs_op_statistics[op].max = clks;
+}
+
 static void start_instruction(void *h)
 {
 	unsigned long *w0 = h;
@@ -57,6 +67,8 @@ static int wait_instruction_complete(voi
 		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time))
 			panic("GRU %p is malfunctioning\n", h);
 	}
+	if (gru_options & OPT_STATS)
+		update_mcs_stats(opc, get_cycles() - start_time);
 	return status;
 }
 
Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2009-01-15 08:18:06.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2009-01-15 08:18:09.000000000 -0600
@@ -122,6 +122,30 @@ static ssize_t statistics_write(struct f
 	return count;
 }
 
+static int mcs_statistics_show(struct seq_file *s, void *p)
+{
+	int op;
+	unsigned long total, count, max;
+	static char *id[] = {"cch_allocate", "cch_start", "cch_interrupt",
+		"cch_interrupt_sync", "cch_deallocate", "tgh_invalidate"};
+
+	for (op = 0; op < mcsop_last; op++) {
+		count = atomic_long_read(&mcs_op_statistics[op].count);
+		total = atomic_long_read(&mcs_op_statistics[op].total);
+		max = mcs_op_statistics[op].max;
+		seq_printf(s, "%-20s%12ld%12ld%12ld\n", id[op], count,
+			   count ? total / count : 0, max);
+	}
+	return 0;
+}
+
+static ssize_t mcs_statistics_write(struct file *file,
+			const char __user *userbuf, size_t count, loff_t *data)
+{
+	memset(mcs_op_statistics, 0, sizeof(mcs_op_statistics));
+	return count;
+}
+
 static int options_show(struct seq_file *s, void *p)
 {
 	seq_printf(s, "0x%lx\n", gru_options);
@@ -137,6 +161,7 @@ static ssize_t options_write(struct file
 	if (copy_from_user
 	    (buf, userbuf, count < sizeof(buf) ? count : sizeof(buf)))
 		return -EFAULT;
+	buf[count - 1] = '\0';
 	if (!strict_strtoul(buf, 10, &val))
 		gru_options = val;
 
@@ -233,6 +258,11 @@ static int statistics_open(struct inode 
 	return single_open(file, statistics_show, NULL);
 }
 
+static int mcs_statistics_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mcs_statistics_show, NULL);
+}
+
 static int options_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, options_show, NULL);
@@ -257,6 +287,14 @@ static const struct file_operations stat
 	.release 	= single_release,
 };
 
+static const struct file_operations mcs_statistics_fops = {
+	.open 		= mcs_statistics_open,
+	.read 		= seq_read,
+	.write 		= mcs_statistics_write,
+	.llseek 	= seq_lseek,
+	.release 	= single_release,
+};
+
 static const struct file_operations options_fops = {
 	.open 		= options_open,
 	.read 		= seq_read,
@@ -285,6 +323,7 @@ static struct proc_entry {
 	struct proc_dir_entry *entry;
 } proc_files[] = {
 	{"statistics", 0644, &statistics_fops},
+	{"mcs_statistics", 0644, &mcs_statistics_fops},
 	{"debug_options", 0644, &options_fops},
 	{"cch_status", 0444, &cch_fops},
 	{"gru_status", 0444, &gru_fops},
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-01-15 08:18:08.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-01-15 08:18:09.000000000 -0600
@@ -242,6 +242,14 @@ struct gru_stats_s {
 enum mcs_op {cchop_allocate, cchop_start, cchop_interrupt, cchop_interrupt_sync,
 	cchop_deallocate, tghop_invalidate, mcsop_last};
 
+struct mcs_op_statistic {
+	atomic_long_t	count;
+	atomic_long_t	total;
+	unsigned long	max;
+};
+
+extern struct mcs_op_statistic mcs_op_statistics[mcsop_last];
+
 #define OPT_DPRINT	1
 #define OPT_STATS	2
 #define GRU_QUICKLOOK	4

