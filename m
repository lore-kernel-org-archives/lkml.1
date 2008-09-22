Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYIVVKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYIVVKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYIVVKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:10:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39660 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753108AbYIVVKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:10:12 -0400
Date: Mon, 22 Sep 2008 16:10:11 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 3/4] x86: Add UV partition call
Message-ID: <20080922211011.GF222374@sgi.com>
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
 arch/x86/kernel/bios_uv.c        |   52 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/genx2apic_uv_x.c |   14 ++++++----
 include/asm-x86/uv/bios.h        |   30 ++++++++++++++++------
 3 files changed, 76 insertions(+), 20 deletions(-)

Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2008-09-22 16:01:11.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2008-09-22 16:01:16.000000000 -0500
@@ -62,14 +62,54 @@ s64 uv_bios_call_reentrant(int which, u6
 	return ret;
 }
 
-long
-x86_bios_freq_base(unsigned long clock_type, unsigned long *ticks_per_second,
-					unsigned long *drift_info)
+
+u8 sn_partition_id;
+EXPORT_SYMBOL(sn_partition_id);
+u8 uv_coherency_id;
+EXPORT_SYMBOL(uv_coherency_id);
+u8 uv_type;
+EXPORT_SYMBOL(uv_type);
+
+/*
+ * Returns information about the UV HUB.
+ *
+ * Parameters for UV_BIOS_GET_SN_INFO call:
+ *  In:
+ *	arg0 - UV_BIOS_GET_SN_INFO
+ *	arg1 - fc (0 for now, other values reserved for future use)
+ *  Out:
+ *      v0
+ *		[7:0]   - uv hub version (0=hub1, 1=hub2)
+ *		[31:24] - partition ID
+ *		[39:32] - coherency_id
+ */
+s64 uv_bios_get_sn_info(int fc, u8 *uvtype, u8 *partid, u8 *coher)
 {
-	return uv_bios_call(BIOS_FREQ_BASE, clock_type,
-				(u64)ticks_per_second, 0, 0, 0);
+	s64 ret;
+	u64 v0, v1;
+
+	ret = uv_bios_call_irqsave(UV_BIOS_GET_SN_INFO, fc,
+				(u64)(&v0), (u64)(&v1), 0, 0);
+	if (ret != BIOS_STATUS_SUCCESS)
+		return ret;
+
+	if (uvtype)
+		*uvtype = v0 & 0xff;
+	if (partid)
+		*partid = (v0 >> 8) & 0xff;
+	if (coher)
+		*coher = (v0 >> 24) & 0xff;
+	return ret;
 }
-EXPORT_SYMBOL_GPL(x86_bios_freq_base);
+
+
+s64
+uv_bios_freq_base(u64 clock_type, u64 *ticks_per_second)
+{
+	return uv_bios_call(UV_BIOS_FREQ_BASE, clock_type,
+			   (u64)ticks_per_second, 0, 0, 0);
+}
+EXPORT_SYMBOL_GPL(uv_bios_freq_base);
 
 
 #ifdef CONFIG_EFI
Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-09-22 16:01:11.000000000 -0500
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-09-22 16:01:16.000000000 -0500
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
@@ -414,6 +414,8 @@ void __init uv_system_init(void)
 		       ~((1 << n_val) - 1)) << m_val;
 
 	uv_bios_init();
+	uv_bios_get_sn_info(0, &uv_type, &sn_partition_id,
+			    &uv_coherency_id);
 	uv_rtc_init();
 
 	for_each_present_cpu(cpu) {
@@ -435,7 +437,7 @@ void __init uv_system_init(void)
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
--- linux.orig/include/asm-x86/uv/bios.h	2008-09-22 16:01:11.000000000 -0500
+++ linux/include/asm-x86/uv/bios.h	2008-09-22 16:01:16.000000000 -0500
@@ -24,12 +24,15 @@
 
 #include <linux/rtc.h>
 
-#define BIOS_FREQ_BASE			0x01000001
-
+/*
+ * Values for the BIOS calls.  It is passed as the first * argument in the
+ * BIOS call.  Passing any other value in the first argument will result
+ * in a BIOS_STATUS_UNIMPLEMENTED return status.
+ */
 enum {
-	BIOS_FREQ_BASE_PLATFORM = 0,
-	BIOS_FREQ_BASE_INTERVAL_TIMER = 1,
-	BIOS_FREQ_BASE_REALTIME_CLOCK = 2
+	UV_BIOS_COMMON,
+	UV_BIOS_GET_SN_INFO,
+	UV_BIOS_FREQ_BASE
 };
 
 /*
@@ -52,6 +55,12 @@ struct sal_systab {
 	u64 function; 		/* BIOS runtime callback function ptr */
 };
 
+enum {
+	BIOS_FREQ_BASE_PLATFORM = 0,
+	BIOS_FREQ_BASE_INTERVAL_TIMER = 1,
+	BIOS_FREQ_BASE_REALTIME_CLOCK = 2
+};
+
 /*
  * bios calls have 6 parameters
  */
@@ -59,11 +68,16 @@ extern s64 uv_bios_call(int, u64, u64, u
 extern s64 uv_bios_call_irqsave(int, u64, u64, u64, u64, u64);
 extern s64 uv_bios_call_reentrant(int which, u64, u64, u64, u64, u64);
 
+extern s64 uv_bios_get_sn_info(int, u8 *, u8 *, u8 *);
+extern s64 uv_bios_freq_base(u64, u64 *);
+
 extern void uv_bios_init(void);
 
-extern long
-x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
-		   unsigned long *drift_info);
+extern u8 uv_type;
+extern u8 sn_partition_id;
+extern u8 uv_coherency_id;
+#define partition_coherence_id()	(uv_coherency_id)
+
 
 #ifndef CONFIG_EFI
 extern u64 efi_call6(void *, u64, u64, u64, u64, u64, u64);
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
