Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbZJNHBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbZJNHBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbZJNHBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:01:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:37440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570AbZJNHBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:01:06 -0400
Date: Wed, 14 Oct 2009 06:59:43 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       krentel@cs.rice.edu, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       krentel@cs.rice.edu, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <19157.26731.855609.165622@cargo.ozlabs.ibm.com>
References: <19157.26731.855609.165622@cargo.ozlabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Adjust frequency and unthrottle for non-group-leader events
Message-ID: <tip-03541f8b69c058162e4cf9675ec9181e6a204d55@git.kernel.org>
Git-Commit-ID: 03541f8b69c058162e4cf9675ec9181e6a204d55
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:59:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03541f8b69c058162e4cf9675ec9181e6a204d55
Gitweb:     http://git.kernel.org/tip/03541f8b69c058162e4cf9675ec9181e6a204d55
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Wed, 14 Oct 2009 16:58:03 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 08:39:32 +0200

perf_event: Adjust frequency and unthrottle for non-group-leader events

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
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <19157.26731.855609.165622@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9d0b5c6..afb7ef3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1355,7 +1355,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 	u64 interrupts, freq;
 
 	spin_lock(&ctx->lock);
-	list_for_each_entry(event, &ctx->group_list, group_entry) {
+	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
