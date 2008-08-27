Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYH0V5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYH0V5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYH0V5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:57:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:45372 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbYH0V5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:57:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,282,1217833200"; 
   d="scan'208";a="432753946"
Date: Wed, 27 Aug 2008 14:57:36 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com
Subject: [patch] xsave: restore xcr0 during resume
Message-ID: <20080827215736.GI1152@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing XCR0(XFEATURE_ENABLED_MASK) restore during resume.

Reported-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index d3e083d..274d060 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -11,6 +11,7 @@
 #include <linux/suspend.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/xcr.h>
 
 static struct saved_context saved_context;
 
@@ -126,6 +127,12 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	if (boot_cpu_has(X86_FEATURE_SEP))
 		enable_sep_cpu();
 
+	/*
+	 * restore XCR0 for xsave capable cpu's.
+	 */
+	if (cpu_has_xsave)
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
+
 	fix_processor_context();
 	do_fpu_end();
 	mtrr_ap_init();
diff --git a/arch/x86/power/cpu_64.c b/arch/x86/power/cpu_64.c
index 66bdfb5..e3b6cf7 100644
--- a/arch/x86/power/cpu_64.c
+++ b/arch/x86/power/cpu_64.c
@@ -14,6 +14,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
+#include <asm/xcr.h>
 
 static void fix_processor_context(void);
 
@@ -122,6 +123,12 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	wrmsrl(MSR_GS_BASE, ctxt->gs_base);
 	wrmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
 
+	/*
+	 * restore XCR0 for xsave capable cpu's.
+	 */
+	if (cpu_has_xsave)
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
+
 	fix_processor_context();
 
 	do_fpu_end();
