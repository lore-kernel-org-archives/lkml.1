Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893Ab0AHUOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0AHUOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 15:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709Ab0AHUOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 15:14:00 -0500
Received: from relay1.sgi.com ([192.48.179.29]:41102 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752426Ab0AHUN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 15:13:59 -0500
Message-ID: <4B479202.7080705@sgi.com>
Date: Fri, 08 Jan 2010 12:13:54 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>
CC: Mike Habeck <habeck@sgi.com>, stable@kernel.org, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>
Subject: [PATCH] x86_64 SGI UV: Fix mapping of MMIO registers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64 SGI UV: Fix mapping of MMIO registers

This fixes the problem of the initialization code not correctly
mapping the entire MMIO space on a UV system.  A side effect is
the map_high() interface needed to be changed to accommodate
different address and size shifts.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -377,13 +377,13 @@
 
 enum map_type {map_wb, map_uc};
 
-static __init void map_high(char *id, unsigned long base, int shift,
-			    int max_pnode, enum map_type map_type)
+static __init void map_high(char *id, unsigned long base, int pshift,
+			int bshift, int max_pnode, enum map_type map_type)
 {
 	unsigned long bytes, paddr;
 
-	paddr = base << shift;
-	bytes = (1UL << shift) * (max_pnode + 1);
+	paddr = base << pshift;
+	bytes = (1UL << bshift) * (max_pnode + 1);
 	printk(KERN_INFO "UV: Map %s_HI 0x%lx - 0x%lx\n", id, paddr,
 						paddr + bytes);
 	if (map_type == map_uc)
@@ -399,7 +399,7 @@
 
 	gru.v = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR);
 	if (gru.s.enable) {
-		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
+		map_high("GRU", gru.s.base, shift, shift, max_pnode, map_wb);
 		gru_start_paddr = ((u64)gru.s.base << shift);
 		gru_end_paddr = gru_start_paddr + (1UL << shift) * (max_pnode + 1);
 
@@ -413,7 +413,7 @@
 
 	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
 	if (mmr.s.enable)
-		map_high("MMR", mmr.s.base, shift, max_pnode, map_uc);
+		map_high("MMR", mmr.s.base, shift, shift, max_pnode, map_uc);
 }
 
 static __init void map_mmioh_high(int max_pnode)
@@ -423,7 +423,8 @@
 
 	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
 	if (mmioh.s.enable)
-		map_high("MMIOH", mmioh.s.base, shift, max_pnode, map_uc);
+		map_high("MMIOH", mmioh.s.base, shift, mmioh.s.m_io,
+			max_pnode, map_uc);
 }
 
 static __init void map_low_mmrs(void)

