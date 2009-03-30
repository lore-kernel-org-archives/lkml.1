Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbZC3B7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbZC3B7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbZC3B7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:59:12 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:33041 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbZC3B7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:59:12 -0400
Message-ID: <49D0276D.2060708@oss.ntt.co.jp>
Date: Mon, 30 Mar 2009 10:59:09 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] vfs: Add  wbcflush sysfs knob to disable storage device
 writeback cache flushes
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp>
In-Reply-To: <49D01F94.6000101@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a sysfs knob to disable storage device writeback cache flushes.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.29-orig/block/blk-barrier.c linux-2.6.29/block/blk-barrier.c
--- linux-2.6.29-orig/block/blk-barrier.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/block/blk-barrier.c	2009-03-29 17:55:45.000000000 +0900
@@ -318,6 +318,9 @@ int blkdev_issue_flush(struct block_devi
  	if (!q)
  		return -ENXIO;

+	if (blk_queue_nowbcflush(q))
+		return -EOPNOTSUPP;
+
  	bio = bio_alloc(GFP_KERNEL, 0);
  	if (!bio)
  		return -ENOMEM;
diff -urNp linux-2.6.29-orig/block/blk-core.c linux-2.6.29/block/blk-core.c
--- linux-2.6.29-orig/block/blk-core.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/block/blk-core.c	2009-03-29 18:09:18.000000000 +0900
@@ -1452,7 +1452,8 @@ static inline void __generic_make_reques
  			goto end_io;
  		}
  		if (bio_barrier(bio) && bio_has_data(bio) &&
-		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+		    (blk_queue_nowbcflush(q) ||
+		     q->next_ordered == QUEUE_ORDERED_NONE)) {
  			err = -EOPNOTSUPP;
  			goto end_io;
  		}
diff -urNp linux-2.6.29-orig/block/blk-sysfs.c linux-2.6.29/block/blk-sysfs.c
--- linux-2.6.29-orig/block/blk-sysfs.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/block/blk-sysfs.c	2009-03-30 10:21:38.000000000 +0900
@@ -151,6 +151,27 @@ static ssize_t queue_nonrot_store(struct
  	return ret;
  }

+static ssize_t queue_wbcflush_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(!blk_queue_nowbcflush(q), page);
+}
+
+static ssize_t queue_wbcflush_store(struct request_queue *q, const char *page,
+				    size_t count)
+{
+	unsigned long nm;
+	ssize_t ret = queue_var_store(&nm, page, count);
+
+	spin_lock_irq(q->queue_lock);
+	if (nm)
+		queue_flag_clear(QUEUE_FLAG_NOWBCFLUSH , q);
+	else
+		queue_flag_set(QUEUE_FLAG_NOWBCFLUSH , q);
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
+
  static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
  {
  	return queue_var_show(blk_queue_nomerges(q), page);
@@ -258,6 +279,12 @@ static struct queue_sysfs_entry queue_no
  	.store = queue_nonrot_store,
  };

+static struct queue_sysfs_entry queue_wbcflush_entry = {
+	.attr = {.name = "wbcflush", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_wbcflush_show,
+	.store = queue_wbcflush_store,
+};
+
  static struct queue_sysfs_entry queue_nomerges_entry = {
  	.attr = {.name = "nomerges", .mode = S_IRUGO | S_IWUSR },
  	.show = queue_nomerges_show,
@@ -284,6 +311,7 @@ static struct attribute *default_attrs[]
  	&queue_iosched_entry.attr,
  	&queue_hw_sector_size_entry.attr,
  	&queue_nonrot_entry.attr,
+	&queue_wbcflush_entry.attr,
  	&queue_nomerges_entry.attr,
  	&queue_rq_affinity_entry.attr,
  	&queue_iostats_entry.attr,
diff -urNp linux-2.6.29-orig/include/linux/blkdev.h linux-2.6.29/include/linux/blkdev.h
--- linux-2.6.29-orig/include/linux/blkdev.h	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/include/linux/blkdev.h	2009-03-30 10:23:34.000000000 +0900
@@ -452,6 +452,7 @@ struct request_queue
  #define QUEUE_FLAG_NONROT      14	/* non-rotational device (SSD) */
  #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
  #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
+#define QUEUE_FLAG_NOWBCFLUSH  16	/* disable write-back cache flushing */

  #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
  				 (1 << QUEUE_FLAG_CLUSTER) |		\
@@ -572,6 +573,8 @@ enum {
  #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
  #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
  #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
+#define blk_queue_nowbcflush(q)	\
+	test_bit(QUEUE_FLAG_NOWBCFLUSH, &(q)->queue_flags)
  #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
  #define blk_queue_flushing(q)	((q)->ordseq)
  #define blk_queue_stackable(q)	\
