Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbZFLMoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbZFLMoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbZFLMnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:43:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:52578 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758642AbZFLMnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:43:47 -0400
Date: Fri, 12 Jun 2009 12:43:15 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Add forward/backward attribute ABI compatibility
Message-ID: <tip-974802eaa1afdc87e00821df7020a2b3c6fee623@git.kernel.org>
Git-Commit-ID: 974802eaa1afdc87e00821df7020a2b3c6fee623
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Jun 2009 12:43:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  974802eaa1afdc87e00821df7020a2b3c6fee623
Gitweb:     http://git.kernel.org/tip/974802eaa1afdc87e00821df7020a2b3c6fee623
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 12 Jun 2009 12:46:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 12 Jun 2009 14:28:52 +0200

perf_counter: Add forward/backward attribute ABI compatibility

Provide for means of extending the perf_counter_attr in a 'natural' way.

We allow growing the structure by appending fields at the end by specifying
the full structure size inside it.

When a new kernel sees a smaller (old) structure, it will 0 pad the tail.
When an old kernel sees a larger (new) structure, it will verify the tail
consists of 0s, otherwise fail.

If we fail due to a size-mismatch, we return -E2BIG and write the kernel's
native attribe size back into the provided structure.

Furthermore, add some attribute verification, so that we'll fail counter
creation when unknown bits are present (PERF_SAMPLE, PERF_FORMAT, or in
the __reserved fields).

(This ABI detail is introduced while keeping the existing syscall ABI.)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   19 +++++++--
 include/linux/syscalls.h     |    2 +-
 kernel/perf_counter.c        |   89 ++++++++++++++++++++++++++++++++++++++++-
 tools/perf/perf.h            |    5 +-
 4 files changed, 105 insertions(+), 10 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 7c4f32f..1b3118a 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -120,6 +120,8 @@ enum perf_counter_sample_format {
 	PERF_SAMPLE_ID				= 1U << 6,
 	PERF_SAMPLE_CPU				= 1U << 7,
 	PERF_SAMPLE_PERIOD			= 1U << 8,
+
+	PERF_SAMPLE_MAX = 1U << 9,		/* non-ABI */
 };
 
 /*
@@ -131,17 +133,26 @@ enum perf_counter_read_format {
 	PERF_FORMAT_TOTAL_TIME_ENABLED		= 1U << 0,
 	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
 	PERF_FORMAT_ID				= 1U << 2,
+
+	PERF_FORMAT_MAX = 1U << 3, 		/* non-ABI */
 };
 
