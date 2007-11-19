Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbXKSWMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbXKSWMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbXKSWLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:11:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55398 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033AbXKSWLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:11:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 3/4] proc: seqfile convert proc_pid_status to properly handle pid namespaces
References: <20071117183109.GA2605@tv-sign.ru>
	<m1abp9vqua.fsf@ebiederm.dsl.xmission.com>
	<m163zxvqm9.fsf_-_@ebiederm.dsl.xmission.com>
	<m11walvqji.fsf_-_@ebiederm.dsl.xmission.com>
Date: Mon, 19 Nov 2007 15:10:02 -0700
In-Reply-To: <m11walvqji.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Mon, 19 Nov 2007 15:06:25 -0700")
Message-ID: <m1ve7xubt1.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently we possibly lookup the pid in the wrong pid namespace.  So
seq_file convert proc_pid_status which ensures the proper pid
namespaces is passed in, and ensures that we don't overflow any
internal buffers when generating /proc/<pid>/status

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/s390/kernel/traps.c     |   23 ++++----
 fs/proc/array.c              |  122 ++++++++++++++++++++----------------------
 fs/proc/base.c               |    4 +-
 fs/proc/internal.h           |    2 +-
 fs/proc/task_mmu.c           |    6 +-
 fs/proc/task_nommu.c         |    2 +-
 include/asm-s390/processor.h |    2 +-
 include/linux/cpuset.h       |    8 ++--
 include/linux/proc_fs.h      |    2 +-
 kernel/cpuset.c              |   18 ++++---
 10 files changed, 93 insertions(+), 96 deletions(-)

diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 8ec9def..fd75106 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -210,41 +210,40 @@ void show_registers(struct pt_regs *regs)
 }	
 
 /* This is called from fs/proc/array.c */
