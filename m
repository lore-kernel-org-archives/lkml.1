Return-Path: <linux-kernel-owner+w=401wt.eu-S965084AbXIKTlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084AbXIKTlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763217AbXIKTlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:41:36 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47292 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763605AbXIKTle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:41:34 -0400
Date: Tue, 11 Sep 2007 21:42:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: Re: [RFC] kbuild - introduce vdir to make life easier for x86_64
Message-ID: <20070911194257.GA9586@uranus.ravnborg.org>
References: <20070910191138.GA31541@uranus.ravnborg.org> <200709110040.41605.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709110040.41605.ak@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 12:40:41AM +0200, Andi Kleen wrote:
> 
> > The below are the minimal clean-up - a bit more could be done.
> > 
> > Comments?
> 
> Looks good in principle. My only suggestion would be to name it something
> differently than vdir. I know that's what GNU make calls it, but it's still
> pretty cryptic. How about just fallback-dir ? 
> 
> Also what would be nice (I don't know if it's doable in make) would
> be a separate variable (e.g. other-obj-... := ) that contains the fallback
> names and that is double checked against the fallback directory. That
> would document it clearly what's going on. Failing that stuffing 
> them into a comment would be good at least.

I did not like the vdir hack for a couple of reasons as partly outline by Andi.
So starting to wonder why the obvious did not work.

For mm/Makefile I wanted to do:

diff --git a/arch/x86_64/mm/Makefile b/arch/x86_64/mm/Makefile
index d25ac86..6f4addf 100644
--- a/arch/x86_64/mm/Makefile
+++ b/arch/x86_64/mm/Makefile
@@ -1,11 +1,10 @@
 #
 # Makefile for the linux x86_64-specific parts of the memory manager.
 #
+i386 := ../../../arch/i386/mm
 
 obj-y	 := init.o fault.o ioremap.o extable.o pageattr.o mmap.o
-obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
+obj-$(CONFIG_HUGETLB_PAGE) += $(i386)/hugetlbpage.o
 obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_K8_NUMA) += k8topology.o
 obj-$(CONFIG_ACPI_NUMA) += srat.o
-
-hugetlbpage-y = ../../i386/mm/hugetlbpage.o

And after wondering a bit I came up with following fix for kbuild:
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index fc498fe..ff03b15 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -46,7 +46,7 @@ multi-objs   := $(multi-objs-y) $(multi-objs-m)
 
 # $(subdir-obj-y) is the list of objects in $(obj-y) which do not live
 # in the local directory
-subdir-obj-y := $(foreach o,$(obj-y),$(if $(filter-out $(o),$(notdir $(o))),$(o)))
+subdir-obj-y := $(filter %/built-in.o, $(obj-y))
 
 # $(obj-dirs) is a list of directories that contain object files
 obj-dirs := $(dir $(multi-objs) $(subdir-obj-y))

subdir-obj-y listed all targets in another dir than current dir
but only needed to list built-in.o targets.

So after fixig this long standing bug in kbuild I could do the attached
cleanup of current x86_64 Makefiles.

I will push the kbuild fix in next merge window but due to the ongoing
merge talk I dunno about the x86_64 patch.
Anyway the kbuild fix needs to be pushed first.

	Sam

 arch/x86_64/kernel/Makefile         |   37 +++++++++++-------------------------
 arch/x86_64/kernel/acpi/Makefile    |   12 ++++-------
 arch/x86_64/kernel/cpufreq/Makefile |   18 +++++------------
 arch/x86_64/mm/Makefile             |    5 +---
 arch/x86_64/pci/Makefile            |   24 ++++++-----------------
 scripts/Makefile.lib                |    2 -
 6 files changed, 33 insertions(+), 65 deletions(-)

diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index ff5d8c9..ac27cc4 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -1,25 +1,26 @@
 #
 # Makefile for the linux kernel.
 #
+i386 := ../../../arch/i386/kernel
 
 extra-y 	:= head.o head64.o init_task.o vmlinux.lds
 EXTRA_AFLAGS	:= -traditional
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_x86_64.o \
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
-		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
-		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o bugs.o \
-		perfctr-watchdog.o
+		setup64.o $(i386)/bootflag.o e820.o reboot.o $(i386)/quirks.o $(i386)/i8237.o \
+		pci-dma.o pci-nommu.o $(i386)/alternative.o hpet.o tsc.o bugs.o \
+		$(i386)/cpu/perfctr-watchdog.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
-obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
+obj-$(CONFIG_X86_MCE)		+= mce.o $(i386)/cpu/mcheck/therm_throt.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd.o
 obj-$(CONFIG_MTRR)		+= ../../i386/kernel/cpu/mtrr/
 obj-$(CONFIG_ACPI)		+= acpi/
