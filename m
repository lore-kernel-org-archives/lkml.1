Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZIRMKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZIRMKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbZIRMKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:10:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:38895 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbZIRMKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:10:10 -0400
Date: Fri, 18 Sep 2009 12:09:40 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090909154339.GA7946@sgi.com>
References: <20090909154339.GA7946@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: SGI UV: Map MMIO-High memory range
Message-ID: <tip-daf7b9c9216e2b82e4c14b7248a85286dab021c3@git.kernel.org>
Git-Commit-ID: daf7b9c9216e2b82e4c14b7248a85286dab021c3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 18 Sep 2009 12:09:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  daf7b9c9216e2b82e4c14b7248a85286dab021c3
Gitweb:     http://git.kernel.org/tip/daf7b9c9216e2b82e4c14b7248a85286dab021c3
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Wed, 9 Sep 2009 10:43:39 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 14:06:40 +0200

x86: SGI UV: Map MMIO-High memory range

UV depends on the MMRHI space being identity mapped. The patch:

	x86: Make 64-bit efi_ioremap use ioremap on MMIO regions

changed this to make efi regions at a different address using
ioremap. Add the identity mapping to uv_system_init.

( Note this code was previously present but was deleted when BIOS
  added the ranges to the EFI map - previous efi code identify
  mapped the ranges. )

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20090909154339.GA7946@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 6011593..f5f5886 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -389,6 +389,16 @@ static __init void map_gru_high(int max_pnode)
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
@@ -643,6 +653,7 @@ void __init uv_system_init(void)
 	}
 
 	map_gru_high(max_pnode);
+	map_mmr_high(max_pnode);
 	map_mmioh_high(max_pnode);
 
 	uv_cpu_init();