-char *task_show_regs(struct task_struct *task, char *buffer)
+void task_show_regs(struct seq_file *m, struct task_struct *task)
 {
 	struct pt_regs *regs;
 
 	regs = task_pt_regs(task);
-	buffer += sprintf(buffer, "task: %p, ksp: %p\n",
+	seq_printf(m, "task: %p, ksp: %p\n",
 		       task, (void *)task->thread.ksp);
-	buffer += sprintf(buffer, "User PSW : %p %p\n",
+	seq_printf(m, "User PSW : %p %p\n",
 		       (void *) regs->psw.mask, (void *)regs->psw.addr);
 
-	buffer += sprintf(buffer, "User GPRS: " FOURLONG,
+	seq_printf(m, "User GPRS: " FOURLONG,
 			  regs->gprs[0], regs->gprs[1],
 			  regs->gprs[2], regs->gprs[3]);
-	buffer += sprintf(buffer, "           " FOURLONG,
+	seq_printf(m, "           " FOURLONG,
 			  regs->gprs[4], regs->gprs[5],
 			  regs->gprs[6], regs->gprs[7]);
-	buffer += sprintf(buffer, "           " FOURLONG,
+	seq_printf(m, "           " FOURLONG,
 			  regs->gprs[8], regs->gprs[9],
 			  regs->gprs[10], regs->gprs[11]);
-	buffer += sprintf(buffer, "           " FOURLONG,
+	seq_printf(m, "           " FOURLONG,
 			  regs->gprs[12], regs->gprs[13],
 			  regs->gprs[14], regs->gprs[15]);
-	buffer += sprintf(buffer, "User ACRS: %08x %08x %08x %08x\n",
+	seq_printf(m, "User ACRS: %08x %08x %08x %08x\n",
 			  task->thread.acrs[0], task->thread.acrs[1],
 			  task->thread.acrs[2], task->thread.acrs[3]);
-	buffer += sprintf(buffer, "           %08x %08x %08x %08x\n",
+	seq_printf(m, "           %08x %08x %08x %08x\n",
 			  task->thread.acrs[4], task->thread.acrs[5],
 			  task->thread.acrs[6], task->thread.acrs[7]);
-	buffer += sprintf(buffer, "           %08x %08x %08x %08x\n",
+	seq_printf(m, "           %08x %08x %08x %08x\n",
 			  task->thread.acrs[8], task->thread.acrs[9],
 			  task->thread.acrs[10], task->thread.acrs[11]);
-	buffer += sprintf(buffer, "           %08x %08x %08x %08x\n",
+	seq_printf(m, "           %08x %08x %08x %08x\n",
 			  task->thread.acrs[12], task->thread.acrs[13],
 			  task->thread.acrs[14], task->thread.acrs[15]);
-	return buffer;
 }
 
 static DEFINE_SPINLOCK(die_lock);
diff --git a/fs/proc/array.c b/fs/proc/array.c
index e7d290f..d23d91d 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -89,18 +89,21 @@
 do { memcpy(buffer, string, strlen(string)); \
      buffer += strlen(string); } while (0)
 
-static inline char *task_name(struct task_struct *p, char *buf)
+static inline void task_name(struct seq_file *m, struct task_struct *p)
 {
 	int i;
+	char *buf, *end;
 	char *name;
 	char tcomm[sizeof(p->comm)];
 
 	get_task_comm(tcomm, p);
 
-	ADDBUF(buf, "Name:\t");
+	end = m->buf + m->size;
+	buf = m->buf + m->count;
+	seq_printf(m, "Name:\n");
 	name = tcomm;
 	i = sizeof(tcomm);
-	do {
+	while (i && (buf < end)) {
 		unsigned char c = *name;
 		name++;
 		i--;
@@ -108,20 +111,21 @@ static inline char *task_name(struct task_struct *p, char *buf)
 		if (!c)
 			break;
 		if (c == '\\') {
-			buf[1] = c;
-			buf += 2;
+			buf++;
+			if (buf < end)
+				*buf++ = c;
 			continue;
 		}
 		if (c == '\n') {
-			buf[0] = '\\';
-			buf[1] = 'n';
-			buf += 2;
+			*buf++ = '\\';
+			if (buf < end)
+				*buf++ = 'n';
 			continue;
 		}
 		buf++;
-	} while (i);
-	*buf = '\n';
-	return buf+1;
+	}
+	m->count = buf - m->buf;
+	seq_printf(m, "\n");
 }
 
 /*
@@ -157,21 +161,20 @@ static inline const char *get_task_state(struct task_struct *tsk)
 	return *p;
 }
 
-static inline char *task_state(struct task_struct *p, char *buffer)
+static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *p)
 {
 	struct group_info *group_info;
 	int g;
 	struct fdtable *fdt = NULL;
-	struct pid_namespace *ns;
 	pid_t ppid, tpid;
 
-	ns = current->nsproxy->pid_ns;
 	rcu_read_lock();
 	ppid = pid_alive(p) ?
 		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
 	tpid = pid_alive(p) && p->ptrace ?
 		task_ppid_nr_ns(rcu_dereference(p->parent), ns) : 0;
-	buffer += sprintf(buffer,
+	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
 		"Pid:\t%d\n"
@@ -181,7 +184,7 @@ static inline char *task_state(struct task_struct *p, char *buffer)
 		"Gid:\t%d\t%d\t%d\t%d\n",
 		get_task_state(p),
 		task_tgid_nr_ns(p, ns),
-		task_pid_nr_ns(p, ns),
+		pid_nr_ns(pid, ns),
 		ppid, tpid,
 		p->uid, p->euid, p->suid, p->fsuid,
 		p->gid, p->egid, p->sgid, p->fsgid);
@@ -189,7 +192,7 @@ static inline char *task_state(struct task_struct *p, char *buffer)
 	task_lock(p);
 	if (p->files)
 		fdt = files_fdtable(p->files);
-	buffer += sprintf(buffer,
+	seq_printf(m,
 		"FDSize:\t%d\n"
 		"Groups:\t",
 		fdt ? fdt->max_fds : 0);
@@ -200,20 +203,17 @@ static inline char *task_state(struct task_struct *p, char *buffer)
 	task_unlock(p);
 
 	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
-		buffer += sprintf(buffer, "%d ", GROUP_AT(group_info, g));
+		seq_printf(m, "%d ", GROUP_AT(group_info, g));
 	put_group_info(group_info);
 
-	buffer += sprintf(buffer, "\n");
-	return buffer;
+	seq_printf(m, "\n");
 }
 
-static char *render_sigset_t(const char *header, sigset_t *set, char *buffer)
+static void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set)
 {
-	int i, len;
+	int i;
 
-	len = strlen(header);
-	memcpy(buffer, header, len);
-	buffer += len;
+	seq_printf(m, "%s", header);
 
 	i = _NSIG;
 	do {
@@ -224,12 +224,10 @@ static char *render_sigset_t(const char *header, sigset_t *set, char *buffer)
 		if (sigismember(set, i+2)) x |= 2;
 		if (sigismember(set, i+3)) x |= 4;
 		if (sigismember(set, i+4)) x |= 8;
-		*buffer++ = (x < 10 ? '0' : 'a' - 10) + x;
+		seq_printf(m, "%x", x);
 	} while (i >= 4);
 
-	*buffer++ = '\n';
-	*buffer = 0;
-	return buffer;
+	seq_printf(m, "\n");
 }
 
 static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
@@ -247,7 +245,7 @@ static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
 	}
 }
 
-static inline char *task_sig(struct task_struct *p, char *buffer)
+static inline void task_sig(struct seq_file *m, struct task_struct *p)
 {
 	unsigned long flags;
 	sigset_t pending, shpending, blocked, ignored, caught;
@@ -274,58 +272,56 @@ static inline char *task_sig(struct task_struct *p, char *buffer)
 	}
 	rcu_read_unlock();
 
-	buffer += sprintf(buffer, "Threads:\t%d\n", num_threads);
-	buffer += sprintf(buffer, "SigQ:\t%lu/%lu\n", qsize, qlim);
+	seq_printf(m, "Threads:\t%d\n", num_threads);
+	seq_printf(m, "SigQ:\t%lu/%lu\n", qsize, qlim);
 
 	/* render them all */
-	buffer = render_sigset_t("SigPnd:\t", &pending, buffer);
-	buffer = render_sigset_t("ShdPnd:\t", &shpending, buffer);
-	buffer = render_sigset_t("SigBlk:\t", &blocked, buffer);
-	buffer = render_sigset_t("SigIgn:\t", &ignored, buffer);
-	buffer = render_sigset_t("SigCgt:\t", &caught, buffer);
-
-	return buffer;
+	render_sigset_t(m, "SigPnd:\t", &pending);
+	render_sigset_t(m, "ShdPnd:\t", &shpending);
+	render_sigset_t(m, "SigBlk:\t", &blocked);
+	render_sigset_t(m, "SigIgn:\t", &ignored);
+	render_sigset_t(m, "SigCgt:\t", &caught);
 }
 
-static inline char *task_cap(struct task_struct *p, char *buffer)
+static inline void task_cap(struct seq_file *m, struct task_struct *p)
 {
-    return buffer + sprintf(buffer, "CapInh:\t%016x\n"
-			    "CapPrm:\t%016x\n"
-			    "CapEff:\t%016x\n",
-			    cap_t(p->cap_inheritable),
-			    cap_t(p->cap_permitted),
-			    cap_t(p->cap_effective));
+	seq_printf(m,	"CapInh:\t%016x\n"
+			"CapPrm:\t%016x\n"
+			"CapEff:\t%016x\n",
+			cap_t(p->cap_inheritable),
+			cap_t(p->cap_permitted),
+			cap_t(p->cap_effective));
 }
 
-static inline char *task_context_switch_counts(struct task_struct *p,
-						char *buffer)
+static inline void task_context_switch_counts(struct seq_file *m,
+						struct task_struct *p)
 {
-	return buffer + sprintf(buffer, "voluntary_ctxt_switches:\t%lu\n"
-			    "nonvoluntary_ctxt_switches:\t%lu\n",
-			    p->nvcsw,
-			    p->nivcsw);
+	seq_printf(m,	"voluntary_ctxt_switches:\t%lu\n"
+			"nonvoluntary_ctxt_switches:\t%lu\n",
+			p->nvcsw,
+			p->nivcsw);
 }
 
-int proc_pid_status(struct task_struct *task, char *buffer)
+int proc_pid_status(struct seq_file *m, struct pid_namespace *ns, struct pid *pid,
+			struct task_struct *task)
 {
-	char *orig = buffer;
 	struct mm_struct *mm = get_task_mm(task);
 
-	buffer = task_name(task, buffer);
-	buffer = task_state(task, buffer);
+	task_name(m, task);
+	task_state(m, ns, pid, task);
 
 	if (mm) {
-		buffer = task_mem(mm, buffer);
+		task_mem(m, mm);
 		mmput(mm);
 	}
-	buffer = task_sig(task, buffer);
-	buffer = task_cap(task, buffer);
-	buffer = cpuset_task_status_allowed(task, buffer);
+	task_sig(m, task);
+	task_cap(m, task);
+	cpuset_task_status_allowed(m, task);
 #if defined(CONFIG_S390)
-	buffer = task_show_regs(task, buffer);
+	task_show_regs(m, task);
 #endif
-	buffer = task_context_switch_counts(task, buffer);
-	return buffer - orig;
+	task_context_switch_counts(m, task);
+	return 0;
 }
 
 /*
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 51f0e7a..086a262 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2222,7 +2222,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	DIR("fdinfo",     S_IRUSR|S_IXUSR, fdinfo),
 	REG("environ",    S_IRUSR, environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
-	INF("status",     S_IRUGO, pid_status),
+	ONE("status",     S_IRUGO, pid_status),
 	INF("limits",	  S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
@@ -2543,7 +2543,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	DIR("fdinfo",    S_IRUSR|S_IXUSR, fdinfo),
 	REG("environ",   S_IRUSR, environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
-	INF("status",    S_IRUGO, pid_status),
+	ONE("status",    S_IRUGO, pid_status),
 	INF("limits",	 S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 74bc772..0033645 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -48,7 +48,7 @@ extern void create_seq_entry(char *name, mode_t mode, const struct file_operatio
 extern int proc_exe_link(struct inode *, struct dentry **, struct vfsmount **);
 extern int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns, struct pid *pid, struct task_struct *task);
 extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns, struct pid *pid, struct task_struct *task);
-extern int proc_pid_status(struct task_struct *, char *);
+extern int proc_pid_status(struct seq_file *m, struct pid_namespace *ns, struct pid *pid, struct task_struct *task);
 extern int proc_pid_statm(struct task_struct *, char *);
 
 extern const struct file_operations proc_maps_operations;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index c24d81a..d5cb8fb 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -6,13 +6,14 @@
 #include <linux/ptrace.h>
 #include <linux/pagemap.h>
 #include <linux/mempolicy.h>
+#include <linux/seq_file.h>
 
 #include <asm/elf.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
 
-char *task_mem(struct mm_struct *mm, char *buffer)
+void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
 	unsigned long data, text, lib;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
@@ -34,7 +35,7 @@ char *task_mem(struct mm_struct *mm, char *buffer)
 	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
 	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
 	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
-	buffer += sprintf(buffer,
+	seq_printf(m, 
 		"VmPeak:\t%8lu kB\n"
 		"VmSize:\t%8lu kB\n"
 		"VmLck:\t%8lu kB\n"
@@ -53,7 +54,6 @@ char *task_mem(struct mm_struct *mm, char *buffer)
 		data << (PAGE_SHIFT-10),
 		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
 		(PTRS_PER_PTE*sizeof(pte_t)*mm->nr_ptes) >> 10);
-	return buffer;
 }
 
 unsigned long task_vsize(struct mm_struct *mm)
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index d8b8c71..d4e9495 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -12,7 +12,7 @@
  * each process that owns it. Non-shared memory is counted
  * accurately.
  */
-char *task_mem(struct mm_struct *mm, char *buffer)
+void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
 	struct vm_list_struct *vml;
 	unsigned long bytes = 0, sbytes = 0, slack = 0;
diff --git a/include/asm-s390/processor.h b/include/asm-s390/processor.h
index 21d40a1..3d4ff06 100644
--- a/include/asm-s390/processor.h
+++ b/include/asm-s390/processor.h
@@ -180,7 +180,7 @@ extern unsigned long thread_saved_pc(struct task_struct *t);
 /*
  * Print register of task into buffer. Used in fs/proc/array.c.
  */
-extern char *task_show_regs(struct task_struct *task, char *buffer);
+extern void task_show_regs(struct seq_file *m, struct task_struct *task);
 
 extern void show_registers(struct pt_regs *regs);
 extern void show_code(struct pt_regs *regs);
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index ecae585..3eb2e81 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -57,7 +57,8 @@ extern int cpuset_memory_pressure_enabled;
 extern void __cpuset_memory_pressure_bump(void);
 
 extern const struct file_operations proc_cpuset_operations;
-extern char *cpuset_task_status_allowed(struct task_struct *task, char *buffer);
+struct seq_file;
+extern void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task);
 
 extern void cpuset_lock(void);
 extern void cpuset_unlock(void);
@@ -126,10 +127,9 @@ static inline int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
 
 static inline void cpuset_memory_pressure_bump(void) {}
 
-static inline char *cpuset_task_status_allowed(struct task_struct *task,
-							char *buffer)
+static inline void cpuset_task_status_allowed(struct seq_file *m, 
+						struct task_struct *task)
 {
-	return buffer;
 }
 
 static inline void cpuset_lock(void) {}
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 69307c9..b070b3b 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -114,7 +114,7 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
-char *task_mem(struct mm_struct *, char *);
+void task_mem(struct seq_file *, struct mm_struct *);
 void clear_refs_smap(struct mm_struct *mm);
 
 struct proc_dir_entry *de_get(struct proc_dir_entry *de);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 50f5dc4..9a0ebcf 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2219,13 +2219,15 @@ const struct file_operations proc_cpuset_operations = {
 #endif /* CONFIG_PROC_PID_CPUSET */
 
 /* Display task cpus_allowed, mems_allowed in /proc/<pid>/status file. */
-char *cpuset_task_status_allowed(struct task_struct *task, char *buffer)
+void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
-	buffer += sprintf(buffer, "Cpus_allowed:\t");
-	buffer += cpumask_scnprintf(buffer, PAGE_SIZE, task->cpus_allowed);
-	buffer += sprintf(buffer, "\n");
-	buffer += sprintf(buffer, "Mems_allowed:\t");
-	buffer += nodemask_scnprintf(buffer, PAGE_SIZE, task->mems_allowed);
-	buffer += sprintf(buffer, "\n");
-	return buffer;
+	int len;
+	seq_printf(m, "Cpus_allowed:\t");
+	m->count += cpumask_scnprintf(m->buf + m->count, m->size - m->count,
+					task->cpus_allowed);
+	seq_printf(m, "\n");
+	seq_printf(m, "Mems_allowed:\t");
+	m->count += nodemask_scnprintf(m->buf + m->count, m->size - m->count,
+					task->mems_allowed);
+	seq_printf(buffer, "\n");
 }
-- 
1.5.3.rc6.17.g1911

