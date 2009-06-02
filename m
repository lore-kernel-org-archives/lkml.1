Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbZFBOUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbZFBOUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbZFBOT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:19:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:44592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455AbZFBOT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:19:56 -0400
Date: Tue, 2 Jun 2009 14:19:07 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, ebiederm@xmission.com,
       oleg@tv-sign.ru, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, ebiederm@xmission.com, oleg@tv-sign.ru,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Use PID namespaces properly
Message-ID: <tip-709e50cf870e61745b39552044aa6c7c38e4f9e0@git.kernel.org>
Git-Commit-ID: 709e50cf870e61745b39552044aa6c7c38e4f9e0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 14:19:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  709e50cf870e61745b39552044aa6c7c38e4f9e0
Gitweb:     http://git.kernel.org/tip/709e50cf870e61745b39552044aa6c7c38e4f9e0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 14:13:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 16:16:25 +0200

perf_counter: Use PID namespaces properly

Stop using task_struct::pid and start using PID namespaces.

PIDs will be reported in the PID namespace of the monitoring
task at the moment of counter creation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    3 +++
 kernel/perf_counter.c        |   42 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index d970fbc..9ec20fc 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -317,6 +317,7 @@ enum perf_event_type {
 #include <linux/spinlock.h>
 #include <linux/hrtimer.h>
 #include <linux/fs.h>
+#include <linux/pid_namespace.h>
 #include <asm/atomic.h>
 
 struct task_struct;
@@ -500,6 +501,8 @@ struct perf_counter {
 
 	void (*destroy)(struct perf_counter *);
 	struct rcu_head			rcu_head;
+
+	struct pid_namespace		*ns;
 #endif
 };
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index fbed4d2..caa012c 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1432,6 +1432,8 @@ static void free_counter_rcu(struct rcu_head *head)
 	struct perf_counter *counter;
 
 	counter = container_of(head, struct perf_counter, rcu_head);
+	if (counter->ns)
+		put_pid_ns(counter->ns);
 	kfree(counter);
 }
 
@@ -2267,6 +2269,28 @@ static void perf_output_end(struct perf_output_handle *handle)
 	rcu_read_unlock();
 }
 
+static u32 perf_counter_pid(struct perf_counter *counter, struct task_struct *p)
+{
+	/*
+	 * only top level counters have the pid namespace they were created in
+	 */
+	if (counter->parent)
+		counter = counter->parent;
+
+	return task_tgid_nr_ns(p, counter->ns);
+}
+
+static u32 perf_counter_tid(struct perf_counter *counter, struct task_struct *p)
+{
+	/*
+	 * only top level counters have the pid namespace they were created in
+	 */
+	if (counter->parent)
+		counter = counter->parent;
+
+	return task_pid_nr_ns(p, counter->ns);
+}
+
 static void perf_counter_output(struct perf_counter *counter,
 				int nmi, struct pt_regs *regs, u64 addr)
 {
@@ -2303,8 +2327,8 @@ static void perf_counter_output(struct perf_counter *counter,
 
 	if (record_type & PERF_RECORD_TID) {
 		/* namespace issues */
-		tid_entry.pid = current->group_leader->pid;
-		tid_entry.tid = current->pid;
+		tid_entry.pid = perf_counter_pid(counter, current);
+		tid_entry.tid = perf_counter_tid(counter, current);
 
 		header.type |= PERF_RECORD_TID;
 		header.size += sizeof(tid_entry);
@@ -2432,6 +2456,9 @@ static void perf_counter_comm_output(struct perf_counter *counter,
 	if (ret)
 		return;
 
+	comm_event->event.pid = perf_counter_pid(counter, comm_event->task);
+	comm_event->event.tid = perf_counter_tid(counter, comm_event->task);
+
 	perf_output_put(&handle, comm_event->event);
 	perf_output_copy(&handle, comm_event->comm,
 				   comm_event->comm_size);
@@ -2504,8 +2531,6 @@ void perf_counter_comm(struct task_struct *task)
 		.task	= task,
 		.event  = {
 			.header = { .type = PERF_EVENT_COMM, },
-			.pid	= task->group_leader->pid,
-			.tid	= task->pid,
 		},
 	};
 
@@ -2542,6 +2567,9 @@ static void perf_counter_mmap_output(struct perf_counter *counter,
 	if (ret)
 		return;
 
+	mmap_event->event.pid = perf_counter_pid(counter, current);
+	mmap_event->event.tid = perf_counter_tid(counter, current);
+
 	perf_output_put(&handle, mmap_event->event);
 	perf_output_copy(&handle, mmap_event->file_name,
 				   mmap_event->file_size);
@@ -2641,8 +2669,6 @@ void perf_counter_mmap(unsigned long addr, unsigned long len,
 		.file   = file,
 		.event  = {
 			.header = { .type = PERF_EVENT_MMAP, },
-			.pid	= current->group_leader->pid,
-			.tid	= current->pid,
 			.start  = addr,
 			.len    = len,
 			.pgoff  = pgoff,
@@ -2664,8 +2690,6 @@ void perf_counter_munmap(unsigned long addr, unsigned long len,
 		.file   = file,
 		.event  = {
 			.header = { .type = PERF_EVENT_MUNMAP, },
-			.pid	= current->group_leader->pid,
-			.tid	= current->pid,
 			.start  = addr,
 			.len    = len,
 			.pgoff  = pgoff,
@@ -3445,6 +3469,8 @@ SYSCALL_DEFINE5(perf_counter_open,
 	list_add_tail(&counter->owner_entry, &current->perf_counter_list);
 	mutex_unlock(&current->perf_counter_mutex);
 
+	counter->ns = get_pid_ns(current->nsproxy->pid_ns);
+
 	fput_light(counter_file, fput_needed2);
 
 out_fput:
