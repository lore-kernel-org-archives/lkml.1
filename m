Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbYJWWxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbYJWWxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYJWWxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:53:12 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51543 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752155AbYJWWxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:53:11 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] UV: memory allocation at initialization
Cc: mingo@elte.hu
Message-Id: <E1Kt949-0000LU-0z@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 23 Oct 2008 17:54:05 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Cliff Wickman <cpw@sgi.com>

UV initialization is currently called too late to call alloc_bootmem_pages().
The current sequence is:

 start_kernel()
   mem_init()
     free_all_bootmem()           <--- discard of bootmem
   rest_init()
     kernel_init()
       smp_prepare_cpus()
       native_smp_prepare_cpus()
         uv_system_init()         <--- uses alloc_bootmem_pages()

It should be calling kmalloc().

Diffed against 2.6.27 (linux-next)

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/genx2apic_uv_x.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux/arch/x86/kernel/genx2apic_uv_x.c
@@ -15,7 +15,6 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/sched.h>
-#include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/hardirq.h>
 #include <asm/smp.h>
@@ -407,16 +406,16 @@ void __init uv_system_init(void)
 	printk(KERN_DEBUG "UV: Found %d blades\n", uv_num_possible_blades());
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
-	uv_blade_info = alloc_bootmem_pages(bytes);
+	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
 
 	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
 
 	bytes = sizeof(uv_node_to_blade[0]) * num_possible_nodes();
-	uv_node_to_blade = alloc_bootmem_pages(bytes);
+	uv_node_to_blade = kmalloc(bytes, GFP_KERNEL);
 	memset(uv_node_to_blade, 255, bytes);
 
 	bytes = sizeof(uv_cpu_to_blade[0]) * num_possible_cpus();
-	uv_cpu_to_blade = alloc_bootmem_pages(bytes);
+	uv_cpu_to_blade = kmalloc(bytes, GFP_KERNEL);
 	memset(uv_cpu_to_blade, 255, bytes);
 
 	blade = 0;
