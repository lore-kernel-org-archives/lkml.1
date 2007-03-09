Return-Path: <linux-kernel-owner+w=401wt.eu-S2992847AbXCIPQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992847AbXCIPQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992848AbXCIPQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:16:13 -0500
Received: from mail-cpk.bigfish.com ([207.46.163.10]:55812 "EHLO
	outbound4-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992847AbXCIPQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:16:12 -0500
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Fri, 9 Mar 2007 16:15:11 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4 TRY#3] optimize and simplify get_cycles_sync()
Message-ID: <20070309151511.GE13481@amd.com>
References: <20070309150825.GA13481@amd.com>
MIME-Version: 1.0
In-Reply-To: <20070309150825.GA13481@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Mar 2007 15:16:00.0890 (UTC)
 FILETIME=[D89B85A0:01C7625D]
X-WSS-ID: 69EFA5B92EG2386474-01-01
Content-Type: multipart/mixed;
 boundary="osDK9TLjxFScVI/L"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--osDK9TLjxFScVI/L
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Joerg Roedel <joerg.roedel@amd.com>

This patch simplifies the get_cycles_sync() function by removing
the #ifdefs from it. Further it introduces an optimization for AMD
processors. There the RDTSCP instruction is used instead of CPUID;RDTSC
which is helpfull if the kernel runs as a KVM guest. Running as a guest
makes CPUID very expensive because it causes an intercept of the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--osDK9TLjxFScVI/L
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=optimized-get_cycles_sync.patch
Content-Transfer-Encoding: 7bit

diff --git a/include/asm-i386/cpufeature.h b/include/asm-i386/cpufeature.h
index 3f92b94..a9f1f01 100644
--- a/include/asm-i386/cpufeature.h
+++ b/include/asm-i386/cpufeature.h
@@ -49,6 +49,7 @@
 #define X86_FEATURE_MP		(1*32+19) /* MP Capable. */
 #define X86_FEATURE_NX		(1*32+20) /* Execute Disable */
 #define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
+#define X86_FEATURE_RDTSCP      (1*32+27) /* RDTSCP */
 #define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
 #define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
 #define X86_FEATURE_3DNOW	(1*32+31) /* 3DNow! */
diff --git a/include/asm-i386/tsc.h b/include/asm-i386/tsc.h
index 84016ff..0b769ad 100644
--- a/include/asm-i386/tsc.h
+++ b/include/asm-i386/tsc.h
@@ -7,6 +7,7 @@
 #define _ASM_i386_TSC_H
 
 #include <asm/processor.h>
+#include <asm/alternative.h>
 
 /*
  * Standard way to access the cycle counter.
@@ -34,22 +35,16 @@ static inline cycles_t get_cycles(void)
 /* Like get_cycles, but make sure the CPU is synchronized. */
 static __always_inline cycles_t get_cycles_sync(void)
 {
-	unsigned long long ret;
-#ifdef X86_FEATURE_SYNC_RDTSC
-	unsigned eax;
+	unsigned int a, d;
 
-	/*
-	 * Don't do an additional sync on CPUs where we know
-	 * RDTSC is already synchronous:
-	 */
-	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
-			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
-#else
-	sync_core();
-#endif
-	rdtscll(ret);
+#define RDTSCP ".byte 0x0f, 0x01, 0xf9"
+	alternative_io_two("cpuid\nrdtsc",
+			   "rdtsc", X86_FEATURE_SYNC_RDTSC,
+			   ".byte 0x0f, 0x01, 0xf9", X86_FEATURE_RDTSCP,
+			   ASM_OUTPUT2("=a" (a), "=d" (d)),
+			   "0" (1) : "ecx", "memory");
 
-	return ret;
+	return ((unsigned long long)a) | (((unsigned long long)d)<<32);
 }
 
 extern void tsc_init(void);

--osDK9TLjxFScVI/L--


