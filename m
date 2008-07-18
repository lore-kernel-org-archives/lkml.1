Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbYGRQSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbYGRQSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYGRQSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:18:47 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42165 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448AbYGRQSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:18:46 -0400
Date: Fri, 18 Jul 2008 11:18:33 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Kirill Korotaev <dev@parallels.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       nick@nick-andrew.net, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 - Object creation
	with a specified id)
Message-ID: <20080718161833.GA23381@us.ibm.com>
References: <20080422193612.GA15835@martell.zuzino.mipt.ru> <1208890580.17117.14.camel@nimitz.home.sr71.net> <20080422210130.GA15937@martell.zuzino.mipt.ru> <1208904967.17117.51.camel@nimitz.home.sr71.net> <480ED9D5.1010906@parallels.com> <480FE037.2010302@cs.columbia.edu> <m1y74a7b4w.fsf@frodo.ebiederm.org> <1215709949.9398.15.camel@nimitz> <20080710173246.GA1857@us.ibm.com> <487FD2BA.4040607@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <487FD2BA.4040607@cs.columbia.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Quoting Oren Laadan (orenl@cs.columbia.edu):
>
>
> Serge E. Hallyn wrote:
>> Quoting Dave Hansen (dave@linux.vnet.ibm.com):
>>> On Wed, 2008-07-09 at 18:58 -0700, Eric W. Biederman wrote:
>>>> In the worst case today we can restore a checkpoint by replaying all of
>>>> the user space actions that took us to get there.  That is a tedious
>>>> and slow approach.
>>> Yes, tedious and slow, *and* minimally invasive in the kernel.  Once we
>>> have a tedious and slow process, we'll have some really good points when
>>> we try to push the next set of patches to make it less slow and tedious.
>>> We'll be able to describe an _actual_ set of problems to our fellow
>>> kernel hackers.
>>>
>>> So, the checkpoint-as-a-corefile idea sounds good to me, but it
>>> definitely leaves a lot of questions about exactly how we'll need to do
>>> the restore.
>>
>> Talking with Dave over irc, I kind of liked the idea of creating a new
>> fs/binfmt_cr.c that executes a checkpoint-as-a-coredump file.
>>
>> One thing I do not like about the checkpoint-as-coredump is that it begs
>> us to dump all memory out into the file.  Our plan/hope was to save
>> ourselves from writing out most memory by:
>>
>> 	1. associating a separate swapfile with each container
>> 	2. doing a swapfile snapshot at each checkpoint
>> 	3. dumping the pte entries (/proc/self/)
>>
>> If we do checkpoint-as-a-coredump, then we need userspace to coordinate
>> a kernel-generated coredump with a user-generated (?) swapfile snapshot.
>> But I guess we figure that out later.
>
> I'm not sure how this approach integrates with (a) live migration (and
> the iterative process of sending over memory modified since previous
> iteration), and (b) incremental checkpoint (where except for the first
> snapshot, additional snapshots only save what changed since the previous
> one).

Oh, well I was seeing them as pretty orthogonal actually.  The reason is
that my checkpoint-as-a-coredump file would NOT include memory contents.
I'm still hoping that we can lock a container into its own nfs-mounted
swapfile, and take a snapshot of that at checkpoint.  Let the snapshot
solution take care of the incremental snapshot.

Attached are one kernel and one cryo patch, purely for a toy
implementation.  It doesn't even *quite* work yet.  Here are the notes
I wrote when I put it down wednesday afternoon:

===============================================================

The kernel patch impelments (only for x86_32) sys_checkpoint.  You
can create a checkpoint with the following test program:

#include <unistd.h>
#include <stdio.h>
#include <sys/syscall.h>
#include <errno.h>

int main()
{
        int ret;

        ret = syscall(327, "output.kckpt");
        printf("ret was %d\n", ret);
        if (ret == -1)
                perror("checkpoint");
        return 0;
}

Make output.kckpt executable and run it.  Works fine.

With the cryo patch, you can do:

SHELL 1:
./tests/sleep
SHELL 2:
./cr -p <sleeppid> -f o1.bin

and you'll see <sleeppid.kckpt> created.  Make that
executable and run it, and you'll see it runs as though
it were the original sleep program.

On the other hand, two problems with using cryo:

        1. the checkpointed app segfaults

        2. if you restart with "cr -r -f o1.bin" it
           fails somewhere.

===============================================================

