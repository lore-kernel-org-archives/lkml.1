Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbXAaFnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbXAaFnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 00:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932896AbXAaFnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 00:43:31 -0500
Received: from main.gmane.org ([80.91.229.2]:37639 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932786AbXAaFna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 00:43:30 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: [patch] kbuild: improving gcc option checking
Date: Wed, 31 Jan 2007 05:43:19 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnes0bka.f71.olecom@flower.upol.cz>
X-Complaints-To: usenet@sea.gmane.org
Keywords: kbuild patch option checking
X-Gmane-NNTP-Posting-Host: flower.upol.cz
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>, Oleg Verych <olecom@flower.upol.cz>, Andrew Morton <akpm@osdl.org>, Roman Zippel <zippel@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org> Horst Schirmeier <horst@schirmeier.com>, Jan Beulich <jbeulich@novell.com>, Daniel Drake <dsd@gentoo.org>, Andi Kleen <ak@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild: improving option checking, Kbuild.include cleanup

 GNU binutils, root users, tmpfiles, external modules ro builds must
 be fixed to do the right thing now.

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Horst Schirmeier <horst@schirmeier.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Daniel Drake <dsd@gentoo.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
---

-- all checks by shell united in one macro -- checker-shell;
-- one disposable output sym. link to /dev/null per shell,
   thus no racing, `-Z' is removed;
-- modules' build output directory is used, if supplied;
-- every option checking function calls shell wrapper, acquires probe;
-- `echo -e' bashizm substituted (people with sh != bash have distinct
   CC options!);
-- some spelling and sense added to the comments;
-- small shuffle of whitespace.

Mostly all people, discussing this back in October are in the CC list.
Sam Ravnborg have not much time to reply. I've added Roman Zippel, as
a very kind reviewer and commiter of previous fix. Comments and
testing are appreciated. Thanks.

Note. `Mail-Followup-To' header is used to supply reply-to list.

-o--=O`C
 #oo'L O
<___=E M

--- linux-2.6.20-rc6/scripts/Kbuild.include~4-gcc-option-check	2007-01-12 19:54:26.000000000 +0100
+++ linux-2.6.20-rc6/scripts/Kbuild.include	2007-01-31 05:56:58.942445500 +0100
@@ -2,5 +2,5 @@
 # kbuild: Generic definitions
 
-# Convinient variables
+# Convenient constants
 comma   := ,
 squote  := '
@@ -57,38 +57,44 @@ endef
 # See documentation in Documentation/kbuild/makefiles.txt
 
-# output directory for tests below
-TMPOUT := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)
+# checker-shell
+# Usage: option = $(call checker-shell, $(CC)...-o $$OUT, option-ok, otherwise)
+# Exit code chooses option. $$OUT is safe location for needless output.
+define checker-shell
+  $(shell set -e; \
+    DIR=$(KBUILD_EXTMOD); \
+    cd $${DIR:-$(objtree)}; \
+    OUT=$$PWD/.$$$$.null; \
+    \
+    ln -s /dev/null $$OUT; \
+    if $(1) >/dev/null 2>&1; \
+      then echo "$(2)"; \
+      else echo "$(3)"; \
+    fi; \
+    rm -f $$OUT)
+endef
 
 # as-option
 # Usage: cflags-y += $(call as-option, -Wa$(comma)-isa=foo,)
-
-as-option = $(shell if $(CC) $(CFLAGS) $(1) -Wa,-Z -c -o /dev/null \
-	     -xassembler /dev/null > /dev/null 2>&1; then echo "$(1)"; \
-	     else echo "$(2)"; fi ;)
+as-option = $(call checker-shell, \
+   $(CC) $(CFLAGS) $(1) -c -xassembler /dev/null -o $$OUT, $(1), $(2))
 
 # as-instr
 # Usage: cflags-y += $(call as-instr, instr, option1, option2)
-
-as-instr = $(shell if echo -e "$(1)" | \
-		      $(CC) $(AFLAGS) -c -xassembler - \
-			    -o $(TMPOUT)astest$$$$.out > /dev/null 2>&1; \
-		   then rm $(TMPOUT)astest$$$$.out; echo "$(2)"; \
-		   else echo "$(3)"; fi)
+as-instr = $(call checker-shell, \
+   printf "$(1)" | $(CC) $(AFLAGS) -c -xassembler -o $$OUT -, $(2), $(3))
 
 # cc-option
 # Usage: cflags-y += $(call cc-option, -march=winchip-c6, -march=i586)
