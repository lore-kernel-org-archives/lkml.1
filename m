Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYLIRAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYLIRAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbYLIRAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:00:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51447 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbYLIRA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:00:29 -0500
Message-ID: <493EA441.1070706@redhat.com>
Date: Tue, 09 Dec 2008 12:00:49 -0500
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Scott James Remnant <scott@netsplit.com>
Subject: [RFC PATCH] waitfd: file descriptor to wait on child processes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is essentially my first kernel patch, so be nice :)

Linux already has signalfd, timerfd, and eventfd to expose signals, 
timers, and events via a file descriptor. This patch is a working 
prototype for a fourth: waitfd. It pretty much does what the name 
suggests: reading from it yields a series of status ints (as would be 
written into the second argument of waitpid) for child processes that 
have changed state. It takes essentially the same arguments as waitpid 
(for now) and supports the same set of features.

This is far from ready for merge. Some things that are wrong with it:
* Waitpid's argument scheme probably isn't the best for this. By default 
it makes it easiest to wait on a single child, which is not often useful 
in this case. Waiting on all children or children in a particular 
process group is possible, but not a particular, explicit set of 
children, which we probably want (and which will complicate the 
implementation significantly).
* The prototype for peek_waitpid is obviously in the wrong place, but I 
haven't found a good home for it.
* Waitid's semantics have slightly altered: passing NULL as the pointer 
to siginfo_t with WNOWAIT will now return successfully instead of 
throwing EFAULT. I don't know if that means I broke it or fixed it :)
* peek_waitpid may not be required at all now. I can probably trick 
sys_wait4 or sys_waitid into giving me what I want (or I could always 
just make do_wait non-static).

Please provide thoughts.

--CJD

 arch/x86/include/asm/unistd_32.h   |    1 +
 arch/x86/include/asm/unistd_64.h   |    2 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/Makefile                        |    1 +
 fs/waitfd.c                        |  113 
++++++++++++++++++++++++++++++++++++
 init/Kconfig                       |   10 +++
 kernel/exit.c                      |   59 +++++++++++++++----
 kernel/sys_ni.c                    |    1 +
 8 files changed, 176 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/unistd_32.h 
b/arch/x86/include/asm/unistd_32.h
index f2bba78..134d83c 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -338,6 +338,7 @@
 #define __NR_dup3        330
 #define __NR_pipe2        331
 #define __NR_inotify_init1    332
+#define __NR_waitfd        333
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/include/asm/unistd_64.h 
b/arch/x86/include/asm/unistd_64.h
index d2e415e..b28eb07 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -653,6 +653,8 @@ __SYSCALL(__NR_dup3, sys_dup3)
 __SYSCALL(__NR_pipe2, sys_pipe2)
 #define __NR_inotify_init1            294
 __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
+#define __NR_waitfd                295
+__SYSCALL(__NR_waitfd, sys_waitfd)
 
 
 #ifndef __NO_STUBS
diff --git a/arch/x86/kernel/syscall_table_32.S 
b/arch/x86/kernel/syscall_table_32.S
index d44395f..c796a8b 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,4 @@ ENTRY(sys_call_table)
     .long sys_dup3            /* 330 */
     .long sys_pipe2
     .long sys_inotify_init1
+    .long sys_waitfd
diff --git a/fs/Makefile b/fs/Makefile
index d9f8afe..74c31fb 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_INOTIFY_USER)    += inotify_user.o
 obj-$(CONFIG_EPOLL)        += eventpoll.o
 obj-$(CONFIG_ANON_INODES)    += anon_inodes.o
 obj-$(CONFIG_SIGNALFD)        += signalfd.o
+obj-$(CONFIG_WAITFD)        += waitfd.o
 obj-$(CONFIG_TIMERFD)        += timerfd.o
 obj-$(CONFIG_EVENTFD)        += eventfd.o
 obj-$(CONFIG_AIO)               += aio.o
