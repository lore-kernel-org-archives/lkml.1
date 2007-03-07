Return-Path: <linux-kernel-owner+w=401wt.eu-S1751024AbXCGLbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbXCGLbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbXCGLbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:31:03 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:40658 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbXCGLa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:30:59 -0500
Date: Wed, 7 Mar 2007 14:27:59 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [1/1] eventfs: pseudo fs which allows to bind events to file descriptors.
Message-ID: <20070307112759.GA3796@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 07 Mar 2007 14:28:43 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline

Hello.

This pseudo fs allows to bind a file descriptor to different kinds of
events, which allows to poll them using epoll().

This particular morning hack supports signals only.

If idea is supposed to be right, I can cook up POSIX timers support.

Signal delivery note.
If special flag is set in signalfd(signo, flag), then signals are _not_
delivered through pending mask update but only through epoll queue.
(Copied from kevent).

Userspace signal code and patch itself can be found at:
http://tservice.net.ru/~s0mbre/archive/eventfs/

signal.c is also attached for interested reader.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/arch/i386/kernel/syscall_table.S b/arch/i386/kernel/syscall_table.S
index 2697e92..b14ee54 100644
--- a/arch/i386/kernel/syscall_table.S
+++ b/arch/i386/kernel/syscall_table.S
@@ -319,3 +319,4 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_signalfd		/* 320 */
diff --git a/arch/x86_64/ia32/ia32entry.S b/arch/x86_64/ia32/ia32entry.S
index eda7a0d..bc6336c 100644
--- a/arch/x86_64/ia32/ia32entry.S
+++ b/arch/x86_64/ia32/ia32entry.S
@@ -719,4 +719,5 @@ ia32_sys_call_table:
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
+	.quad sys_signalfd
 ia32_syscall_end:		
diff --git a/fs/Kconfig b/fs/Kconfig
index 3c4886b..09803ad 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1032,6 +1032,15 @@ config CONFIGFS_FS
 	  Both sysfs and configfs can and should exist together on the
 	  same system. One is not a replacement for the other.
 
+config EVENTFS
+	bool "Enable eventpoll filesystem support" if EMBEDDED
+	depends on EPOLL
+	default y
+	help
+	  Allows to bind file descriptors to different kinds of objects
+	  like signals and timers and work with them using epoll 
+	  family of system calls.
+
 endmenu
 
 menu "Miscellaneous filesystems"
diff --git a/fs/Makefile b/fs/Makefile
index 9edf411..185bcb1 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -22,6 +22,7 @@ endif
 obj-$(CONFIG_INOTIFY)		+= inotify.o
 obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
+obj-$(CONFIG_EVENTFS)		+= eventfs.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 
 nfsd-$(CONFIG_NFSD)		:= nfsctl.o
