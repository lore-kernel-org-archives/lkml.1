Return-Path: <linux-kernel-owner+w=401wt.eu-S1760798AbYFDVr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798AbYFDVr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYFDVrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:47:17 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41445 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbYFDVrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:47:15 -0400
Date: Wed, 4 Jun 2008 23:47:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH 2/2] kbuild: simplify vmlinux link stage
Message-ID: <20080604214713.GC13032@uranus.ravnborg.org>
References: <20080604214514.GA13032@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604214514.GA13032@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 68e9b79c8dad5245f28ab4f3527481b730dbdb61 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 4 Jun 2008 23:38:15 +0200
Subject: [PATCH] kbuild: simplify vmlinux link stage

Move link of vmlinux from Makefile to a script
This makes the link process much more readable/maintainable.

The process was entirely serialized before so there is not
drawback doing so.

With this move take advantage of the prelinked vmlinux.o
file so we do not link all .o files more than once.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                |  168 ++++-------------------------------------------
 arch/um/Makefile        |   17 +----
 scripts/link-vmlinux.sh |  144 ++++++++++++++++++++++++++++++++++++++++
 scripts/mksysmap        |   45 -------------
 4 files changed, 161 insertions(+), 213 deletions(-)
 create mode 100644 scripts/link-vmlinux.sh
 delete mode 100644 scripts/mksysmap

diff --git a/Makefile b/Makefile
index 911cb90..a958d34 100644
--- a/Makefile
+++ b/Makefile
@@ -626,172 +626,32 @@ libs-y1		:= $(patsubst %/, %/lib.a, $(libs-y))
 libs-y2		:= $(patsubst %/, %/built-in.o, $(libs-y))
 libs-y		:= $(libs-y1) $(libs-y2)
 
-# Build vmlinux
-# ---------------------------------------------------------------------------
-# vmlinux is built from the objects selected by $(vmlinux-init) and
-# $(vmlinux-main). Most are built-in.o files from top-level directories
-# in the kernel tree, others are specified in arch/$(ARCH)/Makefile.
-# Ordering when linking is important, and $(vmlinux-init) must be first.
-#
-# vmlinux
-#   ^
-#   |
-#   +-< $(vmlinux-init)
-#   |   +--< init/version.o + more
-#   |
-#   +--< $(vmlinux-main)
-#   |    +--< driver/built-in.o mm/built-in.o + more
-#   |
-#   +-< kallsyms.o (see description in CONFIG_KALLSYMS section)
 #
-# vmlinux version (uname -v) cannot be updated during normal
-# descending-into-subdirs phase since we do not yet know if we need to
-# update vmlinux.
-# Therefore this step is delayed until just before final link of vmlinux -
-# except in the kallsyms case where it is done just before adding the
-# symbols to the kernel.
+# Build vmlinux
 #
