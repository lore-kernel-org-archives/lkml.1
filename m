Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbZHYHlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbZHYHlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZHYHlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:41:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:44940 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbZHYHlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:41:21 -0400
Date: Tue, 25 Aug 2009 07:39:38 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090819092023.980284148@chello.nl>
References: <20090819092023.980284148@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf_counter: Allow sharing of output channels
Message-ID: <tip-a4be7c2778d1fd8e0a8a5607bec91fa221ab2c91@git.kernel.org>
Git-Commit-ID: a4be7c2778d1fd8e0a8a5607bec91fa221ab2c91
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 25 Aug 2009 07:39:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4be7c2778d1fd8e0a8a5607bec91fa221ab2c91
Gitweb:     http://git.kernel.org/tip/a4be7c2778d1fd8e0a8a5607bec91fa221ab2c91
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 19 Aug 2009 11:18:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 25 Aug 2009 09:36:13 +0200

perf_counter: Allow sharing of output channels

Provide the ability to configure a counter to send its output
to another (already existing) counter's output stream.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090819092023.980284148@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    5 +++
 kernel/perf_counter.c        |   83 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index b53f700..e022b84 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -216,6 +216,7 @@ struct perf_counter_attr {
 #define PERF_COUNTER_IOC_REFRESH	_IO ('$', 2)
 #define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
 #define PERF_COUNTER_IOC_PERIOD		_IOW('$', 4, u64)
+#define PERF_COUNTER_IOC_SET_OUTPUT	_IO ('$', 5)
 
 enum perf_counter_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
@@ -415,6 +416,9 @@ enum perf_callchain_context {
 	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
+#define PERF_FLAG_FD_NO_GROUP	(1U << 0)
+#define PERF_FLAG_FD_OUTPUT	(1U << 1)
+
 #ifdef __KERNEL__
 /*
  * Kernel-internal data types and definitions:
@@ -536,6 +540,7 @@ struct perf_counter {
 	struct list_head		sibling_list;
 	int				nr_siblings;
 	struct perf_counter		*group_leader;
+	struct perf_counter		*output;
 	const struct pmu		*pmu;
 
 	enum perf_counter_active_state	state;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 06bf6a4..53abcbe 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1692,6 +1692,11 @@ static void free_counter(struct perf_counter *counter)
 			atomic_dec(&nr_task_counters);
 	}
 
+	if (counter->output) {
+		fput(counter->output->filp);
+		counter->output = NULL;
+	}
+
 	if (counter->destroy)
 		counter->destroy(counter);
 
@@ -1977,6 +1982,8 @@ unlock:
 	return ret;
 }
 
+int perf_counter_set_output(struct perf_counter *counter, int output_fd);
+
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct perf_counter *counter = file->private_data;
@@ -2000,6 +2007,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_COUNTER_IOC_PERIOD:
 		return perf_counter_period(counter, (u64 __user *)arg);
 
+	case PERF_COUNTER_IOC_SET_OUTPUT:
+		return perf_counter_set_output(counter, arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -2270,6 +2280,11 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 	WARN_ON_ONCE(counter->ctx->parent_ctx);
 	mutex_lock(&counter->mmap_mutex);
+	if (counter->output) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
 	if (atomic_inc_not_zero(&counter->mmap_count)) {
 		if (nr_pages != counter->data->nr_pages)
 			ret = -EINVAL;
@@ -2655,6 +2670,7 @@ static int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_counter *counter, unsigned int size,
 			     int nmi, int sample)
 {
+	struct perf_counter *output_counter;
 	struct perf_mmap_data *data;
 	unsigned int offset, head;
 	int have_lost;
@@ -2664,13 +2680,17 @@ static int perf_output_begin(struct perf_output_handle *handle,
 		u64			 lost;
 	} lost_event;
 
+	rcu_read_lock();
 	/*
 	 * For inherited counters we send all the output towards the parent.
 	 */
 	if (counter->parent)
 		counter = counter->parent;
 
-	rcu_read_lock();
+	output_counter = rcu_dereference(counter->output);
+	if (output_counter)
+		counter = output_counter;
+
 	data = rcu_dereference(counter->data);
 	if (!data)
 		goto out;
@@ -4218,6 +4238,57 @@ err_size:
 	goto out;
 }
 
+int perf_counter_set_output(struct perf_counter *counter, int output_fd)
+{
+	struct perf_counter *output_counter = NULL;
+	struct file *output_file = NULL;
+	struct perf_counter *old_output;
+	int fput_needed = 0;
+	int ret = -EINVAL;
+
+	if (!output_fd)
+		goto set;
+
+	output_file = fget_light(output_fd, &fput_needed);
+	if (!output_file)
+		return -EBADF;
+
+	if (output_file->f_op != &perf_fops)
+		goto out;
+
+	output_counter = output_file->private_data;
+
+	/* Don't chain output fds */
+	if (output_counter->output)
+		goto out;
+
+	/* Don't set an output fd when we already have an output channel */
+	if (counter->data)
+		goto out;
+
+	atomic_long_inc(&output_file->f_count);
+
+set:
+	mutex_lock(&counter->mmap_mutex);
+	old_output = counter->output;
+	rcu_assign_pointer(counter->output, output_counter);
+	mutex_unlock(&counter->mmap_mutex);
+
+	if (old_output) {
+		/*
+		 * we need to make sure no existing perf_output_*()
+		 * is still referencing this counter.
+		 */
+		synchronize_rcu();
+		fput(old_output->filp);
+	}
+
+	ret = 0;
+out:
+	fput_light(output_file, fput_needed);
+	return ret;
+}
+
 /**
  * sys_perf_counter_open - open a performance counter, associate it to a task/cpu
  *
@@ -4240,7 +4311,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 	int ret;
 
 	/* for future expandability... */
-	if (flags)
+	if (flags & ~(PERF_FLAG_FD_NO_GROUP | PERF_FLAG_FD_OUTPUT))
 		return -EINVAL;
 
 	ret = perf_copy_attr(attr_uptr, &attr);
@@ -4268,7 +4339,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 	 * Look up the group leader (we will attach this counter to it):
 	 */
 	group_leader = NULL;
-	if (group_fd != -1) {
+	if (group_fd != -1 && !(flags & PERF_FLAG_FD_NO_GROUP)) {
 		ret = -EINVAL;
 		group_file = fget_light(group_fd, &fput_needed);
 		if (!group_file)
@@ -4310,6 +4381,12 @@ SYSCALL_DEFINE5(perf_counter_open,
 	if (!counter_file)
 		goto err_free_put_context;
 
+	if (flags & PERF_FLAG_FD_OUTPUT) {
+		ret = perf_counter_set_output(counter, group_fd);
+		if (ret)
+			goto err_free_put_context;
+	}
+
 	counter->filp = counter_file;
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
