Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbXBSTL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbXBSTL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 14:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932500AbXBSTL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 14:11:56 -0500
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:33163 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932495AbXBSTLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 14:11:50 -0500
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Mon, 19 Feb 2007 20:11:39 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>
Subject: [PATCH 3/3] optimize get_cycles_sync for Linux as KVM guest
Message-ID: <20070219191139.GD6083@amd.com>
References: <20070219190132.GA6083@amd.com>
MIME-Version: 1.0
In-Reply-To: <20070219190132.GA6083@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Feb 2007 19:11:41.0211 (UTC)
 FILETIME=[C975C6B0:01C75459]
X-WSS-ID: 69C729FA2X0967852-01-01
Content-Type: multipart/mixed;
 boundary=V88s5gaDVPzZ0KCq
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--V88s5gaDVPzZ0KCq
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Joerg Roedel <joerg.roedel@amd.com>

This patch modifies the get_cycles_sync() function on i386 and x86_64 to
use the RDTSCP (if it is available) instruction to synchronize with the
CPU core and not CPUID. This is especially usefull when running Linux as
a KVM guest because CPUID is intercepted and will cause a VMEXIT there.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--V88s5gaDVPzZ0KCq
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=get_cycles_sync-optimization.patch
Content-Transfer-Encoding: 7bit

diff --git a/include/asm-i386/cpufeature.h b/include/asm-i386/cpufeature.h
index 3f92b94..7275e41 100644
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
diff --git a/include/asm-x86_64/tsc.h b/include/asm-x86_64/tsc.h
index 9a0a368..7db952d 100644
--- a/include/asm-x86_64/tsc.h
+++ b/include/asm-x86_64/tsc.h
@@ -34,22 +34,28 @@ static inline cycles_t get_cycles(void)
 /* Like get_cycles, but make sure the CPU is synchronized. */
 static __always_inline cycles_t get_cycles_sync(void)
 {
-	unsigned long long ret;
-#ifdef X86_FEATURE_SYNC_RDTSC
+	unsigned int a, d;
 	unsigned eax;
 
+#ifdef X86_FEATURE_SYNC_RDTSC
 	/*
 	 * Don't do an additional sync on CPUs where we know
 	 * RDTSC is already synchronous:
 	 */
 	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
 			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
+	/* We use RDTSCP if it is available, no extra CPUID required then */
+	alternative_add_one(ASM_NOP2, X86_FEATURE_RDTSCP);
 #else
-	sync_core();
+	/* no CPUID required if we use RDTSCP */
+	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_RDTSCP,
+			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
 #endif
-	rdtscll(ret);
 
-	return ret;
+	alternative_io("rdtsc\n" ASM_NOP1, "rdtscp", X86_FEATURE_RDTSCP,
+			ALTERNATIVE_OUTPUT2("=a" (a), "=d" (d)), "0" (1) : "ecx","memory");
+
+	return ((unsigned long long)a) | ((unsigned long long)d) << 32;
 }
 
 extern void tsc_init(void);

--V88s5gaDVPzZ0KCq--


