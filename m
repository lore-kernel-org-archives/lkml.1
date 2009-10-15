Return-Path: <linux-kernel-owner+w=401wt.eu-S1763267AbZJOWul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763267AbZJOWul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762978AbZJOWuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:50:40 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37480 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763258AbZJOWuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:50:40 -0400
From: Robin Holt <holt@sgi.com>
Message-Id: <20091015224947.354545000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 17:40:01 -0500
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>, Cliff Whickman <cpw@sgi.com>
Subject: [patch 2/2] x86, UV: Modify bau to use uv_gpa_to_pnode().
References: <20091015223959.783988000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=bau_use_gpa_to_pnode
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create an inline function to extract the pnode from a global physical
address and then convert the broadcast assist unit to use the newly
created uv_gpa_to_pnode function.

To: Ingo Molnar <mingo@elte.hu>
To: tglx@linutronix.de
Signed-off-by: Robin Holt <holt@sgi.com>
Acked-by: Cliff Whickman <cpw@sgi.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

---
 arch/x86/include/asm/uv/uv_hub.h |    8 +++++++-
 arch/x86/kernel/tlb_uv.c         |    7 ++-----
 2 files changed, 9 insertions(+), 6 deletions(-)
Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-10-15 17:26:48.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-10-15 17:28:46.000000000 -0500
@@ -114,7 +114,7 @@
 /*
  * The largest possible NASID of a C or M brick (+ 2)
  */
-#define UV_MAX_NASID_VALUE	(UV_MAX_NUMALINK_NODES * 2)
+#define UV_MAX_NASID_VALUE	(UV_MAX_NUMALINK_BLADES * 2)
 
 struct uv_scir_s {
 	struct timer_list timer;
@@ -230,6 +230,12 @@ static inline unsigned long uv_gpa(void 
 	return uv_soc_phys_ram_to_gpa(__pa(v));
 }
 
+/* gpa -> pnode */
+static inline int uv_gpa_to_pnode(unsigned long gpa)
+{
+	return gpa >> uv_hub_info->m_val & ((1UL << uv_hub_info->n_val) - 1);
+}
+
 /* pnode, offset --> socket virtual */
 static inline void *uv_pnode_offset_to_vaddr(int pnode, unsigned long offset)
 {
Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c	2009-10-15 17:26:48.000000000 -0500
+++ linux/arch/x86/kernel/tlb_uv.c	2009-10-15 17:28:46.000000000 -0500
@@ -23,8 +23,6 @@
 static struct bau_control	**uv_bau_table_bases __read_mostly;
 static int			uv_bau_retry_limit __read_mostly;
 
-/* position of pnode (which is nasid>>1): */
-static int			uv_nshift __read_mostly;
 /* base pnode in this partition */
 static int			uv_partition_base_pnode __read_mostly;
 
@@ -723,7 +721,7 @@ uv_activation_descriptor_init(int node, 
 	BUG_ON(!adp);
 
 	pa = uv_gpa(adp); /* need the real nasid*/
-	n = pa >> uv_nshift;
+	n = uv_gpa_to_pnode(pa);
 	m = pa & uv_mmask;
 
 	uv_write_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE,
@@ -778,7 +776,7 @@ uv_payload_queue_init(int node, int pnod
 	 * need the pnode of where the memory was really allocated
 	 */
 	pa = uv_gpa(pqp);
-	pn = pa >> uv_nshift;
+	pn = uv_gpa_to_pnode(pa);
 	uv_write_global_mmr64(pnode,
 			      UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST,
 			      ((unsigned long)pn << UV_PAYLOADQ_PNODE_SHIFT) |
@@ -843,7 +841,6 @@ static int __init uv_bau_init(void)
 				       GFP_KERNEL, cpu_to_node(cur_cpu));
 
 	uv_bau_retry_limit = 1;
-	uv_nshift = uv_hub_info->m_val;
 	uv_mmask = (1UL << uv_hub_info->m_val) - 1;
 	nblades = uv_num_possible_blades();
 

