Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbYHEJsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbYHEJsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYHEJp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:45:27 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:40584 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbYHEJpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:45:25 -0400
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, michael@free-electrons.com
Subject: [PATCH 1/1] [x86] Configuration options to compile out x86 CPU support code
Date: Tue,  5 Aug 2008 11:45:19 +0200
Message-Id: <1217929519-10527-1-git-send-email-thomas.petazzoni@free-electrons.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some configuration options that allow to compile out
CPU vendor-specific code in x86 kernels (in arch/x86/kernel/cpu). The
new configuration options are only visible when CONFIG_EMBEDDED is
selected, as they are mostly interesting for space savings reasons.

An example of size saving, on x86 with only Intel CPU support:

   text	   data	    bss	    dec	    hex	filename
1125479	 118760	 212992	1457231	 163c4f	vmlinux.old
1121355	 116536	 212992	1450883	 162383	vmlinux
  -4124   -2224       0   -6348   -18CC +/-

However, I'm not exactly sure that the Kconfig wording is correct with
regard to !64BIT / 64BIT.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: michael@free-electrons.com
---
 arch/x86/Kconfig.cpu         |   70 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/Makefile |   19 ++++++-----
 include/asm-x86/bugs.h       |    5 +++
 3 files changed, 85 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 2c518fb..6156ac2 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -415,3 +415,73 @@ config X86_MINIMUM_CPU_FAMILY
 config X86_DEBUGCTLMSR
 	def_bool y
 	depends on !(MK6 || MWINCHIPC6 || MWINCHIP2 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)
+
+menuconfig PROCESSOR_SELECT
+	default y
+	bool "Supported processor vendors" if EMBEDDED
+	help
+	  This lets you choose what x86 vendor support code your kernel
+	  will include.
+
+config CPU_SUP_INTEL_32
+	default y
+	bool "Support Intel processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for Intel processors
+
+config CPU_SUP_INTEL_64
+	default y
+	bool "Support Intel processors" if PROCESSOR_SELECT
+	depends on 64BIT
+	help
+	  This enables extended support for Intel processors
+
+config CPU_SUP_CYRIX_32
+	default y
+	bool "Support Cyrix processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for Cyrix processors
+
+config CPU_SUP_AMD_32
+	default y
+	bool "Support AMD processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for AMD processors
+
+config CPU_SUP_AMD_64
+	default y
+	bool "Support AMD processors" if PROCESSOR_SELECT
+	depends on 64BIT
+	help
+	  This enables extended support for AMD processors
+
+config CPU_SUP_CENTAUR_32
+	default y
+	bool "Support Centaur processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for Centaur processors
+
+config CPU_SUP_CENTAUR_64
+	default y
+	bool "Support Centaur processors" if PROCESSOR_SELECT
+	depends on 64BIT
+	help
+	  This enables extended support for Centaur processors
+
+config CPU_SUP_TRANSMETA_32
+	default y
+	bool "Support Transmeta processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for Transmeta processors
+
+config CPU_SUP_UMC_32
+	default y
+	bool "Support UMC processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for UMC processors
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index ee76eaa..a35ee92 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -7,15 +7,16 @@ obj-y			+= proc.o feature_names.o
 
 obj-$(CONFIG_X86_32)	+= common.o bugs.o
 obj-$(CONFIG_X86_64)	+= common_64.o bugs_64.o
-obj-$(CONFIG_X86_32)	+= amd.o
-obj-$(CONFIG_X86_64)	+= amd_64.o
-obj-$(CONFIG_X86_32)	+= cyrix.o
-obj-$(CONFIG_X86_32)	+= centaur.o
-obj-$(CONFIG_X86_64)	+= centaur_64.o
-obj-$(CONFIG_X86_32)	+= transmeta.o
-obj-$(CONFIG_X86_32)	+= intel.o
-obj-$(CONFIG_X86_64)	+= intel_64.o
-obj-$(CONFIG_X86_32)	+= umc.o
+
+obj-$(CONFIG_CPU_SUP_AMD_32)		+= amd.o
+obj-$(CONFIG_CPU_SUP_AMD_64)		+= amd_64.o
+obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
+obj-$(CONFIG_CPU_SUP_CENTAUR_32)	+= centaur.o
+obj-$(CONFIG_CPU_SUP_CENTAUR_64)	+= centaur_64.o
+obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
+obj-$(CONFIG_CPU_SUP_INTEL_32)		+= intel.o
+obj-$(CONFIG_CPU_SUP_INTEL_64)		+= intel_64.o
+obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
 obj-$(CONFIG_X86_MCE)	+= mcheck/
 obj-$(CONFIG_MTRR)	+= mtrr/
diff --git a/include/asm-x86/bugs.h b/include/asm-x86/bugs.h
index 021cbdd..66cf8c9 100644
--- a/include/asm-x86/bugs.h
+++ b/include/asm-x86/bugs.h
@@ -2,6 +2,11 @@
 #define _ASM_X86_BUGS_H
 
 extern void check_bugs(void);
+
+#ifdef CONFIG_CPU_SUP_INTEL_32
 int ppro_with_ram_bug(void);
+#else
+#define ppro_with_ram_bug() (0)
+#endif
 
 #endif /* _ASM_X86_BUGS_H */
-- 
1.5.4.3

