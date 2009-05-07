Return-Path: <linux-kernel-owner+w=401wt.eu-S1762329AbZEGVtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbZEGVtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZEGVsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:48:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:51086 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZEGVsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:48:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:cc:subject:mime-version:
	content-type:content-transfer-encoding:x-system-of-record;
	b=bsN4/cR0fEHQpTeqofW4uiq8YCnRlM97zAS7q3OOycXmWBHu+OyLXI+1ALrkPNqMZ
	A/f7AUZvo5ytBsjMg75OA==
Message-ID: <396556a20805301217k293e5718h6bbf02b234897235@europa>
Date: Thu, 7 May 2009 14:48:27 -0700
From: "Adam Langley" <agl@google.com>
To: linux-kernel@vger.kernel.org
Cc: markus@google.com
Subject: [RFC 1/1] seccomp: Add bitmask of allowed system calls.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is a discussion email rather than a patch which I'm seriously
proposing be landed.)

In a recent thread[1] my colleague, Markus, mentioned that we (Chrome
Linux) are investigating using seccomp to implement our rendering
sandbox[2] on Linux.

In the same thread, Ingo mentioned[3] that he thought a bitmap of
allowed system calls would be reasonable. If we had such a thing, many
of the acrobatics that we currently need could be avoided. Since we need
to support the currently existing kernels, we'll need to have the code
for both, but allowing signal handling, gettimeofday, epoll etc would
save a lot of overhead for common operations.

The patch below implements such a scheme. It's written on top of the
current seccomp for the moment, although it looks like seccomp might be
written in terms of ftrace soon[4].

Briefly, it adds a second seccomp mode (2) where one uploads a bitmask.
Syscall n is allowed if, and only if, bit n is true in the bitmask. If n
is beyond the range of the bitmask, the syscall is denied.

If prctl is allowed by the bitmask, then a process may switch to mode 1,
or may set a new bitmask iff the new bitmask is a subset of the current
one. (Possibly moving to mode 1 should only be allowed if read, write,
sigreturn, exit are in the currently allowed set.)

If a process forks/clones, the child inherits the seccomp state of the
parent. (And hopefully I'm managing the memory correctly here.)


Ingo subsequently floated the idea of a more expressive interface based
on ftrace which could introspect the arguments, although I think the
discussion had fallen off list at that point.

He suggested using an ftrace parser which I'm not familiar with, but can
be summed up with:
  seccomp_prctl("sys_write", "fd == 3")  // allow writes only to fd 3

In general, I believe that ftrace based solutions cannot safely validate
arguments which are in user-space memory when multiple threads could be
racing to change the memory between ftrace and the eventual
copy_from_user. Because of this, many useful arguments (such as the
sockaddr to connect, the filename to open etc) are out of reach. LSM
hooks appear to be the best way to impose limits in such cases. (Which
we are also experimenting with).

However, such a parser could be very useful in one particular case:
socketcall on IA32. Allowing recvmsg and sendmsg, but not socket,
connect etc is certainly something that we would be interested in.

In summary: we would like to see a more flexible seccomp and, if people
agree, we're willing to do work to make it so.

Thanks,

AGL


[1] http://lkml.org/lkml/2009/5/6/443
[2] http://dev.chromium.org/developers/design-documents/sandbox
[3] http://lkml.org/lkml/2009/5/7/137
[4] http://lkml.org/lkml/2009/3/31/412

Signed-off-by: Adam Langley <agl@google.com>

---

 fs/proc/array.c         |   21 +++++++
 include/linux/prctl.h   |    3 +
 include/linux/seccomp.h |   24 +++++++-
 kernel/fork.c           |   15 +++++
 kernel/seccomp.c        |  151 +++++++++++++++++++++++++++++++++++++++++------
 kernel/sys.c            |    2 +-
 6 files changed, 194 insertions(+), 22 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 167c333..ce5620a 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -7,7 +7,23 @@
 #include <linux/thread_info.h>
 #include <asm/seccomp.h>
 
-typedef struct { int mode; } seccomp_t;
+/**
+ * struct seccomp_state - the state of a seccomp'ed process
+ *
+ * @mode:
+ *     if this is 1, the process is under standard seccomp rules
+ *             is 2, the process is only allowed to make system calls where
+ *                   the corresponding bit is set in bitmask.
+ * @bit_length: the length of bitmask, in bits.
+ * @bitmask: a mask of allowed system calls.
+ */
+struct seccomp_state {
+	uint16_t mode;
+	uint16_t bit_length;
+	uint8_t bitmask[0];
+};
+
+typedef struct { struct seccomp_state *state; } seccomp_t;
 
 extern void __secure_computing(int);
 static inline void secure_computing(int this_syscall)
@@ -16,8 +32,9 @@ static inline void secure_computing(int this_syscall)
 		__secure_computing(this_syscall);
 }
 
