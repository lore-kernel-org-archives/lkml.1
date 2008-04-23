Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbYDWWKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbYDWWKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYDWWKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:10:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39997 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbYDWWKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:10:05 -0400
Subject: [RFC][PATCH 2/2] sched: aggregate_group_shares no loop
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <1208988476.2849.8.camel@lappy>
References: <1208988476.2849.8.camel@lappy>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 00:09:31 +0200
Message-Id: <1208988571.2849.10.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: aggregate_group_shares no loop

Remove the chance of getting trapped in the loop.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -1713,7 +1713,6 @@ void aggregate_group_shares(struct task_
 	unsigned long shares = 0;
 	int i;
 
-again:
 	for_each_cpu_mask(i, sd->span)
 		shares += tg->cfs_rq[i]->shares;
 
@@ -1723,7 +1722,9 @@ again:
 	 */
 	if (unlikely(!shares && aggregate(tg, sd)->rq_weight)) {
 		__aggregate_redistribute_shares(tg);
-		goto again;
+
+		for_each_cpu_mask(i, sd->span)
+			shares += tg->cfs_rq[i]->shares;
 	}
 
 	aggregate(tg, sd)->shares = shares;


