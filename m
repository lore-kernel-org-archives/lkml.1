Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYIYMwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYIYMwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYIYMwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 08:52:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37578 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753216AbYIYMwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 08:52:15 -0400
Date: Thu, 25 Sep 2008 07:52:10 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - UV fix for size of hub mappings
Message-ID: <20080925125210.GA22404@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the size of the mappings of UV hub registers. Size must
be a function of the maximum node number within the SSI.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/genx2apic_uv_x.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-08-17 01:21:43.000000000 -0500
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-08-17 07:24:38.000000000 -0500
@@ -286,12 +286,13 @@ static __init void map_low_mmrs(void)
 
 enum map_type {map_wb, map_uc};
 
-static __init void map_high(char *id, unsigned long base, int shift, enum map_type map_type)
+static __init void map_high(char *id, unsigned long base, int shift,
+			    int max_pnode, enum map_type map_type)
 {
 	unsigned long bytes, paddr;
 
 	paddr = base << shift;
-	bytes = (1UL << shift);
+	bytes = (1UL << shift) * (max_pnode + 1);
 	printk(KERN_INFO "UV: Map %s_HI 0x%lx - 0x%lx\n", id, paddr,
 	       					paddr + bytes);
 	if (map_type == map_uc)
@@ -307,7 +308,7 @@ static __init void map_gru_high(int max_
 
 	gru.v = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR);
 	if (gru.s.enable)
-		map_high("GRU", gru.s.base, shift, map_wb);
+		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
 }
 
 static __init void map_config_high(int max_pnode)
@@ -317,7 +318,7 @@ static __init void map_config_high(int m
 
 	cfg.v = uv_read_local_mmr(UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR);
 	if (cfg.s.enable)
-		map_high("CONFIG", cfg.s.base, shift, map_uc);
+		map_high("CONFIG", cfg.s.base, shift, max_pnode, map_uc);
 }
 
 static __init void map_mmr_high(int max_pnode)
@@ -327,7 +328,7 @@ static __init void map_mmr_high(int max_
 
 	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
 	if (mmr.s.enable)
-		map_high("MMR", mmr.s.base, shift, map_uc);
+		map_high("MMR", mmr.s.base, shift, max_pnode, map_uc);
 }
 
 static __init void map_mmioh_high(int max_pnode)
@@ -337,7 +338,7 @@ static __init void map_mmioh_high(int ma
 
 	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
 	if (mmioh.s.enable)
-		map_high("MMIOH", mmioh.s.base, shift, map_uc);
+		map_high("MMIOH", mmioh.s.base, shift, max_pnode, map_uc);
 }
 
 static __init void uv_rtc_init(void)

