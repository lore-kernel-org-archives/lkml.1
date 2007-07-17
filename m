Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbXGQK7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbXGQK7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 06:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXGQK7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 06:59:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:1559 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbXGQK7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 06:59:04 -0400
Date: Tue, 17 Jul 2007 12:59:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jonathan Campbell <jon@nerdgrounds.com>
cc: linux-kernel@vger.kernel.org, torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
In-Reply-To: <469A8AED.7070207@nerdgrounds.com>
Message-ID: <Pine.LNX.4.64.0707171240040.686@fbirervta.pbzchgretzou.qr>
References: <469A8AED.7070207@nerdgrounds.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 15 2007 14:00, Jonathan Campbell wrote:
>
> These patches were written against the vanilla 2.6.21.1 kernel. They will have
> no effect UNLESS you make menuconfig and explicitly enable them there.
>
>
inline patches...

>+config X86_DONT_CPUID
>+	bool "Disable CPUID support"
>+	depends on M386 || M486

I think this should not depend on any model.
Depend on x86 at best.

	depends on X86

>+	default n

And perhaps it would be helpful to invert it, like the other options, i.e.:

config X86_CPUID
	bool "Enable CPUID support" if X86 && EMBEDDED
	default y

>+	---help---
>+	  Enable this option if your kernel is strictly intended to run on legacy
>+	  386/486 systems that don't have CPUID. This option disables all CPU detection
>+	  code that is not relevant to pre-Pentium systems.
>+
> config X86_MCE_NONFATAL
> 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
> 	depends on X86_MCE
>@@ -444,6 +453,16 @@
> 	  enable this option even if you don't need it.
> 	  Say N otherwise.
> 
>+config X86_TSC
>+	bool "Enable X86 use TSC timesource"
>+	depends on X86_PC

This is wrong, it should be "X86", not "X86_PC".

12:43 ichi:/boot > grep CONFIG_X86 config-2.6.20.15-ccj49-default | head -n12
CONFIG_X86_32=y
CONFIG_X86=y
# CONFIG_X86_PC is not set
# CONFIG_X86_XEN is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
CONFIG_X86_GENERICARCH=y
# CONFIG_X86_ES7000 is not set

>@@ -7,7 +7,11 @@
> obj-y	:= process.o signal.o entry.o traps.o irq.o \
> 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_i386.o \
> 		pci-dma.o i386_ksyms.o i387.o bootflag.o e820.o\
>-		quirks.o i8237.o topology.o alternative.o i8253.o tsc.o
>+		quirks.o i8237.o topology.o alternative.o i8253.o
>+
>+ifdef CONFIG_X86_TSC
>+obj-y	:= tsc.o
>+endif

Use obj-$(CONFIG_X86_TSC) += tsc.o

> obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
> obj-y				+= cpu/
>diff -r -u linux-2.6.21.1/arch/i386/kernel/cpu/Makefile linux-2.6.21.1-386/arch/i386/kernel/cpu/Makefile
>--- linux-2.6.21.1/arch/i386/kernel/cpu/Makefile	2007-04-27 21:49:26.000000000 +0000
>+++ linux-2.6.21.1-386/arch/i386/kernel/cpu/Makefile	2007-07-03 13:17:57.000000000 +0000
>@@ -4,14 +4,18 @@
> 
> obj-y	:=	common.o proc.o
> 
>+ifndef CONFIG_X86_DONT_CPUID
> obj-y	+=	amd.o
> obj-y	+=	cyrix.o
> obj-y	+=	centaur.o
> obj-y	+=	transmeta.o
>+endif
> obj-y	+=	intel.o intel_cacheinfo.o
>+ifndef CONFIG_X86_DONT_CPUID
> obj-y	+=	rise.o
> obj-y	+=	nexgen.o
> obj-y	+=	umc.o
>+endif

With above's inversion,

