Return-Path: <linux-kernel-owner+w=401wt.eu-S1423450AbXBHVs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423450AbXBHVs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423453AbXBHVs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:48:58 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:34870 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423450AbXBHVs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:48:57 -0500
Date: Thu, 8 Feb 2007 22:48:51 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Oleg Verych <olecom@flower.upol.cz>
Subject: The who needs reviews anyways [PATCH]
Message-ID: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This adds the remaining changes which should have been part of the review 
process. Oleg could have learned something in process, but who needs that 
if wasting everyones time is so much more fun...

Sorry for the delay, but the git server were gone.

- the define command is inappropriate (it's primarily for rule 
  definitions)
- execute commands in the current dir as all other commands
- .*.tmp (but not .*.null) files are also removed up by "make clean"
- printf has other side effects, instead stop pretending we support 
  something else than bash
- proper quoting
- proper indentation

bye, Roman

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 Makefile               |    9 ++++--
 scripts/Kbuild.include |   72 ++++++++++++++++++++++++-------------------------
 2 files changed, 42 insertions(+), 39 deletions(-)

Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile
+++ linux-2.6/Makefile
@@ -192,8 +192,11 @@ KCONFIG_CONFIG	?= .config
 
 # SHELL used by kbuild
 CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
-	  else if [ -x /bin/bash ]; then echo /bin/bash; \
-	  else echo sh; fi ; fi)
+	  else if [ -x /bin/bash ]; then echo /bin/bash; fi; fi)
+ifeq ($(CONFIG_SHELL),)
+$(error bash is required to build the kernel)
+endif
+SHELL := $(CONFIG_SHELL)
 
 HOSTCC       = gcc
 HOSTCXX      = g++
@@ -321,7 +324,7 @@ KERNELRELEASE = $(shell cat include/conf
 KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
 
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
-export ARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
+export ARCH CONFIG_SHELL SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP MAKE AWK GENKSYMS PERL UTS_MACHINE
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
Index: linux-2.6/scripts/Kbuild.include
===================================================================
--- linux-2.6.orig/scripts/Kbuild.include
+++ linux-2.6/scripts/Kbuild.include
@@ -1,7 +1,7 @@
 ####
 # kbuild: Generic definitions
 
-# Convenient constants
+# Convenient variables
 comma   := ,
 squote  := '
 empty   :=
@@ -56,44 +56,48 @@ endef
 # gcc support functions
 # See documentation in Documentation/kbuild/makefiles.txt
 
-# checker-shell
-# Usage: option = $(call checker-shell,$(CC)...-o $$OUT,option-ok,otherwise)
-# Exit code chooses option. $$OUT is safe location for needless output.
-define checker-shell
-$(shell set -e; \
-  DIR=$(KBUILD_EXTMOD); \
-  cd $${DIR:-$(objtree)}; \
-  OUT=$$PWD/.$$$$.null; \
-  if $(1) >/dev/null 2>&1; \
-    then echo "$(2)"; \
-    else echo "$(3)"; \
-  fi; \
-  rm -f $$OUT)
-endef
+# output directory for tests below
+TMPOUT := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)
+
+# try-run
+# Usage: option = $(call try-run, $(CC)...-o "$$TMP",option-ok,otherwise)
+# Exit code chooses option. "$$TMP" is can be used as temporary file and
+# is automatically cleaned up.
+try-run = $(shell set -e;		\
+	TMP="$(TMPOUT).$$$$.tmp";	\
+	if ($(1)) >/dev/null 2>&1;	\
+	then echo "$(2)";		\
+	else echo "$(3)";		\
+	fi;				\
+	rm -f "$$TMP")
 
 # as-option
 # Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
-as-option = $(call checker-shell,\
-   $(CC) $(CFLAGS) $(1) -c -xassembler /dev/null -o $$OUT,$(1),$(2))
+
+as-option = $(call try-run,\
+	$(CC) $(CFLAGS) $(1) -c -xassembler /dev/null -o "$$TMP",$(1),$(2))
 
 # as-instr
 # Usage: cflags-y += $(call as-instr,instr,option1,option2)
