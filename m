Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbYD2UEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbYD2UEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYD2UE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:04:28 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17827 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbYD2UE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:04:27 -0400
Date: Tue, 29 Apr 2008 22:04:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [bug - scsi/blk] -git, WARNING: at include/linux/blkdev.h:427  __blk_run_queue+0x74/0xa0()
Message-ID: <20080429200419.GF12774@kernel.dk>
References: <20080429195508.GA30109@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429195508.GA30109@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29 2008, Ingo Molnar wrote:
> 
> x86.git auto-testing found two new warnings below with latest -git:
> 
>  WARNING: at include/linux/blkdev.h:439 blk_remove_plug+0x69/0x80()
>  WARNING: at include/linux/blkdev.h:427 __blk_run_queue+0x74/0xa0()
> 
> one seems a relatively harmless init locking bug (unlocked access in a 
> probe function), the other seems scarier as it happens in an irq handler 
> and it likely would trigger multiple times if it wasnt a WARN_ON_ONCE().
> 
> Config and full log at:
> 
>  http://redhat.com/~mingo/misc/log-Tue_Apr_29_21_40_46_CEST_2008.bad
>  http://redhat.com/~mingo/misc/config-Tue_Apr_29_21_40_46_CEST_2008.bad

404 on those, but I think Bart and I already closed this one:

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 669b65c..9e2e23b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -418,8 +418,12 @@ struct request_queue
 
 static inline int queue_is_locked(struct request_queue *q)
 {
+#ifdef CONFIG_SMP
 	spinlock_t *lock = q->queue_lock;
 	return lock && spin_is_locked(lock);
+#else
+	return 1;
+#endif
 }
 
 static inline void queue_flag_set_unlocked(unsigned int flag,

-- 
Jens Axboe