Matt has already pointed out some coding errors so *really* it's
just to show one way we could integrate a binary format handler
for partial restart with more userspace control.  I'd be too
embarassed to send it out, but figure I should send it out before
the mini-summit.

-serge

--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-checkpoint-add-sys_checkpoint-and-binfmt_cr.c.patch"

>From 04800bea92f56c15eb1a1de35de9a54613b5eb9c Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serge@us.ibm.com>
Date: Wed, 16 Jul 2008 13:38:44 -0500
Subject: [PATCH 1/1] checkpoint: add sys_checkpoint() and binfmt_cr.c

Add a do_checkpoint syscall (only for x86_32 right now).  The intent is to
dump process data which isn't userspace-accessible yet.

Introduce fs/binfmt_cr, which executes checkpoint files.  At the moment
all it does is execute the original file using its default binary
handler, and resets tsk->mm->arg_start and tsk->did_exec.

Since binfmt_cr only does part of the necessary restart operations, userspace
will need to do the rest.

Cryo, for instance, will cause the new process to execute this task, then be
ptraced to allow the rest of the restore to take place.

Signed-off-by: Serge Hallyn <serge@us.ibm.com>
---
 arch/x86/kernel/process_32.c       |   15 +++++
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/Kconfig.binfmt                  |    7 +++
 fs/Makefile                        |    3 +-
 fs/binfmt_cr.c                     |  100 ++++++++++++++++++++++++++++++++++++
 fs/checkpoint.c                    |   79 ++++++++++++++++++++++++++++
 fs/exec.c                          |   21 ++++++++
 include/asm-x86/unistd_32.h        |    1 +
 include/linux/binfmts.h            |    1 +
 include/linux/checkpoint.h         |    5 ++
 include/linux/sched.h              |    2 +
 include/linux/syscalls.h           |    1 +
 kernel/sys_ni.c                    |    2 +
 13 files changed, 237 insertions(+), 1 deletions(-)
 create mode 100644 fs/binfmt_cr.c
 create mode 100644 fs/checkpoint.c
 create mode 100644 include/linux/checkpoint.h

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index e2db9ac..fd55fec 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -767,3 +767,18 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
 	unsigned long range_end = mm->brk + 0x02000000;
 	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
 }
+
+asmlinkage int sys_checkpoint(struct pt_regs regs)
+{
+	int error;
+	char *filename;
+
+	filename = getname((char __user *) regs.bx);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		goto out;
+	error = do_checkpoint(filename, &regs);
+	putname(filename);
+out:
+	return error;
+}
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index adff556..8195a31 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -326,3 +326,4 @@ ENTRY(sys_call_table)
 	.long sys_fallocate
 	.long sys_timerfd_settime	/* 325 */
 	.long sys_timerfd_gettime
+	.long sys_checkpoint
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 3263084..cb0d19b 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -137,3 +137,10 @@ config BINFMT_MISC
 	  You may say M here for module support and later load the module when
 	  you have use for it; the module is called binfmt_misc. If you
 	  don't know what to answer at this point, say Y.
+
+config BINFMT_CR
+	tristate "Kernel support for executing checkpoint files"
+	default n
+	---help---
+	  Checkpoint files (created using sys_checkpoint) can be executed
+	  as though they were binaries using this binary format handler.
diff --git a/fs/Makefile b/fs/Makefile
index 1e7a11b..9230fac 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o
+		stack.o checkpoint.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
@@ -34,6 +34,7 @@ obj-y				+= $(nfsd-y) $(nfsd-m)
 obj-$(CONFIG_BINFMT_AOUT)	+= binfmt_aout.o
 obj-$(CONFIG_BINFMT_EM86)	+= binfmt_em86.o
 obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc.o
+obj-$(CONFIG_BINFMT_CR)		+= binfmt_cr.o
 
 # binfmt_script is always there
 obj-y				+= binfmt_script.o
