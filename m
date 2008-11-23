Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbYKWSz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbYKWSz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYKWSzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:55:36 -0500
Received: from smtp-out.google.com ([216.239.45.13]:10215 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYKWSze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:55:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=TezSn8wFqcq+DWtff55wgY2TGOSjQiHbe/QVSxMC8LB8CLoSab00G4YubQb32nvmK
	7TR83itp/r+p/JJzcO3OA==
Date: Sun, 23 Nov 2008 10:55:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch 2/2] mm: add dirty_background_bytes and dirty_bytes sysctls
In-Reply-To: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change introduces two new sysctls to /proc/sys/vm:
dirty_background_bytes and dirty_bytes.

dirty_background_bytes is the counterpart to dirty_background_ratio and
dirty_bytes is the counterpart to dirty_ratio.

With growing memory capacities of individual machines, it's no longer
sufficient to specify dirty thresholds as a percentage of the amount of
dirtyable memory over the entire system.

dirty_background_bytes and dirty_bytes specify quantities of memory, in
bytes, that represent the dirty limits for the entire system.  If either
of these values is set, its value represents the amount of dirty memory
that is needed to commence either background or direct writeback.

When a `bytes' or `ratio' file is written, its counterpart becomes a
function of the written value.  For example, if dirty_bytes is written to
be 8096, 8K of memory is required to commence direct writeback.
dirty_ratio is then functionally equivalent to 8K / the amount of
dirtyable memory:

	dirtyable_memory = free pages + mapped pages + file cache

	dirty_background_bytes = dirty_background_ratio * dirtyable_memory
		-or-
	dirty_background_ratio = dirty_background_bytes / dirtyable_memory

		AND

	dirty_bytes = dirty_ratio * dirtyable_memory
		-or-
	dirty_ratio = dirty_bytes / dirtyable_memory

Only one of dirty_background_bytes and dirty_background_ratio may be
specified at a time, and only one of dirty_bytes and dirty_ratio may be
specified.  When one sysctl is written, the other appears as 0 when read.

