Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZCFXbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZCFXbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbZCFXa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:30:57 -0500
Received: from relay1.sgi.com ([192.48.179.29]:56844 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754415AbZCFXa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:30:57 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86: UV uv_flush_tlb_others WARN_ON
Cc: mingo@elte.hu, tj@kernel.org
Message-Id: <E1LfjVI-0006v9-MG@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Fri, 06 Mar 2009 17:30:56 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Cliff Wickman <cpw@sgi.com>

The problem WARN_ON remains in Ingo's tree, and linux-next.
It should be dropped.

uv_flush_tlb_others() (arch/x86/kernel/tlb_uv.c)
The "WARN_ON(!in_atomic())" fails if CONFIG_PREEMPT is not enabled.
And CONFIG_PREEMPT is not enabled by default in the distribution that
most UV owners will use.

We could #ifdef CONFIG_PREEMPT the warning, but that is not good form.
And there seems to be no suitable fix to in_atomic() when CONFIG_PREMPT
is not on.
  As you commented, Ingo:
  > and we have no proper primitive to test for atomicity. (mainly
  > because we dont know about atomicity on a non-preempt kernel)

I propose that we drop the WARN_ON.

Diffed against 2.6.29-rc2

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -316,8 +316,6 @@ const struct cpumask *uv_flush_tlb_other
 	int locals = 0;
 	struct bau_desc *bau_desc;
 
-	WARN_ON(!in_atomic());
-
 	cpumask_andnot(flush_mask, cpumask, cpumask_of(cpu));
 
 	uv_cpu = uv_blade_processor_id();
