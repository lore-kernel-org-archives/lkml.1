Return-Path: <linux-kernel-owner+w=401wt.eu-S1759777AbXKLVDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777AbXKLVDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757871AbXKLU7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 15:59:17 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39827 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbXKLU67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 15:58:59 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: do not use $(ARCH) when not needed
Date: Mon, 12 Nov 2007 22:00:35 +0100
Message-Id: <1194901236-22820-12-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1194901236-22820-11-git-send-email-sam@ravnborg.org>
References: <20071112205451.GA22528@uranus.ravnborg.org>
 <1194901236-22820-1-git-send-email-sam@ravnborg.org>
 <1194901236-22820-2-git-send-email-sam@ravnborg.org>
 <1194901236-22820-3-git-send-email-sam@ravnborg.org>
 <1194901236-22820-4-git-send-email-sam@ravnborg.org>
 <1194901236-22820-5-git-send-email-sam@ravnborg.org>
 <1194901236-22820-6-git-send-email-sam@ravnborg.org>
 <1194901236-22820-7-git-send-email-sam@ravnborg.org>
 <1194901236-22820-8-git-send-email-sam@ravnborg.org>
 <1194901236-22820-9-git-send-email-sam@ravnborg.org>
 <1194901236-22820-10-git-send-email-sam@ravnborg.org>
 <1194901236-22820-11-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For x86 ARCH may say i386 or x86_64 and soon x86.
Rely on CONFIG_X64_32 to select between 32/64 or just
hardcode the value as appropriate.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 Makefile                    |    9 +++++++--
 arch/x86/Makefile           |   10 +++++++---
 arch/x86/Makefile_32        |    8 ++++----
 arch/x86/Makefile_64        |    8 ++++----
 arch/x86/boot/Makefile      |    6 +++---
 arch/x86/kernel/Makefile_32 |    3 ++-
 arch/x86/kernel/Makefile_64 |    2 ++
 arch/x86/vdso/Makefile      |    2 +-
 8 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/Makefile b/Makefile
index e28dde8..b32963a 100644
--- a/Makefile
+++ b/Makefile
@@ -197,8 +197,13 @@ CROSS_COMPILE	?=
 UTS_MACHINE 	:= $(ARCH)
 SRCARCH 	:= $(ARCH)
 
-# for i386 and x86_64 we use SRCARCH equal to x86
-SRCARCH := $(if $(filter x86_64 i386,$(SRCARCH)),x86,$(SRCARCH))
+# Additional ARCH settings for x86
+ifeq ($(ARCH),i386)
+        SRCARCH := x86
+endif
+ifeq ($(ARCH),x86_64)
+        SRCARCH := x86
+endif
 
 KCONFIG_CONFIG	?= .config
 
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 3095973..116b03a 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -1,12 +1,16 @@
 # Unified Makefile for i386 and x86_64
 
 # select defconfig based on actual architecture
-KBUILD_DEFCONFIG := $(ARCH)_defconfig
+ifeq ($(ARCH),x86)
+        KBUILD_DEFCONFIG := i386_defconfig
+else
+        KBUILD_DEFCONFIG := $(ARCH)_defconfig
+endif
 
-# # No need to remake these files
+# No need to remake these files
 $(srctree)/arch/x86/Makefile%: ;
 
-ifeq ($(ARCH),i386)
+ifeq ($(CONFIG_X86_32),y)
         include $(srctree)/arch/x86/Makefile_32
 else
         include $(srctree)/arch/x86/Makefile_64
diff --git a/arch/x86/Makefile_32 b/arch/x86/Makefile_32
index 346ac07..50394da 100644
--- a/arch/x86/Makefile_32
+++ b/arch/x86/Makefile_32
@@ -160,7 +160,7 @@ archclean:
 	$(Q)$(MAKE) $(clean)=arch/x86/boot
 
 define archhelp
-  echo  '* bzImage	- Compressed kernel image (arch/$(ARCH)/boot/bzImage)'
+  echo  '* bzImage	- Compressed kernel image (arch/x86/boot/bzImage)'
   echo  '  install	- Install kernel using'
   echo  '		   (your) ~/bin/installkernel or'
   echo  '		   (distribution) /sbin/installkernel or'
@@ -170,6 +170,6 @@ define archhelp
   echo  '  isoimage     - Create a boot CD-ROM image'
 endef
 
-CLEAN_FILES += arch/$(ARCH)/boot/fdimage \
-	       arch/$(ARCH)/boot/image.iso \
-	       arch/$(ARCH)/boot/mtools.conf
+CLEAN_FILES += arch/x86/boot/fdimage \
+	       arch/x86/boot/image.iso \
+	       arch/x86/boot/mtools.conf
diff --git a/arch/x86/Makefile_64 b/arch/x86/Makefile_64
index 57e714a..a804860 100644
--- a/arch/x86/Makefile_64
+++ b/arch/x86/Makefile_64
@@ -127,7 +127,7 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 
 define archhelp
-  echo  '* bzImage	- Compressed kernel image (arch/$(ARCH)/boot/bzImage)'
+  echo  '* bzImage	- Compressed kernel image (arch/x86/boot/bzImage)'
   echo  '  install	- Install kernel using'
   echo  '		   (your) ~/bin/installkernel or'
   echo  '		   (distribution) /sbin/installkernel or'
@@ -137,8 +137,8 @@ define archhelp
   echo  '  isoimage     - Create a boot CD-ROM image'
 endef
 
-CLEAN_FILES += arch/$(ARCH)/boot/fdimage \
-	       arch/$(ARCH)/boot/image.iso \
-	       arch/$(ARCH)/boot/mtools.conf
+CLEAN_FILES += arch/x86/boot/fdimage \
+	       arch/x86/boot/image.iso \
+	       arch/x86/boot/mtools.conf
 
 
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
-- 
1.5.3.4.1157.g0e74-dirty

