Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZIIPni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZIIPni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZIIPnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:43:37 -0400
Received: from relay2.sgi.com ([192.48.179.30]:59027 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752655AbZIIPng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:43:36 -0400
Date: Wed, 9 Sep 2009 10:43:39 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: SGU UV Map MMIO-High memory range
Message-ID: <20090909154339.GA7946@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UV depends on the MMRHI space being identity mapped.  The patch:
	x86: Make 64-bit efi_ioremap use ioremap on MMIO regions

changed this to make efi regions at a different address using ioremap.
Add the identity mapping to uv_system_init.

(Note this code was previously present but was deleted when BIOS added
the ranges to the EFI map - previous efi code identify mapped the ranges).

Signed-off-by: Jack Steiner <steiner@sgi.com>



---
 arch/x86/kernel/apic/x2apic_uv_x.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-08-31 13:34:18.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-08-31 17:15:05.000000000 -0500
@@ -390,6 +390,16 @@ static __init void map_gru_high(int max_
 		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
 }
 
+static __init void map_mmr_high(int max_pnode)
+{
+	union uvh_rh_gam_mmr_overlay_config_mmr_u mmr;
+	int shift = UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT;
+
+	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
+	if (mmr.s.enable)
+		map_high("MMR", mmr.s.base, shift, max_pnode, map_uc);
+}
+
 static __init void map_mmioh_high(int max_pnode)
 {
 	union uvh_rh_gam_mmioh_overlay_config_mmr_u mmioh;
@@ -644,6 +654,7 @@ void __init uv_system_init(void)
 	}
 
 	map_gru_high(max_pnode);
+	map_mmr_high(max_pnode);
 	map_mmioh_high(max_pnode);
 
 	uv_cpu_init();