diff --git a/fs/eventfs.c b/fs/eventfs.c
new file mode 100644
index 0000000..dae108c
--- /dev/null
+++ b/fs/eventfs.c
@@ -0,0 +1,221 @@
+/*
+ * 2007 Copyright (c) Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/mount.h>
+#include <linux/device.h>
+#include <linux/poll.h>
+#include <asm/io.h>
+
+static inline void eventfs_set_signal_file(int sig, struct file *file)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	current->signal_file[sig-1] = file;
+	spin_unlock_irq(&current->sighand->siglock);
+}
+	
+static int eventfs_signal_release(struct inode *inode, struct file *file)
+{
+	int sig = (int)((unsigned long)(file->private_data) & 0x0fffffff);
+	eventfs_set_signal_file(sig, NULL);
+	return 0;
+}
+
+static unsigned int eventfs_signal_poll(struct file *file, struct poll_table_struct *wait)
+{
+	int sig = (int)((unsigned long)(file->private_data) & 0x0fffffff);
+	unsigned int mask = 0;
+	unsigned long flags;
+
+	poll_wait(file, &current->signal_wait, wait);
+
+	spin_lock_irqsave(&current->sighand->siglock, flags);
+	if (!sigismember(&current->blocked, sig) && (((unsigned long)(file->private_data)) & 0x40000000)) {
+		mask = POLLIN | POLLRDNORM;
+		file->private_data = (void *)(((unsigned long)(file->private_data)) & ~0x40000000);
+	}
+	spin_unlock_irqrestore(&current->sighand->siglock, flags);
+
+	return mask;
+}
+
+struct file_operations eventfs_signal_fops = {
+	.release	= eventfs_signal_release,
+	.poll		= eventfs_signal_poll,
+	.owner		= THIS_MODULE,
+};
+
+static struct vfsmount *eventfs_mnt __read_mostly;
+
+static int eventfs_get_sb(struct file_system_type *fs_type, int flags,
+		   const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "eventfs", NULL, 0x193748dd, mnt);
+}
+
+static struct file_system_type eventfs_fs_type = {
+	.name		= "eventfs",
+	.get_sb		= eventfs_get_sb,
+	.kill_sb	= kill_anon_super,
+};
+
+static int eventfs_delete_dentry(struct dentry *dentry)
+{
+	return 1;
+}
+
+static struct dentry_operations eventfs_dentry_operations = {
+	.d_delete	= eventfs_delete_dentry,
+};
+
+static int eventfs_init(struct file **filp, struct file_operations *fops, unsigned long priv)
+{
+	struct qstr this;
+	char name[32];
+	struct dentry *dentry;
+	struct inode *inode;
+	struct file *file;
+	int err = -ENFILE, fd;
+
+	file = get_empty_filp();
+	if (!file)
+		goto err_out_exit;
+
+	inode = new_inode(eventfs_mnt->mnt_sb);
+	if (!inode)
+		goto err_out_fput;
+
+	inode->i_fop = fops;
+
+	inode->i_state = I_DIRTY;
+	inode->i_mode = S_IRUSR | S_IWUSR;
+	inode->i_uid = current->fsuid;
+	inode->i_gid = current->fsgid;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+
+	err = get_unused_fd();
+	if (err < 0)
+		goto err_out_iput;
+	fd = err;
+
+	sprintf(name, "[%lu]", inode->i_ino);
+	this.name = name;
+	this.len = strlen(name);
+	this.hash = inode->i_ino;
+	dentry = d_alloc(eventfs_mnt->mnt_sb->s_root, &this);
+	if (!dentry)
+		goto err_out_put_fd;
+	dentry->d_op = &eventfs_dentry_operations;
+	d_add(dentry, inode);
+	file->f_vfsmnt = mntget(eventfs_mnt);
+	file->f_dentry = dentry;
+	file->f_mapping = inode->i_mapping;
+	file->f_pos = 0;
+	file->f_flags = O_RDONLY;
+	file->f_op = fops;
+	file->f_mode = FMODE_READ;
+	file->f_version = 0;
+	file->private_data = (void *)priv;
+
+	fd_install(fd, file);
+	*filp = file;
+
+	return fd;
+
+err_out_put_fd:
+	put_unused_fd(fd);
+err_out_iput:
+	iput(inode);
+err_out_fput:
+	put_filp(file);
+err_out_exit:
+	return err;
+}
+
+asmlinkage long sys_signalfd(int sig, int flags)
+{
+	int fd, err = 0;
+	struct file *file;
+	unsigned long priv = sig;
+
+	if (!valid_signal(sig) || sig < 1/* || sig_kernel_only(sig) */)
+		return -EINVAL;
+
+	spin_lock_irq(&current->sighand->siglock);
+	file = current->signal_file[sig-1];
+	if (file)
+		err = -EEXIST;
+	else
+		current->signal_file[sig-1] = (void *)1;
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (err)
+		return err;
+
+	file = NULL;
+	if (flags)
+		priv |= 0x80000000;
+	fd = eventfs_init(&file, &eventfs_signal_fops, priv);
+	if (fd < 0)
+		goto err_out_clean_file;
+	
+	eventfs_set_signal_file(sig, file);
+
+	return fd;
+
+err_out_clean_file:
+	eventfs_set_signal_file(sig, NULL);
+	return fd;
+}
+
+/*
+ * Eventfs subsystem initialization - create caches and register
+ * filesystem to get control file descriptors from.
+ */
+static int __init eventfs_sys_init(void)
+{
+	int err;
+
+	err = register_filesystem(&eventfs_fs_type);
+	if (err)
+		goto err_out_exit;
+	
+	eventfs_mnt = kern_mount(&eventfs_fs_type);
+	err = PTR_ERR(eventfs_mnt);
+	if (IS_ERR(eventfs_mnt))
+		goto err_out_unreg;
+
+	printk(KERN_INFO "Eventfs subsystem has been successfully registered.\n");
+
+	return 0;
+
+err_out_unreg:
+	unregister_filesystem(&eventfs_fs_type);
+err_out_exit:
+	return err;
+}
+
+module_init(eventfs_sys_init);
diff --git a/include/asm-i386/unistd.h b/include/asm-i386/unistd.h
index 833fa17..c72a568 100644
--- a/include/asm-i386/unistd.h
+++ b/include/asm-i386/unistd.h
@@ -325,10 +325,11 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_signalfd		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/asm-x86_64/unistd.h b/include/asm-x86_64/unistd.h
index c5f596e..62a21f3 100644
--- a/include/asm-x86_64/unistd.h
+++ b/include/asm-x86_64/unistd.h
@@ -619,8 +619,10 @@ __SYSCALL(__NR_sync_file_range, sys_sync_file_range)
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_signalfd		280
+__SYSCALL(__NR_signalfd, sys_signalfd)
 
