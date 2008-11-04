Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYKDXwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYKDXwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbYKDXkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:40:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:47707 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbYKDXkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:40:13 -0500
Date: Tue, 4 Nov 2008 15:33:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Peter Zijlstra <peterz@infradead.org>,
       Molnar <mingo@elte.hu>, Ingo@hera.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 40/57] sched_clock: prevent scd->clock from moving backwards
Message-ID: <20081104233301.GO659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched_clock-prevent-scd-clock-from-moving-backwards.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit 5b7dba4ff834259a5623e03a565748704a8fe449 upstream

sched_clock: prevent scd->clock from moving backwards

When sched_clock_cpu() couples the clocks between two cpus, it may
increment scd->clock beyond the GTOD tick window that __update_sched_clock()
uses to clamp the clock.  A later call to __update_sched_clock() may move
the clock back to scd->tick_gtod + TICK_NSEC, violating the clock's
monotonic property.

This patch ensures that scd->clock will not be set backward.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_clock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -118,13 +118,13 @@ static u64 __update_sched_clock(struct s
 
 	/*
 	 * scd->clock = clamp(scd->tick_gtod + delta,
-	 * 		      max(scd->tick_gtod, scd->clock),
-	 * 		      scd->tick_gtod + TICK_NSEC);
+	 *		      max(scd->tick_gtod, scd->clock),
+	 *		      max(scd->clock, scd->tick_gtod + TICK_NSEC));
 	 */
 
 	clock = scd->tick_gtod + delta;
 	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = scd->tick_gtod + TICK_NSEC;
+	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);

-- 