obj-y                   += intel.o intel_cacheinfo.o
obj-$(CONFIG_X86_CPUID) += amd.o cyrix.o centaur.o transmeta.o \
                           rise.o nexgen.o umc.o

simple, is not it?

>@@ -231,6 +239,9 @@
> 
> 
> /* Probe for the CPUID instruction */
>+#ifdef CONFIG_X86_DONT_CPUID
>+#  define have_cpuid_p() ((int)0)
>+#else

There is absolutely zero need for that cast.

>+#ifndef CONFIG_X86_DONT_CPUID
> static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
> {
> 	if (cpu_has(c, X86_FEATURE_PN) && disable_x86_serial_nr ) {
>@@ -362,7 +382,7 @@
> 	return 1;
> }
> __setup("serialnumber", x86_serial_nr_setup);
>-
>+#endif

It would be nice if not so much #ifdefs were introduced.
>@@ -465,6 +493,7 @@
> 		printk(" %08lx", c->x86_capability[i]);
> 	printk("\n");
> 
>+#ifdef CONFIG_SMP
> 	/*
> 	 * On SMP, boot_cpu_data holds the common feature set between
> 	 * all CPUs; so make sure that we indicate which features are
>@@ -476,6 +505,7 @@
> 		for ( i = 0 ; i < NCAPINTS ; i++ )
> 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
> 	}
>+#endif
> 
> 	/* Init Machine Check Exception if available. */
> 	mcheck_init(c);

This change seems out of place.

>+#ifdef CONFIG_X86_DONT_CPUID
>+#  define cpuid		__EVIL__EVIL__EVIL__
>+#  define cpuid_eax	__EVIL__EVIL__EVIL__
>+#  define cpuid_count	__EVIL__EVIL__EVIL__
>+#endif

Is this really needed?

>+config IDE_DONT_PIO
>+	bool "Disable IDE PIO modes"
>+	default n
>+	---help---
>+	  If you are building a Linux kernel for really old 386/486 systems you
>+	  can enable this option to cut out all support for PIO transfers.

While this feature looks interesting for *new* systems,
what would *old* systems be left with, if not PIO?
Note they do not have DMA. (Or at least the generic IDE driver does not have
it.)

>@@ -163,18 +163,24 @@
> {
> 	ide_hwif_t *hwif	= HWIF(drive);
> 	unsigned int dma	= drive->using_dma;
>+#ifndef CONFIG_IDE_DISABLE_LBA48
> 	u8 lba48		= (drive->addressing == 1) ? 1 : 0;
>+#else
>+#  define lba48 ((u8)0)
>+#endif

Needless cast again.

>@@ -484,7 +490,9 @@
> static void idedisk_check_hpa(ide_drive_t *drive)
> {
> 	unsigned long long capacity, set_max;
>+#ifndef CONFIG_IDE_DISABLE_LBA48
> 	int lba48 = idedisk_supports_lba48(drive->id);
>+#endif
> 
> 	capacity = drive->capacity64;
> 	if (lba48)

As for the amount of #preprocessor directives mentioned earlier, this one
could go into idedisk_supports_lba48,
(also note that inverting DISABLE_LBA48 seems better to me), i.e.

idedisk_supports_lba48(...)
{
#ifndef CONFIG_IDE_DISABLE_LBA48
	find_out();
#else
	return 0;
#endif
}

>@@ -98,8 +98,12 @@
> {
> 	ide_hwif_t *hwif	= HWIF(drive);
> 	task_struct_t *taskfile	= (task_struct_t *) task->tfRegister;
>+#ifndef CONFIG_IDE_DISABLE_LBA48
> 	hob_struct_t *hobfile	= (hob_struct_t *) task->hobRegister;
> 	u8 HIHI			= (drive->addressing == 1) ? 0xE0 : 0xEF;
>+#else
>+#  define HIHI ((u8)0)
>+#endif

Nocast.




	Jan
-- 
