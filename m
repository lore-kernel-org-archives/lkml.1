Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbYABThB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbYABThB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYABTgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:36:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55347 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbYABTgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:36:53 -0500
Date: Wed, 2 Jan 2008 11:35:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
In-Reply-To: <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jan 2008, Pekka Enberg wrote:
> 
> I already sent the remaining bits to Linus but this looks much
> cleaner. Thanks Hugh!
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Actually, I'd much rather just do this instead (on top of your patch)

It just creates a new CONFIG_SLABINFO that automatically has the right 
dependencies (ie depends on PROC being on, and either SLAB or SLUB), and 
then both SLAB and SLUB just have the exact same interfaces.

Which means that SLOB could also trivially implement the same thing, with 
no new #ifdef'fery or other crud.

It's totally untested, but looks fairly obvious.

		Linus

---
 fs/proc/proc_misc.c      |   21 ++-------------------
 include/linux/slab.h     |    5 +++++
 include/linux/slab_def.h |    3 ---
 include/linux/slub_def.h |    2 --
 init/Kconfig             |    6 ++++++
 mm/slab.c                |    2 +-
 mm/slub.c                |   11 +++++++++--
 7 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index a11968b..3462bfd 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -410,7 +410,7 @@ static const struct file_operations proc_modules_operations = {
 };
 #endif
 
-#ifdef CONFIG_SLAB
+#ifdef CONFIG_SLABINFO
 static int slabinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &slabinfo_op);
@@ -451,20 +451,6 @@ static const struct file_operations proc_slabstats_operations = {
 #endif
 #endif
 
-#ifdef CONFIG_SLUB
-static int slabinfo_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &slabinfo_op);
-}
-
-static const struct file_operations proc_slabinfo_operations = {
-	.open		= slabinfo_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-#endif
-
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i;
@@ -742,15 +728,12 @@ void __init proc_misc_init(void)
 #endif
 	create_seq_entry("stat", 0, &proc_stat_operations);
 	create_seq_entry("interrupts", 0, &proc_interrupts_operations);
-#ifdef CONFIG_SLAB
+#ifdef CONFIG_SLABINFO
 	create_seq_entry("slabinfo",S_IWUSR|S_IRUGO,&proc_slabinfo_operations);
 #ifdef CONFIG_DEBUG_SLAB_LEAK
 	create_seq_entry("slab_allocators", 0 ,&proc_slabstats_operations);
 #endif
 #endif
-#ifdef CONFIG_SLUB
-	create_seq_entry("slabinfo", S_IWUSR|S_IRUGO, &proc_slabinfo_operations);
-#endif
 	create_seq_entry("buddyinfo",S_IRUGO, &fragmentation_file_operations);
 	create_seq_entry("pagetypeinfo", S_IRUGO, &pagetypeinfo_file_ops);
 	create_seq_entry("vmstat",S_IRUGO, &proc_vmstat_file_operations);
diff --git a/include/linux/slab.h b/include/linux/slab.h
index f3a8eec..f62caaa 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -271,5 +271,10 @@ static inline void *kzalloc(size_t size, gfp_t flags)
 	return kmalloc(size, flags | __GFP_ZERO);
 }
 
+#ifdef CONFIG_SLABINFO
+extern const struct seq_operations slabinfo_op;
+ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
+#endif
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SLAB_H */
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 32bdc2f..fcc4809 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -95,7 +95,4 @@ found:
 
 #endif	/* CONFIG_NUMA */
 
-extern const struct seq_operations slabinfo_op;
-ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
-
 #endif	/* _LINUX_SLAB_DEF_H */
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index b7d9408..40801e7 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -200,6 +200,4 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 }
 #endif
 
-extern const struct seq_operations slabinfo_op;
-
 #endif /* _LINUX_SLUB_DEF_H */
diff --git a/init/Kconfig b/init/Kconfig
index 404bbf3..b9d11a8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -658,6 +658,12 @@ endchoice
 
 endmenu		# General setup
 
+config SLABINFO
+	bool
+	depends on PROC_FS
+	depends on SLAB || SLUB
+	default y
+
 config RT_MUTEXES
 	boolean
 	select PLIST
diff --git a/mm/slab.c b/mm/slab.c
index 2e338a5..aebb9f6 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4105,7 +4105,7 @@ out:
 	schedule_delayed_work(work, round_jiffies_relative(REAPTIMEOUT_CPUC));
 }
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_SLABINFO
 
 static void print_slabinfo_header(struct seq_file *m)
 {
diff --git a/mm/slub.c b/mm/slub.c
index 903dabd..474945e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4127,7 +4127,14 @@ __initcall(slab_sysfs_init);
 /*
  * The /proc/slabinfo ABI
  */
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_SLABINFO
+
+ssize_t slabinfo_write(struct file *file, const char __user * buffer,
+                       size_t count, loff_t *ppos)
+{
+	return -EINVAL;
+}
+
 
 static void print_slabinfo_header(struct seq_file *m)
 {
@@ -4201,4 +4208,4 @@ const struct seq_operations slabinfo_op = {
 	.show = s_show,
 };
 
-#endif /* CONFIG_PROC_FS */
+#endif /* CONFIG_SLABINFO */
