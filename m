Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbYJWGfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbYJWGfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYJWGfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:35:36 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:52103 "EHLO
	QMTA07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755183AbYJWGfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:35:30 -0400
X-Authority-Analysis: v=1.0 c=1 a=sTiiCYPAvvoA:10 a=ojZBJoN8wGQn4kj76ZIA:9
 a=vD5IT-xEUovwLdBOJN0A:7 a=3ED_tmVk28Av8e0UHKY9d2p3hcUA:4 a=wZiCkNY6m2YA:10
 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10 a=MSl-tDqOz04A:10 a=X-lDvSGlWgMA:10
 a=XF7b4UCPwd8A:10
Subject: [PATCH 1/1] relay revamp v8, full patch
From: Tom Zanussi <zanussi@comcast.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Jens Axboe <jens.axboe@oracle.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 01:35:24 -0500
Message-Id: <1224743724.11269.13.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits the current relay into two separate and completely
independent pieces: relay and relay_pagewriter.  Here's a one-line
description of each piece:

relay - the new relay simply accepts pages of trace data from anywhere
in the kernel and collects them into per-cpu lists which can be sent by
userspace to disk or network destinations via standard read(2),
splice(2) and sendfile(2) file operations, after which the pages are
returned to their owner(s).

relay_pagewriter -  provides a small set of page-writing functions that
allow tracers to write into pages it grabs one-by-one from a per-cpu
pool of pages and sends them to relay when each is completely written.

There are of course other features e.g. if you don't want to deal with
multiple per-cpu files, there's also a 'global' mode, as there always
was.  relay_pagewriter also supports a 'flight-recorder' mode where the
pages aren't sent to relay but rather returned to the end of the pool;
at some later point they can be sent to relay via a simple function
designed for that purpose.  Similarly, the 'early tracing/late setup'
functionality has been retained, but is now much simpler in
implementation; the fact that these and other features just seem to
'fall out' of the implementation seems to point to the end design being
a little nicer.

Note that because of this separation, there's nothing special about
relay_pagewriter - it becomes just another source of trace data (via an
actual tracer such as blktrace).

overview
========

Basically, the overall effect of the patchset is to split the current
relay into two separate and completely independent pieces: relay and
relay_pagewriter.  Here's a one-line description of each piece:

relay - the new relay simply accepts pages of trace data from anywhere
in the kernel and collects them into per-cpu lists which can be sent by
userspace to disk or network destinations via standard read(2),
splice(2) and sendfile(2) file operations, after which the pages are
returned to their owner(s).

relay_pagewriter -  provides a small set of page-writing functions that
allow tracers to write into pages it grabs one-by-one from a per-cpu
pool of pages and sends them to relay when each is completely written.

There are of course other features e.g. if you don't want to deal with
multiple per-cpu files, there's also a 'global' mode, as there always
was.  relay_pagewriter also supports a 'flight-recorder' mode where the
pages aren't sent to relay but rather returned to the end of the pool;
at some later point they can be sent to relay via a simple function
designed for that purpose.  Similarly, the 'early tracing/late setup'
functionality has been retained, but is now much simpler in
implementation; the fact that these and other features just seem to
'fall out' of the implementation seems to point to the end design being
a little nicer.

Note that because of this separation, there's nothing special about
relay_pagewriter - it becomes just another source of trace data (via an
actual tracer such as blktrace).

Here's an overview of relay and relay_pagewriter:

relay
=====

With the new changes, relay really does become just what its name says
and and nothing more - it accepts pages from tracers, and relays the
data to userspace via read(2) or splice(2) (and therefore sendfile(2)).
It doesn't allocate any buffer space and provides no write functions -
those are expected to be supplied by any tracer that might want relay
pages of trace data to userspace.

After applying the full patch you should be able to use it to stream
your trace data to disk or over the network...

Anyway, here's a brief overview of the new API (see code for details):

- relay_open():

Creates a per-cpu relay channel and by default associates debugfs files
with each per-cpu 'buffer'.  No buffer space is allocated for the
'buffers', rather they collect pages added by tracers in a list which is
drained by read()/splice(), etc.  Tracers add pages to the 'buffers'
using relay_write_page() and relay_write_pages().  One of the parameters
to relay_open() is n_pages_wakeup, which specifies that readers should
be woken up every time n_pages have been added; if this is 0, readers
are never woken up.

- relay_add_page():

