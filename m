Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbYAOKMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbYAOKMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbYAOKMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:12:47 -0500
Received: from phoenix.clifford.at ([88.198.7.52]:36325 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYAOKMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:12:46 -0500
Date: Tue, 15 Jan 2008 11:06:31 +0100
From: Clifford Wolf <clifford@clifford.at>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] rlim in proc/<pid>/status
Message-ID: <20080115100631.GA13394@clifford.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

because I needed it already twice in two different projects this week: the
following patch adds rlim (ulimits) output to /proc/<pid>/status.

Please let me know if there is another (already existing) way of accessing
this information easy (i.e. connecting with gdb to the process in question
and 'injecting' a getrlimit() call does not count.. ;-).

yours,
 - clifford

Signed-off-by: Clifford Wolf <clifford@clifford.at>

--- linux/fs/proc/array.c	(revision 757)
+++ linux/fs/proc/array.c	(working copy)
@@ -239,6 +239,55 @@
 	}
 }
 
+static char *rlim_names[RLIM_NLIMITS] = {
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
+	[RLIMIT_RTPRIO]     = "RTPrio"
+};
+
+static inline char *task_rlim(struct task_struct *p, char *buffer)
+{
+	unsigned long flags;
+	struct rlimit rlim[RLIM_NLIMITS];
+	int i;
+	
+	rcu_read_lock();
+	if (lock_task_sighand(p, &flags)) {
+		for (i=0; i<RLIM_NLIMITS; i++)
+			rlim[i] = p->signal->rlim[i];
+	}
+	rcu_read_unlock();
+
+	for (i=0; i<RLIM_NLIMITS; i++) {
+		if (rlim_names[i])
+			buffer += sprintf(buffer, "Rlim%s:\t", rlim_names[i]);
+		else
+			buffer += sprintf(buffer, "Rlim%d:\t", i);
+		if (rlim[i].rlim_cur != ~0)
+			buffer += sprintf(buffer, "%lu\t", rlim[i].rlim_cur);
+		else
+			buffer += sprintf(buffer, "-\t");
+		if (rlim[i].rlim_max != ~0)
+			buffer += sprintf(buffer, "%lu\n", rlim[i].rlim_max);
+		else
+			buffer += sprintf(buffer, "-\n");
+	}
+
+	return buffer;
+}
+
 static inline char *task_sig(struct task_struct *p, char *buffer)
 {
 	unsigned long flags;
@@ -310,6 +359,7 @@
 		buffer = task_mem(mm, buffer);
 		mmput(mm);
 	}
+	buffer = task_rlim(task, buffer);
 	buffer = task_sig(task, buffer);
 	buffer = task_cap(task, buffer);
 	buffer = cpuset_task_status_allowed(task, buffer);

-- 
[..] If it still doesn't work, re-write it in assembler. This won't fix the
bug, but it will make sure no one else finds it and makes you look bad.
