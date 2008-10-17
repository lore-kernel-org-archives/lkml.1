Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbYJQMtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbYJQMtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbYJQMsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:48:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:2467 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbYJQMsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=i6P0ORfEBgMRgzqTDUKYtemfs3CQPtEtWKrRwwQThAl/XZUQzHCQ6xzc202EPbLZnZ
         AS9ykjCk+21wW+IvhXTaqosYeo51VqlvOZdivRHrlVZ4y09DOpgDTO7dErnuJ8Z4snco
         giRt82ZlqqMzgq23Sa2Th6S4nrX2vjWhWibjs=
Date: Fri, 17 Oct 2008 16:51:26 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 24/31] proc: move /proc/zoneinfo boilerplate to mm/vmstat.c
Message-ID: <20081017125126.GY22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 3cc2a890493a60721678c1f965e96554b1b7cea4 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 04:19:42 +0400
Subject: [PATCH 24/31] proc: move /proc/zoneinfo boilerplate to mm/vmstat.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/proc_misc.c    |   13 -------------
 include/linux/vmstat.h |    1 -
 mm/vmstat.c            |   15 ++++++++++++++-
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 4735ba6..5ec0119 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -56,18 +56,6 @@
 #include <asm/div64.h>
 #include "internal.h"
 
-static int zoneinfo_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &zoneinfo_op);
-}
-
-static const struct file_operations proc_zoneinfo_file_operations = {
-	.open		= zoneinfo_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 #ifdef CONFIG_BLOCK
 static int diskstats_open(struct inode *inode, struct file *file)
 {
@@ -233,7 +221,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);
 #ifdef CONFIG_BLOCK
 	proc_create("diskstats", 0, NULL, &proc_diskstats_operations);
 #endif
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 26d36dc..eebd4ac 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -44,7 +44,6 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		NR_VM_EVENT_ITEMS
 };
 
-extern const struct seq_operations zoneinfo_op;
 extern int sysctl_stat_interval;
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
diff --git a/mm/vmstat.c b/mm/vmstat.c
index dc76249..68ab9b4 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -774,7 +774,7 @@ static int zoneinfo_show(struct seq_file *m, void *arg)
 	return 0;
 }
 
-const struct seq_operations zoneinfo_op = {
+static const struct seq_operations zoneinfo_op = {
 	.start	= frag_start, /* iterate over all zones. The same as in
 			       * fragmentation. */
 	.next	= frag_next,
@@ -782,6 +782,18 @@ const struct seq_operations zoneinfo_op = {
 	.show	= zoneinfo_show,
 };
 
+static int zoneinfo_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &zoneinfo_op);
+}
+
+static const struct file_operations proc_zoneinfo_file_operations = {
+	.open		= zoneinfo_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static void *vmstat_start(struct seq_file *m, loff_t *pos)
 {
 	unsigned long *v;
@@ -929,6 +941,7 @@ static int __init setup_vmstat(void)
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
 	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
 	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
+	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);
 #endif
 	return 0;
 }
-- 
1.5.6.5