The `bytes' files operate on a page size granularity since dirty limits
are compared with ZVC values, which are in page units.

Prior to this change, the minimum dirty_ratio was 5 as implemented by
get_dirty_limits() although /proc/sys/vm/dirty_ratio would show any user
written value between 0 and 100.  This restriction is maintained, but
dirty_bytes has a lower limit of only one page.

Also prior to this change, the dirty_background_ratio could not equal or
exceed dirty_ratio.  This restriction is maintained in addition to
restricting dirty_background_bytes.  If either background threshold equals
or exceeds that of the dirty threshold, it is implicitly set to half the
dirty threshold.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/filesystems/proc.txt |   26 +++++++++-
 Documentation/sysctl/vm.txt        |    3 +-
 include/linux/writeback.h          |   11 ++++
 kernel/sysctl.c                    |   22 +++++++-
 mm/page-writeback.c                |  102 ++++++++++++++++++++++++++++++------
 5 files changed, 145 insertions(+), 19 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1381,6 +1381,15 @@ swapcache reclaim.  Decreasing vfs_cache_pressure causes the kernel to prefer
 to retain dentry and inode caches.  Increasing vfs_cache_pressure beyond 100
 causes the kernel to prefer to reclaim dentries and inodes.
 
+dirty_background_bytes
+----------------------
+
+Contains the amount of dirty memory at which the pdflush background writeback
+daemon will start writeback.
+
+If dirty_background_bytes is written, dirty_background_ratio becomes a function
+of its value (dirty_background_bytes / the amount of dirtyable system memory).
+
 dirty_background_ratio
 ----------------------
 
@@ -1389,14 +1398,29 @@ pages + file cache, not including locked pages and HugePages), the number of
 pages at which the pdflush background writeback daemon will start writing out
 dirty data.
 
+If dirty_background_ratio is written, dirty_background_bytes becomes a function
+of its value (dirty_background_ratio * the amount of dirtyable system memory).
+
+dirty_bytes
+-----------
+
+Contains the amount of dirty memory at which a process generating disk writes
+will itself start writeback.
+
+If dirty_bytes is written, dirty_ratio becomes a function of its value
+(dirty_bytes / the amount of dirtyable system memory).
+
 dirty_ratio
------------------
+-----------
 
 Contains, as a percentage of the dirtyable system memory (free pages + mapped
 pages + file cache, not including locked pages and HugePages), the number of
 pages at which a process which is generating disk writes will itself start
 writing out dirty data.
 
+If dirty_ratio is written, dirty_bytes becomes a function of its value
+(dirty_ratio * the amount of dirtyable system memory).
+
 dirty_writeback_centisecs
 -------------------------
 
diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -41,7 +41,8 @@ Currently, these files are in /proc/sys/vm:
 
 ==============================================================
 
-dirty_ratio, dirty_background_ratio, dirty_expire_centisecs,
+dirty_bytes, dirty_ratio, dirty_background_bytes,
+dirty_background_ratio, dirty_expire_centisecs,
 dirty_writeback_centisecs, highmem_is_dirtyable,
 vfs_cache_pressure, laptop_mode, block_dump, swap_token_timeout,
 drop-caches, hugepages_treat_as_movable:
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -107,7 +107,9 @@ void throttle_vm_writeout(gfp_t gfp_mask);
 
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
+extern unsigned long dirty_background_bytes;
 extern int vm_dirty_ratio;
+extern unsigned long vm_dirty_bytes;
 extern int dirty_writeback_interval;
 extern int dirty_expire_interval;
 extern int vm_highmem_is_dirtyable;
@@ -116,9 +118,18 @@ extern int laptop_mode;
 
 extern unsigned long determine_dirtyable_memory(void);
 
+extern int dirty_background_ratio_handler(struct ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+extern int dirty_background_bytes_handler(struct ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos);
 extern int dirty_ratio_handler(struct ctl_table *table, int write,
 		struct file *filp, void __user *buffer, size_t *lenp,
 		loff_t *ppos);
+extern int dirty_bytes_handler(struct ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos);
 
 struct ctl_table;
 struct file;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -915,12 +915,22 @@ static struct ctl_table vm_table[] = {
 		.data		= &dirty_background_ratio,
 		.maxlen		= sizeof(dirty_background_ratio),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= &dirty_background_ratio_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "dirty_background_bytes",
+		.data		= &dirty_background_bytes,
+		.maxlen		= sizeof(dirty_background_bytes),
+		.mode		= 0644,
+		.proc_handler	= &dirty_background_bytes_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+	{
 		.ctl_name	= VM_DIRTY_RATIO,
 		.procname	= "dirty_ratio",
 		.data		= &vm_dirty_ratio,
@@ -932,6 +942,16 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one_hundred,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "dirty_bytes",
+		.data		= &vm_dirty_bytes,
+		.maxlen		= sizeof(vm_dirty_bytes),
+		.mode		= 0644,
+		.proc_handler	= &dirty_bytes_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+	{
 		.procname	= "dirty_writeback_centisecs",
 		.data		= &dirty_writeback_interval,
 		.maxlen		= sizeof(dirty_writeback_interval),
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -69,6 +69,12 @@ static inline long sync_writeback_pages(void)
 int dirty_background_ratio = 5;
 
 /*
+ * dirty_background_bytes starts at 0 (disabled) so that it is a function of
+ * dirty_background_ratio * the amount of dirtyable memory
+ */
+unsigned long dirty_background_bytes;
+
+/*
  * free highmem will not be subtracted from the total free memory
  * for calculating free ratios if vm_highmem_is_dirtyable is true
  */
@@ -80,6 +86,12 @@ int vm_highmem_is_dirtyable;
 int vm_dirty_ratio = 10;
 
 /*
+ * vm_dirty_bytes starts at 0 (disabled) so that it is a function of
+ * vm_dirty_ratio * the amount of dirtyable memory
+ */
+unsigned long vm_dirty_bytes;
+
+/*
  * The interval between `kupdate'-style writebacks, in jiffies
  */
 int dirty_writeback_interval = 5 * HZ;
