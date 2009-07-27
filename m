Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbZG0OfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbZG0OfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZG0OfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:35:12 -0400
Received: from relay3.sgi.com ([192.48.156.57]:55836 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751919AbZG0OfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:35:11 -0400
Date: Mon, 27 Jul 2009 09:35:07 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: blade-local memory 
Message-ID: <20090727143507.GA7006@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UV blades may not have any blade-local memory. Add a field (nid) to the UV
blade structure to indicates whether the node has local memory.
This is needed by the GRU driver (pushed separately).


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/include/asm/uv/uv_hub.h   |    7 +++++++
 arch/x86/kernel/apic/x2apic_uv_x.c |    5 +++++
 2 files changed, 12 insertions(+)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-07-23 09:17:15.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-07-23 09:44:41.000000000 -0500
@@ -327,6 +327,7 @@ struct uv_blade_info {
 	unsigned short	nr_possible_cpus;
 	unsigned short	nr_online_cpus;
 	unsigned short	pnode;
+	short		memory_nid;
 };
 extern struct uv_blade_info *uv_blade_info;
 extern short *uv_node_to_blade;
@@ -363,6 +364,12 @@ static inline int uv_blade_to_pnode(int 
 	return uv_blade_info[bid].pnode;
 }
 
+/* Nid of memory node on blade. -1 if no blade-local memory */
+static inline int uv_blade_to_memory_nid(int bid)
+{
+	return uv_blade_info[bid].memory_nid;
+}
+
 /* Determine the number of possible cpus on a blade */
 static inline int uv_blade_nr_possible_cpus(int bid)
 {
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-07-23 09:17:15.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-07-23 09:44:41.000000000 -0500
@@ -592,6 +592,8 @@ void __init uv_system_init(void)
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
 	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
 	BUG_ON(!uv_blade_info);
+	for (blade = 0; blade < uv_num_possible_blades(); blade++)
+		uv_blade_info[blade].memory_nid = -1;
 
 	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
 
@@ -630,6 +632,9 @@ void __init uv_system_init(void)
 		lcpu = uv_blade_info[blade].nr_possible_cpus;
 		uv_blade_info[blade].nr_possible_cpus++;
 
+		/* Any node on the blade, else will contain -1. */
+		uv_blade_info[blade].memory_nid = nid;
+
 		uv_cpu_hub_info(cpu)->lowmem_remap_base = lowmem_redir_base;
 		uv_cpu_hub_info(cpu)->lowmem_remap_top = lowmem_redir_size;
 		uv_cpu_hub_info(cpu)->m_val = m_val;
