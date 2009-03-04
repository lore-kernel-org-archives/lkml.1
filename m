Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbZCDJk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbZCDJk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbZCDJkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:40:47 -0500
Received: from bilbo.ozlabs.org ([203.10.76.25]:56539 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbZCDJkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:40:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18862.19599.929591.3109@cargo.ozlabs.ibm.com>
Date: Wed, 4 Mar 2009 20:40:31 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] perfcounters: provide expansion room in the ABI
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: ABI change

This expands several fields in the perf_counter_hw_event struct and adds
a "flags" argument to the perf_counter_open system call, in order that
features can be added in future without ABI changes.

In particular the record_type field is expanded to 64 bits, and the
space for flag bits has been expanded from 32 to 64 bits.

This also adds some new fields:

* read_format (64 bits) is intended to provide a way to specify what
  userspace wants to get back when it does a read() on a simple
  (non-interrupting) counter;

* exclude_idle (1 bit) provides a way for userspace to ask that events
  that occur when the cpu is idle be excluded;

* extra_config_len will provide a way for userspace to supply an
  arbitrary amount of extra machine-specific PMU configuration data
  immediately following the perf_counter_hw_event struct, to allow
  sophisticated users to program things such as instruction matching
  CAMs and address range registers;

* __reserved_3 and __reserved_4 provide space for future expansion.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This should provide plenty of room for future expansion, in fact maybe
it's a little over the top.

Ingo, if this looks OK, you can pull it from the rfc branch of my
perfcounters.git tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git rfc

 include/linux/perf_counter.h |   12 +++++++++---
 include/linux/syscalls.h     |    2 +-
 kernel/perf_counter.c        |   10 +++++++---
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 186efaf..c42455a 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -69,9 +69,10 @@ struct perf_counter_hw_event {
 	__s64			type;
 
 	__u64			irq_period;
-	__u32			record_type;
+	__u64			record_type;
+	__u64			read_format;
 
-	__u32			disabled       :  1, /* off by default        */
+	__u64			disabled       :  1, /* off by default        */
 				nmi	       :  1, /* NMI sampling          */
 				raw	       :  1, /* raw event type        */
 				inherit	       :  1, /* children inherit it   */
@@ -80,10 +81,15 @@ struct perf_counter_hw_event {
 				exclude_user   :  1, /* don't count user      */
 				exclude_kernel :  1, /* ditto kernel          */
 				exclude_hv     :  1, /* ditto hypervisor      */
+				exclude_idle   :  1, /* don't count when idle */
 
-				__reserved_1 : 23;
+				__reserved_1 : 55;
+
+	__u32			extra_config_len;
+	__u32			__reserved_4;
 
 	__u64			__reserved_2;
+	__u64			__reserved_3;
 };
 
 /*
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 28ef2be..ab1d772 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -698,5 +698,5 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
 asmlinkage long sys_perf_counter_open(
 		const struct perf_counter_hw_event __user *hw_event_uptr,
-		pid_t pid, int cpu, int group_fd);
+		pid_t pid, int cpu, int group_fd, unsigned long flags);
 #endif
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 16b14ba..b2e8389 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1683,16 +1683,16 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 }
 
 /**
- * sys_perf_task_open - open a performance counter, associate it to a task/cpu
+ * sys_perf_counter_open - open a performance counter, associate it to a task/cpu
  *
  * @hw_event_uptr:	event type attributes for monitoring/sampling
  * @pid:		target pid
  * @cpu:		target cpu
  * @group_fd:		group leader counter fd
  */
-SYSCALL_DEFINE4(perf_counter_open,
+SYSCALL_DEFINE5(perf_counter_open,
 		const struct perf_counter_hw_event __user *, hw_event_uptr,
-		pid_t, pid, int, cpu, int, group_fd)
+		pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
 {
 	struct perf_counter *counter, *group_leader;
 	struct perf_counter_hw_event hw_event;
@@ -1703,6 +1703,10 @@ SYSCALL_DEFINE4(perf_counter_open,
 	int fput_needed2 = 0;
 	int ret;
 
+	/* for future expandability... */
+	if (flags)
+		return -EINVAL;
+
 	if (copy_from_user(&hw_event, hw_event_uptr, sizeof(hw_event)) != 0)
 		return -EFAULT;
 
-- 
1.5.6.3

