Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbZIIPp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbZIIPp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZIIPpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:45:24 -0400
Received: from relay2.sgi.com ([192.48.179.30]:60077 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752955AbZIIPpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:45:20 -0400
Date: Wed, 9 Sep 2009 10:45:22 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV SGI, Don't track GRU space in PAT
Message-ID: <20090909154522.GA17060@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GRU space is always mapped as WB in the page table. There is
no need to track the mappings in the PAT. This also eliminates
the "freeing invalid memtype" messages when the GRU space is unmapped.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/include/asm/uv/uv.h       |    2 ++
 arch/x86/kernel/apic/x2apic_uv_x.c |   11 ++++++++++-
 arch/x86/mm/pat.c                  |    5 +++--
 3 files changed, 15 insertions(+), 3 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv.h	2009-09-01 08:27:46.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv.h	2009-09-01 16:34:00.000000000 -0500
@@ -8,6 +8,7 @@ struct mm_struct;
 
 #ifdef CONFIG_X86_UV
 
+extern int is_GRU_range(u64 start, u64 end);
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 extern void uv_cpu_init(void);
@@ -19,6 +20,7 @@ extern const struct cpumask *uv_flush_tl
 
 #else	/* X86_UV */
 
+static inline int is_GRU_range(u64 start, u64 end)	{ return 0; }
 static inline enum uv_system_type get_uv_system_type(void) { return UV_NONE; }
 static inline int is_uv_system(void)	{ return 0; }
 static inline void uv_cpu_init(void)	{ }
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-09-01 16:33:39.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-09-01 16:34:00.000000000 -0500
@@ -34,6 +34,7 @@
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
+static u64 gru_start_paddr, gru_end_paddr;
 
 static int early_get_nodeid(void)
 {
@@ -68,6 +69,11 @@ enum uv_system_type get_uv_system_type(v
 	return uv_system_type;
 }
 
+int is_GRU_range(u64 start, u64 end)
+{
+	return start >= gru_start_paddr && end < gru_end_paddr;
+}
+
 int is_uv_system(void)
 {
 	return uv_system_type != UV_NONE;
@@ -386,8 +392,11 @@ static __init void map_gru_high(int max_
 	int shift = UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT;
 
 	gru.v = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR);
-	if (gru.s.enable)
+	if (gru.s.enable) {
 		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
+		gru_start_paddr = ((u64)gru.s.base << shift);
+		gru_end_paddr = gru_start_paddr + (1UL << shift) * (max_pnode + 1);
+	}
 }
 
 static __init void map_mmr_high(int max_pnode)
Index: linux/arch/x86/mm/pat.c
===================================================================
--- linux.orig/arch/x86/mm/pat.c	2009-09-01 08:27:47.000000000 -0500
+++ linux/arch/x86/mm/pat.c	2009-09-01 16:34:00.000000000 -0500
@@ -27,6 +27,7 @@
 #include <asm/msr.h>
 #include <asm/pat.h>
 #include <asm/io.h>
+#include <asm/uv/uv.h>
 
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_enabled = 1;
@@ -346,7 +347,7 @@ int reserve_memtype(u64 start, u64 end, 
 	}
 
 	/* Low ISA region is always mapped WB in page table. No need to track */
-	if (is_ISA_range(start, end - 1)) {
+	if (is_ISA_range(start, end - 1) || is_GRU_range(start, end - 1)) {
 		if (new_type)
 			*new_type = _PAGE_CACHE_WB;
 		return 0;
@@ -462,7 +463,7 @@ int free_memtype(u64 start, u64 end)
 		return 0;
 
 	/* Low ISA region is always mapped WB. No need to track */
-	if (is_ISA_range(start, end - 1))
+	if (is_ISA_range(start, end - 1) || is_GRU_range(start, end - 1))
 		return 0;
 
 	is_range_ram = pat_pagerange_is_ram(start, end);
