Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbYG3Mvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbYG3Mvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYG3Mv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:51:29 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:12968 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYG3Mv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:51:27 -0400
Date: Wed, 30 Jul 2008 14:49:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86: use arch/x86/include
Message-ID: <20080730124952.GA23413@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi x86 guys.


It turned out to be easy to enable um to use
arch/x86/include so here is a git pull.

The majority is the renames and the real changes are the
diff below.
I have included the um bits too as the changes belongs together.

The commit can be pulled from:

    git://git.kernel.org/pub/scm/linux/kernel/git/sam/x86.git master


See below for full pull request.

	Sam

diff --git a/arch/um/Makefile b/arch/um/Makefile
index ca40397..4a19886 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -156,9 +156,21 @@ include/asm-um/arch:
 	@echo '  SYMLINK $@'
 ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
-	$(Q)ln -fsn $(srctree)/include/asm-$(HEADER_ARCH) include/asm-um/arch
+	$(Q)if [ -d $(srctree)/arch/$(HEADER_ARCH)/include/asm ]; then  \
+		ln -fsn $(srctree)/arch/$(HEADER_ARCH)/include/asm      \
+		        include/asm-um/arch;                            \
+	else                                                            \
+		ln -fsn $(srctree)/include/asm-$(HEADER_ARCH)           \
+		        include/asm-um/arch;                            \
+	fi
 else
-	$(Q)cd $(srctree)/include/asm-um && ln -fsn ../asm-$(HEADER_ARCH) arch
+	$(Q)if [ -d arch/$(HEADER_ARCH)/include/asm ]; then             \
+		ln -fsn $(srctree)/arch/$(HEADER_ARCH)/include/asm      \
+                        include/asm-um/arch;                            \
+	else                                                            \
+		cd $(srctree)/include/asm-um &&                         \
+		ln -fsn ../asm-$(HEADER_ARCH) arch;                     \
+	fi
 endif
 
 $(objtree)/$(ARCH_DIR)/include:
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f5631da..c7493e7 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -110,16 +110,16 @@ KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
 mcore-y  := arch/x86/mach-default/
 
 # Voyager subarch support
-mflags-$(CONFIG_X86_VOYAGER)	:= -Iinclude/asm-x86/mach-voyager
+mflags-$(CONFIG_X86_VOYAGER)	:= -Iarch/x86/include/mach-voyager
 mcore-$(CONFIG_X86_VOYAGER)	:= arch/x86/mach-voyager/
 
 # generic subarchitecture
-mflags-$(CONFIG_X86_GENERICARCH):= -Iinclude/asm-x86/mach-generic
+mflags-$(CONFIG_X86_GENERICARCH):= -Iarch/x86/include/mach-generic
 fcore-$(CONFIG_X86_GENERICARCH)	+= arch/x86/mach-generic/
 mcore-$(CONFIG_X86_GENERICARCH)	:= arch/x86/mach-default/
 
 # default subarch .h files
-mflags-y += -Iinclude/asm-x86/mach-default
+mflags-y += -Iarch/x86/include/mach-default
 
 # 64 bit does not support subarch support - clear sub arch variables
 fcore-$(CONFIG_X86_64)  :=
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index 366f8c7..41564b1 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -119,5 +119,5 @@ sed -n -e '/^\#define/ { s/[^_]*__NR_\([^[:space:]]*\).*/\
 \#endif/p }' $1
 }
 
-(ignore_list && syscall_list ${srctree}/include/asm-x86/unistd_32.h) | \
+(ignore_list && syscall_list ${srctree}/arch/x86/include/asm/unistd_32.h) | \
 $* -E -x c - > /dev/null





The following changes since commit 6e86841d05f371b5b9b86ce76c02aaee83352298:
  Linus Torvalds (1):
        Linux 2.6.27-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/x86.git master

