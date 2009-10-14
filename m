Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZJNF6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZJNF6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 01:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZJNF6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 01:58:54 -0400
Received: from ozlabs.org ([203.10.76.45]:48684 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbZJNF6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 01:58:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19157.26731.855609.165622@cargo.ozlabs.ibm.com>
Date: Wed, 14 Oct 2009 16:58:03 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       "Mark W. Krentel" <krentel@cs.rice.edu>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: [PATCH] perf_event: Adjust frequency and unthrottle for non-group-leader events
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop in perf_ctx_adjust_freq checks the frequency of sampling
event counters, and adjusts the event interval and unthrottles the
event if required, and resets the interrupt count for the event.
However, at present it only looks at group leaders.

This means that a sampling event that is not a group leader will
eventually get throttled, once its interrupt count reaches
sysctl_perf_event_sample_rate/HZ --- and that is guaranteed to
happen, if the event is active for long enough, since the interrupt
count never gets reset.  Once it is throttled it never gets
unthrottled, so it basically just stops working at that point.

This fixes it by making perf_ctx_adjust_freq use ctx->event_list
rather than ctx->group_list.  The existing spin_lock/spin_unlock
around the loop makes it unnecessary to put rcu_read_lock/
rcu_read_unlock around the list_for_each_entry_rcu().

Reported-by: Mark W. Krentel <krentel@cs.rice.edu>
Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Apparently this bug was only seen on powerpc, and not on x86.  I have
no idea why.

Looks to me like we want a similar patch for 2.6.31 with some names
changed (event -> counter etc.).  If people agree with this patch I'll
do one for stable.

 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 76ac4db..1d6b938 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1368,7 +1368,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 	u64 interrupts, freq;
 
 	spin_lock(&ctx->lock);
-	list_for_each_entry(event, &ctx->group_list, group_entry) {
+	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
-- 
1.6.0.4

