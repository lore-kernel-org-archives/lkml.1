Return-Path: <linux-kernel-owner+w=401wt.eu-S965571AbXIJTK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571AbXIJTK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbXIJTKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:10:17 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53582 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbXIJTKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:10:15 -0400
Date: Mon, 10 Sep 2007 21:11:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: [RFC] kbuild - introduce vdir to make life easier for x86_64
Message-ID: <20070910191138.GA31541@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi & Thomas.

One of the complaints raised about the current x86_64
Makfiles are the ugliness needed to reuse code from i386.
Andi asked me if we could do something in kbuild to make
this less ugly and below are the hack I could come up with.

The trick is that in the Makefile we tell kbuild what directory
to search for source files should we fail to locate them in
current directory. This is done by an assingment to the variable
named 'vdir' - a counterpart to make's vpath but it takes only a single
directory and not a list.

In Makefile.build I added an additional rule (see last part of the patch)
that tell kbuild that it may find the sourcefile in vdir if not
present in current dir.
This allowed me to delete some cruft from the current x86_64 makefiles.

The below are the minimal clean-up - a bit more could be done.

Comments?

This is obviously only a RFC patch - I have not even bothered to update
the documentation to describe vdir...

	Sam

 arch/x86_64/kernel/Makefile |   11 +----------
 arch/x86_64/mm/Makefile     |    3 +--
 arch/x86_64/pci/Makefile    |   12 +-----------
 scripts/Makefile.build      |    4 ++++
 4 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index ff5d8c9..fe58ac6 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the linux kernel.
 #
-
+vdir := arch/i386/kernel
 extra-y 	:= head.o head64.o init_task.o vmlinux.lds
 EXTRA_AFLAGS	:= -traditional
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
@@ -49,15 +49,6 @@ obj-y				+= pcspeaker.o
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
 
 therm_throt-y                   += ../../i386/kernel/cpu/mcheck/therm_throt.o
-bootflag-y			+= ../../i386/kernel/bootflag.o
-cpuid-$(subst m,y,$(CONFIG_X86_CPUID))  += ../../i386/kernel/cpuid.o
-topology-y                     += ../../i386/kernel/topology.o
-microcode-$(subst m,y,$(CONFIG_MICROCODE))  += ../../i386/kernel/microcode.o
 intel_cacheinfo-y		+= ../../i386/kernel/cpu/intel_cacheinfo.o
 addon_cpuid_features-y		+= ../../i386/kernel/cpu/addon_cpuid_features.o
-quirks-y			+= ../../i386/kernel/quirks.o
-i8237-y				+= ../../i386/kernel/i8237.o
-msr-$(subst m,y,$(CONFIG_X86_MSR))  += ../../i386/kernel/msr.o
-alternative-y			+= ../../i386/kernel/alternative.o
-pcspeaker-y			+= ../../i386/kernel/pcspeaker.o
 perfctr-watchdog-y		+= ../../i386/kernel/cpu/perfctr-watchdog.o
diff --git a/arch/x86_64/mm/Makefile b/arch/x86_64/mm/Makefile
index d25ac86..3d61425 100644
--- a/arch/x86_64/mm/Makefile
+++ b/arch/x86_64/mm/Makefile
@@ -1,11 +1,10 @@
 #
 # Makefile for the linux x86_64-specific parts of the memory manager.
 #
+vdir := arch/i386/mm
 
 obj-y	 := init.o fault.o ioremap.o extable.o pageattr.o mmap.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_K8_NUMA) += k8topology.o
 obj-$(CONFIG_ACPI_NUMA) += srat.o
-
-hugetlbpage-y = ../../i386/mm/hugetlbpage.o
diff --git a/arch/x86_64/pci/Makefile b/arch/x86_64/pci/Makefile
index c9eddc8..84247e6 100644
--- a/arch/x86_64/pci/Makefile
+++ b/arch/x86_64/pci/Makefile
@@ -3,6 +3,7 @@
 #
 # Reuse the i386 PCI subsystem
 #
+vdir := arch/i386/pci
 EXTRA_CFLAGS += -Iarch/i386/pci
 
 obj-y		:= i386.o
@@ -14,14 +15,3 @@ obj-y			+= legacy.o irq.o common.o early.o
 obj-$(CONFIG_PCI_MMCONFIG) += mmconfig.o direct.o mmconfig-shared.o
 
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
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 7fd6055..e979833 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -218,6 +218,10 @@ $(obj)/%.o: $(src)/%.c FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 
+$(obj)/%.o: $(vdir)/%.c FORCE
+	$(call cmd,force_checksrc)
+	$(call if_changed_rule,cc_o_c)
+
 # Single-part modules are special since we need to mark them in $(MODVERDIR)
 
 $(single-used-m): $(obj)/%.o: $(src)/%.c FORCE
