Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbZBSNto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbZBSNto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbZBSNrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:47:33 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:50970 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbZBSNr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:47:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bbcaaJ6pMijCBRMwXEfoZKay2WgcwyyVhKBzLVW5yylGXSIyymD6zVN6GayU6BqyIG
         rTq3Sypo/AWe378l51rdwma0MAxOO6YLO2xtU70iLYck+VeTXV9NLzFAMq6VE0SFeTs4
         A73yumvrjta2YqV/kFOjW1TOytIJDYYno4hKE=
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>
Subject: [PATCH] [ARM] pxa: accept old ARM926 compatible CPUID for pxa168
Date: Thu, 19 Feb 2009 21:45:56 +0800
Message-Id: <1235051161-8858-8-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235051161-8858-7-git-send-email-eric.y.miao@gmail.com>
References: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-2-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-3-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-4-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-5-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-6-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-7-git-send-email-eric.y.miao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 arch/arm/boot/compressed/head.S |    5 +++++
 arch/arm/mm/Kconfig             |    5 +++++
 arch/arm/mm/proc-mohawk.S       |   26 ++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 4629dc8..fa5089f 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -630,8 +630,13 @@ proc_types:
 		b	__armv4_mmu_cache_off
 		b	__armv4_mmu_cache_flush
 
+#ifdef CONFIG_CPU_MOHAWK_OLD_ID
+		.word 0x41159260		@ ARM926T (Marvell Mohawk)
+		.word 0xfffffff0
+#else
 		.word 0x56158000
 		.word 0xff0ff000
+#endif
 		b __armv4_mmu_cache_on
 		b __armv4_mmu_cache_off
 		b __armv5tej_mmu_cache_flush
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 64086f4..3f1e41a 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -351,6 +351,11 @@ config CPU_MOHAWK
 	select CPU_TLB_V4WBI if MMU
 	select CPU_COPY_V4WB if MMU
 
+config CPU_MOHAWK_OLD_ID
+	bool "Accept Mohawk ARM926 Compatible CPUID"
+	depends on CPU_MOHAWK && !CPU_ARM926T
+	default y
+
 # Feroceon
 config CPU_FEROCEON
 	bool
diff --git a/arch/arm/mm/proc-mohawk.S b/arch/arm/mm/proc-mohawk.S
index 719659a..08dd551 100644
--- a/arch/arm/mm/proc-mohawk.S
+++ b/arch/arm/mm/proc-mohawk.S
@@ -395,6 +395,32 @@ cpu_pxa168_name:
 
 	.section ".proc.info.init", #alloc, #execinstr
 
+#ifdef CONFIG_CPU_MOHAWK_OLD_ID
+	.type	__mohawk_old_id_proc_info,#object
+	.long	0x41159260
+	.long	0xfffffff0
+	.long   PMD_TYPE_SECT | \
+		PMD_SECT_BUFFERABLE | \
+		PMD_SECT_CACHEABLE | \
+		PMD_BIT4 | \
+		PMD_SECT_AP_WRITE | \
+		PMD_SECT_AP_READ
+	.long   PMD_TYPE_SECT | \
+		PMD_BIT4 | \
+		PMD_SECT_AP_WRITE | \
+		PMD_SECT_AP_READ
+	b	__mohawk_setup
+	.long	cpu_arch_name
+	.long	cpu_elf_name
+	.long	HWCAP_SWP|HWCAP_HALF|HWCAP_THUMB|HWCAP_FAST_MULT|HWCAP_EDSP
+	.long	cpu_mohawk_name
+	.long	mohawk_processor_functions
+	.long	v4wbi_tlb_fns
+	.long	v4wb_user_fns
+	.long	mohawk_cache_fns
+	.size	__pxa168_proc_info, . - __pxa168_proc_info
+#endif
+
 	.type	__pxa168_proc_info,#object
 __pxa168_proc_info:
 	.long	0x56158400			@ Marvell PXA168
-- 
1.6.0.4

