Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbZBKRTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbZBKRTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbZBKRTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:19:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48489 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208AbZBKRTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:19:33 -0500
Subject: [RFC] blktrace: add glock tracing to blktrace
From: Steven Whitehouse <swhiteho@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 11 Feb 2009 17:20:27 +0000
Message-Id: <1234372827.3566.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been thinking about adding a mechanism to trace GFS2's glocks (i.e.
the cache control mechanism) for some time. It seems to me that in order
to be most useful, it would be a good plan to have a tracing mechanism
which provides sequencing with respect to block I/O. Having had a look
at the innards of blktrace, I think it would make a good fit.

With that in mind, here is my first attempt at such a thing. It did
occur to me that it might be useful as a generic item for other cluster
filesystems too. With that in mind, I've use the dlm lock modes (which
are more standard) in the interface rather than the GFS2 ones (there is
a 1:1 correspondence in fact).

The assumption is that each glock blktrace message will always include a
"current state", and optionally might include information about state
transitions as well.

Glocks are identified by two numbers: the type number and the glock
number. The latter is (for most glocks) based upon the disk block number
of the object (inode, resource group, etc) which it protects and for the
other glocks, its a small integer. I think it makes sense to use the
existing sector field for this. The type number is reported as part of
the struct blk_trace_io_glock. I've also added a flags field to that
structure (currently unused) in case of future need.

I know it might seem a bit odd for a filesystem to be using this
mechanism, but it does seem to make sense in this particular case.

The kernel patch (applies against the GFS2 -nmw git tree) is below. The
userland bits are in the following email,

Steve.

diff --git a/block/blktrace.c b/block/blktrace.c
index b0a2cae..177493b 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -26,7 +26,8 @@
 #include <trace/block.h>
 #include <asm/uaccess.h>
 
-static unsigned int blktrace_seq __read_mostly = 1;
+unsigned int blktrace_seq __read_mostly = 1;
+EXPORT_SYMBOL_GPL(blktrace_seq);
 
 /* Global reference count of probes */
 static DEFINE_MUTEX(blk_probe_mutex);
@@ -62,11 +63,12 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
  * Send out a notify for this process, if we haven't done so since a trace
  * started
  */
-static void trace_note_tsk(struct blk_trace *bt, struct task_struct *tsk)
+void blk_trace_note_tsk(struct blk_trace *bt, struct task_struct *tsk)
 {
 	tsk->btrace_seq = blktrace_seq;
 	trace_note(bt, tsk->pid, BLK_TN_PROCESS, tsk->comm, sizeof(tsk->comm));
 }
