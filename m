Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbYFLU1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbYFLU1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758345AbYFLU0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:26:37 -0400
Received: from [194.117.236.238] ([194.117.236.238]:39361 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbYFLU0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:26:36 -0400
Date: Thu, 12 Jun 2008 23:26:18 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: tzanussi@gmail.com
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] relay: Fix race condition which occurs when reading
 across CPUs.
Message-ID: <20080612232618.647f5cda@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppose CPU0, as instructed by userspace, reads CPU1's data. If the
latter is logging data, it's not enough to disable IRQs or preemption
to protect the data. Added a per-buffer (thus per-CPU) spinlock to
prevent concurrent access. The choice of using a spinlock is motivated
by the need to log data (and thus lock the buffer) from interrupt
context. The problem was revealed when working on kmemtrace, where some
events were seemingly out-of-order or just all-zeros, even though the
necessary precautions had already been taken.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/linux/relay.h |   10 +++++++---
 kernel/relay.c        |    8 ++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 8593ca1..a3a03e7 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -38,6 +38,7 @@ struct rchan_buf
 	size_t subbufs_produced;	/* count of sub-buffers produced */
 	size_t subbufs_consumed;	/* count of sub-buffers consumed */
 	struct rchan *chan;		/* associated channel */
+	spinlock_t rw_lock;		/* protects buffer during R/W */
 	wait_queue_head_t read_wait;	/* reader wait queue */
 	struct timer_list timer; 	/* reader wake-up timer */
 	struct dentry *dentry;		/* channel file dentry */
@@ -200,13 +201,14 @@ static inline void relay_write(struct rchan *chan,
 	unsigned long flags;
 	struct rchan_buf *buf;
 
-	local_irq_save(flags);
-	buf = chan->buf[smp_processor_id()];
+	buf = chan->buf[get_cpu()];
+	spin_lock_irqsave(&buf->rw_lock, flags);
 	if (unlikely(buf->offset + length >= chan->subbuf_size))
 		length = relay_switch_subbuf(buf, length);
 	memcpy(buf->data + buf->offset, data, length);
 	buf->offset += length;
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&buf->rw_lock, flags);
+	put_cpu();
 }
 
 /**
@@ -228,10 +230,12 @@ static inline void __relay_write(struct rchan *chan,
 	struct rchan_buf *buf;
 
 	buf = chan->buf[get_cpu()];
+	spin_lock(&buf->rw_lock);
 	if (unlikely(buf->offset + length >= buf->chan->subbuf_size))
 		length = relay_switch_subbuf(buf, length);
 	memcpy(buf->data + buf->offset, data, length);
 	buf->offset += length;
+	spin_unlock(&buf->rw_lock);
 	put_cpu();
 }
 
diff --git a/kernel/relay.c b/kernel/relay.c
index 07f25e7..1d2c3d1 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -430,6 +430,8 @@ static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
 	if (!buf)
  		goto free_name;
 
+	spin_lock_init(&buf->rw_lock);
+
  	buf->cpu = cpu;
  	__relay_reset(buf, 1);
 
@@ -1013,11 +1015,13 @@ static ssize_t relay_file_read_subbufs(struct file *filp, loff_t *ppos,
 	struct rchan_buf *buf = filp->private_data;
 	size_t read_start, avail;
 	int ret;
+	unsigned long flags;
 
 	if (!desc->count)
 		return 0;
 
 	mutex_lock(&filp->f_path.dentry->d_inode->i_mutex);
+	spin_lock_irqsave(&buf->rw_lock, flags);
 	do {
 		if (!relay_file_read_avail(buf, *ppos))
 			break;
@@ -1028,15 +1032,19 @@ static ssize_t relay_file_read_subbufs(struct file *filp, loff_t *ppos,
 			break;
 
 		avail = min(desc->count, avail);
+		/* subbuf_actor may sleep, so release the spinlock for now */
+		spin_unlock_irqrestore(&buf->rw_lock, flags);
 		ret = subbuf_actor(read_start, buf, avail, desc, actor);
 		if (desc->error < 0)
 			break;
+		spin_lock_irqsave(&buf->rw_lock, flags);
 
 		if (ret) {
 			relay_file_read_consume(buf, read_start, ret);
 			*ppos = relay_file_read_end_pos(buf, read_start, ret);
 		}
 	} while (desc->count && ret);
+	spin_unlock_irqrestore(&buf->rw_lock, flags);
 	mutex_unlock(&filp->f_path.dentry->d_inode->i_mutex);
 
 	return desc->written;
-- 
1.5.5.4

