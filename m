Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbZCMLYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbZCMLYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbZCMLXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:23:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:42373 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbZCMLXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:23:42 -0400
Message-Id: <20090313112301.384074618@chello.nl>
References: <20090313112125.886730125@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 12:21:30 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/11] perf_counter: add comment to barrier
Content-Disposition: inline; filename=perf_counter-x86-barrier.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to ensure the enabled=0 write happens before we start disabling
the actual counters, so that a pcm_amd_enable() will not enable one underneath
us.

I think the race is impossible anyway, we always balance the ops within any
one context and perform enable() with IRQs disabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -247,6 +247,10 @@ static u64 pmc_amd_save_disable_all(void
 
 	enabled = cpuc->enabled;
 	cpuc->enabled = 0;
+	/*
+	 * ensure we write the disable before we start disabling the
+	 * counters proper, so that pcm_amd_enable() does the right thing.
+	 */
 	barrier();
 
 	for (idx = 0; idx < nr_counters_generic; idx++) {

-- 

