Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbYHAOgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbYHAOgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYHAOgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:36:36 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:53444 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYHAOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:36:35 -0400
X-BigFish: VPS1(zz3117Kzz10d3izzz32i6bh8ah43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4XF8H-02-YO3-01
Date: Fri, 1 Aug 2008 16:36:11 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] x86: pda_init: fix memory leak with CPU_HOTPLUG
Message-ID: <20080801143611.GK5466@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 01 Aug 2008 14:36:22.0168 (UTC) FILETIME=[F7DD9980:01C8F3E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pda->irqstackptr is allocated whenever a CPU is set online.
But it is never freed (or did I miss something?).
This results in a memory leak of 16 KByte for each CPU offline/online
cycle.

Fix is to allocate pda->irqstackptr only once.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/common_64.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

The leak is not a big deal for normal CPU hotplug usage.
But when doing lots of CPU offline/online-cycles during stress tests
this becomes significant.

Patch is against Linus' git-tree (v2.6.27-rc1-157-gf164ca9).


Regards,

Andreas

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
1.5.6.3



