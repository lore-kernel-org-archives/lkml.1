Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbYD3Rni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbYD3Rni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbYD3Rn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:43:28 -0400
Received: from 24-183-181-171.dhcp.oxfr.ma.charter.com ([24.183.181.171]:55546
	"EHLO ghaskins-t60p.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758013AbYD3Rn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:43:27 -0400
X-Greylist: delayed 1669 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 13:43:27 EDT
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] sched: fix inv_weight calc
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, David Bahi <dbahi@novell.com>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org
Date: Wed, 30 Apr 2008 13:15:57 -0400
Message-ID: <20080430171521.5454.91644.stgit@ghaskins-t60p.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently have a bug in sched-devel where the system will fail to
balance tasks if CONFIG_FAIR_GROUP_SCHED=n.  To reproduce, simply launch
a workload with multiple tasks and observe (either via top or
/proc/sched_debug) that the tasks do not distribute much (if at all)
around to all available cores. Instead, they tend to clump on one processor
while the other cores are idle.

Bisecting, we found the culprit to be:

	commit 1b9552e878a5db3388eba8660e8d8400020a07e9
	Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
	Date:   Tue Apr 29 13:47:36 2008 +0200
	Subject: sched: higher granularity load on 64bit systems

Once we identified this patch as the problem, I studied what possible
effect it could have with FAIR_GROUP_SCHED=n vs y.  Most of the code in
1b9552e8 would be compiled out if we disable group-scheduling, but there
is one particular logic change in calc_delta_mine() that affects both modes
that looked suspicious.  It changes the computation of the inverse-weight
from:

    inv_weight = (WMULT_CONST-weight/2)/(weight+1)

to

    inv_weight = 1+(WMULT_CONST-weight/2)/(weight+1)

This patch restores the algorithm to its original logic, and seems to solve
the regression for me.  I can't really wrap my head around the original
intent of the "+1" change, or whether reverting the change will cause a
ripple effect somewhere else.  All I can confirm is that the system will
once again balance load with this logic reverted to its previous form.

Thanks to my colleage, David Bahi, for doing all the legwork on the bisect.
And thanks to Peter Zijlstra for guiding me on all things CFS as I stuggle
to come up to speed on the non-RT portions of the scheduler.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: David Bahi <dbahi@novell.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
---

 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 32ef6c8..8326e20 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1562,7 +1562,7 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 	if (unlikely(!lw->inv_weight)) {
 		unsigned long inv_wls = inv_WLS(lw->weight);
 
-		lw->inv_weight = 1 + (WMULT_CONST-inv_wls/2) / (inv_wls+1);
+		lw->inv_weight = (WMULT_CONST-inv_wls/2) / (inv_wls+1);
 	}
 
 	tmp = inv_WLS((u64)delta_exec * weight);

