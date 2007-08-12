Return-Path: <linux-kernel-owner+w=401wt.eu-S935091AbXHLNjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935091AbXHLNjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 09:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXHLNji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 09:39:38 -0400
Received: from mail.visit.se ([85.194.0.110]:57600 "EHLO mail.visit.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761904AbXHLNjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 09:39:36 -0400
X-Greylist: delayed 2110 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Aug 2007 09:39:35 EDT
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Transfer-Encoding: 7bit
Message-Id: <70E19A0A-2728-4ADA-B984-A36182C1F575@nocrew.org>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-kernel@vger.kernel.org
From: Fredrik Noring <noring@nocrew.org>
Subject: Improving read/write/close system call reliability when used with pthreads
Date: Sun, 12 Aug 2007 15:03:25 +0200
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The attached patch attempts to improve read/write/close system call  
reliability when used with pthreads and pipes. At least two issues  
are handled:

1. Read/write system calls hanging indefinitely when the fd is closed  
by another thread.

2. Read/write fd (reuse) alias problems in combination with - 
ERESTARTSYS.

For (1), a simple scenario has two threads: a reader and a watchdog.  
The reader thread is stuck in a blocking read of an unreliable pipe.  
The watchdog thread is designed to cancel the blocking read using  
close on the reader's fd.

Unfortunately, with the current kernel, the reader thread does not  
wake up by the close call issued by the watchdog. Instead, the reader  
thread remains stuck unless some unrelated signal happens to arrive,  
in which case it wakes up and terminates with -EBADF. This is also  
the current workaround: have the process signal itself after the  
close call in the watchdog thread.

For (2), the scenario can be as (1) above, adding an open system call  
between the close and signal events. Since the read fd has been  
closed it's now reused by open for a completely unrelated file, and  
when read finally wakes up by the signal it starts reading it.

In both of these cases, I believe it would be desirable to have read  
terminate immediately with -EBADF. Similar scenarios can be made for  
the write system call (and perhaps others as well).

The attached sample programs (watchdog.c and aliasing.c) demonstrate  
the effects.

Please regard the attached patch as proof-of-concept to trying to  
solve these problems. The FIXME certainly needs more thought, as do  
locking schemes, performance impact, related fd issues, and the  
approach taken in general. I'd be delighted if it would be possible  
to sort out. :-)

Many thanks,
Fredrik



Notes regarding the patch:

The patch adds a required_fds list to task_struct. System calls such  
as read and write register their fd respectively in this list, as the  
fd:s are required for successful completion of the calls. When close  
is called, it scans the required_fds lists and marks closed fd:s with  
-EBADF, as well as notifies the file with the new file->f_op- 
 >closing_fd file operation. This allows files to wake up waiting  
read/write calls. When read/write wakes up, it checks its  
required_fds list and cancels if its fd has been marked -EBADF.

fs/open.c                 |   63 +++++++++++++++++++++++++++++++++++++ 
+++++++++
fs/pipe.c                 |   28 ++++++++++++++++++++
fs/read_write.c           |    6 ++++
include/linux/fs.h        |    5 +++
include/linux/init_task.h |    1
include/linux/sched.h     |   13 ++++++++-
kernel/fork.c             |    1
7 files changed, 115 insertions(+), 2 deletions(-)



Notes regarding POSIX:

Whether or not close may cancel I/O operations appears to be  
implementation-defined if I interpret the following section  
correctly, unless anyone knows more specific details?

The Open Group Base Specifications Issue 6
IEEE Std 1003.1, 2004 Edition
Copyright 2001-2004 The IEEE and The Open Group, All Rights reserved.

When there is an outstanding cancelable asynchronous I/O operation  
against fildes when close() is called, that I/O operation may be  
canceled. An I/O operation that is not canceled completes as if the  
close() operation had not yet occurred. All operations that are not  
canceled shall complete as if the close() blocked until the  
operations completed. The close() operation itself need not block  
awaiting such I/O completion. Whether any I/O operation is canceled,  
and which I/O operation may be canceled upon close(), is  
implementation-defined.



watchdog.c:

#include <sys/types.h>
#include <sys/uio.h>
#include <pthread.h>
#include <unistd.h>
#include <signal.h>
#include <stdio.h>
#include <errno.h>

int inout[2] = { -1, -1 };

void *watchdog(void *arg)
{
	fprintf(stderr, "Sleeping...\n");
	sleep(1);
	fprintf(stderr, "Closing...\n");
	close(inout[0]);
	fprintf(stderr, "Closed.\n");
	return NULL;
}

