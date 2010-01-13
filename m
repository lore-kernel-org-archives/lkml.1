Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827Ab0AMKis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab0AMKis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432Ab0AMKii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:38:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:38582 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818Ab0AMKig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:38:36 -0500
Date: Wed, 13 Jan 2010 10:37:51 GMT
From: tip-bot for Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, travis@sgi.com, habeck@sgi.com,
       steiner@sgi.com, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       habeck@sgi.com, steiner@sgi.com, travis@sgi.com,
       torvalds@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B479202.7080705@sgi.com>
References: <4B479202.7080705@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: SGI UV: Fix mapping of MMIO registers
Message-ID: <tip-fcfbb2b5facd65efa7284cc315225bfe3d1856c2@git.kernel.org>
Git-Commit-ID: fcfbb2b5facd65efa7284cc315225bfe3d1856c2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:37:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fcfbb2b5facd65efa7284cc315225bfe3d1856c2
Gitweb:     http://git.kernel.org/tip/fcfbb2b5facd65efa7284cc315225bfe3d1856c2
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Fri, 8 Jan 2010 12:13:54 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 10:56:27 +0100

x86: SGI UV: Fix mapping of MMIO registers

This fixes the problem of the initialization code not correctly
mapping the entire MMIO space on a UV system.  A side effect is
the map_high() interface needed to be changed to accommodate
different address and size shifts.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
Cc: <stable@kernel.org>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4B479202.7080705@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 5f92494..b8bb869 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -374,13 +374,13 @@ static __init void get_lowmem_redirect(unsigned long *base, unsigned long *size)
 
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
@@ -396,7 +396,7 @@ static __init void map_gru_high(int max_pnode)
 
 	gru.v = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR);
 	if (gru.s.enable) {
-		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
+		map_high("GRU", gru.s.base, shift, shift, max_pnode, map_wb);
 		gru_start_paddr = ((u64)gru.s.base << shift);
 		gru_end_paddr = gru_start_paddr + (1UL << shift) * (max_pnode + 1);
 
@@ -410,7 +410,7 @@ static __init void map_mmr_high(int max_pnode)
 
 	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
 	if (mmr.s.enable)
-		map_high("MMR", mmr.s.base, shift, max_pnode, map_uc);
+		map_high("MMR", mmr.s.base, shift, shift, max_pnode, map_uc);
 }
 
 static __init void map_mmioh_high(int max_pnode)
@@ -420,7 +420,8 @@ static __init void map_mmioh_high(int max_pnode)
 
 	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
 	if (mmioh.s.enable)
-		map_high("MMIOH", mmioh.s.base, shift, max_pnode, map_uc);
+		map_high("MMIOH", mmioh.s.base, shift, mmioh.s.m_io,
+			max_pnode, map_uc);
 }
 
 static __init void map_low_mmrs(void)
