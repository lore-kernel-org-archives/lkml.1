Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZDTNZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZDTNZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 09:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZDTNZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 09:25:33 -0400
Received: from relay1.sgi.com ([192.48.179.29]:43159 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755268AbZDTNZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 09:25:32 -0400
Date: Mon, 20 Apr 2009 08:25:31 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86/uv - fix for no memory at paddr 0
Message-ID: <20090420132530.GA23156@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/uv: fix for no memory at paddr 0

Fix endcase where the memory at physical address 0 does not really
exist AND one of the sockets on blade 0 has no active cpus.

The memory that _appears_ to be at physical address 0 is actually
memory that located at a different address but has been remapped by
the chipset so that it appears to be at physical address 0.

When determining the UV pnode, the algorithm for determining the pnode
incorrectly used the relocated physical address instead of the actual
(global) address.


[ Impact: boot failure on partitioned systems ]

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-04-13 11:22:12.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-04-13 11:22:46.000000000 -0500
@@ -652,6 +652,7 @@ void __init uv_system_init(void)
 		if (uv_node_to_blade[nid] >= 0)
 			continue;
 		paddr = node_start_pfn(nid) << PAGE_SHIFT;
+		paddr = uv_soc_phys_ram_to_gpa(paddr);
 		pnode = (paddr >> m_val) & pnode_mask;
 		blade = boot_pnode_to_blade(pnode);
 		uv_node_to_blade[nid] = blade;
