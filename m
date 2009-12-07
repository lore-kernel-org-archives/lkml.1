Return-Path: <linux-kernel-owner+w=401wt.eu-S935030AbZLGK03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935030AbZLGK03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934864AbZLGK01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:26:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933573AbZLGK00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:26:26 -0500
Date: Mon, 7 Dec 2009 05:25:07 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>, Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, stable@kernel.org,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       Al Viro <viro@zeniv.linux.org.uk>
Message-Id: <20091207102808.4312.38760.sendpatchset@localhost.localdomain>
Subject: [Patch] proc: fill 'lib' field in /proc/<pid>/statm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the 'lib' field of /proc/<pid>/statm is
always 0, we should fill it with the right value,
the same with 'VmLib'.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: stable@kernel.org

---
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 4badde1..d710293 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -623,7 +623,7 @@ int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 	struct mm_struct *mm = get_task_mm(task);
 
 	if (mm) {
-		size = task_statm(mm, &shared, &text, &data, &resident);
+		size = task_statm(mm, &shared, &text, &data, &resident, &lib);
 		mmput(mm);
 	}
 	seq_printf(m, "%d %d %d %d %d %d %d\n",
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 753ca37..5b7ab52 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -98,7 +98,7 @@ extern spinlock_t proc_subdir_lock;
 struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *);
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
 unsigned long task_vsize(struct mm_struct *);
-int task_statm(struct mm_struct *, int *, int *, int *, int *);
+int task_statm(struct mm_struct *, int *, int *, int *, int *, int *);
 void task_mem(struct seq_file *, struct mm_struct *);
 
 struct proc_dir_entry *de_get(struct proc_dir_entry *de);
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2a1bef9..ea5bdd9 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -63,13 +63,14 @@ unsigned long task_vsize(struct mm_struct *mm)
 }
 
 int task_statm(struct mm_struct *mm, int *shared, int *text,
-	       int *data, int *resident)
+	       int *data, int *resident, int *lib)
 {
 	*shared = get_mm_counter(mm, file_rss);
 	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
 								>> PAGE_SHIFT;
 	*data = mm->total_vm - mm->shared_vm;
 	*resident = *shared + get_mm_counter(mm, anon_rss);
+	*lib = mm->exec_vm - *text;
 	return mm->total_vm;
 }
 
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 8f5c05d..d851ff7 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -92,7 +92,7 @@ unsigned long task_vsize(struct mm_struct *mm)
 }
 
 int task_statm(struct mm_struct *mm, int *shared, int *text,
-	       int *data, int *resident)
+	       int *data, int *resident, int *lib)
 {
 	struct vm_area_struct *vma;
 	struct vm_region *region;
