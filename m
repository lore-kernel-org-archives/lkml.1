Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbYHCHCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbYHCHCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 03:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYHCHCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 03:02:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50832
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbYHCHCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 03:02:32 -0400
Date: Sun, 03 Aug 2008 00:02:32 -0700 (PDT)
Message-Id: <20080803.000232.215078646.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: 2.6.27-rc1-mm1: sparc64 BUG: using smp_processor_id() in
 preemptible code
From: David Miller <davem@davemloft.net>
In-Reply-To: <200808021717.47971.m.kozlowski@tuxland.pl>
References: <20080731000354.24b55d5b.akpm@linux-foundation.org>
	<200808021717.47971.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Sat, 2 Aug 2008 17:17:47 +0200

> I'm running preemtible kernel and have seen similar things before:
> http://marc.info/?l=linux-kernel&m=120652827627051&w=2 and it was fixed by disabling
> preemtpion in relevant sparc64 code paths. smp_call_function_mask() documentation
> says it must be called with preemption disabled.
> 
> Here is a similar fix. Compile and run tested.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Thenk for the report and sample patch.

I've decided to put the preemption disabled call at the smp_tsb_sync() call
site so that smp_tsb_sync() can still invoke smp_call_function_mask() as
a tail-call.

Thanks again!

sparc64: Need to disable preemption around smp_tsb_sync().

Based upon a bug report by Mariusz Kozlowski

It uses smp_call_function_masked() now, which has a preemption-disabled
requirement.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc64/mm/tsb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/sparc64/mm/tsb.c b/arch/sparc64/mm/tsb.c
index 3547937..587f8ef 100644
--- a/arch/sparc64/mm/tsb.c
+++ b/arch/sparc64/mm/tsb.c
@@ -1,9 +1,10 @@
 /* arch/sparc64/mm/tsb.c
  *
- * Copyright (C) 2006 David S. Miller <davem@davemloft.net>
+ * Copyright (C) 2006, 2008 David S. Miller <davem@davemloft.net>
  */
 
 #include <linux/kernel.h>
+#include <linux/preempt.h>
 #include <asm/system.h>
 #include <asm/page.h>
 #include <asm/tlbflush.h>
@@ -415,7 +416,9 @@ retry_tsb_alloc:
 		tsb_context_switch(mm);
 
 		/* Now force other processors to do the same.  */
+		preempt_disable();
 		smp_tsb_sync(mm);
+		preempt_enable();
 
 		/* Now it is safe to free the old tsb.  */
 		kmem_cache_free(tsb_caches[old_cache_index], old_tsb);
-- 
1.5.6.GIT

