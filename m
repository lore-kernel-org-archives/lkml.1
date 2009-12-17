Return-Path: <linux-kernel-owner+w=401wt.eu-S965522AbZLQTtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965522AbZLQTtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965514AbZLQTtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:49:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:42262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965511AbZLQTtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:49:10 -0500
Date: Thu, 17 Dec 2009 19:48:38 GMT
From: tip-bot for Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, rja@sgi.com, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, rja@sgi.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com, tglx@linutronix.de
In-Reply-To: <20091217165323.GA30774@sgi.com>
References: <20091217165323.GA30774@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, uv: Add serial number parameter to uv_bios_get_sn_info()
Message-ID: <tip-b76365a18f7593c9df32a74bf2b4a39741b67bc6@git.kernel.org>
Git-Commit-ID: b76365a18f7593c9df32a74bf2b4a39741b67bc6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b76365a18f7593c9df32a74bf2b4a39741b67bc6
Gitweb:     http://git.kernel.org/tip/b76365a18f7593c9df32a74bf2b4a39741b67bc6
Author:     Russ Anderson <rja@sgi.com>
AuthorDate: Thu, 17 Dec 2009 10:53:25 -0600
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 17 Dec 2009 11:33:51 -0800

x86, uv: Add serial number parameter to uv_bios_get_sn_info()

Add system_serial_number to the information returned by
uv_bios_get_sn_info() UV BIOS call.

Signed-off-by: Russ Anderson <rja@sgi.com>
LKML-Reference: <20091217165323.GA30774@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/uv/bios.h     |    7 ++++---
 arch/x86/kernel/apic/x2apic_uv_x.c |    6 +++---
 arch/x86/kernel/bios_uv.c          |   20 ++++++++++++++------
 3 files changed, 21 insertions(+), 12 deletions(-)

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
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index b684bb3..af5d103 100644
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
@@ -627,8 +627,8 @@ void __init uv_system_init(void)
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
