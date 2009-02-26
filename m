Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZBZLsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZBZLsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 06:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZBZLr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 06:47:59 -0500
Received: from bilbo.ozlabs.org ([203.10.76.25]:57631 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbZBZLr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 06:47:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18854.33125.115592.732783@cargo.ozlabs.ibm.com>
Date: Thu, 26 Feb 2009 22:47:49 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] perfcounters: fix a few minor cleanliness issues
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes three issues noticed by Arnd Bergmann:

- Add #ifdef __KERNEL__ and move some things around in perf_counter.h
  to make sure only the bits that userspace needs are exported to
  userspace.

- Use __u64, __s64, __u32 types in the structs exported to userspace
  rather than u64, s64, u32.

- Make the sys_perf_counter_open syscall available to the SPUs on
  Cell platforms.

And one issue that I noticed in looking at the code again:

- Wrap the perf_counter_open syscall with SYSCALL_DEFINE4 so we get
  the proper handling of int arguments on ppc64 (and some other 64-bit
  architectures).

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This is in the master branch of my perfcounters.git tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

 arch/powerpc/include/asm/systbl.h |    2 +-
 include/linux/perf_counter.h      |   43 +++++++++++++++++++-----------------
 include/linux/syscalls.h          |    9 ++-----
 kernel/perf_counter.c             |    6 ++--
 4 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 4c8095f..d312eec 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -322,4 +322,4 @@ SYSCALL_SPU(epoll_create1)
 SYSCALL_SPU(dup3)
 SYSCALL_SPU(pipe2)
 SYSCALL(inotify_init1)
-SYSCALL(perf_counter_open)
+SYSCALL_SPU(perf_counter_open)
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 32cd1ac..186efaf 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -13,20 +13,8 @@
 #ifndef _LINUX_PERF_COUNTER_H
 #define _LINUX_PERF_COUNTER_H
 
-#include <asm/atomic.h>
-#include <asm/ioctl.h>
-
-#ifdef CONFIG_PERF_COUNTERS
-# include <asm/perf_counter.h>
-#endif
-
-#include <linux/list.h>
-#include <linux/mutex.h>
-#include <linux/rculist.h>
-#include <linux/rcupdate.h>
-#include <linux/spinlock.h>
-
-struct task_struct;
+#include <linux/types.h>
+#include <linux/ioctl.h>
 
 /*
  * User-space ABI bits:
@@ -78,12 +66,12 @@ enum perf_counter_record_type {
  * Hardware event to monitor via a performance monitoring counter:
  */
 struct perf_counter_hw_event {
-	s64			type;
+	__s64			type;
 
-	u64			irq_period;
-	u32			record_type;
+	__u64			irq_period;
+	__u32			record_type;
 
-	u32			disabled       :  1, /* off by default        */
+	__u32			disabled       :  1, /* off by default        */
 				nmi	       :  1, /* NMI sampling          */
 				raw	       :  1, /* raw event type        */
 				inherit	       :  1, /* children inherit it   */
@@ -95,7 +83,7 @@ struct perf_counter_hw_event {
 
 				__reserved_1 : 23;
 
-	u64			__reserved_2;
+	__u64			__reserved_2;
 };
 
 /*
@@ -104,10 +92,24 @@ struct perf_counter_hw_event {
 #define PERF_COUNTER_IOC_ENABLE		_IO('$', 0)
 #define PERF_COUNTER_IOC_DISABLE	_IO('$', 1)
 
+#ifdef __KERNEL__
 /*
- * Kernel-internal data types:
+ * Kernel-internal data types and definitions:
  */
 
+#ifdef CONFIG_PERF_COUNTERS
+# include <asm/perf_counter.h>
+#endif
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/rculist.h>
+#include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+#include <asm/atomic.h>
+
+struct task_struct;
+
 /**
  * struct hw_perf_counter - performance counter hardware details:
  */
@@ -293,4 +295,5 @@ static inline int perf_counter_task_disable(void)	{ return -EINVAL; }
 static inline int perf_counter_task_enable(void)	{ return -EINVAL; }
 #endif
 
+#endif /* __KERNEL__ */
 #endif /* _LINUX_PERF_COUNTER_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 88255d3..28ef2be 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -696,10 +696,7 @@ asmlinkage long sys_pipe(int __user *);
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
 
-asmlinkage int sys_perf_counter_open(
-
-	struct perf_counter_hw_event	*hw_event_uptr		__user,
-	pid_t				pid,
-	int				cpu,
-	int				group_fd);
+asmlinkage long sys_perf_counter_open(
+		const struct perf_counter_hw_event __user *hw_event_uptr,
+		pid_t pid, int cpu, int group_fd);
 #endif
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ad62965..16b14ba 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1690,9 +1690,9 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
  * @cpu:		target cpu
  * @group_fd:		group leader counter fd
  */
-asmlinkage int
-sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr __user,
-		      pid_t pid, int cpu, int group_fd)
+SYSCALL_DEFINE4(perf_counter_open,
+		const struct perf_counter_hw_event __user *, hw_event_uptr,
+		pid_t, pid, int, cpu, int, group_fd)
 {
 	struct perf_counter *counter, *group_leader;
 	struct perf_counter_hw_event hw_event;
-- 
1.5.6.3