-# System.map is generated to document addresses of all kernel symbols
-
-vmlinux-init := $(head-y) $(init-y)
-vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y)
-vmlinux-all  := $(vmlinux-init) $(vmlinux-main)
-vmlinux-lds  := arch/$(SRCARCH)/kernel/vmlinux.lds
-export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
-
-# Rule to link vmlinux - also used during CONFIG_KALLSYMS
-# May be overridden by arch/$(ARCH)/Makefile
-quiet_cmd_vmlinux__ ?= LD      $@
-      cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
-      -T $(vmlinux-lds) $(vmlinux-init)                          \
-      --start-group $(vmlinux-main) --end-group                  \
-      $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
-
-# Generate new vmlinux version
-quiet_cmd_vmlinux_version = GEN     .version
-      cmd_vmlinux_version = set -e;                     \
-	if [ ! -r .version ]; then			\
-	  rm -f .version;				\
-	  echo 1 >.version;				\
-	else						\
-	  mv .version .old_version;			\
-	  expr 0$$(cat .old_version) + 1 >.version;	\
-	fi;						\
-	$(MAKE) $(build)=init
-
-# Generate System.map
-quiet_cmd_sysmap = SYSMAP
-      cmd_sysmap = $(CONFIG_SHELL) $(srctree)/scripts/mksysmap
-
-# Link of vmlinux
-# If CONFIG_KALLSYMS is set .version is already updated
-# Generate System.map and verify that the content is consistent
-# Use + in front of the vmlinux_version rule to silent warning with make -j2
-# First command is ':' to allow us to use + in front of the rule
-define rule_vmlinux__
-	:
-	$(if $(CONFIG_KALLSYMS),,+$(call cmd,vmlinux_version))
-
-	$(call cmd,vmlinux__)
-	$(Q)echo 'cmd_$@ := $(cmd_vmlinux__)' > $(@D)/.$(@F).cmd
-
-	$(Q)$(if $($(quiet)cmd_sysmap),                                      \
-	  echo '  $($(quiet)cmd_sysmap)  System.map' &&)                     \
-	$(cmd_sysmap) $@ System.map;                                         \
-	if [ $$? -ne 0 ]; then                                               \
-		rm -f $@;                                                    \
-		/bin/false;                                                  \
-	fi;
-endef
-
-
-ifdef CONFIG_KALLSYMS
-# Generate section listing all symbols and add it into vmlinux $(kallsyms.o)
-# It's a three stage process:
-# o .tmp_vmlinux1 has all symbols and sections, but __kallsyms is
-#   empty
-#   Running kallsyms on that gives us .tmp_kallsyms1.o with
-#   the right size - vmlinux version (uname -v) is updated during this step
-# o .tmp_vmlinux2 now has a __kallsyms section of the right size,
-#   but due to the added section, some addresses have shifted.
-#   From here, we generate a correct .tmp_kallsyms2.o
-# o The correct .tmp_kallsyms2.o is linked into the final vmlinux.
-# o Verify that the System.map from vmlinux matches the map from
-#   .tmp_vmlinux2, just in case we did not generate kallsyms correctly.
-
-kallsyms.o := .tmp_kallsyms2.o
-
-# Update vmlinux version before link
-# Use + in front of this rule to silent warning about make -j1
-# First command is ':' to allow us to use + in front of this rule
-cmd_ksym_ld = $(cmd_vmlinux__)
-define rule_ksym_ld
-	: 
-	+$(call cmd,vmlinux_version)
-	$(call cmd,vmlinux__)
-	$(Q)echo 'cmd_$@ := $(cmd_vmlinux__)' > $(@D)/.$(@F).cmd
-endef
-
-# Generate .S file with all kernel symbols
-quiet_cmd_kallsyms = KSYM    $@
-      cmd_kallsyms = $(NM) -n $< | $(KALLSYMS) \
-                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) > $@
-
-.tmp_kallsyms1.o .tmp_kallsyms2.o: %.o: %.S scripts FORCE
-	$(call if_changed_dep,as_o_S)
-
-.tmp_kallsyms%.S: .tmp_vmlinux% $(KALLSYMS)
-	$(call cmd,kallsyms)
-
-# .tmp_vmlinux1 must be complete except kallsyms, so update vmlinux version
-.tmp_vmlinux1: $(vmlinux-lds) $(vmlinux-all) FORCE
-	$(call if_changed_rule,ksym_ld)
-
-.tmp_vmlinux2: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms1.o FORCE
-	$(call if_changed,vmlinux__)
-
-# Needs to visit scripts/ before $(KALLSYMS) can be used.
-$(KALLSYMS): scripts ;
-
-endif # ifdef CONFIG_KALLSYMS
+# ---------------------------------------------------------------------------
+export KBUILD_VMLINUX_INIT := $(head-y) $(init-y)
+export KBUILD_VMLINUX_MAIN := $(core-y) $(libs-y) $(drivers-y) $(net-y)
+export KBUILD_VMLINUX_LDS  := arch/$(SRCARCH)/kernel/vmlinux.lds
+export KBUILD_VMLINUX_EXTRA
+export LDFLAGS_vmlinux
 
-# Do modpost on a prelinked vmlinux. The finally linked vmlinux has
-# relevant sections renamed as per the linker script.
-quiet_cmd_vmlinux-modpost = LD      $@
-      cmd_vmlinux-modpost = $(LD) $(LDFLAGS) -r -o $@                          \
-	 $(vmlinux-init) --start-group $(vmlinux-main) --end-group             \
-	 $(filter-out $(vmlinux-init) $(vmlinux-main) FORCE ,$^)
-define rule_vmlinux-modpost
-	:
-	+$(call cmd,vmlinux-modpost)
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
-	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
-endef
+vmlinux-deps := $(KBUILD_VMLINUX_INIT) $(KBUILD_VMLINUX_MAIN)
+vmlinux-deps += $(KBUILD_VMLINUX_LDS)
 
 # vmlinux image - including updated kernel symbols
-vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o $(kallsyms.o) FORCE
+vmlinux: $(vmlinux-deps)
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
 ifdef CONFIG_SAMPLES
 	$(Q)$(MAKE) $(build)=samples
 endif
-	$(call vmlinux-modpost)
-	$(call if_changed_rule,vmlinux__)
-	$(Q)rm -f .old_version
-
-# build vmlinux.o first to catch section mismatch errors early
-ifdef CONFIG_KALLSYMS
-.tmp_vmlinux1: vmlinux.o
-endif
-
-modpost-init := $(filter-out init/built-in.o, $(vmlinux-init))
-vmlinux.o: $(modpost-init) $(vmlinux-main) FORCE
-	$(call if_changed_rule,vmlinux-modpost)
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh
 
