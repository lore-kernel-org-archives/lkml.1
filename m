Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYE3VCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYE3VCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 17:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYE3VCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 17:02:46 -0400
Received: from phoenix.clifford.at ([88.198.7.52]:55654 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbYE3VCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 17:02:46 -0400
X-Greylist: delayed 1934 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2008 17:02:45 EDT
Date: Fri, 30 May 2008 22:11:04 +0200
From: Clifford Wolf <clifford@clifford.at>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add rlimits to /proc/<PID>/status
Message-ID: <20080530201104.GG1369@clifford.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Clifford Wolf <clifford@clifford.at>
---
 fs/proc/array.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 9e3b8c3..3cb2ad3 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -242,6 +242,62 @@ static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
 	}
 }
 
+static const char *rlim_names[RLIM_NLIMITS] = {
+	[RLIMIT_CPU]        = "CPU",
+	[RLIMIT_FSIZE]      = "FSize",
+	[RLIMIT_DATA]       = "Data",
+	[RLIMIT_STACK]      = "Stack",
+	[RLIMIT_CORE]       = "Core",
+	[RLIMIT_RSS]        = "RSS",
+	[RLIMIT_NPROC]      = "NProc",
+	[RLIMIT_NOFILE]     = "NoFile",
+	[RLIMIT_MEMLOCK]    = "MemLock",
+	[RLIMIT_AS]         = "AddrSpace",
+	[RLIMIT_LOCKS]      = "Locks",
+	[RLIMIT_SIGPENDING] = "SigPending",
+	[RLIMIT_MSGQUEUE]   = "MsgQueue",
+	[RLIMIT_NICE]       = "Nice",
+	[RLIMIT_RTPRIO]     = "RTPrio",
+	[RLIMIT_RTTIME]     = "RTTime"
+};
+
+#if RLIM_NLIMITS != 16
+#  error Value of RLIM_NLIMITS changed. \
+         Please update rlim_names in fs/proc/array.c
+#endif
+
+static inline void task_rlim(struct seq_file *m, struct task_struct *p)
+{
+	unsigned long flags;
+	struct rlimit rlim[RLIM_NLIMITS];
+	int i;
+
+	for (i=0; i<RLIM_NLIMITS; i++) {
+		rlim[i].rlim_cur = 0;
+		rlim[i].rlim_max = 0;
+	}
+
+	rcu_read_lock();
+	if (lock_task_sighand(p, &flags)) {
+		for (i=0; i<RLIM_NLIMITS; i++)
+			rlim[i] = p->signal->rlim[i];
+		unlock_task_sighand(p, &flags);
+	}
+	rcu_read_unlock();
+
+	for (i=0; i<RLIM_NLIMITS; i++) {
+		seq_printf(m, "Rlim%s:\t", rlim_names[i]);
+		if (rlim[i].rlim_cur != RLIM_INFINITY)
+			seq_printf(m, "%lu\t", rlim[i].rlim_cur);
+		else
+			seq_printf(m, "inf\t");
+		if (rlim[i].rlim_max != RLIM_INFINITY)
+			seq_printf(m, "%lu\n", rlim[i].rlim_max);
+		else
+			seq_printf(m, "inf\n");
+	}
+}
+
 static inline void task_sig(struct seq_file *m, struct task_struct *p)
 {
 	unsigned long flags;
@@ -322,6 +378,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 		task_mem(m, mm);
 		mmput(mm);
 	}
+	task_rlim(m, task);
 	task_sig(m, task);
 	task_cap(m, task);
 	cpuset_task_status_allowed(m, task);
-- 
1.5.5.3