void wakeup(int sig)
{
	fprintf(stderr, "Alarmed.\n");
}

int main(int argc, char *argv[])
{
	pthread_t th;
	char buf[1];
	ssize_t r;
	
	pipe(inout);
	pthread_create(&th, NULL, watchdog, NULL);
	signal(SIGALRM, wakeup);
	alarm(5);
	
	fprintf(stderr, "Reading...\n");
	r = read(inout[0], buf, sizeof(buf));
	if (r == -1)
		perror("read");
	fprintf(stderr, "Read done.\n");
	
	pthread_join(th, NULL);
	fprintf(stderr, "Exit.\n");
	
	return 0;
}



aliasing.c:

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <pthread.h>
#include <unistd.h>
#include <signal.h>
#include <stdio.h>
#include <errno.h>

int inout[2] = { -1, -1 };

void *aliasing(void *arg)
{
	fprintf(stderr, "Sleeping...\n");
	sleep(1);
	fprintf(stderr, "Closing...\n");
	close(inout[0]);
	fprintf(stderr, "Closed.\n");
	fprintf(stderr, "Opening...\n");
	open(__FILE__, O_RDONLY);
	fprintf(stderr, "Opened.\n");
	return NULL;
}

void wakeup(int sig)
{
	fprintf(stderr, "Alarmed.\n");
}

int main(int argc, char *argv[])
{
	pthread_t th;
	char buf[1];
	ssize_t r;
	
	pipe(inout);
	pthread_create(&th, NULL, aliasing, NULL);
	signal(SIGALRM, wakeup);
	alarm(5);
	
	fprintf(stderr, "Reading...\n");
	r = read(inout[0], buf, 1);
	if (r == -1)
		perror("read");
	else
		fprintf(stderr, "Alias read!\n");
	fprintf(stderr, "Read done.\n");
	
	pthread_join(th, NULL);
	fprintf(stderr, "Exit.\n");
	
	return 0;
}



required-fds.patch (not sure Apple Mail can handle this properly  
though...):

--- linux-2.6.19-gentoo-r5/include/linux/init_task.h	2007-07-12  
22:03:14.000000000 +0200
+++ linux-2.6.19-required-fds/include/linux/init_task.h	2007-08-12  
03:51:34.000000000 +0200
@@ -126,6 +126,7 @@
	.thread		= INIT_THREAD,					\
	.fs		= &init_fs,					\
	.files		= &init_files,					\
+	.required_fds	= LIST_HEAD_INIT(tsk.required_fds),		\
	.signal		= &init_signals,				\
	.sighand	= &init_sighand,				\
	.nsproxy	= &init_nsproxy,				\
--- linux-2.6.19-gentoo-r5/include/linux/sched.h	2007-07-12  
22:03:14.000000000 +0200
+++ linux-2.6.19-required-fds/include/linux/sched.h	2007-08-12  
13:47:44.000000000 +0200
@@ -907,6 +907,8 @@
	struct fs_struct *fs;
/* open file information */
	struct files_struct *files;
+/* file descriptors required to complete current I/O operation  
successfully */
+	struct list_head required_fds;
/* namespaces */
	struct nsproxy *nsproxy;
/* signal handlers */
@@ -930,7 +932,7 @@
/* Thread group tracking */
     	u32 parent_exec_id;
     	u32 self_exec_id;
-/* Protection of (de-)allocation: mm, files, fs, tty, keyrings */
+/* Protection of (de-)allocation: mm, files, required_fds, fs, tty,  
keyrings */
	spinlock_t alloc_lock;
	/* Protection of the PI data structures: */
