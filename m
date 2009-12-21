Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbZLUMMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbZLUMMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 07:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZLUMMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 07:12:31 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56628 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbZLUMMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 07:12:30 -0500
Date: Mon, 21 Dec 2009 13:12:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC]block: add a new flag to make request complete on
	submitted  cpu
Message-ID: <20091221121228.GI4489@kernel.dk>
References: <20091221022827.GA1897@sli10-desk.sh.intel.com> <20091221091030.GF4489@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221091030.GF4489@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21 2009, Jens Axboe wrote:
> On Mon, Dec 21 2009, Shaohua Li wrote:
> > We already have a QUEUE_FLAG_SAME_COMP, which makes request complete
> > on the first cpu of a mc/ht, but this isn't sufficient. In a system
> > with fast block devices (intel SSD), it turns out the first cpu is
> > bottlenect. Add a flag to make request complete on cpu where request
> > is submitted. The flag implies QUEUE_FLAG_SAME_COMP. By default, it is off.
> 
> It was a lazy trick to avoid doing any round robin work in there.
> 
> > My test machine has two CPUs and 4 intel SSD. Without the new flag,
> > the io thoughput is about 400m/s; with it, the thoughput is about 500m/s.
> 
> So I think we should just fix it, I still think the group logic makes
> sense. But instead of always going for the first one, let it complete
> locally if part of the group, if not send to specific submitter CPU.

Is this enough? It renames cpu to local_cpu and ccpu to target_cpu to
make things clearer to read, the real change is that we allow local
completion if the cpu matches OR the group matches.

We just want to keep it as cache local as we can, I don't think we
should add a new sysfs flag to control group vs specific CPU completion.
That's exposing too much detail.

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index ee9c216..300dc90 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -105,23 +105,28 @@ void __blk_complete_request(struct request *req)
 {
 	struct request_queue *q = req->q;
 	unsigned long flags;
-	int ccpu, cpu, group_cpu;
+	int target_cpu, local_cpu, group_cpu;
 
 	BUG_ON(!q->softirq_done_fn);
 
 	local_irq_save(flags);
-	cpu = smp_processor_id();
-	group_cpu = blk_cpu_to_group(cpu);
+	local_cpu = smp_processor_id();
+	group_cpu = blk_cpu_to_group(local_cpu);
 
 	/*
 	 * Select completion CPU
 	 */
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) && req->cpu != -1)
-		ccpu = req->cpu;
+		target_cpu = req->cpu;
 	else
-		ccpu = cpu;
+		target_cpu = local_cpu;
 
-	if (ccpu == cpu || ccpu == group_cpu) {
+	/*
+	 * If the target_cpu is same as the local one or from the same group,
+	 * complete locally
+	 */
+	if (target_cpu == local_cpu ||
+	    blk_cpu_to_group(target_cpu) == group_cpu) {
 		struct list_head *list;
 do_local:
 		list = &__get_cpu_var(blk_cpu_done);
@@ -135,7 +140,7 @@ do_local:
 		 */
 		if (list->next == &req->csd.list)
 			raise_softirq_irqoff(BLOCK_SOFTIRQ);
-	} else if (raise_blk_irq(ccpu, req))
+	} else if (raise_blk_irq(target_cpu, req))
 		goto do_local;
 
 	local_irq_restore(flags);

-- 
Jens Axboe

