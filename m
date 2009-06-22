Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbZFVM67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbZFVM67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZFVM6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:58:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbZFVM6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:58:38 -0400
Date: Mon, 22 Jun 2009 08:58:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: eranian@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.1 - System calls - ioctl
Message-ID: <20090622125837.GA9429@infradead.org>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <20090622114931.GB24366@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622114931.GB24366@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 01:49:31PM +0200, Ingo Molnar wrote:
> > How do you justify your usage of ioctl() in this context?
> 
> We can certainly do a separate sys_perf_counter_ctrl() syscall - and
> we will do that if people think the extra syscall slot is worth it
> in this case.
> 
> The (mild) counter-argument so far was that the current ioctls are
> very simple over "IO" attributes of counters:
> 
>  - enable
>  - disable
>  - reset
>  - refresh
>  - set-period
> 
> So they could be considered 'IO controls' in the classic sense and
> act as a (mild) exception to the 'dont use ioctls' rule.
> 
> They are not some weird tacked-on syscall functionality - they
> modify the IO properties of counters: on/off, value and rate. If
> they go beyond that we'll put it all into a separate syscall and
> deprecate the ioctl (which will have a relatively short half-time
> due to the tools being hosted in the kernel repo).
> 
> This could happen right now in fact, if people think it's worth it.

Yet another multiplexer doesn't buy as anything over ioctls unless it
adds more structure.  PERF_COUNTER_IOC_ENABLE/PERF_COUNTER_IOC_DISABLE/
PERF_COUNTER_IOC_RESET are calls without any argument, so it's kinda
impossible to add more structure.  perf_counter_refresh has an integer
argument, and perf_counter_period aswell (with a slightly more
complicated calling convention due to passing a pointer to the 64bit
integer).  I don't see how moving this to syscalls would improve
things.

But talking about syscalls the sys_perf_counter_open prototype is
really ugly - it uses either the pid or cpu argument which is a pretty
clear indicator it should actually be two sys calls.

Incomplete patch without touching the actuall wire-up below to
demonstrate it:


Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c	2009-06-22 14:43:35.323966162 +0200
+++ linux-2.6/kernel/perf_counter.c	2009-06-22 14:57:30.223807475 +0200
@@ -1396,41 +1396,14 @@ __perf_counter_init_context(struct perf_
 	ctx->task = task;
 }
 