Adds a page of trace data to relay.  After it has been consumed by
userspace, the tracer is notified by the 'relay page' callback function
page_released().  The page passed via the callback can then be re-used
by the tracer (see for example the pagewriter code, which simply adds
the page back into pagewriter's per-cpu page pool).  If the page has
been stolen instead (if SPLICE_F_MOVE succeeded, which can't happen in
current kernels since support for it isn't there), the page_stolen()
callback is called, at which point the tracer can allocate a new page to
replace the stolen page (see the pagewriter code, which does this too).

- relay_add_partial_page():

Adds a partial (less than or equal to PAGE_SIZE) page of trace data to
relay.  Sometimes a less-than-full page needs to be added to relay
e.g. the last page at the end of a trace; this allows for that.

- relay_add_pages():

The same as relay_add_page(), but adds a set of pages to relay and
guarantees that they'll stay together and remain in the same order they
were added.

- relay_close():

Releases unread pages to the tracer(s) and frees the channel.

- relay_flush():

Wakes up readers.

- relay_reset():

Releases unread pages to the tracer(s) and resets the channel state.

That's basically the entire kernel API for relay; the userspace API is
of course just read(), splice(), and sendfile().


relay_pagewriter
================

One example of a component that can write pages of trace data and send
them to relay would be the original relay write functions and buffers
(the no-vmap page-based versions), which have been split out into a new
file called relay_pagewriter.c and provide one means of writing into
pages and feeding them into relay.  blktrace and kvmtrace have been
'ported' over to using pagewriter instead of relay directly.

- pagewriter_open():

Allocates a pool of pages for each cpu and creates a relay channel to
send them to.  Whenever a new page is needed for writing into, the
pagewriter object pulls a page out of the appropriate per-cpu pool and
makes it available to tracers to write/reserve into via the
pagewriter_write() and pagewriter_reserve() functions.  When a page is
full, the pagewriter object sends the page to relay via relay_add_page()
and grabs another page for the next writes.  When relay has finished
relaying the pages to userspace, it returns the page via pagewriter's
page_released() or page_stolen() callbacks; pagewriter simply returns
(and allocates a new page if stolen) the page to the pool.

The number of pages allocated per-cpu is specified by the n_pages param.
The n_pages_wakeup param specifies that readers should be woken up every
n_pages_wakeup pages; pagewriter doesn't actually do anything with this
other than pass it on to the relay channel.

The flags param to pagewriter_open() is also passed on to relay_open();
the bottom half is used by relay for its flags and the top half by
pagewriter.  Here are the pagewriter flags and what they mean:

- PAGEWRITER_PAD_WRITES - this means that the writer doesn't want writes
split across pages - if the write won't fit completely within the space
remaining in the page, the event will be written in the next page, but
before that happens, the write_padding() pagewriter callback is called
to give the tracer a chance to write a 'padding event' in the unused
space.  Currently, this flag only make sense for a tracer using
pagewriter_reserve() and must be set if using pagewriter_reserve()
(since there's no way to reserve across pages).  Also currently,
pagewriter_write() always writes across pages, and for tracers using
pagewriter_write(), this flag should not be set.

- PAGEWRITER_FLIGHT_MODE - if this flag is set, pagewriter won't send
pages to relay as they become full, but will simply send them to the end
of the appropriate per-cpu pool and keep track of how many have been
written.  This continues until the tracer explicitly requests that they
be sent to relay and made available to userspace.  The function that
does this is pagewriter_save_flight_data().  After the pages have been
read by userspace, they're returned to pagewriter as usual.

- PAGEWRITER_LATE_SETUP - if this flag is set, pagewriter_open() won't
create the relay channel until pagewriter_late_setup() is called.
Before that call is made, written pages are tracked in the per-cpu pool
as in the PAGEWRITER_FLIGHT_MODE case and similarly, but after the relay
channel has been created by pagewriter_late_setup(), the pages are sent
to relay and on to userspace (and returned) as usual.

pagewriter callbacks
--------------------

The pagewriter_callbacks param of pagewriter_open() refers to the three
available pagewriter callbacks, none of which are required:

- new_page() - gives the tracer a chance to write page headers, track
pages, etc.

- switch_page() - allows a tracer to define its own switch_page()
'slow-path' function and therefore gain control over the complete write
path.  Wouldn't typically be used by normal tracers.

- write_padding() - called when PAGEWRITER_PAD_WRITES is used - allows
the tracer to write a 'padding event' if a normal event won't fit.
Currently only makes sense when using pagewriter_reserve().

write/reserve functions
-----------------------

- pagewriter_reserve(pagewriter, length):

Reserve length bytes in the current page.  If length bytes won't fit
into the current page, the reserve happens in the next page.  If
length bytes won't fit, at least end_reserve (specified via the
pagewriter_open param) bytes are guaranteed to be available at the end
of the page for the tracer to write a 'padding event' that presumably
will fit in end_reserve bytes.  The tracer is given an opportunity to
write its padding event via the write_padding() callback, which is
passed a pointer to start of padding along with the length of the
padding.  Currently, if using pagewriter_reserve(), the pagewriter
should also be opened using the PAGEWRITER_PAD_WRITES flag.

- pagewriter_write(pagewriter, data, length):

Write length bytes into the current page.  If the event won't fit into
the current page, whatever will fit is written into the current page,
and the remainder is written into the next page.  If there's no page
available for the remainder, the first part won't be written either.
pagewriter_write() disables irqs for synchronization;
__pagewriter_write() is essentially the same, but only disables
preemption.

misc functions
--------------

- pagewriter_flush():

Switches all partially written pages and calls relay_flush().

- pagewriter_close():

Frees the per-cpu pools, closes the associated relay channel, and
destroys the pagewriter.

- pagewriter_reset():

Resets the pagewriter to its initial state.


Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 block/blktrace.c                 |   69 +--
 include/linux/blktrace_api.h     |    7 +-
 include/linux/relay.h            |  255 ++-----
 include/linux/relay_pagewriter.h |  295 ++++++++
 kernel/Makefile                  |    2 +-
 kernel/relay.c                   | 1469 +++++++++++++++-----------------------
 kernel/relay_pagewriter.c        |  860 ++++++++++++++++++++++
 virt/kvm/kvm_trace.c             |   82 +--
 8 files changed, 1845 insertions(+), 1194 deletions(-)
 create mode 100644 include/linux/relay_pagewriter.h
 create mode 100644 kernel/relay_pagewriter.c

diff --git a/block/blktrace.c b/block/blktrace.c
index 85049a7..19e417c 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -35,7 +35,7 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 {
 	struct blk_io_trace *t;
 
-	t = relay_reserve(bt->rchan, sizeof(*t) + len);
+	t = pagewriter_reserve(bt->pagewriter, sizeof(*t) + len);
 	if (t) {
 		const int cpu = smp_processor_id();
 
@@ -153,7 +153,7 @@ void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	if (unlikely(tsk->btrace_seq != blktrace_seq))
 		trace_note_tsk(bt, tsk);
 
-	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
+	t = pagewriter_reserve(bt->pagewriter, sizeof(*t) + pdu_len);
 	if (t) {
 		cpu = smp_processor_id();
 		sequence = per_cpu_ptr(bt->sequence, cpu);
@@ -230,7 +230,7 @@ err:
 
 static void blk_trace_cleanup(struct blk_trace *bt)
 {
-	relay_close(bt->rchan);
+	pagewriter_close(bt->pagewriter);
 	debugfs_remove(bt->msg_file);
 	debugfs_remove(bt->dropped_file);
 	blk_remove_tree(bt->dir);
@@ -268,7 +268,8 @@ static ssize_t blk_dropped_read(struct file *filp, char __user *buffer,
 	struct blk_trace *bt = filp->private_data;
 	char buf[16];
 
-	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&bt->dropped));
+	snprintf(buf, sizeof(buf), "%u\n",
+		 atomic_read(&bt->pagewriter->dropped));
 
 	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
 }
@@ -317,43 +318,19 @@ static const struct file_operations blk_msg_fops = {
 	.write =	blk_msg_write,
 };
 
-/*
- * Keep track of how many times we encountered a full subbuffer, to aid
- * the user space app in telling how many lost events there were.
- */
-static int blk_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
-				     void *prev_subbuf, size_t prev_padding)
+static void blk_write_padding_callback(struct pagewriter_buf *buf,
+				       size_t length,
+				       void *reserved)
 {
-	struct blk_trace *bt;
+	struct blk_io_trace *t = reserved;
 
-	if (!relay_buf_full(buf))
-		return 1;
-
-	bt = buf->chan->private_data;
-	atomic_inc(&bt->dropped);
-	return 0;
-}
-
-static int blk_remove_buf_file_callback(struct dentry *dentry)
-{
-	debugfs_remove(dentry);
-	return 0;
-}
-
-static struct dentry *blk_create_buf_file_callback(const char *filename,
-						   struct dentry *parent,
-						   int mode,
-						   struct rchan_buf *buf,
-						   int *is_global)
-{
-	return debugfs_create_file(filename, mode, parent, buf,
-					&relay_file_operations);
+	t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
+	t->action = BLK_TN_PADDING;
+	t->pdu_len = length - sizeof(*t);
 }
 
-static struct rchan_callbacks blk_relay_callbacks = {
-	.subbuf_start		= blk_subbuf_start_callback,
-	.create_buf_file	= blk_create_buf_file_callback,
-	.remove_buf_file	= blk_remove_buf_file_callback,
+static struct pagewriter_callbacks blk_pagewriter_callbacks = {
+	.write_padding           = blk_write_padding_callback,
 };
 
 /*
@@ -365,6 +342,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	struct blk_trace *old_bt, *bt = NULL;
 	struct dentry *dir = NULL;
 	int ret, i;
+	int n_pages, n_pages_wakeup;
 
 	if (!buts->buf_size || !buts->buf_nr)
 		return -EINVAL;
@@ -400,7 +378,6 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 
 	bt->dir = dir;
 	bt->dev = dev;
-	atomic_set(&bt->dropped, 0);
 
 	ret = -EIO;
 	bt->dropped_file = debugfs_create_file("dropped", 0444, dir, bt, &blk_dropped_fops);
@@ -411,9 +388,13 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	if (!bt->msg_file)
 		goto err;
 
-	bt->rchan = relay_open("trace", dir, buts->buf_size,
-				buts->buf_nr, &blk_relay_callbacks, bt);
-	if (!bt->rchan)
+	n_pages = (buts->buf_size * buts->buf_nr) / PAGE_SIZE;
+	n_pages_wakeup = buts->buf_size / PAGE_SIZE;
+	bt->pagewriter = pagewriter_open("trace", dir, n_pages, n_pages_wakeup,
+					 sizeof(struct blk_io_trace),
+					 &blk_pagewriter_callbacks, bt,
+					 PAGEWRITER_PAD_WRITES);
+	if (!bt->pagewriter)
 		goto err;
 
 	bt->act_mask = buts->act_mask;
@@ -446,8 +427,8 @@ err:
 			debugfs_remove(bt->dropped_file);
 		free_percpu(bt->sequence);
 		free_percpu(bt->msg_data);
-		if (bt->rchan)
-			relay_close(bt->rchan);
+		if (bt->pagewriter)
+			pagewriter_close(bt->pagewriter);
 		kfree(bt);
 	}
 	return ret;
@@ -500,7 +481,7 @@ int blk_trace_startstop(struct request_queue *q, int start)
 	} else {
 		if (bt->trace_state == Blktrace_running) {
 			bt->trace_state = Blktrace_stopped;
-			relay_flush(bt->rchan);
+			pagewriter_flush(bt->pagewriter);
 			ret = 0;
 		}
 	}
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index bdf505d..b14e6e4 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -3,7 +3,7 @@
 
 #ifdef __KERNEL__
 #include <linux/blkdev.h>
-#include <linux/relay.h>
+#include <linux/relay_pagewriter.h>
 #endif
 
 /*
@@ -62,6 +62,7 @@ enum blktrace_notify {
 	__BLK_TN_PROCESS = 0,		/* establish pid/name mapping */
 	__BLK_TN_TIMESTAMP,		/* include system clock */
 	__BLK_TN_MESSAGE,		/* Character string message */
+	__BLK_TN_PADDING,		/* Padding message */
 };
 
 
@@ -89,6 +90,7 @@ enum blktrace_notify {
 #define BLK_TN_PROCESS		(__BLK_TN_PROCESS | BLK_TC_ACT(BLK_TC_NOTIFY))
 #define BLK_TN_TIMESTAMP	(__BLK_TN_TIMESTAMP | BLK_TC_ACT(BLK_TC_NOTIFY))
 #define BLK_TN_MESSAGE		(__BLK_TN_MESSAGE | BLK_TC_ACT(BLK_TC_NOTIFY))
+#define BLK_TN_PADDING		(__BLK_TN_PADDING | BLK_TC_ACT(BLK_TC_NOTIFY))
 
 #define BLK_IO_TRACE_MAGIC	0x65617400
 #define BLK_IO_TRACE_VERSION	0x07
@@ -144,7 +146,7 @@ struct blk_user_trace_setup {
 #if defined(CONFIG_BLK_DEV_IO_TRACE)
 struct blk_trace {
 	int trace_state;
-	struct rchan *rchan;
+	struct pagewriter *pagewriter;
 	unsigned long *sequence;
 	unsigned char *msg_data;
 	u16 act_mask;
@@ -155,7 +157,6 @@ struct blk_trace {
 	struct dentry *dir;
 	struct dentry *dropped_file;
 	struct dentry *msg_file;
-	atomic_t dropped;
 };
 
 extern int blk_trace_ioctl(struct block_device *, unsigned, char __user *);
diff --git a/include/linux/relay.h b/include/linux/relay.h
index 953fc05..2c66026 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2002, 2003 - Tom Zanussi (zanussi@us.ibm.com), IBM Corp
  * Copyright (C) 1999, 2000, 2001, 2002 - Karim Yaghmour (karim@opersys.com)
+ * Copyright (C) 2008 - Tom Zanussi (tzanussi@gmail.com)
  *
  * CONFIG_RELAY definitions and declarations
  */
@@ -18,37 +19,38 @@
 #include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/kref.h>
+#include <linux/pagevec.h>
 
-/* Needs a _much_ better name... */
-#define FIX_SIZE(x) ((((x) - 1) & PAGE_MASK) + PAGE_SIZE)
+/*
+ * relay channel flags
+ */
+#define RCHAN_GLOBAL_BUFFER		0x00000001	/* not using per-cpu */
 
 /*
- * Tracks changes to rchan/rchan_buf structs
+ * For page lists
  */
-#define RELAYFS_CHANNEL_VERSION		7
+struct relay_page {
+	struct page *page;
+	size_t len;
+	struct list_head list;
+	struct relay_page_callbacks *cb;
+	void *private_data;
+};
 
 /*
  * Per-cpu relay channel buffer
  */
-struct rchan_buf
-{
-	void *start;			/* start of channel buffer */
-	void *data;			/* start of current sub-buffer */
-	size_t offset;			/* current offset into sub-buffer */
-	size_t subbufs_produced;	/* count of sub-buffers produced */
-	size_t subbufs_consumed;	/* count of sub-buffers consumed */
+struct rchan_buf {
 	struct rchan *chan;		/* associated channel */
 	wait_queue_head_t read_wait;	/* reader wait queue */
 	struct timer_list timer; 	/* reader wake-up timer */
 	struct dentry *dentry;		/* channel file dentry */
 	struct kref kref;		/* channel buffer refcount */
-	struct page **page_array;	/* array of current buffer pages */
-	unsigned int page_count;	/* number of current buffer pages */
+	struct list_head pages;		/* current set of unconsumed pages */
+	size_t nr_pages;		/* number of unconsumed pages */
+	spinlock_t lock;		/* protect pages list */
+	size_t consumed_offset;		/* bytes consumed in cur page */
 	unsigned int finalized;		/* buffer has been finalized */
-	size_t *padding;		/* padding counts per sub-buffer */
-	size_t prev_padding;		/* temporary variable */
-	size_t bytes_consumed;		/* bytes consumed in cur read subbuf */
-	size_t early_bytes;		/* bytes consumed before VFS inited */
 	unsigned int cpu;		/* this buf's cpu */
 } ____cacheline_aligned;
 
@@ -57,20 +59,15 @@ struct rchan_buf
  */
 struct rchan
 {
-	u32 version;			/* the version of this struct */
-	size_t subbuf_size;		/* sub-buffer size */
-	size_t n_subbufs;		/* number of sub-buffers per buffer */
-	size_t alloc_size;		/* total buffer size allocated */
+	size_t n_pages_wakeup;		/* wake up readers after filling n */
 	struct rchan_callbacks *cb;	/* client callbacks */
 	struct kref kref;		/* channel refcount */
 	void *private_data;		/* for user-defined data */
-	size_t last_toobig;		/* tried to log event > subbuf size */
 	struct rchan_buf *buf[NR_CPUS]; /* per-cpu channel buffers */
-	int is_global;			/* One global buffer ? */
 	struct list_head list;		/* for channel list */
 	struct dentry *parent;		/* parent dentry passed to open */
-	int has_base_filename;		/* has a filename associated? */
 	char base_filename[NAME_MAX];	/* saved base filename */
+	unsigned long flags;		/* relay flags for this channel */
 };
 
 /*
@@ -79,53 +76,11 @@ struct rchan
 struct rchan_callbacks
 {
 	/*
-	 * subbuf_start - called on buffer-switch to a new sub-buffer
-	 * @buf: the channel buffer containing the new sub-buffer
-	 * @subbuf: the start of the new sub-buffer
-	 * @prev_subbuf: the start of the previous sub-buffer
-	 * @prev_padding: unused space at the end of previous sub-buffer
-	 *
-	 * The client should return 1 to continue logging, 0 to stop
-	 * logging.
-	 *
-	 * NOTE: subbuf_start will also be invoked when the buffer is
-	 *       created, so that the first sub-buffer can be initialized
-	 *       if necessary.  In this case, prev_subbuf will be NULL.
-	 *
-	 * NOTE: the client can reserve bytes at the beginning of the new
-	 *       sub-buffer by calling subbuf_start_reserve() in this callback.
-	 */
-	int (*subbuf_start) (struct rchan_buf *buf,
-			     void *subbuf,
-			     void *prev_subbuf,
-			     size_t prev_padding);
-
-	/*
-	 * buf_mapped - relay buffer mmap notification
-	 * @buf: the channel buffer
-	 * @filp: relay file pointer
-	 *
-	 * Called when a relay file is successfully mmapped
-	 */
-        void (*buf_mapped)(struct rchan_buf *buf,
-			   struct file *filp);
-
-	/*
-	 * buf_unmapped - relay buffer unmap notification
-	 * @buf: the channel buffer
-	 * @filp: relay file pointer
-	 *
-	 * Called when a relay file is successfully unmapped
-	 */
-        void (*buf_unmapped)(struct rchan_buf *buf,
-			     struct file *filp);
-	/*
 	 * create_buf_file - create file to represent a relay channel buffer
 	 * @filename: the name of the file to create
 	 * @parent: the parent of the file to create
 	 * @mode: the mode of the file to create
 	 * @buf: the channel buffer
-	 * @is_global: outparam - set non-zero if the buffer should be global
 	 *
 	 * Called during relay_open(), once for each per-cpu buffer,
 	 * to allow the client to create a file to be used to
@@ -136,17 +91,12 @@ struct rchan_callbacks
 	 * The callback should return the dentry of the file created
 	 * to represent the relay buffer.
 	 *
-	 * Setting the is_global outparam to a non-zero value will
-	 * cause relay_open() to create a single global buffer rather
-	 * than the default set of per-cpu buffers.
-	 *
 	 * See Documentation/filesystems/relayfs.txt for more info.
 	 */
 	struct dentry *(*create_buf_file)(const char *filename,
 					  struct dentry *parent,
 					  int mode,
-					  struct rchan_buf *buf,
-					  int *is_global);
+					  struct rchan_buf *buf);
 
 	/*
 	 * remove_buf_file - remove file representing a relay channel buffer
@@ -162,125 +112,60 @@ struct rchan_callbacks
 };
 
 /*
- * CONFIG_RELAY kernel API, kernel/relay.c
- */
-
-struct rchan *relay_open(const char *base_filename,
-			 struct dentry *parent,
-			 size_t subbuf_size,
-			 size_t n_subbufs,
-			 struct rchan_callbacks *cb,
-			 void *private_data);
-extern int relay_late_setup_files(struct rchan *chan,
-				  const char *base_filename,
-				  struct dentry *parent);
-extern void relay_close(struct rchan *chan);
-extern void relay_flush(struct rchan *chan);
-extern void relay_subbufs_consumed(struct rchan *chan,
-				   unsigned int cpu,
-				   size_t consumed);
-extern void relay_reset(struct rchan *chan);
-extern int relay_buf_full(struct rchan_buf *buf);
-
-extern size_t relay_switch_subbuf(struct rchan_buf *buf,
-				  size_t length);
-
-/**
- *	relay_write - write data into the channel
- *	@chan: relay channel
- *	@data: data to be written
- *	@length: number of bytes to write
- *
- *	Writes data into the current cpu's channel buffer.
- *
- *	Protects the buffer by disabling interrupts.  Use this
- *	if you might be logging from interrupt context.  Try
- *	__relay_write() if you know you	won't be logging from
- *	interrupt context.
- */
-static inline void relay_write(struct rchan *chan,
-			       const void *data,
-			       size_t length)
-{
-	unsigned long flags;
-	struct rchan_buf *buf;
-
-	local_irq_save(flags);
-	buf = chan->buf[smp_processor_id()];
-	if (unlikely(buf->offset + length > chan->subbuf_size))
-		length = relay_switch_subbuf(buf, length);
-	memcpy(buf->data + buf->offset, data, length);
-	buf->offset += length;
-	local_irq_restore(flags);
-}
-
-/**
- *	__relay_write - write data into the channel
- *	@chan: relay channel
- *	@data: data to be written
- *	@length: number of bytes to write
- *
- *	Writes data into the current cpu's channel buffer.
- *
- *	Protects the buffer by disabling preemption.  Use
- *	relay_write() if you might be logging from interrupt
- *	context.
+ * Relay page callbacks
  */
-static inline void __relay_write(struct rchan *chan,
-				 const void *data,
-				 size_t length)
+struct relay_page_callbacks
 {
-	struct rchan_buf *buf;
+	/*
+	 * page_released - notification that a page is ready for re-use
+	 * @page: the released page
+	 * @private_data: user-defined data associated with the page
+	 *
+	 * This callback is a notification that a given page has been
+	 * read by userspace and can be re-used.  Always called in
+	 * user context.
+	 */
+	void (*page_released) (struct page *page, void *private_data);
 
-	buf = chan->buf[get_cpu()];
-	if (unlikely(buf->offset + length > buf->chan->subbuf_size))
-		length = relay_switch_subbuf(buf, length);
-	memcpy(buf->data + buf->offset, data, length);
-	buf->offset += length;
-	put_cpu();
-}
+	/*
+	 * page_released - notification that a page has been stolen
+	 * @page: the stolen page
+	 * @private_data: user-defined data associated with the page
+	 *
+	 * This callback is a notification that a given page has been
+	 * stolen by userspace.  The owner may wish to replace it;
+	 * this gives it the opportunity to do so.  Always called in
+	 * user context.
+	 */
+	void (*page_stolen) (struct page *page, void *private_data);
+};
 
-/**
- *	relay_reserve - reserve slot in channel buffer
- *	@chan: relay channel
- *	@length: number of bytes to reserve
- *
- *	Returns pointer to reserved slot, NULL if full.
- *
- *	Reserves a slot in the current cpu's channel buffer.
- *	Does not protect the buffer at all - caller must provide
- *	appropriate synchronization.
+/*
+ * CONFIG_RELAY kernel API, kernel/relay.c
  */
-static inline void *relay_reserve(struct rchan *chan, size_t length)
-{
-	void *reserved;
-	struct rchan_buf *buf = chan->buf[smp_processor_id()];
-
-	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
-		length = relay_switch_subbuf(buf, length);
-		if (!length)
-			return NULL;
-	}
-	reserved = buf->data + buf->offset;
-	buf->offset += length;
 
-	return reserved;
-}
-
-/**
- *	subbuf_start_reserve - reserve bytes at the start of a sub-buffer
- *	@buf: relay channel buffer
- *	@length: number of bytes to reserve
- *
- *	Helper function used to reserve bytes at the beginning of
- *	a sub-buffer in the subbuf_start() callback.
- */
-static inline void subbuf_start_reserve(struct rchan_buf *buf,
-					size_t length)
-{
-	BUG_ON(length >= buf->chan->subbuf_size - 1);
-	buf->offset = length;
-}
+extern struct rchan *relay_open(const char *base_filename,
+				struct dentry *parent,
+				size_t n_pages_wakeup,
+				struct rchan_callbacks *cb,
+				void *private_data,
+				unsigned long rchan_flags);
+extern void relay_add_partial_page(struct rchan *chan,
+				   struct page *page,
+				   size_t len,
+				   struct relay_page_callbacks *cb,
+				   void *private_data);
+extern void relay_add_page(struct rchan *chan,
+			   struct page *page,
+			   struct relay_page_callbacks *cb,
+			   void *private_data);
+extern void relay_add_pages(struct rchan *chan,
+			    struct pagevec *pages,
+			    struct relay_page_callbacks *cb,
+			    void *private_data);
+extern void relay_flush(struct rchan *chan);
+extern void relay_close(struct rchan *chan);
+extern void relay_reset(struct rchan *chan);
 
 /*
  * exported relay file operations, kernel/relay.c
diff --git a/include/linux/relay_pagewriter.h b/include/linux/relay_pagewriter.h
new file mode 100644
index 0000000..efa5985
--- /dev/null
+++ b/include/linux/relay_pagewriter.h
@@ -0,0 +1,295 @@
+/*
+ * linux/include/linux/relay_pagewriter.h
+ *
+ * Copyright (C) 2002, 2003 - Tom Zanussi (zanussi@us.ibm.com), IBM Corp
+ * Copyright (C) 1999, 2000, 2001, 2002 - Karim Yaghmour (karim@opersys.com)
+ * Copyright (C) 2008 - Tom Zanussi (tzanussi@gmail.com)
+ *
+ * CONFIG_RELAY definitions and declarations
+ */
+
+#ifndef _LINUX_RELAY_PAGEWRITER_H
+#define _LINUX_RELAY_PAGEWRITER_H
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/kref.h>
+#include <linux/relay.h>
+
+/*
+ * pagewriter flags
+ */
+#define PAGEWRITER_PAD_WRITES		0x00010000	/* don't cross pages */
+#define PAGEWRITER_FLIGHT_MODE		0x00020000	/* n_pages page ring */
+#define PAGEWRITER_LATE_SETUP		0x00040000	/* delay chan create */
+
+/*
+ * Per-cpu pagewriter buffer
+ */
+struct pagewriter_buf {
+	struct relay_page *page;	/* current write page */
+	void *data;			/* address of current page */
+	size_t offset;			/* current offset into page */
+	struct pagewriter *pagewriter;	/* associated pagewriter */
+	struct kref kref;		/* channel buffer refcount */
+	struct list_head pool;		/* current set of unused pages */
+	struct list_head empty_rpage_structs;	/* cached rpage structs */
+	spinlock_t lock;		/* protect pool */
+	size_t n_pages_flight;		/* number full flight pages written */
+	unsigned int cpu;		/* this buf's cpu */
+	void *private_data;		/* for user-defined per-buf data */
+} ____cacheline_aligned;
+
+/*
+ * Pagewriter data structure
+ */
+struct pagewriter {
+	struct rchan *rchan;		/* associated relay channel */
+	struct pagewriter_callbacks *cb;	/* client callbacks */
+	size_t n_pages;			/* number of pages per buffer */
+	size_t n_pages_wakeup;		/* save for LATE */
+	struct kref kref;		/* channel refcount */
+	void *private_data;		/* for user-defined data */
+	struct pagewriter_buf *buf[NR_CPUS]; /* per-cpu channel buffers */
+	struct list_head list;		/* for channel list */
+	atomic_t dropped;		/* dropped events due to buffer-full */
+	char base_filename[NAME_MAX];	/* saved base filename, for LATE */
+	unsigned long flags;		/* pagewriter flags for this channel */
+	size_t end_reserve;		/* reserve at end of page for PAD  */
+};
+
+extern void pagewriter_pad_switch_page(struct pagewriter_buf *buf);
+extern void pagewriter_pad_flight_switch_page(struct pagewriter_buf *buf);
+extern void pagewriter_nopad_switch_page(struct pagewriter_buf *buf);
+extern void pagewriter_nopad_flight_switch_page(struct pagewriter_buf *buf);
+
+/*
+ * Pagewriter client callbacks
+ */
+struct pagewriter_callbacks {
+	/*
+	 * new_page - called on switch to a new page
+	 * @buf: the channel buffer containing the new page
+	 * @page_data: the start of the new page
+	 *
+	 * This is simply a notification that a new page has been
+	 * switched to.  The default version does nothing.  Clients
+	 * can use the channel private_data to track previous pages,
+	 * determine whether this is the first page, etc.
+	 *
+	 * NOTE: the client can reserve bytes at the beginning of the new
+	 *       page by calling page_start_reserve() in this callback.
+	 */
+	void (*new_page) (struct pagewriter_buf *buf,
+			  void *page_data);
+
+	/*
+	 * switch_page - page switch callback
+	 * @buf: the channel buffer
+	 *
+	 * This callback can be used to replace the complete write
+	 * path.  Normally clients wouldn't override this and would
+	 * use the default version instead.
+	 *
+	 * Switches to a new page and performs page-switch tasks.
+	 */
+	void (*switch_page)(struct pagewriter_buf *buf);
+
+	/*
+	 * write_padding - callback for writing padding events
+	 * @buf: the channel buffer
+	 * @length: the length of the padding
+	 * @reserved: a pointer to the start of padding
+	 *
+	 * This callback can be used to write a padding event when
+	 * pagewriter_reserve can't write a complete event.  The
+	 * length of the padding is guaranteed to be at least as large
+	 * as the end_reserve size passed into pagewriter_reserve().
+	 */
+	void (*write_padding)(struct pagewriter_buf *buf,
+			      size_t length,
+			      void *reserved);
+};
+
+/**
+ *	pagewriter_write - write data into the channel, without padding
+ *	@pagewriter: pagewriter
+ *	@data: data to be written
+ *	@length: number of bytes to write
+ *
+ *	Writes data into the current cpu's channel buffer, crossing
+ *	page boundaries.
+ *
+ *	Protects the buffer by disabling interrupts.  Use this if you
+ *	might be logging from interrupt context.  Try
+ *	__pagewriter_write() if you know you won't be logging from
+ *	interrupt context.
+ */
+static inline void pagewriter_write(struct pagewriter *pagewriter,
+				    const void *data,
+				    size_t length)
+{
+	size_t remainder = length;
+	struct pagewriter_buf *buf;
+	unsigned long flags;
+	void *reserved;
+
+	local_irq_save(flags);
+	buf = pagewriter->buf[smp_processor_id()];
+	reserved = buf->data + buf->offset;
+	if (buf->offset + length > PAGE_SIZE) {
+		if (!buf->data)
+			goto dropped;
+		if (length > PAGE_SIZE)
+			goto dropped;
+		remainder = length - (PAGE_SIZE - buf->offset);
+		pagewriter->cb->switch_page(buf);
+		if (!buf->data)
+			goto dropped;
+		length -= remainder;
+		memcpy(buf->data, data + length, remainder);
+	}
+	memcpy(reserved, data, length);
+	buf->offset += remainder;
+	local_irq_restore(flags);
+
+	return;
+dropped:
+	local_irq_restore(flags);
+	atomic_inc(&buf->pagewriter->dropped);
+}
+
+/**
+ *	__pagewriter_write - write data into the channel, without padding
+ *	@pagewriter: pagewriter
+ *	@data: data to be written
+ *	@length: number of bytes to write
+ *
+ *	Writes data into the current cpu's channel buffer, crossing
+ *	page boundaries.
+ *
+ *	Protects the buffer by disabling preemption.  Use
+ *	pagewriter_write() if you might be logging from interrupt
+ *	context.
+ */
+static inline void __pagewriter_write(struct pagewriter *pagewriter,
+				      const void *data,
+				      size_t length)
+{
+	size_t remainder = length;
+	struct pagewriter_buf *buf;
+	void *reserved;
+
+	buf = pagewriter->buf[get_cpu()];
+	reserved = buf->data + buf->offset;
+	if (buf->offset + length > PAGE_SIZE) {
+		if (!buf->data)
+			goto dropped;
+		if (length > PAGE_SIZE)
+			goto dropped;
+		remainder = length - (PAGE_SIZE - buf->offset);
+		pagewriter->cb->switch_page(buf);
+		if (!buf->data)
+			goto dropped;
+		length -= remainder;
+		memcpy(buf->data, data + length, remainder);
+	}
+	memcpy(reserved, data, length);
+	buf->offset += remainder;
+	put_cpu_no_resched();
+
+	return;
+dropped:
+	put_cpu_no_resched();
+	atomic_inc(&buf->pagewriter->dropped);
+}
+
+/**
+ *	pagewriter_reserve - reserve slot in channel buffer
+ *	@pagewriter: pagewriter
+ *	@length: number of bytes to reserve
+ *
+ *	Returns pointer to reserved slot, NULL if full.
+ *
+ *	Reserves a slot in the current cpu's channel buffer.
+ *	Does not protect the buffer at all - caller must provide
+ *	appropriate synchronization.
+ *
+ *	If the event won't fit, at least end_reserve bytes are
+ *	reserved for a padding event, and the write_padding() callback
+ *	function is called to allow the client to write the padding
+ *	event before switching to the next page.  The write_padding()
+ *	callback is passed a pointer to the start of the padding along
+ *	with its length.
+ */
+
+static inline void *pagewriter_reserve(struct pagewriter *pagewriter,
+				       size_t length)
+{
+	struct pagewriter_buf *buf;
+	void *reserved;
+
+	buf = pagewriter->buf[smp_processor_id()];
+	reserved = buf->data + buf->offset;
+	if (buf->offset + length > PAGE_SIZE - buf->pagewriter->end_reserve) {
+		size_t padding = PAGE_SIZE - buf->offset;
+		if (length != padding) {
+			if (!buf->data)
+				goto dropped;
+			if (length > PAGE_SIZE - buf->pagewriter->end_reserve)
+				goto dropped;
+			if (padding) {
+				reserved = buf->data + PAGE_SIZE - padding;
+				pagewriter->cb->write_padding(buf, padding,
+							      reserved);
+			}
+			pagewriter->cb->switch_page(buf);
+			if (!buf->data)
+				goto dropped;
+			reserved = buf->data;
+		}
+	}
+	buf->offset += length;
+
+	return reserved;
+dropped:
+	atomic_inc(&buf->pagewriter->dropped);
+	return NULL;
+}
+
+/**
+ *	page_start_reserve - reserve bytes at the start of a page
+ *	@buf: pagewriter channel buffer
+ *	@length: number of bytes to reserve
+ *
+ *	Helper function used to reserve bytes at the beginning of
+ *	a page in the new_page() callback.
+ */
+static inline void page_start_reserve(struct pagewriter_buf *buf,
+				      size_t length)
+{
+	BUG_ON(length >= PAGE_SIZE - buf->pagewriter->end_reserve - 1);
+	buf->offset = length;
+}
+
+extern struct pagewriter *pagewriter_open(const char *base_filename,
+					  struct dentry *parent,
+					  size_t n_pages,
+					  size_t n_pages_wakeup,
+					  size_t end_reserved,
+					  struct pagewriter_callbacks *cb,
+					  void *private_data,
+					  unsigned long rchan_flags);
+extern void pagewriter_flush(struct pagewriter *pagewriter);
+extern void pagewriter_close(struct pagewriter *pagewriter);
+extern void pagewriter_reset(struct pagewriter *pagewriter);
+extern void pagewriter_save_flight_data(struct pagewriter *pagewriter);
+extern int pagewriter_late_setup(struct pagewriter *pagewriter,
+				 struct dentry *parent);
+
+#endif /* _LINUX_RELAY_PAGEWRITER_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 066550a..81d28ce 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -80,7 +80,7 @@ obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
 ifeq ($(CONFIG_PREEMPT_RCU),y)
 obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
 endif
-obj-$(CONFIG_RELAY) += relay.o
+obj-$(CONFIG_RELAY) += relay.o relay_pagewriter.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
diff --git a/kernel/relay.c b/kernel/relay.c
index 8d13a78..04edb1d 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2002-2005 - Tom Zanussi (zanussi@us.ibm.com), IBM Corp
  * Copyright (C) 1999-2005 - Karim Yaghmour (karim@opersys.com)
+ * Copyright (C) 2008 - Tom Zanussi (tzanussi@gmail.com)
  *
  * Moved to kernel/relay.c by Paul Mundt, 2006.
  * November 2006 - CPU hotplug support by Mathieu Desnoyers
@@ -18,400 +19,431 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/relay.h>
-#include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/cpu.h>
 #include <linux/splice.h>
+#include <linux/debugfs.h>
 
 /* list of open channels, for cpu hotplug */
 static DEFINE_MUTEX(relay_channels_mutex);
 static LIST_HEAD(relay_channels);
 
+/* forward declarations */
+static void setup_callbacks(struct rchan *chan, struct rchan_callbacks *cb);
+static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu);
+static inline void relay_wakeup_readers(struct rchan_buf *buf);
+static void relay_close_buf(struct rchan_buf *buf);
+static void relay_destroy_channel(struct kref *kref);
+static inline struct relay_page *__relay_get_rpage(struct rchan_buf *buf);
+static inline void __relay_add_page(struct rchan_buf *buf,
+				    struct relay_page *rpage);
+static inline void __relay_add_page_nolock(struct rchan_buf *buf,
+					   struct relay_page *rpage);
+static void __relay_reset(struct rchan_buf *buf, unsigned int init);
+
 /*
- * close() vm_op implementation for relay file mapping.
+ * relay kernel API
  */
-static void relay_file_mmap_close(struct vm_area_struct *vma)
-{
-	struct rchan_buf *buf = vma->vm_private_data;
-	buf->chan->cb->buf_unmapped(buf, vma->vm_file);
-}
 
-/*
- * fault() vm_op implementation for relay file mapping.
+/**
+ *	relay_open - create a new relay channel
+ *	@base_filename: base name of files to create, %NULL for buffering only
+ *	@parent: dentry of parent directory, %NULL for root directory or buffer
+ *	@n_pages_wakeup: wakeup readers after this many pages, 0 means never
+ *	@cb: client callback functions
+ *	@private_data: user-defined data
+ *	@flags: relay channel flags
+ *
+ *	Returns channel pointer if successful, %NULL otherwise.
+ *
+ *	Creates per-cpu channel lists (or a single list if the
+ *	RCHAN_GLOBAL_BUFFER flag is used) to receive pages from
+ *	tracers via relay_add_page()/relay_add_pages().  These lists
+ *	will be drained by userspace via read(2), splice(2), or
+ *	sendfile(2).  Pages added to relay will be either returned to
+ *	their owners after userspace has finished reading them or the
+ *	owners will be notified if they've been stolen (see
+ *	relay_add_page).
+ *
+ *	buffer files will be named base_filename0...base_filenameN-1.
+ *	File permissions will be %S_IRUSR.
  */
-static int relay_buf_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+struct rchan *relay_open(const char *base_filename,
+			 struct dentry *parent,
+			 size_t n_pages_wakeup,
+			 struct rchan_callbacks *cb,
+			 void *private_data,
+			 unsigned long rchan_flags)
 {
-	struct page *page;
-	struct rchan_buf *buf = vma->vm_private_data;
-	pgoff_t pgoff = vmf->pgoff;
+	unsigned int i;
+	struct rchan *chan;
 
-	if (!buf)
-		return VM_FAULT_OOM;
+	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
+	if (!chan)
+		return NULL;
 
-	page = vmalloc_to_page(buf->start + (pgoff << PAGE_SHIFT));
-	if (!page)
-		return VM_FAULT_SIGBUS;
-	get_page(page);
-	vmf->page = page;
+	chan->n_pages_wakeup = n_pages_wakeup;
+	chan->parent = parent;
+	chan->flags = rchan_flags;
 
-	return 0;
-}
+	chan->private_data = private_data;
+	strlcpy(chan->base_filename, base_filename, NAME_MAX);
 
-/*
- * vm_ops for relay file mappings.
- */
-static struct vm_operations_struct relay_file_mmap_ops = {
-	.fault = relay_buf_fault,
-	.close = relay_file_mmap_close,
-};
+	setup_callbacks(chan, cb);
+	kref_init(&chan->kref);
 
-/*
- * allocate an array of pointers of struct page
- */
-static struct page **relay_alloc_page_array(unsigned int n_pages)
-{
-	struct page **array;
-	size_t pa_size = n_pages * sizeof(struct page *);
-
-	if (pa_size > PAGE_SIZE) {
-		array = vmalloc(pa_size);
-		if (array)
-			memset(array, 0, pa_size);
-	} else {
-		array = kzalloc(pa_size, GFP_KERNEL);
+	mutex_lock(&relay_channels_mutex);
+	for_each_online_cpu(i) {
+		chan->buf[i] = relay_open_buf(chan, i);
+		if (!chan->buf[i])
+			goto free_bufs;
 	}
-	return array;
+	list_add(&chan->list, &relay_channels);
+	mutex_unlock(&relay_channels_mutex);
+
+	return chan;
+
+free_bufs:
+	for_each_online_cpu(i) {
+		if (!chan->buf[i])
+			break;
+		relay_close_buf(chan->buf[i]);
+	}
+
+	kref_put(&chan->kref, relay_destroy_channel);
+	mutex_unlock(&relay_channels_mutex);
+	return NULL;
 }
+EXPORT_SYMBOL_GPL(relay_open);
 
-/*
- * free an array of pointers of struct page
- */
-static void relay_free_page_array(struct page **array)
-{
-	if (is_vmalloc_addr(array))
-		vfree(array);
-	else
-		kfree(array);
+/**
+ *	relay_add_partial_page - add a partial page to relay
+ *	@chan: the relay channel
+ *	@page: the page to add
+ *	@len: the length of data in the page
+ *	@cb: relay_page callbacks associated with the page
+ *	@private_data: user data to be associated with the relay_page
+ *
+ *	Add a partial page to relay, meaning a page containing <=
+ *	PAGE_SIZE bytes.  See comments for relay_add_page(); this is
+ *	the same except that it allows the length of data contained in
+ *	the page to be specified, if it contains less than a page's
+ *	worth (or even if it contains a full page's worth -
+ *	relay_add_page() actually calls this internally.).
+ */
+void relay_add_partial_page(struct rchan *chan,
+			    struct page *page,
+			    size_t len,
+			    struct relay_page_callbacks *cb,
+			    void *private_data)
+{
+	struct relay_page *rpage;
+	struct rchan_buf *buf;
+
+	buf = chan->buf[get_cpu()];
+	put_cpu_no_resched();
+	rpage = __relay_get_rpage(buf);
+
+	if (likely(rpage)) {
+		rpage->page = page;
+		rpage->len = len;
+		set_page_private(rpage->page, (unsigned long)buf);
+		rpage->cb = cb;
+		rpage->private_data = private_data;
+		__relay_add_page(buf, rpage);
+	}
 }
+EXPORT_SYMBOL_GPL(relay_add_partial_page);
 
 /**
- *	relay_mmap_buf: - mmap channel buffer to process address space
- *	@buf: relay channel buffer
- *	@vma: vm_area_struct describing memory to be mapped
- *
- *	Returns 0 if ok, negative on error
+ *	relay_add_page - add a page to relay
+ *	@chan: the relay channel
+ *	@page: the page to add
+ *	@cb: relay_page callbacks associated with the page
+ *	@private_data: user data to be associated with the relay_page
  *
- *	Caller should already have grabbed mmap_sem.
+ *	Add a page to relay.  When the page has been read by
+ *	userspace, the owner will be notified.  If the page has been
+ *	copied and is available for re-use by the owner, the
+ *	relay_page_callbacks page_released() callback will be invoked.
+ *	If the page has been stolen, the owner will be notified of
+ *	this fact via the page_stolen() callback; because the
+ *	page_stolen() (and page_released()) callbacks are called from
+ *	user context, the owner can allocate a new page using
+ *	GFP_KERNEL if it wants to.
  */
-static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
+void relay_add_page(struct rchan *chan,
+		    struct page *page,
+		    struct relay_page_callbacks *cb,
+		    void *private_data)
 {
-	unsigned long length = vma->vm_end - vma->vm_start;
-	struct file *filp = vma->vm_file;
-
-	if (!buf)
-		return -EBADF;
+	relay_add_partial_page(chan, page, PAGE_SIZE, cb, private_data);
+}
+EXPORT_SYMBOL_GPL(relay_add_page);
 
-	if (length != (unsigned long)buf->chan->alloc_size)
-		return -EINVAL;
+/**
+ *	relay_add_pages - add a set of pages to relay
+ *	@chan: the relay channel
+ *	@pages: the pages to add
+ *	@cb: relay_page callbacks associated with the pages
+ *	@private_data: user data to be associated with the relay_pages
+ *
+ *	Add a set of pages to relay.  The added pages are guaranteed
+ *	to be inserted together as a group and in the same order as in
+ *	the pagevec.  The comments for relay_add_page() apply in the
+ *	same way to relay_add_pages().
+ */
+void relay_add_pages(struct rchan *chan,
+		     struct pagevec *pages,
+		     struct relay_page_callbacks *cb,
+		     void *private_data)
+{
+	int i, nr_pages = pagevec_count(pages);
+	struct relay_page *rpage;
+	struct rchan_buf *buf;
+	unsigned long flags;
 
-	vma->vm_ops = &relay_file_mmap_ops;
-	vma->vm_flags |= VM_DONTEXPAND;
-	vma->vm_private_data = buf;
-	buf->chan->cb->buf_mapped(buf, filp);
+	buf = chan->buf[get_cpu()];
+	put_cpu_no_resched();
+	spin_lock_irqsave(&buf->lock, flags);
+	for (i = 0; i < nr_pages; i--) {
+		rpage = __relay_get_rpage(buf);
+
+		if (likely(rpage)) {
+			rpage->page = pages->pages[i];
+			rpage->len = PAGE_SIZE;
+			set_page_private(rpage->page, (unsigned long)buf);
+			rpage->cb = cb;
+			rpage->private_data = private_data;
+			__relay_add_page_nolock(buf, rpage);
+		}
+	}
+	spin_unlock_irqrestore(&buf->lock, flags);
 
-	return 0;
+	relay_wakeup_readers(buf);
 }
+EXPORT_SYMBOL_GPL(relay_add_pages);
 
 /**
- *	relay_alloc_buf - allocate a channel buffer
- *	@buf: the buffer struct
- *	@size: total size of the buffer
+ *	relay_flush - flush the channel
+ *	@chan: the channel
  *
- *	Returns a pointer to the resulting buffer, %NULL if unsuccessful. The
- *	passed in size will get page aligned, if it isn't already.
+ *	Flushes all channel buffers, i.e. wakes up readers
  */
-static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
+void relay_flush(struct rchan *chan)
 {
-	void *mem;
-	unsigned int i, j, n_pages;
+	unsigned int i;
+	size_t prev_wakeup = chan->n_pages_wakeup;
 
-	*size = PAGE_ALIGN(*size);
-	n_pages = *size >> PAGE_SHIFT;
+	if (!chan)
+		return;
 
-	buf->page_array = relay_alloc_page_array(n_pages);
-	if (!buf->page_array)
-		return NULL;
+	if (prev_wakeup)
+		chan->n_pages_wakeup = 1;
 
-	for (i = 0; i < n_pages; i++) {
-		buf->page_array[i] = alloc_page(GFP_KERNEL);
-		if (unlikely(!buf->page_array[i]))
-			goto depopulate;
-		set_page_private(buf->page_array[i], (unsigned long)buf);
+	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
+		chan->n_pages_wakeup = prev_wakeup;
+		return;
 	}
-	mem = vmap(buf->page_array, n_pages, VM_MAP, PAGE_KERNEL);
-	if (!mem)
-		goto depopulate;
-
-	memset(mem, 0, *size);
-	buf->page_count = n_pages;
-	return mem;
-
-depopulate:
-	for (j = 0; j < i; j++)
-		__free_page(buf->page_array[j]);
-	relay_free_page_array(buf->page_array);
-	return NULL;
+
+	mutex_lock(&relay_channels_mutex);
+	for_each_possible_cpu(i)
+		if (chan->buf[i])
+			relay_wakeup_readers(chan->buf[i]);
+	mutex_unlock(&relay_channels_mutex);
+	chan->n_pages_wakeup = prev_wakeup;
 }
+EXPORT_SYMBOL_GPL(relay_flush);
 
 /**
- *	relay_create_buf - allocate and initialize a channel buffer
- *	@chan: the relay channel
+ *	relay_close - close the channel
+ *	@chan: the channel
  *
- *	Returns channel buffer if successful, %NULL otherwise.
+ *	Closes all channel buffers and frees the channel.
  */
-static struct rchan_buf *relay_create_buf(struct rchan *chan)
+void relay_close(struct rchan *chan)
 {
-	struct rchan_buf *buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
-	if (!buf)
-		return NULL;
-
-	buf->padding = kmalloc(chan->n_subbufs * sizeof(size_t *), GFP_KERNEL);
-	if (!buf->padding)
-		goto free_buf;
+	unsigned int i;
 
-	buf->start = relay_alloc_buf(buf, &chan->alloc_size);
-	if (!buf->start)
-		goto free_buf;
+	if (!chan)
+		return;
 
-	buf->chan = chan;
-	kref_get(&buf->chan->kref);
-	return buf;
+	mutex_lock(&relay_channels_mutex);
+	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0])
+		relay_close_buf(chan->buf[0]);
+	else
+		for_each_possible_cpu(i)
+			if (chan->buf[i])
+				relay_close_buf(chan->buf[i]);
 
-free_buf:
-	kfree(buf->padding);
-	kfree(buf);
-	return NULL;
+	list_del(&chan->list);
+	kref_put(&chan->kref, relay_destroy_channel);
+	mutex_unlock(&relay_channels_mutex);
 }
+EXPORT_SYMBOL_GPL(relay_close);
 
 /**
- *	relay_destroy_channel - free the channel struct
- *	@kref: target kernel reference that contains the relay channel
+ *	relay_reset - reset the channel
+ *	@chan: the channel
  *
- *	Should only be called from kref_put().
- */
-static void relay_destroy_channel(struct kref *kref)
-{
-	struct rchan *chan = container_of(kref, struct rchan, kref);
-	kfree(chan);
-}
-
-/**
- *	relay_destroy_buf - destroy an rchan_buf struct and associated buffer
- *	@buf: the buffer struct
+ *	This has the effect of erasing all data from all channel buffers
+ *	and restarting the channel in its initial state.
+ *
+ *	NOTE. Care should be taken that the channel isn't actually
+ *	being used by anything when this call is made.
  */
-static void relay_destroy_buf(struct rchan_buf *buf)
+void relay_reset(struct rchan *chan)
 {
-	struct rchan *chan = buf->chan;
 	unsigned int i;
 
-	if (likely(buf->start)) {
-		vunmap(buf->start);
-		for (i = 0; i < buf->page_count; i++)
-			__free_page(buf->page_array[i]);
-		relay_free_page_array(buf->page_array);
+	if (!chan)
+		return;
+
+	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
+		__relay_reset(chan->buf[0], 0);
+		return;
 	}
-	chan->buf[buf->cpu] = NULL;
-	kfree(buf->padding);
-	kfree(buf);
-	kref_put(&chan->kref, relay_destroy_channel);
+
+	mutex_lock(&relay_channels_mutex);
+	for_each_online_cpu(i)
+		if (chan->buf[i])
+			__relay_reset(chan->buf[i], 0);
+	mutex_unlock(&relay_channels_mutex);
 }
+EXPORT_SYMBOL_GPL(relay_reset);
 
-/**
- *	relay_remove_buf - remove a channel buffer
- *	@kref: target kernel reference that contains the relay buffer
- *
- *	Removes the file from the fileystem, which also frees the
- *	rchan_buf_struct and the channel buffer.  Should only be called from
- *	kref_put().
+/*
+ * end relay kernel API
  */
-static void relay_remove_buf(struct kref *kref)
-{
-	struct rchan_buf *buf = container_of(kref, struct rchan_buf, kref);
-	buf->chan->cb->remove_buf_file(buf->dentry);
-	relay_destroy_buf(buf);
-}
 
 /**
- *	relay_buf_empty - boolean, is the channel buffer empty?
- *	@buf: channel buffer
- *
- *	Returns 1 if the buffer is empty, 0 otherwise.
+ *	relay_update_filesize - increase relay file i_size by length
+ *	@buf: relay channel buffer
+ *	@length: length to add
  */
-static int relay_buf_empty(struct rchan_buf *buf)
+static inline void relay_update_filesize(struct rchan_buf *buf, size_t length)
 {
-	return (buf->subbufs_produced - buf->subbufs_consumed) ? 0 : 1;
+	buf->dentry->d_inode->i_size +=	length;
 }
 
 /**
- *	relay_buf_full - boolean, is the channel buffer full?
- *	@buf: channel buffer
- *
- *	Returns 1 if the buffer is full, 0 otherwise.
+ *	__relay_get_rpage - get an empty relay page struct
+ *	@buf: the buffer struct
  */
-int relay_buf_full(struct rchan_buf *buf)
+static inline struct relay_page *__relay_get_rpage(struct rchan_buf *buf)
 {
-	size_t ready = buf->subbufs_produced - buf->subbufs_consumed;
-	return (ready >= buf->chan->n_subbufs) ? 1 : 0;
+	return kmalloc(sizeof(struct relay_page), GFP_ATOMIC);
 }
-EXPORT_SYMBOL_GPL(relay_buf_full);
-
-/*
- * High-level relay kernel API and associated functions.
- */
 
-/*
- * rchan_callback implementations defining default channel behavior.  Used
- * in place of corresponding NULL values in client callback struct.
- */
-
-/*
- * subbuf_start() default callback.  Does nothing.
- */
-static int subbuf_start_default_callback (struct rchan_buf *buf,
-					  void *subbuf,
-					  void *prev_subbuf,
-					  size_t prev_padding)
+static inline void __relay_add_page_nolock(struct rchan_buf *buf,
+					   struct relay_page *rpage)
 {
-	if (relay_buf_full(buf))
-		return 0;
-
-	return 1;
+	list_add_tail(&rpage->list, &buf->pages);
+	buf->nr_pages++;
+	relay_update_filesize(buf, rpage->len);
 }
 
-/*
- * buf_mapped() default callback.  Does nothing.
- */
-static void buf_mapped_default_callback(struct rchan_buf *buf,
-					struct file *filp)
+static inline void __relay_add_page(struct rchan_buf *buf,
+				    struct relay_page *rpage)
 {
-}
+	unsigned long flags;
 
-/*
- * buf_unmapped() default callback.  Does nothing.
- */
-static void buf_unmapped_default_callback(struct rchan_buf *buf,
-					  struct file *filp)
-{
+	spin_lock_irqsave(&buf->lock, flags);
+	__relay_add_page_nolock(buf, rpage);
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	relay_wakeup_readers(buf);
 }
 
-/*
- * create_buf_file_create() default callback.  Does nothing.
+/**
+ *	__relay_remove_page - remove a page from relay
+ *	@buf: the buffer struct
+ *	@rpage: struct relay_page
  */
-static struct dentry *create_buf_file_default_callback(const char *filename,
-						       struct dentry *parent,
-						       int mode,
-						       struct rchan_buf *buf,
-						       int *is_global)
+static void __relay_remove_page(struct rchan_buf *buf,
+				struct relay_page *rpage)
 {
-	return NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	list_del(&rpage->list);
+	buf->nr_pages--;
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	kfree(rpage);
 }
 
-/*
- * remove_buf_file() default callback.  Does nothing.
+/**
+ *	__relay_release_page - remove page from relay and notify owner
+ *	@buf: the buffer struct
+ *	@rpage: struct relay_page
  */
-static int remove_buf_file_default_callback(struct dentry *dentry)
+static void __relay_release_page(struct rchan_buf *buf,
+				 struct relay_page *rpage)
 {
-	return -EINVAL;
-}
+	if (rpage->cb && rpage->cb->page_released)
+		rpage->cb->page_released(rpage->page, rpage->private_data);
 
-/* relay channel default callbacks */
-static struct rchan_callbacks default_channel_callbacks = {
-	.subbuf_start = subbuf_start_default_callback,
-	.buf_mapped = buf_mapped_default_callback,
-	.buf_unmapped = buf_unmapped_default_callback,
-	.create_buf_file = create_buf_file_default_callback,
-	.remove_buf_file = remove_buf_file_default_callback,
-};
+	__relay_remove_page(buf, rpage);
+}
 
 /**
- *	wakeup_readers - wake up readers waiting on a channel
- *	@data: contains the channel buffer
+ *	relay_destroy_channel - free the channel struct
+ *	@kref: target kernel reference that contains the relay channel
  *
- *	This is the timer function used to defer reader waking.
+ *	Should only be called from kref_put().
  */
-static void wakeup_readers(unsigned long data)
+static void relay_destroy_channel(struct kref *kref)
 {
-	struct rchan_buf *buf = (struct rchan_buf *)data;
-	wake_up_interruptible(&buf->read_wait);
+	struct rchan *chan = container_of(kref, struct rchan, kref);
+	kfree(chan);
 }
 
 /**
- *	__relay_reset - reset a channel buffer
- *	@buf: the channel buffer
- *	@init: 1 if this is a first-time initialization
- *
- *	See relay_reset() for description of effect.
+ *	relay_destroy_buf - destroy an rchan_buf struct and release pages
+ *	@buf: the buffer struct
  */
-static void __relay_reset(struct rchan_buf *buf, unsigned int init)
+static void relay_destroy_buf(struct rchan_buf *buf)
 {
-	size_t i;
-
-	if (init) {
-		init_waitqueue_head(&buf->read_wait);
-		kref_init(&buf->kref);
-		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
-	} else
-		del_timer_sync(&buf->timer);
-
-	buf->subbufs_produced = 0;
-	buf->subbufs_consumed = 0;
-	buf->bytes_consumed = 0;
-	buf->finalized = 0;
-	buf->data = buf->start;
-	buf->offset = 0;
+	struct rchan *chan = buf->chan;
+	struct relay_page *rpage, *rpage2;
 
-	for (i = 0; i < buf->chan->n_subbufs; i++)
-		buf->padding[i] = 0;
+	list_for_each_entry_safe(rpage, rpage2, &buf->pages, list)
+		__relay_release_page(buf, rpage);
 
-	buf->chan->cb->subbuf_start(buf, buf->data, NULL, 0);
+	chan->buf[buf->cpu] = NULL;
+	kfree(buf);
+	kref_put(&chan->kref, relay_destroy_channel);
 }
 
 /**
- *	relay_reset - reset the channel
- *	@chan: the channel
- *
- *	This has the effect of erasing all data from all channel buffers
- *	and restarting the channel in its initial state.  The buffers
- *	are not freed, so any mappings are still in effect.
+ *	relay_remove_buf - remove a channel buffer
+ *	@kref: target kernel reference that contains the relay buffer
  *
- *	NOTE. Care should be taken that the channel isn't actually
- *	being used by anything when this call is made.
+ *	Removes the file from the fileystem, which also frees the
+ *	rchan_buf_struct and the channel buffer.  Should only be called from
+ *	kref_put().
  */
-void relay_reset(struct rchan *chan)
+static void relay_remove_buf(struct kref *kref)
 {
-	unsigned int i;
-
-	if (!chan)
-		return;
-
-	if (chan->is_global && chan->buf[0]) {
-		__relay_reset(chan->buf[0], 0);
-		return;
-	}
-
-	mutex_lock(&relay_channels_mutex);
-	for_each_online_cpu(i)
-		if (chan->buf[i])
-			__relay_reset(chan->buf[i], 0);
-	mutex_unlock(&relay_channels_mutex);
+	struct rchan_buf *buf = container_of(kref, struct rchan_buf, kref);
+	buf->chan->cb->remove_buf_file(buf->dentry);
+	relay_destroy_buf(buf);
 }
-EXPORT_SYMBOL_GPL(relay_reset);
 
-static inline void relay_set_buf_dentry(struct rchan_buf *buf,
-					struct dentry *dentry)
+/**
+ *	relay_close_buf - close a channel buffer
+ *	@buf: channel buffer
+ *
+ *	Marks the buffer finalized.  The channel buffer and channel
+ *	buffer data structure are then freed automatically when the
+ *	last reference is given up.
+ */
+static void relay_close_buf(struct rchan_buf *buf)
 {
-	buf->dentry = dentry;
-	buf->dentry->d_inode->i_size = buf->early_bytes;
+	buf->finalized = 1;
+	del_timer_sync(&buf->timer);
+	kref_put(&buf->kref, relay_remove_buf);
 }
 
 static struct dentry *relay_create_buf_file(struct rchan *chan,
@@ -428,14 +460,33 @@ static struct dentry *relay_create_buf_file(struct rchan *chan,
 
 	/* Create file in fs */
 	dentry = chan->cb->create_buf_file(tmpname, chan->parent,
-					   S_IRUSR, buf,
-					   &chan->is_global);
+					   S_IRUSR, buf);
 
 	kfree(tmpname);
 
 	return dentry;
 }
 
+/**
+ *	relay_create_buf - allocate and initialize a channel buffer
+ *	@chan: the relay channel
+ *
+ *	Returns channel buffer if successful, %NULL otherwise.
+ */
+static struct rchan_buf *relay_create_buf(struct rchan *chan)
+{
+	struct rchan_buf *buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	spin_lock_init(&buf->lock);
+	INIT_LIST_HEAD(&buf->pages);
+	buf->chan = chan;
+	kref_get(&buf->chan->kref);
+
+	return buf;
+}
+
 /*
  *	relay_open_buf - create a new relay channel buffer
  *
@@ -446,24 +497,23 @@ static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
  	struct rchan_buf *buf = NULL;
 	struct dentry *dentry;
 
- 	if (chan->is_global)
+	if (chan->flags & RCHAN_GLOBAL_BUFFER)
 		return chan->buf[0];
 
 	buf = relay_create_buf(chan);
 	if (!buf)
 		return NULL;
 
-	if (chan->has_base_filename) {
-		dentry = relay_create_buf_file(chan, buf, cpu);
-		if (!dentry)
-			goto free_buf;
-		relay_set_buf_dentry(buf, dentry);
-	}
+	dentry = relay_create_buf_file(chan, buf, cpu);
+	if (!dentry)
+		goto free_buf;
+	buf->dentry = dentry;
+	buf->dentry->d_inode->i_size = 0;
 
  	buf->cpu = cpu;
  	__relay_reset(buf, 1);
 
- 	if(chan->is_global) {
+	if (chan->flags & RCHAN_GLOBAL_BUFFER) {
  		chan->buf[0] = buf;
  		buf->cpu = 0;
   	}
@@ -476,393 +526,109 @@ free_buf:
 }
 
 /**
- *	relay_close_buf - close a channel buffer
- *	@buf: channel buffer
+ *	relay_wakeup_readers - wake up readers if applicable
+ *	@buf: relay channel buffer
  *
- *	Marks the buffer finalized and restores the default callbacks.
- *	The channel buffer and channel buffer data structure are then freed
- *	automatically when the last reference is given up.
+ *	Will wake up readers after each buf->n_pages_wakeup pages have
+ *	been produced.  To do no waking up, simply pass 0 into relay
+ *	open for this value.
  */
-static void relay_close_buf(struct rchan_buf *buf)
+static inline void relay_wakeup_readers(struct rchan_buf *buf)
 {
-	buf->finalized = 1;
-	del_timer_sync(&buf->timer);
-	kref_put(&buf->kref, relay_remove_buf);
-}
+	size_t wakeup = buf->chan->n_pages_wakeup;
 
-static void setup_callbacks(struct rchan *chan,
-				   struct rchan_callbacks *cb)
-{
-	if (!cb) {
-		chan->cb = &default_channel_callbacks;
-		return;
-	}
-
-	if (!cb->subbuf_start)
-		cb->subbuf_start = subbuf_start_default_callback;
-	if (!cb->buf_mapped)
-		cb->buf_mapped = buf_mapped_default_callback;
-	if (!cb->buf_unmapped)
-		cb->buf_unmapped = buf_unmapped_default_callback;
-	if (!cb->create_buf_file)
-		cb->create_buf_file = create_buf_file_default_callback;
-	if (!cb->remove_buf_file)
-		cb->remove_buf_file = remove_buf_file_default_callback;
-	chan->cb = cb;
+	if (wakeup && (buf->nr_pages % wakeup == 0) &&
+	    (waitqueue_active(&buf->read_wait)))
+		/*
+		 * Calling wake_up_interruptible() from here
+		 * will deadlock if we happen to be logging
+		 * from the scheduler (trying to re-grab
+		 * rq->lock), so defer it.
+		 */
+		__mod_timer(&buf->timer, jiffies + 1);
 }
 
 /**
- * 	relay_hotcpu_callback - CPU hotplug callback
- * 	@nb: notifier block
- * 	@action: hotplug action to take
- * 	@hcpu: CPU number
+ *	wakeup_readers - wake up readers waiting on a channel
+ *	@data: contains the channel buffer
  *
- * 	Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
+ *	This is the timer function used to defer reader waking.
  */
-static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
-				unsigned long action,
-				void *hcpu)
+static void wakeup_readers(unsigned long data)
 {
-	unsigned int hotcpu = (unsigned long)hcpu;
-	struct rchan *chan;
-
-	switch(action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		mutex_lock(&relay_channels_mutex);
-		list_for_each_entry(chan, &relay_channels, list) {
-			if (chan->buf[hotcpu])
-				continue;
-			chan->buf[hotcpu] = relay_open_buf(chan, hotcpu);
-			if(!chan->buf[hotcpu]) {
-				printk(KERN_ERR
-					"relay_hotcpu_callback: cpu %d buffer "
-					"creation failed\n", hotcpu);
-				mutex_unlock(&relay_channels_mutex);
-				return NOTIFY_BAD;
-			}
-		}
-		mutex_unlock(&relay_channels_mutex);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		/* No need to flush the cpu : will be flushed upon
-		 * final relay_flush() call. */
-		break;
-	}
-	return NOTIFY_OK;
+	struct rchan_buf *buf = (struct rchan_buf *)data;
+	wake_up_interruptible(&buf->read_wait);
 }
 
 /**
- *	relay_open - create a new relay channel
- *	@base_filename: base name of files to create, %NULL for buffering only
- *	@parent: dentry of parent directory, %NULL for root directory or buffer
- *	@subbuf_size: size of sub-buffers
- *	@n_subbufs: number of sub-buffers
- *	@cb: client callback functions
- *	@private_data: user-defined data
- *
- *	Returns channel pointer if successful, %NULL otherwise.
+ *	__relay_reset - reset a channel buffer
+ *	@buf: the channel buffer
+ *	@init: 1 if this is a first-time initialization
  *
- *	Creates a channel buffer for each cpu using the sizes and
- *	attributes specified.  The created channel buffer files
- *	will be named base_filename0...base_filenameN-1.  File
- *	permissions will be %S_IRUSR.
+ *	See relay_reset() for description of effect.
  */
-struct rchan *relay_open(const char *base_filename,
-			 struct dentry *parent,
-			 size_t subbuf_size,
-			 size_t n_subbufs,
-			 struct rchan_callbacks *cb,
-			 void *private_data)
+static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 {
-	unsigned int i;
-	struct rchan *chan;
-
-	if (!(subbuf_size && n_subbufs))
-		return NULL;
-
-	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
-	if (!chan)
-		return NULL;
-
-	chan->version = RELAYFS_CHANNEL_VERSION;
-	chan->n_subbufs = n_subbufs;
-	chan->subbuf_size = subbuf_size;
-	chan->alloc_size = FIX_SIZE(subbuf_size * n_subbufs);
-	chan->parent = parent;
-	chan->private_data = private_data;
-	if (base_filename) {
-		chan->has_base_filename = 1;
-		strlcpy(chan->base_filename, base_filename, NAME_MAX);
-	}
-	setup_callbacks(chan, cb);
-	kref_init(&chan->kref);
-
-	mutex_lock(&relay_channels_mutex);
-	for_each_online_cpu(i) {
-		chan->buf[i] = relay_open_buf(chan, i);
-		if (!chan->buf[i])
-			goto free_bufs;
-	}
-	list_add(&chan->list, &relay_channels);
-	mutex_unlock(&relay_channels_mutex);
-
-	return chan;
-
-free_bufs:
-	for_each_online_cpu(i) {
-		if (!chan->buf[i])
-			break;
-		relay_close_buf(chan->buf[i]);
-	}
+	struct relay_page *rpage, *rpage2;
 
-	kref_put(&chan->kref, relay_destroy_channel);
-	mutex_unlock(&relay_channels_mutex);
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(relay_open);
-
-struct rchan_percpu_buf_dispatcher {
-	struct rchan_buf *buf;
-	struct dentry *dentry;
-};
+	if (init) {
+		init_waitqueue_head(&buf->read_wait);
+		kref_init(&buf->kref);
+		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
+	} else
+		del_timer_sync(&buf->timer);
 
-/* Called in atomic context. */
-static void __relay_set_buf_dentry(void *info)
-{
-	struct rchan_percpu_buf_dispatcher *p = info;
+	list_for_each_entry_safe(rpage, rpage2, &buf->pages, list)
+		__relay_release_page(buf, rpage);
 
-	relay_set_buf_dentry(p->buf, p->dentry);
+	buf->consumed_offset = 0;
+	buf->finalized = 0;
 }
 
-/**
- *	relay_late_setup_files - triggers file creation
- *	@chan: channel to operate on
- *	@base_filename: base name of files to create
- *	@parent: dentry of parent directory, %NULL for root directory
- *
- *	Returns 0 if successful, non-zero otherwise.
- *
- *	Use to setup files for a previously buffer-only channel.
- *	Useful to do early tracing in kernel, before VFS is up, for example.
+/*
+ * create_buf_file_create() default callback.  Creates debugfs file.
  */
-int relay_late_setup_files(struct rchan *chan,
-			   const char *base_filename,
-			   struct dentry *parent)
+static struct dentry *create_buf_file_default_callback(const char *filename,
+						       struct dentry *parent,
+						       int mode,
+						       struct rchan_buf *buf)
 {
-	int err = 0;
-	unsigned int i, curr_cpu;
-	unsigned long flags;
-	struct dentry *dentry;
-	struct rchan_percpu_buf_dispatcher disp;
-
-	if (!chan || !base_filename)
-		return -EINVAL;
-
-	strlcpy(chan->base_filename, base_filename, NAME_MAX);
-
-	mutex_lock(&relay_channels_mutex);
-	/* Is chan already set up? */
-	if (unlikely(chan->has_base_filename))
-		return -EEXIST;
-	chan->has_base_filename = 1;
-	chan->parent = parent;
-	curr_cpu = get_cpu();
-	/*
-	 * The CPU hotplug notifier ran before us and created buffers with
-	 * no files associated. So it's safe to call relay_setup_buf_file()
-	 * on all currently online CPUs.
-	 */
-	for_each_online_cpu(i) {
-		if (unlikely(!chan->buf[i])) {
-			printk(KERN_ERR "relay_late_setup_files: CPU %u "
-					"has no buffer, it must have!\n", i);
-			BUG();
-			err = -EINVAL;
-			break;
-		}
-
-		dentry = relay_create_buf_file(chan, chan->buf[i], i);
-		if (unlikely(!dentry)) {
-			err = -EINVAL;
-			break;
-		}
-
-		if (curr_cpu == i) {
-			local_irq_save(flags);
-			relay_set_buf_dentry(chan->buf[i], dentry);
-			local_irq_restore(flags);
-		} else {
-			disp.buf = chan->buf[i];
-			disp.dentry = dentry;
-			smp_mb();
-			/* relay_channels_mutex must be held, so wait. */
-			err = smp_call_function_single(i,
-						       __relay_set_buf_dentry,
-						       &disp, 1);
-		}
-		if (unlikely(err))
-			break;
-	}
-	put_cpu();
-	mutex_unlock(&relay_channels_mutex);
-
-	return err;
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
 }
 
-/**
- *	relay_switch_subbuf - switch to a new sub-buffer
- *	@buf: channel buffer
- *	@length: size of current event
- *
- *	Returns either the length passed in or 0 if full.
- *
- *	Performs sub-buffer-switch tasks such as invoking callbacks,
- *	updating padding counts, waking up readers, etc.
+/*
+ * remove_buf_file() default callback.  Removes debugfs file.
  */
-size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
+static int remove_buf_file_default_callback(struct dentry *dentry)
 {
-	void *old, *new;
-	size_t old_subbuf, new_subbuf;
-
-	if (unlikely(length > buf->chan->subbuf_size))
-		goto toobig;
-
-	if (buf->offset != buf->chan->subbuf_size + 1) {
-		buf->prev_padding = buf->chan->subbuf_size - buf->offset;
-		old_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
-		buf->padding[old_subbuf] = buf->prev_padding;
-		buf->subbufs_produced++;
-		if (buf->dentry)
-			buf->dentry->d_inode->i_size +=
-				buf->chan->subbuf_size -
-				buf->padding[old_subbuf];
-		else
-			buf->early_bytes += buf->chan->subbuf_size -
-					    buf->padding[old_subbuf];
-		smp_mb();
-		if (waitqueue_active(&buf->read_wait))
-			/*
-			 * Calling wake_up_interruptible() from here
-			 * will deadlock if we happen to be logging
-			 * from the scheduler (trying to re-grab
-			 * rq->lock), so defer it.
-			 */
-			__mod_timer(&buf->timer, jiffies + 1);
-	}
-
-	old = buf->data;
-	new_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
-	new = buf->start + new_subbuf * buf->chan->subbuf_size;
-	buf->offset = 0;
-	if (!buf->chan->cb->subbuf_start(buf, new, old, buf->prev_padding)) {
-		buf->offset = buf->chan->subbuf_size + 1;
-		return 0;
-	}
-	buf->data = new;
-	buf->padding[new_subbuf] = 0;
-
-	if (unlikely(length + buf->offset > buf->chan->subbuf_size))
-		goto toobig;
-
-	return length;
-
-toobig:
-	buf->chan->last_toobig = length;
+	debugfs_remove(dentry);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(relay_switch_subbuf);
-
-/**
- *	relay_subbufs_consumed - update the buffer's sub-buffers-consumed count
- *	@chan: the channel
- *	@cpu: the cpu associated with the channel buffer to update
- *	@subbufs_consumed: number of sub-buffers to add to current buf's count
- *
- *	Adds to the channel buffer's consumed sub-buffer count.
- *	subbufs_consumed should be the number of sub-buffers newly consumed,
- *	not the total consumed.
- *
- *	NOTE. Kernel clients don't need to call this function if the channel
- *	mode is 'overwrite'.
- */
-void relay_subbufs_consumed(struct rchan *chan,
-			    unsigned int cpu,
-			    size_t subbufs_consumed)
-{
-	struct rchan_buf *buf;
 
-	if (!chan)
-		return;
-
-	if (cpu >= NR_CPUS || !chan->buf[cpu])
-		return;
-
-	buf = chan->buf[cpu];
-	buf->subbufs_consumed += subbufs_consumed;
-	if (buf->subbufs_consumed > buf->subbufs_produced)
-		buf->subbufs_consumed = buf->subbufs_produced;
-}
-EXPORT_SYMBOL_GPL(relay_subbufs_consumed);
+/* relay channel default callbacks */
+static struct rchan_callbacks default_channel_callbacks = {
+	.create_buf_file = create_buf_file_default_callback,
+	.remove_buf_file = remove_buf_file_default_callback,
+};
 
-/**
- *	relay_close - close the channel
- *	@chan: the channel
- *
- *	Closes all channel buffers and frees the channel.
- */
-void relay_close(struct rchan *chan)
+static void setup_callbacks(struct rchan *chan, struct rchan_callbacks *cb)
 {
-	unsigned int i;
-
-	if (!chan)
+	if (!cb) {
+		chan->cb = &default_channel_callbacks;
 		return;
+	}
 
-	mutex_lock(&relay_channels_mutex);
-	if (chan->is_global && chan->buf[0])
-		relay_close_buf(chan->buf[0]);
-	else
-		for_each_possible_cpu(i)
-			if (chan->buf[i])
-				relay_close_buf(chan->buf[i]);
-
-	if (chan->last_toobig)
-		printk(KERN_WARNING "relay: one or more items not logged "
-		       "[item size (%Zd) > sub-buffer size (%Zd)]\n",
-		       chan->last_toobig, chan->subbuf_size);
-
-	list_del(&chan->list);
-	kref_put(&chan->kref, relay_destroy_channel);
-	mutex_unlock(&relay_channels_mutex);
+	if (!cb->create_buf_file)
+		cb->create_buf_file = create_buf_file_default_callback;
+	if (!cb->remove_buf_file)
+		cb->remove_buf_file = remove_buf_file_default_callback;
+	chan->cb = cb;
 }
-EXPORT_SYMBOL_GPL(relay_close);
 
-/**
- *	relay_flush - close the channel
- *	@chan: the channel
- *
- *	Flushes all channel buffers, i.e. forces buffer switch.
+/*
+ * relay userspace implementations
  */
-void relay_flush(struct rchan *chan)
-{
-	unsigned int i;
-
-	if (!chan)
-		return;
-
-	if (chan->is_global && chan->buf[0]) {
-		relay_switch_subbuf(chan->buf[0], 0);
-		return;
-	}
-
-	mutex_lock(&relay_channels_mutex);
-	for_each_possible_cpu(i)
-		if (chan->buf[i])
-			relay_switch_subbuf(chan->buf[i], 0);
-	mutex_unlock(&relay_channels_mutex);
-}
-EXPORT_SYMBOL_GPL(relay_flush);
 
 /**
  *	relay_file_open - open file op for relay files
@@ -881,19 +647,6 @@ static int relay_file_open(struct inode *inode, struct file *filp)
 }
 
 /**
- *	relay_file_mmap - mmap file op for relay files
- *	@filp: the file
- *	@vma: the vma describing what to map
- *
- *	Calls upon relay_mmap_buf() to map the file into user space.
- */
-static int relay_file_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	struct rchan_buf *buf = filp->private_data;
-	return relay_mmap_buf(buf, vma);
-}
-
-/**
  *	relay_file_poll - poll file op for relay files
  *	@filp: the file
  *	@wait: poll table
@@ -910,7 +663,7 @@ static unsigned int relay_file_poll(struct file *filp, poll_table *wait)
 
 	if (filp->f_mode & FMODE_READ) {
 		poll_wait(filp, &buf->read_wait, wait);
-		if (!relay_buf_empty(buf))
+		if (buf->nr_pages)
 			mask |= POLLIN | POLLRDNORM;
 	}
 
@@ -933,179 +686,65 @@ static int relay_file_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-/*
- *	relay_file_read_consume - update the consumed count for the buffer
+/**
+ *	relay_file_read_page_avail - return bytes available in next page
+ *	@buf: relay channel buffer
  */
-static void relay_file_read_consume(struct rchan_buf *buf,
-				    size_t read_pos,
-				    size_t bytes_consumed)
+static size_t relay_file_read_page_avail(struct rchan_buf *buf)
 {
-	size_t subbuf_size = buf->chan->subbuf_size;
-	size_t n_subbufs = buf->chan->n_subbufs;
-	size_t read_subbuf;
-
-	if (buf->subbufs_produced == buf->subbufs_consumed &&
-	    buf->offset == buf->bytes_consumed)
-		return;
+	unsigned long flags;
+	size_t avail = 0;
 
-	if (buf->bytes_consumed + bytes_consumed > subbuf_size) {
-		relay_subbufs_consumed(buf->chan, buf->cpu, 1);
-		buf->bytes_consumed = 0;
+	spin_lock_irqsave(&buf->lock, flags);
+	if (!list_empty(&buf->pages)) {
+		struct relay_page *rpage;
+		rpage = list_first_entry(&buf->pages, struct relay_page, list);
+		avail = rpage->len - buf->consumed_offset;
 	}
+	spin_unlock_irqrestore(&buf->lock, flags);
 
-	buf->bytes_consumed += bytes_consumed;
-	if (!read_pos)
-		read_subbuf = buf->subbufs_consumed % n_subbufs;
-	else
-		read_subbuf = read_pos / buf->chan->subbuf_size;
-	if (buf->bytes_consumed + buf->padding[read_subbuf] == subbuf_size) {
-		if ((read_subbuf == buf->subbufs_produced % n_subbufs) &&
-		    (buf->offset == subbuf_size))
-			return;
-		relay_subbufs_consumed(buf->chan, buf->cpu, 1);
-		buf->bytes_consumed = 0;
-	}
+	return avail;
 }
 
 /*
- *	relay_file_read_avail - boolean, are there unconsumed bytes available?
+ *	relay_consume - update the consumed count for the buffer
  */
-static int relay_file_read_avail(struct rchan_buf *buf, size_t read_pos)
+static void relay_consume(struct rchan_buf *buf, int bytes_consumed)
 {
-	size_t subbuf_size = buf->chan->subbuf_size;
-	size_t n_subbufs = buf->chan->n_subbufs;
-	size_t produced = buf->subbufs_produced;
-	size_t consumed = buf->subbufs_consumed;
-
-	relay_file_read_consume(buf, read_pos, 0);
-
-	consumed = buf->subbufs_consumed;
-
-	if (unlikely(buf->offset > subbuf_size)) {
-		if (produced == consumed)
-			return 0;
-		return 1;
-	}
-
-	if (unlikely(produced - consumed >= n_subbufs)) {
-		consumed = produced - n_subbufs + 1;
-		buf->subbufs_consumed = consumed;
-		buf->bytes_consumed = 0;
-	}
-
-	produced = (produced % n_subbufs) * subbuf_size + buf->offset;
-	consumed = (consumed % n_subbufs) * subbuf_size + buf->bytes_consumed;
-
-	if (consumed > produced)
-		produced += n_subbufs * subbuf_size;
-
-	if (consumed == produced) {
-		if (buf->offset == subbuf_size &&
-		    buf->subbufs_produced > buf->subbufs_consumed)
-			return 1;
-		return 0;
-	}
-
-	return 1;
-}
+	unsigned long flags;
+	struct relay_page *rpage;
 
-/**
- *	relay_file_read_subbuf_avail - return bytes available in sub-buffer
- *	@read_pos: file read position
- *	@buf: relay channel buffer
- */
-static size_t relay_file_read_subbuf_avail(size_t read_pos,
-					   struct rchan_buf *buf)
-{
-	size_t padding, avail = 0;
-	size_t read_subbuf, read_offset, write_subbuf, write_offset;
-	size_t subbuf_size = buf->chan->subbuf_size;
-
-	write_subbuf = (buf->data - buf->start) / subbuf_size;
-	write_offset = buf->offset > subbuf_size ? subbuf_size : buf->offset;
-	read_subbuf = read_pos / subbuf_size;
-	read_offset = read_pos % subbuf_size;
-	padding = buf->padding[read_subbuf];
-
-	if (read_subbuf == write_subbuf) {
-		if (read_offset + padding < write_offset)
-			avail = write_offset - (read_offset + padding);
-	} else
-		avail = (subbuf_size - padding) - read_offset;
+	spin_lock_irqsave(&buf->lock, flags);
+	rpage = list_first_entry(&buf->pages, struct relay_page, list);
+	spin_unlock_irqrestore(&buf->lock, flags);
 
-	return avail;
-}
+	buf->consumed_offset += bytes_consumed;
 
-/**
- *	relay_file_read_start_pos - find the first available byte to read
- *	@read_pos: file read position
- *	@buf: relay channel buffer
- *
- *	If the @read_pos is in the middle of padding, return the
- *	position of the first actually available byte, otherwise
- *	return the original value.
- */
-static size_t relay_file_read_start_pos(size_t read_pos,
-					struct rchan_buf *buf)
-{
-	size_t read_subbuf, padding, padding_start, padding_end;
-	size_t subbuf_size = buf->chan->subbuf_size;
-	size_t n_subbufs = buf->chan->n_subbufs;
-	size_t consumed = buf->subbufs_consumed % n_subbufs;
-
-	if (!read_pos)
-		read_pos = consumed * subbuf_size + buf->bytes_consumed;
-	read_subbuf = read_pos / subbuf_size;
-	padding = buf->padding[read_subbuf];
-	padding_start = (read_subbuf + 1) * subbuf_size - padding;
-	padding_end = (read_subbuf + 1) * subbuf_size;
-	if (read_pos >= padding_start && read_pos < padding_end) {
-		read_subbuf = (read_subbuf + 1) % n_subbufs;
-		read_pos = read_subbuf * subbuf_size;
+	if (buf->consumed_offset == rpage->len) {
+		__relay_release_page(buf, rpage);
+		buf->consumed_offset = 0;
 	}
-
-	return read_pos;
-}
-
-/**
- *	relay_file_read_end_pos - return the new read position
- *	@read_pos: file read position
- *	@buf: relay channel buffer
- *	@count: number of bytes to be read
- */
-static size_t relay_file_read_end_pos(struct rchan_buf *buf,
-				      size_t read_pos,
-				      size_t count)
-{
-	size_t read_subbuf, padding, end_pos;
-	size_t subbuf_size = buf->chan->subbuf_size;
-	size_t n_subbufs = buf->chan->n_subbufs;
-
-	read_subbuf = read_pos / subbuf_size;
-	padding = buf->padding[read_subbuf];
-	if (read_pos % subbuf_size + count + padding == subbuf_size)
-		end_pos = (read_subbuf + 1) * subbuf_size;
-	else
-		end_pos = read_pos + count;
-	if (end_pos >= subbuf_size * n_subbufs)
-		end_pos = 0;
-
-	return end_pos;
 }
 
 /*
- *	subbuf_read_actor - read up to one subbuf's worth of data
+ *	page_read_actor - read up to one page's worth of data
  */
-static int subbuf_read_actor(size_t read_start,
-			     struct rchan_buf *buf,
-			     size_t avail,
-			     read_descriptor_t *desc,
-			     read_actor_t actor)
+static int page_read_actor(struct rchan_buf *buf,
+			   size_t avail,
+			   read_descriptor_t *desc,
+			   read_actor_t actor)
 {
-	void *from;
+	struct relay_page *rpage;
+	unsigned long flags;
 	int ret = 0;
+	void *from;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	rpage = list_first_entry(&buf->pages, struct relay_page, list);
+	spin_unlock_irqrestore(&buf->lock, flags);
 
-	from = buf->start + read_start;
+	from = page_address(rpage->page);
+	from += rpage->len - avail;
 	ret = avail;
 	if (copy_to_user(desc->arg.buf, from, avail)) {
 		desc->error = -EFAULT;
@@ -1118,22 +757,21 @@ static int subbuf_read_actor(size_t read_start,
 	return ret;
 }
 
-typedef int (*subbuf_actor_t) (size_t read_start,
-			       struct rchan_buf *buf,
-			       size_t avail,
-			       read_descriptor_t *desc,
-			       read_actor_t actor);
+typedef int (*page_actor_t) (struct rchan_buf *buf,
+			     size_t avail,
+			     read_descriptor_t *desc,
+			     read_actor_t actor);
 
 /*
- *	relay_file_read_subbufs - read count bytes, bridging subbuf boundaries
+ *	relay_file_read_pages - read count bytes, bridging page boundaries
  */
-static ssize_t relay_file_read_subbufs(struct file *filp, loff_t *ppos,
-					subbuf_actor_t subbuf_actor,
-					read_actor_t actor,
-					read_descriptor_t *desc)
+static ssize_t relay_file_read_pages(struct file *filp, loff_t *ppos,
+				     page_actor_t page_actor,
+				     read_actor_t actor,
+				     read_descriptor_t *desc)
 {
 	struct rchan_buf *buf = filp->private_data;
-	size_t read_start, avail;
+	size_t avail;
 	int ret;
 
 	if (!desc->count)
@@ -1141,22 +779,16 @@ static ssize_t relay_file_read_subbufs(struct file *filp, loff_t *ppos,
 
 	mutex_lock(&filp->f_path.dentry->d_inode->i_mutex);
 	do {
-		if (!relay_file_read_avail(buf, *ppos))
-			break;
-
-		read_start = relay_file_read_start_pos(*ppos, buf);
-		avail = relay_file_read_subbuf_avail(read_start, buf);
+		avail = relay_file_read_page_avail(buf);
 		if (!avail)
 			break;
-
 		avail = min(desc->count, avail);
-		ret = subbuf_actor(read_start, buf, avail, desc, actor);
+		ret = page_actor(buf, avail, desc, actor);
 		if (desc->error < 0)
 			break;
-
 		if (ret) {
-			relay_file_read_consume(buf, read_start, ret);
-			*ppos = relay_file_read_end_pos(buf, read_start, ret);
+			relay_consume(buf, ret);
+			*ppos += ret;
 		}
 	} while (desc->count && ret);
 	mutex_unlock(&filp->f_path.dentry->d_inode->i_mutex);
@@ -1174,27 +806,40 @@ static ssize_t relay_file_read(struct file *filp,
 	desc.count = count;
 	desc.arg.buf = buffer;
 	desc.error = 0;
-	return relay_file_read_subbufs(filp, ppos, subbuf_read_actor,
-				       NULL, &desc);
+	return relay_file_read_pages(filp, ppos, page_read_actor,
+				     NULL, &desc);
 }
 
-static void relay_consume_bytes(struct rchan_buf *rbuf, int bytes_consumed)
+static void relay_pipe_buf_release(struct pipe_inode_info *pipe,
+				   struct pipe_buffer *pipe_buf)
 {
-	rbuf->bytes_consumed += bytes_consumed;
+	struct rchan_buf *buf;
 
-	if (rbuf->bytes_consumed >= rbuf->chan->subbuf_size) {
-		relay_subbufs_consumed(rbuf->chan, rbuf->cpu, 1);
-		rbuf->bytes_consumed %= rbuf->chan->subbuf_size;
-	}
+	buf = (struct rchan_buf *)page_private(pipe_buf->page);
+	relay_consume(buf, pipe_buf->private);
 }
 
-static void relay_pipe_buf_release(struct pipe_inode_info *pipe,
-				   struct pipe_buffer *buf)
+static int relay_pipe_buf_steal(struct pipe_inode_info *pipe,
+				struct pipe_buffer *pipe_buf)
 {
-	struct rchan_buf *rbuf;
+	int ret;
+	struct rchan_buf *buf;
 
-	rbuf = (struct rchan_buf *)page_private(buf->page);
-	relay_consume_bytes(rbuf, buf->private);
+	buf = (struct rchan_buf *)page_private(pipe_buf->page);
+	ret = generic_pipe_buf_steal(pipe, pipe_buf);
+	if (!ret) {
+		struct relay_page *rpage;
+		unsigned long flags;
+		spin_lock_irqsave(&buf->lock, flags);
+		rpage = list_first_entry(&buf->pages, struct relay_page, list);
+		spin_unlock_irqrestore(&buf->lock, flags);
+		__relay_remove_page(buf, rpage);
+		if (rpage->cb && rpage->cb->page_stolen)
+			rpage->cb->page_stolen(pipe_buf->page,
+					       rpage->private_data);
+	}
+
+	return ret;
 }
 
 static struct pipe_buf_operations relay_pipe_buf_ops = {
@@ -1203,7 +848,7 @@ static struct pipe_buf_operations relay_pipe_buf_ops = {
 	.unmap = generic_pipe_buf_unmap,
 	.confirm = generic_pipe_buf_confirm,
 	.release = relay_pipe_buf_release,
-	.steal = generic_pipe_buf_steal,
+	.steal = relay_pipe_buf_steal,
 	.get = generic_pipe_buf_get,
 };
 
@@ -1212,24 +857,17 @@ static void relay_page_release(struct splice_pipe_desc *spd, unsigned int i)
 }
 
 /*
- *	subbuf_splice_actor - splice up to one subbuf's worth of data
+ *	page_splice_actor - splice available data
  */
-static int subbuf_splice_actor(struct file *in,
-			       loff_t *ppos,
-			       struct pipe_inode_info *pipe,
-			       size_t len,
-			       unsigned int flags,
-			       int *nonpad_ret)
+static int page_splice_actor(struct file *in,
+			     struct pipe_inode_info *pipe,
+			     size_t len,
+			     unsigned int flags)
 {
-	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
-	struct rchan_buf *rbuf = in->private_data;
-	unsigned int subbuf_size = rbuf->chan->subbuf_size;
-	uint64_t pos = (uint64_t) *ppos;
-	uint32_t alloc_size = (uint32_t) rbuf->chan->alloc_size;
-	size_t read_start = (size_t) do_div(pos, alloc_size);
-	size_t read_subbuf = read_start / subbuf_size;
-	size_t padding = rbuf->padding[read_subbuf];
-	size_t nonpad_end = read_subbuf * subbuf_size + subbuf_size - padding;
+	unsigned int poff, total_len, nr_pages, ret;
+	struct rchan_buf *buf = in->private_data;
+	struct relay_page *rpage;
+	unsigned long lflags;
 	struct page *pages[PIPE_BUFFERS];
 	struct partial_page partial[PIPE_BUFFERS];
 	struct splice_pipe_desc spd = {
@@ -1241,61 +879,38 @@ static int subbuf_splice_actor(struct file *in,
 		.spd_release = relay_page_release,
 	};
 
-	if (rbuf->subbufs_produced == rbuf->subbufs_consumed)
+	if (list_empty(&buf->pages))
 		return 0;
 
-	/*
-	 * Adjust read len, if longer than what is available
-	 */
-	if (len > (subbuf_size - read_start % subbuf_size))
-		len = subbuf_size - read_start % subbuf_size;
+	poff = buf->consumed_offset;
+	nr_pages = min_t(unsigned int, buf->nr_pages, PIPE_BUFFERS);
+	total_len = 0;
 
-	subbuf_pages = rbuf->chan->alloc_size >> PAGE_SHIFT;
-	pidx = (read_start / PAGE_SIZE) % subbuf_pages;
-	poff = read_start & ~PAGE_MASK;
-	nr_pages = min_t(unsigned int, subbuf_pages, PIPE_BUFFERS);
+	spin_lock_irqsave(&buf->lock, lflags);
+	list_for_each_entry(rpage, &buf->pages, list) {
+		unsigned int this_len;
 
-	for (total_len = 0; spd.nr_pages < nr_pages; spd.nr_pages++) {
-		unsigned int this_len, this_end, private;
-		unsigned int cur_pos = read_start + total_len;
+		if (spd.nr_pages >= nr_pages)
+			break;
 
 		if (!len)
 			break;
 
-		this_len = min_t(unsigned long, len, PAGE_SIZE - poff);
-		private = this_len;
+		this_len = min_t(unsigned long, len, rpage->len - poff);
 
-		spd.pages[spd.nr_pages] = rbuf->page_array[pidx];
+		spd.pages[spd.nr_pages] = rpage->page;
 		spd.partial[spd.nr_pages].offset = poff;
-
-		this_end = cur_pos + this_len;
-		if (this_end >= nonpad_end) {
-			this_len = nonpad_end - cur_pos;
-			private = this_len + padding;
-		}
 		spd.partial[spd.nr_pages].len = this_len;
-		spd.partial[spd.nr_pages].private = private;
+		spd.partial[spd.nr_pages].private = this_len;
 
 		len -= this_len;
 		total_len += this_len;
 		poff = 0;
-		pidx = (pidx + 1) % subbuf_pages;
-
-		if (this_end >= nonpad_end) {
-			spd.nr_pages++;
-			break;
-		}
+		spd.nr_pages++;
 	}
+	spin_unlock_irqrestore(&buf->lock, lflags);
 
-	if (!spd.nr_pages)
-		return 0;
-
-	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
-	if (ret < 0 || ret < total_len)
-		return ret;
-
-        if (read_start + ret == nonpad_end)
-                ret += padding;
+	ret = splice_to_pipe(pipe, &spd);
 
         return ret;
 }
@@ -1308,13 +923,12 @@ static ssize_t relay_file_splice_read(struct file *in,
 {
 	ssize_t spliced;
 	int ret;
-	int nonpad_ret = 0;
 
 	ret = 0;
 	spliced = 0;
 
 	while (len && !spliced) {
-		ret = subbuf_splice_actor(in, ppos, pipe, len, flags, &nonpad_ret);
+		ret = page_splice_actor(in, pipe, len, flags);
 		if (ret < 0)
 			break;
 		else if (!ret) {
@@ -1331,8 +945,7 @@ static ssize_t relay_file_splice_read(struct file *in,
 			len = 0;
 		else
 			len -= ret;
-		spliced += nonpad_ret;
-		nonpad_ret = 0;
+		spliced += ret;
 	}
 
 	if (spliced)
@@ -1344,7 +957,6 @@ static ssize_t relay_file_splice_read(struct file *in,
 const struct file_operations relay_file_operations = {
 	.open		= relay_file_open,
 	.poll		= relay_file_poll,
-	.mmap		= relay_file_mmap,
 	.read		= relay_file_read,
 	.llseek		= no_llseek,
 	.release	= relay_file_release,
@@ -1352,9 +964,50 @@ const struct file_operations relay_file_operations = {
 };
 EXPORT_SYMBOL_GPL(relay_file_operations);
 
-static __init int relay_init(void)
+/**
+ * 	relay_hotcpu_callback - CPU hotplug callback
+ * 	@nb: notifier block
+ * 	@action: hotplug action to take
+ * 	@hcpu: CPU number
+ *
+ * 	Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
+ */
+static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
+				unsigned long action,
+				void *hcpu)
 {
+	unsigned int hotcpu = (unsigned long)hcpu;
+	struct rchan *chan;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		mutex_lock(&relay_channels_mutex);
+		list_for_each_entry(chan, &relay_channels, list) {
+			if (chan->buf[hotcpu])
+				continue;
+			chan->buf[hotcpu] = relay_open_buf(chan, hotcpu);
+			if (!chan->buf[hotcpu]) {
+				printk(KERN_ERR
+					"relay_hotcpu_callback: cpu %d buffer "
+					"creation failed\n", hotcpu);
+				mutex_unlock(&relay_channels_mutex);
+				return NOTIFY_BAD;
+			}
+		}
+		mutex_unlock(&relay_channels_mutex);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		/* No need to flush the cpu : will be flushed upon
+		 * final relay_flush() call. */
+		break;
+	}
+	return NOTIFY_OK;
+}
 
+static __init int relay_init(void)
+{
 	hotcpu_notifier(relay_hotcpu_callback, 0);
 	return 0;
 }
diff --git a/kernel/relay_pagewriter.c b/kernel/relay_pagewriter.c
new file mode 100644
index 0000000..7a855ef
--- /dev/null
+++ b/kernel/relay_pagewriter.c
@@ -0,0 +1,860 @@
+/*
+ * Provides per-cpu page writers and page pool management for current
+ * users of the relay interface.  Basically this provides functions to
+ * write into pages, feed them into a relay object for consumption by
+ * usespace, and reclaim them after they've been read.
+ *
+ * See Documentation/filesystems/relay.txt for an overview.
+ *
+ * Copyright (C) 2002-2005 - Tom Zanussi (zanussi@us.ibm.com), IBM Corp
+ * Copyright (C) 1999-2005 - Karim Yaghmour (karim@opersys.com)
+ * Copyright (C) 2008 - Tom Zanussi (tzanussi@gmail.com)
+ *
+ * Moved to kernel/relay.c by Paul Mundt, 2006.
+ * November 2006 - CPU hotplug support by Mathieu Desnoyers
+ * 	(mathieu.desnoyers@polymtl.ca)
+ *
+ * This file is released under the GPL.
+ */
+#include <linux/errno.h>
+#include <linux/stddef.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/relay.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/cpu.h>
+#include <linux/splice.h>
+#include <linux/relay_pagewriter.h>
+#include <linux/debugfs.h>
+
+/* list of open pagewriters, for cpu hotplug */
+static DEFINE_MUTEX(pagewriters_mutex);
+static LIST_HEAD(pagewriters);
+
+/* forward declarations */
+static void setup_callbacks(struct pagewriter *pagewriter,
+			    struct pagewriter_callbacks *cb,
+			    unsigned long flags);
+static void pagewriter_close_buf(struct pagewriter_buf *buf);
+static struct pagewriter_buf *pagewriter_open_buf(struct pagewriter *pw,
+						  unsigned int cpu);
+static void pagewriter_destroy(struct kref *kref);
+static void __pagewriter_reset(struct pagewriter_buf *buf, unsigned int init);
+static void pagewriter_save_flight_buf(struct pagewriter_buf *buf);
+static struct relay_page_callbacks pagewriter_relay_page_callbacks;
+static void add_empty_rpage_struct(struct pagewriter_buf *buf,
+				   struct relay_page *rpage);
+static inline void switch_to_next_page(struct pagewriter_buf *buf);
+
+/*
+ * pagewriter kernel API
+ */
+
+/**
+ *	pagewriter_open - create a new pagewriter
+ *	@base_filename: base name of files to create, %NULL for buffering only
+ *	@parent: dentry of parent directory, %NULL for root directory or buffer
+ *	@n_pages: number of pages to use for each buffer
+ *	@n_pages_wakeup: wakeup readers after this many pages, 0 means never
+ *	@end_reserve: reserve at least that for padding events, 0 if not needed
+ *	@cb: client callback functions
+ *	@private_data: user-defined data
+ *	@flags: channel flags, top half for pagewriter, bottom half for relay
+ *
+ *	Returns pagewriter pointer if successful, %NULL otherwise.
+ *
+ *	Creates a pagewriter page pool for each cpu using the sizes and
+ *	attributes specified.
+ */
+struct pagewriter *pagewriter_open(const char *base_filename,
+				   struct dentry *parent,
+				   size_t n_pages,
+				   size_t n_pages_wakeup,
+				   size_t end_reserve,
+				   struct pagewriter_callbacks *cb,
+				   void *private_data,
+				   unsigned long flags)
+{
+	unsigned int i;
+	struct pagewriter *pagewriter;
+
+	if (!n_pages)
+		return NULL;
+
+	pagewriter = kzalloc(sizeof(struct pagewriter), GFP_KERNEL);
+	if (!pagewriter)
+		return NULL;
+
+	if (flags & PAGEWRITER_LATE_SETUP) {
+		strlcpy(pagewriter->base_filename, base_filename, NAME_MAX);
+		pagewriter->n_pages_wakeup = n_pages_wakeup;
+	} else {
+		pagewriter->rchan = relay_open(base_filename, parent,
+					       n_pages_wakeup, NULL,
+					       private_data, flags);
+		if (!pagewriter->rchan) {
+			kfree(pagewriter);
+			return NULL;
+		}
+	}
+
+	pagewriter->flags = flags;
+	pagewriter->n_pages = n_pages;
+	pagewriter->end_reserve = end_reserve;
+	atomic_set(&pagewriter->dropped, 0);
+
+	pagewriter->private_data = private_data;
+	setup_callbacks(pagewriter, cb, flags);
+	kref_init(&pagewriter->kref);
+
+	mutex_lock(&pagewriters_mutex);
+	for_each_online_cpu(i) {
+		pagewriter->buf[i] = pagewriter_open_buf(pagewriter, i);
+		if (!pagewriter->buf[i])
+			goto free_bufs;
+	}
+	list_add(&pagewriter->list, &pagewriters);
+	mutex_unlock(&pagewriters_mutex);
+
+	return pagewriter;
+
+free_bufs:
+	for_each_online_cpu(i) {
+		if (!pagewriter->buf[i])
+			break;
+		pagewriter_close_buf(pagewriter->buf[i]);
+	}
+
+	relay_close(pagewriter->rchan);
+	kref_put(&pagewriter->kref, pagewriter_destroy);
+	kfree(pagewriter);
+	mutex_unlock(&pagewriters_mutex);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(pagewriter_open);
+
+/**
+ *	relay_page - send a full page to relay
+ *	@pagewriter_buf: the pagewriter buf
+ *
+ *	'relays' a full page i.e. sends it to relay.
+ */
+static void relay_page(struct pagewriter_buf *buf)
+{
+	kref_get(&buf->kref);
+	relay_add_page(buf->pagewriter->rchan, buf->page->page,
+		       &pagewriter_relay_page_callbacks, (void *)buf);
+	buf->page->page = NULL;
+}
+
+/**
+ *	relay_partial_page - send a partial page to relay
+ *	@pagewriter_buf: the pagewriter buf
+ *
+ *	'relays' a partial page i.e. sends it to relay.
+ */
+static void relay_partial_page(struct pagewriter_buf *buf, unsigned int len)
+{
+	kref_get(&buf->kref);
+	relay_add_partial_page(buf->pagewriter->rchan, buf->page->page, len,
+			       &pagewriter_relay_page_callbacks, (void *)buf);
+	buf->page->page = NULL;
+}
+
+/**
+ *	pagewriter_flush_page - flush a possibly partial page
+ *	@pagewriter_bur: the pagewriter buf
+ *	@len: the length of data in the page
+ *
+ *	Used to flush the current, probably partial, non-padded page.
+ */
+static void pagewriter_flush_page(struct pagewriter_buf *buf, unsigned int len)
+{
+	unsigned long flags;
+
+	if (len == PAGE_SIZE) {
+		buf->pagewriter->cb->switch_page(buf);
+		return;
+	}
+
+	flags = buf->pagewriter->flags;
+	if (flags & PAGEWRITER_FLIGHT_MODE || flags & PAGEWRITER_LATE_SETUP) {
+		unsigned long flags;
+		buf->page->len = len;
+		spin_lock_irqsave(&buf->lock, flags);
+		list_add_tail(&buf->page->list, &buf->pool);
+		spin_unlock_irqrestore(&buf->lock, flags);
+		buf->n_pages_flight++;
+		return;
+	}
+	relay_partial_page(buf, len);
+	add_empty_rpage_struct(buf, buf->page);
+	switch_to_next_page(buf);
+}
+
+/**
+ *	pagewriter_flush - flush the pagewriter
+ *	@pagewriter: the pagewriter
+ *
+ *	Flushes all channel buffers, i.e. forces page switch.
+ */
+void pagewriter_flush(struct pagewriter *pagewriter)
+{
+	unsigned int i;
+
+	if (!pagewriter)
+		return;
+
+	mutex_lock(&pagewriters_mutex);
+	for_each_possible_cpu(i) {
+		struct pagewriter_buf *buf = pagewriter->buf[i];
+		if (!buf)
+			continue;
+		if (buf->pagewriter->flags & PAGEWRITER_PAD_WRITES) {
+			size_t len = PAGE_SIZE - buf->offset;
+			void *pad = buf->data + buf->offset;
+			if (len)
+				pagewriter->cb->write_padding(buf, len, pad);
+			pagewriter->cb->switch_page(buf);
+		} else {
+			size_t len = buf->offset;
+			pagewriter_flush_page(buf, len);
+		}
+	}
+	relay_flush(pagewriter->rchan);
+	mutex_unlock(&pagewriters_mutex);
+}
+EXPORT_SYMBOL_GPL(pagewriter_flush);
+
+/**
+ *	pagewriter_close - close the pagewriter
+ *	@pagewriter: the pagewriter
+ *
+ *	Closes all buffers and frees their page pools, and also frees
+ *	the pagewriter.
+ */
+void pagewriter_close(struct pagewriter *pagewriter)
+{
+	unsigned int i;
+
+	if (!pagewriter)
+		return;
+
+	mutex_lock(&pagewriters_mutex);
+	for_each_possible_cpu(i)
+		if (pagewriter->buf[i])
+			pagewriter_close_buf(pagewriter->buf[i]);
+
+	relay_close(pagewriter->rchan);
+
+	list_del(&pagewriter->list);
+	kref_put(&pagewriter->kref, pagewriter_destroy);
+	mutex_unlock(&pagewriters_mutex);
+}
+EXPORT_SYMBOL_GPL(pagewriter_close);
+
+/**
+ *	pagewriter_reset - reset the pagewriter
+ *	@pagewriter: the pagewriter
+ *
+ *	This has the effect of erasing all data from the current page
+ *	and restarting the pagewriter in its initial state.
+ *
+ *	NOTE. Care should be taken that the pagewriter isn't actually
+ *	being used by anything when this call is made.
+ */
+void pagewriter_reset(struct pagewriter *pagewriter)
+{
+	unsigned int i;
+
+	if (!pagewriter)
+		return;
+
+	mutex_lock(&pagewriters_mutex);
+	for_each_online_cpu(i)
+		if (pagewriter->buf[i])
+			__pagewriter_reset(pagewriter->buf[i], 0);
+	mutex_unlock(&pagewriters_mutex);
+}
+EXPORT_SYMBOL_GPL(pagewriter_reset);
+
+/**
+ *	pagewriter_save_flight_data - log all pages dirtied in flight mode
+ *	@pagewriter: pagewriter
+ *
+ *	In flight mode (PAGEWRITER_FLIGHT_MODE), the pages written to
+ *	via the pagewriter_write/reserve functions are simply cycled
+ *	around the per-cpu page pools, and not sent to relay.  This
+ *	function provides a way, at the user's request, to simply
+ *	sends all the dirty pages in the page pools to relay and
+ *	therefore onto their final destination e.g. disk or network.
+ *
+ *	The pagewriter and associated buffers will be in the same
+ *	state as if hey were reset after this call.
+ */
+void pagewriter_save_flight_data(struct pagewriter *pagewriter)
+{
+	unsigned int i;
+
+	if (!pagewriter)
+		return;
+
+	mutex_lock(&pagewriters_mutex);
+	for_each_possible_cpu(i)
+		if (pagewriter->buf[i])
+			pagewriter_save_flight_buf(pagewriter->buf[i]);
+	relay_flush(pagewriter->rchan);
+	mutex_unlock(&pagewriters_mutex);
+}
+EXPORT_SYMBOL_GPL(pagewriter_save_flight_data);
+
+/**
+ *	pagewriter_late_setup - create relay channel and log early pages
+ *	@pagewriter: pagewriter
+ *	@parent: dentry of parent directory, %NULL for root directory
+ *
+ *	If the pagewriter was initially created in early mode
+ *	(PAGEWRITER_LATE_SETUP), this creates the relay channel and
+ *	sends all the early pages in the page pools to relay and
+ *	therefore onto their final destination e.g. disk or network.
+ *
+ *	Returns 0 if successful, non-zero otherwise.
+ *
+ *	Use to setup files for a previously buffer-only channel.
+ *	Useful to do early tracing in kernel, before VFS is up, for example.
+ */
+int pagewriter_late_setup(struct pagewriter *pagewriter,
+			  struct dentry *parent)
+{
+	if (!pagewriter)
+		return -EINVAL;
+
+	pagewriter->rchan = relay_open(pagewriter->base_filename,
+				       parent,
+				       pagewriter->n_pages_wakeup,
+				       NULL,
+				       pagewriter->private_data,
+				       pagewriter->flags);
+	if (!pagewriter->rchan)
+		return -ENOMEM;
+
+	pagewriter->flags &= ~PAGEWRITER_LATE_SETUP;
+	pagewriter_save_flight_data(pagewriter);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pagewriter_late_setup);
+
+/*
+ * end relay kernel API
+ */
+
+/**
+ *	pagewriter_get_free_page - get a free relay_page from the pool
+ *	@buf: the buffer struct
+ *
+ *	Returns relay page if successful, NULL if not.
+ */
+static struct relay_page *pagewriter_get_free_page(struct pagewriter_buf *buf)
+{
+	struct relay_page *rpage = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	if (!list_empty(&buf->pool)) {
+		rpage = list_first_entry(&buf->pool, struct relay_page, list);
+		list_del(&rpage->list);
+	}
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	return rpage;
+}
+
+static inline void switch_to_next_page(struct pagewriter_buf *buf)
+{
+	struct relay_page *new_page = pagewriter_get_free_page(buf);
+	if (!new_page) {
+		buf->page = NULL;
+		buf->data = NULL;
+		return;
+	}
+	buf->page = new_page;
+	buf->data = page_address(buf->page->page);
+	buf->offset = 0;
+	buf->pagewriter->cb->new_page(buf, buf->data);
+}
+
+/**
+ *	get_empty_rpage_struct - get an empty rpage_struct to hold a page
+ *	@buf: the buffer struct
+ *
+ *	Returns an rpage_struct if successful, NULL if not.
+ */
+static struct relay_page *get_empty_rpage_struct(struct pagewriter_buf *buf)
+{
+	struct relay_page *rpage = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	if (!list_empty(&buf->empty_rpage_structs)) {
+		rpage = list_first_entry(&buf->empty_rpage_structs,
+					 struct relay_page, list);
+		list_del(&rpage->list);
+	}
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	return rpage;
+}
+
+static void add_empty_rpage_struct_nolock(struct pagewriter_buf *buf,
+					  struct relay_page *rpage)
+{
+	list_add_tail(&rpage->list, &buf->empty_rpage_structs);
+}
+
+/**
+ *	add_empty_rpage_struct - add/return a free rpage_struct to the pool
+ *	@buf: buffer struct
+ *	@rpage: struct relay_page
+ */
+static void add_empty_rpage_struct(struct pagewriter_buf *buf,
+				   struct relay_page *rpage)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	add_empty_rpage_struct_nolock(buf, rpage);
+	spin_unlock_irqrestore(&buf->lock, flags);
+}
+
+/**
+ *	pagewriter_destroy - free the pagewriter struct
+ *	@kref: target kernel reference that contains the relay channel
+ *
+ *	Should only be called from kref_put().
+ */
+static void pagewriter_destroy(struct kref *kref)
+{
+	struct pagewriter *pagewriter = container_of(kref, struct pagewriter,
+						     kref);
+	kfree(pagewriter);
+}
+
+/**
+ *	pagewriter_destroy_buf - destroy a pagewriter_buf struct and page pool
+ *	@buf: the buffer struct
+ */
+static void pagewriter_destroy_buf(struct pagewriter_buf *buf)
+{
+	struct pagewriter *pagewriter = buf->pagewriter;
+	struct relay_page *rpage, *rpage2;
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	list_for_each_entry_safe(rpage, rpage2, &buf->pool, list) {
+		__free_page(rpage->page);
+		list_del(&rpage->list);
+		kfree(rpage);
+	}
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	pagewriter->buf[buf->cpu] = NULL;
+	kfree(buf);
+	kref_put(&pagewriter->kref, pagewriter_destroy);
+}
+
+/**
+ *	pagewriter_remove_buf - remove a pagewriter buffer
+ *	@kref: target kernel reference that contains the relay buffer
+ *
+ *	Frees the pagweriter_buf and the buffer's page pool.  Should
+ *	only be called from kref_put().
+ */
+static void pagewriter_remove_buf(struct kref *kref)
+{
+	struct pagewriter_buf *buf = container_of(kref, struct pagewriter_buf,
+						  kref);
+	pagewriter_destroy_buf(buf);
+}
+
+/**
+ *	pagewriter_close_buf - close a pagewriter buffer
+ *	@buf: channel buffer
+ *
+ *	The channel buffer and channel buffer data structure are freed
+ *	automatically when the last reference is given up.
+ */
+static void pagewriter_close_buf(struct pagewriter_buf *buf)
+{
+	kref_put(&buf->kref, pagewriter_remove_buf);
+}
+
+/**
+ *	pagewriter_add_free_page - add/return a free relay_page to the pool
+ *	@buf: the buffer struct
+ *	@rpage: relay_page to add
+ *
+ *	Returns relay page if successful, NULL if not.
+ */
+static void pagewriter_add_free_page(struct pagewriter_buf *buf,
+				     struct relay_page *rpage)
+{
+	int was_empty = list_empty(&buf->pool);
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	list_add_tail(&rpage->list, &buf->pool);
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	if (was_empty)
+		switch_to_next_page(buf);
+
+	kref_put(&buf->kref, pagewriter_remove_buf);
+}
+
+/**
+ *	pagewriter_alloc_pool - allocate a pool of pages for the buffer
+ *	@buf: the buffer struct
+ *
+ *	Allocates buf->pagewriter->n_pages pages to the buffer.
+ *	Returns 0 if successful.
+ */
+static int pagewriter_alloc_pool(struct pagewriter_buf *buf)
+{
+	unsigned int i;
+	struct relay_page *rpage = NULL;
+
+	for (i = 0; i < buf->pagewriter->n_pages; i++) {
+		rpage = kmalloc(sizeof(struct relay_page), GFP_KERNEL);
+		if (unlikely(!rpage))
+			goto depopulate;
+		rpage->page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (unlikely(!rpage->page))
+			goto depopulate;
+		list_add_tail(&rpage->list, &buf->pool);
+	}
+
+	return 0;
+
+depopulate:
+	list_for_each_entry(rpage, &buf->pool, list) {
+		__free_page(rpage->page);
+		list_del(&rpage->list);
+	}
+
+	return -ENOMEM;
+}
+
+/**
+ *	pagewriter_create_buf - allocate and initialize a buffer's page pool
+ *	@pagewriter: the pagewriter
+ *
+ *	Returns pagewriter buffer if successful, %NULL otherwise.
+ */
+static struct pagewriter_buf *pagewriter_create_buf(struct pagewriter *pw)
+{
+	struct pagewriter_buf *buf = kzalloc(sizeof(struct pagewriter_buf),
+					     GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	spin_lock_init(&buf->lock);
+	INIT_LIST_HEAD(&buf->pool);
+	INIT_LIST_HEAD(&buf->empty_rpage_structs);
+	buf->pagewriter = pw;
+	kref_get(&buf->pagewriter->kref);
+
+	if (pagewriter_alloc_pool(buf))
+		goto free_buf;
+
+	return buf;
+
+free_buf:
+	kfree(buf);
+	return NULL;
+}
+
+/*
+ *	pagewriter_open_buf - create a new pagewriter buf with page pool
+ *
+ *	used by pagewriter_open() and CPU hotplug.
+ */
+static struct pagewriter_buf *pagewriter_open_buf(struct pagewriter *pagewriter,
+					     unsigned int cpu)
+{
+	struct pagewriter_buf *buf = NULL;
+
+	buf = pagewriter_create_buf(pagewriter);
+	if (!buf)
+		return NULL;
+
+	buf->cpu = cpu;
+
+	__pagewriter_reset(buf, 1);
+
+	return buf;
+}
+
+/*
+ * new_page() default callback.
+ */
+static void new_page_default_callback(struct pagewriter_buf *buf,
+				      void *page_data)
+{
+}
+
+/*
+ * write_padding() default callback.
+ */
+void pagewriter_write_padding_default_callback(struct pagewriter_buf *buf,
+					       size_t length,
+					       void *reserved)
+{
+}
+
+/* pagewriter default callbacks */
+static struct pagewriter_callbacks default_pagewriter_callbacks = {
+	.new_page = new_page_default_callback,
+	.write_padding = pagewriter_write_padding_default_callback,
+};
+
+static void set_page_switch_cb(struct pagewriter_callbacks *cb,
+			       unsigned long flags)
+{
+	if (flags & PAGEWRITER_FLIGHT_MODE || flags & PAGEWRITER_LATE_SETUP) {
+		if (flags & PAGEWRITER_PAD_WRITES)
+			cb->switch_page = pagewriter_pad_flight_switch_page;
+		else
+			cb->switch_page = pagewriter_nopad_flight_switch_page;
+	} else {
+		if (flags & PAGEWRITER_PAD_WRITES)
+			cb->switch_page = pagewriter_pad_switch_page;
+		else
+			cb->switch_page = pagewriter_nopad_switch_page;
+	}
+}
+
+static void setup_callbacks(struct pagewriter *pagewriter,
+			    struct pagewriter_callbacks *cb,
+			    unsigned long flags)
+{
+	if (!cb)
+		pagewriter->cb = &default_pagewriter_callbacks;
+
+	if (!cb->switch_page)
+		set_page_switch_cb(cb, flags);
+	if (!cb->new_page)
+		cb->new_page = new_page_default_callback;
+	if (!cb->write_padding)
+		cb->write_padding = pagewriter_write_padding_default_callback;
+
+	pagewriter->cb = cb;
+}
+
+/**
+ * 	pagewriter_page_released_callback - relay_page page_released impl
+ * 	@page: the page released
+ * 	@private_data: contains associated pagewriter_buf
+ *
+ * 	relay has notified us that a page we gave it has been read and
+ * 	is now available for us to re-use.  We simply add it back to
+ * 	the page pool for that buf.
+ */
+static void pagewriter_page_released_callback(struct page *page,
+					      void *private_data)
+{
+	struct pagewriter_buf *buf = private_data;
+	struct relay_page *rpage = get_empty_rpage_struct(buf);
+
+	rpage->page = page;
+	pagewriter_add_free_page(buf, rpage);
+}
+
+/**
+ * 	pagewriter_page_stolen_callback - relay_page page_stolen impl
+ * 	@page: the page released
+ * 	@private_data: contains associated pagewriter_buf
+ *
+ * 	relay has notified us that a page we gave it has been stolen.
+ * 	We simply allocate a new one and add it to the page pool for
+ * 	that buf.
+ */
+static void pagewriter_page_stolen_callback(struct page *page,
+					    void *private_data)
+{
+	struct pagewriter_buf *buf = private_data;
+	struct relay_page *rpage;
+	struct page *new_page;
+
+	new_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (unlikely(!new_page))
+		return;
+	set_page_private(new_page, (unsigned long)buf);
+	rpage = get_empty_rpage_struct(buf);
+
+	rpage->page = new_page;
+	pagewriter_add_free_page(buf, rpage);
+}
+
+static struct relay_page_callbacks pagewriter_relay_page_callbacks = {
+	.page_released	= pagewriter_page_released_callback,
+	.page_stolen	= pagewriter_page_stolen_callback,
+};
+
+/**
+ *	pagewriter_pad_switch_page - switch to a new page
+ *	@buf: channel buffer
+ *	@length: size of current event
+ *	@reserved: a pointer to the space reserved
+ *
+ *	Page switching function for pagewriter_write() functions,
+ *	which don't use padding because they write across page
+ *	boundaries.  Returns the remainder i.e. the amount that should
+ *	be written into the second page.
+ *
+ *	Performs page-switch tasks.
+ */
+void pagewriter_pad_switch_page(struct pagewriter_buf *buf)
+{
+	relay_page(buf);
+	add_empty_rpage_struct(buf, buf->page);
+	switch_to_next_page(buf);
+}
+EXPORT_SYMBOL_GPL(pagewriter_pad_switch_page);
+
+void pagewriter_pad_flight_switch_page(struct pagewriter_buf *buf)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	list_add_tail(&buf->page->list, &buf->pool);
+	spin_unlock_irqrestore(&buf->lock, flags);
+	buf->n_pages_flight++;
+
+	switch_to_next_page(buf);
+}
+EXPORT_SYMBOL_GPL(pagewriter_pad_flight_switch_page);
+
+void pagewriter_nopad_switch_page(struct pagewriter_buf *buf)
+{
+	relay_page(buf);
+	add_empty_rpage_struct(buf, buf->page);
+	switch_to_next_page(buf);
+}
+EXPORT_SYMBOL_GPL(pagewriter_nopad_switch_page);
+
+void pagewriter_nopad_flight_switch_page(struct pagewriter_buf *buf)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	list_add_tail(&buf->page->list, &buf->pool);
+	spin_unlock_irqrestore(&buf->lock, flags);
+	buf->n_pages_flight++;
+
+	switch_to_next_page(buf);
+}
+EXPORT_SYMBOL_GPL(pagewriter_nopad_flight_switch_page);
+
+/**
+ *	__pagewriter_reset - reset a pagewriter
+ *	@buf: the channel buffer
+ *	@init: 1 if this is a first-time initialization
+ *
+ *	See pagewriter_reset() for description of effect.
+ */
+static void __pagewriter_reset(struct pagewriter_buf *buf, unsigned int init)
+{
+	if (init)
+		kref_init(&buf->kref);
+
+	buf->n_pages_flight = 0;
+
+	switch_to_next_page(buf);
+}
+
+static void pagewriter_save_flight_buf(struct pagewriter_buf *buf)
+{
+	size_t first_page, n_pages = buf->n_pages_flight;
+	struct relay_page *first_rpage;
+	unsigned long flags;
+
+	buf->pagewriter->cb->switch_page(buf);
+
+	if(buf->n_pages_flight > buf->pagewriter->n_pages)
+		n_pages = buf->pagewriter->n_pages;
+
+	first_page = buf->pagewriter->n_pages - n_pages;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	list_for_each_entry(first_rpage, &buf->pool, list)
+		if (!first_page--)
+			break;
+
+	list_for_each_entry_from(first_rpage, &buf->pool, list) {
+		if (buf->page->len == PAGE_SIZE) {
+			relay_page(buf);
+			add_empty_rpage_struct_nolock(buf, buf->page);
+		} else {
+			relay_partial_page(buf, buf->page->len);
+			add_empty_rpage_struct_nolock(buf, buf->page);
+		}
+	}
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	__pagewriter_reset(buf, 0);
+}
+
+/**
+ * 	pagewriter_hotcpu_callback - CPU hotplug callback
+ * 	@nb: notifier block
+ * 	@action: hotplug action to take
+ * 	@hcpu: CPU number
+ *
+ * 	Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
+ */
+static int __cpuinit pagewriter_hotcpu_callback(struct notifier_block *nb,
+						unsigned long action,
+						void *hcpu)
+{
+	unsigned int hotcpu = (unsigned long)hcpu;
+	struct pagewriter *pagewriter;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		mutex_lock(&pagewriters_mutex);
+		list_for_each_entry(pagewriter, &pagewriters, list) {
+			if (pagewriter->buf[hotcpu])
+				continue;
+			pagewriter->buf[hotcpu] =
+				pagewriter_open_buf(pagewriter, hotcpu);
+			if (!pagewriter->buf[hotcpu]) {
+				printk(KERN_ERR
+					"pagewriter_hotcpu_callback: cpu %d "
+				       "buffer creation failed\n", hotcpu);
+				mutex_unlock(&pagewriters_mutex);
+				return NOTIFY_BAD;
+			}
+		}
+		mutex_unlock(&pagewriters_mutex);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		/* No need to flush the cpu : will be flushed upon
+		 * final relay_flush() call. */
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static __init int pagewriter_init(void)
+{
+
+	hotcpu_notifier(pagewriter_hotcpu_callback, 0);
+	return 0;
+}
+
+early_initcall(pagewriter_init);
diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
index 41dcc84..9c027b0 100644
--- a/virt/kvm/kvm_trace.c
+++ b/virt/kvm/kvm_trace.c
@@ -15,7 +15,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/relay.h>
+#include <linux/relay_pagewriter.h>
 #include <linux/debugfs.h>
 #include <linux/ktime.h>
 
@@ -27,9 +27,8 @@
 
 struct kvm_trace {
 	int trace_state;
-	struct rchan *rchan;
+	struct pagewriter *pagewriter;
 	struct dentry *lost_file;
-	atomic_t lost_records;
 };
 static struct kvm_trace *kvm_trace;
 
@@ -84,7 +83,7 @@ static void kvm_add_trace(void *probe_private, void *call_data,
 	}
 
 	size = calc_rec_size(p->timestamp_in, extra * sizeof(u32));
-	relay_write(kt->rchan, &rec, size);
+	pagewriter_write(kt->pagewriter, &rec, size);
 }
 
 static struct kvm_trace_probe kvm_trace_probes[] = {
@@ -96,7 +95,7 @@ static int lost_records_get(void *data, u64 *val)
 {
 	struct kvm_trace *kt = data;
 
-	*val = atomic_read(&kt->lost_records);
+	*val = atomic_read(&kt->pagewriter->dropped);
 	return 0;
 }
 
@@ -107,56 +106,31 @@ DEFINE_SIMPLE_ATTRIBUTE(kvm_trace_lost_ops, lost_records_get, NULL, "%llu\n");
  *  many times we encountered a full subbuffer, to tell user space app the
  *  lost records there were.
  */
-static int kvm_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
-				     void *prev_subbuf, size_t prev_padding)
+static void kvm_new_page_callback(struct pagewriter_buf *buf,
+				  void *page_data)
 {
-	struct kvm_trace *kt;
-
-	if (!relay_buf_full(buf)) {
-		if (!prev_subbuf) {
-			/*
-			 * executed only once when the channel is opened
-			 * save metadata as first record
-			 */
-			subbuf_start_reserve(buf, sizeof(u32));
-			*(u32 *)subbuf = 0x12345678;
-		}
-
-		return 1;
+	int magic_written = (int)buf->private_data;
+
+	if (!magic_written) {
+		/*
+		 * executed only once when the channel is opened
+		 * save metadata as first record
+		 */
+		page_start_reserve(buf, sizeof(u32));
+		*(u32 *)page_data = 0x12345678;
+		buf->private_data = (void *)1;
 	}
-
-	kt = buf->chan->private_data;
-	atomic_inc(&kt->lost_records);
-
-	return 0;
-}
-
-static struct dentry *kvm_create_buf_file_callack(const char *filename,
-						 struct dentry *parent,
-						 int mode,
-						 struct rchan_buf *buf,
-						 int *is_global)
-{
-	return debugfs_create_file(filename, mode, parent, buf,
-				   &relay_file_operations);
-}
-
-static int kvm_remove_buf_file_callback(struct dentry *dentry)
-{
-	debugfs_remove(dentry);
-	return 0;
 }
 
-static struct rchan_callbacks kvm_relay_callbacks = {
-	.subbuf_start 		= kvm_subbuf_start_callback,
-	.create_buf_file 	= kvm_create_buf_file_callack,
-	.remove_buf_file 	= kvm_remove_buf_file_callback,
+static struct pagewriter_callbacks kvm_pagewriter_callbacks = {
+	.new_page		= kvm_new_page_callback,
 };
 
 static int do_kvm_trace_enable(struct kvm_user_trace_setup *kuts)
 {
 	struct kvm_trace *kt;
 	int i, r = -ENOMEM;
+	int n_pages, n_pages_wakeup;
 
 	if (!kuts->buf_size || !kuts->buf_nr)
 		return -EINVAL;
@@ -166,15 +140,17 @@ static int do_kvm_trace_enable(struct kvm_user_trace_setup *kuts)
 		goto err;
 
 	r = -EIO;
-	atomic_set(&kt->lost_records, 0);
 	kt->lost_file = debugfs_create_file("lost_records", 0444, kvm_debugfs_dir,
 					    kt, &kvm_trace_lost_ops);
 	if (!kt->lost_file)
 		goto err;
 
-	kt->rchan = relay_open("trace", kvm_debugfs_dir, kuts->buf_size,
-				kuts->buf_nr, &kvm_relay_callbacks, kt);
-	if (!kt->rchan)
+	n_pages = (kuts->buf_size * kuts->buf_nr) / PAGE_SIZE;
+	n_pages_wakeup = kuts->buf_size / PAGE_SIZE;
+	kt->pagewriter = pagewriter_open("trace", kvm_debugfs_dir, n_pages, 0,
+					 n_pages_wakeup,
+					 &kvm_pagewriter_callbacks, kt, 0UL);
+	if (!kt->pagewriter)
 		goto err;
 
 	kvm_trace = kt;
@@ -195,8 +171,8 @@ err:
 	if (kt) {
 		if (kt->lost_file)
 			debugfs_remove(kt->lost_file);
-		if (kt->rchan)
-			relay_close(kt->rchan);
+		if (kt->pagewriter)
+			pagewriter_close(kt->pagewriter);
 		kfree(kt);
 	}
 	return r;
@@ -228,7 +204,7 @@ static int kvm_trace_pause(void)
 
 	if (kt->trace_state == KVM_TRACE_STATE_RUNNING) {
 		kt->trace_state = KVM_TRACE_STATE_PAUSE;
-		relay_flush(kt->rchan);
+		pagewriter_flush(kt->pagewriter);
 		r = 0;
 	}
 
@@ -253,7 +229,7 @@ void kvm_trace_cleanup(void)
 			marker_probe_unregister(p->name, p->probe_func, p);
 		}
 
-		relay_close(kt->rchan);
+		pagewriter_close(kt->pagewriter);
 		debugfs_remove(kt->lost_file);
 		kfree(kt);
 	}
-- 
1.5.3.5



