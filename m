Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZFENWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZFENWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZFENWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:22:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:33801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbZFENWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:22:16 -0400
Date: Fri, 5 Jun 2009 13:21:43 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Generate mmap events for install_special_mapping()
Message-ID: <tip-089dd79db9264dc0da602bad45d42f1b3e7d1e07@git.kernel.org>
Git-Commit-ID: 089dd79db9264dc0da602bad45d42f1b3e7d1e07
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 13:21:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  089dd79db9264dc0da602bad45d42f1b3e7d1e07
Gitweb:     http://git.kernel.org/tip/089dd79db9264dc0da602bad45d42f1b3e7d1e07
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Jun 2009 14:04:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 14:46:41 +0200

perf_counter: Generate mmap events for install_special_mapping()

In order to track the vdso also generate mmap events for
install_special_mapping().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   14 ++++++++------
 kernel/perf_counter.c        |   34 ++++++++++++++++++++++------------
 mm/mmap.c                    |    5 +++--
 3 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 6ca403a..40dc0e2 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -617,8 +617,13 @@ static inline int is_software_counter(struct perf_counter *counter)
 
 extern void perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
 
-extern void perf_counter_mmap(unsigned long addr, unsigned long len,
-			      unsigned long pgoff, struct file *file);
+extern void __perf_counter_mmap(struct vm_area_struct *vma);
+
+static inline void perf_counter_mmap(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_EXEC)
+		__perf_counter_mmap(vma);
+}
 
 extern void perf_counter_comm(struct task_struct *tsk);
 extern void perf_counter_fork(struct task_struct *tsk);
@@ -668,10 +673,7 @@ static inline void
 perf_swcounter_event(u32 event, u64 nr, int nmi,
 		     struct pt_regs *regs, u64 addr)			{ }
 
-static inline void
-perf_counter_mmap(unsigned long addr, unsigned long len,
-		  unsigned long pgoff, struct file *file)		{ }
-
+static inline void perf_counter_mmap(struct vm_area_struct *vma)	{ }
 static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 static inline void perf_counter_fork(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index a5d3e2a..37a5a24 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2255,7 +2255,7 @@ out:
 }
 
 static void perf_output_copy(struct perf_output_handle *handle,
-			     void *buf, unsigned int len)
+			     const void *buf, unsigned int len)
 {
 	unsigned int pages_mask;
 	unsigned int offset;
@@ -2681,9 +2681,10 @@ void perf_counter_comm(struct task_struct *task)
  */
 
 struct perf_mmap_event {
-	struct file	*file;
-	char		*file_name;
-	int		file_size;
+	struct vm_area_struct	*vma;
+
+	const char		*file_name;
+	int			file_size;
 
 	struct {
 		struct perf_event_header	header;
@@ -2744,11 +2745,12 @@ static void perf_counter_mmap_event(struct perf_mmap_event *mmap_event)
 {
 	struct perf_cpu_context *cpuctx;
 	struct perf_counter_context *ctx;
-	struct file *file = mmap_event->file;
+	struct vm_area_struct *vma = mmap_event->vma;
+	struct file *file = vma->vm_file;
 	unsigned int size;
 	char tmp[16];
 	char *buf = NULL;
-	char *name;
+	const char *name;
 
 	if (file) {
 		buf = kzalloc(PATH_MAX, GFP_KERNEL);
@@ -2762,6 +2764,15 @@ static void perf_counter_mmap_event(struct perf_mmap_event *mmap_event)
 			goto got_name;
 		}
 	} else {
+		name = arch_vma_name(mmap_event->vma);
+		if (name)
+			goto got_name;
+
+		if (!vma->vm_mm) {
+			name = strncpy(tmp, "[vdso]", sizeof(tmp));
+			goto got_name;
+		}
+
 		name = strncpy(tmp, "//anon", sizeof(tmp));
 		goto got_name;
 	}
@@ -2791,8 +2802,7 @@ got_name:
 	kfree(buf);
 }
 
-void perf_counter_mmap(unsigned long addr, unsigned long len,
-		       unsigned long pgoff, struct file *file)
+void __perf_counter_mmap(struct vm_area_struct *vma)
 {
 	struct perf_mmap_event mmap_event;
 
@@ -2800,12 +2810,12 @@ void perf_counter_mmap(unsigned long addr, unsigned long len,
 		return;
 
 	mmap_event = (struct perf_mmap_event){
-		.file   = file,
+		.vma	= vma,
 		.event  = {
 			.header = { .type = PERF_EVENT_MMAP, },
-			.start  = addr,
-			.len    = len,
-			.pgoff  = pgoff,
+			.start  = vma->vm_start,
+			.len    = vma->vm_end - vma->vm_start,
+			.pgoff  = vma->vm_pgoff,
 		},
 	};
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 6451ce2..8101de4 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1220,8 +1220,7 @@ munmap_back:
 	if (correct_wcount)
 		atomic_inc(&inode->i_writecount);
 out:
-	if (vm_flags & VM_EXEC)
-		perf_counter_mmap(addr, len, pgoff, file);
+	perf_counter_mmap(vma);
 
 	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
@@ -2309,6 +2308,8 @@ int install_special_mapping(struct mm_struct *mm,
 
 	mm->total_vm += len >> PAGE_SHIFT;
 
+	perf_counter_mmap(vma);
+
 	return 0;
 }
 
