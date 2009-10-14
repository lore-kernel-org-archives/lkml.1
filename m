Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbZJNTbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbZJNTbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759068AbZJNTbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:31:00 -0400
Received: from claw.goop.org ([74.207.240.146]:55337 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063AbZJNT36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:29:58 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 08/12] x86: create specific X86_VSYSCALL config variable
Date: Wed, 14 Oct 2009 12:28:32 -0700
Message-Id: <1255548516-15260-9-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vsyscalls are only implemented on 64-bit at present, though there's no
fundimental reason why they couldn't be implemented for 32-bit.  Create
a new CONFIG_X86_VSYSCALL to control compilation of vsyscall-related
code and definitions to make it clearer where they are.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig              |    6 +++++-
 arch/x86/include/asm/fixmap.h |    7 +++++--
 arch/x86/kernel/Makefile      |    3 ++-
 arch/x86/kernel/hpet.c        |    4 ++--
 arch/x86/kernel/tsc.c         |    4 ++--
 5 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 13ffa5d..7950d54 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -136,7 +136,7 @@ config GENERIC_CALIBRATE_DELAY
 
 config GENERIC_TIME_VSYSCALL
 	bool
-	default X86_64
+	default X86_VSYSCALL
 
 config ARCH_HAS_CPU_RELAX
 	def_bool y
@@ -222,6 +222,10 @@ config X86_32_LAZY_GS
 	def_bool y
 	depends on X86_32 && !CC_STACKPROTECTOR
 
+config X86_VSYSCALL
+       def_bool y
+       depends on X86_64
+
 config KTIME_SCALAR
 	def_bool X86_32
 source "init/Kconfig"
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 7b2d71d..3b63b57 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -74,12 +74,15 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_32
 	FIX_HOLE,
 	FIX_VDSO,
-#else
+#endif
+
+#ifdef CONFIG_X86_VSYSCALL
 	VSYSCALL_LAST_PAGE,
 	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
 			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
 	VSYSCALL_HPET,
-#endif
+#endif	/* CONFIG_X86_VSYSCALL */
+
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 430d5b2..1c9ec2f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -37,7 +37,8 @@ obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
-obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
+obj-$(CONFIG_X86_64)	+= syscall_64.o
+obj-$(CONFIG_X86_VSYSCALL)	+= vsyscall_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index dedc2bd..2cac930 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -744,7 +744,7 @@ static cycle_t read_hpet(struct clocksource *cs)
 	return (cycle_t)hpet_readl(HPET_COUNTER);
 }
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_VSYSCALL
 static cycle_t __vsyscall_fn vread_hpet(void)
 {
 	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
@@ -759,7 +759,7 @@ static struct clocksource clocksource_hpet = {
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_resume_counter,
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_VSYSCALL
 	.vread		= vread_hpet,
 #endif
 };
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 71f4368..fe7174f 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -725,7 +725,7 @@ static cycle_t read_tsc(struct clocksource *cs)
 		ret : clocksource_tsc.cycle_last;
 }
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_VSYSCALL
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret;
@@ -752,7 +752,7 @@ static struct clocksource clocksource_tsc = {
 	.shift                  = 22,
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_VSYSCALL
 	.vread                  = vread_tsc,
 #endif
 };
-- 
1.6.2.5

