Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbXL3IaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbXL3IaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 03:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXL3I3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 03:29:54 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:35196 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbXL3I3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 03:29:53 -0500
Date: Sun, 30 Dec 2007 09:29:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH - RFC] x86: unify arch/x86/kernel/Makefile(s)
Message-ID: <20071230082952.GA12327@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine the 32 and 64 bit specific Makefiles in one file.
While doing so link order was (almost) preserved on 32 bit
but on 64 bit link order changed a lot.

Patch was checked with defconfig + allyesconfig builds.
The same .o files were linked in these configurations.

To keep readability of the Makefiles a few Kconfig
symbols was added/modified and it was checked that
they were not used anywhere else.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

I do not have a proper test-system so this patch is
not boot tested - sorry.
For 32 bit it is low-risk.
For 64 bit it needs to be boot tested - anyone?

Patch is made on top of mm branch of x86 tree.

	Sam

 arch/x86/Kconfig            |   10 ++++-
 arch/x86/Kconfig.debug      |    3 +-
 arch/x86/kernel/Makefile    |   93 +++++++++++++++++++++++++++++++++++++++----
 arch/x86/kernel/Makefile_32 |   54 -------------------------
 arch/x86/kernel/Makefile_64 |   52 ------------------------
 5 files changed, 95 insertions(+), 117 deletions(-)
 delete mode 100644 arch/x86/kernel/Makefile_32
 delete mode 100644 arch/x86/kernel/Makefile_64

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 581058a..e6fe276 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -132,9 +132,17 @@ config GENERIC_PENDING_IRQ
 
 config X86_SMP
 	bool
-	depends on X86_32 && SMP && !X86_VOYAGER
+	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
 	default y
 
+config X86_32_SMP
+	def_bool y
+	depends on X86_32 && SMP
+
+config X86_64_SMP
+	def_bool y
+	depends on X86_64 && SMP
+
 config X86_HT
 	bool
 	depends on SMP
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 77eda46..625e6bf 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -75,8 +75,7 @@ config X86_FIND_SMP_CONFIG
 
 config X86_MPPARSE
 	def_bool y
