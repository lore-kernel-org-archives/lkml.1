Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbZBLNZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbZBLNZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 08:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757647AbZBLNZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 08:25:37 -0500
Received: from mail.suse.de ([195.135.220.2]:53123 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757681AbZBLNZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 08:25:36 -0500
Message-ID: <4994234D.1000404@suse.de>
Date: Thu, 12 Feb 2009 14:25:33 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Deadlock during multipath failover
References: <20090212094022.GA4973@schmichrtp.de.ibm.com>
In-Reply-To: <20090212094022.GA4973@schmichrtp.de.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christof,

Christof Schmitt wrote:
> During failover tests on a current distribution kernel, we found this
> problem. From reading the code, the upstream kernel has the same
> problem:
> 
> During multipath failover tests with SCSI on System z, the kernel
> deadlocks in this situation:
> 
>>  STACK:
>>  0 blk_add_timer+206 [0x2981ea]
>>  1 blk_rq_timed_out+132 [0x2982a8]
>>  2 blk_abort_request+114 [0x29833e]
>>  3 blk_abort_queue+92 [0x2983a8]
>>  4 deactivate_path+74 [0x3e00009625a]
>>  5 run_workqueue+236 [0x149e04]
>>  6 worker_thread+294 [0x149fce]
>>  7 kthread+110 [0x14f436]
>>  8 kernel_thread_starter+6 [0x10941a]
> 
> blk_abort_queue takes the queue_lock with spinlock_irqsave and walks
> the timer_list with list_for_each_entry_safe. Since a path to a SCSI
> device just failed, the rport state is FC_PORTSTATE_BLOCKED. This
> rport state triggers blk_add_timer that calls list_add_tail to move
> the request to the end of timer_list. Thus, the
> list_for_each_entry_safe never reaches the end of the timer_list, it
> continously moves the requests to the end of the list.
> 
Hmm. That would be fixes by using list_splice() here:

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index a095353..67bcc3f 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -209,12 +209,15 @@ void blk_abort_queue(struct request_queue *q)
 {
        unsigned long flags;
        struct request *rq, *tmp;
+       LIST_HEAD(list);
 
        spin_lock_irqsave(q->queue_lock, flags);
 
        elv_abort_queue(q);
 
-       list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list)
+       list_splice_init(&q->timeout_list, &list);
+
+       list_for_each_entry_safe(rq, tmp, &list, timeout_list)
                blk_abort_request(rq);
 
        spin_unlock_irqrestore(q->queue_lock, flags);

> The rport state FC_PORTSTATE_BLOCKED would end, when the function
> fc_timeout_deleted_rport would run to remove the rport. But this
> function was schedules from queue_delayed_work. The timer already
> expired, but the timer function does not run, because the timer
> interrupt is disabled from the spinlock_irqsave call.
> 
.. but this shouldn't happen anymore when using splice, as
the timer will be called _after_ the irqrestore above.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