-#define __NR_syscall_max __NR_move_pages
+#define __NR_syscall_max __NR_signalfd
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 49fe299..22c1412 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -935,6 +935,10 @@ struct task_struct {
 /* signal handlers */
 	struct signal_struct *signal;
 	struct sighand_struct *sighand;
+#ifdef CONFIG_EVENTFS
+	struct file *signal_file[_NSIG];
+	wait_queue_head_t signal_wait;
+#endif
 
 	sigset_t blocked, real_blocked;
 	sigset_t saved_sigmask;		/* To be restored with TIF_RESTORE_SIGMASK */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 1912c6c..b34f4e6 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -605,4 +605,6 @@ asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct g
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+asmlinkage long sys_signalfd(int sig, int flags);
+
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index d154cc7..1b318da 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1128,6 +1128,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (retval)
 		goto bad_fork_cleanup_namespaces;
 
+#ifdef CONFIG_EVENTFS
+	memset(p->signal_file, 0, ARRAY_SIZE(p->signal_file));
+	init_waitqueue_head(&p->signal_wait);
+#endif
+
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
 	/*
 	 * Clear TID on mm_release()?
diff --git a/kernel/signal.c b/kernel/signal.c
index 3670225..059977c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -739,6 +739,16 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	struct sigqueue * q = NULL;
 	int ret = 0;
 
+#ifdef CONFIG_EVENTFS
+	if (t->signal_file[sig-1]) {
+		struct file *file = t->signal_file[sig-1];
+		file->private_data = (void *)(((unsigned long)(file->private_data)) | 0x40000000);
+		wake_up(&t->signal_wait);
+		if (((unsigned long)(file->private_data)) & 0x80000000)
+			return 1;
+	}
+#endif
+
 	/*
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.
@@ -817,6 +827,18 @@ specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 	ret = send_signal(sig, info, t, &t->pending);
 	if (!ret && !sigismember(&t->blocked, sig))
 		signal_wake_up(t, sig == SIGKILL);
+#ifdef CONFIG_EVENTFS
+	/*
+	 * Eventfs allows to deliver signals through epoll queue, 
+	 * it is possible to setup epoll to not deliver
+	 * signal through the usual way, in that case send_signal()
+	 * returns 1 and signal is delivered only through epoll queue.
+	 * We simulate successfull delivery notification through this hack:
+	 */
+	if (ret == 1)
+		ret = 0;
+
+#endif
 out:
 	return ret;
 }
