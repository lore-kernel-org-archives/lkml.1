Return-Path: <linux-kernel-owner+w=401wt.eu-S1764627AbZDIJHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764627AbZDIJHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764352AbZDIJHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:07:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:44566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760106AbZDIJHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:07:35 -0400
Date: Thu, 9 Apr 2009 09:06:50 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090409085524.514046352@chello.nl>
References: <20090409085524.514046352@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: sysctl for system wide perf counters
Message-ID: <tip-79bbb0bfff331422caf8a353be68c4764bc1e47f@git.kernel.org>
Git-Commit-ID: 79bbb0bfff331422caf8a353be68c4764bc1e47f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 09:06:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79bbb0bfff331422caf8a353be68c4764bc1e47f
Gitweb:     http://git.kernel.org/tip/79bbb0bfff331422caf8a353be68c4764bc1e47f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 9 Apr 2009 10:53:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 11:00:54 +0200

perf_counter: sysctl for system wide perf counters

Impact: add sysctl for paranoid/relaxed perfcounters policy

Allow the use of system wide perf counters to everybody, but provide
a sysctl to disable it for the paranoid security minded.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090409085524.514046352@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |    4 +++-
 kernel/sysctl.c              |   11 +++++++++++
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index c22363a..9814328 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -568,6 +568,8 @@ struct perf_callchain_entry {
 
 extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 
+extern int sysctl_perf_counter_priv;
+
 #else
 static inline void
 perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index af9fd89..a2fa5bc 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -42,6 +42,8 @@ static atomic_t nr_mmap_tracking __read_mostly;
 static atomic_t nr_munmap_tracking __read_mostly;
 static atomic_t nr_comm_tracking __read_mostly;
 
+int sysctl_perf_counter_priv __read_mostly; /* do we need to be privileged */
+
 /*
  * Mutex for (sysadmin-configurable) counter reservations:
  */
@@ -1132,7 +1134,7 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 	 */
 	if (cpu != -1) {
 		/* Must be root to operate on a CPU counter: */
-		if (!capable(CAP_SYS_ADMIN))
+		if (sysctl_perf_counter_priv && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
 
 		if (cpu < 0 || cpu > num_possible_cpus())
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4286b62..8ba4578 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -49,6 +49,7 @@
 #include <linux/reboot.h>
 #include <linux/ftrace.h>
 #include <linux/slow-work.h>
+#include <linux/perf_counter.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -920,6 +921,16 @@ static struct ctl_table kern_table[] = {
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
