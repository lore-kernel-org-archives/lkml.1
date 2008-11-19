Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYKSORb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYKSORb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbYKSORV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:17:21 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:43958 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbYKSORU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:17:20 -0500
Date: Wed, 19 Nov 2008 15:15:31 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, Fabio Checconi <fchecconi@gmail.com>
Subject: Re: [PATCH] Exiting queue and task might race to free cic
Message-ID: <20081119141531.GG26308@kernel.dk>
References: <200811191527.18539.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811191527.18539.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19 2008, Nikanth Karthikesan wrote:
> Hi Jens
> 
> Looking at the bug reported here
> http://thread.gmane.org/gmane.linux.kernel/722539
> it looks like an exiting queue can race with an exiting task.
> 
> When a queue exits the queue lock is taken and cfq_exit_queue() would free all 
> the cic's associated with the queue.
> 
> But when a task exits, cfq_exit_io_context() gets cic one by one and then 
> locks the associated queue to call __cfq_exit_single_io_context. It looks like 
> between getting a cic from the ioc and locking the queue, the queue might have 
> exited on another cpu. Isn't this possible?
> 
> If possible, either verifying whether cic->key is still not null or q->flags 
> does not have QUEUE_FLAG_DEAD set would fix this.
> 
> Thanks
> Nikanth Karthikesan
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 6a062ee..b9b627a 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1318,7 +1318,12 @@ static void cfq_exit_single_io_context(struct 
> io_context *ioc,
>  		unsigned long flags;
>  
>  		spin_lock_irqsave(q->queue_lock, flags);
> -		__cfq_exit_single_io_context(cfqd, cic);
> +		/*
> +		 * cic might have been already exited when an exiting task
> +		 * races with an exiting queue.
> +		 */
> +		if (likely(cic->key))
> +			__cfq_exit_single_io_context(cfqd, cic);
>  		spin_unlock_irqrestore(q->queue_lock, flags);
>  	}
>  }

Not sure this is enough, we probably need to copy the key to ensure that
we get a fresh value. How does this look?

Did you actually trigger this, or is it just from code inspection?

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6a062ee..560cd1c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1318,7 +1318,14 @@ static void cfq_exit_single_io_context(struct io_context *ioc,
 		unsigned long flags;
 
 		spin_lock_irqsave(q->queue_lock, flags);
-		__cfq_exit_single_io_context(cfqd, cic);
+
+		/*
+		 * Ensure we get a fresh copy of the ->key to prevent
+		 * race between exiting task and queue
+		 */
+		smp_read_barrier_depends();
+		if (cic->key)
+			__cfq_exit_single_io_context(cfqd, cic);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 }

-- 
Jens Axboe

