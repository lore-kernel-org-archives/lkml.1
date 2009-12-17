Return-Path: <linux-kernel-owner+w=401wt.eu-S933579AbZLQA1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579AbZLQA1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762939AbZLQA1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:27:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:40856 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762873AbZLQA1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:27:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,408,1257148800"; 
   d="scan'208";a="756926140"
Subject: [patch] x86, cpuid: add "volatile" to asm in native_cpuid()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 16 Dec 2009 16:25:42 -0800
Message-Id: <1261009542.2745.55.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xsave_cntxt_init() does something like:

	cpuid(0xd, ..);	// find out what features FP/SSE/.. etc are supported

	xsetbv();	// enable the features known to OS

	cpuid(0xd, ..);	// find out the size of the context for features enabled

Depending on what features get enabled in xsetbv(), value of the
cpuid.eax=0xd.ecx=0.ebx changes correspondingly (representing the
size of the context that is enabled).

As we don't have volatile keyword for native_cpuid(), gcc 4.1.2
optimizes away the second cpuid and the kernel continues to use
the cpuid information obtained before xsetbv(), ultimately leading to kernel
crash on processors supporting more state than the legacy FP/SSE.

Add "volatile" for native_cpuid().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org
---
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 6f8ec1c..fc801ba 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -181,7 +181,7 @@ static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 				unsigned int *ecx, unsigned int *edx)
 {
 	/* ecx is often an input as well as an output. */
-	asm("cpuid"
+	asm volatile("cpuid"
 	    : "=a" (*eax),
 	      "=b" (*ebx),
 	      "=c" (*ecx),


