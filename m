Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbYI2WDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbYI2WDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYI2WCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:02:55 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48017 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751337AbYI2WCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:02:54 -0400
Date: Mon, 29 Sep 2008 17:02:53 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 2/4] Add UV bios call infrastructure
Message-ID: <20080929220253.GD108640@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/4] Add UV bios call infrastructure

Add the UV wrapper code to call OEM runtime service.

Signed-off-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/bios_uv.c |   73 ++++++++++++++++++++++++++++++++--------------
 include/asm-x86/uv/bios.h |   62 ++++++++++++++++++---------------------
 2 files changed, 82 insertions(+), 53 deletions(-)

Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2008-09-29 16:51:20.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2008-09-29 16:53:07.000000000 -0500
@@ -1,8 +1,6 @@
 /*
  * BIOS run time interface routines.
  *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
- *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
  *  the Free Software Foundation; either version 2 of the License, or
@@ -16,33 +14,66 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Russ Anderson
  */
 
+#include <linux/efi.h>
+#include <asm/efi.h>
+#include <linux/io.h>
 #include <asm/uv/bios.h>
 
-const char *
-x86_bios_strerror(long status)
+#ifdef CONFIG_EFI
+
+s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
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
+	if (!virt_addr_valid(efi.systab->runtime->oem))
+		/*
+		 * BIOS does not support oem runtime function.
+		 */
+		return BIOS_STATUS_UNIMPLEMENTED;
+
+	return efi_call_virt6(oem, which, a1, a2, a3, a4, a5);
 }
 
-long
-x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
-		   unsigned long *drift_info)
+#else
+s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
+{
+	return BIOS_STATUS_UNIMPLEMENTED;
+}
+#endif /* CONFIG_EFI */
+
+s64 uv_bios_call_irqsave(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
+					u64 a4, u64 a5)
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
+s64 uv_bios_call_reentrant(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
+					u64 a4, u64 a5)
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
+	return uv_bios_call(UV_BIOS_FREQ_BASE, clock_type,
+				(u64)ticks_per_second, 0, 0, 0);
 }
 EXPORT_SYMBOL_GPL(x86_bios_freq_base);
Index: linux/include/asm-x86/uv/bios.h
===================================================================
--- linux.orig/include/asm-x86/uv/bios.h	2008-09-29 16:51:20.000000000 -0500
+++ linux/include/asm-x86/uv/bios.h	2008-09-29 16:53:07.000000000 -0500
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
@@ -19,11 +17,33 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Russ Anderson
  */
 
 #include <linux/rtc.h>
 
-#define BIOS_FREQ_BASE			0x01000001
+/*
+ * Values for the BIOS calls.  It is passed as the first * argument in the
+ * BIOS call.  Passing any other value in the first argument will result
+ * in a BIOS_STATUS_UNIMPLEMENTED return status.
+ */
+enum uv_bios_cmd {
+	UV_BIOS_COMMON,
+	UV_BIOS_GET_SN_INFO,
+	UV_BIOS_FREQ_BASE
+};
+
+/*
+ * Status values returned from a BIOS call.
+ */
+enum {
+	BIOS_STATUS_SUCCESS		=  0,
+	BIOS_STATUS_UNIMPLEMENTED	= -ENOSYS,
+	BIOS_STATUS_EINVAL		= -EINVAL,
+	BIOS_STATUS_UNAVAIL		= -EBUSY
+};
 
 enum {
 	BIOS_FREQ_BASE_PLATFORM = 0,
@@ -31,38 +51,16 @@ enum {
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
-enum {
-	BIOS_STATUS_SUCCESS		=  0,
-	BIOS_STATUS_UNIMPLEMENTED	= -1,
-	BIOS_STATUS_EINVAL		= -2,
-	BIOS_STATUS_ERROR		= -3
-};
+/*
+ * bios calls have 6 parameters
+ */
+extern s64 uv_bios_call(enum uv_bios_cmd, u64, u64, u64, u64, u64);
+extern s64 uv_bios_call_irqsave(enum uv_bios_cmd, u64, u64, u64, u64, u64);
+extern s64 uv_bios_call_reentrant(enum uv_bios_cmd, u64, u64, u64, u64, u64);
 
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
-};
 
 extern long
 x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
 		   unsigned long *drift_info);
-extern const char *x86_bios_strerror(long status);
 
 #endif /* ASM_X86__UV__BIOS_H */
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
