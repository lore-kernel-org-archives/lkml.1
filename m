Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbZBYGTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbZBYGTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 01:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbZBYGTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 01:19:05 -0500
Received: from mail-ew0-f164.google.com ([209.85.219.164]:64969 "EHLO
	mail-ew0-f164.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbZBYGS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 01:18:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=HDXKyVzvJlMCu0VUeU+Xs0SunS2wqShLplktUwU/uNqAvHRo6hQAaOmAPBxo+duN/3
         +pQwHjy7jZJPMYidxr3BTsC1OPZy3cOIWIXSC7TnqKcHeBZy0woImaXAcU4wjmbfcPGK
         1HvMepLnIWZ6PIaE+d4eAMgt2kUWLhSUJJvRI=
Message-ID: <49a4e2cf.0a1ad00a.4273.ffffae5b@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Date: Wed, 25 Feb 2009 06:13:16 +0100
Subject: [PATCH 2/2] tracing/core: make the read callbacks reentrants
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that several per-cpu files can be read or spliced at the same, we
want the read/splice callbacks for tracing files to be reentrants.

Until now, a single global mutex (trace_types_lock) serialized the
access to tracing_read_pipe(), tracing_splice_read_pipe(), and the
seq helpers.

Ie: it means that if a user tries to read trace_pipe0 and trace_pipe1 at the
same time, the access to the function tracing_read_pipe() is contended and one
reader must wait for the other to finish its read call.

The trace_type_lock mutex is mostly here to serialize the access to the global
current tracer (current_trace), which can be changed concurrently. Although the
iter struct keeps a private pointer to this tracer, its callbacks can be changed
by another function.

The method used here is to not keep anymore private reference to the tracer
inside the iterator but to make a copy of it inside the iterator. Then it checks
on subsequents read calls if the tracer has changed. This is not costly because
the current tracer is not expected to be changed often, so we use a branch
prediction for that.

Moreover, we add a private mutex to the iterator (there is one iterator per file
descriptor) to serialize the accesses in case of multiple consumers per file
descriptor (which would be a silly idea from the user). Note that this is not
to protect the ring buffer, since the ring buffer already serializes the readers
accesses.
This is to prevent from traces weirdness in case of concurrent consumers.
But these mutexes can be dropped anyway, that would not result in any crash.
Just tell me what you think about it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   98 ++++++++++++++++++++++++++++++++++++++++---------
 kernel/trace/trace.h |    3 +-
 2 files changed, 82 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 48cb5f4..832e352 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1293,20 +1293,32 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 	return ent;
 }
 
+/*
+ * No necessary locking here. The worst thing which can
+ * happen is loosing events consumed at the same time
+ * by a trace_pipe reader.
+ * Other than that, we don't risk to crash the ring buffer
+ * because it serializes the readers.
+ *
+ * The current tracer is copied to avoid a global locking
+ * all around.
+ */
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
 	struct trace_iterator *iter = m->private;
+	static struct tracer *old_tracer;
 	int cpu_file = iter->cpu_file;
 	void *p = NULL;
 	loff_t l = 0;
 	int cpu;
 
+	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-
-	if (!current_trace || current_trace != iter->trace) {
-		mutex_unlock(&trace_types_lock);
-		return NULL;
+	if (unlikely(old_tracer != current_trace && current_trace)) {
+		old_tracer = current_trace;
+		*iter->trace = *current_trace;
 	}
+	mutex_unlock(&trace_types_lock);
 
 	atomic_inc(&trace_record_cmdline_disabled);
 
@@ -1340,7 +1352,6 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 static void s_stop(struct seq_file *m, void *p)
 {
 	atomic_dec(&trace_record_cmdline_disabled);
-	mutex_unlock(&trace_types_lock);
 }
 
 static void print_lat_help_header(struct seq_file *m)
@@ -1690,13 +1701,24 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 		goto out;
 	}
 
+	/*
+	 * We make a copy of the current tracer to avoid concurrent
+	 * changes on it while we are reading.
+	 */
 	mutex_lock(&trace_types_lock);
+	iter->trace = kzalloc(sizeof(*iter->trace), GFP_KERNEL);
+	if (!iter->trace) {
+		*ret = -ENOMEM;
+		goto fail;
+	}
+	if (current_trace)
+		*iter->trace = *current_trace;
+
 	if (current_trace && current_trace->print_max)
 		iter->tr = &max_tr;
 	else
 		iter->tr = &global_trace;
-	iter->trace = current_trace;
 	iter->pos = -1;
+	mutex_init(&iter->mutex);
 	iter->cpu_file = cpu_file;
 
 	/* Notify the tracer early; before we stop tracing. */
@@ -1746,8 +1768,9 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 		if (iter->buffer_iter[cpu])
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
 	}
-fail:
+ fail:
 	mutex_unlock(&trace_types_lock);
