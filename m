Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZEOW2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZEOW2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 18:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbZEOW2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 18:28:16 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:40459 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbZEOW2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 18:28:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CxEryEG7R3etPMDV0nzWbjAzjBWM6BmFMarxRXn1yocF1tlfZhc9tRiuKpVNotGNOW
         GpPTkZOIYwCfUa4i3tbdOixwiwumpVpBoBtQNCT8GU4/h1MxEwWPOuBkVnf7yOHOdGB0
         fllPENLKRHJvGvb+Hh2+UcNMhS3Vh4xdHeKE0=
Subject: [PATCH 25/30] loongson: Hibernation Support in mips system
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org
Cc: Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com,
       zhangfx@lemote.com, yanh@lemote.com,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Erwan Lerale <erwan@thiscow.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Sat, 16 May 2009 06:28:08 +0800
Message-Id: <1242426488.10164.173.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d4776f4891b9be96d357910f62d9ebaf898a3015 Mon Sep 17 00:00:00 2001
From: Wu Zhangjin <wuzhangjin@gmail.com>
Date: Sat, 16 May 2009 04:51:26 +0800
Subject: [PATCH 25/30] loongson: Hibernation Support in mips system

---
 arch/mips/Kconfig               |    3 +
 arch/mips/Makefile              |    3 +
 arch/mips/include/asm/suspend.h |    2 +
 arch/mips/kernel/asm-offsets.c  |   13 ++++++
 arch/mips/power/Makefile        |    1 +
 arch/mips/power/cpu.c           |   48 ++++++++++++++++++++++++
 arch/mips/power/hibernate.S     |   78
+++++++++++++++++++++++++++++++++++++++
 include/linux/suspend.h         |    2 +-
 8 files changed, 149 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/power/Makefile
 create mode 100644 arch/mips/power/cpu.c
 create mode 100644 arch/mips/power/hibernate.S

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 68c12de..b14e866 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2130,6 +2130,9 @@ endmenu
 
 menu "Power management options"
 
+config ARCH_HIBERNATION_POSSIBLE
+	def_bool y
+
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 	depends on !SMP
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index d73f084..8bde363 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -677,6 +677,9 @@ core-y			+= arch/mips/kernel/ arch/mips/mm/
arch/mips/math-emu/
 
 drivers-$(CONFIG_OPROFILE)	+= arch/mips/oprofile/
 
+# suspend and hibernation support
+drivers-$(CONFIG_PM)	+= arch/mips/power/
+
 ifdef CONFIG_LASAT
 rom.bin rom.sw: vmlinux
 	$(Q)$(MAKE) $(build)=arch/mips/lasat/image $@
diff --git a/arch/mips/include/asm/suspend.h
b/arch/mips/include/asm/suspend.h
index 2562f8f..1d44287 100644
--- a/arch/mips/include/asm/suspend.h
+++ b/arch/mips/include/asm/suspend.h
@@ -3,4 +3,6 @@
 
 /* Somewhen...  Maybe :-)  */
 
+static inline int arch_prepare_suspend(void) { return 0; }
+
 #endif /* __ASM_SUSPEND_H */
diff --git a/arch/mips/kernel/asm-offsets.c
b/arch/mips/kernel/asm-offsets.c
index c901c22..94964f5 100644
--- a/arch/mips/kernel/asm-offsets.c
+++ b/arch/mips/kernel/asm-offsets.c
@@ -14,6 +14,7 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/kbuild.h>
+#include <linux/suspend.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 
@@ -326,3 +327,15 @@ void output_octeon_cop2_state_defines(void)
 	BLANK();
 }
 #endif
