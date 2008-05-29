Return-Path: <linux-kernel-owner+w=401wt.eu-S1751169AbYE2HJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbYE2HJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 03:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYE2HJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 03:09:19 -0400
Received: from brick.kernel.dk ([87.55.233.238]:16155 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYE2HJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 03:09:18 -0400
Date: Thu, 29 May 2008 09:09:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: block: make blktrace use per-cpu buffers for message notes
Message-ID: <20080529070915.GK25504@kernel.dk>
References: <200805281559.m4SFx7b9022392@hera.kernel.org> <20080528231351.a35001bc.akpm@linux-foundation.org> <20080529062214.GG25504@kernel.dk> <20080528233801.e9e55eeb.akpm@linux-foundation.org> <20080529064520.GJ25504@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529064520.GJ25504@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29 2008, Jens Axboe wrote:
> On Wed, May 28 2008, Andrew Morton wrote:
> > On Thu, 29 May 2008 08:22:15 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Wed, May 28 2008, Andrew Morton wrote:
> > > > On Wed, 28 May 2008 15:59:07 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> > > > 
> > > > > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=64565911cdb57c2f512a9715b985b5617402cc67
> > > > > Commit:     64565911cdb57c2f512a9715b985b5617402cc67
> > > > > Parent:     4722dc52a891ab6cb2d637ddb87233e0ce277827
> > > > > Author:     Jens Axboe <jens.axboe@oracle.com>
> > > > > AuthorDate: Wed May 28 14:45:33 2008 +0200
> > > > > Committer:  Jens Axboe <jens.axboe@oracle.com>
> > > > > CommitDate: Wed May 28 14:49:27 2008 +0200
> > > > 
> > > > please try to avoid merging unreviewed changes.
> > > 
> > > Just because you didn't review it doesn't mean it's unreviewed :-)
> > > 
> > > It's not unreviewed, it was posted on lkml and a few version were
> > > bounced back and forth.
> > 
> > OK.  The Subject: swizzling confounded me.
> > 
> > > > >  		if (unlikely(bt))					\
> > > > >  			__trace_note_message(bt, fmt, ##__VA_ARGS__);	\
> > > > >  	} while (0)
> > > > > -#define BLK_TN_MAX_MSG		1024
> > > > > +#define BLK_TN_MAX_MSG		128
> > > > 
> > > > It seems a bit strange to do this right when we've taken this _off_ the
> > > > stack.  But I suppose nothing will break.
> > > 
> > > It was never on the stack, it was a global static char array. We are
> > > still allocating memory for this, per-cpu. So I think it still makes
> > > sense to shrink the size. It's really meant for small trace messages,
> > > 128 bytes is plenty. It's an in-kernel property, the userland app
> > > doesn't care. So we could easily grow this in the future, should the
> > > need arise.
> > 
> > yup.
> > 
> > It's a bit sad to stage the data in a local per-cpu buffer and then
> > copy it into relay's per-cpu buffer.  I guess this is because the
> > length of the output isn't known beforehand.  Could be fixed by doing
> > what kvasprintf() does, but that might well be slower.
> 
> I agree, this is what we debated. My reasoning is that it's better
> to minimize usage of the relay buffer, so the stage-and-copy doesn't
> matter a whole lot.
> 
> I seem to recall a relay_unreserve() patch from Tom back in the day,
> if we had something like that we could do the optimal approach of:

So I dug back into the old archives, and the patch was actually done
by me back in feb 2006. Not sure I particularly like it or if it
even works in this forward ported version, but it should get the
point across. blktrace is the sole user of relay_reserve(), so I
think it would be OK to change the interface.

This is clearly NOT 2.6.26 material though, but it's food for
thought (I hope).

diff --git a/block/blktrace.c b/block/blktrace.c
index 7ae87cc..8583bfc 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -27,6 +27,18 @@
 
 static unsigned int blktrace_seq __read_mostly = 1;
 
+static void note_header(struct blk_io_trace *t, struct blk_trace *bt,
+			pid_t pid, int action, size_t len)
+{
+	t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
+	t->time = ktime_to_ns(ktime_get());
+	t->device = bt->dev;
+	t->action = action;
+	t->pid = pid;
+	t->cpu = smp_processor_id();
+	t->pdu_len = len;
+}
+
 /*
  * Send out a notify message.
  */
@@ -37,16 +49,9 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 
 	t = relay_reserve(bt->rchan, sizeof(*t) + len);
 	if (t) {
-		const int cpu = smp_processor_id();
-
-		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
-		t->time = ktime_to_ns(ktime_get());
-		t->device = bt->dev;
-		t->action = action;
-		t->pid = pid;
-		t->cpu = cpu;
-		t->pdu_len = len;
+		note_header(t, bt, pid, action, len);
 		memcpy((void *) t + sizeof(*t), data, len);
+		relay_commit_reserve(bt->rchan);
 	}
 }
 