@@ -1006,6 +1028,18 @@ __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 	 * to avoid several races.
 	 */
 	ret = send_signal(sig, info, p, &p->signal->shared_pending);
+#ifdef CONFIG_EVENTFS
+	/*
+	 * Eventfs allows to deliver signals through epoll queue, 
+	 * it is possible to setup epoll to not deliver
+	 * signal through the usual way, in that case send_signal()
+	 * returns 1 and signal is delivered only through epoll queue.
+	 * We simulate successfull delivery notification through this hack:
+	 */
+	if (ret == 1)
+		ret = 0;
+
+#endif
 	if (unlikely(ret))
 		return ret;
 
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index d7306d0..c131d20 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -113,6 +113,8 @@ cond_syscall(sys_vm86);
 cond_syscall(compat_sys_ipc);
 cond_syscall(compat_sys_sysctl);
 
+cond_syscall(sys_signalfd);
+
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
 cond_syscall(sys_pciconfig_write);

-- 
	Evgeniy Polyakov

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=koi8-r
Content-Disposition: attachment; filename="signal.c"

#include <sys/epoll.h>

#include <signal.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <linux/unistd.h>
#include <linux/types.h>

#define _syscall2(type,name,type1,arg1,type2,arg2) \
type name (type1 arg1, type2 arg2) \
{\
	return syscall(__NR_##name, arg1, arg2);\
}

_syscall2(int, signalfd, int, sig, int, flags);

#if 1
#define ulog(f, a...) fprintf(stderr, f, ##a)
#else
#define ulog(f, a...)
#endif
#define ulog_err(f, a...) ulog(f ": %s [%d].\n", ##a, strerror(errno), errno)

static void sig_handler(int signo)
{
	printf("%s, signo: %d.\n", __func__, signo);
}

static int epoll_signal_init(int ctl_fd, int sig, int flags)
{
	int fd;
	struct epoll_event event;

	fd = signalfd(sig, flags);
	if (fd < 0) {
		ulog_err("Failed to bind signal: %d, flags: %d", sig, flags);
		return fd;
	}

	event.events = EPOLLIN;
	event.data.fd = fd;

	if (epoll_ctl(ctl_fd, EPOLL_CTL_ADD, fd, &event) < 0) {
		ulog_err("Failed to perform control ADD operation: fd: %d", fd);
		return -1;
	}

	return 0;
}

int main()
{
	int err, ctl_fd, i;
	struct epoll_event event[256];

	ctl_fd = epoll_create(10);
	if (ctl_fd < 0) {
		ulog_err("Failed to create epoll control file descriptor");
		return -1;
	}

	signal(SIGUSR1, sig_handler);
	signal(SIGUSR2, sig_handler);
	
	err = epoll_signal_init(ctl_fd, SIGUSR1, 1);
	if (err)
		return err;

	err = epoll_signal_init(ctl_fd, SIGUSR2, 0);
	if (err)
		return err;

	ulog("%s: pid: %d\n", __func__, getpid());

	kill(getpid(), SIGUSR1);
	kill(getpid(), SIGUSR2);

	while (1) {
		err = epoll_wait(ctl_fd, event, 256, 10000);
		if (err < 0) {
			ulog_err("Failed to wait for events");
			continue;
		}

		if (err == 0)
			continue;

		for (i=0; i<err; ++i)
			printf("Dequeued signal, fd: %u.\n", event[i].data.fd);
	}

	return 0;
}

--T4sUOijqQbZv57TR--
