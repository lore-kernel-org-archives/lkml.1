Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbYGaJdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbYGaJdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYGaJcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:32:33 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:54994 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYGaJc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:32:29 -0400
Message-Id: <20080731093220.690886851@free-electrons.com>
References: <20080731092703.661994657@free-electrons.com>
User-Agent: quilt/0.46-1
Date: Thu, 31 Jul 2008 11:27:04 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Cc: michael@free-electrons.com,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Matt Mackall <mpm@selenic.com>, bcrl@kvack.org, linux-aio@kvack.org,
       akpm@linux-foundation.org
Subject: [patch 1/4] Configure out AIO support
Content-Disposition: inline; filename=configure-out-aio-support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds the CONFIG_AIO option which allows to remove support
for asynchronous I/O operations, that are not necessarly used by
applications, particularly on embedded devices. As this is a
size-reduction option, it depends on CONFIG_EMBEDDED. It allows to
save ~7 kilobytes of kernel code/data:

   text	   data	    bss	    dec	    hex	filename
1115067	 119180	 217088	1451335	 162547	vmlinux
1108025	 119048	 217088	1444161	 160941	vmlinux.new
  -7042    -132       0   -7174   -1C06 +/-

This patch has been originally written by Matt Mackall
<mpm@selenic.com>, and is part of the Linux Tiny project.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: bcrl@kvack.org
Cc: linux-aio@kvack.org
Cc: mpm@selenic.com
Cc: akpm@linux-foundation.org


---
 fs/Makefile         |    3 ++-
 include/linux/aio.h |    9 +++++++++
 init/Kconfig        |    8 ++++++++
 kernel/sys_ni.c     |    5 +++++
 kernel/sysctl.c     |    2 ++
 5 files changed, 26 insertions(+), 1 deletion(-)

Index: linuxdev/fs/Makefile
===================================================================
--- linuxdev.orig/fs/Makefile
+++ linuxdev/fs/Makefile
@@ -8,7 +8,7 @@
 obj-y :=	open.o read_write.o file_table.o super.o \
 		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
 		ioctl.o readdir.o select.o fifo.o locks.o dcache.o inode.o \
-		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
+		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
 		stack.o
@@ -27,6 +27,7 @@
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
+obj-$(CONFIG_AIO)               += aio.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 
 nfsd-$(CONFIG_NFSD)		:= nfsctl.o
Index: linuxdev/include/linux/aio.h
===================================================================
--- linuxdev.orig/include/linux/aio.h
+++ linuxdev/include/linux/aio.h
@@ -204,12 +204,21 @@
 /* prototypes */
 extern unsigned aio_max_size;
 
+#ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
 extern int aio_put_req(struct kiocb *iocb);
 extern void kick_iocb(struct kiocb *iocb);
 extern int aio_complete(struct kiocb *iocb, long res, long res2);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
+#else
+static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
+static inline int aio_put_req(struct kiocb *iocb) { return 0; }
+static inline void kick_iocb(struct kiocb *iocb) { }
+static inline int aio_complete(struct kiocb *iocb, long res, long res2) { return 0; }
+struct mm_struct;
+static inline void exit_aio(struct mm_struct *mm) { }
+#endif /* CONFIG_AIO */
 
 #define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
 
Index: linuxdev/init/Kconfig
===================================================================
--- linuxdev.orig/init/Kconfig
+++ linuxdev/init/Kconfig
@@ -724,6 +724,14 @@
 	  option replaces shmem and tmpfs with the much simpler ramfs code,
 	  which may be appropriate on small systems without swap.
 
+config AIO
+	bool "Enable AIO support" if EMBEDDED
+	default y
+	help
+	  This option enables POSIX asynchronous I/O which may by used
+          by some high performance threaded applications. Disabling
+          this option saves about 7k.
+
 config VM_EVENT_COUNTERS
 	default y
 	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
Index: linuxdev/kernel/sys_ni.c
===================================================================
--- linuxdev.orig/kernel/sys_ni.c
+++ linuxdev/kernel/sys_ni.c
@@ -125,6 +125,11 @@
 cond_syscall(sys_vm86);
 cond_syscall(compat_sys_ipc);
 cond_syscall(compat_sys_sysctl);
+cond_syscall(sys_io_setup);
+cond_syscall(sys_io_destroy);
+cond_syscall(sys_io_submit);
+cond_syscall(sys_io_cancel);
+cond_syscall(sys_io_getevents);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
Index: linuxdev/kernel/sysctl.c
===================================================================
--- linuxdev.orig/kernel/sysctl.c
+++ linuxdev/kernel/sysctl.c
@@ -1290,6 +1290,7 @@
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
+#ifdef CONFIG_AIO
 	{
 		.procname	= "aio-nr",
 		.data		= &aio_nr,
@@ -1304,6 +1305,7 @@
 		.mode		= 0644,
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
+#endif /* CONFIG_AIO */
 #ifdef CONFIG_INOTIFY_USER
 	{
 		.ctl_name	= FS_INOTIFY,

-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
