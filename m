Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbYHFI2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbYHFI2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbYHFI1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:27:47 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:21441 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752083AbYHFI1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:27:46 -0400
X-BigFish: VPS21(zzzz10d3izz3198u327anz32i6bh)
X-WSS-ID: 0K567HZ-01-35R-01
Date: Wed, 6 Aug 2008 10:27:30 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/2] x86: pda_init(): fix memory leak when using CPU hotplug
Message-ID: <20080806082730.GD5427@alberich.amd.com>
References: <20080806082400.GC5427@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080806082400.GC5427@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2008 08:27:34.0310 (UTC) FILETIME=[46B32C60:01C8F79E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pda->irqstackptr is allocated whenever a CPU is set online.
But it is never freed. This results in a memory leak of 16K
for each CPU offline/online cycle.

Fix is to allocate pda->irqstackptr only once.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/common_64.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

This is a re-submission of a patch posted last week. See
http://marc.info/?l=linux-kernel&m=121760147831093
Patch is against 2.6.27-rc2.

diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index dd6e3f1..c941397 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -493,17 +493,20 @@ void pda_init(int cpu)
 		/* others are initialized in smpboot.c */
 		pda->pcurrent = &init_task;
 		pda->irqstackptr = boot_cpu_stack;
+		pda->irqstackptr += IRQSTACKSIZE - 64;
 	} else {
-		pda->irqstackptr = (char *)
-			__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
-		if (!pda->irqstackptr)
-			panic("cannot allocate irqstack for cpu %d", cpu);
+		if (!pda->irqstackptr) {
+			pda->irqstackptr = (char *)
+				__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
+			if (!pda->irqstackptr)
+				panic("cannot allocate irqstack for cpu %d",
+				      cpu);
+			pda->irqstackptr += IRQSTACKSIZE - 64;
+		}
 
 		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
 			pda->nodenumber = cpu_to_node(cpu);
 	}
-
-	pda->irqstackptr += IRQSTACKSIZE-64;
 }
 
 char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
-- 
1.5.6.4



