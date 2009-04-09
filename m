Return-Path: <linux-kernel-owner+w=401wt.eu-S1763227AbZDIIzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763227AbZDIIzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 04:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760729AbZDIIyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 04:54:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:34733 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbZDIIyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 04:54:22 -0400
Message-Id: <20090409085524.514046352@chello.nl>
References: <20090409085342.799915215@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 09 Apr 2009 10:53:45 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] perf_counter: sysctl for system wide perf counters
Content-Disposition: inline; filename=pref_counter-sysctl-global.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the use of system wide perf counters to everybody, but provide
a sysctl to disable it for the paranoid security minded.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |    4 +++-
 kernel/sysctl.c              |   11 +++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -568,6 +568,8 @@ struct perf_callchain_entry {
 
 extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 
+extern int sysctl_perf_counter_priv;
+
 #else
 static inline void
 perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -42,6 +42,8 @@ static atomic_t nr_mmap_tracking __read_
 static atomic_t nr_munmap_tracking __read_mostly;
 static atomic_t nr_comm_tracking __read_mostly;
 
+int sysctl_perf_counter_priv; /* do we need to be privileged */
+
 /*
  * Mutex for (sysadmin-configurable) counter reservations:
  */
@@ -1132,7 +1134,7 @@ static struct perf_counter_context *find
 	 */
 	if (cpu != -1) {
 		/* Must be root to operate on a CPU counter: */
-		if (!capable(CAP_SYS_ADMIN))
+		if (sysctl_perf_counter_priv && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
 
 		if (cpu < 0 || cpu > num_possible_cpus())
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -50,6 +50,7 @@
 #include <linux/reboot.h>
 #include <linux/ftrace.h>
 #include <linux/slow-work.h>
+#include <linux/perf_counter.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -931,6 +932,16 @@ static struct ctl_table kern_table[] = {
 		.child		= slow_work_sysctls,
 	},
 #endif
+#ifdef CONFIG_PERF_COUNTERS
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "perf_counter_privileged",
+		.data		= &sysctl_perf_counter_priv,
+		.maxlen		= sizeof(sysctl_perf_counter_priv),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt

-- 

