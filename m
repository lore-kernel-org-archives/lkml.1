Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbZKKSar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbZKKSar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 13:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbZKKSaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 13:30:46 -0500
Received: from relay2.sgi.com ([192.48.179.30]:60253 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757926AbZKKSaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 13:30:46 -0500
Date: Wed, 11 Nov 2009 12:30:49 -0600
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: UV SGI, Don't track GRU space in PAT
Message-ID: <20091111183049.GA23692@sgi.com>
References: <20091029184723.GA562@sgi.com> <20091108120609.GW11372@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108120609.GW11372@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...
> >  	/* Low ISA region is always mapped WB. No need to track */
> > -	if (is_ISA_range(start, end - 1))
> > +	if (is_ISA_range(start, end - 1) || is_GRU_range(start, end - 1))
> >  		return 0;
> 
> Hm, that's quite ugly - we used to have is_ISA_range() exceptions, now 
> is_GRU_range() is added too.
> 
> We should instead have an x86_platform vector for PAT exceptions, which 
> SGI/UV (and ISA) would fill in automatically, agreed?

Could you point me to some code to clone - I'm not sure exactly what you
have in mind.

Is this close (untested)?? If so, I'll clean it up,test it & post a real patch.

--- jack



Index: linux/arch/x86/mm/pat.c
===================================================================
--- linux.orig/arch/x86/mm/pat.c	2009-11-11 12:09:59.000000000 -0600
+++ linux/arch/x86/mm/pat.c	2009-11-11 12:25:50.000000000 -0600
@@ -353,6 +353,12 @@ static int free_ram_pages_type(u64 start
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
@@ -393,7 +399,7 @@ int reserve_memtype(u64 start, u64 end, 
 	}
 
 	/* Low ISA region is always mapped WB in page table. No need to track */
-	if (is_ISA_range(start, end - 1)) {
+	if (is_untracked_pat_range(start, end - 1)) {
 		if (new_type)
 			*new_type = _PAGE_CACHE_WB;
 		return 0;
@@ -504,7 +510,7 @@ int free_memtype(u64 start, u64 end)
 		return 0;
 
 	/* Low ISA region is always mapped WB. No need to track */
-	if (is_ISA_range(start, end - 1))
+	if (default_is_untracked_pat_range(start, end - 1))
 		return 0;
 
 	is_range_ram = pat_pagerange_is_ram(start, end);
@@ -587,7 +593,7 @@ static unsigned long lookup_memtype(u64 
 	int rettype = _PAGE_CACHE_WB;
 	struct memtype *entry;
 
-	if (is_ISA_range(paddr, paddr + PAGE_SIZE - 1))
+	if (is_untracked_pat_range(paddr, paddr + PAGE_SIZE - 1))
 		return rettype;
 
 	if (pat_pagerange_is_ram(paddr, paddr + PAGE_SIZE)) {
Index: linux/arch/x86/include/asm/pat.h
===================================================================
--- linux.orig/arch/x86/include/asm/pat.h	2009-10-26 19:39:06.000000000 -0500
+++ linux/arch/x86/include/asm/pat.h	2009-11-11 12:19:26.000000000 -0600
@@ -24,4 +24,6 @@ int io_reserve_memtype(resource_size_t s
 
 void io_free_memtype(resource_size_t start, resource_size_t end);
 
+extern int (*is_untracked_pat_range)(u64 start, u64 end);
+
 #endif /* _ASM_X86_PAT_H */
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-11-11 12:09:59.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-11-11 12:24:26.000000000 -0600
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
@@ -388,8 +401,12 @@ static __init void map_gru_high(int max_
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
