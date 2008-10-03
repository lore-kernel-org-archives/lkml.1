Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYJCQ7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYJCQ7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYJCQ7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:59:35 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54621 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753927AbYJCQ7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:59:34 -0400
Date: Fri, 3 Oct 2008 11:59:33 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Cc: Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: [PATCH 3/4] x86: Add UV partition call v4
Message-ID: <20081003165933.GD131149@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 3/4] x86: Add UV partition call v4

Add a bios call to return partitioning related info.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/bios_uv.c        |   44 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/genx2apic_uv_x.c |   14 +++++++-----
 include/asm-x86/uv/bios.h        |   22 ++++++++++++++++---
 3 files changed, 66 insertions(+), 14 deletions(-)

Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2008-10-03 11:05:27.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2008-10-03 11:05:37.000000000 -0500
@@ -23,6 +23,7 @@
 #include <asm/efi.h>
 #include <linux/io.h>
 #include <asm/uv/bios.h>
+#include <asm/uv/uv_hub.h>
 
 struct uv_systab uv_systab;
 
@@ -65,14 +66,47 @@ s64 uv_bios_call_reentrant(enum uv_bios_
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
 
 
 #ifdef CONFIG_EFI
Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-10-03 11:05:27.000000000 -0500
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-10-03 11:05:37.000000000 -0500
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
@@ -429,6 +429,8 @@ void __init uv_system_init(void)
 		       ~((1 << n_val) - 1)) << m_val;
 
 	uv_bios_init();
+	uv_bios_get_sn_info(0, &uv_type, &sn_partition_id,
+			    &uv_coherency_id, &uv_region_size);
 	uv_rtc_init();
 
 	for_each_present_cpu(cpu) {
@@ -450,7 +452,7 @@ void __init uv_system_init(void)
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
--- linux.orig/include/asm-x86/uv/bios.h	2008-10-03 11:05:27.000000000 -0500
+++ linux/include/asm-x86/uv/bios.h	2008-10-03 11:05:37.000000000 -0500
@@ -61,6 +61,16 @@ enum {
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
@@ -68,10 +78,16 @@ extern s64 uv_bios_call(enum uv_bios_cmd
 extern s64 uv_bios_call_irqsave(enum uv_bios_cmd, u64, u64, u64, u64, u64);
 extern s64 uv_bios_call_reentrant(enum uv_bios_cmd, u64, u64, u64, u64, u64);
 
+extern s64 uv_bios_get_sn_info(int, int *, long *, long *, long *);
+extern s64 uv_bios_freq_base(u64, u64 *);
+
 extern void uv_bios_init(void);
 
-extern long
-x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
-		   unsigned long *drift_info);
+extern int uv_type;
+extern long sn_partition_id;
+extern long uv_coherency_id;
+extern long uv_region_size;
+#define partition_coherence_id()	(uv_coherency_id)
+
 
 #endif /* ASM_X86__UV__BIOS_H */
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
