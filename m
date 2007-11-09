Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbXKIXVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbXKIXVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbXKIXTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:19:20 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51340 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242AbXKIXTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:19:08 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 09/11] x86: enable "make ARCH=x86"
Date: Sat, 10 Nov 2007 00:20:43 +0100
Message-Id: <1194650446684-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <20071109230812.GA5176@uranus.ravnborg.org>
References: <20071109230812.GA5176@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After unification of the Kconfig files it required
only trivial changes to enable "make ARCH=x86".
This patch unteach kconfig about SRCARCH and
let kbuild compute x86 for `uname -m` equals x86_64
and the i.86 variants.

The selection of 32 versus 64 bit is now done as a
configuration step like we select SMP, PREMPT etc.

Two drawbacks of this patch:
1) People are used to select 32 versus 64 using ARCH={i386,x86_64}
2) we lost the possibility to generate a true allmodconfig
   for a 64 bit x86 kernel with a simple command.

The workaround is to do:
$ cat myconfig
CONFIG_X86_32=n
CONFIG_X86_64=y
$ make allmodconfig KCONFIG_ALLCONFIG=myconfig

Lot's of scripts will break because they assume
i386 or x86_64 but with this patch we take the logical
step and name the architecture x86 as one would really expect.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                    |    6 ++----
 arch/x86/Kconfig            |   21 +++++++++++++++++++++
 arch/x86/Kconfig.i386       |   18 ------------------
 arch/x86/Kconfig.x86_64     |   20 --------------------
 arch/x86/Makefile           |    6 +++---
 arch/x86/boot/Makefile      |    6 +++---
 arch/x86/kernel/Makefile_32 |    3 ++-
 arch/x86/kernel/Makefile_64 |    2 ++
 arch/x86/vdso/Makefile      |    2 +-
 scripts/kconfig/Makefile    |    7 +------
 10 files changed, 35 insertions(+), 56 deletions(-)
 delete mode 100644 arch/x86/Kconfig.i386
 delete mode 100644 arch/x86/Kconfig.x86_64

diff --git a/Makefile b/Makefile
index e28dde8..afeeef8 100644
--- a/Makefile
+++ b/Makefile
@@ -165,7 +165,8 @@ export srctree objtree VPATH TOPDIR
 # then ARCH is assigned, getting whatever value it gets normally, and 
 # SUBARCH is subsequently ignored.
 
-SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/        \
+				  -e s/sun4u/sparc64/                    \
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
@@ -197,9 +198,6 @@ CROSS_COMPILE	?=
 UTS_MACHINE 	:= $(ARCH)
 SRCARCH 	:= $(ARCH)
 
-# for i386 and x86_64 we use SRCARCH equal to x86
-SRCARCH := $(if $(filter x86_64 i386,$(SRCARCH)),x86,$(SRCARCH))
-
 KCONFIG_CONFIG	?= .config
 
 # SHELL used by kbuild
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 34517bf..153c26c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1,5 +1,26 @@
 # x86 configuration
 
+# Select 32 or 64 bit
+choice
+	bool "Select 32 or 64 bit"
+	default X86_32
+
+config X86_32
+	bool "32 bit (former ARCH=i386)"
+	help
+	  This is Linux's home port.  Linux was originally native to the Intel
+	  386, and runs on all the later x86 processors including the Intel
+	  486, 586, Pentiums, and various instruction-set-compatible chips by
+	  AMD, Cyrix, and others.
+
+config X86_64
+	bool "64 bit (former ARCH=x86_64)"
+	help
+	  Port to the x86-64 architecture. x86-64 is a 64-bit extension to the
+	  classical 32-bit x86 architecture. For details see
+	  <http://www.x86-64.org/>.
+endchoice
+
 ### Arch settings
 config X86
 	bool
diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig.i386
deleted file mode 100644
index 7b8dc26..0000000
--- a/arch/x86/Kconfig.i386
+++ /dev/null
@@ -1,18 +0,0 @@
-#
-# For a description of the syntax of this configuration file,
-# see Documentation/kbuild/kconfig-language.txt.
-#
-
-mainmenu "Linux Kernel Configuration"
-
-config X86_32
-	bool
-	default y
-	help
-	  This is Linux's home port.  Linux was originally native to the Intel
-	  386, and runs on all the later x86 processors including the Intel
-	  486, 586, Pentiums, and various instruction-set-compatible chips by
-	  AMD, Cyrix, and others.
-
-
-source "arch/x86/Kconfig"
diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
deleted file mode 100644
index b262aae..0000000
--- a/arch/x86/Kconfig.x86_64
+++ /dev/null
@@ -1,20 +0,0 @@
-#
-# For a description of the syntax of this configuration file,
-# see Documentation/kbuild/kconfig-language.txt.
-#
-# Note: ISA is disabled and will hopefully never be enabled.
-# If you managed to buy an ISA x86-64 box you'll have to fix all the
-# ISA drivers you need yourself.
-#
-
-mainmenu "Linux Kernel Configuration"
-
-config X86_64
-	bool
-	default y
-	help
-	  Port to the x86-64 architecture. x86-64 is a 64-bit extension to the
-	  classical 32-bit x86 architecture. For details see
-	  <http://www.x86-64.org/>.
-
-source "arch/x86/Kconfig"
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 3095973..ee94224 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -1,12 +1,12 @@
 # Unified Makefile for i386 and x86_64
 