+EXPORT_SYMBOL_GPL(blk_trace_note_tsk);
 
 static void trace_note_time(struct blk_trace *bt)
 {
@@ -159,7 +161,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	local_irq_save(flags);
 
 	if (unlikely(tsk->btrace_seq != blktrace_seq))
-		trace_note_tsk(bt, tsk);
+		blk_trace_note_tsk(bt, tsk);
 
 	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
 	if (t) {
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index ad8e121..cca0163 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -27,6 +27,9 @@
 #include <linux/freezer.h>
 #include <linux/workqueue.h>
 #include <linux/jiffies.h>
+#include <trace/gfs2.h>
+#include <linux/blktrace_api.h>
+#include <linux/relay.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -40,6 +43,10 @@
 #include "util.h"
 #include "bmap.h"
 
+DEFINE_TRACE(gfs2_glock_state_change);
+DEFINE_TRACE(gfs2_glock_put);
+DEFINE_TRACE(gfs2_demote_rq);
+
 struct gfs2_gl_hash_bucket {
         struct hlist_head hb_list;
 };
@@ -155,7 +162,7 @@ static void glock_free(struct gfs2_glock *gl)
 
 	if (aspace)
 		gfs2_aspace_put(aspace);
-
+	trace_gfs2_glock_put(gl);
 	sdp->sd_lockstruct.ls_ops->lm_put_lock(gfs2_glock_cachep, gl);
 }
 
@@ -422,6 +429,7 @@ static void finish_xmote(struct gfs2_glock *gl, unsigned int ret)
 	int rv;
 
 	spin_lock(&gl->gl_spin);
+	trace_gfs2_glock_state_change(gl, state);
 	state_change(gl, state);
 	gh = find_first_waiter(gl);
 
@@ -835,6 +843,7 @@ static void handle_callback(struct gfs2_glock *gl, unsigned int state,
 			gl->gl_demote_state != state) {
 		gl->gl_demote_state = LM_ST_UNLOCKED;
 	}
+	trace_gfs2_demote_rq(gl);
 }
 
 /**
@@ -1684,10 +1693,119 @@ static int gfs2_dump_lockstate(struct gfs2_sbd *sdp)
 	return error;
 }
 
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+static u8 glock_trace_state(unsigned int state)
+{
+	switch(state) {
+	case LM_ST_SHARED:
+		return BLK_GLS_PREAD;
+	case LM_ST_DEFERRED:
+		return BLK_GLS_CWRITE;
+	case LM_ST_EXCLUSIVE:
+		return BLK_GLS_EXCLUSIVE;
+	}
+	return BLK_GLS_NULL;
+}
+
+static void gfs2_trace_glock(struct gfs2_glock *gl, u8 new_state,
+			     u8 tgt_state)
+{
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct block_device *bdev = sdp->sd_vfs->s_bdev;
+	struct request_queue *rq = bdev_get_queue(bdev);
+	struct blk_trace *bt = rq->blk_trace;
+	struct task_struct *tsk = current;
+	struct blk_io_trace *t;
+	struct blk_io_trace_glock *g;
+	unsigned long flags;
+	pid_t pid;
+	u64 glnum;
+
+	if (likely(!bt))
+		return;
+	if (unlikely(bt->trace_state != Blktrace_running))
+		return;
+	glnum = gl->gl_name.ln_number;
+	if (((bt->act_mask << BLK_TC_SHIFT) & BLK_TN_GLOCK) == 0)
+		return;
+	/* Only certain glock types are mapped to disk block numbers */
+	switch(gl->gl_name.ln_type) {
+	case LM_TYPE_INODE:
+	case LM_TYPE_RGRP:
+	case LM_TYPE_IOPEN:
+	case LM_TYPE_FLOCK:
+		if (glnum < bt->start_lba || glnum > bt->end_lba)
+        	        return;
+	}
+	pid = tsk->pid;
+	/* Hmm, not sure if selecting by pid makes sense here... */
+	if (bt->pid && (pid != bt->pid))
+		return;
+	local_irq_save(flags);
+	if (unlikely(tsk->btrace_seq != blktrace_seq))
+		blk_trace_note_tsk(bt, tsk);
+
+	t = relay_reserve(bt->rchan, sizeof(*t) + sizeof(*g));
+	if (t) {
+		const int cpu = smp_processor_id();
+		unsigned long *sequence = per_cpu_ptr(bt->sequence, cpu);
+
+		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
+		t->sequence = ++(*sequence);
+		t->time = ktime_to_ns(ktime_get());
+		t->sector = glnum;
+		t->bytes = 0;
+		t->action = BLK_TN_GLOCK;
+		t->pid = pid;
+		t->device = bt->dev;
+		t->cpu = cpu;
+		t->error = 0;
+		t->pdu_len = sizeof(*g);
+		g = (struct blk_io_trace_glock *)(t + 1);
+		g->type = cpu_to_be32(gl->gl_name.ln_type);
+		g->flags = 0;
+		g->cur_state = BLK_GLS_NONE;
+		if (test_bit(GLF_TRACE_INITIAL, &gl->gl_flags))
+			g->cur_state = glock_trace_state(gl->gl_state);
+		g->new_state = new_state;
+		g->dmt_state = 0;
+		if (test_bit(GLF_DEMOTE, &gl->gl_flags) ||
+		    test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags))
+			g->dmt_state = glock_trace_state(gl->gl_demote_state);
+		g->tgt_state = tgt_state;
+		if (g->tgt_state == g->cur_state)
+			g->tgt_state = 0;
+		if (g->cur_state == g->new_state)
+			g->new_state = 0;
+        }
+
+	local_irq_restore(flags);
+}
+
+static void gfs2_trace_state_change(struct gfs2_glock *gl,
+				    unsigned int new_state)
+{
+	gfs2_trace_glock(gl, glock_trace_state(new_state),
+			 glock_trace_state(gl->gl_target));
+	set_bit(GLF_TRACE_INITIAL, &gl->gl_flags);
+}
+
+static void gfs2_trace_glock_put(struct gfs2_glock *gl)
+{
+	gfs2_trace_glock(gl, BLK_GLS_NONE, BLK_GLS_NONE);
+}
+
+static void gfs2_trace_demote_rq(struct gfs2_glock *gl)
+{
+	gfs2_trace_glock(gl, 0, 0);
+}
+#endif /* CONFIG_BLK_DEV_IO_TRACE */
 
 int __init gfs2_glock_init(void)
 {
 	unsigned i;
+	int rv;
+
 	for(i = 0; i < GFS2_GL_HASH_SIZE; i++) {
 		INIT_HLIST_HEAD(&gl_hash_table[i].hb_list);
 	}
@@ -1702,6 +1820,12 @@ int __init gfs2_glock_init(void)
 		return PTR_ERR(glock_workqueue);
 
 	register_shrinker(&glock_shrinker);
+	rv = register_trace_gfs2_glock_state_change(gfs2_trace_state_change);
+	WARN_ON(rv && rv != -ENOSYS);
+	rv = register_trace_gfs2_glock_put(gfs2_trace_glock_put);
+	WARN_ON(rv && rv != -ENOSYS);
+	rv = register_trace_gfs2_demote_rq(gfs2_trace_demote_rq);
+	WARN_ON(rv && rv != -ENOSYS);
 
 	return 0;
 }
