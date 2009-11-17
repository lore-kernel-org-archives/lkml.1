Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZKQVXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZKQVXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 16:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZKQVXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 16:23:15 -0500
Received: from relay1.sgi.com ([192.48.179.29]:46555 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752885AbZKQVXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 16:23:15 -0500
Date: Tue, 17 Nov 2009 15:23:18 -0600
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: UV SGI, Don't track GRU space in PAT
Message-ID: <20091117212318.GA21137@sgi.com>
References: <20091029184723.GA562@sgi.com> <20091108120609.GW11372@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108120609.GW11372@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GRU space is always mapped as WB in the page table. There is
no need to track the mappings in the PAT. This also eliminates
the "freeing invalid memtype" messages when the GRU space is unmapped.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
Version 2 with changes suggested by Ingo (at least I think I understood what
he wanted).


 arch/x86/include/asm/pat.h         |    2 ++
 arch/x86/kernel/apic/x2apic_uv_x.c |   19 ++++++++++++++++++-
 arch/x86/mm/pat.c                  |   12 +++++++++---
 3 files changed, 29 insertions(+), 4 deletions(-)

Index: linux/arch/x86/include/asm/pat.h
===================================================================
--- linux.orig/arch/x86/include/asm/pat.h	2009-11-17 01:26:59.000000000 -0600
+++ linux/arch/x86/include/asm/pat.h	2009-11-17 15:13:17.000000000 -0600
@@ -24,4 +24,6 @@ int io_reserve_memtype(resource_size_t s
 
 void io_free_memtype(resource_size_t start, resource_size_t end);
 
+extern int (*is_untracked_pat_range)(u64 start, u64 end);
+
 #endif /* _ASM_X86_PAT_H */
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-11-17 15:13:14.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-11-17 15:13:17.000000000 -0600
@@ -30,10 +30,22 @@
 #include <asm/apic.h>
 #include <asm/ipi.h>
 #include <asm/smp.h>
+#include <asm/pat.h>
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
+static u64 gru_start_paddr, gru_end_paddr;
+
+static int is_GRU_range(u64 start, u64 end)
+{
+	return start >= gru_start_paddr && end < gru_end_paddr;
+}
+
+static int uv_is_untracked_pat_range(u64 start, u64 end)
+{
+	return is_ISA_range(start, end) || is_GRU_range(start, end);
+}
 
 static int early_get_nodeid(void)
 {
@@ -49,6 +61,7 @@ static int early_get_nodeid(void)
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strcmp(oem_id, "SGI")) {
+		is_untracked_pat_range =  uv_is_untracked_pat_range;
 		if (!strcmp(oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
 		else if (!strcmp(oem_table_id, "UVX"))
@@ -386,8 +399,12 @@ static __init void map_gru_high(int max_
 	int shift = UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT;
 
 	gru.v = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR);
-	if (gru.s.enable)
+	if (gru.s.enable) {
 		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
+		gru_start_paddr = ((u64)gru.s.base << shift);
+		gru_end_paddr = gru_start_paddr + (1UL << shift) * (max_pnode + 1);
+
+	}
 }
 
 static __init void map_mmr_high(int max_pnode)
Index: linux/arch/x86/mm/pat.c
===================================================================
--- linux.orig/arch/x86/mm/pat.c	2009-11-17 15:13:14.000000000 -0600
+++ linux/arch/x86/mm/pat.c	2009-11-17 15:13:17.000000000 -0600
@@ -348,6 +348,12 @@ static int free_ram_pages_type(u64 start
 	return 0;
 }
 
+static int default_is_untracked_pat_range(u64 start, u64 end)
+{
+	return is_ISA_range(start, end);
+}
+int (*is_untracked_pat_range)(u64 start, u64 end) = default_is_untracked_pat_range;
+
 /*
  * req_type typically has one of the:
  * - _PAGE_CACHE_WB
@@ -383,7 +389,7 @@ int reserve_memtype(u64 start, u64 end, 
 	}
 
 	/* Low ISA region is always mapped WB in page table. No need to track */
-	if (is_ISA_range(start, end - 1)) {
+	if (is_untracked_pat_range(start, end - 1)) {
 		if (new_type)
 			*new_type = _PAGE_CACHE_WB;
 		return 0;
@@ -494,7 +500,7 @@ int free_memtype(u64 start, u64 end)
 		return 0;
 
 	/* Low ISA region is always mapped WB. No need to track */
-	if (is_ISA_range(start, end - 1))
+	if (default_is_untracked_pat_range(start, end - 1))
 		return 0;
 
 	is_range_ram = pat_pagerange_is_ram(start, end);
@@ -577,7 +583,7 @@ static unsigned long lookup_memtype(u64 
 	int rettype = _PAGE_CACHE_WB;
 	struct memtype *entry;
 
-	if (is_ISA_range(paddr, paddr + PAGE_SIZE - 1))
+	if (is_untracked_pat_range(paddr, paddr + PAGE_SIZE - 1))
 		return rettype;
 
 	if (pat_pagerange_is_ram(paddr, paddr + PAGE_SIZE)) {