-# select defconfig based on actual architecture
-KBUILD_DEFCONFIG := $(ARCH)_defconfig
+# select i386 defconfig file as default config
+KBUILD_DEFCONFIG := i386_defconfig
 
 # # No need to remake these files
 $(srctree)/arch/x86/Makefile%: ;
 
-ifeq ($(ARCH),i386)
+ifeq ($(CONFIG_X86_32),y)
         include $(srctree)/arch/x86/Makefile_32
 else
         include $(srctree)/arch/x86/Makefile_64
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 89dbf97..7a3116c 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -49,10 +49,10 @@ HOSTCFLAGS_build.o := $(LINUXINCLUDE)
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386,
 # that way we can complain to the user if the CPU is insufficient.
-cflags-i386   := 
-cflags-x86_64 := -m32
+cflags-$(CONFIG_X86_32) :=
+cflags-$(CONFIG_X86_64) := -m32
 KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
-		   $(cflags-$(ARCH)) \
+		   $(cflags-y) \
 		   -Wall -Wstrict-prototypes \
 		   -march=i386 -mregparm=3 \
 		   -include $(srctree)/$(src)/code16gcc.h \
diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index b9d6798..a7bc93c 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -3,6 +3,7 @@
 #
 
 extra-y := head_32.o init_task.o vmlinux.lds
+CPPFLAGS_vmlinux.lds += -Ui386
 
 obj-y	:= process_32.o signal_32.o entry_32.o traps_32.o irq_32.o \
 		ptrace_32.o time_32.o ioport_32.o ldt_32.o setup_32.o i8259_32.o sys_i386_32.o \
@@ -60,7 +61,7 @@ quiet_cmd_syscall = SYSCALL $@
       cmd_syscall = $(CC) -m elf_i386 -nostdlib $(SYSCFLAGS_$(@F)) \
 		          -Wl,-T,$(filter-out FORCE,$^) -o $@
 
-export CPPFLAGS_vsyscall_32.lds += -P -C -U$(ARCH)
+export CPPFLAGS_vsyscall_32.lds += -P -C -Ui386
 
 vsyscall-flags = -shared -s -Wl,-soname=linux-gate.so.1 \
 		 $(call ld-option, -Wl$(comma)--hash-style=sysv)
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index 24671c3..5a88890 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -3,7 +3,9 @@
 #
 
 extra-y 	:= head_64.o head64.o init_task.o vmlinux.lds
+CPPFLAGS_vmlinux.lds += -Ux86_64
 EXTRA_AFLAGS	:= -traditional
+
 obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
 		ptrace_64.o time_64.o ioport_64.o ldt_64.o setup_64.o i8259_64.o sys_x86_64.o \
 		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 7a2ba45..e7bff0f 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -20,7 +20,7 @@ quiet_cmd_syscall = SYSCALL $@
       cmd_syscall = $(CC) -m elf_x86_64 -nostdlib $(SYSCFLAGS_$(@F)) \
 		          -Wl,-T,$(filter-out FORCE,$^) -o $@
 
-export CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
+export CPPFLAGS_vdso.lds += -P -C
 
 vdso-flags = -fPIC -shared -Wl,-soname=linux-vdso.so.1 \
 		 $(call ld-option, -Wl$(comma)--hash-style=sysv) \
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 5959412..3c9db07 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -4,12 +4,7 @@
 
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config
 
-# If a arch/$(SRCARCH)/Kconfig.$(ARCH) file exist use it
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/Kconfig.$(ARCH)),)
-        Kconfig := arch/$(SRCARCH)/Kconfig.$(ARCH)
-else
-        Kconfig := arch/$(SRCARCH)/Kconfig
-endif
+Kconfig := arch/$(ARCH)/Kconfig
 
 xconfig: $(obj)/qconf
 	$< $(Kconfig)
-- 
1.5.3.4.1157.g0e74-dirty

