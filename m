Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbYGQHhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbYGQHhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYGQHcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:32:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171AbYGQHcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:32:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 23/23] /proc/PID/syscall
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Windows: let it get in *your* way.
Message-Id: <20080717073144.5A28715411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:31:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds /proc/PID/syscall and /proc/PID/task/TID/syscall magic files.
These use task_current_syscall() to show the task's current system call
number and argument registers, stack pointer and PC.  For a task blocked
but not in a syscall, the file shows "-1" in place of the syscall number,
followed by only the SP and PC.  For a task that's not blocked, it shows
"running".

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/proc/base.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6f21daa..6c950c7 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -509,6 +509,26 @@ static int proc_pid_limits(struct task_struct *task, char *buffer)
 	return count;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+static int proc_pid_syscall(struct task_struct *task, char *buffer)
+{
+	long nr;
+	unsigned long args[6], sp, pc;
+
+	if (task_current_syscall(task, &nr, args, 6, &sp, &pc))
+		return sprintf(buffer, "running\n");
+
+	if (nr < 0)
+		return sprintf(buffer, "%ld 0x%lx 0x%lx\n", nr, sp, pc);
+
+	return sprintf(buffer,
+		       "%ld 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
+		       nr,
+		       args[0], args[1], args[2], args[3], args[4], args[5],
+		       sp, pc);
+}
+#endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
+
 /************************************************************************/
 /*                       Here the fs part begins                        */
 /************************************************************************/
@@ -2425,6 +2445,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+	INF("syscall",    S_IRUSR, pid_syscall),
+#endif
 	INF("cmdline",    S_IRUGO, pid_cmdline),
 	ONE("stat",       S_IRUGO, tgid_stat),
 	ONE("statm",      S_IRUGO, pid_statm),
@@ -2757,6 +2780,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
 #endif
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+	INF("syscall",   S_IRUSR, pid_syscall),
+#endif
 	INF("cmdline",   S_IRUGO, pid_cmdline),
 	ONE("stat",      S_IRUGO, tid_stat),
 	ONE("statm",     S_IRUGO, pid_statm),