-obj-$(CONFIG_X86_MSR)		+= msr.o
-obj-$(CONFIG_MICROCODE)		+= microcode.o
-obj-$(CONFIG_X86_CPUID)		+= cpuid.o
+obj-$(CONFIG_X86_MSR)		+= $(i386)/msr.o
+obj-$(CONFIG_MICROCODE)		+= $(i386)/microcode.o
+obj-$(CONFIG_X86_CPUID)		+= $(i386)/cpuid.o
 obj-$(CONFIG_SMP)		+= smp.o smpboot.o trampoline.o tsc_sync.o
 obj-y				+= apic.o  nmi.o
 obj-y				+= io_apic.o mpparse.o genapic.o genapic_flat.o
@@ -41,23 +42,9 @@ obj-$(CONFIG_AUDIT)		+= audit.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 
-obj-y				+= topology.o
-obj-y				+= intel_cacheinfo.o
-obj-y				+= addon_cpuid_features.o
-obj-y				+= pcspeaker.o
+obj-y				+= $(i386)/topology.o
+obj-y				+= $(i386)/cpu/intel_cacheinfo.o
+obj-y				+= $(i386)/cpu/addon_cpuid_features.o
+obj-y				+= $(i386)/pcspeaker.o
 
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
-
-therm_throt-y                   += ../../i386/kernel/cpu/mcheck/therm_throt.o
-bootflag-y			+= ../../i386/kernel/bootflag.o
-cpuid-$(subst m,y,$(CONFIG_X86_CPUID))  += ../../i386/kernel/cpuid.o
-topology-y                     += ../../i386/kernel/topology.o
-microcode-$(subst m,y,$(CONFIG_MICROCODE))  += ../../i386/kernel/microcode.o
-intel_cacheinfo-y		+= ../../i386/kernel/cpu/intel_cacheinfo.o
-addon_cpuid_features-y		+= ../../i386/kernel/cpu/addon_cpuid_features.o
-quirks-y			+= ../../i386/kernel/quirks.o
-i8237-y				+= ../../i386/kernel/i8237.o
-msr-$(subst m,y,$(CONFIG_X86_MSR))  += ../../i386/kernel/msr.o
-alternative-y			+= ../../i386/kernel/alternative.o
-pcspeaker-y			+= ../../i386/kernel/pcspeaker.o
-perfctr-watchdog-y		+= ../../i386/kernel/cpu/perfctr-watchdog.o
diff --git a/arch/x86_64/kernel/acpi/Makefile b/arch/x86_64/kernel/acpi/Makefile
index 080b996..7879f97 100644
--- a/arch/x86_64/kernel/acpi/Makefile
+++ b/arch/x86_64/kernel/acpi/Makefile
@@ -1,9 +1,7 @@
-obj-y			:= boot.o
-boot-y			:= ../../../i386/kernel/acpi/boot.o
-obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup.o
+i386 := ../../../../arch/i386/kernel/acpi
 
-ifneq ($(CONFIG_ACPI_PROCESSOR),)
-obj-y			+= processor.o
-processor-y		:= ../../../i386/kernel/acpi/processor.o ../../../i386/kernel/acpi/cstate.o
-endif
+obj-y				:= $(i386)/boot.o
+obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup.o
+obj-$(CONFIG_ACPI_PROCESSOR)	+= $(i386)/processor.o
+obj-$(CONFIG_ACPI_PROCESSOR)	+= $(i386)/cstate.o
 
diff --git a/arch/x86_64/kernel/cpufreq/Makefile b/arch/x86_64/kernel/cpufreq/Makefile
index 753ce1d..d8dacae 100644
--- a/arch/x86_64/kernel/cpufreq/Makefile
+++ b/arch/x86_64/kernel/cpufreq/Makefile
@@ -2,16 +2,10 @@
 # Reuse the i386 cpufreq drivers
 #
 
-SRCDIR := ../../../i386/kernel/cpu/cpufreq
+i386 := ../../../i386/kernel/cpu/cpufreq
 
