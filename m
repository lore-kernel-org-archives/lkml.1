Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYJQMs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYJQMs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbYJQMsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:48:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:21607 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbYJQMsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=B03lkOKWT/bmnxiIZy52+KeXHb0YcqrKXf2dQB48/ZHDJrV3B7yp9hxHi3xOXKUzc1
         w+7/GRJVlYIl3x+VwgI3VkxrUEhcbch8o8sw7ECdlSuKueAilVetqVu+OrP3RRtIkHrm
         DG9XieWGs49/S03B3VYHbLyep46xRYercYjjw=
Date: Fri, 17 Oct 2008 16:51:10 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 23/31] proc: move /proc/vmstat boilerplate to mm/vmstat.c
Message-ID: <20081017125110.GX22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 2b7053a4fcfdda346a1339047e954dbbfa6c5501 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 04:17:48 +0400
Subject: [PATCH 23/31] proc: move /proc/vmstat boilerplate to mm/vmstat.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/proc_misc.c    |   12 ------------
 include/linux/vmstat.h |    1 -
 mm/vmstat.c            |   14 +++++++++++++-
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 828436f..4735ba6 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -68,17 +68,6 @@ static const struct file_operations proc_zoneinfo_file_operations = {
 	.release	= seq_release,
 };
 
-static int vmstat_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &vmstat_op);
-}
-static const struct file_operations proc_vmstat_file_operations = {
-	.open		= vmstat_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 #ifdef CONFIG_BLOCK
 static int diskstats_open(struct inode *inode, struct file *file)
 {
@@ -244,7 +233,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
 	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);
 #ifdef CONFIG_BLOCK
 	proc_create("diskstats", 0, NULL, &proc_diskstats_operations);
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index e34e3ed..26d36dc 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -45,7 +45,6 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 };
 
 extern const struct seq_operations zoneinfo_op;
-extern const struct seq_operations vmstat_op;
 extern int sysctl_stat_interval;
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f8f37a2..dc76249 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -837,13 +837,24 @@ static void vmstat_stop(struct seq_file *m, void *arg)
 	m->private = NULL;
 }
 
-const struct seq_operations vmstat_op = {
+static const struct seq_operations vmstat_op = {
 	.start	= vmstat_start,
 	.next	= vmstat_next,
 	.stop	= vmstat_stop,
 	.show	= vmstat_show,
 };
 
+static int vmstat_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &vmstat_op);
+}
+
+static const struct file_operations proc_vmstat_file_operations = {
+	.open		= vmstat_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SMP
@@ -917,6 +928,7 @@ static int __init setup_vmstat(void)
 #ifdef CONFIG_PROC_FS
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
 	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
+	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
 #endif
 	return 0;
 }
-- 
1.5.6.5

