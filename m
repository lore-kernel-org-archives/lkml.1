Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967261Ab0B0CCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 21:02:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:22584 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967127Ab0B0CCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 21:02:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=R8CBM+nB1oL7GabbsxxUNn6X5zu37cCVm0ETRJwjliKBi9xJrrXAtXI8++4jqwPLD
	YRX92MZwk1LfZKXBJobmw==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH] Export per-tid and per-tgid cputime in nanoseconds.
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl
Date: Fri, 26 Feb 2010 18:01:06 -0800
Message-ID: <20100227015506.32764.71812.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---

 fs/proc/array.c    |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/proc/base.c     |    2 ++
 fs/proc/internal.h |    2 ++
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 13b5d07..54604b8 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -547,3 +547,43 @@ int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 
 	return 0;
 }
+
+static int do_task_cputime(struct task_struct *task, char * buffer, int whole)
+{
+	int res;
+	unsigned long flags;
+	unsigned long long sum_exec_runtime = 0;
+	struct task_struct *t;
+
+	if (lock_task_sighand(task, &flags)) {
+		if (whole) {
+			t = task;
+			/* 
+			 * Add up live thread sum_exec_runtime at the group
+			 * level.
+			 */
+			do {
+				sum_exec_runtime += t->se.sum_exec_runtime;
+				t = next_thread(t);
+			} while (t != task);
+			sum_exec_runtime += task->signal->sum_sched_runtime;
+		}
+		unlock_task_sighand(task, &flags);
+	}
+
+	if (!whole)
+		sum_exec_runtime = task->se.sum_exec_runtime;
+
+	res = sprintf(buffer,"%llu\n", sum_exec_runtime);
+	return res;
+}
+
+int proc_tid_cputime(struct task_struct *task, char * buffer)
+{
+	return do_task_cputime(task, buffer, 0);
+}
+
+int proc_tgid_cputime(struct task_struct *task, char * buffer)
+{
+	return do_task_cputime(task, buffer, 1);
+}
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 58324c2..8fbc785 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2595,6 +2595,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("numa_maps",  S_IRUGO, proc_numa_maps_operations),
 #endif
 	REG("mem",        S_IRUSR|S_IWUSR, proc_mem_operations),
+	INF("cputime_ns", S_IRUGO, proc_tgid_cputime),
 	LNK("cwd",        proc_cwd_link),
 	LNK("root",       proc_root_link),
 	LNK("exe",        proc_exe_link),
@@ -2930,6 +2931,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("numa_maps", S_IRUGO, proc_numa_maps_operations),
 #endif
 	REG("mem",       S_IRUSR|S_IWUSR, proc_mem_operations),
+	INF("cputime_ns", S_IRUGO, proc_tid_cputime),
 	LNK("cwd",       proc_cwd_link),
 	LNK("root",      proc_root_link),
 	LNK("exe",       proc_exe_link),
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 1f24a3e..f9e9799 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -51,6 +51,8 @@ extern int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
 extern int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
+extern int proc_tid_cputime(struct task_struct *, char *);
+extern int proc_tgid_cputime(struct task_struct *, char *);
 extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
 
 extern const struct file_operations proc_maps_operations;