diff --git a/fs/binfmt_cr.c b/fs/binfmt_cr.c
new file mode 100644
index 0000000..8a0e173
--- /dev/null
+++ b/fs/binfmt_cr.c
@@ -0,0 +1,100 @@
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/binfmts.h>
+#include <linux/init.h>
+#include <linux/file.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/mm_types.h>
+#include <linux/sched.h>
+#include <linux/checkpoint.h>
+
+/*
+ * The pathname is likely to quickly overrun bprm->buf.
+ * I'll need to read the first page of the file.
+ */
+static int load_checkpoint(struct linux_binprm *bprm,struct pt_regs *regs)
+{
+	unsigned long arg_start;
+	short did_exec;
+	char *cp;
+	struct file *file;
+	int retval;
+
+	cp = bprm->buf;
+	if (memcmp(cp, CKPT_ID, strlen(CKPT_ID)))
+		return -ENOEXEC;
+	cp += strlen(CKPT_ID) + 1;
+	printk(KERN_NOTICE "%s: checking version\n", __func__);
+	if (memcmp(cp, CKPT_VERSION, strlen(CKPT_VERSION)))
+		return -EINVAL;
+	/* Grab the pathname of the original, checkpointed executable */
+	cp += strlen(CKPT_VERSION) + 1;
+	if (*cp == ' ') {
+		printk(KERN_NOTICE "Serge: bump by 1\n");
+		cp++;
+	}
+	printk(KERN_NOTICE "%s: reading arg_start\n", __func__);
+	retval = sscanf(cp, "%lu", &arg_start);
+	if (retval != 1)
+		return -EINVAL;
+	printk(KERN_NOTICE "%s: arg_start was %lu\n", __func__, arg_start);
+	printk(KERN_NOTICE "%s: moving cp to did_exec\n", __func__);
+	while (*(++cp) != ' ' && (cp-bprm->buf < BINPRM_BUF_SIZE));
+	cp++;
+	if (cp-bprm->buf >= BINPRM_BUF_SIZE)
+		return -EINVAL;
+	printk(KERN_NOTICE "%s: reading did_exec (cp is %s)\n", __func__, cp);
+	retval = sscanf(cp, "%hu", &did_exec);
+	if (retval != 1)
+		return -EINVAL;
+	printk(KERN_NOTICE "%s: did_exec was %hu\n", __func__, did_exec);
+	printk(KERN_NOTICE "%s: moving cp to fname\n", __func__);
+	while (*(++cp) != ' ' && (cp-bprm->buf < BINPRM_BUF_SIZE));
+	cp++;
+	if (cp-bprm->buf >= BINPRM_BUF_SIZE)
+		return -EINVAL;
+	/*
+	 * OK, now restart the process with the original executable's dentry.
+	 */
+	printk(KERN_NOTICE "%s: opening fname: %s\n", __func__, cp);
+	file = open_exec(cp);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	printk(KERN_NOTICE "%s: calling prepare_binprm %s\n", __func__, cp);
+	bprm->file = file;
+	retval = prepare_binprm(bprm);
+	if (retval < 0)
+		return retval;
+	retval = search_binary_handler(bprm,regs);
+	if (retval >= 0) {
+		/* execve success */
+		printk(KERN_NOTICE "%s: execve succeeded!\n", __func__);
+		current->mm->arg_start = arg_start;
+		current->did_exec = did_exec;
+	} else
+		printk(KERN_NOTICE "%s: execve failed with %d.\n", __func__, retval);
+	return retval;
+}
+
+static struct linux_binfmt cr_format = {
+	.module		= THIS_MODULE,
+	.load_binary	= load_checkpoint,
+};
+
+static int __init init_cr_binfmt(void)
+{
+	return register_binfmt(&cr_format);
+}
+
+static void __exit exit_cr_binfmt(void)
+{
+	unregister_binfmt(&cr_format);
+}
+
+core_initcall(init_cr_binfmt);
+module_exit(exit_cr_binfmt);
+MODULE_LICENSE("GPL");
diff --git a/fs/checkpoint.c b/fs/checkpoint.c
new file mode 100644
index 0000000..784f79a
--- /dev/null
+++ b/fs/checkpoint.c
@@ -0,0 +1,79 @@
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/mm_types.h>
+#include <linux/uaccess.h>
+#include <linux/sched.h>
+#include <linux/checkpoint.h>
+
+int checkpoint_write(struct file *file, const void *addr, int nr)
+{
+	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
+}
+
+#ifdef CONFIG_PROC_FS
+char *get_exe_name(char *buf, int buflen)
+{
+	struct file *f = current->mm->exe_file;
+	return dentry_path(f->f_dentry, buf, buflen);
+}
+#else
+char *get_exe_name(char *buf, int buflen)
+{
+	if (buflen < sizeof(current->comm))
+		return -ENAMETOOLONG;
+	return get_task_comm(buf, current);
+#endif
+
+/*
+ * Format of a checkpoint file.
+ *  Version 2008-07-14:
+ *   LX_CKPT2008-07-14
+ *   mm->arg_start (lu)
+ *   current->did_exec (hu)
+ *   filename
+ */
+int dump_checkpoint(struct file *file, struct pt_regs * regs)
+{
+	char buf[MMARGSTR];
+	char *exename, *sret;
+	size_t len;
+	mm_segment_t fs;
+	int retval = 0;
+
+	exename = kmalloc(4096, GFP_KERNEL);
+	if (IS_ERR(exename))
+		return -ENOMEM;
+
+	fs = get_fs();
+	set_fs(KERNEL_DS);
+
+	retval = -EINVAL;
+	printk(KERN_NOTICE "%s: writing a dump file\n", __func__);
+	if (!checkpoint_write(file, CKPT_ID, sizeof(CKPT_ID)))
+		goto out_setfs;
+	printk(KERN_NOTICE "%s: wrote ckpt id\n", __func__);
+	if (!checkpoint_write(file, CKPT_VERSION, sizeof(CKPT_VERSION)))
+		goto out_setfs;
+	len = snprintf(buf, MMARGSTR, " %lu ", current->mm->arg_start);
+	if (!checkpoint_write(file, buf, len))
+		goto out_setfs;
+	len = snprintf(buf, MMARGSTR, "%hu ", current->did_exec);
+	if (!checkpoint_write(file, buf, len))
+		goto out_setfs;
+
+	sret = get_exe_name(exename, 4096);
+	if (IS_ERR(sret)) {
+		retval = PTR_ERR(sret);
+		goto out_setfs;
+	}
+	retval = 0;
+	if (!checkpoint_write(file, sret, strlen(sret)+1))
+		retval = -EINVAL;
+	printk(KERN_NOTICE "%s: returning %d\n", __func__, retval);
+out_setfs:
+	set_fs(fs);
+	kfree(exename);
+	return retval;
+}
diff --git a/fs/exec.c b/fs/exec.c
index fd92343..68ad85c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -51,6 +51,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
+#include <linux/checkpoint.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1790,3 +1791,23 @@ fail_unlock:
 fail:
 	return retval;
 }
