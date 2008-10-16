Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYJPGRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYJPGRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbYJPGNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:13:05 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:42178 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755184AbYJPGND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:13:03 -0400
X-Authority-Analysis: v=1.0 c=1 a=Zow0e3gTvPwA:10 a=1eQj4xbIPsIA:10
 a=z56Yt4NhsqPYbtU2DXgA:9 a=vEA_nnbCKvmdnYmwP5oA:7
 a=E7XEqaLHROjdGdxKZUaExrYALpQA:4 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10
 a=eZLSmJVMEtUA:10
Subject: [RFC PATCH 16/21]  Remove early tracing for now
From: Tom Zanussi <zanussi@comcast.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Jens Axboe <jens.axboe@oracle.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 01:06:35 -0500
Message-Id: <1224137195.16328.235.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove early tracing - for one thing relay doesn't trace any more, for
another, relay is pointless without user files, since its purpose now is
only to relay, after all.

---
 include/linux/relay.h |    6 ---
 kernel/relay.c        |  111 ++++---------------------------------------------
 2 files changed, 8 insertions(+), 109 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index a33b728..1dbed4e 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -49,7 +49,6 @@ struct rchan_buf
 	size_t consumed_offset;		/* bytes consumed in cur page */
 	size_t nr_pages;		/* number of unconsumed pages */
 	unsigned int finalized;		/* buffer has been finalized */
-	size_t early_bytes;		/* bytes consumed before VFS inited */
 	unsigned int cpu;		/* this buf's cpu */
 } ____cacheline_aligned;
 
@@ -65,7 +64,6 @@ struct rchan
 	struct rchan_buf *buf[NR_CPUS]; /* per-cpu channel buffers */
 	struct list_head list;		/* for channel list */
 	struct dentry *parent;		/* parent dentry passed to open */
-	int has_base_filename;		/* has a filename associated? */
 	char base_filename[NAME_MAX];	/* saved base filename */
 	unsigned long flags;		/* relay flags for this channel */
 };
@@ -177,10 +175,6 @@ extern void relay_flush(struct rchan *chan);
 extern void relay_close(struct rchan *chan);
 extern void relay_reset(struct rchan *chan);
 
-extern int relay_late_setup_files(struct rchan *chan,
-				  const char *base_filename,
-				  struct dentry *parent);
-
 /*
  * exported relay file operations, kernel/relay.c
  */
diff --git a/kernel/relay.c b/kernel/relay.c
index b27b655..9c37cd6 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -84,10 +84,7 @@ static void __relay_remove_page(struct rchan_buf *buf,
  */
 static inline void relay_update_filesize(struct rchan_buf *buf, size_t length)
 {
-	if (buf->dentry)
-		buf->dentry->d_inode->i_size +=	length;
-	else
-		buf->early_bytes += length;
+	buf->dentry->d_inode->i_size +=	length;
 }
 
 /**
@@ -386,7 +383,7 @@ static inline void relay_set_buf_dentry(struct rchan_buf *buf,
 					struct dentry *dentry)
 {
 	buf->dentry = dentry;
-	buf->dentry->d_inode->i_size = buf->early_bytes;
+	buf->dentry->d_inode->i_size = 0;
 }
 
 static struct dentry *relay_create_buf_file(struct rchan *chan,
@@ -427,12 +424,10 @@ static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
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
+	relay_set_buf_dentry(buf, dentry);
 
  	buf->cpu = cpu;
  	__relay_reset(buf, 1);
@@ -513,10 +508,8 @@ struct rchan *relay_open(const char *base_filename,
 	chan->flags = rchan_flags;
 
 	chan->private_data = private_data;
-	if (base_filename) {
-		chan->has_base_filename = 1;
-		strlcpy(chan->base_filename, base_filename, NAME_MAX);
-	}
+	strlcpy(chan->base_filename, base_filename, NAME_MAX);
+
 	setup_callbacks(chan, cb);
 	kref_init(&chan->kref);
 
@@ -544,94 +537,6 @@ free_bufs:
 }
 EXPORT_SYMBOL_GPL(relay_open);
 
-struct rchan_percpu_buf_dispatcher {
-	struct rchan_buf *buf;
-	struct dentry *dentry;
-};
-
-/* Called in atomic context. */
-static void __relay_set_buf_dentry(void *info)
-{
-	struct rchan_percpu_buf_dispatcher *p = info;
-
-	relay_set_buf_dentry(p->buf, p->dentry);
-}
-
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
- */
-int relay_late_setup_files(struct rchan *chan,
-			   const char *base_filename,
-			   struct dentry *parent)
-{
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
-}
-
 /**
  *	relay_close - close the channel
  *	@chan: the channel
-- 
1.5.3.5



