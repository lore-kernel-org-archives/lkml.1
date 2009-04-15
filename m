Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZDOP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZDOP5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZDOP5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:57:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:40342 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZDOP5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:57:09 -0400
Subject: Re: [git-pull -tip] Add -Werror to arch/x86/ files only and fix
 warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1239798333.7653.15.camel@ht.satnam>
References: <1239793458.7653.12.camel@ht.satnam>
	 <20090415111355.GB27727@elte.hu>  <1239798333.7653.15.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 21:25:23 +0530
Message-Id: <1239810924.2996.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 17:55 +0530, Jaswinder Singh Rajput wrote:
> On Wed, 2009-04-15 at 13:13 +0200, Ingo Molnar wrote:
> > >  
> > > +# Make all warnings into errors
> > 
> > => 'Turn all warnings into errors'
> > 
> > > +ccflags-y := -Werror
> > > +
> > >  targets		:= vmlinux.bin setup.bin setup.elf bzImage
> > >  targets		+= fdimage fdimage144 fdimage288 image.iso mtools.conf
> > >  subdir-		:= compressed
> > 
> > > --- a/arch/x86/mm/Makefile
> > > +++ b/arch/x86/mm/Makefile
> > > @@ -1,3 +1,6 @@
> > > +# Make all warnings into errors
> > > +ccflags-y			:= -Werror
> > > +
> > >  obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
> > >  	    pat.o pgtable.o gup.o
> > 
> > i'd suggest to right-align this obj-y rule as well, to move it in 
> > line with the other lines.
> > 
> > Looks good otherwise.
> > 
> 
> Ok here is the updated patch:
> 
> Subject: [PATCH] x86: Adding -Werror to arch/x86/ files only
> 
> Adding -Werror to arch/x86/ files only, to turn all warnings into errors.

Here is V2 of this patch where we can enable/disable this option:

Subject: [PATCH-tip] x86: Adding -Werror to arch/x86/ files only for !CONFIG_ALLOW_X86_WARNINGS

Adding -Werror to arch/x86/ files only, to turn all warnings into errors.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/Kconfig                       |    9 +++++++++
 arch/x86/boot/Makefile                 |    5 +++++
 arch/x86/boot/compressed/Makefile      |    5 +++++
 arch/x86/crypto/Makefile               |    5 +++++
 arch/x86/ia32/Makefile                 |    5 +++++
 arch/x86/kernel/Makefile               |    5 +++++
 arch/x86/kernel/acpi/Makefile          |    5 +++++
 arch/x86/kernel/acpi/realmode/Makefile |    5 +++++
 arch/x86/kernel/apic/Makefile          |    5 +++++
 arch/x86/kernel/cpu/Makefile           |    5 +++++
 arch/x86/kernel/cpu/cpufreq/Makefile   |    5 +++++
 arch/x86/kernel/cpu/mcheck/Makefile    |    5 +++++
 arch/x86/kernel/cpu/mtrr/Makefile      |    5 +++++
 arch/x86/kvm/Makefile                  |    5 +++++
 arch/x86/lguest/Makefile               |    5 +++++
 arch/x86/lib/Makefile                  |    5 +++++
 arch/x86/math-emu/Makefile             |    5 +++++
 arch/x86/mm/Makefile                   |   10 ++++++++--
 arch/x86/mm/kmemcheck/Makefile         |    7 ++++++-
 arch/x86/oprofile/Makefile             |    5 +++++
 arch/x86/pci/Makefile                  |    5 +++++
 arch/x86/power/Makefile                |    5 +++++
 arch/x86/vdso/Makefile                 |    6 +++++-
 arch/x86/video/Makefile                |    7 ++++++-
 arch/x86/xen/Makefile                  |    7 ++++++-
 25 files changed, 135 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2560fff..f53e335 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -171,6 +171,15 @@ config ARCH_SUPPORTS_OPTIMIZED_INLINING
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y
 
+config ALLOW_X86_WARNINGS
+	bool "Continue building x86 despite compiler warnings"
+	default n
+	depends on ALLOW_WARNINGS
+	depends on DEBUG_KERNEL
+	help
+	  By enabling this option you will disable -Werror on building
+	  x86 C files only.
+
 # Use the generic interrupt handling code in kernel/irq/:
 config GENERIC_HARDIRQS
 	bool
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 658bc52..95f9cfd 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -22,6 +22,11 @@ ROOT_DEV	:= CURRENT
 
 SVGA_MODE	:= -DSVGA_MODE=NORMAL_VGA
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y	:= -Werror
+endif
+
 targets		:= vmlinux.bin setup.bin setup.elf bzImage
 targets		+= fdimage fdimage144 fdimage288 image.iso mtools.conf
 subdir-		:= compressed
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 65551c9..2e84872 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,6 +4,11 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y := -Werror
+endif
+
 targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index ebe7dee..e12163b 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -2,6 +2,11 @@
 # Arch-specific CryptoAPI modules.
 #
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y := -Werror
+endif
+
 obj-$(CONFIG_CRYPTO_AES_586) += aes-i586.o
 obj-$(CONFIG_CRYPTO_TWOFISH_586) += twofish-i586.o
 obj-$(CONFIG_CRYPTO_SALSA20_586) += salsa20-i586.o
diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index 52d0ccf..87af2bc 100644
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -2,6 +2,11 @@
 # Makefile for the ia32 kernel emulation subsystem.
 #
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y := -Werror
+endif
+
 obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o
 
 sysv-$(CONFIG_SYSVIPC) := ipc32.o
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 68a4ff6..f3bbc79 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -2,6 +2,11 @@
 # Makefile for the linux kernel.
 #
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y		:= -Werror
+endif
+
 extra-y                := head_$(BITS).o head$(BITS).o head.o init_task.o vmlinux.lds
 
 CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
index fd5ca97..43a4559 100644
--- a/arch/x86/kernel/acpi/Makefile
+++ b/arch/x86/kernel/acpi/Makefile
@@ -1,3 +1,8 @@
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y			:= -Werror
+endif
+
 subdir-				:= realmode
 
 obj-$(CONFIG_ACPI)		+= boot.o
diff --git a/arch/x86/kernel/acpi/realmode/Makefile b/arch/x86/kernel/acpi/realmode/Makefile
index 167bc16..e053670 100644
--- a/arch/x86/kernel/acpi/realmode/Makefile
+++ b/arch/x86/kernel/acpi/realmode/Makefile
@@ -6,6 +6,11 @@
 # for more details.
 #
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y	:= -Werror
+endif
+
 always		:= wakeup.bin
 targets		:= wakeup.elf wakeup.lds
 
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index da7b7b9..3d06de5 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -2,6 +2,11 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y			:= -Werror
+endif
+
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o probe_$(BITS).o ipi.o nmi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3efcb2b..b010843 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -2,6 +2,11 @@
 # Makefile for x86-compatible CPU details, features and quirks
 #
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y		:= -Werror
+endif
+
 # Don't trace early stages of a secondary CPU boot
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_common.o = -pg
diff --git a/arch/x86/kernel/cpu/cpufreq/Makefile b/arch/x86/kernel/cpu/cpufreq/Makefile
index 509296d..986c7db 100644
--- a/arch/x86/kernel/cpu/cpufreq/Makefile
+++ b/arch/x86/kernel/cpu/cpufreq/Makefile
@@ -2,6 +2,11 @@
 # K8 systems. ACPI is preferred to all other hardware-specific drivers.
 # speedstep-* is preferred over p4-clockmod.
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y				:= -Werror
+endif
+
 obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
 obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o
 obj-$(CONFIG_X86_POWERNOW_K6)		+= powernow-k6.o
diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
index b2f8982..e3b1755 100644
--- a/arch/x86/kernel/cpu/mcheck/Makefile
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -1,3 +1,8 @@
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y			:= -Werror
+endif
+
 obj-y				=  mce_$(BITS).o therm_throt.o
 
 obj-$(CONFIG_X86_32)		+= k7.o p4.o p5.o p6.o winchip.o
diff --git a/arch/x86/kernel/cpu/mtrr/Makefile b/arch/x86/kernel/cpu/mtrr/Makefile
index f4361b5..29d2d03 100644
--- a/arch/x86/kernel/cpu/mtrr/Makefile
+++ b/arch/x86/kernel/cpu/mtrr/Makefile
@@ -1,3 +1,8 @@
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y	:= -Werror
+endif
+
 obj-y		:= main.o if.o generic.o state.o cleanup.o
 obj-$(CONFIG_X86_32) += amd.o cyrix.o centaur.o
 
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index d3ec292..cc975ed 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -2,6 +2,11 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y := -Werror
+endif
+
 common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
                 coalesced_mmio.o irq_comm.o)
 ifeq ($(CONFIG_KVM_TRACE),y)
diff --git a/arch/x86/lguest/Makefile b/arch/x86/lguest/Makefile
index 27f0c9e..7f99e43 100644
--- a/arch/x86/lguest/Makefile
+++ b/arch/x86/lguest/Makefile
@@ -1 +1,6 @@
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y	:= -Werror
+endif
+
 obj-y		:= i386_head.o boot.o
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 55e11aa..ffa4fe8 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -2,6 +2,11 @@
 # Makefile for x86 specific library files.
 #
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y := -Werror
+endif
+
 obj-$(CONFIG_SMP) := msr-on-cpu.o
 
 lib-y := delay.o
