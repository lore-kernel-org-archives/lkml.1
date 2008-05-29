Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYE2GmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYE2GmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 02:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYE2GmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 02:42:06 -0400
Received: from brick.kernel.dk ([87.55.233.238]:6575 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbYE2GmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 02:42:05 -0400
Date: Thu, 29 May 2008 08:42:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc4: RIP __call_for_each_cic+0x20/0x50
Message-ID: <20080529064202.GI25504@kernel.dk>
References: <20080510103719.GA4967@martell.zuzino.mipt.ru> <20080527052740.GB28301@martell.zuzino.mipt.ru> <20080527133510.GV7712@kernel.dk> <20080527151809.GA14296@linux.vnet.ibm.com> <20080528100721.GQ25504@kernel.dk> <20080528103026.GE8255@linux.vnet.ibm.com> <20080528124423.GV25504@kernel.dk> <20080528132012.GF8255@linux.vnet.ibm.com> <20080529043852.GA15489@linux.vnet.ibm.com> <20080529062617.GH25504@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529062617.GH25504@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29 2008, Jens Axboe wrote:
> > But one additional question...
> > 
> > 	static void cfq_cic_free_rcu(struct rcu_head *head)
> > 	{
> > 		struct cfq_io_context *cic;
> > 
> > 		cic = container_of(head, struct cfq_io_context, rcu_head);
> > 
> > 		kmem_cache_free(cfq_ioc_pool, cic);
> > 		elv_ioc_count_dec(ioc_count);
> > 
> > 		if (ioc_gone && !elv_ioc_count_read(ioc_count))
> > 			complete(ioc_gone);
> > 	}
> > 
> > Suppose that a pair of tasks both execute the elv_ioc_count_dec()
> > at the same time, so that all counters are now zero.  Both then
> > find that there is still an ioc_gone, and that the count is
> > now zero.  One of the tasks invokes complete(ioc_gone).  This
> > awakens the corresponding cfq_exit(), which now returns, getting
> > rid of its stack frame -- and corrupting the all_gone auto variable
> > that ioc_gone references.
> > 
> > Now the second task gets a big surprise when it tries to invoke
> > complete(ioc_gone).
> > 
> > Or is there something else that I am missing here?
> 
> No, I think that's a problem spot as well. To my knowledge, nobody has
> ever hit that. The anticipatory scheduler has the same code.
> 
> What we want to avoid here is making cfq_cic_free_rcu() a lot more
> expensive, which is why the elv_ioc_count_read() is behind that
> ioc_gone check. I'll need to think a bit on how to handle that
> better :-)

So how about this? Add a spinlock for checking and clearing ioc_gone
back to NULL. It doesn't matter if we make the ioc_gone != NULL
case a little more expensive, as it will only happen on cfq-iosched
module unload. And it seems the clearest way of making this safe.
The last hunk should really not be necessary, as ioc_gone wont be
set back to NULL before wait_for_completion() is entered.

An identical patch is needed in AS as well.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d01b411..32aa367 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -48,6 +48,7 @@ static struct kmem_cache *cfq_ioc_pool;
 
 static DEFINE_PER_CPU(unsigned long, ioc_count);
 static struct completion *ioc_gone;
+static DEFINE_SPINLOCK(ioc_gone_lock);
 
 #define CFQ_PRIO_LISTS		IOPRIO_BE_NR
 #define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
@@ -1177,8 +1178,19 @@ static void cfq_cic_free_rcu(struct rcu_head *head)
 	kmem_cache_free(cfq_ioc_pool, cic);
 	elv_ioc_count_dec(ioc_count);
 
-	if (ioc_gone && !elv_ioc_count_read(ioc_count))
-		complete(ioc_gone);
+	if (ioc_gone) {
+		/*
+		 * CFQ scheduler is exiting, grab exit lock and check
+		 * the pending io context count. If it hits zero,
+		 * complete ioc_gone and set it back to NULL
+		 */
+		spin_lock(&ioc_gone_lock);
+		if (ioc_gone && !elv_ioc_count_read(ioc_count)) {
+			complete(ioc_gone);
+			ioc_gone = NULL;
+		}
+		spin_unlock(&ioc_gone_lock);
+	}
 }
 
 static void cfq_cic_free(struct cfq_io_context *cic)
@@ -2317,7 +2329,7 @@ static void __exit cfq_exit(void)
 	 * pending RCU callbacks
 	 */
 	if (elv_ioc_count_read(ioc_count))
-		wait_for_completion(ioc_gone);
+		wait_for_completion(&all_gone);
 	cfq_slab_kill();
 }
 

-- 
Jens Axboe

