Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbZFCXMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbZFCXMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZFCXMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:12:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:15714 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbZFCXMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ATUH3RpDJ01sjRqezN9aUe1Hle0nR7G+TdTfyTYIlwBDlCQU5LEZSgh7zuRMTIN1A9
         lW7USM635d32cAaNHSdfDMDvqUTAYibKlvJzbcKYlAt0arbm240L9TzWq3gdqzzIN7M7
         vjYrRuQlnZ6mAeWoSt0p83c898ai/pcmER1UI=
Date: Thu, 4 Jun 2009 03:04:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
	/proc/*/exe
Message-ID: <20090603230422.GB853@x200.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090531151953.8f8b14b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 03:19:53PM -0700, Andrew Morton wrote:
> On Mon, 1 Jun 2009 01:54:27 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > And BTW, there is something unnatural when executable path is attached
> > to mm_struct(!) not task_struct,
> 
> mm_struct is the central object for a heavyweight process.  All threads
> within that process share the same executable path (don't they?) so
> attaching the executable path to the mm seems OK to me.

OK, let's try this:


[PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch /proc/*/exe

->exec_path marks executable which is associated with running task.
Binfmt loader decides which executable is such and can, in theory,
assign anything. Unlike current status quo when first VM_EXECUTABLE mapping is
sort of marks running executable.

If executable unmaps its all VM_EXECUTABLE mappings, /proc/*/exe ceases
to exists, ick! And userpsace can't even use MAP_EXECUTABLE.

Tasks which aren't created by running clone(2) and execve(2)
(read: kernel threads) get empty ->exec_path and

->exec_path is copied on clone(2) and put at do_exit() time.

->exec_path is going to replace struct mm_struct::exe_file et al
and allows to remove VM_EXECUTABLE flag while keeping readlink("/proc/*/exe")
without loop over all VMAs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/binfmt_aout.c      |    1 +
 fs/binfmt_elf.c       |    1 +
 fs/binfmt_elf_fdpic.c |    1 +
 fs/binfmt_flat.c      |    1 +
 fs/binfmt_som.c       |    1 +
 fs/proc/base.c        |   38 ++++++++++++++------------------------
 include/linux/sched.h |   25 +++++++++++++++++++++++++
 kernel/exit.c         |    1 +
 kernel/fork.c         |    2 ++
 9 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index b639dcf..a19b185 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -379,6 +379,7 @@ beyond_if:
 	regs->gp = ex.a_gpvalue;
 #endif
 	start_thread(regs, ex.a_entry, current->mm->start_stack);
+	set_task_exec_path(current, &bprm->file->f_path);
 	return 0;
 }
 
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 40381df..b815bfc 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -999,6 +999,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 #endif
 
 	start_thread(regs, elf_entry, bprm->p);
+	set_task_exec_path(current, &bprm->file->f_path);
 	retval = 0;
 out:
 	kfree(loc);
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index fdb66fa..f545504 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1185,6 +1185,7 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *params,
 		seg++;
 	}
 
+	set_task_exec_path(current, &file->f_path);
 	return 0;
 }
 
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 697f6b5..a16f977 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -798,6 +798,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 			libinfo->lib_list[id].start_brk) +	/* start brk */
 			stack_len);
 
+	set_task_exec_path(current, &bprm->file->f_path);
 	return 0;
 err:
 	return ret;
diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
index eff74b9..6c56262 100644
--- a/fs/binfmt_som.c
+++ b/fs/binfmt_som.c
@@ -174,6 +174,7 @@ static int map_som_binary(struct file *file,
 	up_write(&current->mm->mmap_sem);
 	if (retval > 0 || retval < -1024)
 		retval = 0;
+	set_task_exec_path(current, &bprm->file->f_path);
 out:
 	set_fs(old_fs);
 	return retval;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3326bbf..dc4ee6a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -201,6 +201,20 @@ static int proc_root_link(struct inode *inode, struct path *path)
 	return result;
 }
 
+static int proc_exe_link(struct inode *inode, struct path *path)
+{
+	struct task_struct *tsk;
+
+	tsk = get_proc_task(inode);
+	if (!tsk)
+		return -ENOENT;
+	get_task_exec_path(tsk, path);
+	put_task_struct(tsk);
+	if (!path->mnt || !path->dentry)
+		return -ENOENT;
+	return 0;
+}
+
 /*
  * Return zero if current may access user memory in @task, -error if not.
  */
@@ -1302,30 +1316,6 @@ void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm)
 	newmm->exe_file = get_mm_exe_file(oldmm);
 }
 
-static int proc_exe_link(struct inode *inode, struct path *exe_path)
-{
-	struct task_struct *task;
-	struct mm_struct *mm;
-	struct file *exe_file;
-
-	task = get_proc_task(inode);
-	if (!task)
-		return -ENOENT;
-	mm = get_task_mm(task);
-	put_task_struct(task);
-	if (!mm)
-		return -ENOENT;
-	exe_file = get_mm_exe_file(mm);
-	mmput(mm);
-	if (exe_file) {
-		*exe_path = exe_file->f_path;
-		path_get(&exe_file->f_path);
-		fput(exe_file);
-		return 0;
-	} else
-		return -ENOENT;
-}
-
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..6b2dd01 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1265,6 +1265,12 @@ struct task_struct {
 #endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
+	/*
+	 * Executable, binfmt loader wants to associate with task
+	 * (read: execve(2) argument).
+	 * Empty, if concept isn't applicable, e. g. kernel thread.
+	 */
+	struct path exec_path;
 /* filesystem information */
 	struct fs_struct *fs;
 /* open file information */
@@ -2403,6 +2409,25 @@ static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
 
+static inline void get_task_exec_path(struct task_struct *tsk, struct path *path)
+{
+	task_lock(tsk);
+	path_get(&tsk->exec_path);
+	*path = tsk->exec_path;
+	task_unlock(tsk);
+}
+
+static inline void set_task_exec_path(struct task_struct *tsk, struct path *path)
+{
+	struct path old_path;
+
+	path_get(path);
+	task_lock(tsk);
+	old_path = tsk->exec_path;
+	tsk->exec_path = *path;
+	task_unlock(tsk);
+	path_put(&old_path);
+}
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/kernel/exit.c b/kernel/exit.c
index abf9cf3..8e70b54 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -962,6 +962,7 @@ NORET_TYPE void do_exit(long code)
 
 	exit_sem(tsk);
 	exit_files(tsk);
+	set_task_exec_path(tsk, &(struct path){ .mnt = NULL, .dentry = NULL });
 	exit_fs(tsk);
 	check_stack_usage();
 	exit_thread();
diff --git a/kernel/fork.c b/kernel/fork.c
index b9e2edd..c0ee931 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1191,6 +1191,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	cgroup_fork_callbacks(p);
 	cgroup_callbacks_done = 1;
 
+	get_task_exec_path(current, &p->exec_path);
+
 	/* Need tasklist lock for parent etc handling! */
 	write_lock_irq(&tasklist_lock);
 
