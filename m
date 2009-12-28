Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949AbZL1V2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbZL1V2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 16:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZL1V23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 16:28:29 -0500
Received: from relay3.sgi.com ([192.48.152.1]:42445 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751323AbZL1V23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 16:28:29 -0500
Message-ID: <4B3922F9.3060905@sgi.com>
Date: Mon, 28 Dec 2009 13:28:25 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Robin Holt <holt@sgi.com>,
       Jack Steiner <steiner@sgi.com>, stable@kernel.org, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_64 SGI UV: Fix writes to led registers on remote uv hubs.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 SGI UV: Fix writes to led registers on remote uv hubs.

The wrong address was being used to write the SCIR led regs on remote
hubs.  Also, there was an inconsistency between how BIOS and the kernel
indexed these regs.  Standardize on using the lower 6 bits of the APIC
ID as the index.

This patch fixes the problem of writing to an errant address to a cpu # >= 64.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Cc: stable@kernel.org
---
 arch/x86/include/asm/uv/uv_hub.h   |   20 +++++++++++++++++++-
 arch/x86/kernel/apic/x2apic_uv_x.c |   12 ++++++------
 2 files changed, 25 insertions(+), 7 deletions(-)

--- linux.orig/arch/x86/include/asm/uv/uv_hub.h
+++ linux/arch/x86/include/asm/uv/uv_hub.h
@@ -338,6 +338,18 @@
 	return UV_GLOBAL_GRU_MMR_BASE | offset | (pnode << uv_hub_info->m_val);
 }
 
+static inline void uv_write_global_mmr8(int pnode, unsigned long offset,
+				unsigned char val)
+{
+	writeb(val, uv_global_mmr64_address(pnode, offset));
+}
+
+static inline unsigned char uv_read_global_mmr8(int pnode,
+						 unsigned long offset)
+{
+	return readb(uv_global_mmr64_address(pnode, offset));
+}
+
 /*
  * Access hub local MMRs. Faster than using global space but only local MMRs
  * are accessible.
@@ -457,11 +469,17 @@
 	}
 }
 
+static inline unsigned long uv_scir_offset(int apicid)
+{
+	return SCIR_LOCAL_MMR_BASE | (apicid & 0x3f);
+}
+
 static inline void uv_set_cpu_scir_bits(int cpu, unsigned char value)
 {
 	if (uv_cpu_hub_info(cpu)->scir.state != value) {
+		uv_write_global_mmr8(uv_cpu_to_pnode(cpu),
+				uv_cpu_hub_info(cpu)->scir.offset, value);
 		uv_cpu_hub_info(cpu)->scir.state = value;
-		uv_write_local_mmr8(uv_cpu_hub_info(cpu)->scir.offset, value);
 	}
 }
 
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -632,8 +632,10 @@
 	uv_rtc_init();
 
 	for_each_present_cpu(cpu) {
+		int apicid = per_cpu(x86_cpu_to_apicid, cpu);
+
 		nid = cpu_to_node(cpu);
-		pnode = uv_apicid_to_pnode(per_cpu(x86_cpu_to_apicid, cpu));
+		pnode = uv_apicid_to_pnode(apicid);
 		blade = boot_pnode_to_blade(pnode);
 		lcpu = uv_blade_info[blade].nr_possible_cpus;
 		uv_blade_info[blade].nr_possible_cpus++;
@@ -654,15 +656,13 @@
 		uv_cpu_hub_info(cpu)->gnode_extra = gnode_extra;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = sn_coherency_id;
-		uv_cpu_hub_info(cpu)->scir.offset = SCIR_LOCAL_MMR_BASE + lcpu;
+		uv_cpu_hub_info(cpu)->scir.offset = uv_scir_offset(apicid);
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
 
-		printk(KERN_DEBUG "UV: cpu %d, apicid 0x%x, pnode %d, nid %d, "
-			"lcpu %d, blade %d\n",
-			cpu, per_cpu(x86_cpu_to_apicid, cpu), pnode, nid,
-			lcpu, blade);
+		printk(KERN_DEBUG "UV: cpu %d, apicid 0x%x, pnode %d, nid %d, lcpu %d, blade %d\n",
+			cpu, apicid, pnode, nid, lcpu, blade);
 	}
 
 	/* Add blade/pnode info for nodes without cpus */
