Return-Path: <linux-kernel-owner+w=401wt.eu-S1765628AbXJTMPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765628AbXJTMPd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 08:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXJTMPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 08:15:25 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49764 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXJTMPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 08:15:24 -0400
Date: Sat, 20 Oct 2007 16:20:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Nick <gentuu@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cfq_exit_queue() should cancel cfq_data->unplug_work
Message-ID: <20071020122015.GA2487@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(untested, needs an explicit ack/nack from maintainer)

Spotted by Nick <gentuu@gmail.com>, perhaps explains the first trace in
http://bugzilla.kernel.org/show_bug.cgi?id=9180.

cfq_exit_queue() should cancel cfqd->unplug_work before freeing cfqd.
blk_sync_queue() seems unneeded, removed.

Q: why cfq_exit_queue() calls cfq_shutdown_timer_wq() twice?

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- K/block/cfq-iosched.c~1_cfq	2007-08-09 19:59:26.000000000 +0400
+++ K/block/cfq-iosched.c	2007-10-20 15:48:35.000000000 +0400
@@ -2053,7 +2053,7 @@ static void cfq_shutdown_timer_wq(struct
 {
 	del_timer_sync(&cfqd->idle_slice_timer);
 	del_timer_sync(&cfqd->idle_class_timer);
-	blk_sync_queue(cfqd->queue);
+	kblockd_flush_work(&cfqd->unplug_work);
 }
 
 static void cfq_put_async_queues(struct cfq_data *cfqd)

