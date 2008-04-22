Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbYDVMpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbYDVMpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760359AbYDVMpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:45:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44370 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760204AbYDVMpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:45:08 -0400
Subject: Re: Soft lockup regression from today's sched.git merge.
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20080422.030519.259068348.davem@davemloft.net>
References: <20080422.015931.70144614.davem@davemloft.net>
	 <20080422091456.GC9939@elte.hu>
	 <20080422.030519.259068348.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 14:45:04 +0200
Message-Id: <1208868304.7115.251.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 03:05 -0700, David Miller wrote:

> BTW, I'm also getting cpu's wedged in the group aggregate code:
> 
> [  121.338742] TSTATE: 0000009980001602 TPC: 000000000054ea20 TNPC: 0000000000456828 Y: 00000000    Not tainted
> [  121.338778] TPC: <__first_cpu+0x4/0x28>
> [  121.338791] g0: 0000000000000000 g1: 0000000000000002 g2: 0000000000000000 g3: 0000000000000002
> [  121.338809] g4: fffff803fe9b24c0 g5: fffff8001587c000 g6: fffff803fe9d0000 g7: 00000000007b7260
> [  121.338827] o0: 0000000000000002 o1: 00000000007b7258 o2: 0000000000000000 o3: 00000000007b7800
> [  121.338845] o4: 0000000000845000 o5: 0000000000000400 sp: fffff803fe9d2ed1 ret_pc: 0000000000456820
> [  121.338879] RPC: <aggregate_group_shares+0x10c/0x16c>
> [  121.338893] l0: 0000000000000400 l1: 000000000000000d l2: 00000000000003ff l3: 0000000000000000
> [  121.338911] l4: 0000000000000000 l5: 0000000000000000 l6: fffff803fe9d0000 l7: 0000000080009002
> [  121.338928] i0: 0000000000801c20 i1: fffff800161ca508 i2: 00000000000001d8 i3: 0000000000000001
> [  121.338946] i4: fffff800161d9c00 i5: 0000000000000001 i6: fffff803fe9d2f91 i7: 0000000000456904
> [  121.338968] I7: <aggregate_get_down+0x84/0x13c>
> 
> I'm suspecting the deluge of cpumask changes that also went in today.
> 
> I guess I'll be bisecting all day tomorrow too :-/

Sadly both the cpumask changes and the group load-balancer came in the
same batch - so its all new code. Also, it looks like the cpumask
changes are before the load balance changes - so bisecting this will be
'fun'.

That said; the code in question looks like:

static
void aggregate_group_shares(struct task_group *tg, struct sched_domain *sd)
{
        unsigned long shares = 0;
        int i;

again:
        for_each_cpu_mask(i, sd->span)
                shares += tg->cfs_rq[i]->shares;

        /*
         * When the span doesn't have any shares assigned, but does have
         * tasks to run do a machine wide rebalance (should be rare).
         */
        if (unlikely(!shares && aggregate(tg, sd)->rq_weight)) {
                __aggregate_redistribute_shares(tg);
                goto again;
        }

        aggregate(tg, sd)->shares = shares;
}

and the __first_cpu() call is from the for_each_cpu_mask() afaict. and
sd->span should be good - that's not new. So I'm a bit puzzled.

But you say they get wedged - so the above trace is a snapshot (NMI,
sysrq-[tw] or the like) that could also mean they get wedged in this
'again' loop we have here.

I have two patches; the first will stick in a printk() to see if it is
indeed the loop in this function. The second is an attempt at breaking
out of it.

BTW, what does the sched_domain tree look like on that 128-cpu machine?

---
 kernel/printk.c |    2 --
 kernel/sched.c  |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6-2/kernel/printk.c
===================================================================
--- linux-2.6-2.orig/kernel/printk.c
+++ linux-2.6-2/kernel/printk.c
@@ -1020,8 +1020,6 @@ void release_console_sem(void)
 	console_locked = 0;
 	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
-	if (wake_klogd)
-		wake_up_klogd();
 }
 EXPORT_SYMBOL(release_console_sem);
 
Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -1710,6 +1710,7 @@ again:
 	 * tasks to run do a machine wide rebalance (should be rare).
 	 */
 	if (unlikely(!shares && aggregate(tg, sd)->rq_weight)) {
+		printk(KERN_EMERG "[%d] no sd shares\n", raw_smp_processor_id());
 		__aggregate_redistribute_shares(tg);
 		goto again;
 	}


---
 kernel/sched.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -1661,9 +1661,9 @@ void aggregate_group_weight(struct task_
  */
 static void __aggregate_redistribute_shares(struct task_group *tg)
 {
-	int i, max_cpu = smp_processor_id();
+	int i;
 	unsigned long rq_weight = 0;
-	unsigned long shares, max_shares = 0, shares_rem = tg->shares;
+	unsigned long shares, shares_rem = tg->shares;
 
 	for_each_possible_cpu(i)
 		rq_weight += tg->cfs_rq[i]->load.weight;
@@ -1677,10 +1677,6 @@ static void __aggregate_redistribute_sha
 
 		tg->cfs_rq[i]->shares = shares;
 
-		if (shares > max_shares) {
-			max_shares = shares;
-			max_cpu = i;
-		}
 		shares_rem -= shares;
 	}
 
@@ -1689,7 +1685,7 @@ static void __aggregate_redistribute_sha
 	 * due to rounding down when computing the per-cpu shares.
 	 */
 	if (shares_rem)
-		tg->cfs_rq[max_cpu]->shares += shares_rem;
+		tg->cfs_rq[smp_process_id()]->shares += shares_rem;
 }
 
 /*