@@ -1025,6 +1027,13 @@
#endif
};
+#define REQUIRED_FD_INIT(fd) { .fd = fd }
+
+struct required_fd {
+	struct list_head list;
+	int fd;
+};
+
static inline pid_t process_group(struct task_struct *tsk)
{
	return tsk->signal->pgrp;
@@ -1429,7 +1438,7 @@
		(thread_group_leader(p) && !thread_group_empty(p))
/*
- * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
+ * Protects ->fs, ->files, ->mm, ->group_info, ->comm, - 
 >required_fds, keyring
   * subscriptions and synchronises with wait4().  Also used in  
procfs.  Also
   * pins the final release of task.io_context.  Also protects ->cpuset.
   *
--- linux-2.6.19-gentoo-r5/include/linux/fs.h	2007-07-12  
22:03:14.000000000 +0200
+++ linux-2.6.19-required-fds/include/linux/fs.h	2007-08-12  
13:27:02.000000000 +0200
@@ -1120,6 +1120,7 @@
	int (*mmap) (struct file *, struct vm_area_struct *);
	int (*open) (struct inode *, struct file *);
	int (*flush) (struct file *, fl_owner_t id);
+	void (*closing_fd) (struct inode *, struct file *, struct  
files_struct *files, unsigned int fd);
	int (*release) (struct inode *, struct file *);
	int (*fsync) (struct file *, struct dentry *, int datasync);
	int (*aio_fsync) (struct kiocb *, int datasync);
@@ -1497,6 +1498,10 @@
			int mode);
extern struct file *filp_open(const char *, int, int);
extern struct file * dentry_open(struct dentry *, struct vfsmount *,  
int);
+extern int required_fds_are_bad(struct task_struct *task);
+extern void add_required_fd(struct task_struct *task,
+			    struct required_fd *req_fd);
+extern void del_required_fds(struct task_struct *task);
extern int filp_close(struct file *, fl_owner_t id);
extern char * getname(const char __user *);
--- linux-2.6.19-gentoo-r5/kernel/fork.c	2007-07-12  
22:03:14.000000000 +0200
+++ linux-2.6.19-required-fds/kernel/fork.c	2007-08-12  
13:12:59.000000000 +0200
@@ -1156,6 +1156,7 @@
	retval = copy_thread(0, clone_flags, stack_start, stack_size, p, regs);
	if (retval)
		goto bad_fork_cleanup_namespaces;
+	INIT_LIST_HEAD(&p->required_fds);
	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ?  
child_tidptr : NULL;
	/*
--- linux-2.6.19-gentoo-r5/fs/read_write.c	2007-07-12  
22:03:14.000000000 +0200
+++ linux-2.6.19-required-fds/fs/read_write.c	2007-08-12  
13:19:59.000000000 +0200
@@ -355,10 +355,12 @@
asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf,  
size_t count)
{
+	struct required_fd req_fd = REQUIRED_FD_INIT(fd);
	struct file *file;
	ssize_t ret = -EBADF;
	int fput_needed;
+	add_required_fd(current, &req_fd);
	file = fget_light(fd, &fput_needed);
	if (file) {
		loff_t pos = file_pos_read(file);
@@ -366,6 +368,7 @@
		file_pos_write(file, pos);
		fput_light(file, fput_needed);
	}
+	del_required_fds(current);
	return ret;
}
@@ -373,10 +376,12 @@
asmlinkage ssize_t sys_write(unsigned int fd, const char __user *  
buf, size_t count)
{
+	struct required_fd req_fd = REQUIRED_FD_INIT(fd);
	struct file *file;
	ssize_t ret = -EBADF;
	int fput_needed;
+	add_required_fd(current, &req_fd);
	file = fget_light(fd, &fput_needed);
	if (file) {
		loff_t pos = file_pos_read(file);
@@ -384,6 +389,7 @@
		file_pos_write(file, pos);
		fput_light(file, fput_needed);
	}
+	del_required_fds(current);
	return ret;
}
--- linux-2.6.19-gentoo-r5/fs/open.c	2007-07-12 22:03:14.000000000 +0200
+++ linux-2.6.19-required-fds/fs/open.c	2007-08-12 16:30:03.000000000  
+0200
@@ -2,6 +2,9 @@
   *  linux/fs/open.c
   *
   *  Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ *  2007-08-12 Implemented required_fds functionality to close files
+ *             reliably with pthreads, by Fredrik Noring  
<noring@nocrew.org>.
   */
#include <linux/string.h>
@@ -1015,6 +1018,53 @@
#endif
+void mark_required_fd_bad(struct task_struct *task, unsigned int fd)
+{
+	struct required_fd *req_fd;
+
+	task_lock(task);
+	list_for_each_entry(req_fd, &task->required_fds, list)
+		if (req_fd->fd == fd)
+			req_fd->fd = -EBADF;
+	task_unlock(task);
+}
+
+int required_fds_are_bad(struct task_struct *task)
+{
+	struct required_fd *req_fd;
+	int ret = 0;
+
+	task_lock(task);
+	list_for_each_entry(req_fd, &task->required_fds, list)
+		if (req_fd->fd == -EBADF) {
+			ret = 1;
+			break;
+		}
+	task_unlock(task);
+	
+	return ret;
+}
+
+EXPORT_SYMBOL(required_fds_are_bad);
+
+void add_required_fd(struct task_struct *task, struct required_fd  
*req_fd)
+{
+	task_lock(task);
+	list_add(&req_fd->list, &task->required_fds);
+	task_unlock(task);
+}
+
+EXPORT_SYMBOL(add_required_fd);
+
+void del_required_fds(struct task_struct *task)
+{
+	task_lock(task);
+	INIT_LIST_HEAD(&task->required_fds);
+	task_unlock(task);
+}
+
+EXPORT_SYMBOL(del_required_fds);
+
/*
   * "id" is the POSIX thread ID. We use the
   * files pointer for this..
@@ -1048,9 +1098,17 @@
{
	struct file * filp;
	struct files_struct *files = current->files;
+	struct task_struct *task;
	struct fdtable *fdt;
	int retval;
+	/* FIXME: Proof of concept but obviously inefficient. Mark
+	 * within f_op->closing_fd instead, where we know the tasks
+	 * that are really interested in learning this? */
+	for_each_process(task)
+		if(task->files == files)
+			mark_required_fd_bad(task, fd);
+	
	spin_lock(&files->file_lock);
	fdt = files_fdtable(files);
	if (fd >= fdt->max_fds)
@@ -1062,6 +1120,10 @@
	FD_CLR(fd, fdt->close_on_exec);
	__put_unused_fd(files, fd);
	spin_unlock(&files->file_lock);
+	if (filp->f_op && filp->f_op->closing_fd) {
+		struct inode *inode = filp->f_dentry->d_inode;
+		filp->f_op->closing_fd(inode, filp, files, fd);
+	}
	retval = filp_close(filp, files);
	/* can't restart close syscall because file table entry was cleared */
--- linux-2.6.19-gentoo-r5/fs/pipe.c	2007-07-12 22:03:14.000000000 +0200
+++ linux-2.6.19-required-fds/fs/pipe.c	2007-08-12 13:43:13.000000000  
+0200
@@ -316,6 +316,11 @@
			wake_up_interruptible_sync(&pipe->wait);
   			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
		}