diff --git a/fs/waitfd.c b/fs/waitfd.c
new file mode 100644
index 0000000..25b54d1
--- /dev/null
+++ b/fs/waitfd.c
@@ -0,0 +1,113 @@
+/*
+ *  fs/waitfd.c
+ *
+ *  Copyright (C) 2008  Red Hat, Casey Dahlin <cdahlin@redhat.com>
+ *
+ *  Largely derived from fs/signalfd.c
+ */
+
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/list.h>
+#include <linux/anon_inodes.h>
+#include <linux/syscalls.h>
+
+long peek_waitpid(pid_t upid, int options);
+
+struct waitfd_ctx {
+    int ops;
+    pid_t upid;
+};
+
+static int waitfd_release(struct inode *inode, struct file *file)
+{
+    kfree(file->private_data);
+    return 0;
+}
+
+static unsigned int waitfd_poll(struct file *file, poll_table *wait)
+{
+    struct waitfd_ctx *ctx = file->private_data;
+    long value;
+
+    poll_wait(file, &current->signal->wait_chldexit, wait);
+
+    value = peek_waitpid(ctx->upid, ctx->ops);
+    if (value > 0) {
+        return POLLIN;
+    } if (value == -ECHILD) {
+        return POLLIN;
+    }
+
+    return 0;
+}
+
+/*
+ * Returns a multiple of the size of a "struct waitfd_siginfo", or a 
negative
+ * error code. The "count" parameter must be at least the size of a
+ * "struct waitfd_siginfo".
+ */
+static ssize_t waitfd_read(struct file *file, char __user *buf, size_t 
count,
+                 loff_t *ppos)
+{
+    struct waitfd_ctx *ctx = file->private_data;
+    int __user *stat_addr = (int *)buf;
+    int nonblock = file->f_flags & O_NONBLOCK ? WNOHANG: 0;
+    ssize_t ret, total = 0;
+
+    count /= sizeof(int);
+    if (!count)
+        return -EINVAL;
+
+    do {
+        ret = sys_wait4(ctx->upid, stat_addr, ctx->ops | nonblock,
+                NULL);
+        if (ret == 0)
+            ret = -EAGAIN;
+        if (ret == -ECHILD)
+            ret = 0;
+        if (ret <= 0)
+            break;
+
+        stat_addr++;
+        total += sizeof(struct siginfo);
+        nonblock = WNOHANG;
+    } while (--count);
+
+    return total ? total: ret;
+}
+
+static const struct file_operations waitfd_fops = {
+    .release    = waitfd_release,
+    .poll        = waitfd_poll,
+    .read        = waitfd_read,
+};
+
+asmlinkage long sys_waitfd(pid_t upid, int ops)
+{
+    int ufd;
+    struct waitfd_ctx *ctx;
+
+    if (ops & ~(WNOHANG|WUNTRACED|WCONTINUED|
+            __WNOTHREAD|__WCLONE|__WALL))
+        return -EINVAL;
+
+    ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+    if (!ctx)
+        return -ENOMEM;
+
+    ctx->ops = ops;
+    ctx->upid = upid;
+
+    ufd = anon_inode_getfd("[waitfd]", &waitfd_fops, ctx,
+                   (ops & WNOHANG) ? O_NONBLOCK : 0);
+    if (ufd < 0)
+        kfree(ctx);
+
+    return ufd;
+}
diff --git a/init/Kconfig b/init/Kconfig
index f763762..bc34871 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -683,6 +683,16 @@ config EPOLL
       Disabling this option will cause the kernel to be built without
       support for epoll family of system calls.
 
+config WAITFD
+    bool "Enable waitfd() system call" if EMBEDDED
+    select ANON_INODES
+    default y
+    help
+      Enable the waitfd() system call that allows receving child state
+      changes from a file descriptor.
+
+      If unsure, say Y.
+
 config SIGNALFD
     bool "Enable signalfd() system call" if EMBEDDED
     select ANON_INODES
diff --git a/kernel/exit.c b/kernel/exit.c
index 2d8be7e..e69044b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1233,18 +1233,20 @@ static int wait_noreap_copyout(struct 
task_struct *p, pid_t pid, uid_t uid,
     int retval = rusagep ? getrusage(p, RUSAGE_BOTH, rusagep) : 0;
 
     put_task_struct(p);
-    if (!retval)
-        retval = put_user(SIGCHLD, &infop->si_signo);
-    if (!retval)
-        retval = put_user(0, &infop->si_errno);
-    if (!retval)
-        retval = put_user((short)why, &infop->si_code);
-    if (!retval)
-        retval = put_user(pid, &infop->si_pid);
-    if (!retval)
-        retval = put_user(uid, &infop->si_uid);
-    if (!retval)
-        retval = put_user(status, &infop->si_status);
+    if (infop) {
+        if (!retval)
+            retval = put_user(SIGCHLD, &infop->si_signo);
+        if (!retval)
+            retval = put_user(0, &infop->si_errno);
+        if (!retval)
+            retval = put_user((short)why, &infop->si_code);
+        if (!retval)
+            retval = put_user(pid, &infop->si_pid);
+        if (!retval)
+            retval = put_user(uid, &infop->si_uid);
+        if (!retval)
+            retval = put_user(status, &infop->si_status);
+    }
     if (!retval)
         retval = pid;
     return retval;
@@ -1794,6 +1796,39 @@ asmlinkage long sys_waitid(int which, pid_t upid,
     return ret;
 }
 
+long peek_waitpid(pid_t upid, int options)
+{
+    struct pid *pid = NULL;
+    enum pid_type type;
+    long ret;
+
+    if (options & ~(WNOHANG|WUNTRACED|WCONTINUED|
+            __WNOTHREAD|__WCLONE|__WALL))
+        return -EINVAL;
+
+    options |= WNOHANG | WNOWAIT;
+
+    if (upid == -1)
+        type = PIDTYPE_MAX;
+    else if (upid < 0) {
+        type = PIDTYPE_PGID;
+        pid = find_get_pid(-upid);
+    } else if (upid == 0) {
+        type = PIDTYPE_PGID;
+        pid = get_pid(task_pgrp(current));
+    } else /* upid > 0 */ {
+        type = PIDTYPE_PID;
+        pid = find_get_pid(upid);
+    }
+
+    ret = do_wait(type, pid, options | WEXITED, NULL, NULL, NULL);
+    put_pid(pid);
+
+    /* avoid REGPARM breakage on x86: */
+    asmlinkage_protect(4, ret, upid, options);
+    return ret;
+}
+
 asmlinkage long sys_wait4(pid_t upid, int __user *stat_addr,
               int options, struct rusage __user *ru)
 {
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index e14a232..e8d4da6 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -163,6 +163,7 @@ cond_syscall(sys_ioprio_set);
 cond_syscall(sys_ioprio_get);
 
 /* New file descriptors */
+cond_syscall(sys_waitfd);
 cond_syscall(sys_signalfd);
 cond_syscall(sys_signalfd4);
 cond_syscall(compat_sys_signalfd);