-static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
+static struct perf_counter_context *find_get_pid_context(pid_t pid)
 {
 	struct perf_counter_context *parent_ctx;
 	struct perf_counter_context *ctx;
-	struct perf_cpu_context *cpuctx;
 	struct task_struct *task;
 	unsigned long flags;
 	int err;
 
-	/*
-	 * If cpu is not a wildcard then this is a percpu counter:
-	 */
-	if (cpu != -1) {
-		/* Must be root to operate on a CPU counter: */
-		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
-			return ERR_PTR(-EACCES);
-
-		if (cpu < 0 || cpu > num_possible_cpus())
-			return ERR_PTR(-EINVAL);
-
-		/*
-		 * We could be clever and allow to attach a counter to an
-		 * offline CPU and activate it when the CPU comes up, but
-		 * that's for later.
-		 */
-		if (!cpu_isset(cpu, cpu_online_map))
-			return ERR_PTR(-ENODEV);
-
-		cpuctx = &per_cpu(perf_cpu_context, cpu);
-		ctx = &cpuctx->ctx;
-		get_ctx(ctx);
-
-		return ctx;
-	}
-
 	rcu_read_lock();
 	if (!pid)
 		task = current;
@@ -3727,6 +3700,16 @@ static int perf_copy_attr(struct perf_co
 	if (attr->read_format & ~(PERF_FORMAT_MAX-1))
 		return -EINVAL;
 
+	if (!attr->exclude_kernel) {
+		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
+	}
+
+	if (attr->freq) {
+		if (attr->sample_freq > sysctl_perf_counter_sample_rate)
+			return -EINVAL;
+	}
+
 out:
 	return ret;
 
@@ -3736,52 +3719,16 @@ err_size:
 	goto out;
 }
 
-/**
- * sys_perf_counter_open - open a performance counter, associate it to a task/cpu
- *
- * @attr_uptr:	event type attributes for monitoring/sampling
- * @pid:		target pid
- * @cpu:		target cpu
- * @group_fd:		group leader counter fd
- */
-SYSCALL_DEFINE5(perf_counter_open,
-		struct perf_counter_attr __user *, attr_uptr,
-		pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
+static int do_perf_counter_open(struct perf_counter_attr *attr,
+		struct perf_counter_context *ctx, int cpu, int group_fd)
 {
 	struct perf_counter *counter, *group_leader;
-	struct perf_counter_attr attr;
-	struct perf_counter_context *ctx;
 	struct file *counter_file = NULL;
 	struct file *group_file = NULL;
 	int fput_needed = 0;
 	int fput_needed2 = 0;
 	int ret;
 
-	/* for future expandability... */
-	if (flags)
-		return -EINVAL;
-
-	ret = perf_copy_attr(attr_uptr, &attr);
-	if (ret)
-		return ret;
-
-	if (!attr.exclude_kernel) {
-		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
-			return -EACCES;
-	}
-
-	if (attr.freq) {
-		if (attr.sample_freq > sysctl_perf_counter_sample_rate)
-			return -EINVAL;
-	}
-
-	/*
-	 * Get the target context (task or percpu):
-	 */
-	ctx = find_get_context(pid, cpu);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-
 	/*
 	 * Look up the group leader (we will attach this counter to it):
 	 */
@@ -3810,11 +3757,11 @@ SYSCALL_DEFINE5(perf_counter_open,
 		/*
 		 * Only a group leader can be exclusive or pinned
 		 */
-		if (attr.exclusive || attr.pinned)
+		if (attr->exclusive || attr->pinned)
 			goto err_put_context;
 	}
 
-	counter = perf_counter_alloc(&attr, cpu, ctx, group_leader,
+	counter = perf_counter_alloc(attr, cpu, ctx, group_leader,
 				     GFP_KERNEL);
 	ret = PTR_ERR(counter);
 	if (IS_ERR(counter))
@@ -3857,6 +3804,68 @@ err_put_context:
 	goto out_fput;
 }
 
+SYSCALL_DEFINE4(perf_counter_open_pid,
+		struct perf_counter_attr __user *, attr_uptr,
+		pid_t, pid, int, group_fd, unsigned long, flags)
+{
+	struct perf_counter_attr attr;
+	struct perf_counter_context *ctx;
+	int ret;
+
+	/* for future expandability... */
+	if (flags)
+		return -EINVAL;
+
+	ret = perf_copy_attr(attr_uptr, &attr);
+	if (ret)
+		return ret;
+
+	ctx = find_get_pid_context(pid);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	return do_perf_counter_open(&attr, ctx, -1, group_fd);
+}
+
+SYSCALL_DEFINE4(perf_counter_open_cpu,
+		struct perf_counter_attr __user *, attr_uptr,
+		int, cpu, int, group_fd, unsigned long, flags)
+{
+	struct perf_counter_attr attr;
+	struct perf_counter_context *ctx;
+	struct perf_cpu_context *cpuctx;
+	int ret;
+
+	/* for future expandability... */
+	if (flags)
+		return -EINVAL;
+
+	ret = perf_copy_attr(attr_uptr, &attr);
+	if (ret)
+		return ret;
+
+	/* Must be root to operate on a CPU counter: */
+	if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (cpu < 0 || cpu > num_possible_cpus())
+		return -EINVAL;
+
+	/*
+	 * We could be clever and allow to attach a counter to an
+	 * offline CPU and activate it when the CPU comes up, but
+	 * that's for later.
+	 */
+	if (!cpu_isset(cpu, cpu_online_map))
+		return -ENODEV;
+
+	cpuctx = &per_cpu(perf_cpu_context, cpu);
+	ctx = &cpuctx->ctx;
+	get_ctx(ctx);
+
+	return do_perf_counter_open(&attr, ctx, cpu, group_fd);
+}
+
 /*
  * inherit a counter from parent task to child task:
  */
@@ -4027,7 +4036,7 @@ void perf_counter_exit_task(struct task_
 	__perf_counter_task_sched_out(child_ctx);
 
 	/*
-	 * Take the context lock here so that if find_get_context is
+	 * Take the context lock here so that if find_get_pid_context is
 	 * reading child->perf_counter_ctxp, we wait until it has
 	 * incremented the context's refcount before we do put_ctx below.
 	 */

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
