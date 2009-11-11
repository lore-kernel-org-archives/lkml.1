Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbZKKUfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbZKKUfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbZKKUfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:35:54 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:38249 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZKKUfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:35:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=qEaZ+AAdemfdH2dvYoWY3/G4Vcx9ZUNlZ35mngLwoyLQz/6f4Q2rkN6sKR89VljHsY
         iYL9bsPZgqc+glffFScyzIcDd9bn9Jjs3tsiTWIi8tpDN02VGNcNQbUM6RuIbS63xWP9
         Y+gvyapr5GM4wyMDHHkjoidzA6tedOB2290hQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: x86@kernel.org
Subject: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
Date: Wed, 11 Nov 2009 21:34:34 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911112134.34261.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"ht" flag indicates only ability to detect siblings not HT presence itself.

Inspired by:
http://www.codemonkey.org.uk/2009/11/10/common-hyperthreading-misconception/

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
It could be that there are some user-space programs depending on "ht"
flag so the patch is marked as RFC..

 arch/x86/include/asm/cpufeature.h |    4 ++--
 arch/x86/kernel/cpu/capflags.c    |    2 +-
 arch/x86/kernel/cpu/common.c      |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: b/arch/x86/include/asm/cpufeature.h
===================================================================
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -42,7 +42,7 @@
 #define X86_FEATURE_XMM		(0*32+25) /* "sse" */
 #define X86_FEATURE_XMM2	(0*32+26) /* "sse2" */
 #define X86_FEATURE_SELFSNOOP	(0*32+27) /* "ss" CPU self snoop */
-#define X86_FEATURE_HT		(0*32+28) /* Hyper-Threading */
+#define X86_FEATURE_HT_DETECTION (0*32+28) /* Hyper-Threading detection */
 #define X86_FEATURE_ACC		(0*32+29) /* "tm" Automatic clock control */
 #define X86_FEATURE_IA64	(0*32+30) /* IA-64 processor */
 #define X86_FEATURE_PBE		(0*32+31) /* Pending Break Enable */
@@ -220,7 +220,7 @@ extern const char * const x86_power_flag
 #define cpu_has_xmm2		boot_cpu_has(X86_FEATURE_XMM2)
 #define cpu_has_xmm3		boot_cpu_has(X86_FEATURE_XMM3)
 #define cpu_has_aes		boot_cpu_has(X86_FEATURE_AES)
-#define cpu_has_ht		boot_cpu_has(X86_FEATURE_HT)
+#define cpu_has_ht_detection	boot_cpu_has(X86_FEATURE_HT_DETECTION)
 #define cpu_has_mp		boot_cpu_has(X86_FEATURE_MP)
 #define cpu_has_nx		boot_cpu_has(X86_FEATURE_NX)
 #define cpu_has_k6_mtrr		boot_cpu_has(X86_FEATURE_K6_MTRR)
Index: b/arch/x86/kernel/cpu/capflags.c
===================================================================
--- a/arch/x86/kernel/cpu/capflags.c
+++ b/arch/x86/kernel/cpu/capflags.c
@@ -27,7 +27,7 @@ const char * const x86_cap_flags[NCAPINT
 	[X86_FEATURE_XMM]                = "sse",
 	[X86_FEATURE_XMM2]               = "sse2",
 	[X86_FEATURE_SELFSNOOP]          = "ss",
-	[X86_FEATURE_HT]                 = "ht",
+	[X86_FEATURE_HT_DETECTION]       = "ht_detection",
 	[X86_FEATURE_ACC]                = "tm",
 	[X86_FEATURE_IA64]               = "ia64",
 	[X86_FEATURE_PBE]                = "pbe",
Index: b/arch/x86/kernel/cpu/common.c
===================================================================
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -433,7 +433,7 @@ void __cpuinit detect_ht(struct cpuinfo_
 	u32 eax, ebx, ecx, edx;
 	int index_msb, core_bits;
 
-	if (!cpu_has(c, X86_FEATURE_HT))
+	if (!cpu_has(c, X86_FEATURE_HT_DETECTION))
 		return;
 
 	if (cpu_has(c, X86_FEATURE_CMP_LEGACY))
