Return-Path: <linux-kernel-owner+w=401wt.eu-S1765530AbZFLNcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765530AbZFLNcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762451AbZFLN0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:26:05 -0400
Received: from ozlabs.org ([203.10.76.45]:54999 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955AbZFLNZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:59 -0400
CC: linux-kernel@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 7/17] cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.: mips
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mike Travis <travis@sgi.com>
Message-Id: <20090612132601.ECEB0DDDA0@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Thanks to Al Viro for reminding me of this, via Ingo)

CPU_MASK_ALL is the (deprecated) "all bits set" cpumask, defined as so:

	#define CPU_MASK_ALL (cpumask_t) { { ... } }

Taking the address of such a temporary is questionable at best,
unfortunately 321a8e9d (cpumask: add CPU_MASK_ALL_PTR macro) added
CPU_MASK_ALL_PTR:

	#define CPU_MASK_ALL_PTR (&CPU_MASK_ALL)

Which formalizes this practice.  One day gcc could bite us over this
usage (though we seem to have gotten away with it so far).

So replace everywhere which used &CPU_MASK_ALL or CPU_MASK_ALL_PTR
with the modern "cpu_all_mask" (a real struct cpumask *), and remove
CPU_MASK_ALL_PTR altogether.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mike Travis <travis@sgi.com>
---
 arch/mips/alchemy/common/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/alchemy/common/time.c b/arch/mips/alchemy/common/time.c
--- a/arch/mips/alchemy/common/time.c
+++ b/arch/mips/alchemy/common/time.c
@@ -89,7 +89,7 @@ static struct clock_event_device au1x_rt
 	.irq		= AU1000_RTC_MATCH2_INT,
 	.set_next_event	= au1x_rtcmatch2_set_next_event,
 	.set_mode	= au1x_rtcmatch2_set_mode,
-	.cpumask	= CPU_MASK_ALL_PTR,
+	.cpumask	= cpu_all_mask,
 };
 
 static struct irqaction au1x_rtcmatch2_irqaction = {