+#define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
+
 /*
  * Hardware event to monitor via a performance monitoring counter:
  */
 struct perf_counter_attr {
+
 	/*
 	 * Major type: hardware/software/tracepoint/etc.
 	 */
 	__u32			type;
-	__u32			__reserved_1;
+
+	/*
+	 * Size of the attr structure, for fwd/bwd compat.
+	 */
+	__u32			size;
 
 	/*
 	 * Type specific configuration information.
@@ -168,12 +179,12 @@ struct perf_counter_attr {
 				comm	       :  1, /* include comm data     */
 				freq           :  1, /* use freq, not period  */
 
-				__reserved_2   : 53;
+				__reserved_1   : 53;
 
 	__u32			wakeup_events;	/* wakeup every n events */
-	__u32			__reserved_3;
+	__u32			__reserved_2;
 
-	__u64			__reserved_4;
+	__u64			__reserved_3;
 };
 
 /*
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index c6c84ad..418d90f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -758,6 +758,6 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
 
 asmlinkage long sys_perf_counter_open(
-		const struct perf_counter_attr __user *attr_uptr,
+		struct perf_counter_attr __user *attr_uptr,
 		pid_t pid, int cpu, int group_fd, unsigned long flags);
 #endif
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 663bbe0..29b685f 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3584,6 +3584,9 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	case PERF_TYPE_TRACEPOINT:
 		pmu = tp_perf_counter_init(counter);
 		break;
+
+	default:
+		break;
 	}
 done:
 	err = 0;
@@ -3610,6 +3613,85 @@ done:
 	return counter;
 }
 
+static int perf_copy_attr(struct perf_counter_attr __user *uattr,
+			  struct perf_counter_attr *attr)
+{
+	int ret;
+	u32 size;
+
+	if (!access_ok(VERIFY_WRITE, uattr, PERF_ATTR_SIZE_VER0))
+		return -EFAULT;
+
+	/*
+	 * zero the full structure, so that a short copy will be nice.
+	 */
+	memset(attr, 0, sizeof(*attr));
+
+	ret = get_user(size, &uattr->size);
+	if (ret)
+		return ret;
+
+	if (size > PAGE_SIZE)	/* silly large */
+		goto err_size;
+
+	if (!size)		/* abi compat */
+		size = PERF_ATTR_SIZE_VER0;
+
+	if (size < PERF_ATTR_SIZE_VER0)
+		goto err_size;
+
+	/*
+	 * If we're handed a bigger struct than we know of,
+	 * ensure all the unknown bits are 0.
+	 */
+	if (size > sizeof(*attr)) {
+		unsigned long val;
+		unsigned long __user *addr;
+		unsigned long __user *end;
+
+		addr = PTR_ALIGN((void __user *)uattr + sizeof(*attr),
+				sizeof(unsigned long));
+		end  = PTR_ALIGN((void __user *)uattr + size,
+				sizeof(unsigned long));
+
+		for (; addr < end; addr += sizeof(unsigned long)) {
+			ret = get_user(val, addr);
+			if (ret)
+				return ret;
+			if (val)
+				goto err_size;
+		}
+	}
+
+	ret = copy_from_user(attr, uattr, size);
+	if (ret)
+		return -EFAULT;
+
+	/*
+	 * If the type exists, the corresponding creation will verify
+	 * the attr->config.
+	 */
+	if (attr->type >= PERF_TYPE_MAX)
+		return -EINVAL;
+
+	if (attr->__reserved_1 || attr->__reserved_2 || attr->__reserved_3)
+		return -EINVAL;
+
+	if (attr->sample_type & ~(PERF_SAMPLE_MAX-1))
+		return -EINVAL;
+
+	if (attr->read_format & ~(PERF_FORMAT_MAX-1))
+		return -EINVAL;
+
+out:
+	return ret;
+
+err_size:
+	put_user(sizeof(*attr), &uattr->size);
+	ret = -E2BIG;
+	goto out;
+}
+
 /**
  * sys_perf_counter_open - open a performance counter, associate it to a task/cpu
  *
@@ -3619,7 +3701,7 @@ done:
  * @group_fd:		group leader counter fd
  */
 SYSCALL_DEFINE5(perf_counter_open,
-		const struct perf_counter_attr __user *, attr_uptr,
+		struct perf_counter_attr __user *, attr_uptr,
 		pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
 {
 	struct perf_counter *counter, *group_leader;
@@ -3635,8 +3717,9 @@ SYSCALL_DEFINE5(perf_counter_open,
 	if (flags)
 		return -EINVAL;
 
-	if (copy_from_user(&attr, attr_uptr, sizeof(attr)) != 0)
-		return -EFAULT;
+	ret = perf_copy_attr(attr_uptr, &attr);
+	if (ret)
+		return ret;
 
 	if (!attr.exclude_kernel) {
 		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index af0a504..87a1aca 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -53,11 +53,12 @@ static inline unsigned long long rdclock(void)
 	_min1 < _min2 ? _min1 : _min2; })
 
 static inline int
-sys_perf_counter_open(struct perf_counter_attr *attr_uptr,
+sys_perf_counter_open(struct perf_counter_attr *attr,
 		      pid_t pid, int cpu, int group_fd,
 		      unsigned long flags)
 {
-	return syscall(__NR_perf_counter_open, attr_uptr, pid, cpu,
+	attr->size = sizeof(*attr);
+	return syscall(__NR_perf_counter_open, attr, pid, cpu,
 		       group_fd, flags);
 }
 
