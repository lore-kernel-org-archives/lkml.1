Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZLQQxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZLQQxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZLQQxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:53:30 -0500
Received: from relay3.sgi.com ([192.48.152.1]:52382 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752415AbZLQQx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:53:29 -0500
Date: Thu, 17 Dec 2009 10:53:25 -0600
From: Russ Anderson <rja@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Russ Anderson <rja@sgi.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: x86: uv: Add serial number parameter to uv_bios_get_sn_info()
Message-ID: <20091217165323.GA30774@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add system_serial_number to the information returned by
uv_bios_get_sn_info() UV BIOS call.

Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
---

This patch only effects UV systems.

 arch/x86/include/asm/uv/bios.h     |    7 ++++---
 arch/x86/kernel/apic/x2apic_uv_x.c |    6 +++---
 arch/x86/kernel/bios_uv.c          |   20 ++++++++++++++------
 3 files changed, 21 insertions(+), 12 deletions(-)

Index: linux/arch/x86/include/asm/uv/bios.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/bios.h	2009-12-16 15:59:58.000000000 -0600
+++ linux/arch/x86/include/asm/uv/bios.h	2009-12-16 16:16:35.000000000 -0600
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
@@ -89,7 +89,7 @@ extern s64 uv_bios_call(enum uv_bios_cmd
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
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-12-16 15:59:58.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-12-16 16:01:13.000000000 -0600
@@ -5,7 +5,7 @@
  *
  * SGI UV APIC functions (note: not an Intel compatible APIC)
  *
- * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2009 Silicon Graphics, Inc. All rights reserved.
  */
 #include <linux/cpumask.h>
 #include <linux/hardirq.h>
@@ -627,8 +627,8 @@ void __init uv_system_init(void)
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
--- linux.orig/arch/x86/kernel/bios_uv.c	2009-12-16 15:59:58.000000000 -0600
+++ linux/arch/x86/kernel/bios_uv.c	2009-12-16 16:19:11.000000000 -0600
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
@@ -97,8 +103,11 @@ s64 uv_bios_get_sn_info(int fc, int *uvt
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
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
