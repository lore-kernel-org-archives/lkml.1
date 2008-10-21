Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYJUVXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYJUVXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYJUVW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:22:56 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55356 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752047AbYJUVWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:22:55 -0400
Date: Tue, 21 Oct 2008 16:22:54 -0500
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] sgi-xp: define xp_expand_memprotect() and xp_restrict_memprotect()
Message-ID: <20081021212254.GC14386@sgi.com>
References: <20081021212054.GB14386@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021212054.GB14386@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define xp_expand_memprotect() and xp_restrict_memprotect() so they can be
tailered to the hardware they are run on.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/sgi-xp/xp.h      |    7 ++--
 drivers/misc/sgi-xp/xp_main.c |    7 ++++
 drivers/misc/sgi-xp/xp_sn2.c  |   34 +++++++++++++++++++
 drivers/misc/sgi-xp/xp_uv.c   |   66 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/sgi-xp/xpc_sn2.c |   15 ++------
 5 files changed, 117 insertions(+), 12 deletions(-)

Index: linux/drivers/misc/sgi-xp/xp_sn2.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xp_sn2.c	2008-10-09 11:14:24.000000000 -0500
+++ linux/drivers/misc/sgi-xp/xp_sn2.c	2008-10-09 13:18:36.000000000 -0500
@@ -120,6 +120,38 @@ xp_cpu_to_nasid_sn2(int cpuid)
 	return cpuid_to_nasid(cpuid);
 }
 
+static enum xp_retval
+xp_expand_memprotect_sn2(unsigned long phys_addr, unsigned long size)
+{
+	u64 nasid_array = 0;
+	int ret;
+
+	ret = sn_change_memprotect(phys_addr, size, SN_MEMPROT_ACCESS_CLASS_1,
+				   &nasid_array);
+	if (ret != 0) {
+		dev_err(xp, "sn_change_memprotect(,, "
+			"SN_MEMPROT_ACCESS_CLASS_1,) failed ret=%d\n", ret);
+		return xpSalError;
+	}
+	return xpSuccess;
+}
+
+static enum xp_retval
+xp_restrict_memprotect_sn2(unsigned long phys_addr, unsigned long size)
+{
+	u64 nasid_array = 0;
+	int ret;
+
+	ret = sn_change_memprotect(phys_addr, size, SN_MEMPROT_ACCESS_CLASS_0,
+				   &nasid_array);
+	if (ret != 0) {
+		dev_err(xp, "sn_change_memprotect(,, "
+			"SN_MEMPROT_ACCESS_CLASS_0,) failed ret=%d\n", ret);
+		return xpSalError;
+	}
+	return xpSuccess;
+}
+
 enum xp_retval
 xp_init_sn2(void)
 {
@@ -132,6 +164,8 @@ xp_init_sn2(void)
 	xp_pa = xp_pa_sn2;
 	xp_remote_memcpy = xp_remote_memcpy_sn2;
 	xp_cpu_to_nasid = xp_cpu_to_nasid_sn2;
+	xp_expand_memprotect = xp_expand_memprotect_sn2;
+	xp_restrict_memprotect = xp_restrict_memprotect_sn2;
 
 	return xp_register_nofault_code_sn2();
 }
Index: linux/drivers/misc/sgi-xp/xp_uv.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xp_uv.c	2008-10-09 11:14:24.000000000 -0500
+++ linux/drivers/misc/sgi-xp/xp_uv.c	2008-10-09 13:43:27.000000000 -0500
@@ -15,6 +15,11 @@
 
 #include <linux/device.h>
 #include <asm/uv/uv_hub.h>
+#if defined CONFIG_X86_64
+#include <asm/uv/bios.h>
+#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+#include <asm/sn/sn_sal.h>
+#endif
 #include "../sgi-gru/grukservices.h"
 #include "xp.h"
 
@@ -49,6 +54,65 @@ xp_cpu_to_nasid_uv(int cpuid)
 	return UV_PNODE_TO_NASID(uv_cpu_to_pnode(cpuid));
 }
 