@@ -77,17 +82,24 @@ static void trace_note_time(struct blk_trace *bt)
 
 void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
 {
-	int n;
-	va_list args;
-	char *buf;
+	struct blk_io_trace *t;
 
 	preempt_disable();
-	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
-	va_start(args, fmt);
-	n = vscnprintf(buf, BLK_TN_MAX_MSG, fmt, args);
-	va_end(args);
+	t = relay_reserve(bt->rchan, sizeof(*t) + BLK_TN_MAX_MSG);
+	if (t) {
+		va_list args;
+		char *buf = (void *) t + sizeof(*t);
+		int len;
 
-	trace_note(bt, 0, BLK_TN_MESSAGE, buf, n);
+		va_start(args, fmt);
+		len = vscnprintf(buf, BLK_TN_MAX_MSG, fmt, args);
+		va_end(args);
+
+		if (BLK_TN_MAX_MSG - len)
+			relay_unreserve(bt->rchan, BLK_TN_MAX_MSG - len);
+
+		relay_commit_reserve(bt->rchan);
+	}
 	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(__trace_note_message);
@@ -187,6 +199,7 @@ void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 
 		if (pdu_len)
 			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
+		relay_commit_reserve(bt->rchan);
 	}
 
 	local_irq_restore(flags);
diff --git a/include/linux/relay.h b/include/linux/relay.h
index 6cd8c44..593f27f 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -35,6 +35,7 @@ struct rchan_buf
 	void *start;			/* start of channel buffer */
 	void *data;			/* start of current sub-buffer */
 	size_t offset;			/* current offset into sub-buffer */
+	size_t reserve_offset;
 	size_t subbufs_produced;	/* count of sub-buffers produced */
 	size_t subbufs_consumed;	/* count of sub-buffers consumed */
 	struct rchan *chan;		/* associated channel */
@@ -206,6 +207,7 @@ static inline void relay_write(struct rchan *chan,
 		length = relay_switch_subbuf(buf, length);
 	memcpy(buf->data + buf->offset, data, length);
 	buf->offset += length;
+	buf->reserve_offset = buf->offset;
 	local_irq_restore(flags);
 }
 
@@ -232,6 +234,7 @@ static inline void __relay_write(struct rchan *chan,
 		length = relay_switch_subbuf(buf, length);
 	memcpy(buf->data + buf->offset, data, length);
 	buf->offset += length;
+	buf->reserve_offset = buf->offset;
 	put_cpu();
 }
 
@@ -244,7 +247,8 @@ static inline void __relay_write(struct rchan *chan,
  *
  *	Reserves a slot in the current cpu's channel buffer.
  *	Does not protect the buffer at all - caller must provide
- *	appropriate synchronization.
+ *	appropriate synchronization. Must be paired directly with
+ *	a call to @relay_commit_reserve or @relay_unreserve.
  */
 static inline void *relay_reserve(struct rchan *chan, size_t length)
 {
@@ -257,11 +261,25 @@ static inline void *relay_reserve(struct rchan *chan, size_t length)
 			return NULL;
 	}
 	reserved = buf->data + buf->offset;
-	buf->offset += length;
+	buf->reserve_offset += length;
 
 	return reserved;
 }
 
+static inline void relay_unreserve(struct rchan *chan, size_t length)
+{
+	struct rchan_buf *buf = chan->buf[smp_processor_id()];
+
+	buf->reserve_offset -= length;
+}
+
+static inline void relay_commit_reserve(struct rchan *chan)
+{
+	struct rchan_buf *buf = chan->buf[smp_processor_id()];
+
+	buf->offset = buf->reserve_offset;
+}
+
 /**
  *	subbuf_start_reserve - reserve bytes at the start of a sub-buffer
  *	@buf: relay channel buffer
diff --git a/kernel/relay.c b/kernel/relay.c
index 7de644c..9208bd9 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -369,6 +369,7 @@ static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 	buf->finalized = 0;
 	buf->data = buf->start;
 	buf->offset = 0;
+	buf->reserve_offset = 0;
 
 	for (i = 0; i < buf->chan->n_subbufs; i++)
 		buf->padding[i] = 0;
@@ -644,8 +645,10 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
 	new_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
 	new = buf->start + new_subbuf * buf->chan->subbuf_size;
 	buf->offset = 0;
+	buf->reserve_offset = 0;
 	if (!buf->chan->cb->subbuf_start(buf, new, old, buf->prev_padding)) {
 		buf->offset = buf->chan->subbuf_size + 1;
+		buf->reserve_offset = buf->offset;
 		return 0;
 	}
 	buf->data = new;

-- 
Jens Axboe

