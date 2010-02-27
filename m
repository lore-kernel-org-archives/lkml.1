Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968676Ab0B0RFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:05:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48370 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968632Ab0B0RFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 12:05:04 -0500
Date: Sat, 27 Feb 2010 18:04:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/uv changes for v2.6.34
Message-ID: <20100227170453.GA25723@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-uv-for-linus

 Thanks,

	Ingo

------------------>
Jack Steiner (1):
      x86, uv: uv_global_gru_mmr_address() macro fix

Roel Kluin (1):
      x86, uv: Remove recursion in uv_heartbeat_enable()

Russ Anderson (1):
      x86, uv: Add serial number parameter to uv_bios_get_sn_info()


 arch/x86/include/asm/uv/bios.h     |    7 ++++---
 arch/x86/include/asm/uv/uv_hub.h   |    3 ++-
 arch/x86/kernel/apic/x2apic_uv_x.c |   15 +++++++--------
 arch/x86/kernel/bios_uv.c          |   20 ++++++++++++++------
 4 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/uv/bios.h b/arch/x86/include/asm/uv/bios.h
index 2751f30..3fbc1f3 100644
--- a/arch/x86/include/asm/uv/bios.h
+++ b/arch/x86/include/asm/uv/bios.h
@@ -18,8 +18,8 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
- *  Copyright (c) Russ Anderson
+ *  Copyright (c) 2008-2009 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Russ Anderson <rja@sgi.com>
  */
 
 #include <linux/rtc.h>
@@ -89,7 +89,7 @@ extern s64 uv_bios_call(enum uv_bios_cmd, u64, u64, u64, u64, u64);
 extern s64 uv_bios_call_irqsave(enum uv_bios_cmd, u64, u64, u64, u64, u64);
 extern s64 uv_bios_call_reentrant(enum uv_bios_cmd, u64, u64, u64, u64, u64);
 
-extern s64 uv_bios_get_sn_info(int, int *, long *, long *, long *);
+extern s64 uv_bios_get_sn_info(int, int *, long *, long *, long *, long *);
 extern s64 uv_bios_freq_base(u64, u64 *);
 extern int uv_bios_mq_watchlist_alloc(unsigned long, unsigned int,
 					unsigned long *);
@@ -104,6 +104,7 @@ extern int uv_type;
 extern long sn_partition_id;
 extern long sn_coherency_id;
 extern long sn_region_size;
+extern long system_serial_number;
 #define partition_coherence_id()	(sn_coherency_id)
 
 extern struct kobject *sgi_uv_kobj;	/* /sys/firmware/sgi_uv */
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 811bfab..7a81d9d 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -335,7 +335,8 @@ static inline unsigned long uv_read_global_mmr64(int pnode,
  */
 static inline unsigned long uv_global_gru_mmr_address(int pnode, unsigned long offset)
 {
-	return UV_GLOBAL_GRU_MMR_BASE | offset | (pnode << uv_hub_info->m_val);
+	return UV_GLOBAL_GRU_MMR_BASE | offset |
+		((unsigned long)pnode << uv_hub_info->m_val);
 }
 
 /*
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index b684bb3..d199dc3 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -5,7 +5,7 @@
  *
  * SGI UV APIC functions (note: not an Intel compatible APIC)
  *
- * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2009 Silicon Graphics, Inc. All rights reserved.
  */
 #include <linux/cpumask.h>
 #include <linux/hardirq.h>
@@ -475,7 +475,7 @@ static void uv_heartbeat(unsigned long ignored)
 
 static void __cpuinit uv_heartbeat_enable(int cpu)
 {
-	if (!uv_cpu_hub_info(cpu)->scir.enabled) {
+	while (!uv_cpu_hub_info(cpu)->scir.enabled) {
 		struct timer_list *timer = &uv_cpu_hub_info(cpu)->scir.timer;
 
 		uv_set_cpu_scir_bits(cpu, SCIR_CPU_HEARTBEAT|SCIR_CPU_ACTIVITY);
@@ -483,11 +483,10 @@ static void __cpuinit uv_heartbeat_enable(int cpu)
 		timer->expires = jiffies + SCIR_CPU_HB_INTERVAL;
 		add_timer_on(timer, cpu);
 		uv_cpu_hub_info(cpu)->scir.enabled = 1;
-	}
 
-	/* check boot cpu */
-	if (!uv_cpu_hub_info(0)->scir.enabled)
-		uv_heartbeat_enable(0);
+		/* also ensure that boot cpu is enabled */
+		cpu = 0;
+	}
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -627,8 +626,8 @@ void __init uv_system_init(void)
 	}
 
 	uv_bios_init();
-	uv_bios_get_sn_info(0, &uv_type, &sn_partition_id,
-			    &sn_coherency_id, &sn_region_size);
+	uv_bios_get_sn_info(0, &uv_type, &sn_partition_id, &sn_coherency_id,
+			    &sn_region_size, &system_serial_number);
 	uv_rtc_init();
 
 	for_each_present_cpu(cpu) {
diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/kernel/bios_uv.c
index b0206a2..c918eba 100644
--- a/arch/x86/kernel/bios_uv.c
+++ b/arch/x86/kernel/bios_uv.c
@@ -15,8 +15,8 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
- *  Copyright (c) Russ Anderson
+ *  Copyright (c) 2008-2009 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Russ Anderson <rja@sgi.com>
  */
 
 #include <linux/efi.h>
@@ -30,6 +30,7 @@ static struct uv_systab uv_systab;
 s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
 {
 	struct uv_systab *tab = &uv_systab;
+	s64 ret;
 
 	if (!tab->function)
 		/*
@@ -37,9 +38,11 @@ s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
 		 */
 		return BIOS_STATUS_UNIMPLEMENTED;
 
-	return efi_call6((void *)__va(tab->function),
-					(u64)which, a1, a2, a3, a4, a5);
+	ret = efi_call6((void *)__va(tab->function), (u64)which,
+			a1, a2, a3, a4, a5);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(uv_bios_call);
 
 s64 uv_bios_call_irqsave(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
 					u64 a4, u64 a5)
@@ -73,11 +76,14 @@ long sn_coherency_id;
 EXPORT_SYMBOL_GPL(sn_coherency_id);
 long sn_region_size;
 EXPORT_SYMBOL_GPL(sn_region_size);
+long system_serial_number;
+EXPORT_SYMBOL_GPL(system_serial_number);
 int uv_type;
+EXPORT_SYMBOL_GPL(uv_type);
 
 
 s64 uv_bios_get_sn_info(int fc, int *uvtype, long *partid, long *coher,
-		long *region)
+		long *region, long *ssn)
 {
 	s64 ret;
 	u64 v0, v1;
@@ -97,8 +103,11 @@ s64 uv_bios_get_sn_info(int fc, int *uvtype, long *partid, long *coher,
 		*coher = part.coherence_id;
 	if (region)
 		*region = part.region_size;
+	if (ssn)
+		*ssn = v1;
 	return ret;
 }
+EXPORT_SYMBOL_GPL(uv_bios_get_sn_info);
 
 int
 uv_bios_mq_watchlist_alloc(unsigned long addr, unsigned int mq_size,
@@ -185,4 +194,3 @@ void uv_bios_init(void)
 
 void uv_bios_init(void) { }
 #endif
-
