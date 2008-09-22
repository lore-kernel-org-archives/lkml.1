Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbYIVWSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbYIVWSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYIVWSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:18:15 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38170 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753670AbYIVWSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:18:14 -0400
Date: Mon, 22 Sep 2008 17:18:13 -0500
From: Russ Anderson <rja@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 2/4] x86: Add UV bios call infrastructure
Message-ID: <20080922221810.GA65429@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080922210928.GE222374@sgi.com> <48D81705.1030806@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <48D81705.1030806@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 22, 2008 at 03:07:01PM -0700, H. Peter Anvin wrote:
> Russ Anderson wrote:
> >+	if (tab->function == (unsigned long)NULL)
> 
> Preferred style is:
> 
> 	if (!tab->function)
> 
> 	-hpa

Attached is an updated patch.


-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=uv_bios_common

[PATCH 2/4] Add UV bios call infrastructure

Add the EFI callback function and associated wrapper code.
Initialize SAL system table entry info at boot time.

Signed-off-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/bios_uv.c        |  106 +++++++++++++++++++++++++++++++--------
 arch/x86/kernel/genx2apic_uv_x.c |    1 
 include/asm-x86/uv/bios.h        |   58 +++++++++++----------
 3 files changed, 117 insertions(+), 48 deletions(-)

Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2008-09-22 17:14:08.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2008-09-22 17:14:39.000000000 -0500
@@ -1,8 +1,6 @@
 /*
  * BIOS run time interface routines.
  *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
- *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
  *  the Free Software Foundation; either version 2 of the License, or
@@ -16,33 +14,99 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Russ Anderson
  */
 
+#include <linux/efi.h>
+#include <linux/io.h>
 #include <asm/uv/bios.h>
 
