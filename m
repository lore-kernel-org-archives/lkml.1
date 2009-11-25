Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbZKYQUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbZKYQUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 11:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbZKYQUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 11:20:16 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45050 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753911AbZKYQUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 11:20:15 -0500
Date: Wed, 25 Nov 2009 10:20:19 -0600
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: SGI UV - Map low MMR ranges
Message-ID: <20091125162018.GA25445@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explicitly mmap the UV chipset MMR address ranges used to
access blade-local registers. Although these same MMRs are also
mmaped at higher addresses, the low range is more
convenient when accessing blade-local registers.
The low range addresses always alias to the local blade
regardless of the blade id.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-11-24 01:30:19.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-11-24 07:44:49.000000000 -0600
@@ -427,6 +427,12 @@ static __init void map_mmioh_high(int ma
 		map_high("MMIOH", mmioh.s.base, shift, max_pnode, map_uc);
 }
 
+static __init void map_low_mmrs(void)
+{
+	init_extra_mapping_uc(UV_GLOBAL_MMR32_BASE, UV_GLOBAL_MMR32_SIZE);
+	init_extra_mapping_uc(UV_LOCAL_MMR_BASE, UV_LOCAL_MMR_SIZE);
+}
+
 static __init void uv_rtc_init(void)
 {
 	long status;
@@ -568,6 +574,8 @@ void __init uv_system_init(void)
 	unsigned long mmr_base, present, paddr;
 	unsigned short pnode_mask;
 
+	map_low_mmrs();
+
 	m_n_config.v = uv_read_local_mmr(UVH_SI_ADDR_MAP_CONFIG);
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
