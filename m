Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZIKVg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZIKVg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbZIKVg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:36:58 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:47478 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbZIKVg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:36:57 -0400
X-Greylist: delayed 1129 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2009 17:36:54 EDT
Date: Fri, 11 Sep 2009 17:16:55 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de, David.Woodhouse@intel.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
	'make oldconfig'
Message-ID: <20090911211654.GA11399@c2.user-mode-linux.org>
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org> <20090904144857.GA12872@elte.hu> <alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org> <4AA13FE6.20807@zytor.com> <20090904183103.GA1873@elte.hu> <4AA16336.3050606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA16336.3050606@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 11:57:58AM -0700, H. Peter Anvin wrote:
> The "obvious" change of allowing SUBARCH to take values like i386 and
> x86_64 is also wrong (and possibly have a DEFAULT_ARCH which can be
> different than SUBARCH), because we have several instances of:
> 
> ifneq ($(SUBARCH),$(ARCH))
> 
> ... in the build tree, and even have ugliness like:
> 
> [scripts/tags.h]
> # Support um (which uses SUBARCH)
> if [ "${ARCH}" = "um" ]; then
>         if [ "$SUBARCH" = "i386" ]; then
>                 archinclude=x86
>         elif [ "$SUBARCH" = "x86_64" ]; then
>                 archinclude=x86
>         else
>                 archinclude=${SUBARCH}
>         fi
> fi
> 
> Anyway... it sounds like we need to drop this commit for now and
> re-merge it when there is a fix for UM.
> 
> Jeff, Sam, I would appreciate your suggestions as how best to fix this
> kind of stuff...

I figured out how to make this work - see below.

			Jeff

-- 
Work email - jdike at linux dot intel dot com

commit 370d4e326094c053b7f602178a4303f958471136
Author: Jeff Dike <jdike@kvm.user-mode-linux.org>
Date:   Fri Sep 11 17:07:36 2009 -0400

    Make UML build with SUBARCH=x86
    
    This patch makes UML build with David Woodhouse's commit
    5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9 in x86/linux-2.6-tip.
    
    I start with Peter Anvin's patch to arch/um/Makefile:
    
    	+#
    	+# i386 and x86_64 are separate architectures to the UM build.
    	+#
    	+ifeq ($(SUBARCH),x86)
    	+ifeq ($(CONFIG_64BIT),y)
    	+SUBARCH := x86_64
    	+else
    	+SUBARCH := i386
    	+endif
    	+endif
    
    and fix a couple of things.  CONFIG_64BIT was defined in terms of
    SUBARCH, so this patch is a bit circular in making SUBARCH depend on
    CONFIG_64BIT.  I do like x86 and change the test to
    	ifeq ($(shell uname -m),x86_64)
    
    SUBARCH is used in other places, so in order to just confine changes
    to UML, I define UML_SUBARCH to be either x86_64 or i386 and
    heavy-handedly do s/SUBARCH/UML_SUBARCH in arch/um/Makefile and
    arch/um/os-Linux/Makefile.  This makes the UML build descend through
    the existing -i386 and -x86_64 directories.
    
    CONFIG_64BIT needs to be defined correctly.  This used to be done by
    seeing if SUBARCH = "x86_64".  I replace SUBARCH with UML_SUBARCH,
    which is exported from the Makefile.
    
    This induces a build loop by causing include/config/auto.conf.cmd to
    see an unexpected mismatch between UML_SUBARCH and x86_64
    because the arch Makefile hasn't been included yet, so UML_SUBARCH
    hasn't been set yet.  Somehow, this causes infinite Makefile updates
    and make restarts.  I fixed this by moving the include of the arch
    Makefile above the auto.conf stuff.  UML is fine with this, but maybe
    other arches won't be.

diff --git a/Makefile b/Makefile
index 60de4ef..c25406f 100644
--- a/Makefile
+++ b/Makefile
@@ -473,6 +473,8 @@ libs-y		:= lib/
 core-y		:= usr/
 endif # KBUILD_EXTMOD
 
+include $(srctree)/arch/$(SRCARCH)/Makefile
+
 ifeq ($(dot-config),1)
 # Read in config
 -include include/config/auto.conf
@@ -524,7 +526,6 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
-include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 0d207e7..686c7b0 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -75,3 +75,7 @@ config HZ
 config SUBARCH
 	string
 	option env="SUBARCH"
+
+config UML_SUBARCH
+	string
+	option env="UML_SUBARCH"
diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index 5ee3280..e915680 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -13,7 +13,7 @@ config UML_X86
 
 config 64BIT
 	bool
-	default SUBARCH = "x86_64"
+	default UML_SUBARCH = "x86_64"
 
 config X86_32
 	def_bool !64BIT
diff --git a/arch/um/Makefile b/arch/um/Makefile
index 0728def..28419ef 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -12,6 +12,18 @@ OS := $(shell uname -s)
 # features.
 SHELL := /bin/bash
 
+UML_SUBARCH = $(SUBARCH)
+#
+# i386 and x86_64 are separate architectures to the UM build.
+#
+ifeq ($(SUBARCH),x86)
+ifeq ($(shell uname -m),x86_64)
+	UML_SUBARCH := x86_64
+else
+	UML_SUBARCH := i386
+endif
+endif
+
 filechk_gen_header = $<
 
 core-y			+= $(ARCH_DIR)/kernel/		\
