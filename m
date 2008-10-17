Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYJQMuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYJQMuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756427AbYJQMuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:50:00 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:44043 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbYJQMt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:49:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=R1HBKpQvch9Jl7bJ6Lj4QqBKTieULwRI3ylDvQm8fP0rWX6TPiee1W+d/cDBfOmFJn
         Xy0dME3EpaA35/DSSGgDWfbsR0dFelUuheNpFnHJ4PdwCY7pFDgT0JDhn3bgqKgdKCy8
         yRW1LUMZ1NhCmHJc0ltQdi4A48+qGCrOz5llw=
Date: Fri, 17 Oct 2008 16:53:01 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 27/31] proc: move /proc/schedstat boilerplate to
	kernel/sched_stats.h
Message-ID: <20081017125301.GB22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From df061e2eb4f51b50946f057dad1e5e7ce967fd85 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 13:23:43 +0400
Subject: [PATCH 27/31] proc: move /proc/schedstat boilerplate to kernel/sched_stats.h

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/proc_misc.c   |    3 ---
 include/linux/sched.h |    4 ----
 kernel/sched.c        |    1 +
 kernel/sched_stats.h  |    9 ++++++++-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 429376e..981efbf 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -194,9 +194,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-#ifdef CONFIG_SCHEDSTATS
-	proc_create("schedstat", 0, NULL, &proc_schedstat_operations);
-#endif
 #ifdef CONFIG_PROC_KCORE
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
 	if (proc_root_kcore)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c226c7b..a6f584b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -638,10 +638,6 @@ struct sched_info {
 };
 #endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
 
-#ifdef CONFIG_SCHEDSTATS
-extern const struct file_operations proc_schedstat_operations;
-#endif /* CONFIG_SCHEDSTATS */
-
 #ifdef CONFIG_TASK_DELAY_ACCT
 struct task_delay_info {
 	spinlock_t	lock;
diff --git a/kernel/sched.c b/kernel/sched.c
index 6f23059..973cc94 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -55,6 +55,7 @@
 #include <linux/cpuset.h>
 #include <linux/percpu.h>
 #include <linux/kthread.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/sysctl.h>
 #include <linux/syscalls.h>
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 8385d43..6967055 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -90,13 +90,20 @@ static int schedstat_open(struct inode *inode, struct file *file)
 	return res;
 }
 
-const struct file_operations proc_schedstat_operations = {
+static const struct file_operations proc_schedstat_operations = {
 	.open    = schedstat_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
 	.release = single_release,
 };
 
+static int __init proc_schedstat_init(void)
+{
+	proc_create("schedstat", 0, NULL, &proc_schedstat_operations);
+	return 0;
+}
+module_init(proc_schedstat_init);
+
 /*
  * Expects runqueue lock to be held for atomicity of update
  */
-- 
1.5.6.5

