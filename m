Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab0BVK06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:26:58 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40233 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0BVK04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:26:56 -0500
Message-ID: <4B825982.3060606@ct.jp.nec.com>
Date: Mon, 22 Feb 2010 19:16:34 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>, Greg KH <gregkh@suse.de>,
       Alasdair G Kergon <agk@redhat.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Junichi Nomura <j-nomura@ce.jp.nec.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [Stable-review] [93/93] dm mpath: fix stall when requeueing io
References: <20100219163257.186977438@kvm.kroah.org> <4B815A3D.9040402@canonical.com>
In-Reply-To: <4B815A3D.9040402@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alasdair, Greg,

Please replace this patch with the patch attached below.
This patch seems to have been broken somewhere, since the original
patch (*) for 2.6.33-rc6 cosmetically depends on another patch included
in 2.6.33-rc1.
  (*) http://marc.info/?l=dm-devel&m=126518144727377&w=2

Stefan, thank you for spotting this.

BTW, as for your spin lock question, the spin_lock_irq could be spin_lock.
Please see my answer below for details.

On 02/22/2010 01:07 AM +0900, Stefan Bader wrote:
>> @@ -1568,12 +1575,16 @@ static void dm_request_fn(struct request
>>  
>>  		blk_start_request(rq);
>>  		spin_unlock(q->queue_lock);
>> -		map_request(ti, rq, md);
>> +		if (map_request(ti, rq, md))
>> +			goto requeued;
>>  		spin_lock_irq(q->queue_lock);
>>  	}
> 
> That is the current state of dm_request_function:
> 
>                 clone = rq->special;
>                 atomic_inc(&md->pending[rq_data_dir(clone)]);
> 
>                 spin_unlock(q->queue_lock);
>                 if (map_request(ti, clone, md))
> 
> While looking over the code I also noticed that the spinlock is dropped with
> spin_unlock and then reacquired with spin_lock_irq. Isn't the irq version too
> much in that case? Or was the intention to have interrupts enabled when unlocking?

In the current device-mapper code, I would like to go with
spin_unlock/lock here.
However, there was a case to enable irq in map_requst() for request
allocation, and this spin_lock_irq was a work-around for the case.
Now, there is no such case in the device-mapper code, so spin_lock should
be enough here.  But I'm still using spin_lock_irq for safeness, since
there might be some more cases to enable irq during request submission
to underlying devices.
I'll remove the _irq in the future after lots of testings.


REVISED PATCH:
This patch fixes the problem that system may stall if target's ->map_rq
returns DM_MAPIO_REQUEUE in map_request().
E.g. stall happens on 1 CPU box when a dm-mpath device with queue_if_no_path
     bounces between all-paths-down and paths-up on I/O load.

When target's ->map_rq returns DM_MAPIO_REQUEUE, map_request() requeues
the request and returns to dm_request_fn().  Then, dm_request_fn()
doesn't exit the I/O dispatching loop and continues processing
the requeued request again.
This map and requeue loop can be done with interrupt disabled,
so 1 CPU system can be stalled if this situation happens.

For example, commands below can stall my 1 CPU box within 1 minute or so:
  # dmsetup table mp
  mp: 0 2097152 multipath 1 queue_if_no_path 0 1 1 service-time 0 1 2 8:144 1 1
  # while true; do dd if=/dev/mapper/mp of=/dev/null bs=1M count=100; done &
  # while true; do \
  > dmsetup message mp 0 "fail_path 8:144" \
  > dmsetup suspend --noflush mp \
  > dmsetup resume mp \
  > dmsetup message mp 0 "reinstate_path 8:144" \
  > done

To fix the problem above, this patch changes dm_request_fn() to exit
the I/O dispatching loop once if a request is requeued in map_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/dm.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: 2.6.32.8/drivers/md/dm.c
===================================================================
--- 2.6.32.8.orig/drivers/md/dm.c
+++ 2.6.32.8/drivers/md/dm.c
@@ -1487,10 +1487,15 @@ static int dm_prep_fn(struct request_que
 	return BLKPREP_OK;
 }
 
-static void map_request(struct dm_target *ti, struct request *rq,
-			struct mapped_device *md)
+/*
+ * Returns:
+ * 0  : the request has been processed (not requeued)
+ * !0 : the request has been requeued
+ */
+static int map_request(struct dm_target *ti, struct request *rq,
+		       struct mapped_device *md)
 {
-	int r;
+	int r, requeued = 0;
 	struct request *clone = rq->special;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
@@ -1516,6 +1521,7 @@ static void map_request(struct dm_target
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
 		dm_requeue_unmapped_request(clone);
+		requeued = 1;
 		break;
 	default:
 		if (r > 0) {
@@ -1527,6 +1533,8 @@ static void map_request(struct dm_target
 		dm_kill_unmapped_request(clone, r);
 		break;
 	}
+
+	return requeued;
 }
 
 /*
@@ -1568,12 +1576,17 @@ static void dm_request_fn(struct request
 
 		blk_start_request(rq);
 		spin_unlock(q->queue_lock);
-		map_request(ti, rq, md);
+		if (map_request(ti, rq, md))
+			goto requeued;
+
 		spin_lock_irq(q->queue_lock);
 	}
 
 	goto out;
 
+requeued:
+	spin_lock_irq(q->queue_lock);
+
 plug_and_out:
 	if (!elv_queue_empty(q))
 		/* Some requests still remain, retry later */