@@ -24,11 +36,11 @@ include $(srctree)/$(ARCH_DIR)/Makefile-skas
 
 SHARED_HEADERS	:= $(ARCH_DIR)/include/shared
 ARCH_INCLUDE	:= -I$(srctree)/$(SHARED_HEADERS)
-ARCH_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)/shared
+ARCH_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/sys-$(UML_SUBARCH)/shared
 ifneq ($(KBUILD_SRC),)
 ARCH_INCLUDE	+= -I$(SHARED_HEADERS)
 endif
-KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
+KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(UML_SUBARCH)
 
 # -Dvmap=kernel_vmap prevents anything from referencing the libpcap.o symbol so
 # named - it's a common symbol in libpcap, so we get a binary which crashes.
@@ -38,7 +50,7 @@ KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
 #
 # These apply to USER_CFLAGS to.
 
-KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\" \
+KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(UML_SUBARCH)\" \
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
 	-Din6addr_loopback=kernel_in6addr_loopback \
 	-Din6addr_any=kernel_in6addr_any
@@ -49,7 +61,7 @@ USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
 	$(patsubst -I%,,$(KBUILD_CFLAGS)))) $(ARCH_INCLUDE) $(MODE_INCLUDE) \
 	$(filter -I%,$(CFLAGS)) -D_FILE_OFFSET_BITS=64
 
-include $(srctree)/$(ARCH_DIR)/Makefile-$(SUBARCH)
+include $(srctree)/$(ARCH_DIR)/Makefile-$(UML_SUBARCH)
 
 #This will adjust *FLAGS accordingly to the platform.
 include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
@@ -99,7 +111,7 @@ CFLAGS_NO_HARDENING := $(call cc-option, -fno-PIC,) $(call cc-option, -fno-pic,)
 CONFIG_KERNEL_STACK_ORDER ?= 2
 STACK_SIZE := $(shell echo $$[ 4096 * (1 << $(CONFIG_KERNEL_STACK_ORDER)) ] )
 
-CPPFLAGS_vmlinux.lds = -U$(SUBARCH) -DSTART=$(START) -DELF_ARCH=$(ELF_ARCH) \
+CPPFLAGS_vmlinux.lds = -U$(UML_SUBARCH) -DSTART=$(START) -DELF_ARCH=$(ELF_ARCH) \
 	-DELF_FORMAT="$(ELF_FORMAT)" -DKERNEL_STACK_SIZE=$(STACK_SIZE)
 
 # The wrappers will select whether using "malloc" or the kernel allocator.
@@ -129,8 +141,8 @@ archclean:
 
 # Generated files
 
-$(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s: FORCE
-	$(Q)$(MAKE) $(build)=$(ARCH_DIR)/sys-$(SUBARCH) $@
+$(ARCH_DIR)/sys-$(UML_SUBARCH)/user-offsets.s: FORCE
+	$(Q)$(MAKE) $(build)=$(ARCH_DIR)/sys-$(UML_SUBARCH) $@
 
 define filechk_gen-asm-offsets
         (set -e; \
@@ -145,7 +157,7 @@ define filechk_gen-asm-offsets
          echo ""; )
 endef
 
-$(SHARED_HEADERS)/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
+$(SHARED_HEADERS)/user_constants.h: $(ARCH_DIR)/sys-$(UML_SUBARCH)/user-offsets.s
 	$(call filechk,gen-asm-offsets)
 
 $(SHARED_HEADERS)/kern_constants.h:
@@ -153,3 +165,4 @@ $(SHARED_HEADERS)/kern_constants.h:
 	$(Q)echo '#include "../../../../include/asm/asm-offsets.h"' >$@
 
 export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
+export UML_SUBARCH
diff --git a/arch/um/os-Linux/Makefile b/arch/um/os-Linux/Makefile
index d66f038..2b23018 100644
--- a/arch/um/os-Linux/Makefile
+++ b/arch/um/os-Linux/Makefile
@@ -5,13 +5,13 @@
 
 obj-y = aio.o elf_aux.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
 	registers.o sigio.o signal.o start_up.o time.o tty.o uaccess.o \
-	umid.o tls.o user_syms.o util.o drivers/ sys-$(SUBARCH)/ skas/
+	umid.o tls.o user_syms.o util.o drivers/ sys-$(UML_SUBARCH)/ skas/
 
 USER_OBJS := $(user-objs-y) aio.o elf_aux.o execvp.o file.o helper.o irq.o \
 	main.o mem.o process.o registers.o sigio.o signal.o start_up.o time.o \
 	tty.o tls.o uaccess.o umid.o util.o
 
-CFLAGS_user_syms.o += -DSUBARCH_$(SUBARCH)
+CFLAGS_user_syms.o += -DSUBARCH_$(UML_SUBARCH)
 
 HAVE_AIO_ABI := $(shell [ -r /usr/include/linux/aio_abi.h ] && \
 	echo -DHAVE_AIO_ABI )
