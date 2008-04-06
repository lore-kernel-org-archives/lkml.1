Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYDFRfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYDFRfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 13:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYDFRfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 13:35:09 -0400
Received: from [194.117.236.238] ([194.117.236.238]:53092 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYDFRfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 13:35:07 -0400
Date: Sun, 6 Apr 2008 20:34:26 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tom Zanussi <zanussi@comcast.net>
Subject: [PATCH] relay: add buffer-only functionality, for early kernel
 tracing
Message-ID: <20080406203426.40431e74@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

relay_open() can now handle NULL base_filename, to register a
buffer-only channel. Using a new function, relay_late_setup_files(), one
can assign files after creating the channel, thus allowing for doing
early tracing in the kernel, before VFS is up. This currently works for
tracing just after kmem_init_cache() runs, no earlier.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 Documentation/filesystems/relay.txt |   11 ++++
 include/linux/relay.h               |    5 ++
 kernel/relay.c                      |  113 ++++++++++++++++++++++++++---------
 3 files changed, 101 insertions(+), 28 deletions(-)

diff --git a/Documentation/filesystems/relay.txt b/Documentation/filesystems/relay.txt
index 094f2d2..b417f83 100644
--- a/Documentation/filesystems/relay.txt
+++ b/Documentation/filesystems/relay.txt
@@ -161,6 +161,7 @@ TBD(curr. line MT:/API/)
     relay_close(chan)
     relay_flush(chan)
     relay_reset(chan)
+    relay_late_setup_files(chan, base_filename, parent)
 
   channel management typically called on instigation of userspace:
 
@@ -294,6 +295,16 @@ user-defined data with a channel, and is immediately available
 (including in create_buf_file()) via chan->private_data or
 buf->chan->private_data.
 
+Buffer-only channels
+--------------------
+
+These channels have no files associated and can be created with
+relay_open(NULL, NULL, ...). Such channels are useful in scenarios such
+as when doing early tracing in the kernel, before the VFS is up. In these
+cases, one may open a buffer-only channel and then call 
+relay_late_setup_files() when the kernel is ready to handle files,
+to expose the buffered data to the userspace.
+
 Channel 'modes'
 ---------------
 
diff --git a/include/linux/relay.h b/include/linux/relay.h
index 6cd8c44..953fc05 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -48,6 +48,7 @@ struct rchan_buf
 	size_t *padding;		/* padding counts per sub-buffer */
 	size_t prev_padding;		/* temporary variable */
 	size_t bytes_consumed;		/* bytes consumed in cur read subbuf */
+	size_t early_bytes;		/* bytes consumed before VFS inited */
 	unsigned int cpu;		/* this buf's cpu */
 } ____cacheline_aligned;
 
@@ -68,6 +69,7 @@ struct rchan
 	int is_global;			/* One global buffer ? */
 	struct list_head list;		/* for channel list */
 	struct dentry *parent;		/* parent dentry passed to open */
+	int has_base_filename;		/* has a filename associated? */
 	char base_filename[NAME_MAX];	/* saved base filename */
 };
 
@@ -169,6 +171,9 @@ struct rchan *relay_open(const char *base_filename,
 			 size_t n_subbufs,
 			 struct rchan_callbacks *cb,
 			 void *private_data);
+extern int relay_late_setup_files(struct rchan *chan,
+				  const char *base_filename,
+				  struct dentry *parent);
 extern void relay_close(struct rchan *chan);
 extern void relay_flush(struct rchan *chan);
 extern void relay_subbufs_consumed(struct rchan *chan,
diff --git a/kernel/relay.c b/kernel/relay.c
index 4c035a8..c1f36f4 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -378,6 +378,35 @@ void relay_reset(struct rchan *chan)
 }
 EXPORT_SYMBOL_GPL(relay_reset);
 
+static int relay_setup_buf_file(struct rchan *chan,
+				struct rchan_buf *buf,
+				unsigned int cpu)
+{
+	struct dentry *dentry;
+ 	char *tmpname;
+
+	tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
+	if (!tmpname)
+		goto failed;
+	snprintf(tmpname, NAME_MAX, "%s%d", chan->base_filename, cpu);
+
+	/* Create file in fs */
+	dentry = chan->cb->create_buf_file(tmpname, chan->parent,
+					   S_IRUSR, buf, 
+					   &chan->is_global);
+	
+	kfree(tmpname);
+
+	if (!dentry)
+		goto failed;
+	buf->dentry = dentry;
+
+	return 0;
+
+failed:
+	return 1;
+}
+
 /*
  *	relay_open_buf - create a new relay channel buffer
  *
@@ -386,44 +415,31 @@ EXPORT_SYMBOL_GPL(relay_reset);
 static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
 {
  	struct rchan_buf *buf = NULL;
-	struct dentry *dentry;
- 	char *tmpname;
 
  	if (chan->is_global)
 		return chan->buf[0];
 
-	tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
- 	if (!tmpname)
- 		goto end;
- 	snprintf(tmpname, NAME_MAX, "%s%d", chan->base_filename, cpu);
-
 	buf = relay_create_buf(chan);
 	if (!buf)
- 		goto free_name;
+ 		goto end;
+
+ 	if (chan->has_base_filename)
+		if (relay_setup_buf_file(chan, buf, cpu)) 
+			goto free_buf;
 
  	buf->cpu = cpu;
  	__relay_reset(buf, 1);
 
-	/* Create file in fs */
- 	dentry = chan->cb->create_buf_file(tmpname, chan->parent, S_IRUSR,
- 					   buf, &chan->is_global);
- 	if (!dentry)
- 		goto free_buf;
-
-	buf->dentry = dentry;
-
  	if(chan->is_global) {
  		chan->buf[0] = buf;
  		buf->cpu = 0;
   	}
 
