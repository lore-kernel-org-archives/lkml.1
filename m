Return-Path: <linux-kernel-owner+w=401wt.eu-S934402AbZLGATA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934402AbZLGATA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758768AbZLGASx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:18:53 -0500
Received: from kroah.org ([198.145.64.141]:34707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758588AbZLGANw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:52 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:57 2009
Message-Id: <20091207000657.658227549@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [096/119] perf_event: Adjust frequency and unthrottle for non-group-leader events
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=perf_event-adjust-frequency-and-unthrottle-for-non-group-leader-events.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Paul Mackerras <paulus@samba.org>

commit 03541f8b69c058162e4cf9675ec9181e6a204d55 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1363,7 +1363,7 @@ static void perf_ctx_adjust_freq(struct 
 	u64 interrupts, freq;
 
 	spin_lock(&ctx->lock);
-	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+	list_for_each_entry_rcu(counter, &ctx->counter_list, event_entry) {
 		if (counter->state != PERF_COUNTER_STATE_ACTIVE)
 			continue;
 


