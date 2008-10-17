Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYJQMrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYJQMrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYJQMr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:47:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:5209 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbYJQMr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:47:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VU5A36QzNW7XSG1eGmdSOH8oe6/F9RqvhUx5nEoAM/IdjrngAqs+sa6BtfQXohbts5
         HRtnGXwW9cRwz9nn1IwnAH+NYDDtrc5pDkGQku8ZJ60wsV5F54+tp4fLb/95HQfKwBLo
         cUgOYKOWfAptl2lD6XeS2Ar7FMzj0tJWe2MzE=
Date: Fri, 17 Oct 2008 16:50:29 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 21/31] proc: move /proc/buddyinfo boilerplate to mm/vmstat.c
Message-ID: <20081017125029.GV22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 5ac8a804d748e9ed618f5c03f762d3a9dbcbca73 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 04:13:52 +0400
Subject: [PATCH 21/31] proc: move /proc/buddyinfo boilerplate to mm/vmstat.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/proc_misc.c    |   14 --------------
 include/linux/vmstat.h |    1 -
 mm/vmstat.c            |   25 +++++++++++++++++++++----
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 60b1c07..21a7c2a 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -56,19 +56,6 @@
 #include <asm/div64.h>
 #include "internal.h"
 
-static int fragmentation_open(struct inode *inode, struct file *file)
-{
-	(void)inode;
-	return seq_open(file, &fragmentation_op);
-}
-
-static const struct file_operations fragmentation_file_operations = {
-	.open		= fragmentation_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static int pagetypeinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &pagetypeinfo_op);
@@ -269,7 +256,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
 	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
 	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
 	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 58334d4..0940109 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -44,7 +44,6 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		NR_VM_EVENT_ITEMS
 };
 
-extern const struct seq_operations fragmentation_op;
 extern const struct seq_operations pagetypeinfo_op;
 extern const struct seq_operations zoneinfo_op;
 extern const struct seq_operations vmstat_op;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index d7826af..2fa5a4e 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -8,7 +8,7 @@
  *  Copyright (C) 2006 Silicon Graphics, Inc.,
  *		Christoph Lameter <christoph@lameter.com>
  */
-
+#include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/module.h>
@@ -384,7 +384,7 @@ void zone_statistics(struct zone *preferred_zone, struct zone *z)
 #endif
 
 #ifdef CONFIG_PROC_FS
-
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
 static char * const migratetype_names[MIGRATE_TYPES] = {
@@ -581,13 +581,25 @@ static int pagetypeinfo_show(struct seq_file *m, void *arg)
 	return 0;
 }
 
-const struct seq_operations fragmentation_op = {
+static const struct seq_operations fragmentation_op = {
 	.start	= frag_start,
 	.next	= frag_next,
 	.stop	= frag_stop,
 	.show	= frag_show,
 };
 
+static int fragmentation_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &fragmentation_op);
+}
+
+static const struct file_operations fragmentation_file_operations = {
+	.open		= fragmentation_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 const struct seq_operations pagetypeinfo_op = {
 	.start	= frag_start,
 	.next	= frag_next,
@@ -877,9 +889,11 @@ static int __cpuinit vmstat_cpuup_callback(struct notifier_block *nfb,
 
 static struct notifier_block __cpuinitdata vmstat_notifier =
 	{ &vmstat_cpuup_callback, NULL, 0 };
+#endif
 
 static int __init setup_vmstat(void)
 {
+#ifdef CONFIG_SMP
 	int cpu;
 
 	refresh_zone_stat_thresholds();
@@ -887,7 +901,10 @@ static int __init setup_vmstat(void)
 
 	for_each_online_cpu(cpu)
 		start_cpu_timer(cpu);
+#endif
+#ifdef CONFIG_PROC_FS
+	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
+#endif
 	return 0;
 }
 module_init(setup_vmstat)
-#endif
-- 
1.5.6.5

