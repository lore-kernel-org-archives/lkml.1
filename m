Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXEGOxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXEGOxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933973AbXEGOxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:53:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:24924 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbXEGOxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:53:19 -0400
Date: Mon, 7 May 2007 17:53:20 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: eli@mellanox.co.il, general@lists.openfabrics.org
Subject: Re: [PATCH] IB/mlx4 mlx4_ib: commands timeout
Message-ID: <20070507145320.GA15275@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <1178538772.10759.2.camel@mtls03> <adad51c7me8.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adad51c7me8.fsf@cisco.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Roland Dreier <rdreier@cisco.com>:
> Subject: Re: [PATCH] IB/mlx4 mlx4_ib: commands timeout
> 
>  > When the system is busy it may happen that the command actually
>  > completed but it took more than the specified timeout till the
>  > task executing the command was actually given CPU time. This test
>  > checks that the completion is really missing before failing.
> 
>  > +	if (!wait_for_completion_timeout(&context->done, msecs_to_jiffies(timeout)))
>  > +		if (!context->done.done) {
>  > +			err = -EBUSY;
>  > +			goto out;
>  > +		}
> 
> This seems more like a bug in wait_for_completion_timeout().  Anyway,
> it's definitely not OK to poke inside the definition of struct
> completion in driver code, so we need to find a different way to solve
> this.
> 
> BTW the same completion handling code is in mthca -- is this also a
> problem there?

Google gave me this:
http://lkml.org/lkml/2007/3/1/156
so it seems a similiar problem was observed in mthca.

Thomas, Ingo, I think you were the ones to propose
wait_for_completion_timeout()/wait_for_completion_interruptible_timeout():
would it make sense to change these functions to return -ETIMEDOUT on
timeout, 0 on success? No one seems to use the actual timeout value,
as far as I can see.

Would something like the following, untested, patch, make sense?

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>

--

diff --git a/include/linux/completion.h b/include/linux/completion.h
index 268c5a4..84360c8 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -44,11 +44,10 @@ static inline void init_completion(struct completion *x)
 
 extern void FASTCALL(wait_for_completion(struct completion *));
 extern int FASTCALL(wait_for_completion_interruptible(struct completion *x));
-extern unsigned long FASTCALL(wait_for_completion_timeout(struct completion *x,
-						   unsigned long timeout));
-extern unsigned long FASTCALL(wait_for_completion_interruptible_timeout(
-			struct completion *x, unsigned long timeout));
-
+extern int FASTCALL(wait_for_completion_timeout(struct completion *x,
+						unsigned long timeout));
+extern int FASTCALL(wait_for_completion_interruptible_timeout(struct completion *x,
+							      unsigned long timeout));
 extern void FASTCALL(complete(struct completion *));
 extern void FASTCALL(complete_all(struct completion *));
 
diff --git a/kernel/sched.c b/kernel/sched.c
index b9a6837..5ee3df6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3661,9 +3661,10 @@ void fastcall __sched wait_for_completion(struct completion *x)
 }
 EXPORT_SYMBOL(wait_for_completion);
 
-unsigned long fastcall __sched
+int fastcall __sched
 wait_for_completion_timeout(struct completion *x, unsigned long timeout)
 {
+	int ret = 0;
 	might_sleep();
 
 	spin_lock_irq(&x->wait.lock);
@@ -3672,22 +3673,24 @@ wait_for_completion_timeout(struct completion *x, unsigned long timeout)
 
 		wait.flags |= WQ_FLAG_EXCLUSIVE;
 		__add_wait_queue_tail(&x->wait, &wait);
-		do {
+		for (;;) {
 			__set_current_state(TASK_UNINTERRUPTIBLE);
 			spin_unlock_irq(&x->wait.lock);
 			timeout = schedule_timeout(timeout);
 			spin_lock_irq(&x->wait.lock);
+			if (x->done)
+				break;
 			if (!timeout) {
-				__remove_wait_queue(&x->wait, &wait);
-				goto out;
+				ret = -ETIMEDOUT;
+				break;
 			}
-		} while (!x->done);
+		}
 		__remove_wait_queue(&x->wait, &wait);
 	}
 	x->done--;
 out:
 	spin_unlock_irq(&x->wait.lock);
-	return timeout;
+	return ret;
 }
 EXPORT_SYMBOL(wait_for_completion_timeout);
 
@@ -3724,10 +3727,12 @@ out:
 }
 EXPORT_SYMBOL(wait_for_completion_interruptible);
 
-unsigned long fastcall __sched
+int fastcall __sched
 wait_for_completion_interruptible_timeout(struct completion *x,
 					  unsigned long timeout)
 {
+	int ret = 0;
+
 	might_sleep();
 
 	spin_lock_irq(&x->wait.lock);
@@ -3736,7 +3741,7 @@ wait_for_completion_interruptible_timeout(struct completion *x,
 
 		wait.flags |= WQ_FLAG_EXCLUSIVE;
 		__add_wait_queue_tail(&x->wait, &wait);
-		do {
+		for (;;) {
 			if (signal_pending(current)) {
 				timeout = -ERESTARTSYS;
 				__remove_wait_queue(&x->wait, &wait);
@@ -3746,17 +3751,19 @@ wait_for_completion_interruptible_timeout(struct completion *x,
 			spin_unlock_irq(&x->wait.lock);
 			timeout = schedule_timeout(timeout);
 			spin_lock_irq(&x->wait.lock);
+			if (x->done)
+				break;
 			if (!timeout) {
-				__remove_wait_queue(&x->wait, &wait);
-				goto out;
+				ret = -ETIMEDOUT;
+				break;
 			}
-		} while (!x->done);
+		}
 		__remove_wait_queue(&x->wait, &wait);
 	}
 	x->done--;
 out:
 	spin_unlock_irq(&x->wait.lock);
-	return timeout;
+	return ret;
 }
 EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
 


-- 
MST
