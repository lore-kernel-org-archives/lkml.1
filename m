Return-Path: <linux-kernel-owner+w=401wt.eu-S1764902AbYD2TOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764902AbYD2TOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYD2TOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:14:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbYD2TOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:14:39 -0400
Date: Tue, 29 Apr 2008 15:12:21 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, Mike Anderson <andmike@linux.vnet.ibm.com>,
       Alasdair Graeme Kergon <agk@redhat.com>
Subject: [PATCH] Optimize lock in queue unplugging
Message-ID: <Pine.LNX.4.64.0804291459030.17110@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Mike Anderson was doing an OLTP benchmark on a computer with 48 physical 
disks mapped to one logical device via device mapper.

He found that there was a slowdown on request_queue->lock in function 
generic_unplug_device. The slowdown is caused by the fact that when some 
code calls unplug on the device mapper, device mapper calls unplug on all 
physical disks. These unplug calls take the lock, find that the queue is 
already unplugged, release the lock and exit.

With the below patch, performance of the benchmark was increased by 18% 
(the whole OLTP application, not just block layer microbenchmarks).

So I'm submitting this patch for upstream. I think the patch is correct, 
because when more threads call simultaneously plug and unplug, it is 
unspecified, if the queue is or isn't plugged (so the patch can't make 
this worse). And the caller that plugged the queue should unplug it 
anyway. (if it doesn't, there's 3ms timeout).

Mikulas


Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
  block/blk-core.c |    3 +++
  1 file changed, 3 insertions(+)

Index: linux-2.6.25/block/blk-core.c
===================================================================
--- linux-2.6.25.orig/block/blk-core.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/block/blk-core.c	2008-04-29 18:50:37.000000000 +0200
@@ -271,6 +271,9 @@ EXPORT_SYMBOL(__generic_unplug_device);
   **/
  void generic_unplug_device(struct request_queue *q)
  {
+	if (likely(!blk_queue_plugged(q)))
+		return;
+
  	spin_lock_irq(q->queue_lock);
  	__generic_unplug_device(q);
  	spin_unlock_irq(q->queue_lock);
