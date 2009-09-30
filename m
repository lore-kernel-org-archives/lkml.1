Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbZI3VEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbZI3VEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbZI3VEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:04:33 -0400
Received: from relay1.sgi.com ([192.48.179.29]:32935 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752972AbZI3VEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:04:32 -0400
Date: Wed, 30 Sep 2009 16:04:34 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, hpa@zytor.com, Cliff Wickman <cpw@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 1/2] x86: UV bios calls to support UV hardware performance counter and topology access
Message-ID: <20090930210433.GB12090@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add UV bios calls to support UV hardware performance counter and 
topology access.

Signed-off-by: Russ Anderson <rja@sgi.com>
Acked-by: Cliff Wickman <cpw@sgi.com>
---

This patch only effects UV systems.

 arch/x86/include/asm/uv/bios.h     |   17 ++++++++--
 arch/x86/kernel/apic/x2apic_uv_x.c |    6 +--
 arch/x86/kernel/bios_uv.c          |   59 +++++++++++++++++++++++++++++++++----
 3 files changed, 69 insertions(+), 13 deletions(-)

Index: linux/arch/x86/include/asm/uv/bios.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/bios.h	2009-09-26 12:19:21.000000000 -0500
+++ linux/arch/x86/include/asm/uv/bios.h	2009-09-29 23:03:17.000000000 -0500
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
@@ -36,7 +36,11 @@ enum uv_bios_cmd {
 	UV_BIOS_WATCHLIST_ALLOC,
 	UV_BIOS_WATCHLIST_FREE,
 	UV_BIOS_MEMPROTECT,
-	UV_BIOS_GET_PARTITION_ADDR
+	UV_BIOS_GET_PARTITION_ADDR,
+	UV_BIOS_HWPERF,
+	UV_BIOS_GET_PCI_TOPOLOGY,
+	UV_BIOS_GET_PCIBUS_INFO,
+	UV_BIOS_GET_GEOINFO
 };
 
 /*
@@ -98,13 +102,17 @@ extern s64 uv_bios_call(enum uv_bios_cmd
 extern s64 uv_bios_call_irqsave(enum uv_bios_cmd, u64, u64, u64, u64, u64);
 extern s64 uv_bios_call_reentrant(enum uv_bios_cmd, u64, u64, u64, u64, u64);
 
-extern s64 uv_bios_get_sn_info(int, int *, long *, long *, long *);
+extern s64 uv_bios_get_sn_info(int, int *, long *, long *, long *, long *);
 extern s64 uv_bios_freq_base(u64, u64 *);
 extern int uv_bios_mq_watchlist_alloc(int, unsigned long, unsigned int,
 					unsigned long *);
 extern int uv_bios_mq_watchlist_free(int, int);
 extern s64 uv_bios_change_memprotect(u64, u64, enum uv_memprotect);
 extern s64 uv_bios_reserved_page_pa(u64, u64 *, u64 *, u64 *);
+extern s64 uv_bios_hwperf(u64, u64 , u64 , u64, u64 *, int *);
+extern s64 uv_bios_get_pci_topology(u64, u64);
+extern s64 uv_bios_get_hubdev_info(u64, u64);
+extern s64 uv_bios_get_geoinfo(u64, u64, u64);
 
 extern void uv_bios_init(void);
 
@@ -113,6 +121,7 @@ extern int uv_type;
 extern long sn_partition_id;
 extern long sn_coherency_id;
 extern long sn_region_size;
+extern long system_serial_number;
 #define partition_coherence_id()	(sn_coherency_id)
 
 extern struct kobject *sgi_uv_kobj;	/* /sys/firmware/sgi_uv */
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-09-26 12:30:45.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-09-30 15:22:39.000000000 -0500
@@ -5,7 +5,7 @@
  *
  * SGI UV APIC functions (note: not an Intel compatible APIC)
  *
- * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2009 Silicon Graphics, Inc. All rights reserved.
  */
 #include <linux/cpumask.h>
 #include <linux/hardirq.h>
@@ -619,8 +619,8 @@ void __init uv_system_init(void)
 	}
 
 	uv_bios_init();
-	uv_bios_get_sn_info(0, &uv_type, &sn_partition_id,
-			    &sn_coherency_id, &sn_region_size);
+	uv_bios_get_sn_info(0, &uv_type, &sn_partition_id, &sn_coherency_id,
+			    &sn_region_size, &system_serial_number);
 	uv_rtc_init();
 
 	for_each_present_cpu(cpu) {
Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2009-09-26 12:19:21.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2009-09-29 23:09:28.000000000 -0500
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
@@ -37,9 +38,11 @@ s64 uv_bios_call(enum uv_bios_cmd which,
 		 */
 		return BIOS_STATUS_UNIMPLEMENTED;
 
-	return efi_call6((void *)__va(tab->function),
-					(u64)which, a1, a2, a3, a4, a5);
+	ret = efi_call6((void *)__va(tab->function), (u64)which,
+			a1, a2, a3, a4, a5);
+	return ret;
 }
+EXPORT_SYMBOL(uv_bios_call);
 
 s64 uv_bios_call_irqsave(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
 					u64 a4, u64 a5)
@@ -73,11 +76,13 @@ long sn_coherency_id;
 EXPORT_SYMBOL_GPL(sn_coherency_id);
 long sn_region_size;
 EXPORT_SYMBOL_GPL(sn_region_size);
+long system_serial_number;
+EXPORT_SYMBOL_GPL(system_serial_number);
 int uv_type;
 
 
 s64 uv_bios_get_sn_info(int fc, int *uvtype, long *partid, long *coher,
-		long *region)
+		long *region, long *ssn)
 {
 	s64 ret;
 	u64 v0, v1;
@@ -97,6 +102,8 @@ s64 uv_bios_get_sn_info(int fc, int *uvt
 		*coher = part.coherence_id;
 	if (region)
 		*region = part.region_size;
+	if (ssn)
+		*ssn = v1;
 	return ret;
 }
 
@@ -158,6 +165,47 @@ s64 uv_bios_freq_base(u64 clock_type, u6
 }
 EXPORT_SYMBOL_GPL(uv_bios_freq_base);
 
+s64 uv_bios_hwperf(u64 nasid, u64 opcode, u64 arg0, u64 arg1,
+		   u64 *ptdata, int *v0)
+{
+	s64 ret;
+
+	ret = uv_bios_call(UV_BIOS_HWPERF, nasid, opcode,
+			   arg0, arg1, (u64)ptdata);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(uv_bios_hwperf);
+
+s64 uv_bios_get_pci_topology(u64 buf, u64 len)
+{
+	s64 ret;
+
+	ret = uv_bios_call(UV_BIOS_GET_PCI_TOPOLOGY, buf, len, 0, 0, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(uv_bios_get_pci_topology);
+
+s64 uv_bios_get_geoinfo(u64 nasid, u64 buf, u64 len)
+{
+	s64 ret;
+
+	ret = uv_bios_call(UV_BIOS_GET_GEOINFO, nasid, buf, len, 0, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(uv_bios_get_geoinfo);
+
+s64 uv_bios_get_hubdev_info(u64 nasid, u64 buf)
+{
+	s64 ret;
+
+	ret = uv_bios_call(UV_BIOS_GET_PCIBUS_INFO, nasid, buf, 0, 0, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(uv_bios_get_hubdev_info);
 
 #ifdef CONFIG_EFI
 void uv_bios_init(void)
@@ -189,4 +237,3 @@ void uv_bios_init(void)
 
 void uv_bios_init(void) { }
 #endif
-
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
