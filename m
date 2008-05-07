Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbYEGQ0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbYEGQ0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYEGQ0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:26:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41953 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbYEGQ0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:26:38 -0400
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1210136148.3453.59.camel@ymzhang>
References: <1210136148.3453.59.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 May 2008 18:26:15 +0200
Message-Id: <1210177575.6525.4.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-07 at 12:55 +0800, Zhang, Yanmin wrote:
> ﻿Comparing with kernel 2.6.25, sysbench+mysql(oltp, readonly) has many
> regression with 2.6.26-rc1.
> 
> 1) 8-core stoakley: 28%;
> 2) 16-core tigerton: 20%;
> 3) Itanium Montvale: 50%.
> 
> Bisect located below patch.
> 
> 8f1bc385cfbab474db6c27b5af1e439614f3025c is first bad commit
> commit 8f1bc385cfbab474db6c27b5af1e439614f3025c
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Sat Apr 19 19:45:00 2008 +0200
> 
>     sched: fair: weight calculations
>     
>     In order to level the hierarchy, we need to calculate load based on the
>     root view. That is, each task's load is in the same unit.
> 
> 
> 
> After I manually reverted the patch against 2.6.26-rc1 while fixing a couple of
> conflictions/errors, sysbench oltp regression became less than 3% on 8-core
> stoakley.

Does this patch help?

---
From: Mike Galbraith <efault@gmx.de>
Subject: sched: fix weight calculations

The conversion between virtual and real time is as follows:

  dvt = rw/w * dt <=> dt = w/rw * dvt

Since we want the fair sleeper granularity to be in real time, we actually
need to do:

  dvt = - rw/w * l

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -662,10 +662,15 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
 		if (sched_feat(NEW_FAIR_SLEEPERS)) {
+			unsigned long thresh = sysctl_sched_latency;
+
+			/*
+			 * convert the sleeper threshold into virtual time
+			 */
 			if (sched_feat(NORMALIZED_SLEEPER))
-				vruntime -= calc_delta_weight(sysctl_sched_latency, se);
-			else
-				vruntime -= sysctl_sched_latency;
+				thresh = calc_delta_fair(thresh, se);
+
+			vruntime -= thresh;
 		}
 
 		/* ensure we never gain time by being placed backwards. */


