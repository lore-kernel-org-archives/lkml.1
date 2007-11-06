Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbXKFTAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbXKFTAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXKFS74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:59:56 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:49054 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbXKFS7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:59:55 -0500
Date: Tue, 6 Nov 2007 23:05:10 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick <gentuu@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cfq: fix IOPRIO_CLASS_IDLE delays
Message-ID: <20071106200510.GA11435@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After the fresh boot:

	ionice -c3 -p $$
	echo cfq >> /sys/block/XXX/queue/scheduler
	dd if=/dev/XXX of=/dev/null bs=512 count=1

Now dd hangs in D state and the queue is completely stalled for approximately
INITIAL_JIFFIES + CFQ_IDLE_GRACE jiffies. This is because cfq_init_queue()
forgets to initialize cfq_data->last_end_request.

(I guess this patch is not complete, overflow is still possible)

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- cfq/block/cfq-iosched.c~	2007-08-09 19:59:26.000000000 +0400
+++ cfq/block/cfq-iosched.c	2007-11-06 22:39:08.000000000 +0300
@@ -2122,6 +2122,7 @@ static void *cfq_init_queue(struct reque
 
 	INIT_WORK(&cfqd->unplug_work, cfq_kick_queue);
 
+	cfqd->last_end_request = jiffies;
 	cfqd->cfq_quantum = cfq_quantum;
 	cfqd->cfq_fifo_expire[0] = cfq_fifo_expire[0];
 	cfqd->cfq_fifo_expire[1] = cfq_fifo_expire[1];