+
+int do_checkpoint(char *filename, struct pt_regs * regs)
+{
+	int retval = -EINVAL;
+	struct file * file;
+
+	printk(KERN_NOTICE "%s: called (filename %s)\n", __func__, filename);
+	file = filp_open(filename, O_CREAT|O_NOFOLLOW|O_WRONLY, 0600);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+	printk(KERN_NOTICE "%s: create went ok\n", __func__);
+	if (!file->f_op || !file->f_op->write)
+		goto close_fail;
+
+	retval = dump_checkpoint(file, regs);
+
+close_fail:
+	filp_close(file, NULL);
+	return retval;
+}
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index 8317d94..b367465 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -332,6 +332,7 @@
 #define __NR_fallocate		324
 #define __NR_timerfd_settime	325
 #define __NR_timerfd_gettime	326
+#define __NR_checkpoint		327
 
 #ifdef __KERNEL__
 
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index ee0ed48..3024e44 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -70,6 +70,7 @@ struct linux_binfmt {
 	int (*load_shlib)(struct file *);
 	int (*core_dump)(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
 	unsigned long min_coredump;	/* minimal dump size */
+	int (*checkpoint)(struct pt_regs *regs, struct file *file);
 	int hasvdso;
 };
 
diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
new file mode 100644
index 0000000..5628f0e
--- /dev/null
+++ b/include/linux/checkpoint.h
@@ -0,0 +1,5 @@
+#define CKPT_ID "LX_CKPT"
+#define CKPT_VERSION "2008-07-14"
+#define MMARGSTR 20
+
+int dump_checkpoint(struct file *file, struct pt_regs * regs);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c5d3f84..7098822 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1861,6 +1861,8 @@ extern int do_execve(char *, char __user * __user *, char __user * __user *, str
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
 
+extern int do_checkpoint(char *, struct pt_regs *);
+
 extern void set_task_comm(struct task_struct *tsk, char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0522f36..f08877d 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -617,5 +617,6 @@ asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
+asmlinkage long sys_checkpoint(const char *filename);
 
 #endif
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 5b9b467..62dcdaa 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -161,3 +161,5 @@ cond_syscall(sys_timerfd_gettime);
 cond_syscall(compat_sys_timerfd_settime);
 cond_syscall(compat_sys_timerfd_gettime);
 cond_syscall(sys_eventfd);
+
+cond_syscall(sys_checkpoint);
-- 
1.5.4.3


--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-cryo--sys_checkpoint-first-attempt-at-exploiting.patch"

>From 3b5b5488e4c25a1fff223c9b98883f17af4a40e2 Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serue@us.ibm.com>
Date: Wed, 16 Jul 2008 14:33:31 -0400
Subject: [PATCH 1/1] sys_checkpoint: first attempt at exploiting

First attempt at using the sys_checkpoint and binfmt_cr.c
functionality.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
---
 cr.c  |   13 +++++++++++--
 sci.h |    5 +++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/cr.c b/cr.c
index ffb7b0b..82ba813 100644
--- a/cr.c
+++ b/cr.c
@@ -932,6 +932,11 @@ static int save_process_data(pid_t pid, int fd, lh_list_t *ptree)
 		write_item(fd, "sigpend", &sigpend, sizeof(sigpend));
 	}
 
+	/* Write the ckpt image */
+	snprintf(fname, sizeof(fname), "%u.kckpt", syscallpid);
+	PT_CKPT(syscallpid, fname);
+	write_item(fd, "ckpt_file", fname, strlen(fname));
+
 	/* file descriptors */
 	write_item(fd, "FD", NULL, 0);
 	t_d(pi->nf);
@@ -1094,6 +1099,7 @@ pid_t restart_first_proc(int fd, char *exe, char *sargv, int la, char *senv,
 		WARN("set_proc_file(%d) errno=%d: %s\n", next_pid,
 			errno, strerror(errno));
 
+	DEBUG("executing the file %s with args %s\n", exe, sargv);
 	if ((pid = fork()) == 0) {
 		if (ptrace_traceme() == -1) exit(1);
 		close(fd);
@@ -1877,6 +1883,7 @@ static int process_restart(int fd, int mode)
 	void *buf = NULL;
 	int ret, la = 0, le = 0;
 	size_t bufsz;
+	char *ckpt_file = NULL;
 	lh_list_t *ptree = NULL, *pt;
 	lh_hash_t hpid;
 	pid_t *pid = NULL, *ppid = NULL, npid = 0;
@@ -1912,6 +1919,7 @@ static int process_restart(int fd, int mode)
 			Free(sigact);
 			Free(sigmask);
 			Free(sigpend);
+			Free(ckpt_file);
 		}
 
 		/* fillup process fields */
@@ -1919,6 +1927,7 @@ static int process_restart(int fd, int mode)
 		else ITEM_SET(ppid, pid_t);
 		else ITEM_SET(exitsig, int);
 		else ITEM_SET(exe, char);
+		else ITEM_SET(ckpt_file, char);
 		else ITEM_SET(cwd, char);
 		else ITEM_SET(regs, struct user_regs_struct);
 		else ITEM_SET(fpregs, struct user_fpregs_struct);
@@ -1931,13 +1940,13 @@ static int process_restart(int fd, int mode)
 		else if (ITEM_IS("FD")) {
 			/* all previous necessary fields ok, ready to fork */
 			if (! ptree) {
-				t_d(npid = restart_first_proc(fd, exe, sargv, la, senv, le, *pid));
+				t_d(npid = restart_first_proc(fd, ckpt_file ? ckpt_file : exe, sargv, la, senv, le, *pid));
 			} else {
 				lh_list_t *p = lh_hash_lookup(&hpid, (unsigned int)*ppid);
 				pid_t nppid = p ? (pid_t) p->data : 0;
 				
 				if (*exitsig == SIGCHLD)
-					t_d(npid = restart_proc(fd, nppid, exe, sargv, la, senv, le, *pid));
+					t_d(npid = restart_proc(fd, nppid, ckpt_file ? ckpt_file : exe, sargv, la, senv, le, *pid));
 				else
 					t_d(npid = restart_thread(nppid, *exitsig, regs->esp));
 			}
diff --git a/sci.h b/sci.h
index 0b32ae4..8717350 100644
--- a/sci.h
+++ b/sci.h
@@ -132,6 +132,11 @@ int call_func(pid_t pid, int scratch, int flag, int funcaddr, int argc, ...);
 			-3, 0, buf,		\
 			0, 0, n)
 
+#define SYS_ckpt 327
+#define PT_CKPT(p, path) \
+	ptrace_syscall(p, 0, 0, SYS_ckpt, 1,	\
+			STRLEN_PTR, 0, path)
+
 #define PT_LSEEK(p, fd, off, w) \
 	ptrace_syscall(p, 0, 0, SYS_lseek, 3,	\
 			0, 0, fd,		\
-- 
1.5.5.1


--cNdxnHkX5QqsyA0e--