-# The actual objects are generated when descending, 
+# The actual objects are generated when descending,
 # make sure no implicit rule kicks in
-$(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds): $(vmlinux-dirs) ;
+$(sort $(vmlinux-deps)): $(vmlinux-dirs) ;
 
 # Handle descending into subdirectories listed in $(vmlinux-dirs)
 # Preset locale variables to speed up the build process. Limit locale
diff --git a/arch/um/Makefile b/arch/um/Makefile
index dbeab15..06cbc09 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -104,7 +104,7 @@ archprepare: $(ARCH_SYMLINKS) $(ARCH_DIR)/include/user_constants.h
 prepare: $(ARCH_DIR)/include/kern_constants.h
 
 LINK-$(CONFIG_LD_SCRIPT_STATIC) += -static
-LINK-$(CONFIG_LD_SCRIPT_DYN) += -Wl,-rpath,/lib
+LINK-$(CONFIG_LD_SCRIPT_DYN) += -rpath /lib -rpath /usr/lib
 
 CFLAGS_NO_HARDENING := $(call cc-option, -fno-PIC,) $(call cc-option, -fno-pic,) \
 	$(call cc-option, -fno-stack-protector,) \
@@ -117,19 +117,8 @@ CPPFLAGS_vmlinux.lds = -U$(SUBARCH) -DSTART=$(START) -DELF_ARCH=$(ELF_ARCH) \
 	-DELF_FORMAT="$(ELF_FORMAT)" -DKERNEL_STACK_SIZE=$(STACK_SIZE)
 
 # The wrappers will select whether using "malloc" or the kernel allocator.
