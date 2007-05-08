Return-Path: <linux-kernel-owner+w=401wt.eu-S967426AbXEHNDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967426AbXEHNDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966159AbXEHNDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:03:45 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:58293 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S967264AbXEHNDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:03:44 -0400
Date: Tue, 8 May 2007 17:07:59 +0400
From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
To: linux-kernel@vger.kernel.org
Cc: kbaidarov@ru.mvista.com
Subject: [PATCH] block:  generic_unplug_device implicitly makes irq enable
Message-ID: <20070508170759.1c66352a@windmill.dev.rtsoft.ru>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.19; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while working on LKCD I found out common block device issue.
LKCD uses generic_unplug_device() to finish disk IO in case of blockdev kernel core dump.
I found out that after calling of generic_unplug_device() IRQs become implicitly enabled (it is supposed that IRQs are disabled).
I looked at generic_unplug_device() code and found out that function lose state of irq flags, it use spin_lock_irq()/spin_unlock_irq() instead of spin_lock_irqsave()/spin_unlock_irqrestore():
void generic_unplug_device(request_queue_t *q)
{
	spin_lock_irq(q->queue_lock);
	__generic_unplug_device(q);
	spin_unlock_irq(q->queue_lock);
}

generic_unplug_device() - is a method to unplug the block device, named unplug_fn in struct request_queue.
I've compared generic_unplug_device() with other methods:
file drivers/md/raid5.c ...
static void raid5_unplug_device(request_queue_t *q)
{
	mddev_t *mddev = q->queuedata;
	raid5_conf_t *conf = mddev_to_conf(mddev);
	unsigned long flags;

	spin_lock_irqsave(&conf->device_lock, flags);

	if (blk_remove_plug(q)) {
		conf->seq_flush++;
		raid5_activate_delayed(conf);
	}
	md_wakeup_thread(mddev->thread);

	spin_unlock_irqrestore(&conf->device_lock, flags);

	unplug_slaves(mddev);
}

file drivers/block/umem.c ...
static void mm_unplug_device(request_queue_t *q)
{
	struct cardinfo *card = q->queuedata;
	unsigned long flags;

	spin_lock_irqsave(&card->lock, flags);
	if (blk_remove_plug(q))
		activate(card);
	spin_unlock_irqrestore(&card->lock, flags);
}

As you can see raid5_unplug_device() and mm_unplug_device() are using
spin_lock_irqsave()/spin_unlock_irqrestore(), instead of spin_lock_irq()/spin_unlock_irq().
I found out that generic_unplug_device() is used not only in LKCD, so I suggest to switch generic_unplug_device() to spin_lock_irqsave()/spin_unlock_irqrestore() to prevent implicitly losing of IRQ flags.
Here is patch against kernel 2.6.21.1.
Please CC me to answers/comments.
Thanks.

Signed-off-by: Konstantin Baydarov <kbaidarov@ru.mvista.com>

 block/ll_rw_blk.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.21.1/block/ll_rw_blk.c
===================================================================
--- linux-2.6.21.1.orig/block/ll_rw_blk.c
+++ linux-2.6.21.1/block/ll_rw_blk.c
@@ -1602,9 +1602,11 @@ EXPORT_SYMBOL(__generic_unplug_device);
  **/
 void generic_unplug_device(request_queue_t *q)
 {
-	spin_lock_irq(q->queue_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
 	__generic_unplug_device(q);
-	spin_unlock_irq(q->queue_lock);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL(generic_unplug_device);
 
