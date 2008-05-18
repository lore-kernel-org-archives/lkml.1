Return-Path: <linux-kernel-owner+w=401wt.eu-S1762935AbYERS7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762935AbYERS7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761376AbYERSvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:51:46 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53478 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760260AbYERSvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:51:43 -0400
Date: Sun, 18 May 2008 20:52:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [RFC PATCH] move link of vmlinux from Makefile to a script
Message-ID: <20080518185219.GA777@uranus.ravnborg.org>
References: <482DCD89.76E4.0078.0@novell.com> <20080517125204.GA19741@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080517125204.GA19741@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I have several times been tempted to move it all to a shell script.
> What has prevented me to do so has only been:
> 1) that um has some subtle requirement and therefore redefine the
>    vmlinux link
> 2) that last time I reworked this stuff Andrew could not boot one
>    of his systems and I never figured out why
> 3) lack of time..
> 
> But if someone comes up with a patch that moves all this stuff out
> of the top-level Makefile I am all open for it.

I gave it a quick try. This is first try and comments are welcome.
It does not address the um issue - but I think that is doable
with an additional enviroment variable.

The conditionals around KALLSYMS may be simplified - I just did
not try to do so.

What I like with the patch below is that it is 100 times more
readable than the Makefile stuff.
The drawback are that we either link or not - we cannot restart
from the middle of the link. But that it not a real issue.

This patch futhermore remove a debug target to assist in
kallysms issues - I have not seen it used for a long time
now. And I was also considering removing the extra kallsyms
pass as I dunnot how usefull it is and for an allyesconfig
build it take too much time.

This patch includes your version simplifactions too allthough
that is not obvious.

	Sam


 Makefile                |  196 ++++-------------------------------------------
 scripts/link-vmlinux.sh |  132 +++++++++++++++++++++++++++++++
 scripts/mksysmap        |   44 -----------
 3 files changed, 148 insertions(+), 224 deletions(-)


diff --git a/Makefile b/Makefile
index 3140145..6589ae5 100644
--- a/Makefile
+++ b/Makefile
@@ -628,204 +628,40 @@ libs-y		:= $(libs-y1) $(libs-y2)
 
 # Build vmlinux
 # ---------------------------------------------------------------------------
-# vmlinux is built from the objects selected by $(vmlinux-init) and
-# $(vmlinux-main). Most are built-in.o files from top-level directories
+# vmlinux is built from the objects selected by $(KBUILD_VMLINUX_INIT) and
+# $(KBUILD_VMLINUX_MAIN). Most are built-in.o files from top-level directories
 # in the kernel tree, others are specified in arch/$(ARCH)/Makefile.
-# Ordering when linking is important, and $(vmlinux-init) must be first.
+# Ordering when linking is important, and $(KBUILD_VMLINUX_INIT) must be first.
 #
 # vmlinux
 #   ^
 #   |
-#   +-< $(vmlinux-init)
+#   +-< $(KBUILD_VMLINUX_INIT)
 #   |   +--< init/version.o + more
 #   |
-#   +--< $(vmlinux-main)
-#   |    +--< driver/built-in.o mm/built-in.o + more
-#   |
-#   +-< kallsyms.o (see description in CONFIG_KALLSYMS section)
-#
-# vmlinux version (uname -v) cannot be updated during normal
-# descending-into-subdirs phase since we do not yet know if we need to
-# update vmlinux.
-# Therefore this step is delayed until just before final link of vmlinux -
-# except in the kallsyms case where it is done just before adding the
-# symbols to the kernel.
-#
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
-	$(verify_kallsyms)
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
-# o If CONFIG_KALLSYMS_EXTRA_PASS is set, do an extra pass using
-#   .tmp_vmlinux3 and .tmp_kallsyms3.o.  This is only meant as a
-#   temporary bypass to allow the kernel to be built while the
-#   maintainers work out what went wrong with kallsyms.
-
-ifdef CONFIG_KALLSYMS_EXTRA_PASS
-last_kallsyms := 3
-else
-last_kallsyms := 2
-endif
-
-kallsyms.o := .tmp_kallsyms$(last_kallsyms).o
-
-define verify_kallsyms
-	$(Q)$(if $($(quiet)cmd_sysmap),                                      \
-	  echo '  $($(quiet)cmd_sysmap)  .tmp_System.map' &&)                \
-	  $(cmd_sysmap) .tmp_vmlinux$(last_kallsyms) .tmp_System.map
-	$(Q)cmp -s System.map .tmp_System.map ||                             \
-		(echo Inconsistent kallsyms data;                            \
-		 echo Try setting CONFIG_KALLSYMS_EXTRA_PASS;                \
-		 rm .tmp_kallsyms* ; /bin/false )
-endef
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
+#   +--< $(KBUILD_VMLINUX_MAIN)
+#        +--< driver/built-in.o mm/built-in.o + more
 