-LINK_WRAPS = -Wl,--wrap,malloc -Wl,--wrap,free -Wl,--wrap,calloc
-
-LD_FLAGS_CMDLINE = $(foreach opt,$(LDFLAGS),-Wl,$(opt))
-
-CFLAGS_vmlinux := $(LINK-y) $(LINK_WRAPS) $(LD_FLAGS_CMDLINE)
-define cmd_vmlinux__
-	$(CC) $(CFLAGS_vmlinux) -o $@ \
-	-Wl,-T,$(vmlinux-lds) $(vmlinux-init) \
-	-Wl,--start-group $(vmlinux-main) -Wl,--end-group \
-	-lutil \
-	$(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o \
-	FORCE ,$^) ; rm -f linux
-endef
+LDFLAGS_vmlinux := $(LINK-y) --wrap malloc --wrap free --wrap calloc
+KBUILD_VMLINUX_EXTRA := -lutil
 
 # When cleaning we don't include .config, so we don't include
 # TT or skas makefiles and don't clean skas_ptregs.h.
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
new file mode 100644
index 0000000..224f698
--- /dev/null
+++ b/scripts/link-vmlinux.sh
@@ -0,0 +1,144 @@
+# Build vmlinux
+# ---------------------------------------------------------------------------
+# vmlinux is built from the objects selected by $(KBUILD_VMLINUX_INIT) and
+# $(KBUILD_VMLINUX_MAIN). Most are built-in.o files from top-level directories
+# in the kernel tree, others are specified in arch/$(ARCH)/Makefile.
+# Ordering when linking is important, and $(KBUILD_VMLINUX_INIT) must be first.
+#
+# vmlinux
+#   ^
+#   |
+#   +-< $(KBUILD_VMLINUX_INIT)
+#   |   +--< init/version.o + more
+#   |
+#   +--< $(KBUILD_VMLINUX_MAIN)
+#   |    +--< driver/built-in.o mm/built-in.o + more
+#   |
+#   +-< $(KBUILD_VMLINUX_EXTRA)
+#
+# vmlinux version (uname -v) cannot be updated during normal
+# descending-into-subdirs phase since we do not yet know if we need to
+# update vmlinux.
+#
+# System.map is generated to document addresses of all kernel symbols
+
+MAKE=make
+
+# We need access to CONFIG_ symbols
+source .config
+# Error out on error
+set -e
+# USe "make V=3" to debug this script
+if [ "${KBUILD_VERBOSE}" = "3" ]; then
+	set -x
+fi
+# Override MAKEFLAGS to avoid parrallel builds
+MAKEFLAGS='--no-print-directory -Rr'
+# Delete output files in case of error
+trap cleanup SIGHUP SIGINT SIGQUIT SIGTERM ERR
+cleanup()
+{
+	rm -f vmlinux.o
+	rm -f .old_version
+	rm -f .tmp_vmlinux*
+	rm -f .tmp_kallsyms*
+	rm -f vmlinux
+	rm -f .tmp_System.map
+	rm -f System.map
+}
+# non-verbose output
+tell()
+{
+	printf "  %-7s %s\n" $1 $2
+}
+
+#####
+# Generate System.map
+
+# $NM produces the following output:
+# f0081e80 T alloc_vfsmnt
+
+#   The second row specify the type of the symbol:
+#   A = Absolute
+#   B = Uninitialised data (.bss)
+#   C = Comon symbol
+#   D = Initialised data
+#   G = Initialised data for small objects
+#   I = Indirect reference to another symbol
+#   N = Debugging symbol
+#   R = Read only
+#   S = Uninitialised data for small objects
+#   T = Text code symbol
+#   U = Undefined symbol
+#   V = Weak symbol
+#   W = Weak symbol
+#   Corresponding small letters are local symbols
+
+# For System.map filter away:
+#   a - local absolute symbols
+#   N = Debugging symbol
+#   U - undefined global symbols
+#   w - local weak symbols
+
+# readprofile starts reading symbols when _stext is found, and
+# continue until it finds a symbol which is not either of 'T', 't',
+# 'W' or 'w'. __crc_ are 'A' and placed in the middle
+# so we just ignore them to let readprofile continue to work.
+# (At least sparc64 has __crc_ in the middle).
+mksysmap()
+{
+	$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)'
+}
+
+# link vmlinux.o
+tell LD vmlinux.o
+${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -r -o vmlinux.o      \
+	${KBUILD_VMLINUX_INIT}                           \
+        --start-group ${KBUILD_VMLINUX_MAIN} --end-group \
+	${KBUILD_VMLINUX_EXTRA}
+
+# modpost vmlinux.o
+${MAKE} -f ${srctree}/scripts/Makefile.modpost vmlinux.o
+
+# Update version
+tell GEN .version
+if [ ! -r .version ]; then
+	rm -f .version;
+	echo 1 >.version;
+else
+	mv .version .old_version;
+	expr 0$(cat .old_version) + 1 >.version;
+fi;
+
+# final build of init/
+${MAKE} -f ${srctree}/scripts/Makefile.build obj=init
+
+VMLINUX=vmlinux
+if [ "${CONFIG_KALLSYMS}" = "y" ]; then
+	VMLINUX=.tmp_vmlinux
+fi
+
+# First stage of fully linked vmlinux
+tell LD ${VMLINUX}
+${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${VMLINUX} \
+      -T ${KBUILD_VMLINUX_LDS} vmlinux.o
+
+if [ "${CONFIG_KALLSYMS}" = "y" ]; then
+
+	# Do an extra pass to link in kallsyms data
+	${NM} -n .tmp_vmlinux | scripts/kallsyms > .tmp_kallsyms.S
+        ${CC} ${KBUILD_AFLAGS} ${KBUILD_CPPFLAGS} -c -o .tmp_kallsyms.o \
+	      .tmp_kallsyms.S
+        # link in kalll symbols
+	tell LD vmlinux
+        ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o vmlinux \
+         -T ${KBUILD_VMLINUX_LDS} vmlinux.o .tmp_kallsyms.o
+fi
+
+tell SYSMAP System.map
+mksysmap vmlinux > System.map
+
+# We made a new kernel - delete old version file
+rm -f .old_version
+
+
diff --git a/scripts/mksysmap b/scripts/mksysmap
deleted file mode 100644
index 6e133a0..0000000
--- a/scripts/mksysmap
+++ /dev/null
@@ -1,45 +0,0 @@
-#!/bin/sh -x
-# Based on the vmlinux file create the System.map file
-# System.map is used by module-init tools and some debugging
-# tools to retrieve the actual addresses of symbols in the kernel.
-#
-# Usage
-# mksysmap vmlinux System.map
-
-
-#####
-# Generate System.map (actual filename passed as second argument)
-
-# $NM produces the following output:
-# f0081e80 T alloc_vfsmnt
-
-#   The second row specify the type of the symbol:
-#   A = Absolute
-#   B = Uninitialised data (.bss)
-#   C = Comon symbol
-#   D = Initialised data
-#   G = Initialised data for small objects
-#   I = Indirect reference to another symbol
-#   N = Debugging symbol
-#   R = Read only
-#   S = Uninitialised data for small objects
-#   T = Text code symbol
-#   U = Undefined symbol
-#   V = Weak symbol
-#   W = Weak symbol
-#   Corresponding small letters are local symbols
-
-# For System.map filter away:
-#   a - local absolute symbols
-#   U - undefined global symbols
-#   N - debugging symbols
-#   w - local weak symbols
-
-# readprofile starts reading symbols when _stext is found, and
-# continue until it finds a symbol which is not either of 'T', 't',
-# 'W' or 'w'. __crc_ are 'A' and placed in the middle
-# so we just ignore them to let readprofile continue to work.
-# (At least sparc64 has __crc_ in the middle).
-
-$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2
-
-- 
1.5.4.1.143.ge7e51

