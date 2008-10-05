Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYJEKPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYJEKPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYJEKO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:14:59 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34449 "EHLO
	vinyl.outflux.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751756AbYJEKO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:14:58 -0400
Date: Sun, 5 Oct 2008 03:14:38 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] proc: show personality via /proc/pid/personality
Message-ID: <20081005101438.GR10632@outflux.net>
References: <20081002211424.GJ10632@outflux.net> <20081004145149.52c34ee7@infradead.org> <20081004220220.GK10632@outflux.net> <20081004164239.0c1483a4@infradead.org> <20081005004233.GL10632@outflux.net> <20081004174843.6fe48a8e@infradead.org> <20081005091120.GA21003@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005091120.GA21003@x200.localdomain>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make process personality flags visible in /proc.  Since a process's
personality is potentially sensitive (e.g. READ_IMPLIES_EXEC), make this
file only readable by the process owner.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
Please revert the prior patch against the "status" file -- this is the
alternative.
---
 fs/proc/array.c    |    8 ++++++++
 fs/proc/base.c     |    2 ++
 fs/proc/internal.h |    2 ++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 71c9be5..6b6b492 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -337,6 +337,14 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	return 0;
 }
 
+int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
+{
+	seq_printf(m, "%08x\n", task->personality);
+
+	return 0;
+}
+
 static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task, int whole)
 {
diff --git a/fs/proc/base.c b/fs/proc/base.c
index a28840b..c675c62 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2459,6 +2459,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("environ",    S_IRUSR, environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
 	ONE("status",     S_IRUGO, pid_status),
+	ONE("personality", S_IRUSR, pid_personality),
 	INF("limits",	  S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
@@ -2794,6 +2795,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("environ",   S_IRUSR, environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
 	ONE("status",    S_IRUGO, pid_status),
+	ONE("personality", S_IRUSR, pid_personality),
 	INF("limits",	 S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 4422023..747e3de 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -53,6 +53,8 @@ extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
 extern int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
+extern int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task);
 extern int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
 extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
-- 
1.5.6.3


-- 
Kees Cook
Ubuntu Security Team
