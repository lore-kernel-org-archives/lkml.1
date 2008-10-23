Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYJWGfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYJWGfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYJWGf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:35:26 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:34209 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267AbYJWGfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:35:23 -0400
X-Authority-Analysis: v=1.0 c=1 a=DBI0Po4I3clMkm4JQ2MA:9
 a=5Olz-JBX2ftkaQMXG5EA:7 a=eMGPhZ3mM9NEUYi27r_8I9tLN0UA:4 a=wZiCkNY6m2YA:10
 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10 a=X-lDvSGlWgMA:10 a=MSl-tDqOz04A:10
 a=b8hG5vVbyAkA:10
Subject: [PATCH 0/1] relay revamp v8
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
Date: Thu, 23 Oct 2008 01:35:14 -0500
Message-Id: <1224743714.11269.12.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's version 8 of the 'relay revamp' patchset.

The difference between this version and version 7 is a set of small
changes needed to make kvm_trace work properly (details below).

I've tested this version with both kvm_trace and blktrace and both
seemed to perform well and without any problems.

At this point, I think the patchset is mergeable - I would have liked
to have had more time for testing, but wanted to post it for
consideration anyway before the 2.6.28 merge window closed; I have the
funny feeling that if it doesn't make it into 2.6.28, it (or the
current relay) won't survive to see 2.6.29.

As I've mentioned previously, I think the end result of all these
changes is really a much nicer, simpler and more powerful design (and
implementation) and for that reason alone, I think it's worthwhile to
consider merging.

But probably the more important reason I'd like to see it in 2.6.28 is
that despite the fact that I turned relay maintainership over two
years ago, I'm still the only one banging my head against the wall
when problems come up, and I just don't want to have to do it any
more; even if I'm not the one maintaining it, it's now much easier for
anyone else to understand what's going on.  A major part of the
headaches had to do with padding and sub-buffers, which are now either
gone or handled in a sane way - over the past several months, I've
spent a lot of late nights digging into a couple of bugs directly
related to those 'features' of the current relay.  Actually, those
features made some sense when the target users were supposed to be
using mmap, which is what relay was originally designed for (splice
didn't even exist then), but they really got in the way of a sane
read(2) implementation, which was basically bolted on as an
afterthought.  As it turned out, once it was added, read(2) ended up
being used pretty much exclusively, which in reality hasn't been a
problem from the user's perspective - it's proven to be very
high-performing and robust - there's really only been one bug reported
and fixed against it, and that basically amounted to a corner case.
Nonetheless, from a maintenance perspective, it wasn't fun to dig up
the cause and fix it.  With the new patchset, that should no longer be
the case.

Finally, the fact that the current relay isn't really broken and
actually performs well means that even if the new changes turn out to
be fatally flawed in some way, they can just be reverted and the
current relay will still be there and will still work the same as
before.

Rather than posting all the individual patches again, I'm just posting
the squashed version.  The description for that patch contains the
overview and API description; if it gets merged, I'll convert all that
to Documentation later.

I'm also appending the end-result relay and relay_pagewriter at the
end of this mail since it may be hard to see the result through all
the individual changes.

Here's the description of the additional patch beyond the previous 23
(rolled into the full patch, and not posted separately):

-- Fixes to make kvm_trace work properly with new relay.

kvm_trace uses the new_page() callback to write a magic number at the
beginning of the first page, but the logic added in an earlier patch
to do that was erroneously using a per-channel flag for that; what's
really needed is a per-buffer flag.  Added a private_data field to
pagewriter_buf for this purpose.  Also discovered that the first page
was being switched twice at the beginning of a trace, so removed the
extra initial page_switch and added it to __pagewriter_reset().

Below is the current relay/relay_pagewriter code after applying all
patches in the patchset, for convenience.

Tom



--- /dev/null	2007-10-15 18:18:04.000000000 -0500
+++ include/linux/relay.h	2008-10-22 23:25:57.000000000 -0500
@@ -0,0 +1,176 @@
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
+	size_t len;
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
+
+/*
+ * exported relay file operations, kernel/relay.c
+ */
+extern const struct file_operations relay_file_operations;
+
+#endif /* _LINUX_RELAY_H */
+
--- /dev/null	2007-10-15 18:18:04.000000000 -0500
+++ kernel/relay.c	2008-10-22 23:26:00.000000000 -0500
@@ -0,0 +1,1015 @@
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
+}
+EXPORT_SYMBOL_GPL(relay_add_partial_page);
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
+	relay_add_partial_page(chan, page, PAGE_SIZE, cb, private_data);
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
+	int i, nr_pages = pagevec_count(pages);
+	struct relay_page *rpage;
+	struct rchan_buf *buf;
+	unsigned long flags;
+
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
+	relay_update_filesize(buf, rpage->len);
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
+	unsigned long flags;
+	size_t avail = 0;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	if (!list_empty(&buf->pages)) {
+		struct relay_page *rpage;
+		rpage = list_first_entry(&buf->pages, struct relay_page, list);
+		avail = rpage->len - buf->consumed_offset;
+	}
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	return avail;
+}
+
+/*
+ *	relay_consume - update the consumed count for the buffer
+ */
+static void relay_consume(struct rchan_buf *buf, int bytes_consumed)
+{
+	unsigned long flags;
+	struct relay_page *rpage;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	rpage = list_first_entry(&buf->pages, struct relay_page, list);
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	buf->consumed_offset += bytes_consumed;
+
+	if (buf->consumed_offset == rpage->len) {
+		__relay_release_page(buf, rpage);
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
+	struct relay_page *rpage;
+	unsigned long flags;
+	int ret = 0;
+	void *from;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	rpage = list_first_entry(&buf->pages, struct relay_page, list);
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	from = page_address(rpage->page);
+	from += rpage->len - avail;
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
+	unsigned long lflags;
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
+	spin_lock_irqsave(&buf->lock, lflags);
+	list_for_each_entry(rpage, &buf->pages, list) {
+		unsigned int this_len;
+
+		if (spd.nr_pages >= nr_pages)
+			break;
+
+		if (!len)
+			break;
+
+		this_len = min_t(unsigned long, len, rpage->len - poff);
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
+	spin_unlock_irqrestore(&buf->lock, lflags);
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
--- /dev/null	2007-10-15 18:18:04.000000000 -0500
+++ include/linux/relay_pagewriter.h	2008-10-22 23:26:03.000000000 -0500
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
--- /dev/null	2007-10-15 18:18:04.000000000 -0500
+++ kernel/relay_pagewriter.c	2008-10-22 23:26:03.000000000 -0500
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


