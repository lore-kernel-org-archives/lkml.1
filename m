Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZELPtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZELPtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZELPrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:47:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:51138 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758392AbZELPrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:47:52 -0400
Subject: [PATCH 8/10 -tip] x86: Add cpufeature for Microcode update
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
In-Reply-To: <1242142941.2547.21.camel@ht.satnam>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam>  <1242142807.2547.18.camel@ht.satnam>
	 <1242142849.2547.19.camel@ht.satnam>  <1242142908.2547.20.camel@ht.satnam>
	 <1242142941.2547.21.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 12 May 2009 21:13:16 +0530
Message-Id: <1242142996.2547.22.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Setting microcode update feature to friendly access of UCODE MSRs like:
1. IA32_PLATFORM_ID (Intel)
2. IA32_UCODE_WRITE (Intel)
3. IA32_UCODE_REV (Intel)
4. MSR_AMD64_PATCH_LEVEL (AMD)
5. MSR_AMD64_PATCH_LOADER (AMD)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |   12 ++++++++++++
 arch/x86/kernel/cpu/intel.c       |   11 +++++++++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index d37ab0f..1fd6770 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -155,6 +155,7 @@
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration	*/
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer	*/
 #define X86_FEATURE_PNAME	(7*32+ 2) /* Processor Name		*/
+#define X86_FEATURE_MICROCODE	(7*32+ 3) /* Microcode update		*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 1d36ac4..ca133a0 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -352,6 +352,15 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 #endif
 }
 
+/* Set cpufeatures to friendly access miscellaneous MSRs		*/
+static void __cpuinit set_soft_cpufeatures(struct cpuinfo_x86 *c)
+{
+	if (c->x86 >= 0x10) {				/* fam10h+	*/
+		/* setting microcode update feature			*/
+		set_cpu_cap(c, X86_FEATURE_MICROCODE);
+	}
+}
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
@@ -371,6 +380,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
+	/* setting early so that other functions can take advantage */
+	set_soft_cpufeatures(c);
+
 	early_init_amd(c);
 
 	/*
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 62130a0..ddb26f2 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -303,10 +303,21 @@ static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
 	}
 }
 
+/* Set cpufeatures to friendly access miscellaneous MSRs		*/
+static void __cpuinit set_soft_cpufeatures(struct cpuinfo_x86 *c)
+{
+	/* setting microcode update feature				*/
+	if (c->x86 >= 6 && !cpu_has(c, X86_FEATURE_IA64))
+		set_cpu_cap(c, X86_FEATURE_MICROCODE);
+}
+
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
 
+	/* setting early so that other functions can take advantage */
+	set_soft_cpufeatures(c);
+
 	early_init_intel(c);
 
 	intel_workarounds(c);
-- 
1.6.0.6