+	kfree(iter->trace);
 	kfree(iter);
 
 	return ERR_PTR(-ENOMEM);
@@ -1782,6 +1805,8 @@ static int tracing_release(struct inode *inode, struct file *file)
 	mutex_unlock(&trace_types_lock);
 
 	seq_release(inode, file);
+	mutex_destroy(&iter->mutex);
+	kfree(iter->trace);
 	kfree(iter);
 	return 0;
 }
@@ -2391,10 +2416,20 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		goto out;
 	}
 
+	/*
+	 * We make a copy of the current tracer to avoid concurrent
+	 * changes on it while we are reading.
+	 */
+	iter->trace = kmalloc(sizeof(*iter->trace), GFP_KERNEL);
+	if (!iter->trace) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	if (current_trace)
+		*iter->trace = *current_trace;
+
 	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL)) {
-		kfree(iter);
 		ret = -ENOMEM;
-		goto out;
+		goto fail;
 	}
 
 	/* trace pipe does not show start of buffer */
@@ -2402,7 +2437,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 
 	iter->cpu_file = cpu_file;
 	iter->tr = &global_trace;
-	iter->trace = current_trace;
+	mutex_init(&iter->mutex);
 	filp->private_data = iter;
 
 	if (iter->trace->pipe_open)
@@ -2411,6 +2446,12 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 out:
 	mutex_unlock(&trace_types_lock);
 	return ret;
+
+fail:
+	kfree(iter->trace);
+	kfree(iter);
+	mutex_unlock(&trace_types_lock);
+	return ret;
 }
 
 static int tracing_release_pipe(struct inode *inode, struct file *file)
@@ -2427,6 +2468,8 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 	mutex_unlock(&trace_types_lock);
 
 	free_cpumask_var(iter->started);
+	mutex_destroy(&iter->mutex);
+	kfree(iter->trace);
 	kfree(iter);
 
 	return 0;
@@ -2496,18 +2539,15 @@ static int tracing_wait_pipe(struct file *filp)
 			return -EAGAIN;
 		}
 
-		mutex_unlock(&trace_types_lock);
+		mutex_unlock(&iter->mutex);
 
 		iter->trace->wait_pipe(iter);
 
-		mutex_lock(&trace_types_lock);
+		mutex_lock(&iter->mutex);
 
 		if (signal_pending(current))
 			return -EINTR;
 
-		if (iter->trace != current_trace)
-			return 0;
-
 		/*
 		 * We block until we read something and tracing is disabled.
 		 * We still block if tracing is disabled, but we have never
@@ -2532,6 +2572,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter = filp->private_data;
+	static struct tracer *old_tracer;
 	ssize_t sret;
 
 	/* return any leftover data */
@@ -2541,7 +2582,19 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 	trace_seq_reset(&iter->seq);
 
+	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
+	if (unlikely(old_tracer != current_trace && current_trace)) {
+		old_tracer = current_trace;
+		*iter->trace = *current_trace;
+	}
+	mutex_unlock(&trace_types_lock);
+
+	/*
+	 * Avoid more than one consumer on a single file descriptor
+	 * This is just a matter of traces coherency, the ring buffer itself
+	 * is protected.
+	 */
+	mutex_lock(&iter->mutex);
 	if (iter->trace->read) {
 		sret = iter->trace->read(iter, filp, ubuf, cnt, ppos);
 		if (sret)
@@ -2598,7 +2651,7 @@ waitagain:
 		goto waitagain;
 
 out:
-	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&iter->mutex);
 
 	return sret;
 }
@@ -2675,11 +2728,20 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		.ops		= &tracing_pipe_buf_ops,
 		.spd_release	= tracing_spd_release_pipe,
 	};
+	static struct tracer *old_tracer;
 	ssize_t ret;
 	size_t rem;
 	unsigned int i;
 
+	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
+	if (unlikely(old_tracer != current_trace && current_trace)) {
+		old_tracer = current_trace;
+		*iter->trace = *current_trace;
+	}
+	mutex_unlock(&trace_types_lock);
+
+	mutex_lock(&iter->mutex);
 
 	if (iter->trace->splice_read) {
 		ret = iter->trace->splice_read(iter, filp,
@@ -2719,14 +2781,14 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		trace_seq_reset(&iter->seq);
 	}
 
-	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&iter->mutex);
 
 	spd.nr_pages = i;
 
 	return splice_to_pipe(pipe, &spd);
 
 out_err:
-	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&iter->mutex);
 
 	return ret;
 }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 0a38bdf..86c7e77 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -417,8 +417,9 @@ struct trace_iterator {
 	struct trace_array	*tr;
 	struct tracer		*trace;
 	void			*private;
-	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
 	int			cpu_file;
+	struct mutex		mutex;
+	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
 
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
-- 
1.6.1