+		if (required_fds_are_bad(current)) {
+			if (!ret)
+				ret = -EBADF;
+			break;
+		}
		pipe_wait(pipe);
	}
	mutex_unlock(&inode->i_mutex);
@@ -488,6 +493,11 @@
			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
			do_wakeup = 0;
		}
+		if (required_fds_are_bad(current)) {
+			if (!ret)
+				ret = -EBADF;
+			break;
+		}
		pipe->waiting_writers++;
		pipe_wait(pipe);
		pipe->waiting_writers--;
@@ -576,6 +586,18 @@
	return mask;
}
+static void
+pipe_closing_fd(struct inode *inode, struct file *file,
+		struct files_struct *files, unsigned int fd)
+{
+	struct pipe_inode_info *pipe;
+
+	mutex_lock(&inode->i_mutex);
+	pipe = inode->i_pipe;
+	wake_up_interruptible(&pipe->wait);
+	mutex_unlock(&inode->i_mutex);
+}
+
static int
pipe_release(struct inode *inode, int decr, int decw)
{
@@ -727,6 +749,7 @@
	.poll		= pipe_poll,
	.ioctl		= pipe_ioctl,
	.open		= pipe_read_open,
+	.closing_fd	= pipe_closing_fd,
	.release	= pipe_read_release,
	.fasync		= pipe_read_fasync,
};
@@ -739,6 +762,7 @@
	.poll		= pipe_poll,
	.ioctl		= pipe_ioctl,
	.open		= pipe_write_open,
+	.closing_fd	= pipe_closing_fd,
	.release	= pipe_write_release,
	.fasync		= pipe_write_fasync,
};
@@ -752,6 +776,7 @@
	.poll		= pipe_poll,
	.ioctl		= pipe_ioctl,
	.open		= pipe_rdwr_open,
+	.closing_fd	= pipe_closing_fd,
	.release	= pipe_rdwr_release,
	.fasync		= pipe_rdwr_fasync,
};
@@ -764,6 +789,7 @@
	.poll		= pipe_poll,
	.ioctl		= pipe_ioctl,
	.open		= pipe_read_open,
+	.closing_fd	= pipe_closing_fd,
	.release	= pipe_read_release,
	.fasync		= pipe_read_fasync,
};
@@ -776,6 +802,7 @@
	.poll		= pipe_poll,
	.ioctl		= pipe_ioctl,
	.open		= pipe_write_open,
+	.closing_fd	= pipe_closing_fd,
	.release	= pipe_write_release,
	.fasync		= pipe_write_fasync,
};
@@ -789,6 +816,7 @@
	.poll		= pipe_poll,
	.ioctl		= pipe_ioctl,
	.open		= pipe_rdwr_open,
+	.closing_fd	= pipe_closing_fd,
	.release	= pipe_rdwr_release,
	.fasync		= pipe_rdwr_fasync,
};