+static enum xp_retval
+xp_expand_memprotect_uv(unsigned long phys_addr, unsigned long size)
+{
+	int ret;
+
+#if defined CONFIG_X86_64
+	ret = uv_bios_change_memprotect(phys_addr, size, UV_MEMPROT_ALLOW_RW);
+	if (ret != BIOS_STATUS_SUCCESS) {
+		dev_err(xp, "uv_bios_change_memprotect(,, "
+			"UV_MEMPROT_ALLOW_RW) failed, ret=%d\n", ret);
+		return xpBiosError;
+	}
+
+#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+	u64 nasid_array;
+
+	ret = sn_change_memprotect(phys_addr, size, SN_MEMPROT_ACCESS_CLASS_1,
+				   &nasid_array);
+	if (ret != 0) {
+		dev_err(xp, "sn_change_memprotect(,, "
+			"SN_MEMPROT_ACCESS_CLASS_1,) failed ret=%d\n", ret);
+		return xpSalError;
+	}
+#else
+	#error not a supported configuration
+#endif
+	return xpSuccess;
+}
+
+static enum xp_retval
+xp_restrict_memprotect_uv(unsigned long phys_addr, unsigned long size)
+{
+	int ret;
+
+#if defined CONFIG_X86_64
+	ret = uv_bios_change_memprotect(phys_addr, size,
+					UV_MEMPROT_RESTRICT_ACCESS);
+	if (ret != BIOS_STATUS_SUCCESS) {
+		dev_err(xp, "uv_bios_change_memprotect(,, "
+			"UV_MEMPROT_RESTRICT_ACCESS) failed, ret=%d\n", ret);
+		return xpBiosError;
+	}
+
+#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+	u64 nasid_array;
+
+	ret = sn_change_memprotect(phys_addr, size, SN_MEMPROT_ACCESS_CLASS_0,
+				   &nasid_array);
+	if (ret != 0) {
+		dev_err(xp, "sn_change_memprotect(,, "
+			"SN_MEMPROT_ACCESS_CLASS_0,) failed ret=%d\n", ret);
+		return xpSalError;
+	}
+#else
+	#error not a supported configuration
+#endif
+	return xpSuccess;
+}
+
 enum xp_retval
 xp_init_uv(void)
 {
@@ -61,6 +125,8 @@ xp_init_uv(void)
 	xp_pa = xp_pa_uv;
 	xp_remote_memcpy = xp_remote_memcpy_uv;
 	xp_cpu_to_nasid = xp_cpu_to_nasid_uv;
+	xp_expand_memprotect = xp_expand_memprotect_uv;
+	xp_restrict_memprotect = xp_restrict_memprotect_uv;
 
 	return xpSuccess;
 }
Index: linux/drivers/misc/sgi-xp/xp.h
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xp.h	2008-10-09 11:14:24.000000000 -0500
+++ linux/drivers/misc/sgi-xp/xp.h	2008-10-09 13:19:24.000000000 -0500
@@ -190,9 +190,10 @@ enum xp_retval {
 	xpGruSendMqError,	/* 59: gru send message queue related error */
 
 	xpBadChannelNumber,	/* 60: invalid channel number */
-	xpBadMsgType,		/* 60: invalid message type */
+	xpBadMsgType,		/* 61: invalid message type */
+	xpBiosError,		/* 62: BIOS error */
 
-	xpUnknownReason		/* 61: unknown reason - must be last in enum */
+	xpUnknownReason		/* 63: unknown reason - must be last in enum */
 };
 
 /*
@@ -341,6 +342,8 @@ extern unsigned long (*xp_pa) (void *);
 extern enum xp_retval (*xp_remote_memcpy) (unsigned long, const unsigned long,
 		       size_t);
 extern int (*xp_cpu_to_nasid) (int);
+extern enum xp_retval (*xp_expand_memprotect) (unsigned long, unsigned long);
+extern enum xp_retval (*xp_restrict_memprotect) (unsigned long, unsigned long);
 
 extern u64 xp_nofault_PIOR_target;
 extern int xp_nofault_PIOR(void *);
Index: linux/drivers/misc/sgi-xp/xp_main.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xp_main.c	2008-10-09 11:14:24.000000000 -0500
+++ linux/drivers/misc/sgi-xp/xp_main.c	2008-10-09 13:18:08.000000000 -0500
@@ -51,6 +51,13 @@ EXPORT_SYMBOL_GPL(xp_remote_memcpy);
 int (*xp_cpu_to_nasid) (int cpuid);
 EXPORT_SYMBOL_GPL(xp_cpu_to_nasid);
 
+enum xp_retval (*xp_expand_memprotect) (unsigned long phys_addr,
+					unsigned long size);
+EXPORT_SYMBOL_GPL(xp_expand_memprotect);
+enum xp_retval (*xp_restrict_memprotect) (unsigned long phys_addr,
+					  unsigned long size);
+EXPORT_SYMBOL_GPL(xp_restrict_memprotect);
+
 /*
  * xpc_registrations[] keeps track of xpc_connect()'s done by the kernel-level
  * users of XPC.
Index: linux/drivers/misc/sgi-xp/xpc_sn2.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xpc_sn2.c	2008-10-09 11:14:24.000000000 -0500
+++ linux/drivers/misc/sgi-xp/xpc_sn2.c	2008-10-09 13:20:21.000000000 -0500
@@ -553,22 +553,17 @@ static u64 xpc_prot_vec_sn2[MAX_NUMNODES
 static enum xp_retval
 xpc_allow_amo_ops_sn2(struct amo *amos_page)
 {
-	u64 nasid_array = 0;
-	int ret;
+	enum xp_retval ret = xpSuccess;
 
 	/*
 	 * On SHUB 1.1, we cannot call sn_change_memprotect() since the BIST
 	 * collides with memory operations. On those systems we call
 	 * xpc_allow_amo_ops_shub_wars_1_1_sn2() instead.
 	 */
-	if (!enable_shub_wars_1_1()) {
-		ret = sn_change_memprotect(ia64_tpa((u64)amos_page), PAGE_SIZE,
-					   SN_MEMPROT_ACCESS_CLASS_1,
-					   &nasid_array);
-		if (ret != 0)
-			return xpSalError;
-	}
-	return xpSuccess;
+	if (!enable_shub_wars_1_1())
+		ret = xp_expand_memprotect(ia64_tpa((u64)amos_page), PAGE_SIZE);
+
+	return ret;
 }
 
 /*