Sam Ravnborg (1):
      x86: use arch/x86/include

 arch/um/Makefile                                   |   16 ++++++++++++++--
 arch/x86/Makefile                                  |    6 +++---
 {include/asm-x86 => arch/x86/include/asm}/Kbuild   |    0
 .../asm-x86 => arch/x86/include/asm}/a.out-core.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/a.out.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/acpi.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/agp.h    |    0
 .../x86/include/asm}/alternative-asm.h             |    0
 .../asm-x86 => arch/x86/include/asm}/alternative.h |    0
 .../asm-x86 => arch/x86/include/asm}/amd_iommu.h   |    0
 .../x86/include/asm}/amd_iommu_types.h             |    0
 {include/asm-x86 => arch/x86/include/asm}/apic.h   |    0
 .../asm-x86 => arch/x86/include/asm}/apicdef.h     |    0
 .../asm-x86 => arch/x86/include/asm}/arch_hooks.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/asm.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/atomic.h |    0
 .../asm-x86 => arch/x86/include/asm}/atomic_32.h   |    0
 .../asm-x86 => arch/x86/include/asm}/atomic_64.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/auxvec.h |    0
 .../asm-x86 => arch/x86/include/asm}/bios_ebda.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/bitops.h |    0
 {include/asm-x86 => arch/x86/include/asm}/boot.h   |    0
 .../asm-x86 => arch/x86/include/asm}/bootparam.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/bug.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/bugs.h   |    0
 .../asm-x86 => arch/x86/include/asm}/byteorder.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/cache.h  |    0
 .../asm-x86 => arch/x86/include/asm}/cacheflush.h  |    0
 .../asm-x86 => arch/x86/include/asm}/calgary.h     |    0
 .../asm-x86 => arch/x86/include/asm}/calling.h     |    0
 .../asm-x86 => arch/x86/include/asm}/checksum.h    |    0
 .../asm-x86 => arch/x86/include/asm}/checksum_32.h |    0
 .../asm-x86 => arch/x86/include/asm}/checksum_64.h |    0
 .../asm-x86 => arch/x86/include/asm}/cmpxchg.h     |    0
 .../asm-x86 => arch/x86/include/asm}/cmpxchg_32.h  |    0
 .../asm-x86 => arch/x86/include/asm}/cmpxchg_64.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/compat.h |    0
 {include/asm-x86 => arch/x86/include/asm}/cpu.h    |    0
 .../asm-x86 => arch/x86/include/asm}/cpufeature.h  |    0
 .../asm-x86 => arch/x86/include/asm}/cputime.h     |    0
 .../asm-x86 => arch/x86/include/asm}/current.h     |    0
 .../asm-x86 => arch/x86/include/asm}/debugreg.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/delay.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/desc.h   |    0
 .../asm-x86 => arch/x86/include/asm}/desc_defs.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/device.h |    0
 {include/asm-x86 => arch/x86/include/asm}/div64.h  |    0
 .../asm-x86 => arch/x86/include/asm}/dma-mapping.h |    0
 {include/asm-x86 => arch/x86/include/asm}/dma.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/dmi.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/ds.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/dwarf2.h |    0
 {include/asm-x86 => arch/x86/include/asm}/e820.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/edac.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/efi.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/elf.h    |    0
 .../x86/include/asm}/emergency-restart.h           |    0
 {include/asm-x86 => arch/x86/include/asm}/errno.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/fb.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/fcntl.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/fixmap.h |    0
 .../asm-x86 => arch/x86/include/asm}/fixmap_32.h   |    0
 .../asm-x86 => arch/x86/include/asm}/fixmap_64.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/floppy.h |    0
 {include/asm-x86 => arch/x86/include/asm}/frame.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/ftrace.h |    0
 {include/asm-x86 => arch/x86/include/asm}/futex.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/gart.h   |    0
 .../asm-x86 => arch/x86/include/asm}/genapic.h     |    0
 .../asm-x86 => arch/x86/include/asm}/genapic_32.h  |    0
 .../asm-x86 => arch/x86/include/asm}/genapic_64.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/geode.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/gpio.h   |    0
 .../asm-x86 => arch/x86/include/asm}/hardirq.h     |    0
 .../asm-x86 => arch/x86/include/asm}/hardirq_32.h  |    0
 .../asm-x86 => arch/x86/include/asm}/hardirq_64.h  |    0
 .../asm-x86 => arch/x86/include/asm}/highmem.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/hpet.h   |    0
 .../asm-x86 => arch/x86/include/asm}/hugetlb.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/hw_irq.h |    0
 .../x86/include/asm}/hypertransport.h              |    0
 {include/asm-x86 => arch/x86/include/asm}/i387.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/i8253.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/i8259.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/ia32.h   |    0
 .../asm-x86 => arch/x86/include/asm}/ia32_unistd.h |    0
 {include/asm-x86 => arch/x86/include/asm}/idle.h   |    0
 .../x86/include/asm}/intel_arch_perfmon.h          |    0
 {include/asm-x86 => arch/x86/include/asm}/io.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/io_32.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/io_64.h  |    0
 .../asm-x86 => arch/x86/include/asm}/io_apic.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/ioctl.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/ioctls.h |    0
 {include/asm-x86 => arch/x86/include/asm}/iommu.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/ipcbuf.h |    0
 {include/asm-x86 => arch/x86/include/asm}/ipi.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/irq.h    |    0
 .../asm-x86 => arch/x86/include/asm}/irq_regs.h    |    0
 .../asm-x86 => arch/x86/include/asm}/irq_regs_32.h |    0
 .../asm-x86 => arch/x86/include/asm}/irq_regs_64.h |    0
 .../asm-x86 => arch/x86/include/asm}/irq_vectors.h |    0
 .../asm-x86 => arch/x86/include/asm}/irqflags.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/ist.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/k8.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/kdebug.h |    0
 {include/asm-x86 => arch/x86/include/asm}/kexec.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/kgdb.h   |    0
 .../asm-x86 => arch/x86/include/asm}/kmap_types.h  |    0
 .../asm-x86 => arch/x86/include/asm}/kprobes.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/kvm.h    |    0
 .../asm-x86 => arch/x86/include/asm}/kvm_host.h    |    0
 .../asm-x86 => arch/x86/include/asm}/kvm_para.h    |    0
 .../x86/include/asm}/kvm_x86_emulate.h             |    0
 {include/asm-x86 => arch/x86/include/asm}/ldt.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/lguest.h |    0
 .../x86/include/asm}/lguest_hcall.h                |    0
 .../asm-x86 => arch/x86/include/asm}/linkage.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/local.h  |    0
 .../asm-x86 => arch/x86/include/asm}/math_emu.h    |    0
 .../asm-x86 => arch/x86/include/asm}/mc146818rtc.h |    0
 {include/asm-x86 => arch/x86/include/asm}/mca.h    |    0
 .../asm-x86 => arch/x86/include/asm}/mca_dma.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/mce.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/mman.h   |    0
 .../asm-x86 => arch/x86/include/asm}/mmconfig.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/mmu.h    |    0
 .../asm-x86 => arch/x86/include/asm}/mmu_context.h |    0
 .../x86/include/asm}/mmu_context_32.h              |    0
 .../x86/include/asm}/mmu_context_64.h              |    0
 {include/asm-x86 => arch/x86/include/asm}/mmx.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/mmzone.h |    0
 .../asm-x86 => arch/x86/include/asm}/mmzone_32.h   |    0
 .../asm-x86 => arch/x86/include/asm}/mmzone_64.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/module.h |    0
 {include/asm-x86 => arch/x86/include/asm}/mpspec.h |    0
 .../asm-x86 => arch/x86/include/asm}/mpspec_def.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/msgbuf.h |    0
 {include/asm-x86 => arch/x86/include/asm}/msidef.h |    0
 .../asm-x86 => arch/x86/include/asm}/msr-index.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/msr.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/mtrr.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/mutex.h  |    0
 .../asm-x86 => arch/x86/include/asm}/mutex_32.h    |    0
 .../asm-x86 => arch/x86/include/asm}/mutex_64.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/nmi.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/nops.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/numa.h   |    0
 .../asm-x86 => arch/x86/include/asm}/numa_32.h     |    0
 .../asm-x86 => arch/x86/include/asm}/numa_64.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/numaq.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/olpc.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/page.h   |    0
 .../asm-x86 => arch/x86/include/asm}/page_32.h     |    0
 .../asm-x86 => arch/x86/include/asm}/page_64.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/param.h  |    0
 .../asm-x86 => arch/x86/include/asm}/paravirt.h    |    0
 .../asm-x86 => arch/x86/include/asm}/parport.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/pat.h    |    0
 .../asm-x86 => arch/x86/include/asm}/pci-direct.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/pci.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/pci_32.h |    0
 {include/asm-x86 => arch/x86/include/asm}/pci_64.h |    0
 {include/asm-x86 => arch/x86/include/asm}/pda.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/percpu.h |    0
 .../asm-x86 => arch/x86/include/asm}/pgalloc.h     |    0
 .../x86/include/asm}/pgtable-2level-defs.h         |    0
 .../x86/include/asm}/pgtable-2level.h              |    0
 .../x86/include/asm}/pgtable-3level-defs.h         |    0
 .../x86/include/asm}/pgtable-3level.h              |    0
 .../asm-x86 => arch/x86/include/asm}/pgtable.h     |    0
 .../asm-x86 => arch/x86/include/asm}/pgtable_32.h  |    0
 .../asm-x86 => arch/x86/include/asm}/pgtable_64.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/poll.h   |    0
 .../asm-x86 => arch/x86/include/asm}/posix_types.h |    0
 .../x86/include/asm}/posix_types_32.h              |    0
 .../x86/include/asm}/posix_types_64.h              |    0
 {include/asm-x86 => arch/x86/include/asm}/prctl.h  |    0
 .../x86/include/asm}/processor-cyrix.h             |    0
 .../x86/include/asm}/processor-flags.h             |    0
 .../asm-x86 => arch/x86/include/asm}/processor.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/proto.h  |    0
 .../asm-x86 => arch/x86/include/asm}/ptrace-abi.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/ptrace.h |    0
 .../asm-x86 => arch/x86/include/asm}/pvclock-abi.h |    0
 .../asm-x86 => arch/x86/include/asm}/pvclock.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/reboot.h |    0
 .../x86/include/asm}/reboot_fixups.h               |    0
 .../x86/include/asm}/required-features.h           |    0
 .../asm-x86 => arch/x86/include/asm}/resource.h    |    0
 .../x86/include/asm}/resume-trace.h                |    0
 {include/asm-x86 => arch/x86/include/asm}/rio.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/rtc.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/rwlock.h |    0
 {include/asm-x86 => arch/x86/include/asm}/rwsem.h  |    0
 .../asm-x86 => arch/x86/include/asm}/scatterlist.h |    0
 .../asm-x86 => arch/x86/include/asm}/seccomp.h     |    0
 .../asm-x86 => arch/x86/include/asm}/seccomp_32.h  |    0
 .../asm-x86 => arch/x86/include/asm}/seccomp_64.h  |    0
 .../asm-x86 => arch/x86/include/asm}/sections.h    |    0
 .../asm-x86 => arch/x86/include/asm}/segment.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/sembuf.h |    0
 {include/asm-x86 => arch/x86/include/asm}/serial.h |    0
 {include/asm-x86 => arch/x86/include/asm}/setup.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/shmbuf.h |    0
 .../asm-x86 => arch/x86/include/asm}/shmparam.h    |    0
 .../asm-x86 => arch/x86/include/asm}/sigcontext.h  |    0
 .../x86/include/asm}/sigcontext32.h                |    0
 .../asm-x86 => arch/x86/include/asm}/siginfo.h     |    0
 {include/asm-x86 => arch/x86/include/asm}/signal.h |    0
 {include/asm-x86 => arch/x86/include/asm}/smp.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/socket.h |    0
 .../asm-x86 => arch/x86/include/asm}/sockios.h     |    0
 .../asm-x86 => arch/x86/include/asm}/sparsemem.h   |    0
 .../asm-x86 => arch/x86/include/asm}/spinlock.h    |    0
 .../x86/include/asm}/spinlock_types.h              |    0
 {include/asm-x86 => arch/x86/include/asm}/srat.h   |    0
 .../asm-x86 => arch/x86/include/asm}/stacktrace.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/stat.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/statfs.h |    0
 {include/asm-x86 => arch/x86/include/asm}/string.h |    0
 .../asm-x86 => arch/x86/include/asm}/string_32.h   |    0
 .../asm-x86 => arch/x86/include/asm}/string_64.h   |    0
 .../asm-x86 => arch/x86/include/asm}/suspend.h     |    0
 .../asm-x86 => arch/x86/include/asm}/suspend_32.h  |    0
 .../asm-x86 => arch/x86/include/asm}/suspend_64.h  |    0
 .../asm-x86 => arch/x86/include/asm}/swiotlb.h     |    0
 .../asm-x86 => arch/x86/include/asm}/sync_bitops.h |    0
 {include/asm-x86 => arch/x86/include/asm}/system.h |    0
 .../asm-x86 => arch/x86/include/asm}/system_64.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/tce.h    |    0
 .../asm-x86 => arch/x86/include/asm}/termbits.h    |    0
 .../asm-x86 => arch/x86/include/asm}/termios.h     |    0
 .../asm-x86 => arch/x86/include/asm}/therm_throt.h |    0
 .../asm-x86 => arch/x86/include/asm}/thread_info.h |    0
 {include/asm-x86 => arch/x86/include/asm}/time.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/timer.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/timex.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/tlb.h    |    0
 .../asm-x86 => arch/x86/include/asm}/tlbflush.h    |    0
 .../asm-x86 => arch/x86/include/asm}/topology.h    |    0
 .../asm-x86 => arch/x86/include/asm}/trampoline.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/traps.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/tsc.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/types.h  |    0
 .../asm-x86 => arch/x86/include/asm}/uaccess.h     |    0
 .../asm-x86 => arch/x86/include/asm}/uaccess_32.h  |    0
 .../asm-x86 => arch/x86/include/asm}/uaccess_64.h  |    0
 .../asm-x86 => arch/x86/include/asm}/ucontext.h    |    0
 .../asm-x86 => arch/x86/include/asm}/unaligned.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/unistd.h |    0
 .../asm-x86 => arch/x86/include/asm}/unistd_32.h   |    0
 .../asm-x86 => arch/x86/include/asm}/unistd_64.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/unwind.h |    0
 {include/asm-x86 => arch/x86/include/asm}/user.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/user32.h |    0
 .../asm-x86 => arch/x86/include/asm}/user_32.h     |    0
 .../asm-x86 => arch/x86/include/asm}/user_64.h     |    0
 .../asm-x86 => arch/x86/include/asm}/uv/bios.h     |    0
 .../asm-x86 => arch/x86/include/asm}/uv/uv_bau.h   |    0
 .../asm-x86 => arch/x86/include/asm}/uv/uv_hub.h   |    0
 .../asm-x86 => arch/x86/include/asm}/uv/uv_mmrs.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/vdso.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/vga.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/vgtod.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/vic.h    |    0
 .../x86/include/asm}/visws/cobalt.h                |    0
 .../x86/include/asm}/visws/lithium.h               |    0
 .../asm-x86 => arch/x86/include/asm}/visws/piix4.h |    0
 .../asm-x86 => arch/x86/include/asm}/visws/sgivw.h |    0
 {include/asm-x86 => arch/x86/include/asm}/vm86.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/vmi.h    |    0
 .../asm-x86 => arch/x86/include/asm}/vmi_time.h    |    0
 .../asm-x86 => arch/x86/include/asm}/voyager.h     |    0
 .../asm-x86 => arch/x86/include/asm}/vsyscall.h    |    0
 .../asm-x86 => arch/x86/include/asm}/xen/events.h  |    0
 .../x86/include/asm}/xen/grant_table.h             |    0
 .../x86/include/asm}/xen/hypercall.h               |    0
 .../x86/include/asm}/xen/hypervisor.h              |    0
 .../x86/include/asm}/xen/interface.h               |    0
 .../x86/include/asm}/xen/interface_32.h            |    0
 .../x86/include/asm}/xen/interface_64.h            |    0
 .../asm-x86 => arch/x86/include/asm}/xen/page.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/xor.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/xor_32.h |    0
 {include/asm-x86 => arch/x86/include/asm}/xor_64.h |    0
 .../x86/include}/mach-bigsmp/mach_apic.h           |    0
 .../x86/include}/mach-bigsmp/mach_apicdef.h        |    0
 .../x86/include}/mach-bigsmp/mach_ipi.h            |    0
 .../x86/include}/mach-default/apm.h                |    0
 .../x86/include}/mach-default/do_timer.h           |    0
 .../x86/include}/mach-default/entry_arch.h         |    0
 .../x86/include}/mach-default/mach_apic.h          |    0
 .../x86/include}/mach-default/mach_apicdef.h       |    0
 .../x86/include}/mach-default/mach_ipi.h           |    0
 .../x86/include}/mach-default/mach_mpparse.h       |    0
 .../x86/include}/mach-default/mach_mpspec.h        |    0
 .../x86/include}/mach-default/mach_timer.h         |    0
 .../x86/include}/mach-default/mach_traps.h         |    0
 .../x86/include}/mach-default/mach_wakecpu.h       |    0
 .../x86/include}/mach-default/pci-functions.h      |    0
 .../x86/include}/mach-default/setup_arch.h         |    0
 .../x86/include}/mach-default/smpboot_hooks.h      |    0
 .../x86/include}/mach-es7000/mach_apic.h           |    0
 .../x86/include}/mach-es7000/mach_apicdef.h        |    0
 .../x86/include}/mach-es7000/mach_ipi.h            |    0
 .../x86/include}/mach-es7000/mach_mpparse.h        |    0
 .../x86/include}/mach-es7000/mach_wakecpu.h        |    0
 .../x86/include}/mach-generic/gpio.h               |    0
 .../x86/include}/mach-generic/irq_vectors_limits.h |    0
 .../x86/include}/mach-generic/mach_apic.h          |    0
 .../x86/include}/mach-generic/mach_apicdef.h       |    0
 .../x86/include}/mach-generic/mach_ipi.h           |    0
 .../x86/include}/mach-generic/mach_mpparse.h       |    0
 .../x86/include}/mach-generic/mach_mpspec.h        |    0
 .../x86/include}/mach-numaq/mach_apic.h            |    0
 .../x86/include}/mach-numaq/mach_apicdef.h         |    0
 .../x86/include}/mach-numaq/mach_ipi.h             |    0
 .../x86/include}/mach-numaq/mach_mpparse.h         |    0
 .../x86/include}/mach-numaq/mach_wakecpu.h         |    0
 .../x86/include}/mach-rdc321x/gpio.h               |    0
 .../x86/include}/mach-rdc321x/rdc321x_defs.h       |    0
 .../x86/include}/mach-summit/irq_vectors_limits.h  |    0
 .../x86/include}/mach-summit/mach_apic.h           |    0
 .../x86/include}/mach-summit/mach_apicdef.h        |    0
 .../x86/include}/mach-summit/mach_ipi.h            |    0
 .../x86/include}/mach-summit/mach_mpparse.h        |    0
 .../x86/include}/mach-voyager/do_timer.h           |    0
 .../x86/include}/mach-voyager/entry_arch.h         |    0
 .../x86/include}/mach-voyager/setup_arch.h         |    0
 scripts/checksyscalls.sh                           |    2 +-
 331 files changed, 18 insertions(+), 6 deletions(-)
 rename {include/asm-x86 => arch/x86/include/asm}/Kbuild (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/a.out-core.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/a.out.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/acpi.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/agp.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/alternative-asm.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/alternative.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/amd_iommu.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/amd_iommu_types.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/apic.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/apicdef.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/arch_hooks.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/asm.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/atomic.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/atomic_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/atomic_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/auxvec.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/bios_ebda.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/bitops.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/boot.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/bootparam.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/bug.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/bugs.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/byteorder.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/cache.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/cacheflush.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/calgary.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/calling.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/checksum.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/checksum_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/checksum_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/cmpxchg.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/cmpxchg_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/cmpxchg_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/compat.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/cpu.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/cpufeature.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/cputime.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/current.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/debugreg.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/delay.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/desc.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/desc_defs.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/device.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/div64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/dma-mapping.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/dma.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/dmi.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ds.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/dwarf2.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/e820.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/edac.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/efi.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/elf.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/emergency-restart.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/errno.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/fb.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/fcntl.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/fixmap.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/fixmap_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/fixmap_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/floppy.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/frame.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ftrace.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/futex.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/gart.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/genapic.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/genapic_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/genapic_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/geode.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/gpio.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/hardirq.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/hardirq_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/hardirq_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/highmem.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/hpet.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/hugetlb.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/hw_irq.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/hypertransport.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/i387.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/i8253.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/i8259.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ia32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ia32_unistd.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/idle.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/intel_arch_perfmon.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/io.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/io_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/io_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/io_apic.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ioctl.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ioctls.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/iommu.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ipcbuf.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ipi.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/irq.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/irq_regs.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/irq_regs_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/irq_regs_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/irq_vectors.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/irqflags.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ist.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/k8.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/kdebug.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/kexec.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/kgdb.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/kmap_types.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/kprobes.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/kvm.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/kvm_host.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/kvm_para.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/kvm_x86_emulate.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ldt.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/lguest.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/lguest_hcall.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/linkage.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/local.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/math_emu.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mc146818rtc.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mca.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mca_dma.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mce.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mman.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mmconfig.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mmu.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mmu_context.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mmu_context_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mmu_context_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mmx.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mmzone.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mmzone_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mmzone_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/module.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mpspec.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mpspec_def.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/msgbuf.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/msidef.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/msr-index.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/msr.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mtrr.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mutex.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mutex_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/mutex_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/nmi.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/nops.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/numa.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/numa_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/numa_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/numaq.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/olpc.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/page.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/page_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/page_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/param.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/paravirt.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/parport.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pat.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pci-direct.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pci.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pci_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pci_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pda.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/percpu.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pgalloc.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pgtable-2level-defs.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pgtable-2level.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pgtable-3level-defs.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pgtable-3level.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pgtable.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pgtable_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pgtable_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/poll.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/posix_types.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/posix_types_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/posix_types_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/prctl.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/processor-cyrix.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/processor-flags.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/processor.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/proto.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ptrace-abi.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ptrace.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pvclock-abi.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/pvclock.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/reboot.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/reboot_fixups.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/required-features.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/resource.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/resume-trace.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/rio.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/rtc.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/rwlock.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/rwsem.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/scatterlist.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/seccomp.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/seccomp_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/seccomp_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/sections.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/segment.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/sembuf.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/serial.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/setup.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/shmbuf.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/shmparam.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/sigcontext.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/sigcontext32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/siginfo.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/signal.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/smp.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/socket.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/sockios.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/sparsemem.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/spinlock.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/spinlock_types.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/srat.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/stacktrace.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/stat.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/statfs.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/string.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/string_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/string_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/suspend.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/suspend_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/suspend_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/swiotlb.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/sync_bitops.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/system.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/system_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/tce.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/termbits.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/termios.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/therm_throt.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/thread_info.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/time.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/timer.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/timex.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/tlb.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/tlbflush.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/topology.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/trampoline.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/traps.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/tsc.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/types.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/uaccess.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/uaccess_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/uaccess_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/ucontext.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/unaligned.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/unistd.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/unistd_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/unistd_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/unwind.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/user.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/user32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/user_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/user_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/uv/bios.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/uv/uv_bau.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/uv/uv_hub.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/uv/uv_mmrs.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/vdso.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/vga.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/vgtod.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/vic.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/visws/cobalt.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/visws/lithium.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/visws/piix4.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/visws/sgivw.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/vm86.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/vmi.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/vmi_time.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/voyager.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/vsyscall.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/xen/events.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/xen/grant_table.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/xen/hypercall.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/xen/hypervisor.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/xen/interface.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/xen/interface_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/xen/interface_64.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/xen/page.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/xor.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/xor_32.h (100%)
 rename {include/asm-x86 => arch/x86/include/asm}/xor_64.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-bigsmp/mach_apic.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-bigsmp/mach_apicdef.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-bigsmp/mach_ipi.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/apm.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/do_timer.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/entry_arch.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/mach_apic.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/mach_apicdef.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/mach_ipi.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/mach_mpparse.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/mach_mpspec.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/mach_timer.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/mach_traps.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/mach_wakecpu.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/pci-functions.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/setup_arch.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-default/smpboot_hooks.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-es7000/mach_apic.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-es7000/mach_apicdef.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-es7000/mach_ipi.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-es7000/mach_mpparse.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-es7000/mach_wakecpu.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-generic/gpio.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-generic/irq_vectors_limits.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-generic/mach_apic.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-generic/mach_apicdef.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-generic/mach_ipi.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-generic/mach_mpparse.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-generic/mach_mpspec.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-numaq/mach_apic.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-numaq/mach_apicdef.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-numaq/mach_ipi.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-numaq/mach_mpparse.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-numaq/mach_wakecpu.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-rdc321x/gpio.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-rdc321x/rdc321x_defs.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-summit/irq_vectors_limits.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-summit/mach_apic.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-summit/mach_apicdef.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-summit/mach_ipi.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-summit/mach_mpparse.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-voyager/do_timer.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-voyager/entry_arch.h (100%)
 rename {include/asm-x86 => arch/x86/include}/mach-voyager/setup_arch.h (100%)