@@ -135,23 +147,75 @@ static int calc_period_shift(void)
 {
 	unsigned long dirty_total;
 
-	dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) / 100;
+	if (vm_dirty_bytes)
+		dirty_total = vm_dirty_bytes / PAGE_SIZE;
+	else
+		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
+				100;
 	return 2 + ilog2(dirty_total - 1);
 }
 
 /*
- * update the period when the dirty ratio changes.
+ * update the period when the dirty threshold changes.
  */
+static void update_completion_period(void)
+{
+	int shift = calc_period_shift();
+	prop_change_shift(&vm_completions, shift);
+	prop_change_shift(&vm_dirties, shift);
+}
+
+int dirty_background_ratio_handler(struct ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dointvec_minmax(table, write, filp, buffer, lenp, ppos);
+	if (ret == 0 && write)
+		dirty_background_bytes = 0;
+	return ret;
+}
+
+int dirty_background_bytes_handler(struct ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_doulongvec_minmax(table, write, filp, buffer, lenp, ppos);
+	if (ret == 0 && write)
+		dirty_background_ratio = 0;
+	return ret;
+}
+
 int dirty_ratio_handler(struct ctl_table *table, int write,
 		struct file *filp, void __user *buffer, size_t *lenp,
 		loff_t *ppos)
 {
 	int old_ratio = vm_dirty_ratio;
-	int ret = proc_dointvec_minmax(table, write, filp, buffer, lenp, ppos);
+	int ret;
+
+	ret = proc_dointvec_minmax(table, write, filp, buffer, lenp, ppos);
 	if (ret == 0 && write && vm_dirty_ratio != old_ratio) {
-		int shift = calc_period_shift();
-		prop_change_shift(&vm_completions, shift);
-		prop_change_shift(&vm_dirties, shift);
+		update_completion_period();
+		vm_dirty_bytes = 0;
+	}
+	return ret;
+}
+
+
+int dirty_bytes_handler(struct ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int old_bytes = vm_dirty_bytes;
+	int ret;
+
+	ret = proc_doulongvec_minmax(table, write, filp, buffer, lenp, ppos);
+	if (ret == 0 && write && vm_dirty_bytes != old_bytes) {
+		update_completion_period();
+		vm_dirty_ratio = 0;
 	}
 	return ret;
 }
@@ -365,23 +429,29 @@ void
 get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
 		 unsigned long *pbdi_dirty, struct backing_dev_info *bdi)
 {
-	int background_ratio;		/* Percentages */
-	int dirty_ratio;
 	unsigned long background;
 	unsigned long dirty;
 	unsigned long available_memory = determine_dirtyable_memory();
 	struct task_struct *tsk;
 
-	dirty_ratio = vm_dirty_ratio;
-	if (dirty_ratio < 5)
-		dirty_ratio = 5;
+	if (vm_dirty_bytes)
+		dirty = (vm_dirty_bytes + PAGE_SIZE) / PAGE_SIZE;
+	else {
+		int dirty_ratio;
 
-	background_ratio = dirty_background_ratio;
-	if (background_ratio >= dirty_ratio)
-		background_ratio = dirty_ratio / 2;
+		dirty_ratio = vm_dirty_ratio;
+		if (dirty_ratio < 5)
+			dirty_ratio = 5;
+		dirty = (dirty_ratio * available_memory) / 100;
+	}
+
+	if (dirty_background_bytes)
+		background = (dirty_background_bytes + PAGE_SIZE) / PAGE_SIZE;
+	else
+		background = (dirty_background_ratio * available_memory) / 100;
 
-	background = (background_ratio * available_memory) / 100;
-	dirty = (dirty_ratio * available_memory) / 100;
+	if (background >= dirty)
+		background = dirty / 2;
 	tsk = current;
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
 		background += background / 4;
