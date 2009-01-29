Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbZA2Th2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbZA2Th2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZA2ThN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:37:13 -0500
Received: from relay3.sgi.com ([192.48.171.31]:51172 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751552AbZA2ThM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:37:12 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV cleanup
Cc: mingo@elte.hu, tj@kernel.org
Message-Id: <E1LScjM-00073R-Cu@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 29 Jan 2009 13:39:16 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Cliff Wickman <cpw@sgi.com>

This patch tweaks a couple things:

- uv_flush_tlb_others()
  the WARN_ON(!in_atomic()); fails if CONFIG_PREEMPT is not enabled

  The #ifdef may not be the right fix. The fix is probably in the
  in_atomic macro, but I'm not sure what in_atomic() should return
  if CONFIG_PREEMPT is turned off.  I tested making it return 1 in that
  case, but that yielded tons of warnings.

  The simpler fix for tlb_uv.c would be to just drop the WARN_ON.

- uv_flush_send_and_wait() should return a pointer if the broadcast
  remote tlb shootdown requests fail. That causes the conventional IPI
  method of shootdown to be used.

Diffed against 2.6.29-rc2
  (Ingo's tree)

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -259,7 +259,7 @@ const struct cpumask *uv_flush_send_and_
 		 * the cpu's, all of which are still in the mask.
 		 */
 		__get_cpu_var(ptcstats).ptc_i++;
-		return 0;
+		return flush_mask;
 	}
 
 	/*
@@ -316,7 +316,9 @@ const struct cpumask *uv_flush_tlb_other
 	int locals = 0;
 	struct bau_desc *bau_desc;
 
+#ifdef CONFIG_PREEMPT
 	WARN_ON(!in_atomic());
+#endif
 
 	cpumask_andnot(flush_mask, cpumask, cpumask_of(cpu));
 