+
+#ifdef CONFIG_HIBERNATION
+void output_pbe_defines(void)
+{
+ 	COMMENT(" Linux struct pbe offsets. ");
+ 	OFFSET(PBE_ADDRESS , pbe, address);
+ 	OFFSET(PBE_ORIG_ADDRESS  , pbe, orig_address);
+ 	OFFSET(PBE_NEXT  , pbe, next);
+ 	DEFINE(PBE_SIZE  , sizeof(struct pbe));
+ 	BLANK();
+}
+#endif
diff --git a/arch/mips/power/Makefile b/arch/mips/power/Makefile
new file mode 100644
index 0000000..73d56b8
--- /dev/null
+++ b/arch/mips/power/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_HIBERNATION) += cpu.o hibernate.o
diff --git a/arch/mips/power/cpu.c b/arch/mips/power/cpu.c
new file mode 100644
index 0000000..b799bfe
--- /dev/null
+++ b/arch/mips/power/cpu.c
@@ -0,0 +1,48 @@
+/*
+ * Suspend support specific for mips.
+ *
+ */
+#include <linux/mm.h>
+#include <asm/mipsregs.h>
+#include <asm/page.h>
+#include <asm/suspend.h>
+
+/* References to section boundaries */
+extern const void __nosave_begin, __nosave_end;
+static uint32_t saved_status;
+unsigned long 
+	 saved_ra,
+	 saved_sp,
+	 saved_fp,
+	 saved_gp,
+	 saved_s0,
+	 saved_s1,
+	 saved_s2,
+	 saved_s3,
+	 saved_s4,
+	 saved_s5,
+	 saved_s6,
+	 saved_s7,
+	 saved_a0,
+	 saved_a1,
+	 saved_a2,
+	 saved_a3,
+	 saved_v0,
+	 saved_v1;
+
+void save_processor_state(void)
+{
+	saved_status = read_c0_status();
+}
+
+void restore_processor_state(void)
+{
+	write_c0_status(saved_status);
+}
+
+int pfn_is_nosave(unsigned long pfn)
+{
+ 	unsigned long nosave_begin_pfn = __pa(&__nosave_begin) >> PAGE_SHIFT;
+ 	unsigned long nosave_end_pfn = PAGE_ALIGN(__pa(&__nosave_end)) >>
PAGE_SHIFT;
+ 	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
+}
diff --git a/arch/mips/power/hibernate.S b/arch/mips/power/hibernate.S
new file mode 100644
index 0000000..e45ec45
--- /dev/null
+++ b/arch/mips/power/hibernate.S
@@ -0,0 +1,78 @@
+#incldue <linux/linkage.h>
+#include <asm/asm-offsets.h>
+#include <asm/regdef.h>
+#include <asm/asm.h>
+
+.text 
+LEAF(swsusp_arch_suspend)
+	 PTR_LA t0, saved_ra
+	 PTR_S ra, (t0)
+	 PTR_LA t0, saved_sp
+	 PTR_S sp, (t0)
+	 PTR_LA t0, saved_fp
+	 PTR_S fp, (t0)
+	 PTR_LA t0, saved_gp
+	 PTR_S gp, (t0)
+	 PTR_LA t0, saved_s0
+	 PTR_S s0, (t0) 
+	 PTR_LA t0, saved_s1
+	 PTR_S s1, (t0)
+	 PTR_LA t0, saved_s2
+	 PTR_S s2, (t0)
+	 PTR_LA t0, saved_s3
+	 PTR_S s3, (t0)
+	 PTR_LA t0, saved_s4
+	 PTR_S s4, (t0)
+	 PTR_LA t0, saved_s5
+	 PTR_S s5, (t0)
+	 PTR_LA t0, saved_s6
+	 PTR_S s6, (t0)
+	 PTR_LA t0, saved_s7
+	 PTR_S s7, (t0)
+	 PTR_LA t0, saved_a0
+	 PTR_S a0, (t0)
+	 PTR_LA t0, saved_a1
+	 PTR_S a1, (t0)
+	 PTR_LA t0, saved_a2
+	 PTR_S a2, (t0)
+	 PTR_LA t0, saved_v1
+	 PTR_S v1, (t0)
+	 j swsusp_save
+	 nop
+END(swsusp_arch_suspend)
+
+LEAF(swsusp_arch_resume)
+	PTR_L t0, restore_pblist
+0: 
+	PTR_L t1, PBE_ADDRESS(t0)   /* source */
+ 	PTR_L t2, PBE_ORIG_ADDRESS(t0) /* destination */
+ 	PTR_ADDIU t3, t1, _PAGE_SIZE
+1: 
+	REG_L t8, (t1)
+ 	REG_S t8, (t2)
+ 	PTR_ADDIU t1, t1, SZREG
+ 	PTR_ADDIU t2, t2, SZREG
+ 	bne t1, t3, 1b
+ 	PTR_L t0, PBE_NEXT(t0)
+ 	bnez t0, 0b
+	//flush cache and tlb. no need?I am not sure.
+	PTR_L ra, saved_ra
+	PTR_L sp, saved_sp
+	PTR_L fp, saved_fp
+	PTR_L s0, saved_s0
+	PTR_L s1, saved_s1
+	PTR_L s2, saved_s2
+	PTR_L s3, saved_s3
+	PTR_L s4, saved_s4
+	PTR_L s5, saved_s5
+	PTR_L s6, saved_s6
+	PTR_L s7, saved_s7
+	PTR_L a0, saved_a0
+	PTR_L a1, saved_a1
+	PTR_L a2, saved_a2
+	PTR_L a3, saved_a3
+	PTR_LI v0, 0x0 
+	PTR_L v1, saved_v1
+	jr ra
+	nop
+END(swsusp_arch_resume)
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index c7d9bb1..4ed4879 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_SUSPEND_H
 #define _LINUX_SUSPEND_H
 
-#if defined(CONFIG_X86) || defined(CONFIG_FRV) || defined(CONFIG_PPC32)
|| defined(CONFIG_PPC64)
+#if defined(CONFIG_X86) || defined(CONFIG_FRV) || defined(CONFIG_PPC32)
|| defined(CONFIG_PPC64) || defined(CONFIG_MIPS)
 #include <asm/suspend.h>
 #endif
 #include <linux/swap.h>
-- 
1.6.2.1



