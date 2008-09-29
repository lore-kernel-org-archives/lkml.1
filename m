Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYI2WDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYI2WDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYI2WDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:03:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48065 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753965AbYI2WDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:03:20 -0400
Date: Mon, 29 Sep 2008 17:03:19 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 3/4] Add UV partition call
Message-ID: <20080929220319.GE108640@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 3/4] Add UV partition call

Add a bios call to return partitioning related info.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/bios_uv.c        |   44 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/genx2apic_uv_x.c |   14 +++++++-----
 include/asm-x86/uv/bios.h        |   22 ++++++++++++++++---
 3 files changed, 66 insertions(+), 14 deletions(-)

Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-09-29 16:38:13.000000000 -0500
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-09-29 16:55:32.000000000 -0500
@@ -342,12 +342,12 @@ static __init void map_mmioh_high(int ma
 
 static __init void uv_rtc_init(void)
 {
-	long status, ticks_per_sec, drift;
+	long status;
+	u64 ticks_per_sec;
 
-	status =
-	    x86_bios_freq_base(BIOS_FREQ_BASE_REALTIME_CLOCK, &ticks_per_sec,
-					&drift);
-	if (status != 0 || ticks_per_sec < 100000) {
+	status = uv_bios_freq_base(BIOS_FREQ_BASE_REALTIME_CLOCK,
+					&ticks_per_sec);
+	if (status != BIOS_STATUS_SUCCESS || ticks_per_sec < 100000) {
 		printk(KERN_WARNING
 			"unable to determine platform RTC clock frequency, "
 			"guessing.\n");
@@ -428,6 +428,8 @@ void __init uv_system_init(void)
 	gnode_upper = (((unsigned long)node_id.s.node_id) &
 		       ~((1 << n_val) - 1)) << m_val;
 
+	uv_bios_get_sn_info(0, &uv_type, &sn_partition_id,
+			    &uv_coherency_id, &uv_region_size);
 	uv_rtc_init();
 
 	for_each_present_cpu(cpu) {
@@ -449,7 +451,7 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
-		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
+		uv_cpu_hub_info(cpu)->coherency_domain_number = uv_coherency_id;
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
Index: linux/include/asm-x86/uv/bios.h
===================================================================
--- linux.orig/include/asm-x86/uv/bios.h	2008-09-29 16:53:07.000000000 -0500
+++ linux/include/asm-x86/uv/bios.h	2008-09-29 16:55:32.000000000 -0500
@@ -51,6 +51,16 @@ enum {
 	BIOS_FREQ_BASE_REALTIME_CLOCK = 2
 };
 
+union partition_info_u {
+	u64	val;
+	struct {
+		u64	hub_version	:  8,
+			partition_id	: 16,
+			coherence_id	: 16,
+			region_size	: 24;
+	};
+};
+
 /*
  * bios calls have 6 parameters
  */
@@ -58,9 +68,15 @@ extern s64 uv_bios_call(enum uv_bios_cmd
 extern s64 uv_bios_call_irqsave(enum uv_bios_cmd, u64, u64, u64, u64, u64);
 extern s64 uv_bios_call_reentrant(enum uv_bios_cmd, u64, u64, u64, u64, u64);
 
+extern s64 uv_bios_get_sn_info(int, int *, long *, long *, long *);
+extern s64 uv_bios_freq_base(u64, u64 *);
+
+
+extern int uv_type;
+extern long sn_partition_id;
+extern long uv_coherency_id;
+extern long uv_region_size;
+#define partition_coherence_id()	(uv_coherency_id)
 
-extern long
-x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
-		   unsigned long *drift_info);
 
 #endif /* ASM_X86__UV__BIOS_H */
Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2008-09-29 16:53:07.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2008-09-29 16:55:32.000000000 -0500
@@ -23,6 +23,7 @@
 #include <asm/efi.h>
 #include <linux/io.h>
 #include <asm/uv/bios.h>
+#include <asm/uv/uv_hub.h>
 
 #ifdef CONFIG_EFI
 
@@ -69,11 +70,44 @@ s64 uv_bios_call_reentrant(enum uv_bios_
 	return ret;
 }
 
-long
-x86_bios_freq_base(unsigned long clock_type, unsigned long *ticks_per_second,
-					unsigned long *drift_info)
+
+long sn_partition_id;
+EXPORT_SYMBOL_GPL(sn_partition_id);
+long uv_coherency_id;
+EXPORT_SYMBOL_GPL(uv_coherency_id);
+long uv_region_size;
+EXPORT_SYMBOL_GPL(uv_region_size);
+int uv_type;
+
+
+s64 uv_bios_get_sn_info(int fc, int *uvtype, long *partid, long *coher,
+		long *region)
+{
+	s64 ret;
+	u64 v0, v1;
+	union partition_info_u part;
+
+	ret = uv_bios_call_irqsave(UV_BIOS_GET_SN_INFO, fc,
+				(u64)(&v0), (u64)(&v1), 0, 0);
+	if (ret != BIOS_STATUS_SUCCESS)
+		return ret;
+
+	part.val = v0;
+	if (uvtype)
+		*uvtype = part.hub_version;
+	if (partid)
+		*partid = part.partition_id;
+	if (coher)
+		*coher = part.coherence_id;
+	if (region)
+		*region = part.region_size;
+	return ret;
+}
+
+
+s64 uv_bios_freq_base(u64 clock_type, u64 *ticks_per_second)
 {
 	return uv_bios_call(UV_BIOS_FREQ_BASE, clock_type,
-				(u64)ticks_per_second, 0, 0, 0);
+			   (u64)ticks_per_second, 0, 0, 0);
 }
-EXPORT_SYMBOL_GPL(x86_bios_freq_base);
+EXPORT_SYMBOL_GPL(uv_bios_freq_base);
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