@@ -1710,6 +1834,9 @@ void gfs2_glock_exit(void)
 {
 	unregister_shrinker(&glock_shrinker);
 	destroy_workqueue(glock_workqueue);
+	unregister_trace_gfs2_glock_state_change(gfs2_trace_state_change);
+	unregister_trace_gfs2_glock_put(gfs2_trace_glock_put);
+	unregister_trace_gfs2_demote_rq(gfs2_trace_demote_rq);
 }
 
 static int gfs2_glock_iter_next(struct gfs2_glock_iter *gi)
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 980a086..3192cc3 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -189,6 +189,7 @@ enum {
 	GLF_REPLY_PENDING		= 9,
 	GLF_INITIAL			= 10,
 	GLF_FROZEN			= 11,
+	GLF_TRACE_INITIAL		= 12,
 };
 
 struct gfs2_glock {
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 1dba349..1b7a07b 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -62,6 +62,7 @@ enum blktrace_notify {
 	__BLK_TN_PROCESS = 0,		/* establish pid/name mapping */
 	__BLK_TN_TIMESTAMP,		/* include system clock */
 	__BLK_TN_MESSAGE,		/* Character string message */
+	__BLK_TN_GLOCK,			/* Glock data */
 };
 
 
@@ -89,6 +90,7 @@ enum blktrace_notify {
 #define BLK_TN_PROCESS		(__BLK_TN_PROCESS | BLK_TC_ACT(BLK_TC_NOTIFY))
 #define BLK_TN_TIMESTAMP	(__BLK_TN_TIMESTAMP | BLK_TC_ACT(BLK_TC_NOTIFY))
 #define BLK_TN_MESSAGE		(__BLK_TN_MESSAGE | BLK_TC_ACT(BLK_TC_NOTIFY))
+#define BLK_TN_GLOCK		(__BLK_TN_GLOCK | BLK_TC_ACT(BLK_TC_NOTIFY))
 
 #define BLK_IO_TRACE_MAGIC	0x65617400
 #define BLK_IO_TRACE_VERSION	0x07
@@ -119,6 +121,29 @@ struct blk_io_trace_remap {
 	__be64 sector;
 };
 
+/* Glock lock states, so we don't need to add any header deps */
+enum {
+	BLK_GLS_NONE = 1, 	/* i.e. invalid */
+	BLK_GLS_NULL,		/* Null lock (preserves LVB content) */
+	BLK_GLS_CREAD,		/* Concurrent read */
+	BLK_GLS_CWRITE,		/* Concurrent write */
+	BLK_GLS_PREAD,		/* Protected read */
+	BLK_GLS_PWRITE,		/* Protected write */
+	BLK_GLS_EXCLUSIVE,	/* Exclusive */
+};
+
+/*
+ * Glock info
+ */
+struct blk_io_trace_glock {
+	__be32 type;	/* Glock type, as per gl_name.ln_type */
+	__be32 flags;	/* Flags, currently unused */
+	u8 cur_state;	/* Current state */
+	u8 new_state;	/* New state */
+	u8 dmt_state;	/* Requested demote state */
+	u8 tgt_state;	/* Target state */
+};
+
 enum {
 	Blktrace_setup = 1,
 	Blktrace_running,
@@ -191,7 +216,8 @@ extern int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 			   char __user *arg);
 extern int blk_trace_startstop(struct request_queue *q, int start);
 extern int blk_trace_remove(struct request_queue *q);
-
+extern void blk_trace_note_tsk(struct blk_trace *bt, struct task_struct *tsk);
+extern unsigned int blktrace_seq __read_mostly;
 #else /* !CONFIG_BLK_DEV_IO_TRACE */
 #define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
 #define blk_trace_shutdown(q)			do { } while (0)


