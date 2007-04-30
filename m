Return-Path: <linux-kernel-owner+w=401wt.eu-S1423463AbXD3Pzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423463AbXD3Pzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423448AbXD3Ptl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:49:41 -0400
Received: from ns.suse.de ([195.135.220.2]:44967 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423373AbXD3Pth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:37 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: bk@suse.de, ak@suse.de, davej@codemonkey.org.uk, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [3/34] x86: Save the MTRRs of the BSP before booting an AP
Message-Id: <20070430154934.DCD06151FC@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Bernhard Kaindl <bk@suse.de>
Applied fix by Andew Morton:
http://lkml.org/lkml/2007/4/8/88 - Fix `make headers_check'.

AMD and Intel x86 CPU manuals state that it is the responsibility of
system software to initialize and maintain MTRR consistency across
all processors in Multi-Processing Environments.

Quote from page 188 of the AMD64 System Programming manual (Volume 2):

7.6.5 MTRRs in Multi-Processing Environments

"In multi-processing environments, the MTRRs located in all processors must
characterize memory in the same way. Generally, this means that identical
values are written to the MTRRs used by the processors." (short omission here)
"Failure to do so may result in coherency violations or loss of atomicity.
Processor implementations do not check the MTRR settings in other processors
to ensure consistency. It is the responsibility of system software to
initialize and maintain MTRR consistency across all processors."

Current Linux MTRR code already implements the above in the case that the
BIOS does not properly initialize MTRRs on the secondary processors,
but the case where the fixed-range MTRRs of the boot processor are changed
after Linux started to boot, before the initialsation of a secondary
processor, is not handled yet.

In this case, secondary processors are currently initialized by Linux
with MTRRs which the boot processor had very early, when mtrr_bp_init()
did run, but not with the MTRRs which the boot processor uses at the
time when that secondary processors is actually booted,
causing differing MTRR contents on the secondary processors.

Such situation happens on Acer Ferrari 1000 and 5000 notebooks where the
BIOS enables and sets AMD-specific IORR bits in the fixed-range MTRRs
of the boot processor when it transitions the system into ACPI mode.
The SMI handler of the BIOS does this in SMM, entered while Linux ACPI
code runs acpi_enable().

Other occasions where the SMI handler of the BIOS may change bits in
the MTRRs could occur as well. To initialize newly booted secodary
processors with the fixed-range MTRRs which the boot processor uses
at that time, this patch saves the fixed-range MTRRs of the boot
processor before new secondary processors are started. When the
secondary processors run their Linux initialisation code, their
fixed-range MTRRs will be updated with the saved fixed-range MTRRs.

If CONFIG_MTRR is not set, we define mtrr_save_state
as an empty statement because there is nothing to do.

Possible TODOs:

*) CPU-hotplugging outside of SMP suspend/resume is not yet tested
   with this patch.

*) If, even in this case, an AP never runs i386/do_boot_cpu or x86_64/cpu_up,
   then the calls to mtrr_save_state() could be replaced by calls to
   mtrr_save_fixed_ranges(NULL) and  mtrr_save_state() would not be
   needed.

   That would need either verification of the CPU-hotplug code or
   at least a test on a >2 CPU machine.

*) The MTRRs of other running processors are not yet checked at this
   time but it might be interesting to syncronize the MTTRs of all
   processors before booting. That would be an incremental patch,
   but of rather low priority since there is no machine known so
   far which would require this.

AK: moved prototypes on x86-64 around to fix warnings

Signed-off-by: Bernhard Kaindl <bk@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>

---
 arch/i386/kernel/cpu/mtrr/main.c |   11 +++++++++++
 arch/i386/kernel/smpboot.c       |    7 +++++++
 arch/x86_64/kernel/smpboot.c     |    6 ++++++
 include/asm-i386/mtrr.h          |    2 ++
 include/asm-x86_64/mtrr.h        |    2 ++
 5 files changed, 28 insertions(+)

Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -58,6 +58,7 @@
 #include <mach_wakecpu.h>
 #include <smpboot_hooks.h>
 #include <asm/vmi.h>
+#include <asm/mtrr.h>
 
 /* Set if we find a B stepping CPU */
 static int __devinitdata smp_b_stepping;
@@ -815,6 +816,12 @@ static int __cpuinit do_boot_cpu(int api
 	unsigned short nmi_high = 0, nmi_low = 0;
 
 	/*
+	 * Save current MTRR state in case it was changed since early boot
+	 * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
+	 */
+	mtrr_save_state();
+
+	/*
 	 * We can't use kernel_thread since we must avoid to
 	 * reschedule the child.
 	 */
Index: linux/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smpboot.c
+++ linux/arch/x86_64/kernel/smpboot.c
@@ -944,6 +944,12 @@ int __cpuinit __cpu_up(unsigned int cpu)
  		return -ENOSYS;
 	}
 
+	/*
+	 * Save current MTRR state in case it was changed since early boot
+	 * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
+	 */
+	mtrr_save_state();
+
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 	/* Boot it! */
 	err = do_boot_cpu(cpu, apicid);
Index: linux/include/asm-i386/mtrr.h
===================================================================
--- linux.orig/include/asm-i386/mtrr.h
+++ linux/include/asm-i386/mtrr.h
@@ -70,6 +70,7 @@ struct mtrr_gentry
 /*  The following functions are for use by other drivers  */
 # ifdef CONFIG_MTRR
 extern void mtrr_save_fixed_ranges(void *);
+extern void mtrr_save_state(void);
 extern int mtrr_add (unsigned long base, unsigned long size,
 		     unsigned int type, char increment);
 extern int mtrr_add_page (unsigned long base, unsigned long size,
@@ -81,6 +82,7 @@ extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 #  else
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
+#define mtrr_save_state() do {} while (0)
 static __inline__ int mtrr_add (unsigned long base, unsigned long size,
 				unsigned int type, char increment)
 {
Index: linux/arch/i386/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/main.c
+++ linux/arch/i386/kernel/cpu/mtrr/main.c
@@ -729,6 +729,17 @@ void mtrr_ap_init(void)
 	local_irq_restore(flags);
 }
 
+/**
+ * Save current fixed-range MTRR state of the BSP
+ */
+void mtrr_save_state(void)
+{
+	if (smp_processor_id() == 0)
+		mtrr_save_fixed_ranges(NULL);
+	else
+		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
+}
+
 static int __init mtrr_init_finialize(void)
 {
 	if (!mtrr_if)
Index: linux/include/asm-x86_64/mtrr.h
===================================================================
--- linux.orig/include/asm-x86_64/mtrr.h
+++ linux/include/asm-x86_64/mtrr.h
@@ -139,10 +139,12 @@ struct mtrr_gentry32
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 extern void mtrr_save_fixed_ranges(void *);
+extern void mtrr_save_state(void);
 #else
 #define mtrr_ap_init() do {} while (0)
 #define mtrr_bp_init() do {} while (0)
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
+#define mtrr_save_state() do {} while (0)
 #endif
 
 #endif /* __KERNEL__ */
