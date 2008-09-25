Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbYIYGI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbYIYGI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYIYGHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:07:39 -0400
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:35759
	"EHLO QMTA07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532AbYIYGHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:07:38 -0400
X-Authority-Analysis: v=1.0 c=1 a=WB0yaNWoo4YA:10 a=qHhMY6xanEoA:10
 a=rJv3afqXiQcjoyf599cA:9 a=b4r9fNxe9091E4xIwjYA:7
 a=gemvp36d1nDBPY8RKVtBux6mTGgA:4 a=DIuwkUbe1fkA:10
Subject: [RFC PATCH 3/8] relay - Add channel flags to relay, remove global
	callback param.
From: Tom Zanussi <zanussi@comcast.net>
To: Martin Bligh <mbligh@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
In-Reply-To: <1222228215.7761.0.camel@charm-linux>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	 <20080922140740.GB5279@in.ibm.com>
	 <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
	 <1222147545.6875.135.camel@charm-linux>
	 <33307c790809230700o4bf0d22fg8ab2dcb904f7d66c@mail.gmail.com>
	 <1222228215.7761.0.camel@charm-linux>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 01:07:35 -0500
Message-Id: <1222322855.6435.58.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

relay should probably have had a flags param from the beginning; it
wasn't originally added because it wasn't originally needed - it
probably would have helped avoid some of the callback contortions
that were added due to a lack of flags.  This adds them and does a
small amount of low-hanging cleanup, and is also in preparation for
some new flags in future patches.
---
 block/blktrace.c      |    5 ++---
 include/linux/relay.h |   19 ++++++++++---------
 kernel/relay.c        |   20 ++++++++++----------
 virt/kvm/kvm_trace.c  |    9 ++++-----
 4 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index eb9651c..150c5f7 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -356,8 +356,7 @@ static int blk_remove_buf_file_callback(struct dentry *dentry)
 static struct dentry *blk_create_buf_file_callback(const char *filename,
 						   struct dentry *parent,
 						   int mode,
-						   struct rchan_buf *buf,
-						   int *is_global)
+						   struct rchan_buf *buf)
 {
 	return debugfs_create_file(filename, mode, parent, buf,
 					&relay_file_operations);
@@ -424,7 +423,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 		goto err;
 
 	bt->rchan = relay_open("trace", dir, buts->buf_size,
-				buts->buf_nr, &blk_relay_callbacks, bt);
+			       buts->buf_nr, &blk_relay_callbacks, bt, 0UL);
 	if (!bt->rchan)
 		goto err;
 
diff --git a/include/linux/relay.h b/include/linux/relay.h
index a1dcfc1..648b4da 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -28,6 +28,12 @@
 #define RELAYFS_CHANNEL_VERSION		7
 
 /*
+ * relay channel flags
+ */
+#define RCHAN_MODE_OVERWRITE		0x00000001	/* 'flight' mode */
+#define RCHAN_GLOBAL_BUFFER		0x00000002	/* not using per-cpu */
+
+/*
  * Per-cpu relay channel buffer
  */
 struct rchan_buf
@@ -66,11 +72,11 @@ struct rchan
 	void *private_data;		/* for user-defined data */
 	size_t last_toobig;		/* tried to log event > subbuf size */
 	struct rchan_buf *buf[NR_CPUS]; /* per-cpu channel buffers */
-	int is_global;			/* One global buffer ? */
 	struct list_head list;		/* for channel list */
 	struct dentry *parent;		/* parent dentry passed to open */
 	int has_base_filename;		/* has a filename associated? */
 	char base_filename[NAME_MAX];	/* saved base filename */
