Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbYAOWQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbYAOWQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbYAOWQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:16:42 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:1113 "EHLO
	mail198-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901AbYAOWQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:16:41 -0500
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Subject: [PATCH] lost softirq, 2.6.24-rc7
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
To: linux-kernel@vger.kernel.org, mingo@redhat.com
Content-Type: text/plain
Date: Tue, 15 Jan 2008 14:15:26 -0800
Message-Id: <1200435326.4092.9.camel@bx740>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2008 22:16:30.0645 (UTC) FILETIME=[47989E50:01C857C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@am.sony.com>

(Ingo, there is a question for you after the description, just before the
patch.)

When running an interrupt and network intensive stress test with PREEMPT_RT
enabled, the target system stopped processing received network packets.
skbs from received packets were being queued by net_rx_action(), but the
NET_RX_SOFTIRQ softirq was never running to remove the skbs from the queue.
Since the target system root file system is NFS mounted, the system is now
effectively hung.

A pseudocode description of how this state was reached follows.
Each level of indentation represents a function call from the previous line.


ethernet driver irq handler receives packet
   netif_rx()
      queues skb (qlen == 1), raises NET_RX_SOFTIRQ

on return from irq
   ___do_softirq() [ 1 ]
      Reset the pending bitmask
      net_rx_action()
         dequeues skb (qlen == 0)
         jiffies incremented, so
            break out of processing
            and raise NET_RX_SOFTIRQ
            (but don't deassert NAPI_STATE_SCHED)

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         ksoftirqd thread runs
            process TIMER_SOFTIRQ
            process RCU_SOFTIRQ
            << ksoftirqd sleeps >>
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

         ___do_softirq() [ 2 ]
            Reset the pending bitmask
            finds NET_RX_SOFTIRQ raised but already running
            << ___do_softirq() [ 2 ] completes >>

      << ___do_softirq() [ 1 ] resumes >>
      the pending bitmask is empty, so NET_RX_SOFTIRQ is lost



Since NET_RX_SOFTIRQ was lost, net_rx_action() is never called, so
NAPI_STATE_SCHED is never deasserted.

When netif_rx() is called for subsequent packets, it queues the skb but
does not raise NET_RX_SOFTIRQ because it believes that NET_RX_SOFTIRQ
is active since NAPI_STATE_SCHED is set.

THE PROBLEM:
   The softirq was lost when "___do_softirq() [ 2 ]" reset the softirq pending
   bit for NET_RX_SOFTIRQ.


The above sequence was captured by the following trace:

       softirq
napi   pending  softirq_  napi
state  bitmask  running   qlen  trace location
-----  -------  --------  ----  ----------------------------------

0      000      0         0     ___do_softirq - exit

0      000      0         0     netif_rx
1      000      0         0     __napi_schedule

1      008      0         1     ___do_softirq - entry or restart
1      000      8         1     net_rx_action
1      000      8         1     process_backlog
1      10a      8         0     net_rx_action - softnet_break

1      10a      8         0     ksoftirqd - before while
1      108      8         0     ksoftirqd - after  while
1      108      8         0     ksoftirqd - before while
1      008      8         0     ksoftirqd - after  while

1      008      8         0     ___do_softirq - entry or restart
1      000      8         0     ___do_softirq - find already running
1      000      8         0     ___do_softirq - before or_softirq_pending()
1      000      8         0     ___do_softirq - after  or_softirq_pending()
1      000      8         0     ___do_softirq - exit

1      000      0         0     ___do_softirq - before or_softirq_pending()
1      000      0         0     ___do_softirq - after  or_softirq_pending()
1      000      0         0     ___do_softirq - exit

1      000      0         0     netif_rx

1      102      0         1     netif_rx
1      102      0         1     netif_rx - qlen > 0


The proposed fix is for __do_soft_irq() to re-enable any pending softirq
that it disabled, but did not process due to being already running.  If
it is already running, then another context already saved the value of
local_softirq_pending(), then zeroed it out.  Then subsequently the same
softirq was raised again, potentially after the other context completed
processing the softirq.

This patch might be related to some of the problems reported in the lkml
thread "2.6.20->2.6.21 - networking dies after random time", which began
16 June 2007.  The reports in that thread did not have the specific details
that I need to determine whether this is the same problem that they
experienced.  (The signature of the problem is that the napi state is 1,
napi qlen > 0, and NET_RX_SOFTIRQ is never running.)

Ingo,

One concern I have is that the attached patch might cause a softirq to be
processed twice.  Is it always safe to invoke a softirq one extra time?

If this patch is not an accceptable fix for the problem, then I can also 
supply a workaround in the NET_RX_SOFTIRQ that avoids this scenario.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 kernel/softirq.c |    9 	5 +	4 -	0 !
 1 files changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6.24-rc7/kernel/softirq.c
===================================================================
--- linux-2.6.24-rc7.orig/kernel/softirq.c
+++ linux-2.6.24-rc7/kernel/softirq.c
@@ -261,7 +261,7 @@ static DEFINE_PER_CPU(u32, softirq_runni
 static void ___do_softirq(const int same_prio_only)
 {
 	int max_restart = MAX_SOFTIRQ_RESTART, max_loops = MAX_SOFTIRQ_RESTART;
-	__u32 pending, available_mask, same_prio_skipped;
+	__u32 pending, available_mask, skipped;
 	struct softirq_action *h;
 	struct task_struct *tsk;
 	int cpu, softirq;
@@ -273,7 +273,7 @@ static void ___do_softirq(const int same
 restart:
 	available_mask = -1;
 	softirq = 0;
-	same_prio_skipped = 0;
+	skipped = 0;
 	/* Reset the pending bitmask before enabling irqs */
 	set_softirq_pending(0);
 
@@ -295,7 +295,7 @@ restart:
 				tsk = __get_cpu_var(ksoftirqd)[softirq].tsk;
 				if (tsk && tsk->normal_prio !=
 						current->normal_prio) {
-					same_prio_skipped |= softirq_mask;
+					skipped |= softirq_mask;
 					available_mask &= ~softirq_mask;
 					goto next;
 				}
@@ -305,6 +305,7 @@ restart:
 			 * Is this softirq already being processed?
 			 */
 			if (per_cpu(softirq_running, cpu) & softirq_mask) {
+				skipped |= softirq_mask;
 				available_mask &= ~softirq_mask;
 				goto next;
 			}
@@ -328,7 +329,7 @@ next:
 		pending >>= 1;
 	} while (pending);
 
-	or_softirq_pending(same_prio_skipped);
+	or_softirq_pending(skipped);
 	pending = local_softirq_pending();
 	if (pending & available_mask) {
 		if (--max_restart)