-
-cc-option = $(shell if $(CC) $(CFLAGS) $(1) -S -o /dev/null -xc /dev/null \
-             > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
+cc-option = $(call checker-shell, \
+   $(CC) $(CFLAGS) $(if $(3),$(3),$(1)) -S -xc /dev/null -o $$OUT, $(1), $(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn, -march=winchip-c6)
-cc-option-yn = $(shell if $(CC) $(CFLAGS) $(1) -S -o /dev/null -xc /dev/null \
-                > /dev/null 2>&1; then echo "y"; else echo "n"; fi;)
+cc-option-yn = $(call cc-option, "y", "n", $(1))
 
 # cc-option-align
 # Prefix align with either -falign or -malign
 cc-option-align = $(subst -functions=0,,\
-	$(call cc-option,-falign-functions=0,-malign-functions=0))
+   $(call cc-option,-falign-functions=0,-malign-functions=0))
 
 # cc-version
@@ -98,15 +104,13 @@ cc-version = $(shell $(CONFIG_SHELL) $(s
 # cc-ifversion
 # Usage:  EXTRA_CFLAGS += $(call cc-ifversion, -lt, 0402, -O1)
-cc-ifversion = $(shell if [ $(call cc-version, $(CC)) $(1) $(2) ]; then \
-                       echo $(3); fi;)
+cc-ifversion = $(shell [ $(call cc-version, $(CC)) $(1) $(2) ] && echo $(3))
 
 # ld-option
 # Usage: ldflags += $(call ld-option, -Wl$(comma)--hash-style=both)
-ld-option = $(shell if $(CC) $(1) -nostdlib -xc /dev/null \
-			     -o $(TMPOUT)ldtest$$$$.out > /dev/null 2>&1; \
-             then rm $(TMPOUT)ldtest$$$$.out; echo "$(1)"; \
-             else echo "$(2)"; fi)
+ld-option = $(call checker-shell, \
+   $(CC) $(1) -nostdlib -xc /dev/null -o $$OUT, $(1), $(2))
+
+######
 
-###
 # Shorthand for $(Q)$(MAKE) -f scripts/Makefile.build obj=
 # Usage:
@@ -114,17 +118,26 @@ ld-option = $(shell if $(CC) $(1) -nostd
 build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
 
-# Prefix -I with $(srctree) if it is not an absolute path
-addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
+# Prefix -I with $(srctree) if it is not an absolute path,
+# add original to the end
+addtree = $(if \
+	$(filter-out -I/%, $(1)), $(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
+
 # Find all -I options and call addtree
-flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
+flags = $(foreach o,$($(1)), \
+	$(if $(filter -I%,$(o)), $(call addtree, $(o)), $(o)))
 
-# If quiet is set, only print short version of command
+# echo command.
+# Short version is used, if $(quiet) equals `quiet_', otherwise full one.
+echo-cmd = $(if $($(quiet)cmd_$(1)), \
+	echo '  $(call escsq,$($(quiet)cmd_$(1)))$(echo-why)';)
+
+# printing commands
 cmd = @$(echo-cmd) $(cmd_$(1))
 
-# Add $(obj)/ for paths that is not absolute
-objectify = $(foreach o,$(1),$(if $(filter /%,$(o)),$(o),$(obj)/$(o)))
+# Add $(obj)/ for paths that are not absolute
+objectify = $(foreach o,$(1), $(if $(filter /%,$(o)), $(o), $(obj)/$(o)))
 
 ###
-# if_changed      - execute command if any prerequisite is newer than 
+# if_changed      - execute command if any prerequisite is newer than
 #                   target, or command line has changed
 # if_changed_dep  - as if_changed, but uses fixdep to reveal dependencies
@@ -134,5 +147,5 @@ objectify = $(foreach o,$(1),$(if $(filt
 
 ifneq ($(KBUILD_NOCMDDEP),1)
-# Check if both arguments has same arguments. Result in empty string if equal
+# Check if both arguments has same arguments. Result is empty string, if equal.
 # User may override this check using make KBUILD_NOCMDDEP=1
 arg-check = $(strip $(filter-out $(cmd_$(1)), $(cmd_$@)) \
@@ -140,8 +153,4 @@ arg-check = $(strip $(filter-out $(cmd_$
 endif
 
-# echo command. Short version is $(quiet) equals quiet, otherwise full command
-echo-cmd = $(if $($(quiet)cmd_$(1)), \
-	echo '  $(call escsq,$($(quiet)cmd_$(1)))$(echo-why)';)
-
 # >'< substitution is for echo to work,
 # >$< substitution to preserve $ when reloading .cmd file
@@ -154,5 +163,5 @@ make-cmd = $(subst \#,\\\#,$(subst $$,$$
 any-prereq = $(filter-out $(PHONY),$?) $(filter-out $(PHONY) $(wildcard $^),$^)
 
-# Execute command if command has changed or prerequisitei(s) are updated
+# Execute command if command has changed or prerequisite(s) are updated.
 #
 if_changed = $(if $(strip $(any-prereq) $(arg-check)),                       \
@@ -161,6 +170,6 @@ if_changed = $(if $(strip $(any-prereq) 
 	echo 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)
 
-# execute the command and also postprocess generated .d dependencies
-# file
+# Execute the command and also postprocess generated .d dependencies file.
+#
 if_changed_dep = $(if $(strip $(any-prereq) $(arg-check) ),                  \
 	@set -e;                                                             \
@@ -170,7 +179,8 @@ if_changed_dep = $(if $(strip $(any-prer
 	mv -f $(dot-target).tmp $(dot-target).cmd)
 
+# Will check if $(cmd_foo) changed, or any of the prerequisites changed,
+# and if so will execute $(rule_foo).
 # Usage: $(call if_changed_rule,foo)
-# will check if $(cmd_foo) changed, or any of the prequisites changed,
-# and if so will execute $(rule_foo)
+#
 if_changed_rule = $(if $(strip $(any-prereq) $(arg-check) ),                 \
 	@set -e;                                                             \



