Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYJFFXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYJFFXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 01:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYJFFWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 01:22:51 -0400
Received: from qmta08.westchester.pa.mail.comcast.net ([76.96.62.80]:52246
	"EHLO QMTA08.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbYJFFWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 01:22:49 -0400
X-Authority-Analysis: v=1.0 c=1 a=MEeBkdDcnKQQwpBkyGcA:9
 a=heOqlGXQAxGySTy1IM0A:7 a=0NWtKknd7ZH3DiKUfBiKp4nWnLwA:4 a=wZiCkNY6m2YA:10
 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10 a=X-lDvSGlWgMA:10 a=MSl-tDqOz04A:10
 a=gi0PWCVxevcA:10
Subject: [RFC PATCH 0/1] relay revamp v5
From: Tom Zanussi <zanussi@comcast.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1222751080.8703.133.camel@charm-linux>
References: <1222666828.7637.180.camel@charm-linux>
	 <20080929162743.GA15472@Krystal>  <1222751080.8703.133.camel@charm-linux>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 00:22:44 -0500
Message-Id: <1223270564.7054.75.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I decided to go another round with this after all...

The patch following this mail contains the full patch; because there
have been so many changes and it's hard to see from just looking at the
patch the end result, I'm including relay.c and relay.h at the end of
this mail.  The full patch also includes the two new files,
relay_pagewriter.c and .h in for anyone interested in seeing what those
look like.

Basically the patch includes the changes from the previous 11 that I
posted and in addition completely separates the reading part of relay
from the writing part.  With the new changes, relay really does become
just what its name says and and nothing more - it accepts pages from
tracers, and relays the data to userspace via read(2) or splice(2) (and
therefore sendfile(2)).  It doesn't allocate any buffer space and
provides no write functions - those are expected to be supplied by some
other component such as possibly the unified ring-buffer or any other
tracer that might want relay pages of trace data to userspace.

One example of such a component would be the original relay write
functions and buffers (the no-vmap page-based versions of the previous
patchset), which have been split out into a new file called
relay_pagewriter.c and provide one means of writing into pages and
feeding them into relay.  blktrace and kvmtrace have been 'ported' over
to using pagewriter instead of relay directly.

I've only tested the new relay lightly via blktrace, which seems to work
fine, and haven't looked at plugging anything else into it, but after
applying the full patch you should be able to use it to stream e.g.
ftrace/unified trace buffer/ring-buffer trace data to disk or over the
network...

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


That's basically the entire kernel API; the userspace API is of course
just read(), splice(), and sendfile().

Tom

--- /dev/null	2007-10-15 18:18:04.000000000 -0500
+++ include/linux/relay.h	2008-10-05 20:37:19.000000000 -0500
@@ -0,0 +1,170 @@
+/*
+ * linux/include/linux/relay.h
+ *
+ * Copyright (C) 2002, 2003 - Tom Zanussi (zanussi@us.ibm.com), IBM Corp
+ * Copyright (C) 1999, 2000, 2001, 2002 - Karim Yaghmour (karim@opersys.com)
+ * Copyright (C) 2008 - Tom Zanussi (tzanussi@gmail.com)
+ *
+ * CONFIG_RELAY definitions and declarations
+ */
+
+#ifndef _LINUX_RELAY_H
+#define _LINUX_RELAY_H
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/kref.h>
+#include <linux/pagevec.h>
+
+/*
+ * relay channel flags
+ */
+#define RCHAN_GLOBAL_BUFFER		0x00000001	/* not using per-cpu */
+
+/*
+ * For page lists
+ */
+struct relay_page {
+	struct page *page;
+	struct list_head list;
+	struct relay_page_callbacks *cb;
+	void *private_data;
+};
+
+/*
+ * Per-cpu relay channel buffer
+ */
+struct rchan_buf {
+	struct rchan *chan;		/* associated channel */
+	wait_queue_head_t read_wait;	/* reader wait queue */
+	struct timer_list timer; 	/* reader wake-up timer */
+	struct dentry *dentry;		/* channel file dentry */
+	struct kref kref;		/* channel buffer refcount */
+	struct list_head pages;		/* current set of unconsumed pages */
+	size_t nr_pages;		/* number of unconsumed pages */
+	spinlock_t lock;		/* protect pages list */
+	size_t consumed_offset;		/* bytes consumed in cur page */
+	unsigned int finalized;		/* buffer has been finalized */
+	unsigned int cpu;		/* this buf's cpu */
+} ____cacheline_aligned;
+
+/*
+ * Relay channel data structure
+ */
+struct rchan
+{
+	size_t n_pages_wakeup;		/* wake up readers after filling n */
+	struct rchan_callbacks *cb;	/* client callbacks */
+	struct kref kref;		/* channel refcount */
+	void *private_data;		/* for user-defined data */
+	struct rchan_buf *buf[NR_CPUS]; /* per-cpu channel buffers */
+	struct list_head list;		/* for channel list */
+	struct dentry *parent;		/* parent dentry passed to open */
+	char base_filename[NAME_MAX];	/* saved base filename */
+	unsigned long flags;		/* relay flags for this channel */
+};
+
+/*
+ * Relay channel client callbacks
+ */
+struct rchan_callbacks
+{
+	/*
+	 * create_buf_file - create file to represent a relay channel buffer
+	 * @filename: the name of the file to create
+	 * @parent: the parent of the file to create
+	 * @mode: the mode of the file to create
+	 * @buf: the channel buffer
+	 *
+	 * Called during relay_open(), once for each per-cpu buffer,
+	 * to allow the client to create a file to be used to
+	 * represent the corresponding channel buffer.  If the file is
+	 * created outside of relay, the parent must also exist in
+	 * that filesystem.
+	 *
+	 * The callback should return the dentry of the file created
+	 * to represent the relay buffer.
+	 *
+	 * See Documentation/filesystems/relayfs.txt for more info.
+	 */
+	struct dentry *(*create_buf_file)(const char *filename,
+					  struct dentry *parent,
+					  int mode,
+					  struct rchan_buf *buf);
+
+	/*
+	 * remove_buf_file - remove file representing a relay channel buffer
+	 * @dentry: the dentry of the file to remove
+	 *
+	 * Called during relay_close(), once for each per-cpu buffer,
+	 * to allow the client to remove a file used to represent a
+	 * channel buffer.
+	 *
+	 * The callback should return 0 if successful, negative if not.
+	 */
+	int (*remove_buf_file)(struct dentry *dentry);
+};
+
+/*
+ * Relay page callbacks
+ */
+struct relay_page_callbacks
+{
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
+
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
+
+/*
+ * CONFIG_RELAY kernel API, kernel/relay.c
+ */
+
+extern struct rchan *relay_open(const char *base_filename,
+				struct dentry *parent,
+				size_t n_pages_wakeup,
+				struct rchan_callbacks *cb,
+				void *private_data,
+				unsigned long rchan_flags);
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
+
+/*
+ * exported relay file operations, kernel/relay.c
+ */
+extern const struct file_operations relay_file_operations;
+
+#endif /* _LINUX_RELAY_H */
+
--- /dev/null	2007-10-15 18:18:04.000000000 -0500
+++ kernel/relay.c	2008-10-05 20:37:19.000000000 -0500
@@ -0,0 +1,969 @@
+/*
+ * Public API and common code for kernel->userspace relay file support.
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
+#include <linux/mm.h>
+#include <linux/cpu.h>
+#include <linux/splice.h>
+#include <linux/debugfs.h>
+
+/* list of open channels, for cpu hotplug */
+static DEFINE_MUTEX(relay_channels_mutex);
+static LIST_HEAD(relay_channels);
+
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
+/*
+ * relay kernel API
+ */
+
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
+ */
+struct rchan *relay_open(const char *base_filename,
+			 struct dentry *parent,
+			 size_t n_pages_wakeup,
+			 struct rchan_callbacks *cb,
+			 void *private_data,
+			 unsigned long rchan_flags)
+{
+	unsigned int i;
+	struct rchan *chan;
+
+	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
+	if (!chan)
+		return NULL;
+
+	chan->n_pages_wakeup = n_pages_wakeup;
+	chan->parent = parent;
+	chan->flags = rchan_flags;
+
+	chan->private_data = private_data;
+	strlcpy(chan->base_filename, base_filename, NAME_MAX);
+
+	setup_callbacks(chan, cb);
+	kref_init(&chan->kref);
+
+	mutex_lock(&relay_channels_mutex);
+	for_each_online_cpu(i) {
+		chan->buf[i] = relay_open_buf(chan, i);
+		if (!chan->buf[i])
+			goto free_bufs;
+	}
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
+}
+EXPORT_SYMBOL_GPL(relay_open);
+
+/**
+ *	relay_add_page - add a page to relay
+ *	@chan: the relay channel
+ *	@page: the page to add
+ *	@cb: relay_page callbacks associated with the page
+ *	@private_data: user data to be associated with the relay_page
+ *
+ *	Add a page to relay.  When the page has been read by
+ *	userspace, the owner will be notified.  If the page has been
+ *	copied and is available for re-use by the owner, the
+ *	relay_page_callbacks page_released() callback will be invoked.
+ *	If the page has been stolen, the owner will be notified of
+ *	this fact via the page_stolen() callback; because the
+ *	page_stolen() (and page_released()) callbacks are called from
+ *	user context, the owner can allocate a new page using
+ *	GFP_KERNEL if it wants to.
+ */
+void relay_add_page(struct rchan *chan,
+		    struct page *page,
+		    struct relay_page_callbacks *cb,
+		    void *private_data)
+{
+	struct relay_page *rpage;
+	struct rchan_buf *buf;
+
+	buf = chan->buf[get_cpu()];
+	rpage = __relay_get_rpage(buf);
+
+	if (likely(rpage)) {
+		rpage->page = page;
+		set_page_private(rpage->page, (unsigned long)buf);
+		rpage->cb = cb;
+		rpage->private_data = private_data;
+		__relay_add_page(buf, rpage);
+	}
+	put_cpu();
+}
+EXPORT_SYMBOL_GPL(relay_add_page);
+
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
+	struct relay_page *rpage;
+	struct rchan_buf *buf;
+	unsigned long flags;
+	int i, nr_pages = pagevec_count(pages);
+
+	buf = chan->buf[get_cpu()];
+	spin_lock_irqsave(&buf->lock, flags);
+	for (i = 0; i < nr_pages; i--) {
+		rpage = __relay_get_rpage(buf);
+
+		if (likely(rpage)) {
+			rpage->page = pages->pages[i];
+			set_page_private(rpage->page, (unsigned long)buf);
+			rpage->cb = cb;
+			rpage->private_data = private_data;
+			__relay_add_page_nolock(buf, rpage);
+		}
+	}
+	spin_unlock_irqrestore(&buf->lock, flags);
+	put_cpu();
+
+	relay_wakeup_readers(buf);
+}
+EXPORT_SYMBOL_GPL(relay_add_pages);
+
+/**
+ *	relay_flush - flush the channel
+ *	@chan: the channel
+ *
+ *	Flushes all channel buffers, i.e. wakes up readers
+ */
+void relay_flush(struct rchan *chan)
+{
+	unsigned int i;
+	size_t prev_wakeup = chan->n_pages_wakeup;
+
+	if (!chan)
+		return;
+
+	if (prev_wakeup)
+		chan->n_pages_wakeup = 1;
+
+	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
+		chan->n_pages_wakeup = prev_wakeup;
+		return;
+	}
+
+	mutex_lock(&relay_channels_mutex);
+	for_each_possible_cpu(i)
+		if (chan->buf[i])
+			relay_wakeup_readers(chan->buf[i]);
+	mutex_unlock(&relay_channels_mutex);
+	chan->n_pages_wakeup = prev_wakeup;
+}
+EXPORT_SYMBOL_GPL(relay_flush);
+
+/**
+ *	relay_close - close the channel
+ *	@chan: the channel
+ *
+ *	Closes all channel buffers and frees the channel.
+ */
+void relay_close(struct rchan *chan)
+{
+	unsigned int i;
+
+	if (!chan)
+		return;
+
+	mutex_lock(&relay_channels_mutex);
+	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0])
+		relay_close_buf(chan->buf[0]);
+	else
+		for_each_possible_cpu(i)
+			if (chan->buf[i])
+				relay_close_buf(chan->buf[i]);
+
+	list_del(&chan->list);
+	kref_put(&chan->kref, relay_destroy_channel);
+	mutex_unlock(&relay_channels_mutex);
+}
+EXPORT_SYMBOL_GPL(relay_close);
+
+/**
+ *	relay_reset - reset the channel
+ *	@chan: the channel
+ *
+ *	This has the effect of erasing all data from all channel buffers
+ *	and restarting the channel in its initial state.
+ *
+ *	NOTE. Care should be taken that the channel isn't actually
+ *	being used by anything when this call is made.
+ */
+void relay_reset(struct rchan *chan)
+{
+	unsigned int i;
+
+	if (!chan)
+		return;
+
+	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
+		__relay_reset(chan->buf[0], 0);
+		return;
+	}
+
+	mutex_lock(&relay_channels_mutex);
+	for_each_online_cpu(i)
+		if (chan->buf[i])
+			__relay_reset(chan->buf[i], 0);
+	mutex_unlock(&relay_channels_mutex);
+}
+EXPORT_SYMBOL_GPL(relay_reset);
+
+/*
+ * end relay kernel API
+ */
+
+/**
+ *	relay_update_filesize - increase relay file i_size by length
+ *	@buf: relay channel buffer
+ *	@length: length to add
+ */
+static inline void relay_update_filesize(struct rchan_buf *buf, size_t length)
+{
+	buf->dentry->d_inode->i_size +=	length;
+}
+
+/**
+ *	__relay_get_rpage - get an empty relay page struct
+ *	@buf: the buffer struct
+ */
+static inline struct relay_page *__relay_get_rpage(struct rchan_buf *buf)
+{
+	return kmalloc(sizeof(struct relay_page), GFP_ATOMIC);
+}
+
+static inline void __relay_add_page_nolock(struct rchan_buf *buf,
+					   struct relay_page *rpage)
+{
+	list_add_tail(&rpage->list, &buf->pages);
+	buf->nr_pages++;
+	relay_update_filesize(buf, PAGE_SIZE);
+}
+
+static inline void __relay_add_page(struct rchan_buf *buf,
+				    struct relay_page *rpage)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	__relay_add_page_nolock(buf, rpage);
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	relay_wakeup_readers(buf);
+}
+
+/**
+ *	__relay_remove_page - remove a page from relay
+ *	@buf: the buffer struct
+ *	@rpage: struct relay_page
+ */
+static void __relay_remove_page(struct rchan_buf *buf,
+				struct relay_page *rpage)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	list_del(&rpage->list);
+	buf->nr_pages--;
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	kfree(rpage);
+}
+
+/**
+ *	__relay_release_page - remove page from relay and notify owner
+ *	@buf: the buffer struct
+ *	@rpage: struct relay_page
+ */
+static void __relay_release_page(struct rchan_buf *buf,
+				 struct relay_page *rpage)
+{
+	if (rpage->cb && rpage->cb->page_released)
+		rpage->cb->page_released(rpage->page, rpage->private_data);
+
+	__relay_remove_page(buf, rpage);
+}
+
+/**
+ *	relay_destroy_channel - free the channel struct
+ *	@kref: target kernel reference that contains the relay channel
+ *
+ *	Should only be called from kref_put().
+ */
+static void relay_destroy_channel(struct kref *kref)
+{
+	struct rchan *chan = container_of(kref, struct rchan, kref);
+	kfree(chan);
+}
+
+/**
+ *	relay_destroy_buf - destroy an rchan_buf struct and release pages
+ *	@buf: the buffer struct
+ */
+static void relay_destroy_buf(struct rchan_buf *buf)
+{
+	struct rchan *chan = buf->chan;
+	struct relay_page *rpage, *rpage2;
+
+	list_for_each_entry_safe(rpage, rpage2, &buf->pages, list)
+		__relay_release_page(buf, rpage);
+
+	chan->buf[buf->cpu] = NULL;
+	kfree(buf);
+	kref_put(&chan->kref, relay_destroy_channel);
+}
+
+/**
+ *	relay_remove_buf - remove a channel buffer
+ *	@kref: target kernel reference that contains the relay buffer
+ *
+ *	Removes the file from the fileystem, which also frees the
+ *	rchan_buf_struct and the channel buffer.  Should only be called from
+ *	kref_put().
+ */
+static void relay_remove_buf(struct kref *kref)
+{
+	struct rchan_buf *buf = container_of(kref, struct rchan_buf, kref);
+	buf->chan->cb->remove_buf_file(buf->dentry);
+	relay_destroy_buf(buf);
+}
+
+/**
+ *	relay_close_buf - close a channel buffer
+ *	@buf: channel buffer
+ *
+ *	Marks the buffer finalized.  The channel buffer and channel
+ *	buffer data structure are then freed automatically when the
+ *	last reference is given up.
+ */
+static void relay_close_buf(struct rchan_buf *buf)
+{
+	buf->finalized = 1;
+	del_timer_sync(&buf->timer);
+	kref_put(&buf->kref, relay_remove_buf);
+}
+
+static struct dentry *relay_create_buf_file(struct rchan *chan,
+					    struct rchan_buf *buf,
+					    unsigned int cpu)
+{
+	struct dentry *dentry;
+	char *tmpname;
+
+	tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
+	if (!tmpname)
+		return NULL;
+	snprintf(tmpname, NAME_MAX, "%s%d", chan->base_filename, cpu);
+
+	/* Create file in fs */
+	dentry = chan->cb->create_buf_file(tmpname, chan->parent,
+					   S_IRUSR, buf);
+
+	kfree(tmpname);
+
+	return dentry;
+}
+
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
+/*
+ *	relay_open_buf - create a new relay channel buffer
+ *
+ *	used by relay_open() and CPU hotplug.
+ */
+static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
+{
+ 	struct rchan_buf *buf = NULL;
+	struct dentry *dentry;
+
+	if (chan->flags & RCHAN_GLOBAL_BUFFER)
+		return chan->buf[0];
+
+	buf = relay_create_buf(chan);
+	if (!buf)
+		return NULL;
+
+	dentry = relay_create_buf_file(chan, buf, cpu);
+	if (!dentry)
+		goto free_buf;
+	buf->dentry = dentry;
+	buf->dentry->d_inode->i_size = 0;
+
+ 	buf->cpu = cpu;
+ 	__relay_reset(buf, 1);
+
+	if (chan->flags & RCHAN_GLOBAL_BUFFER) {
+ 		chan->buf[0] = buf;
+ 		buf->cpu = 0;
+  	}
+
+	return buf;
+
+free_buf:
+ 	relay_destroy_buf(buf);
+	return NULL;
+}
+
+/**
+ *	relay_wakeup_readers - wake up readers if applicable
+ *	@buf: relay channel buffer
+ *
+ *	Will wake up readers after each buf->n_pages_wakeup pages have
+ *	been produced.  To do no waking up, simply pass 0 into relay
+ *	open for this value.
+ */
+static inline void relay_wakeup_readers(struct rchan_buf *buf)
+{
+	size_t wakeup = buf->chan->n_pages_wakeup;
+
+	if (wakeup && (buf->nr_pages % wakeup == 0) &&
+	    (waitqueue_active(&buf->read_wait)))
+		/*
+		 * Calling wake_up_interruptible() from here
+		 * will deadlock if we happen to be logging
+		 * from the scheduler (trying to re-grab
+		 * rq->lock), so defer it.
+		 */
+		__mod_timer(&buf->timer, jiffies + 1);
+}
+
+/**
+ *	wakeup_readers - wake up readers waiting on a channel
+ *	@data: contains the channel buffer
+ *
+ *	This is the timer function used to defer reader waking.
+ */
+static void wakeup_readers(unsigned long data)
+{
+	struct rchan_buf *buf = (struct rchan_buf *)data;
+	wake_up_interruptible(&buf->read_wait);
+}
+
+/**
+ *	__relay_reset - reset a channel buffer
+ *	@buf: the channel buffer
+ *	@init: 1 if this is a first-time initialization
+ *
+ *	See relay_reset() for description of effect.
+ */
+static void __relay_reset(struct rchan_buf *buf, unsigned int init)
+{
+	struct relay_page *rpage, *rpage2;
+
+	if (init) {
+		init_waitqueue_head(&buf->read_wait);
+		kref_init(&buf->kref);
+		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
+	} else
+		del_timer_sync(&buf->timer);
+
+	list_for_each_entry_safe(rpage, rpage2, &buf->pages, list)
+		__relay_release_page(buf, rpage);
+
+	buf->consumed_offset = 0;
+	buf->finalized = 0;
+}
+
+/*
+ * create_buf_file_create() default callback.  Creates debugfs file.
+ */
+static struct dentry *create_buf_file_default_callback(const char *filename,
+						       struct dentry *parent,
+						       int mode,
+						       struct rchan_buf *buf)
+{
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+/*
+ * remove_buf_file() default callback.  Removes debugfs file.
+ */
+static int remove_buf_file_default_callback(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+	return 0;
+}
+
+/* relay channel default callbacks */
+static struct rchan_callbacks default_channel_callbacks = {
+	.create_buf_file = create_buf_file_default_callback,
+	.remove_buf_file = remove_buf_file_default_callback,
+};
+
+static void setup_callbacks(struct rchan *chan, struct rchan_callbacks *cb)
+{
+	if (!cb) {
+		chan->cb = &default_channel_callbacks;
+		return;
+	}
+
+	if (!cb->create_buf_file)
+		cb->create_buf_file = create_buf_file_default_callback;
+	if (!cb->remove_buf_file)
+		cb->remove_buf_file = remove_buf_file_default_callback;
+	chan->cb = cb;
+}
+
+/*
+ * relay userspace implementations
+ */
+
+/**
+ *	relay_file_open - open file op for relay files
+ *	@inode: the inode
+ *	@filp: the file
+ *
+ *	Increments the channel buffer refcount.
+ */
+static int relay_file_open(struct inode *inode, struct file *filp)
+{
+	struct rchan_buf *buf = inode->i_private;
+	kref_get(&buf->kref);
+	filp->private_data = buf;
+
+	return nonseekable_open(inode, filp);
+}
+
+/**
+ *	relay_file_poll - poll file op for relay files
+ *	@filp: the file
+ *	@wait: poll table
+ *
+ *	Poll implemention.
+ */
+static unsigned int relay_file_poll(struct file *filp, poll_table *wait)
+{
+	unsigned int mask = 0;
+	struct rchan_buf *buf = filp->private_data;
+
+	if (buf->finalized)
+		return POLLERR;
+
+	if (filp->f_mode & FMODE_READ) {
+		poll_wait(filp, &buf->read_wait, wait);
+		if (buf->nr_pages)
+			mask |= POLLIN | POLLRDNORM;
+	}
+
+	return mask;
+}
+
+/**
+ *	relay_file_release - release file op for relay files
+ *	@inode: the inode
+ *	@filp: the file
+ *
+ *	Decrements the channel refcount, as the filesystem is
+ *	no longer using it.
+ */
+static int relay_file_release(struct inode *inode, struct file *filp)
+{
+	struct rchan_buf *buf = filp->private_data;
+	kref_put(&buf->kref, relay_remove_buf);
+
+	return 0;
+}
+
+/**
+ *	relay_file_read_page_avail - return bytes available in next page
+ *	@buf: relay channel buffer
+ */
+static size_t relay_file_read_page_avail(struct rchan_buf *buf)
+{
+	size_t avail = 0;
+
+	if (!list_empty(&buf->pages))
+		avail = PAGE_SIZE - buf->consumed_offset;
+
+	return avail;
+}
+
+/*
+ *	relay_consume - update the consumed count for the buffer
+ */
+static void relay_consume(struct rchan_buf *buf, int bytes_consumed)
+{
+	buf->consumed_offset += bytes_consumed;
+
+	if (buf->consumed_offset == PAGE_SIZE) {
+		struct relay_page *rpage;
+		rpage = list_first_entry(&buf->pages, struct relay_page, list);
+		__relay_release_page(buf, rpage);
+
+		buf->consumed_offset = 0;
+	}
+}
+
+/*
+ *	page_read_actor - read up to one page's worth of data
+ */
+static int page_read_actor(struct rchan_buf *buf,
+			   size_t avail,
+			   read_descriptor_t *desc,
+			   read_actor_t actor)
+{
+	void *from;
+	int ret = 0;
+	struct relay_page *rpage;
+
+	rpage = list_first_entry(&buf->pages, struct relay_page, list);
+
+	from = page_address(rpage->page);
+	from += PAGE_SIZE - avail;
+	ret = avail;
+	if (copy_to_user(desc->arg.buf, from, avail)) {
+		desc->error = -EFAULT;
+		ret = 0;
+	}
+	desc->arg.data += ret;
+	desc->written += ret;
+	desc->count -= ret;
+
+	return ret;
+}
+
+typedef int (*page_actor_t) (struct rchan_buf *buf,
+			     size_t avail,
+			     read_descriptor_t *desc,
+			     read_actor_t actor);
+
+/*
+ *	relay_file_read_pages - read count bytes, bridging page boundaries
+ */
+static ssize_t relay_file_read_pages(struct file *filp, loff_t *ppos,
+				     page_actor_t page_actor,
+				     read_actor_t actor,
+				     read_descriptor_t *desc)
+{
+	struct rchan_buf *buf = filp->private_data;
+	size_t avail;
+	int ret;
+
+	if (!desc->count)
+		return 0;
+
+	mutex_lock(&filp->f_path.dentry->d_inode->i_mutex);
+	do {
+		avail = relay_file_read_page_avail(buf);
+		if (!avail)
+			break;
+		avail = min(desc->count, avail);
+		ret = page_actor(buf, avail, desc, actor);
+		if (desc->error < 0)
+			break;
+		if (ret) {
+			relay_consume(buf, ret);
+			*ppos += ret;
+		}
+	} while (desc->count && ret);
+	mutex_unlock(&filp->f_path.dentry->d_inode->i_mutex);
+
+	return desc->written;
+}
+
+static ssize_t relay_file_read(struct file *filp,
+			       char __user *buffer,
+			       size_t count,
+			       loff_t *ppos)
+{
+	read_descriptor_t desc;
+	desc.written = 0;
+	desc.count = count;
+	desc.arg.buf = buffer;
+	desc.error = 0;
+	return relay_file_read_pages(filp, ppos, page_read_actor,
+				     NULL, &desc);
+}
+
+static void relay_pipe_buf_release(struct pipe_inode_info *pipe,
+				   struct pipe_buffer *pipe_buf)
+{
+	struct rchan_buf *buf;
+
+	buf = (struct rchan_buf *)page_private(pipe_buf->page);
+	relay_consume(buf, pipe_buf->private);
+}
+
+static int relay_pipe_buf_steal(struct pipe_inode_info *pipe,
+				struct pipe_buffer *pipe_buf)
+{
+	int ret;
+	struct rchan_buf *buf;
+
+	buf = (struct rchan_buf *)page_private(pipe_buf->page);
+	ret = generic_pipe_buf_steal(pipe, pipe_buf);
+	if (!ret) {
+		struct relay_page *rpage;
+		rpage = list_first_entry(&buf->pages, struct relay_page, list);
+		__relay_remove_page(buf, rpage);
+		if (rpage->cb && rpage->cb->page_stolen)
+			rpage->cb->page_stolen(pipe_buf->page,
+					       rpage->private_data);
+	}
+
+	return ret;
+}
+
+static struct pipe_buf_operations relay_pipe_buf_ops = {
+	.can_merge = 0,
+	.map = generic_pipe_buf_map,
+	.unmap = generic_pipe_buf_unmap,
+	.confirm = generic_pipe_buf_confirm,
+	.release = relay_pipe_buf_release,
+	.steal = relay_pipe_buf_steal,
+	.get = generic_pipe_buf_get,
+};
+
+static void relay_page_release(struct splice_pipe_desc *spd, unsigned int i)
+{
+}
+
+/*
+ *	page_splice_actor - splice available data
+ */
+static int page_splice_actor(struct file *in,
+			     struct pipe_inode_info *pipe,
+			     size_t len,
+			     unsigned int flags)
+{
+	unsigned int poff, total_len, nr_pages, ret;
+	struct rchan_buf *buf = in->private_data;
+	struct relay_page *rpage;
+	struct page *pages[PIPE_BUFFERS];
+	struct partial_page partial[PIPE_BUFFERS];
+	struct splice_pipe_desc spd = {
+		.pages = pages,
+		.nr_pages = 0,
+		.partial = partial,
+		.flags = flags,
+		.ops = &relay_pipe_buf_ops,
+		.spd_release = relay_page_release,
+	};
+
+	if (list_empty(&buf->pages))
+		return 0;
+
+	poff = buf->consumed_offset;
+	nr_pages = min_t(unsigned int, buf->nr_pages, PIPE_BUFFERS);
+	total_len = 0;
+
+	list_for_each_entry(rpage, &buf->pages, list) {
+		unsigned int this_len;
+
+		if (spd.nr_pages >= nr_pages)
+			break;
+
+		if (!len)
+			break;
+
+		this_len = min_t(unsigned long, len, PAGE_SIZE - poff);
+
+		spd.pages[spd.nr_pages] = rpage->page;
+		spd.partial[spd.nr_pages].offset = poff;
+		spd.partial[spd.nr_pages].len = this_len;
+		spd.partial[spd.nr_pages].private = this_len;
+
+		len -= this_len;
+		total_len += this_len;
+		poff = 0;
+		spd.nr_pages++;
+	}
+
+	ret = splice_to_pipe(pipe, &spd);
+
+        return ret;
+}
+
+static ssize_t relay_file_splice_read(struct file *in,
+				      loff_t *ppos,
+				      struct pipe_inode_info *pipe,
+				      size_t len,
+				      unsigned int flags)
+{
+	ssize_t spliced;
+	int ret;
+
+	ret = 0;
+	spliced = 0;
+
+	while (len && !spliced) {
+		ret = page_splice_actor(in, pipe, len, flags);
+		if (ret < 0)
+			break;
+		else if (!ret) {
+			if (spliced)
+				break;
+			if (flags & SPLICE_F_NONBLOCK) {
+				ret = -EAGAIN;
+				break;
+			}
+		}
+
+		*ppos += ret;
+		if (ret > len)
+			len = 0;
+		else
+			len -= ret;
+		spliced += ret;
+	}
+
+	if (spliced)
+		return spliced;
+
+	return ret;
+}
+
+const struct file_operations relay_file_operations = {
+	.open		= relay_file_open,
+	.poll		= relay_file_poll,
+	.read		= relay_file_read,
+	.llseek		= no_llseek,
+	.release	= relay_file_release,
+	.splice_read	= relay_file_splice_read,
+};
+EXPORT_SYMBOL_GPL(relay_file_operations);
+
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
+{
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
+
+static __init int relay_init(void)
+{
+	hotcpu_notifier(relay_hotcpu_callback, 0);
+	return 0;
+}
+
+early_initcall(relay_init);


