Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZHTA3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZHTA3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 20:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZHTA3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 20:29:17 -0400
Received: from claw.goop.org ([74.207.240.146]:46202 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZHTA3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 20:29:16 -0400
Message-ID: <4A8C98DD.2020709@goop.org>
Date: Wed, 19 Aug 2009 17:29:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [GIT PULL] Fix Xen boot with CONFIG_CC_STACKPROTECTOR
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's a couple of little changes which prevents an early boot crash
under Xen, due to the stackprotector preamble using segment registers
before they're set up.  I only need to disable stackprotector for a
handful of functions, but unfortunately it looks like it can only be
disabled on a per-file basis.

Thanks,
    J

The following changes since commit 64f1607ffbbc772685733ea63e6f7f4183df1b16:
  Linus Torvalds (1):
        Linux 2.6.31-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git bugfix

Jeremy Fitzhardinge (2):
      x86: make sure load_percpu_segment has no stackprotector
      xen: rearrange things to fix stackprotector

 arch/x86/kernel/cpu/Makefile |    4 ++++
 arch/x86/xen/Makefile        |    4 ++++
 arch/x86/xen/enlighten.c     |   22 ++++++++++------------
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 4e242f9..8b5b9b6 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -7,6 +7,10 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_common.o = -pg
 endif
 
+# Make sure load_percpu_segment has no stackprotector
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_common.o		:= $(nostackp)
+
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
 obj-y			+= vmware.o hypervisor.o
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3b767d0..a5b9288 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -5,6 +5,10 @@ CFLAGS_REMOVE_time.o = -pg
 CFLAGS_REMOVE_irq.o = -pg
 endif
 
+# Make sure early boot has no stackprotector
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_enlighten.o		:= $(nostackp)
+
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm.o xen-asm_$(BITS).o \
 			grant-table.o suspend.o
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f09e8c3..edcf72a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -925,10 +925,6 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_domain_type = XEN_PV_DOMAIN;
 
-	BUG_ON(memcmp(xen_start_info->magic, "xen-3", 5) != 0);
-
-	xen_setup_features();
-
 	/* Install Xen paravirt ops */
 	pv_info = xen_info;
 	pv_init_ops = xen_init_ops;
@@ -937,8 +933,15 @@ asmlinkage void __init xen_start_kernel(void)
 	pv_apic_ops = xen_apic_ops;
 	pv_mmu_ops = xen_mmu_ops;
 
-	xen_init_irq_ops();
+#ifdef CONFIG_X86_64
+	/*
+	 * Setup percpu state.  We only need to do this for 64-bit
+	 * because 32-bit already has %fs set properly.
+	 */
+	load_percpu_segment(0);
+#endif
 
+	xen_init_irq_ops();
 	xen_init_cpuid_mask();
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -948,6 +951,8 @@ asmlinkage void __init xen_start_kernel(void)
 	set_xen_basic_apic_ops();
 #endif
 
+	xen_setup_features();
+
 	if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
 		pv_mmu_ops.ptep_modify_prot_start = xen_ptep_modify_prot_start;
 		pv_mmu_ops.ptep_modify_prot_commit = xen_ptep_modify_prot_commit;
@@ -955,13 +960,6 @@ asmlinkage void __init xen_start_kernel(void)
 
 	machine_ops = xen_machine_ops;
 
-#ifdef CONFIG_X86_64
-	/*
-	 * Setup percpu state.  We only need to do this for 64-bit
-	 * because 32-bit already has %fs set properly.
-	 */
-	load_percpu_segment(0);
-#endif
 	/*
 	 * The only reliable way to retain the initial address of the
 	 * percpu gdt_page is to remember it here, so we can go and


