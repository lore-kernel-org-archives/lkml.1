Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYFUOMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYFUOMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbYFUOML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:12:11 -0400
Received: from [194.117.236.238] ([194.117.236.238]:54452 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbYFUOMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:12:09 -0400
Date: Sat, 21 Jun 2008 17:11:49 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: tzanussi@gmail.com
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] relay: Add buffer-only channels; useful for early
 logging.
Message-ID: <20080621171149.1434e523@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows one to create and use a channel with no associated files. Files
can be initialized later. This is useful in scenarios such as logging
in early code, before VFS is up. Therefore, such channels can be
created and used as soon as kmem_cache_init() completed.

This is needed by kmemtrace to do tracing in early kernel code.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 Documentation/filesystems/relay.txt |   11 +++
 include/linux/relay.h               |    5 +
 kernel/relay.c                      |  141 +++++++++++++++++++++++++++--------
 3 files changed, 126 insertions(+), 31 deletions(-)

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
index a3a03e7..1d3dcf8 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -49,6 +49,7 @@ struct rchan_buf
 	size_t *padding;		/* padding counts per sub-buffer */
 	size_t prev_padding;		/* temporary variable */
 	size_t bytes_consumed;		/* bytes consumed in cur read subbuf */
+	size_t early_bytes;		/* bytes consumed before VFS inited */
 	unsigned int cpu;		/* this buf's cpu */
 } ____cacheline_aligned;
 
@@ -69,6 +70,7 @@ struct rchan
 	int is_global;			/* One global buffer ? */
 	struct list_head list;		/* for channel list */
 	struct dentry *parent;		/* parent dentry passed to open */
+	int has_base_filename;		/* has a filename associated? */
 	char base_filename[NAME_MAX];	/* saved base filename */
 };
 
@@ -170,6 +172,9 @@ struct rchan *relay_open(const char *base_filename,
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
index 250a27a..80a6a40 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -407,6 +407,39 @@ void relay_reset(struct rchan *chan)
 }
 EXPORT_SYMBOL_GPL(relay_reset);
 
+static int relay_setup_buf_file(struct rchan *chan,
+				struct rchan_buf *buf,
+				unsigned int cpu)
+{
+	struct dentry *dentry;
+	unsigned long flags;
+	char *tmpname;
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
+	spin_lock_irqsave(&buf->rw_lock, flags);
+	buf->dentry = dentry;
+	buf->dentry->d_inode->i_size = buf->early_bytes;
+	spin_unlock_irqrestore(&buf->rw_lock, flags);
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
@@ -415,48 +448,33 @@ EXPORT_SYMBOL_GPL(relay_reset);
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
+		return NULL;
 
 	spin_lock_init(&buf->rw_lock);
 
+	if (chan->has_base_filename)
+		if (relay_setup_buf_file(chan, buf, cpu))
+			goto free_buf;
+
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
+	return buf;
 
 free_buf:
  	relay_destroy_buf(buf);
- 	buf = NULL;
-free_name:
- 	kfree(tmpname);
-end:
-	return buf;
+	return NULL;
 }
 
 /**
@@ -539,8 +557,8 @@ static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
 
 /**
  *	relay_open - create a new relay channel
- *	@base_filename: base name of files to create
- *	@parent: dentry of parent directory, %NULL for root directory
+ *	@base_filename: base name of files to create, %NULL for buffering only
+ *	@parent: dentry of parent directory, %NULL for root directory or buffer
  *	@subbuf_size: size of sub-buffers
  *	@n_subbufs: number of sub-buffers
  *	@cb: client callback functions
@@ -562,8 +580,6 @@ struct rchan *relay_open(const char *base_filename,
 {
 	unsigned int i;
 	struct rchan *chan;
-	if (!base_filename)
-		return NULL;
 
 	if (!(subbuf_size && n_subbufs))
 		return NULL;
@@ -578,7 +594,10 @@ struct rchan *relay_open(const char *base_filename,
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
 
@@ -607,6 +626,62 @@ free_bufs:
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
+	int err;
+	struct rchan_buf *buf;
+
+	if (!chan || !base_filename)
+		return 1;
+
+	strlcpy(chan->base_filename, base_filename, NAME_MAX);
+
+	mutex_lock(&relay_channels_mutex);
+	if (unlikely(chan->has_base_filename))
+		goto out;
+	chan->has_base_filename = 1;
+	chan->parent = parent;
+	/*
+	 * The CPU hotplug notifier ran before us and created buffers with
+	 * no files associated. So it's safe to call relay_setup_buf_file()
+	 * on all currently online CPUs.
+	 */
+	for_each_online_cpu(i) {
+		buf = chan->buf[i];
+
+		if (unlikely(!buf)) {
+			printk(KERN_ERR "relay_late_setup_files: "
+			       "all CPUs should have buffers!\n");
+			goto out;
+		}
+
+		err = relay_setup_buf_file(chan, buf, i);
+		if (unlikely(err))
+			goto out;
+	}
+	mutex_unlock(&relay_channels_mutex);
+
+	return 0;
+
+out:
+	mutex_unlock(&relay_channels_mutex);
+	return 1;
+}
+
+/**
  *	relay_switch_subbuf - switch to a new sub-buffer
  *	@buf: channel buffer
  *	@length: size of current event
@@ -629,8 +704,13 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
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
@@ -1241,9 +1321,8 @@ EXPORT_SYMBOL_GPL(relay_file_operations);
 
 static __init int relay_init(void)
 {
-
 	hotcpu_notifier(relay_hotcpu_callback, 0);
 	return 0;
 }
 
-module_init(relay_init);
+early_initcall(relay_init);
-- 
1.5.5.4
