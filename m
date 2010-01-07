Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943Ab0AGXbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab0AGXbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 18:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983Ab0AGXbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 18:31:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58231 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0AGXbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 18:31:44 -0500
Date: Thu, 7 Jan 2010 15:30:23 -0800
Message-Id: <201001072330.o07NUNcb010383@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Gary Hade <garyhade@us.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86 fixes for 2.6.33-rc4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (terminus.zytor.com [127.0.0.1]); Thu, 07 Jan 2010 15:30:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
	
The following changes since commit 2c1f1895ef2aa8f0e5497893eff71304aef332e1:
  Linus Torvalds (1):
        Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git x86-fixes-for-linus

Heiko Carstens (1):
      x86: copy_from_user() should not return -EFAULT

Rusty Russell (1):
      Revert "x86: Side-step lguest problem by only building cmpxchg8b_emu for pre-Pentium"

Suresh Siddha (1):
      x86, irq: Check move_in_progress before freeing the vector mapping

Yinghai Lu (2):
      x86: Fix size for ex trampoline with 32bit
      x86/pci: Intel ioh bus num reg accessing fix

 arch/x86/Kconfig.cpu              |    2 +-
 arch/x86/include/asm/uaccess_32.h |    5 ++---
 arch/x86/include/asm/uaccess_64.h |    5 ++---
 arch/x86/kernel/apic/io_apic.c    |    7 +++++++
 arch/x86/kernel/e820.c            |    4 ++--
 arch/x86/pci/intel_bus.c          |    4 ++++
 6 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 08e442b..f20ddf8 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -396,7 +396,7 @@ config X86_TSC
 
 config X86_CMPXCHG64
 	def_bool y
-	depends on !M386 && !M486
+	depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 0c9825e..088d09f 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -205,14 +205,13 @@ static inline unsigned long __must_check copy_from_user(void *to,
 					  unsigned long n)
 {
 	int sz = __compiletime_object_size(to);
-	int ret = -EFAULT;
 
 	if (likely(sz == -1 || sz >= n))
-		ret = _copy_from_user(to, from, n);
+		n = _copy_from_user(to, from, n);
 	else
 		copy_from_user_overflow();
 
-	return ret;
+	return n;
 }
 
 long __must_check strncpy_from_user(char *dst, const char __user *src,
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 46324c6..535e421 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -30,16 +30,15 @@ static inline unsigned long __must_check copy_from_user(void *to,
 					  unsigned long n)
 {
 	int sz = __compiletime_object_size(to);
-	int ret = -EFAULT;
 
 	might_fault();
 	if (likely(sz == -1 || sz >= n))
-		ret = _copy_from_user(to, from, n);
+		n = _copy_from_user(to, from, n);
 #ifdef CONFIG_DEBUG_VM
 	else
 		WARN(1, "Buffer overflow detected!\n");
 #endif
-	return ret;
+	return n;
 }
 
 static __always_inline __must_check
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index de00c46..53243ca 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2434,6 +2434,13 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		cfg = irq_cfg(irq);
 		raw_spin_lock(&desc->lock);
 
+		/*
+		 * Check if the irq migration is in progress. If so, we
+		 * haven't received the cleanup request yet for this irq.
+		 */
+		if (cfg->move_in_progress)
+			goto unlock;
+
 		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 			goto unlock;
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 05ed7ab..a1a7876 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -733,13 +733,13 @@ struct early_res {
 };
 static struct early_res early_res[MAX_EARLY_RES] __initdata = {
 	{ 0, PAGE_SIZE, "BIOS data page", 1 },	/* BIOS data page */
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_32) && defined(CONFIG_X86_TRAMPOLINE)
 	/*
 	 * But first pinch a few for the stack/trampoline stuff
 	 * FIXME: Don't need the extra page at 4K, but need to fix
 	 * trampoline before removing it. (see the GDT stuff)
 	 */
-	{ PAGE_SIZE, PAGE_SIZE, "EX TRAMPOLINE", 1 },
+	{ PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE", 1 },
 #endif
 
 	{}
diff --git a/arch/x86/pci/intel_bus.c b/arch/x86/pci/intel_bus.c
index b7a55dc..f81a2fa 100644
--- a/arch/x86/pci/intel_bus.c
+++ b/arch/x86/pci/intel_bus.c
@@ -49,6 +49,10 @@ static void __devinit pci_root_bus_res(struct pci_dev *dev)
 	u64 mmioh_base, mmioh_end;
 	int bus_base, bus_end;
 
+	/* some sys doesn't get mmconf enabled */
+	if (dev->cfg_size < 0x120)
+		return;
+
 	if (pci_root_num >= PCI_ROOT_NR) {
 		printk(KERN_DEBUG "intel_bus.c: PCI_ROOT_NR is too small\n");
 		return;
