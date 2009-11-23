Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZKWSzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZKWSzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbZKWSzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:55:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:56024 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648AbZKWSzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:55:42 -0500
Date: Mon, 23 Nov 2009 18:55:19 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091119202341.GA4420@sgi.com>
References: <20091119202341.GA4420@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: UV SGI: Don't track GRU space in PAT
Message-ID: <tip-fd12a0d69aee6d90fa9b9890db24368a897f8423@git.kernel.org>
Git-Commit-ID: fd12a0d69aee6d90fa9b9890db24368a897f8423
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd12a0d69aee6d90fa9b9890db24368a897f8423
Gitweb:     http://git.kernel.org/tip/fd12a0d69aee6d90fa9b9890db24368a897f8423
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Thu, 19 Nov 2009 14:23:41 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 19:47:42 +0100

x86: UV SGI: Don't track GRU space in PAT

GRU space is always mapped as WB in the page table. There is
no need to track the mappings in the PAT. This also eliminates
the "freeing invalid memtype" messages when the GRU space is
unmapped.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20091119202341.GA4420@sgi.com>
[ v2: fix build failure ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/pat.h         |    2 ++
 arch/x86/include/asm/x86_init.h    |    2 ++
 arch/x86/kernel/apic/x2apic_uv_x.c |   19 ++++++++++++++++++-
 arch/x86/kernel/x86_init.c         |    2 ++
 arch/x86/mm/pat.c                  |   12 +++++++++---
 5 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
index e2c1668..4c35dd0 100644
--- a/arch/x86/include/asm/pat.h
+++ b/arch/x86/include/asm/pat.h
@@ -24,4 +24,6 @@ int io_reserve_memtype(resource_size_t start, resource_size_t end,
 
 void io_free_memtype(resource_size_t start, resource_size_t end);
 
+int default_is_untracked_pat_range(u64 start, u64 end);
+
 #endif /* _ASM_X86_PAT_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 2c756fd..8112ed7 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -113,11 +113,13 @@ struct x86_cpuinit_ops {
 
 /**
  * struct x86_platform_ops - platform specific runtime functions
+ * @is_untracked_pat_range	exclude from PAT logic
  * @calibrate_tsc:		calibrate TSC
  * @get_wallclock:		get time from HW clock like RTC etc.
  * @set_wallclock:		set time back to HW clock
  */
 struct x86_platform_ops {
+	int (*is_untracked_pat_range)(u64 start, u64 end);
 	unsigned long (*calibrate_tsc)(void);
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long nowtime);
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index f5f5886..2477c9f 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -30,10 +30,22 @@
 #include <asm/apic.h>
 #include <asm/ipi.h>
 #include <asm/smp.h>
+#include <asm/x86_init.h>
 
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
+		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
 		if (!strcmp(oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
 		else if (!strcmp(oem_table_id, "UVX"))
@@ -385,8 +398,12 @@ static __init void map_gru_high(int max_pnode)
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
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 4449a4a..bcc749e 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -13,6 +13,7 @@
 #include <asm/e820.h>
 #include <asm/time.h>
 #include <asm/irq.h>
+#include <asm/pat.h>
 #include <asm/tsc.h>
 
 void __cpuinit x86_init_noop(void) { }
@@ -69,6 +70,7 @@ struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 };
 
 struct x86_platform_ops x86_platform = {
+	.is_untracked_pat_range		= default_is_untracked_pat_range,
 	.calibrate_tsc			= native_calibrate_tsc,
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_rtc_mmss,
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index e78cd0e..38a66ef 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -20,6 +20,7 @@
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
+#include <asm/x86_init.h>
 #include <asm/pgtable.h>
 #include <asm/fcntl.h>
 #include <asm/e820.h>
@@ -348,6 +349,11 @@ static int free_ram_pages_type(u64 start, u64 end)
 	return 0;
 }
 
+int default_is_untracked_pat_range(u64 start, u64 end)
+{
+	return is_ISA_range(start, end);
+}
+
 /*
  * req_type typically has one of the:
  * - _PAGE_CACHE_WB
@@ -388,7 +394,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	}
 
 	/* Low ISA region is always mapped WB in page table. No need to track */
-	if (is_ISA_range(start, end - 1)) {
+	if (x86_platform.is_untracked_pat_range(start, end - 1)) {
 		if (new_type)
 			*new_type = _PAGE_CACHE_WB;
 		return 0;
@@ -499,7 +505,7 @@ int free_memtype(u64 start, u64 end)
 		return 0;
 
 	/* Low ISA region is always mapped WB. No need to track */
-	if (is_ISA_range(start, end - 1))
+	if (x86_platform.is_untracked_pat_range(start, end - 1))
 		return 0;
 
 	is_range_ram = pat_pagerange_is_ram(start, end);
@@ -582,7 +588,7 @@ static unsigned long lookup_memtype(u64 paddr)
 	int rettype = _PAGE_CACHE_WB;
 	struct memtype *entry;
 
-	if (is_ISA_range(paddr, paddr + PAGE_SIZE - 1))
+	if (x86_platform.is_untracked_pat_range(paddr, paddr + PAGE_SIZE - 1))
 		return rettype;
 
 	if (pat_pagerange_is_ram(paddr, paddr + PAGE_SIZE)) {