+extern struct seccomp_state* seccomp_state_dup(const struct seccomp_state *old);
 extern long prctl_get_seccomp(void);
-extern long prctl_set_seccomp(unsigned long);
+extern long prctl_set_seccomp(unsigned long, unsigned long, unsigned long);
 
 #else /* CONFIG_SECCOMP */
 
@@ -32,7 +49,8 @@ static inline long prctl_get_seccomp(void)
 	return -EINVAL;
 }
 
-static inline long prctl_set_seccomp(unsigned long arg2)
+static inline long prctl_set_seccomp(unsigned long arg2, unsigned long arg3,
+				     unsigned long arg4)
 {
 	return -EINVAL;
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index b9e2edd..1f599ec 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -35,6 +35,7 @@
 #include <linux/cgroup.h>
 #include <linux/security.h>
 #include <linux/hugetlb.h>
+#include <linux/seccomp.h>
 #include <linux/swap.h>
 #include <linux/syscalls.h>
 #include <linux/jiffies.h>
@@ -143,6 +144,10 @@ void free_task(struct task_struct *tsk)
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
+#ifdef CONFIG_SECCOMP
+	if (tsk->seccomp.state)
+		kfree(tsk->seccomp.state);
+#endif
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -240,6 +245,16 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	if (err)
 		goto out;
 
+#ifdef CONFIG_SECCOMP
+	if (orig->seccomp.state) {
+		tsk->seccomp.state = seccomp_state_dup(orig->seccomp.state);
+		if (!tsk->seccomp.state) {
+			err = ENOMEM;
+			goto out;
+		}
+	}
+#endif
+
 	setup_thread_stack(tsk, orig);
 	stackend = end_of_stack(tsk);
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 57d4b13..3fcf658 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -9,9 +9,10 @@
 #include <linux/seccomp.h>
 #include <linux/sched.h>
 #include <linux/compat.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
 
 /* #define SECCOMP_DEBUG 1 */
-#define NR_SECCOMP_MODES 1
 
 /*
  * Secure computing mode 1 allows only read/write/exit/sigreturn.
@@ -32,8 +33,8 @@ static int mode1_syscalls_32[] = {
 
 void __secure_computing(int this_syscall)
 {
-	int mode = current->seccomp.mode;
-	int * syscall;
+	int mode = current->seccomp.state->mode;
+	int *syscall;
 
 	switch (mode) {
 	case 1:
@@ -47,6 +48,13 @@ void __secure_computing(int this_syscall)
 				return;
 		} while (*++syscall);
 		break;
+	case 2:
+		if (this_syscall >= current->seccomp.state->bit_length)
+			break;
+		if (current->seccomp.state->bitmask[this_syscall / 8] &
+		    (1 << (7 - (this_syscall % 8))))
+			return;
+		break;
 	default:
 		BUG();
 	}
@@ -57,30 +65,135 @@ void __secure_computing(int this_syscall)
 	do_exit(SIGKILL);
 }
 
-long prctl_get_seccomp(void)
+/**
+ * seccomp_mask_install() - install a system call mask
+ * @seccomp_bitlength: the number of bits in the mask
+ * @seccomp_mask: a pointer in userspace to the bits
+ *
+ * This is used to install a system call mask when none currently exists.
+ */
+static int seccomp_mask_install(unsigned long seccomp_mask,
+				unsigned long seccomp_bitlength)
 {
-	return current->seccomp.mode;
+	if (seccomp_bitlength >= 1024)
+		return -EINVAL;
+	current->seccomp.state = kmalloc(sizeof(struct seccomp_state) +
+					 (seccomp_bitlength + 7) / 8,
+					 GFP_KERNEL);
+	if (!current->seccomp.state)
+		return -ENOMEM;
+	current->seccomp.state->mode = 2;
+	current->seccomp.state->bit_length = seccomp_bitlength;
+	if (copy_from_user(current->seccomp.state->bitmask,
+			   (void __user *) seccomp_mask,
+			   (seccomp_bitlength + 7) / 8)) {
+		kfree(current->seccomp.state);
+		current->seccomp.state = NULL;
+		return -EFAULT;
+	}
+
+	set_thread_flag(TIF_SECCOMP);
+	return 0;
 }
 
-long prctl_set_seccomp(unsigned long seccomp_mode)
+/**
+ * seccomp_mask_subset() - subset a system call mask
+ * @seccomp_bitlength: the number of bits in the mask
+ * @seccomp_mask: a pointer in userspace to the bits
+ *
+ * This is used when a process which already has a system call mask tries to
+ * install another. We require that the new mask be <= to the length of the old
+ * one and that it's a subset of the old mask.
+ */
+static int seccomp_mask_subset(unsigned long seccomp_mask,
+			       unsigned long seccomp_bitlength)
 {
-	long ret;
+	unsigned i;
+	const unsigned byte_length = (seccomp_bitlength + 7) / 8;
+	const uint8_t *current_mask = current->seccomp.state->bitmask;
+	struct seccomp_state *new;
 
-	/* can set it only once to be even more secure */
-	ret = -EPERM;
-	if (unlikely(current->seccomp.mode))
-		goto out;
+	if (seccomp_bitlength > current->seccomp.state->bit_length)
+		return -EPERM;
+	new = kmalloc(sizeof(struct seccomp_state) + byte_length, GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+	new->mode = 2;
+	new->bit_length = seccomp_bitlength;
+	if (copy_from_user(new->bitmask,
+			   (void __user *) seccomp_mask,
+			   byte_length)) {
+		kfree(new);
+		return -EFAULT;
+	}
+
+	for (i = 0; i < byte_length; ++i) {
+		if ((new->bitmask[i] & current_mask[i]) != new->bitmask[i]) {
+			kfree(new);
+			return -EPERM;
+		}
+	}
+
+	kfree(current->seccomp.state);
+	current->seccomp.state = new;
+
+	return 0;
+}
+
+struct seccomp_state* seccomp_state_dup(const struct seccomp_state *orig)
+{
+	const unsigned state_len = sizeof(struct seccomp_state) +
+				   (orig->bit_length + 7) / 8;
+	struct seccomp_state *new = kmalloc(state_len, GFP_KERNEL);
+	if (!new)
+		return NULL;
 
-	ret = -EINVAL;
-	if (seccomp_mode && seccomp_mode <= NR_SECCOMP_MODES) {
-		current->seccomp.mode = seccomp_mode;
+	memcpy(new, orig, state_len);
+	return new;
+}
+
+
+long prctl_get_seccomp(void)
+{
+	if (!current->seccomp.state)
+		return 0;
+	return current->seccomp.state->mode;
+}
+
+long prctl_set_seccomp(unsigned long seccomp_mode,
+		       unsigned long seccomp_mask,
+		       unsigned long seccomp_bitlength)
+{
+	switch (seccomp_mode) {
+	case 0:
+		/* One cannot switch to mode 0 from any other mode */
+		if (current->seccomp.state)
+			return -EPERM;
+		return 0;
+
+	case 1:
+		if (current->seccomp.state)
+			kfree(current->seccomp.state);
+		current->seccomp.state = kmalloc(sizeof(struct seccomp_state),
+						 GFP_KERNEL);
+		if (!current->seccomp.state)
+			return -ENOMEM;
+		current->seccomp.state->mode = 1;
+		current->seccomp.state->bit_length = 0;
 		set_thread_flag(TIF_SECCOMP);
 #ifdef TIF_NOTSC
 		disable_TSC();
 #endif
-		ret = 0;
-	}
+		return 0;
+
+	case 2:
+		/* System call bitmask */
 
- out:
-	return ret;
+		if (current->seccomp.state)
+			return seccomp_mask_subset(seccomp_mask, seccomp_bitlength);
+		return seccomp_mask_install(seccomp_mask, seccomp_bitlength);
+
+	default:
+		return -EINVAL;
+	}
 }
diff --git a/kernel/sys.c b/kernel/sys.c
index e7998cf..bf50553 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1785,7 +1785,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			error = prctl_get_seccomp();
 			break;
 		case PR_SET_SECCOMP:
-			error = prctl_set_seccomp(arg2);
+			error = prctl_set_seccomp(arg2, arg3, arg4);
 			break;
 		case PR_GET_TSC:
 			error = GET_TSC_CTL(arg2);
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 725a650..840442b 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -321,6 +321,26 @@ static inline void task_context_switch_counts(struct seq_file *m,
 			p->nivcsw);
 }
 
+extern const char hex_asc[];
+
+static void task_show_seccomp(struct seq_file *m, struct task_struct *p) {
+#if defined(CONFIG_SECCOMP)
+	const int mode = p->seccomp.state ? p->seccomp.state->mode : 0;
+	unsigned i;
+
+	seq_printf(m, "Seccomp:\t%d\n", mode);
+	if (mode != 2)
+		return;
+	seq_printf(m, "Seccomp_mask:\t%d,", p->seccomp.state->bit_length);
+	for (i = 0; i < (p->seccomp.state->bit_length + 7) / 8; ++i) {
+		const uint8_t *mask = p->seccomp.state->bitmask;
+		seq_printf(m, "%c%c", hex_asc[mask[i] >> 4],
+		           hex_asc[mask[i] & 15]);
+	}
+	seq_printf(m, "\n");
+#endif
+}
+
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
@@ -340,6 +360,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	task_show_regs(m, task);
 #endif
 	task_context_switch_counts(m, task);
+	task_show_seccomp(m, task);
 	return 0;
 }
 
