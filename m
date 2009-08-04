Return-Path: <linux-kernel-owner+w=401wt.eu-S932829AbZHDPcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbZHDPcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbZHDPcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:32:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:39760 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271AbZHDPb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:31:59 -0400
Date: Tue, 4 Aug 2009 15:31:24 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090727143656.GA7698@sgi.com>
References: <20090727143656.GA7698@sgi.com>
Subject: [tip:x86/urgent] x86, UV: Delete mapping of MMR rangs mapped by BIOS
Message-ID: <tip-cc5e4fa1bd4d2f56da07f9092281afdcd2374ab9@git.kernel.org>
Git-Commit-ID: cc5e4fa1bd4d2f56da07f9092281afdcd2374ab9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 15:31:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc5e4fa1bd4d2f56da07f9092281afdcd2374ab9
Gitweb:     http://git.kernel.org/tip/cc5e4fa1bd4d2f56da07f9092281afdcd2374ab9
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Mon, 27 Jul 2009 09:36:56 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 16:18:02 +0200

x86, UV: Delete mapping of MMR rangs mapped by BIOS

The UV BIOS has added additional MMR ranges that are mapped via
EFI virtual mode mappings. These ranges should be deleted from
ranges mapped by uv_system_init().

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: linux-mm@kvack.org
LKML-Reference: <20090727143656.GA7698@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |   31 +------------------------------
 1 files changed, 1 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index ad3f0a9..445c210 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -362,12 +362,6 @@ static __init void get_lowmem_redirect(unsigned long *base, unsigned long *size)
 	BUG();
 }
 
-static __init void map_low_mmrs(void)
-{
-	init_extra_mapping_uc(UV_GLOBAL_MMR32_BASE, UV_GLOBAL_MMR32_SIZE);
-	init_extra_mapping_uc(UV_LOCAL_MMR_BASE, UV_LOCAL_MMR_SIZE);
-}
-
 enum map_type {map_wb, map_uc};
 
 static __init void map_high(char *id, unsigned long base, int shift,
@@ -395,26 +389,6 @@ static __init void map_gru_high(int max_pnode)
 		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
 }
 
-static __init void map_config_high(int max_pnode)
-{
-	union uvh_rh_gam_cfg_overlay_config_mmr_u cfg;
-	int shift = UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR_BASE_SHFT;
-
-	cfg.v = uv_read_local_mmr(UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR);
-	if (cfg.s.enable)
-		map_high("CONFIG", cfg.s.base, shift, max_pnode, map_uc);
-}
-
-static __init void map_mmr_high(int max_pnode)
-{
-	union uvh_rh_gam_mmr_overlay_config_mmr_u mmr;
-	int shift = UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT;
-
-	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
-	if (mmr.s.enable)
-		map_high("MMR", mmr.s.base, shift, max_pnode, map_uc);
-}
-
 static __init void map_mmioh_high(int max_pnode)
 {
 	union uvh_rh_gam_mmioh_overlay_config_mmr_u mmioh;
@@ -566,8 +540,6 @@ void __init uv_system_init(void)
 	unsigned long mmr_base, present, paddr;
 	unsigned short pnode_mask;
 
-	map_low_mmrs();
-
 	m_n_config.v = uv_read_local_mmr(UVH_SI_ADDR_MAP_CONFIG);
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
@@ -667,11 +639,10 @@ void __init uv_system_init(void)
 		pnode = (paddr >> m_val) & pnode_mask;
 		blade = boot_pnode_to_blade(pnode);
 		uv_node_to_blade[nid] = blade;
+		max_pnode = max(pnode, max_pnode);
 	}
 
 	map_gru_high(max_pnode);
-	map_mmr_high(max_pnode);
-	map_config_high(max_pnode);
 	map_mmioh_high(max_pnode);
 
 	uv_cpu_init();
