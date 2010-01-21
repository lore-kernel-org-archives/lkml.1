Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576Ab0AUE2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0AUE2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171Ab0AUE1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:27:53 -0500
Received: from kroah.org ([198.145.64.141]:60130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab0AUEWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:22:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:34 2010
Message-Id: <20100121041834.071686049@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Travis <travis@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [12/30] x86: SGI UV: Fix mapping of MMIO registers
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Travis <travis@sgi.com>

commit fcfbb2b5facd65efa7284cc315225bfe3d1856c2 upstream.

This fixes the problem of the initialization code not correctly
mapping the entire MMIO space on a UV system.  A side effect is
the map_high() interface needed to be changed to accommodate
different address and size shifts.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4B479202.7080705@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -364,13 +364,13 @@ static __init void get_lowmem_redirect(u
 
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
@@ -386,7 +386,7 @@ static __init void map_gru_high(int max_
 
 	gru.v = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR);
 	if (gru.s.enable)
-		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
+		map_high("GRU", gru.s.base, shift, shift, max_pnode, map_wb);
 }
 
 static __init void map_mmr_high(int max_pnode)
@@ -396,7 +396,7 @@ static __init void map_mmr_high(int max_
 
 	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
 	if (mmr.s.enable)
-		map_high("MMR", mmr.s.base, shift, max_pnode, map_uc);
+		map_high("MMR", mmr.s.base, shift, shift, max_pnode, map_uc);
 }
 
 static __init void map_mmioh_high(int max_pnode)
@@ -406,7 +406,8 @@ static __init void map_mmioh_high(int ma
 
 	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
 	if (mmioh.s.enable)
-		map_high("MMIOH", mmioh.s.base, shift, max_pnode, map_uc);
+		map_high("MMIOH", mmioh.s.base, shift, mmioh.s.m_io,
+			max_pnode, map_uc);
 }
 
 static __init void uv_rtc_init(void)


