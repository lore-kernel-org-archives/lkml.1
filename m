Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbXB1O0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbXB1O0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932773AbXB1O0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:26:31 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:33272 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932566AbXB1O0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:26:30 -0500
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Wed, 28 Feb 2007 15:25:54 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] optimize and simplify get_cycles_sync()
Message-ID: <20070228142554.GE19452@amd.com>
References: <20070228140501.GA19452@amd.com>
MIME-Version: 1.0
In-Reply-To: <20070228140501.GA19452@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 28 Feb 2007 14:26:06.0914 (UTC)
 FILETIME=[62574A20:01C75B44]
X-WSS-ID: 69FB4E882EG1586313-01-01
Content-Type: multipart/mixed;
 boundary="/unnNtmY43mpUSKx"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/unnNtmY43mpUSKx
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Joerg Roedel <joerg.roedel@amd.com>

This patch simplifies the get_cycles_sync() function by removing the
#ifdefs from it. Further it introduces an optimization for AMD
processors. There the RDTSCP instruction is used instead of CPUID;RDTSC
which is helpfull if the kernel runs as a KVM guest. Running as a guest
makes CPUID very expensive because it causes an intercept of the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--/unnNtmY43mpUSKx
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
diff --git a/include/asm-x86_64/tsc.h b/include/asm-x86_64/tsc.h
index 9a0a368..05df3f6 100644
--- a/include/asm-x86_64/tsc.h
+++ b/include/asm-x86_64/tsc.h
@@ -34,22 +34,15 @@ static inline cycles_t get_cycles(void)
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
+	alternative_io_two("cpuid\nrdtsc",
+			   "rdtsc", X86_FEATURE_SYNC_RDTSC,
+			   "rdtscp", X86_FEATURE_RDTSCP,
+			   ASM_OUTPUT2("=a" (a), "=d" (d)),
+			   "0" (1) : "ecx", "memory");
 
-	return ret;
+	return ((unsigned long long)a) | (((unsigned long long)d)<<32);
 }
 
 extern void tsc_init(void);

--/unnNtmY43mpUSKx--