-obj-$(CONFIG_X86_POWERNOW_K8) += powernow-k8.o
-obj-$(CONFIG_X86_ACPI_CPUFREQ) += acpi-cpufreq.o
-obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO) += speedstep-centrino.o
-obj-$(CONFIG_X86_P4_CLOCKMOD) += p4-clockmod.o
-obj-$(CONFIG_X86_SPEEDSTEP_LIB) += speedstep-lib.o
-
-powernow-k8-objs := ${SRCDIR}/powernow-k8.o
-speedstep-centrino-objs := ${SRCDIR}/speedstep-centrino.o
-acpi-cpufreq-objs := ${SRCDIR}/acpi-cpufreq.o
-p4-clockmod-objs := ${SRCDIR}/p4-clockmod.o
-speedstep-lib-objs := ${SRCDIR}/speedstep-lib.o
+obj-$(CONFIG_X86_POWERNOW_K8)		+= $(i386)/powernow-k8.o
+obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= $(i386)/acpi-cpufreq.o
+obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO)	+= $(i386)/speedstep-centrino.o
+obj-$(CONFIG_X86_P4_CLOCKMOD)		+= $(i386)/p4-clockmod.o
+obj-$(CONFIG_X86_SPEEDSTEP_LIB)		+= $(i386)/speedstep-lib.o
diff --git a/arch/x86_64/mm/Makefile b/arch/x86_64/mm/Makefile
index d25ac86..6f4addf 100644
--- a/arch/x86_64/mm/Makefile
+++ b/arch/x86_64/mm/Makefile
@@ -1,11 +1,10 @@
 #
 # Makefile for the linux x86_64-specific parts of the memory manager.
 #
+i386 := ../../../arch/i386/mm
 
 obj-y	 := init.o fault.o ioremap.o extable.o pageattr.o mmap.o
-obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
+obj-$(CONFIG_HUGETLB_PAGE) += $(i386)/hugetlbpage.o
 obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_K8_NUMA) += k8topology.o
 obj-$(CONFIG_ACPI_NUMA) += srat.o
-
-hugetlbpage-y = ../../i386/mm/hugetlbpage.o
diff --git a/arch/x86_64/pci/Makefile b/arch/x86_64/pci/Makefile
index c9eddc8..6f69df2 100644
--- a/arch/x86_64/pci/Makefile
+++ b/arch/x86_64/pci/Makefile
@@ -3,25 +3,15 @@
 #
 # Reuse the i386 PCI subsystem
 #
+i386 := ../../../arch/i386/pci
 EXTRA_CFLAGS += -Iarch/i386/pci
 
-obj-y		:= i386.o
-obj-$(CONFIG_PCI_DIRECT)+= direct.o
-obj-y		+= fixup.o init.o
-obj-$(CONFIG_ACPI)	+= acpi.o
-obj-y			+= legacy.o irq.o common.o early.o
+obj-y			:= $(i386)/i386.o
+obj-$(CONFIG_PCI_DIRECT)+= $(i386)/direct.o
+obj-y			+= $(i386)/fixup.o init.o
+obj-$(CONFIG_ACPI)	+= $(i386)/acpi.o
+obj-y			+= $(i386)/legacy.o $(i386)/irq.o $(i386)/common.o $(i386)/early.o
 # mmconfig has a 64bit special
-obj-$(CONFIG_PCI_MMCONFIG) += mmconfig.o direct.o mmconfig-shared.o
+obj-$(CONFIG_PCI_MMCONFIG) += mmconfig.o $(i386)/direct.o $(i386)/mmconfig-shared.o
 
 obj-$(CONFIG_NUMA)	+= k8-bus.o
-
-direct-y += ../../i386/pci/direct.o
-acpi-y   += ../../i386/pci/acpi.o
-legacy-y += ../../i386/pci/legacy.o
-irq-y    += ../../i386/pci/irq.o
-common-y += ../../i386/pci/common.o
-fixup-y  += ../../i386/pci/fixup.o
-i386-y  += ../../i386/pci/i386.o
-init-y += ../../i386/pci/init.o
-early-y += ../../i386/pci/early.o
-mmconfig-shared-y += ../../i386/pci/mmconfig-shared.o
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index fc498fe..ff03b15 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -46,7 +46,7 @@ multi-objs   := $(multi-objs-y) $(multi-objs-m)
 
 # $(subdir-obj-y) is the list of objects in $(obj-y) which do not live
 # in the local directory
-subdir-obj-y := $(foreach o,$(obj-y),$(if $(filter-out $(o),$(notdir $(o))),$(o)))
+subdir-obj-y := $(filter %/built-in.o, $(obj-y))
 
 # $(obj-dirs) is a list of directories that contain object files
 obj-dirs := $(dir $(multi-objs) $(subdir-obj-y))
