Return-Path: <linux-kernel-owner+w=401wt.eu-S934420AbYBOLXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420AbYBOLXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 06:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934026AbYBOLXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 06:23:09 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:10520 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934015AbYBOLXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 06:23:08 -0500
X-SourceIP: 80.56.237.116
Message-Id: <20080215112055.831528000@chello.nl>
References: <20080215111819.978881000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 15 Feb 2008 12:18:22 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] sched: fair: fix calc_delta_asym
Content-Disposition: inline; filename=sched-fair-asym.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of calc_delta_asym() is to be asymetrically around NICE_0_LOAD, in
that it favours >=0 over <0. The current implementation does not achieve that.

 -20         |
             |
   0 --------+-------
           .'
  19     .'

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -417,12 +417,17 @@ calc_delta_fair(unsigned long delta, str
 static inline unsigned long
 calc_delta_asym(unsigned long delta, struct sched_entity *se)
 {
-	unsigned long fair = calc_delta_fair(delta, se);
+	if (se->load.weight < NICE_0_LOAD) {
+		struct load_weight lw = {
+			.weight = NICE_0_LOAD,
+			.inv_weight = 1UL << (WMULT_SHIFT-NICE_0_SHIFT)
+		};
 
-	if (fair > delta)
-		fair = delta;
+		delta = calc_delta_mine(delta, cfs_rq_of(se)->load.weight, &lw);
+		se = parent_entity(se);
+	}
 
-	return fair;
+	return calc_delta_fair(delta, se);
 }
 
 /*

--