diff --git a/arch/x86/math-emu/Makefile b/arch/x86/math-emu/Makefile
index 9b0c63b..85278e8 100644
--- a/arch/x86/math-emu/Makefile
+++ b/arch/x86/math-emu/Makefile
@@ -8,6 +8,11 @@ PARANOID = -DPARANOID
 EXTRA_CFLAGS	:= $(PARANOID) $(DEBUG) -fno-builtin $(MATH_EMULATION)
 EXTRA_AFLAGS	:= $(PARANOID)
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y	:= -Werror
+endif
+
 # From 'C' language sources:
 C_OBJS =fpu_entry.o errors.o \
 	fpu_arith.o fpu_aux.o fpu_etc.o fpu_tags.o fpu_trig.o \
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index eefdeee..0ef8c18 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,5 +1,11 @@
-obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-	    pat.o pgtable.o gup.o
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y			:= -Werror
+endif
+
+obj-y				:=  init.o init_$(BITS).o fault.o ioremap.o \
+				    extable.o pageattr.o mmap.o pat.o \
+				    pgtable.o gup.o
 
 obj-$(CONFIG_SMP)		+= tlb.o
 
diff --git a/arch/x86/mm/kmemcheck/Makefile b/arch/x86/mm/kmemcheck/Makefile
index 520b3bc..e789844 100644
--- a/arch/x86/mm/kmemcheck/Makefile
+++ b/arch/x86/mm/kmemcheck/Makefile
@@ -1 +1,6 @@
-obj-y := error.o kmemcheck.o opcode.o pte.o selftest.o shadow.o
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y	:= -Werror
+endif
+
+obj-y		:= error.o kmemcheck.o opcode.o pte.o selftest.o shadow.o
diff --git a/arch/x86/oprofile/Makefile b/arch/x86/oprofile/Makefile
index 446902b..07a1689 100644
--- a/arch/x86/oprofile/Makefile
+++ b/arch/x86/oprofile/Makefile
@@ -1,3 +1,8 @@
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y := -Werror
+endif
+
 obj-$(CONFIG_OPROFILE) += oprofile.o
 
 DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index d49202e..8b8920d 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -1,3 +1,8 @@
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y			:= -Werror
+endif
+
 obj-y				:= i386.o init.o
 
 obj-$(CONFIG_PCI_BIOS)		+= pcbios.o
diff --git a/arch/x86/power/Makefile b/arch/x86/power/Makefile
index 58b32db..0ebd3f7 100644
--- a/arch/x86/power/Makefile
+++ b/arch/x86/power/Makefile
@@ -1,3 +1,8 @@
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y		:= -Werror
+endif
+
 # __restore_processor_state() restores %gs after S3 resume and so should not
 # itself be stack-protected
 nostackp := $(call cc-option, -fno-stack-protector)
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 16a9020..c5c47b4 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -2,6 +2,11 @@
 # Building vDSO images for x86.
 #
 
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y			:= -Werror
+endif
+
 VDSO64-$(CONFIG_X86_64)		:= y
 VDSO32-$(CONFIG_X86_32)		:= y
 VDSO32-$(CONFIG_COMPAT)		:= y
@@ -9,7 +14,6 @@ VDSO32-$(CONFIG_COMPAT)		:= y
 vdso-install-$(VDSO64-y)	+= vdso.so
 vdso-install-$(VDSO32-y)	+= $(vdso32-images)
 
-
 # files to link into the vdso
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
 
diff --git a/arch/x86/video/Makefile b/arch/x86/video/Makefile
index 2c447c9..16aafab 100644
--- a/arch/x86/video/Makefile
+++ b/arch/x86/video/Makefile
@@ -1 +1,6 @@
-obj-$(CONFIG_FB)               += fbdev.o
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y		:= -Werror
+endif
+
+obj-$(CONFIG_FB)	+= fbdev.o
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3b767d0..bb22068 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,3 +1,8 @@
+# Turn all warnings into errors
+ifndef CONFIG_ALLOW_X86_WARNINGS
+ccflags-y := -Werror
+endif
+
 ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_spinlock.o = -pg
@@ -10,4 +15,4 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			grant-table.o suspend.o
 
 obj-$(CONFIG_SMP)		+= smp.o spinlock.o
-obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
\ No newline at end of file
+obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
-- 
1.6.0.6