-const char *
-x86_bios_strerror(long status)
+struct sal_systab sal_systab;
+
+s64 uv_bios_call(int which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
 {
-	const char *str;
-	switch (status) {
-	case  0: str = "Call completed without error";	break;
-	case -1: str = "Not implemented";		break;
-	case -2: str = "Invalid argument";		break;
-	case -3: str = "Call completed with error";	break;
-	default: str = "Unknown BIOS status code";	break;
-	}
-	return str;
+	struct sal_systab *tab = &sal_systab;
+
+	if (!tab->function)
+		/*
+		 * BIOS does not support SAL systab
+		 */
+		return BIOS_STATUS_UNIMPLEMENTED;
+
+	return efi_call6((void *)__va(tab->function),
+					which, a1, a2, a3, a4, a5);
 }
 
-long
-x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
-		   unsigned long *drift_info)
+s64 uv_bios_call_irqsave(int which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
 {
-	struct uv_bios_retval isrv;
+	unsigned long bios_flags;
+	s64 ret;
 
-	BIOS_CALL(isrv, BIOS_FREQ_BASE, which, 0, 0, 0, 0, 0, 0);
-	*ticks_per_second = isrv.v0;
-	*drift_info = isrv.v1;
-	return isrv.status;
+	local_irq_save(bios_flags);
+	ret = uv_bios_call(which, a1, a2, a3, a4, a5);
+	local_irq_restore(bios_flags);
+
+	return ret;
+}
+
+s64 uv_bios_call_reentrant(int which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
+{
+	s64 ret;
+
+	preempt_disable();
+	ret = uv_bios_call(which, a1, a2, a3, a4, a5);
+	preempt_enable();
+
+	return ret;
+}
+
+long
+x86_bios_freq_base(unsigned long clock_type, unsigned long *ticks_per_second,
+					unsigned long *drift_info)
+{
+	return uv_bios_call(BIOS_FREQ_BASE, clock_type,
+				(u64)ticks_per_second, 0, 0, 0);
 }
 EXPORT_SYMBOL_GPL(x86_bios_freq_base);
+
+
+#ifdef CONFIG_EFI
+void uv_bios_init(void)
+{
+	struct sal_systab *tab;
+
+	if ((efi.sal_systab == EFI_INVALID_TABLE_ADDR) ||
+	    (efi.sal_systab == (unsigned long)NULL)) {
+		printk(KERN_CRIT "No EFI SAL System Table.\n");
+		sal_systab.function = (unsigned long)NULL;
+		return;
+	}
+
+	tab = (struct sal_systab *)ioremap(efi.sal_systab,
+					sizeof(struct sal_systab));
+	if (strncmp(tab->signature, "SST_", 4) != 0)
+		printk(KERN_ERR "bad signature in SAL system table!");
+
+	/*
+	 * Copy table to permanent spot for later use.
+	 */
+	memcpy(&sal_systab, tab, sizeof(struct sal_systab));
+	iounmap(tab);
+
+	printk(KERN_INFO "EFI SAL System Table Revision %d\n", tab->revision);
+}
+#else	/* !CONFIG_EFI */
+/*
+ * IF EFI is not configured, have the EFI calls return unimplemented.
+ */
+u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
+			u64 arg4, u64 arg5, u64 arg6)
+{
+	return  BIOS_STATUS_UNIMPLEMENTED;
+}
+
+void uv_bios_init(void) { }
+#endif
+
Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-09-22 17:14:08.000000000 -0500
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-09-22 17:14:18.000000000 -0500
@@ -413,6 +413,7 @@ void __init uv_system_init(void)
 	gnode_upper = (((unsigned long)node_id.s.node_id) &
 		       ~((1 << n_val) - 1)) << m_val;
 
+	uv_bios_init();
 	uv_rtc_init();
 
 	for_each_present_cpu(cpu) {
Index: linux/include/asm-x86/uv/bios.h
===================================================================
--- linux.orig/include/asm-x86/uv/bios.h	2008-09-22 17:14:08.000000000 -0500
+++ linux/include/asm-x86/uv/bios.h	2008-09-22 17:14:18.000000000 -0500
@@ -2,9 +2,7 @@
 #define ASM_X86__UV__BIOS_H
 
 /*
- * BIOS layer definitions.
- *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ * UV BIOS layer definitions.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -19,6 +17,9 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Russ Anderson
  */
 
 #include <linux/rtc.h>
@@ -31,38 +32,41 @@ enum {
 	BIOS_FREQ_BASE_REALTIME_CLOCK = 2
 };
 
-# define BIOS_CALL(result, a0, a1, a2, a3, a4, a5, a6, a7)		\
-	do {								\
-		/* XXX - the real call goes here */			\
-		result.status = BIOS_STATUS_UNIMPLEMENTED;		\
-		isrv.v0 = 0;						\
-		isrv.v1 = 0;						\
-	} while (0)
-
+/*
+ * Status values returned from a BIOS call.
+ */
 enum {
 	BIOS_STATUS_SUCCESS		=  0,
-	BIOS_STATUS_UNIMPLEMENTED	= -1,
-	BIOS_STATUS_EINVAL		= -2,
-	BIOS_STATUS_ERROR		= -3
+	BIOS_STATUS_UNIMPLEMENTED	= -ENOSYS,
+	BIOS_STATUS_EINVAL		= -EINVAL,
+	BIOS_STATUS_UNAVAIL		= -EBUSY
 };
 
-struct uv_bios_retval {
-	/*
-	 * A zero status value indicates call completed without error.
-	 * A negative status value indicates reason of call failure.
-	 * A positive status value indicates success but an
-	 * informational value should be printed (e.g., "reboot for
-	 * change to take effect").
-	 */
-	s64 status;
-	u64 v0;
-	u64 v1;
-	u64 v2;
+/*
+ * The SAL system table describes specific firmware
+ * capabilities available to the Linux kernel at runtime.
+ */
+struct sal_systab {
+	char signature[4];	/* must be "SST_" */
+	u32 revision;		/* distinguish different firmware revs */
+	u64 function; 		/* BIOS runtime callback function ptr */
 };
 
+/*
+ * bios calls have 6 parameters
+ */
+extern s64 uv_bios_call(int, u64, u64, u64, u64, u64);
+extern s64 uv_bios_call_irqsave(int, u64, u64, u64, u64, u64);
+extern s64 uv_bios_call_reentrant(int which, u64, u64, u64, u64, u64);
+
+extern void uv_bios_init(void);
+
 extern long
 x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
 		   unsigned long *drift_info);
-extern const char *x86_bios_strerror(long status);
+
+#ifndef CONFIG_EFI
+extern u64 efi_call6(void *, u64, u64, u64, u64, u64, u64);
+#endif
 
 #endif /* ASM_X86__UV__BIOS_H */

--mP3DRpeJDSE+ciuQ--