-as-instr = $(call checker-shell,\
-   printf "$(1)" | $(CC) $(AFLAGS) -c -xassembler -o $$OUT -,$(2),$(3))
+
+as-instr = $(call try-run,\
+	echo -e "$(1)" | $(CC) $(AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
 
 # cc-option
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
-cc-option = $(call checker-shell,\
-   $(CC) $(CFLAGS) $(if $(3),$(3),$(1)) -S -xc /dev/null -o $$OUT,$(1),$(2))
+
+cc-option = $(call try-run,\
+	$(CC) $(CFLAGS) $(1) -S -xc /dev/null -o "$$TMP",$(1),$(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
-cc-option-yn = $(call cc-option,"y","n",$(1))
+cc-option-yn = $(call try-run,\
+	$(CC) $(CFLAGS) $(1) -S -xc /dev/null -o "$$TMP",y,n)
 
 # cc-option-align
 # Prefix align with either -falign or -malign
 cc-option-align = $(subst -functions=0,,\
-   $(call cc-option,-falign-functions=0,-malign-functions=0))
+	$(call cc-option,-falign-functions=0,-malign-functions=0))
 
 # cc-version
 # Usage gcc-ver := $(call cc-version,$(CC))
@@ -105,24 +109,22 @@ cc-ifversion = $(shell [ $(call cc-versi
 
 # ld-option
 # Usage: ldflags += $(call ld-option, -Wl$(comma)--hash-style=both)
-ld-option = $(call checker-shell,\
-   $(CC) $(1) -nostdlib -xc /dev/null -o $$OUT,$(1),$(2))
+ld-option = $(call try-run,\
+	$(CC) $(1) -nostdlib -xc /dev/null -o "$$TMP",$(1),$(2))
 
 ######
 
+###
 # Shorthand for $(Q)$(MAKE) -f scripts/Makefile.build obj=
 # Usage:
 # $(Q)$(MAKE) $(build)=dir
 build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
 
-# Prefix -I with $(srctree) if it is not an absolute path,
-# add original to the end
-addtree = $(if \
-	$(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
+# Prefix -I with $(srctree) if it is not an absolute path.
+addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
 
 # Find all -I options and call addtree
-flags = $(foreach o,$($(1)),\
-	$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
+flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
 
 # echo command.
 # Short version is used, if $(quiet) equals `quiet_', otherwise full one.
@@ -144,7 +146,7 @@ objectify = $(foreach o,$(1),$(if $(filt
 # See Documentation/kbuild/makefiles.txt for more info
 
 ifneq ($(KBUILD_NOCMDDEP),1)
-# Check if both arguments has same arguments. Result is empty string, if equal.
+# Check if both arguments has same arguments. Result is empty string if equal.
 # User may override this check using make KBUILD_NOCMDDEP=1
 arg-check = $(strip $(filter-out $(cmd_$(1)), $(cmd_$@)) \
                     $(filter-out $(cmd_$@),   $(cmd_$(1))) )
@@ -168,7 +170,6 @@ if_changed = $(if $(strip $(any-prereq) 
 	echo 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)
 
 # Execute the command and also postprocess generated .d dependencies file.
-#
 if_changed_dep = $(if $(strip $(any-prereq) $(arg-check) ),                  \
 	@set -e;                                                             \
 	$(echo-cmd) $(cmd_$(1));                                             \
@@ -176,10 +177,9 @@ if_changed_dep = $(if $(strip $(any-prer
 	rm -f $(depfile);                                                    \
 	mv -f $(dot-target).tmp $(dot-target).cmd)
 
-# Will check if $(cmd_foo) changed, or any of the prerequisites changed,
-# and if so will execute $(rule_foo).
 # Usage: $(call if_changed_rule,foo)
-#
+# Will check if $(cmd_foo) or any of the prerequisites changed,
+# and if so will execute $(rule_foo).
 if_changed_rule = $(if $(strip $(any-prereq) $(arg-check) ),                 \
 	@set -e;                                                             \
 	$(rule_$(1)))