+	unsigned long flags;		/* relay flags for this channel */
 };
 
 /*
@@ -125,7 +131,6 @@ struct rchan_callbacks
 	 * @parent: the parent of the file to create
 	 * @mode: the mode of the file to create
 	 * @buf: the channel buffer
-	 * @is_global: outparam - set non-zero if the buffer should be global
 	 *
 	 * Called during relay_open(), once for each per-cpu buffer,
 	 * to allow the client to create a file to be used to
@@ -136,17 +141,12 @@ struct rchan_callbacks
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
@@ -191,7 +191,8 @@ struct rchan *relay_open(const char *base_filename,
 			 size_t subbuf_size,
 			 size_t n_subbufs,
 			 struct rchan_callbacks *cb,
-			 void *private_data);
+			 void *private_data,
+			 unsigned long rchan_flags);
 extern int relay_late_setup_files(struct rchan *chan,
 				  const char *base_filename,
 				  struct dentry *parent);
diff --git a/kernel/relay.c b/kernel/relay.c
index f1f55ae..d7a6458 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -310,8 +310,7 @@ static void buf_unmapped_default_callback(struct rchan_buf *buf,
 static struct dentry *create_buf_file_default_callback(const char *filename,
 						       struct dentry *parent,
 						       int mode,
-						       struct rchan_buf *buf,
-						       int *is_global)
+						       struct rchan_buf *buf)
 {
 	return NULL;
 }
@@ -411,7 +410,7 @@ void relay_reset(struct rchan *chan)
 	if (!chan)
 		return;
 
-	if (chan->is_global && chan->buf[0]) {
+	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
 		__relay_reset(chan->buf[0], 0);
 		return;
 	}
@@ -445,8 +444,7 @@ static struct dentry *relay_create_buf_file(struct rchan *chan,
 
 	/* Create file in fs */
 	dentry = chan->cb->create_buf_file(tmpname, chan->parent,
-					   S_IRUSR, buf,
-					   &chan->is_global);
+					   S_IRUSR, buf);
 
 	kfree(tmpname);
 
@@ -463,7 +461,7 @@ static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
  	struct rchan_buf *buf = NULL;
 	struct dentry *dentry;
 
- 	if (chan->is_global)
+	if (chan->flags & RCHAN_GLOBAL_BUFFER)
 		return chan->buf[0];
 
 	buf = relay_create_buf(chan);
@@ -480,7 +478,7 @@ static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
  	buf->cpu = cpu;
  	__relay_reset(buf, 1);
 
- 	if(chan->is_global) {
+	if(chan->flags & RCHAN_GLOBAL_BUFFER) {
  		chan->buf[0] = buf;
  		buf->cpu = 0;
   	}
@@ -595,7 +593,8 @@ struct rchan *relay_open(const char *base_filename,
 			 size_t subbuf_size,
 			 size_t n_subbufs,
 			 struct rchan_callbacks *cb,
-			 void *private_data)
+			 void *private_data,
+			 unsigned long rchan_flags)
 {
 	unsigned int i;
 	struct rchan *chan;
@@ -612,6 +611,7 @@ struct rchan *relay_open(const char *base_filename,
 	chan->subbuf_size = subbuf_size;
 	chan->alloc_size = FIX_SIZE(subbuf_size * n_subbufs);
 	chan->parent = parent;
+	chan->flags = rchan_flags;
 	chan->private_data = private_data;
 	if (base_filename) {
 		chan->has_base_filename = 1;
@@ -828,7 +828,7 @@ void relay_close(struct rchan *chan)
 		return;
 
 	mutex_lock(&relay_channels_mutex);
-	if (chan->is_global && chan->buf[0])
+	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0])
 		relay_close_buf(chan->buf[0]);
 	else
 		for_each_possible_cpu(i)
@@ -859,7 +859,7 @@ void relay_flush(struct rchan *chan)
 	if (!chan)
 		return;
 
-	if (chan->is_global && chan->buf[0]) {
+	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
 		chan->cb->switch_subbuf(chan->buf[0], 0);
 		return;
 	}
diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
index 58141f3..d0a9e1c 100644
--- a/virt/kvm/kvm_trace.c
+++ b/virt/kvm/kvm_trace.c
@@ -130,10 +130,9 @@ static int kvm_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
 }
 
 static struct dentry *kvm_create_buf_file_callack(const char *filename,
-						 struct dentry *parent,
-						 int mode,
-						 struct rchan_buf *buf,
-						 int *is_global)
+						  struct dentry *parent,
+						  int mode,
+						  struct rchan_buf *buf)
 {
 	return debugfs_create_file(filename, mode, parent, buf,
 				   &relay_file_operations);
@@ -171,7 +170,7 @@ static int do_kvm_trace_enable(struct kvm_user_trace_setup *kuts)
 		goto err;
 
 	kt->rchan = relay_open("trace", kvm_debugfs_dir, kuts->buf_size,
-				kuts->buf_nr, &kvm_relay_callbacks, kt);
+			       kuts->buf_nr, &kvm_relay_callbacks, kt, 0UL);
 	if (!kt->rchan)
 		goto err;
 
-- 
1.5.3.5