- 	goto free_name;
+ 	goto end;
 
 free_buf:
  	relay_destroy_buf(buf);
  	buf = NULL;
-free_name:
- 	kfree(tmpname);
 end:
 	return buf;
 }
@@ -508,8 +524,8 @@ static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
 
 /**
  *	relay_open - create a new relay channel
- *	@base_filename: base name of files to create
- *	@parent: dentry of parent directory, %NULL for root directory
+ *	@base_filename: base name of files to create, %NULL for buffering only
+ *	@parent: dentry of parent directory, %NULL for root directory or buffer
  *	@subbuf_size: size of sub-buffers
  *	@n_subbufs: number of sub-buffers
  *	@cb: client callback functions
@@ -531,8 +547,6 @@ struct rchan *relay_open(const char *base_filename,
 {
 	unsigned int i;
 	struct rchan *chan;
-	if (!base_filename)
-		return NULL;
 
 	if (!(subbuf_size && n_subbufs))
 		return NULL;
@@ -547,12 +561,15 @@ struct rchan *relay_open(const char *base_filename,
 	chan->alloc_size = FIX_SIZE(subbuf_size * n_subbufs);
 	chan->parent = parent;
 	chan->private_data = private_data;
-	strlcpy(chan->base_filename, base_filename, NAME_MAX);
+	if (base_filename) {
+		chan->has_base_filename = 1;
+		strlcpy(chan->base_filename, base_filename, NAME_MAX);
+	}
 	setup_callbacks(chan, cb);
 	kref_init(&chan->kref);
 
 	mutex_lock(&relay_channels_mutex);
-	for_each_online_cpu(i) {
+	for_each_present_cpu(i) {
 		chan->buf[i] = relay_open_buf(chan, i);
 		if (!chan->buf[i])
 			goto free_bufs;
@@ -563,7 +580,7 @@ struct rchan *relay_open(const char *base_filename,
 	return chan;
 
 free_bufs:
-	for_each_online_cpu(i) {
+	for_each_present_cpu(i) {
 		if (!chan->buf[i])
 			break;
 		relay_close_buf(chan->buf[i]);
@@ -576,6 +593,41 @@ free_bufs:
 EXPORT_SYMBOL_GPL(relay_open);
 
 /**
+ *	relay_late_setup_files - triggers file creation
+ *	@chan: channel to operate on
+ *	@base_filename: base name of files to create
+ *	@parent: dentry of parent directory, %NULL for root directory
+ *
+ *	Returns 0 if successful, non-zero otherwise.
+ *
+ *	Use to setup files for a previously buffer-only channel.
+ *	Useful to do early tracing in kernel, before VFS is up, for example.
+ */
+int relay_late_setup_files(struct rchan *chan,
+			   const char *base_filename,
+			   struct dentry *parent)
+{
+	unsigned int i;
+	
+	if (!chan || !base_filename)
+		return 1;
+	
+	strlcpy(chan->base_filename, base_filename, NAME_MAX);
+	chan->has_base_filename = 1;
+	chan->parent = parent;
+
+	mutex_lock(&relay_channels_mutex);
+	for_each_present_cpu(i) {
+		relay_setup_buf_file(chan, chan->buf[i], i);
+		chan->buf[i]->dentry->d_inode->i_size =
+			chan->buf[i]->early_bytes;
+	}
+	mutex_unlock(&relay_channels_mutex);
+
+	return 0;
+}
+		
+/**
  *	relay_switch_subbuf - switch to a new sub-buffer
  *	@buf: channel buffer
  *	@length: size of current event
@@ -598,8 +650,13 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
 		old_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
 		buf->padding[old_subbuf] = buf->prev_padding;
 		buf->subbufs_produced++;
-		buf->dentry->d_inode->i_size += buf->chan->subbuf_size -
-			buf->padding[old_subbuf];
+		if (buf->dentry)
+			buf->dentry->d_inode->i_size +=
+				buf->chan->subbuf_size -
+				buf->padding[old_subbuf];
+		else
+			buf->early_bytes += buf->chan->subbuf_size -
+					    buf->padding[old_subbuf];
 		smp_mb();
 		if (waitqueue_active(&buf->read_wait))
 			/*
-- 
1.5.2.5