-	depends on X86_LOCAL_APIC && !X86_VISWS
-	depends on X86_32
+	depends on (X86_32 && (X86_LOCAL_APIC && !X86_VISWS)) || X86_64
 
 config DOUBLEFAULT
 	default y
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 3857334..0903bbf 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -1,9 +1,86 @@
-ifeq ($(CONFIG_X86_32),y)
-include ${srctree}/arch/x86/kernel/Makefile_32
-else
-include ${srctree}/arch/x86/kernel/Makefile_64
-endif
+#
+# Makefile for the linux kernel.
+#
+
+extra-y                := head_$(BITS).o init_task.o vmlinux.lds
+extra-$(CONFIG_X86_64) += head64.o
+
+CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
+CFLAGS_vsyscall_64.o := $(PROFILING) -g0
+
+obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
+obj-y			+= traps_$(BITS).o irq_$(BITS).o
+obj-y			+= time_$(BITS).o ioport_$(BITS).o ldt.o
+obj-y			+= setup_$(BITS).o i8259_$(BITS).o
+obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
+obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
+obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o setup64.o
+obj-y			+= pci-dma_$(BITS).o  bootflag.o e820_$(BITS).o
+obj-y			+= quirks.o i8237.o topology.o
+obj-y			+= alternative.o i8253.o
+obj-$(CONFIG_X86_64)	+= pci-nommu_64.o bugs_64.o
+obj-y			+= tsc_$(BITS).o io_delay.o rtc.o
+
+obj-y				+= i387.o
+obj-y				+= ptrace.o
+obj-y				+= ds.o
+obj-$(CONFIG_X86_32)		+= tls.o
+obj-$(CONFIG_IA32_EMULATION)	+= tls.o
+obj-y				+= step.o
+obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
+obj-y				+= cpu/
+obj-y				+= acpi/
+obj-$(CONFIG_X86_BIOS_REBOOT)	+= reboot_32.o
+obj-$(CONFIG_X86_64)            += reboot_64.o
+obj-$(CONFIG_MCA)		+= mca_32.o
+obj-$(CONFIG_X86_MSR)		+= msr.o
+obj-$(CONFIG_X86_CPUID)		+= cpuid.o
+obj-$(CONFIG_MICROCODE)		+= microcode.o
+obj-$(CONFIG_PCI)		+= early-quirks.o
+obj-$(CONFIG_APM)		+= apm_32.o
+obj-$(CONFIG_X86_SMP)		+= smp_$(BITS).o smpboot_$(BITS).o tsc_sync.o
+obj-$(CONFIG_X86_32_SMP)	+= smpcommon_32.o
+obj-$(CONFIG_X86_64_SMP)	+= smp_64.o smpboot_64.o tsc_sync.o
+obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
+obj-$(CONFIG_X86_MPPARSE)	+= mpparse_$(BITS).o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_$(BITS).o nmi_$(BITS).o
+obj-$(CONFIG_X86_IO_APIC)	+= io_apic_$(BITS).o
+obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
+obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
+obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
+obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
+obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
+obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
+obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
+obj-$(CONFIG_KPROBES)		+= kprobes.o
+obj-$(CONFIG_MODULES)		+= module_$(BITS).o
+obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
+obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
+obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
+obj-$(CONFIG_VM86)		+= vm86_32.o
+obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+
+obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 
-# Workaround to delete .lds files with make clean
-# The problem is that we do not enter Makefile_32 with make clean.
-clean-files := vsyscall*.lds vsyscall*.so
+obj-$(CONFIG_K8_NB)		+= k8.o
+obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
+
+obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
+obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
+obj-y				+= pcspeaker.o
+
+obj-$(CONFIG_SCx200)		+= scx200_32.o
+
+###
+# 64 bit specific files
+ifeq ($(CONFIG_X86_64),y)
+        obj-y				+= genapic_64.o genapic_flat_64.o
+        obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
+        obj-$(CONFIG_AUDIT)		+= audit_64.o
+        obj-$(CONFIG_PM)		+= suspend_64.o
+        obj-$(CONFIG_HIBERNATION)	+= suspend_asm_64.o
+
+        obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
+        obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
+        obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
+endif
diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
deleted file mode 100644
index 86c6327..0000000
--- a/arch/x86/kernel/Makefile_32
+++ /dev/null
@@ -1,54 +0,0 @@
-#
-# Makefile for the linux kernel.
-#
-
-extra-y := head_32.o init_task.o vmlinux.lds
-CPPFLAGS_vmlinux.lds += -Ui386
-
-obj-y	:= process_32.o signal_32.o entry_32.o traps_32.o irq_32.o \
-		time_32.o ioport_32.o ldt.o setup_32.o i8259_32.o sys_i386_32.o \
-		pci-dma_32.o i386_ksyms_32.o bootflag.o e820_32.o\
-		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o io_delay.o rtc.o
-
-obj-y				+= i387.o
-obj-y				+= ptrace.o
-obj-y				+= ds.o
-obj-y				+= tls.o
-obj-y				+= step.o
-obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
-obj-y				+= cpu/
-obj-y				+= acpi/
-obj-$(CONFIG_X86_BIOS_REBOOT)	+= reboot_32.o
-obj-$(CONFIG_MCA)		+= mca_32.o
-obj-$(CONFIG_X86_MSR)		+= msr.o
-obj-$(CONFIG_X86_CPUID)		+= cpuid.o
-obj-$(CONFIG_MICROCODE)		+= microcode.o
-obj-$(CONFIG_PCI)		+= early-quirks.o
-obj-$(CONFIG_APM)		+= apm_32.o
-obj-$(CONFIG_X86_SMP)		+= smp_32.o smpboot_32.o tsc_sync.o
-obj-$(CONFIG_SMP)		+= smpcommon_32.o
-obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_32.o
-obj-$(CONFIG_X86_MPPARSE)	+= mpparse_32.o
-obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_32.o nmi_32.o
-obj-$(CONFIG_X86_IO_APIC)	+= io_apic_32.o
-obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
-obj-$(CONFIG_KEXEC)		+= machine_kexec_32.o relocate_kernel_32.o crash.o
-obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_32.o
-obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
-obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
-obj-$(CONFIG_KPROBES)		+= kprobes.o
-obj-$(CONFIG_MODULES)		+= module_32.o
-obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
-obj-$(CONFIG_EFI) 		+= efi.o efi_32.o efi_stub_32.o
-obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
-obj-$(CONFIG_VM86)		+= vm86_32.o
-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
-obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
-obj-$(CONFIG_K8_NB)		+= k8.o
-obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
-
-obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
-obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_32.o
-obj-y				+= pcspeaker.o
-
-obj-$(CONFIG_SCx200)		+= scx200_32.o
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
deleted file mode 100644
index b8f9d13..0000000
--- a/arch/x86/kernel/Makefile_64
+++ /dev/null
@@ -1,52 +0,0 @@
-#
-# Makefile for the linux kernel.
-#
-
-extra-y 	:= head_64.o head64.o init_task.o vmlinux.lds
-CPPFLAGS_vmlinux.lds += -Ux86_64
-
-obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
-		time_64.o ioport_64.o ldt.o setup_64.o i8259_64.o sys_x86_64.o \
-		x8664_ksyms_64.o syscall_64.o vsyscall_64.o \
-		setup64.o bootflag.o e820_64.o reboot_64.o quirks.o i8237.o \
-		pci-dma_64.o pci-nommu_64.o alternative.o hpet.o tsc_64.o bugs_64.o \
-		i8253.o io_delay.o rtc.o
-
-obj-y				+= ptrace.o
-obj-y				+= ds.o
-obj-y				+= step.o
-
-obj-y				+= i387.o
-obj-$(CONFIG_IA32_EMULATION)	+= tls.o
-obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
-obj-y				+= cpu/
-obj-y				+= acpi/
-obj-$(CONFIG_X86_MSR)		+= msr.o
-obj-$(CONFIG_MICROCODE)		+= microcode.o
-obj-$(CONFIG_X86_CPUID)		+= cpuid.o
-obj-$(CONFIG_SMP)		+= smp_64.o smpboot_64.o trampoline_64.o tsc_sync.o
-obj-y				+= apic_64.o  nmi_64.o
-obj-y				+= io_apic_64.o mpparse_64.o genapic_64.o genapic_flat_64.o
-obj-$(CONFIG_KEXEC)		+= machine_kexec_64.o relocate_kernel_64.o crash.o
-obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_64.o
-obj-$(CONFIG_PM)		+= suspend_64.o
-obj-$(CONFIG_HIBERNATION)	+= suspend_asm_64.o
-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
-obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
-obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
-obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
-obj-$(CONFIG_KPROBES)		+= kprobes.o
-obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
-obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
-obj-$(CONFIG_K8_NB)		+= k8.o
-obj-$(CONFIG_AUDIT)		+= audit_64.o
-obj-$(CONFIG_EFI)		+= efi.o efi_64.o efi_stub_64.o
-obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_64.o
-
-obj-$(CONFIG_MODULES)		+= module_64.o
-obj-$(CONFIG_PCI)		+= early-quirks.o
-
-obj-y				+= topology.o
-obj-y				+= pcspeaker.o
-
-CFLAGS_vsyscall_64.o		:= $(PROFILING) -g0
-- 
1.5.3.7.1112.g9758e

