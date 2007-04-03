Return-Path: <linux-kernel-owner+w=401wt.eu-S1030259AbXDCOVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbXDCOVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030274AbXDCOVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:21:05 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:50610 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030259AbXDCOVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:21:04 -0400
Date: Tue, 3 Apr 2007 16:00:36 +0200 (CEST)
From: Bernhard Kaindl <bk@suse.de>
To: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jan Beulich <jbeulich@novell.com>
Subject: [PATCH 2/4] Save the MTRRs of the BSP before booting an AP
In-Reply-To: <Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
Message-ID: <Pine.LNX.4.64.0704031559080.7626@jbgna.fhfr.qr>
References: <Pine.LNX.4.64.0703211730140.2519@jbgna.fhfr.qr>
 <200703272213.51947.ak@suse.de> <Pine.LNX.4.64.0703281155490.17746@jbgna.fhfr.qr>
 <200703291525.59116.ak@suse.de> <Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While I haven't found this as cause of the MTRR suspend issue on the
Ferraris, AMD and Intel x86 CPU manuals state that it is the responsibility
of system software to initialize and maintain MTRR consistency across
all processors in Multi-Processing Environments:

Quote from page 188 of the AMD64 System Programming manual (Volume 2):

-----------------------------------------------------------------------------
7.6.5 MTRRs in Multi-Processing Environments

"In multi-processing environments, the MTRRs located in all processors must
characterize memory in the same way. Generally, this means that identical
values are written to the MTRRs used by the processors." (short omission here)
"Failure to do so may result in coherency violations or loss of atomicity.
Processor implementations do not check the MTRR settings in other processors
to ensure consistency. It is the responsibility of system software to
initialize and maintain MTRR consistency across all processors."
-----------------------------------------------------------------------------

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

Possible TODOs:

*) CPU-hotplugging outside of SMP suspend/resume is not yet tested
   with this patch.

*) If, even in this case, an AP never runs i386/do_boot_cpu or x86_64/cpu_up,
   then the calls to mtrr_save_state() could be replaced by calls to
   mtrr_save_fixed_ranges(NULL) and  mtrr_save_state() would not be
   needed.

   That would need either verification of the CPU-hotplug code.

*) The MTRRs of other running processors are not yet checked at this
   time but it might be interesting to syncronize the MTTRs of all
   processors before booting new CPUs. That would be an incremental
   patch, of rather low priority since there is no machine known so
   far which would require this.

Signed-off-by: Bernhard Kaindl <bk@suse.de>

--- linux-2.6.20.orig/arch/i386/kernel/smpboot.c
+++ linux-2.6.20/arch/i386/kernel/smpboot.c
@@ -59,6 +59,7 @@
 #include <asm/nmi.h>
 #include <asm/pda.h>
 #include <asm/genapic.h>
+#include <asm/mtrr.h>

 #include <mach_apic.h>
 #include <mach_wakecpu.h>
@@ -951,6 +952,12 @@ static int __cpuinit do_boot_cpu(int api
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
Index: linux-2.6.20/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux-2.6.20.orig/arch/x86_64/kernel/smpboot.c
+++ linux-2.6.20/arch/x86_64/kernel/smpboot.c
@@ -1157,6 +1157,12 @@ int __cpuinit __cpu_up(unsigned int cpu)
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
Index: linux-2.6.20/include/asm-i386/mtrr.h
===================================================================
--- linux-2.6.20.orig/include/asm-i386/mtrr.h
+++ linux-2.6.20/include/asm-i386/mtrr.h
@@ -25,6 +25,7 @@

 #include <linux/ioctl.h>
 #include <linux/errno.h>
+#include <linux/smp.h>

 #define	MTRR_IOCTL_BASE	'M'

@@ -70,6 +71,16 @@ struct mtrr_gentry
 /*  The following functions are for use by other drivers  */
 # ifdef CONFIG_MTRR
 extern void mtrr_save_fixed_ranges(void *);
+/**
+ * Save current fixed-range MTRR state of the BSP
+ */
+static __inline__ void mtrr_save_state (void)
+{
+	if (smp_processor_id() == 0)
+		mtrr_save_fixed_ranges(NULL);
+	else
+		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
+}
 extern int mtrr_add (unsigned long base, unsigned long size,
 		     unsigned int type, char increment);
 extern int mtrr_add_page (unsigned long base, unsigned long size,
@@ -81,6 +92,7 @@ extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 #  else
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
+#define mtrr_save_state() do {} while (0)
 static __inline__ int mtrr_add (unsigned long base, unsigned long size,
 				unsigned int type, char increment)
 {
Index: linux-2.6.20/include/asm-x86_64/proto.h
===================================================================
--- linux-2.6.20.orig/include/asm-x86_64/proto.h
+++ linux-2.6.20/include/asm-x86_64/proto.h
@@ -2,6 +2,7 @@
 #define _ASM_X8664_PROTO_H 1

 #include <asm/ldt.h>
+#include <linux/smp.h>

 /* misc architecture specific prototypes */

@@ -20,10 +21,21 @@ extern void mcheck_init(struct cpuinfo_x
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 extern void mtrr_save_fixed_ranges(void *);
+static __inline__ void mtrr_save_state (void)
+{
+	/*
+	 * Save current fixed-range MTRR state of the BSP:
+	 */
+	if (smp_processor_id() == 0)
+		mtrr_save_fixed_ranges(NULL);
+	else
+		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
+}
 #else
 #define mtrr_ap_init() do {} while (0)
 #define mtrr_bp_init() do {} while (0)
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
+#define mtrr_save_state() do {} while (0)
 #endif
 extern void init_memory_mapping(unsigned long start, unsigned long end);

If CONFIG_MTRR is not set, we define mtrr_save_state
as an empty statement because there is nothing to do.

