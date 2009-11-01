Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZKAPYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZKAPYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 10:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZKAPYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 10:24:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55770 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbZKAPYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 10:24:41 -0500
Date: Sun, 1 Nov 2009 16:24:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20091101152433.GA30390@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      x86: Remove STACKPROTECTOR_ALL

Feng Tang (1):
      x86: Make EFI RTC function depend on 32bit again

Jan Beulich (1):
      x86-64: Fix register leak in 32-bit syscall audting

Jiri Slaby (1):
      x86: crash_dump: Fix non-pae kdump kernel memory accesses

Rusty Russell (1):
      x86: Side-step lguest problem by only building cmpxchg8b_emu for pre-Pentium


 arch/x86/Kconfig                |    4 ----
 arch/x86/Kconfig.cpu            |    2 +-
 arch/x86/Makefile               |    1 -
 arch/x86/ia32/ia32entry.S       |    5 ++---
 arch/x86/kernel/crash_dump_32.c |   19 +++++++++++++++++++
 arch/x86/kernel/efi.c           |    2 ++
 6 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 07e0114..72ace95 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1443,12 +1443,8 @@ config SECCOMP
 
 	  If unsure, say Y. Only embedded should say N here.
 
-config CC_STACKPROTECTOR_ALL
-	bool
-
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	select CC_STACKPROTECTOR_ALL
 	---help---
 	  This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index f2824fb..2649840 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -400,7 +400,7 @@ config X86_TSC
 
 config X86_CMPXCHG64
 	def_bool y
-	depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
+	depends on !M386 && !M486
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index a012ee8..d2d24c9 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -76,7 +76,6 @@ ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
         ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(biarch)),y)
                 stackp-y := -fstack-protector
-                stackp-$(CONFIG_CC_STACKPROTECTOR_ALL) += -fstack-protector-all
                 KBUILD_CFLAGS += $(stackp-y)
         else
                 $(warning stack protector enabled but no compiler support)
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 1733f9f..581b056 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -204,7 +204,7 @@ sysexit_from_sys_call:
 	movl RDI-ARGOFFSET(%rsp),%r8d	/* reload 5th syscall arg */
 	.endm
 
-	.macro auditsys_exit exit,ebpsave=RBP
+	.macro auditsys_exit exit
 	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
@@ -217,7 +217,6 @@ sysexit_from_sys_call:
 	call audit_syscall_exit
 	GET_THREAD_INFO(%r10)
 	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall return value */
-	movl \ebpsave-ARGOFFSET(%rsp),%ebp /* reload user register value */
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
 	cli
 	TRACE_IRQS_OFF
@@ -351,7 +350,7 @@ cstar_auditsys:
 	jmp cstar_dispatch
 
 sysretl_audit:
-	auditsys_exit sysretl_from_sys_call, RCX /* user %ebp in RCX slot */
+	auditsys_exit sysretl_from_sys_call
 #endif
 
 cstar_tracesys:
diff --git a/arch/x86/kernel/crash_dump_32.c b/arch/x86/kernel/crash_dump_32.c
index f7cdb3b..cd97ce1 100644
--- a/arch/x86/kernel/crash_dump_32.c
+++ b/arch/x86/kernel/crash_dump_32.c
@@ -16,6 +16,22 @@ static void *kdump_buf_page;
 /* Stores the physical address of elf header of crash image. */
 unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
 
+static inline bool is_crashed_pfn_valid(unsigned long pfn)
+{
+#ifndef CONFIG_X86_PAE
+	/*
+	 * non-PAE kdump kernel executed from a PAE one will crop high pte
+	 * bits and poke unwanted space counting again from address 0, we
+	 * don't want that. pte must fit into unsigned long. In fact the
+	 * test checks high 12 bits for being zero (pfn will be shifted left
+	 * by PAGE_SHIFT).
+	 */
+	return pte_pfn(pfn_pte(pfn, __pgprot(0))) == pfn;
+#else
+	return true;
+#endif
+}
+
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied
@@ -41,6 +57,9 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	if (!csize)
 		return 0;
 
+	if (!is_crashed_pfn_valid(pfn))
+		return -EFAULT;
+
 	vaddr = kmap_atomic_pfn(pfn, KM_PTE0);
 
 	if (!userbuf) {
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index ad5bd98..cdcfb12 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -454,8 +454,10 @@ void __init efi_init(void)
 	if (add_efi_memmap)
 		do_add_efi_memmap();
 
+#ifdef CONFIG_X86_32
 	x86_platform.get_wallclock = efi_get_time;
 	x86_platform.set_wallclock = efi_set_rtc_mmss;
+#endif
 
 	/* Setup for EFI runtime service */
 	reboot_type = BOOT_EFI;
