Return-Path: <linux-kernel-owner+w=401wt.eu-S1761759AbYBAJ7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761759AbYBAJ7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763137AbYBAJ6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:58:01 -0500
Received: from mx1.suse.de ([195.135.220.2]:35412 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763011AbYBAJ57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:57:59 -0500
Subject: Re: [bug] as_merged_requests(): possible recursive locking detected
From: Nikanth Karthikesan <knikanth@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080131221436.GA3760@elte.hu>
References: <20080131221436.GA3760@elte.hu>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 15:33:11 +0530
Message-Id: <1201860191.10128.0.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 23:14 +0100, Ingo Molnar wrote:
> 
> Jens,
> 
> AS still has some locking issues - see the lockdep warning below that 
> the x86 test-rig just triggered. Config attached. Never saw this one 
> before. Can send more info if needed.
> 

The io_contexts are swapped. And while swapping, the locks were also
getting swapped, which will change the order of locking after that. This
may be the cause of these warning. I am not sure whether not swapping
the locks is the right way to fix this. Using a field of spinlock_t
itself to order locking might be better, instead of the address of the
container.

Now while adding a new member to io_context, one should not forget to
add it here. Also copying whole io_context and then restoring the locks
might have a window where this warning could be triggered.

Thanks
Nikanth Karthikesan

Do not swap locks while swapping io_contexts

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 6d16755..b9c6e39 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -179,9 +179,32 @@ EXPORT_SYMBOL(copy_io_context);
 void swap_io_context(struct io_context **ioc1, struct io_context **ioc2)
 {
 	struct io_context *temp;
+
+	/*
+	 * Do not swap the locks to preserve locking order
+	 */
+
 	temp = *ioc1;
-	*ioc1 = *ioc2;
-	*ioc2 = temp;
+
+	(*ioc1)->refcount = (*ioc2)->refcount;
+	(*ioc1)->nr_tasks = (*ioc2)->nr_tasks;
+	(*ioc1)->ioprio = (*ioc2)->ioprio;
+	(*ioc1)->ioprio_changed = (*ioc2)->ioprio_changed;
+	(*ioc1)->last_waited = (*ioc2)->last_waited;
+	(*ioc1)->nr_batch_requests = (*ioc2)->nr_batch_requests;
+	(*ioc1)->aic = (*ioc2)->aic;
+	(*ioc1)->radix_root = (*ioc2)->radix_root;
+	(*ioc1)->ioc_data = (*ioc2)->ioc_data;
+
+	(*ioc2)->refcount = (temp)->refcount;
+	(*ioc2)->nr_tasks = (temp)->nr_tasks;
+	(*ioc2)->ioprio = (temp)->ioprio;
+	(*ioc2)->ioprio_changed = (temp)->ioprio_changed;
+	(*ioc2)->last_waited = (temp)->last_waited;
+	(*ioc2)->nr_batch_requests = (temp)->nr_batch_requests;
+	(*ioc2)->aic = (temp)->aic;
+	(*ioc2)->radix_root = (temp)->radix_root;
+	(*ioc2)->ioc_data = (temp)->ioc_data;
 }
 EXPORT_SYMBOL(swap_io_context);
 