-.tmp_kallsyms1.o .tmp_kallsyms2.o .tmp_kallsyms3.o: %.o: %.S scripts FORCE
-	$(call if_changed_dep,as_o_S)
+export KBUILD_VMLINUX_INIT := $(head-y) $(init-y)
+export KBUILD_VMLINUX_MAIN := $(core-y) $(libs-y) $(drivers-y) $(net-y)
+export KBUILD_VMLINUX_LDS  := arch/$(SRCARCH)/kernel/vmlinux.lds
 
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
-.tmp_vmlinux3: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms2.o FORCE
-	$(call if_changed,vmlinux__)
-
-# Needs to visit scripts/ before $(KALLSYMS) can be used.
-$(KALLSYMS): scripts ;
-
-# Generate some data for debugging strange kallsyms problems
-debug_kallsyms: .tmp_map$(last_kallsyms)
-
-.tmp_map%: .tmp_vmlinux% FORCE
-	($(OBJDUMP) -h $< | $(AWK) '/^ +[0-9]/{print $$4 " 0 " $$2}'; $(NM) $<) | sort > $@
-
-.tmp_map3: .tmp_map2
-
-.tmp_map2: .tmp_map1
-
-endif # ifdef CONFIG_KALLSYMS
-
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
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
new file mode 100644
index 0000000..e25f4ff
--- /dev/null
+++ b/scripts/link-vmlinux.sh
@@ -0,0 +1,132 @@
+# Build vmlinux
+# ---------------------------------------------------------------------------
+# vmlinux is built from the objects selected by $(vmlinux-init) and
+# $(vmlinux-main). Most are built-in.o files from top-level directories
+# in the kernel tree, others are specified in arch/$(ARCH)/Makefile.
+# Ordering when linking is important, and $(vmlinux-init) must be first.
+#
+# vmlinux
+#   ^
+#   |
+#   +-< $(vmlinux-init)
+#   |   +--< init/version.o + more
+#   |
+#   +--< $(vmlinux-main)
+#   |    +--< driver/built-in.o mm/built-in.o + more
+#   |
+#   +-< kallsyms.o (see description in CONFIG_KALLSYMS section)
+#
+# vmlinux version (uname -v) cannot be updated during normal
+# descending-into-subdirs phase since we do not yet know if we need to
+# update vmlinux.
+# Therefore this step is delayed until just before final link of vmlinux -
+# except in the kallsyms case where it is done just before adding the
+# symbols to the kernel.
+#
+# System.map is generated to document addresses of all kernel symbols
+
+
+MAKE=make
+
+source .config
+set -x
+
+#####
+# Generate System.map (output are written to stdout
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
+	$NM -n $1 | grep -v '\( [aUw] \)\|\(__crc_\)\|\( \$[adt]\)'
+}
+
+# link vmlinux.o
+${LD} ${LDFLAGS} -r -o vmlinux.o ${KBUILD_VMLINUX_INIT}              \
+        --start-group ${KBUILD_VMLINUX_MAIN} --end-group
+
+# modpost vmlinux.o
+${MAKE} -f ${srctree}/scripts/Makefile.modpost vmlinux.o
+
+# Update version
+set -e
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
+	VMLINUX_KALL=vmlinux
+	SYSTEMMAP=System.map
+fi
+if [ "${CONFIG_KALLSYMS_EXTRA_PASS}" = "y" ]; then
+	VMLINUX_KALL=.tmp_vmlinux_kall
+	SYSTEMMAP=.tmp_System.map
+fi
+
+# First stage of fully linked vmlinux
+${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${VMLINUX} -T ${KBUILD_VMLINUX_LDS} vmlinux.o
+
+if [ "${CONFIG_KALLSYMS}" = "y" ]; then
+	#Generate kernel symbols
+	${NM} -n .tmp_vmlinux | scripts/kallsyms > .tmp_kallsyms.S
+	${CC} ${KBUILD_AFLAGS} ${KBUILD_CPPFLAGS} -c -o .tmp_kallsyms.o .tmp_kallsyms.S
+	# link in kalll symbols
+	${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${VMLINUX_KALL} \
+	 -T ${KBUILD_VMLINUX_LDS} vmlinux.o .tmp_kallsyms.o
+	mksysmap ${VMLINUX_KALL} > ${SYSTEMMAP}
+fi
+
+if [ "${CONFIG_KALLSYMS_EXTRA_PASS}" = "y" ]; then
+	# Do an extra pass to check that symbol did not change when linked in
+	${NM} -n ${VMLINUX_KALL} | scripts/kallsyms > .tmp_kallsyms_extra.S
+        ${CC} ${KBUILD_AFLAGS} ${KBUILD_CPPFLAGS} -c -o .tmp_kallsyms_extra.o .tmp_kallsyms_extra.S
+        # link in kalll symbols
+        ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o vmlinux \
+         -T ${KBUILD_VMLINUX_LDS} vmlinux.o .tmp_kallsyms2.o
+	mksysmap vmlinux > System.map
+	cmp -s System.map ${SYSTEMMAP} || \
+		(echo Inconsistent kallsyms data;
+		 echo Try setting CONFIG_KALLSYMS_EXTRA_PASS;
+		 rm .tmp_kallsyms* ;
+		 exit 1 )
+fi
+# We made a new kernel - delete old version file
+rm -f .old_version
+
+
diff --git a/scripts/mksysmap b/scripts/mksysmap
deleted file mode 100644
index 4390fab..0000000
--- a/scripts/mksysmap
+++ /dev/null
@@ -1,44 +0,0 @@
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
-#   w - local weak symbols
-
-# readprofile starts reading symbols when _stext is found, and
-# continue until it finds a symbol which is not either of 'T', 't',
-# 'W' or 'w'. __crc_ are 'A' and placed in the middle
-# so we just ignore them to let readprofile continue to work.
-# (At least sparc64 has __crc_ in the middle).
-
-$NM -n $1 | grep -v '\( [aUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2
-
