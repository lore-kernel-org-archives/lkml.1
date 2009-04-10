Return-Path: <linux-kernel-owner+w=401wt.eu-S935095AbZDJWWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935095AbZDJWWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 18:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbZDJWWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 18:22:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:29381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbZDJWW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 18:22:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,169,1239001200"; 
   d="scan'208";a="446948641"
Subject: [patch] x86: add linux kernel support for YMM state
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: hpa@linux.intel.com, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 10 Apr 2009 15:21:24 -0700
Message-Id: <1239402084.27006.8057.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: add linux kernel support for YMM state

Intel Advanced Vector Extensions (AVX) introduce 256-bit vector processing
capability. More about AVX at http://software.intel.com/sites/avx

Add OS support for YMM state management using xsave/xrstor infrastructure
to support AVX.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/include/asm/processor.h
===================================================================
--- tip.orig/arch/x86/include/asm/processor.h
+++ tip/arch/x86/include/asm/processor.h
@@ -352,6 +352,11 @@ struct i387_soft_struct {
 	u32			entry_eip;
 };
 
+struct ymmh_struct {
+	/* 16 * 16 bytes for each YMMH-reg = 256 bytes */
+	u32 ymmh_space[64];
+};
+
 struct xsave_hdr_struct {
 	u64 xstate_bv;
 	u64 reserved1[2];
@@ -361,6 +366,7 @@ struct xsave_hdr_struct {
 struct xsave_struct {
 	struct i387_fxsave_struct i387;
 	struct xsave_hdr_struct xsave_hdr;
+	struct ymmh_struct ymmh;
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
 
Index: tip/arch/x86/include/asm/sigcontext.h
===================================================================
--- tip.orig/arch/x86/include/asm/sigcontext.h
+++ tip/arch/x86/include/asm/sigcontext.h
@@ -269,6 +269,11 @@ struct _xsave_hdr {
 	__u64 reserved2[5];
 };
 
+struct _ymmh_state {
+	/* 16 * 16 bytes for each YMMH-reg */
+	__u32 ymmh_space[64];
+};
+
 /*
  * Extended state pointed by the fpstate pointer in the sigcontext.
  * In addition to the fpstate, information encoded in the xstate_hdr
@@ -278,6 +283,7 @@ struct _xsave_hdr {
 struct _xstate {
 	struct _fpstate fpstate;
 	struct _xsave_hdr xstate_hdr;
+	struct _ymmh_state ymmh;
 	/* new processor state extensions go here */
 };
 
Index: tip/arch/x86/include/asm/xsave.h
===================================================================
--- tip.orig/arch/x86/include/asm/xsave.h
+++ tip/arch/x86/include/asm/xsave.h
@@ -7,6 +7,7 @@
 
 #define XSTATE_FP	0x1
 #define XSTATE_SSE	0x2
+#define XSTATE_YMM	0x4
 
 #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
 
@@ -15,7 +16,7 @@
 /*
  * These are the features that the OS can handle currently.
  */
-#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE)
+#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
 
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
Index: tip/arch/x86/kernel/xsave.c
===================================================================
--- tip.orig/arch/x86/kernel/xsave.c
+++ tip/arch/x86/kernel/xsave.c
@@ -326,7 +326,7 @@ void __ref xsave_cntxt_init(void)
 	}
 
 	/*
-	 * for now OS knows only about FP/SSE
+	 * Support only the state known to OS.
 	 */
 	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
 	xsave_init();


