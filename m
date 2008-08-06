Return-Path: <linux-kernel-owner+w=401wt.eu-S1761703AbYHFIaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761703AbYHFIaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbYHFI3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:29:53 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:13905 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbYHFI3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:29:52 -0400
X-BigFish: VPS4(zzzz10d3izzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0K567LG-02-3OS-01
Date: Wed, 6 Aug 2008 10:29:37 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/2] x86: cpu_init(): fix memory leak when using CPU hotplug
Message-ID: <20080806082937.GE5427@alberich.amd.com>
References: <20080806082400.GC5427@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080806082400.GC5427@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2008 08:29:40.0671 (UTC) FILETIME=[920454F0:01C8F79E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exception stacks are allocated each time a CPU is set online.
But the allocated space is never freed. Thus with one CPU hotplug
offline/online cycle there is a memory leak of 24K (6 pages) for
a CPU.

Fix is to allocate exception stacks only once -- when the CPU is
set online for the first time.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/common_64.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index c941397..a5b9600 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -604,19 +604,22 @@ void __cpuinit cpu_init(void)
 	/*
 	 * set up and load the per-CPU TSS
 	 */
-	for (v = 0; v < N_EXCEPTION_STACKS; v++) {
+	if (!orig_ist->ist[0]) {
 		static const unsigned int order[N_EXCEPTION_STACKS] = {
-			[0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
-			[DEBUG_STACK - 1] = DEBUG_STACK_ORDER
+		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
+		  [DEBUG_STACK - 1] = DEBUG_STACK_ORDER
 		};
-		if (cpu) {
-			estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
-			if (!estacks)
-				panic("Cannot allocate exception stack %ld %d\n",
-				      v, cpu);
+		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
+			if (cpu) {
+				estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
+				if (!estacks)
+					panic("Cannot allocate exception "
+					      "stack %ld %d\n", v, cpu);
+			}
+			estacks += PAGE_SIZE << order[v];
+			orig_ist->ist[v] = t->x86_tss.ist[v] =
+					(unsigned long)estacks;
 		}
-		estacks += PAGE_SIZE << order[v];
-		orig_ist->ist[v] = t->x86_tss.ist[v] = (unsigned long)estacks;
 	}
 
 	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
-- 
1.5.6.4



