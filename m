Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYLLUuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYLLUuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYLLUun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:50:43 -0500
Received: from relay1.sgi.com ([192.48.179.29]:52172 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752944AbYLLUum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:50:42 -0500
Date: Fri, 12 Dec 2008 14:50:40 -0600
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86 : UV fix for global physical addresses
Message-ID: <20081212205040.GA25739@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a UV bug related to generating global memory addresses
on partitioned systems. Partition systems do not have physical memory
at address 0. Instead, a chunk of high memory is remapped by the chipset
so that it appears to be at address 0. This remapping is INVISIBLE to most
of the OS. The only OS functions that need to be aware of the remaping are
functions that directly interface to the chipset. The GRU is one example.

Also, delete a couple of unused macros related to global memory addresses.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/include/asm/uv/uv_hub.h |   16 ++--------------
 arch/x86/kernel/genx2apic_uv_x.c |    3 +--
 2 files changed, 3 insertions(+), 16 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2008-12-08 08:29:29.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2008-12-11 16:16:19.000000000 -0600
@@ -211,7 +211,7 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 static inline unsigned long uv_soc_phys_ram_to_gpa(unsigned long paddr)
 {
 	if (paddr < uv_hub_info->lowmem_remap_top)
-		paddr += uv_hub_info->lowmem_remap_base;
+		paddr |= uv_hub_info->lowmem_remap_base;
 	return paddr | uv_hub_info->gnode_upper;
 }
 
@@ -219,19 +219,7 @@ static inline unsigned long uv_soc_phys_
 /* socket virtual --> UV global physical address */
 static inline unsigned long uv_gpa(void *v)
 {
-	return __pa(v) | uv_hub_info->gnode_upper;
-}
-
-/* socket virtual --> UV global physical address */
-static inline void *uv_vgpa(void *v)
-{
-	return (void *)uv_gpa(v);
-}
-
-/* UV global physical address --> socket virtual */
-static inline void *uv_va(unsigned long gpa)
-{
-	return __va(gpa & uv_hub_info->gpa_mask);
+	return uv_soc_phys_ram_to_gpa(__pa(v));
 }
 
 /* pnode, offset --> socket virtual */
Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-12-11 13:27:24.000000000 -0600
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-12-11 16:19:24.000000000 -0600
@@ -535,8 +535,7 @@ void __init uv_system_init(void)
 		uv_blade_info[blade].nr_possible_cpus++;
 
 		uv_cpu_hub_info(cpu)->lowmem_remap_base = lowmem_redir_base;
-		uv_cpu_hub_info(cpu)->lowmem_remap_top =
-					lowmem_redir_base + lowmem_redir_size;
+		uv_cpu_hub_info(cpu)->lowmem_remap_top = lowmem_redir_size;
 		uv_cpu_hub_info(cpu)->m_val = m_val;
 		uv_cpu_hub_info(cpu)->n_val = m_val;
 		uv_cpu_hub_info(cpu)->numa_blade_id = blade;
