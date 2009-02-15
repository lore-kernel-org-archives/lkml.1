Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbZBOSWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbZBOSWf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZBOSUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:20:47 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:3898 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbZBOSUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:20:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MeqBzA3O7im7S7NokjHjRkMLjRemqLhoEDdEr7WJbbPOUvt1K1pPPQsRwb4M5QJ0WX
         ilU4++udULUzqvy9wTIpMn3kE6JCCrZKP8RYWXMAkKbeTaAn/gxrwZD5wx62tr+EkXSU
         Pn/hEw4PnKpa5h9TxmS91VqwuUpseU3/vjThU=
From: Andreas Robinson <andr345@gmail.com>
To: sam@ravnborg.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 6/6] kbuild: enable relinking of vmlinux without full kernel tree
Date: Sun, 15 Feb 2009 19:20:28 +0100
Message-Id: <1234722028-8110-7-git-send-email-andr345@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1234722028-8110-1-git-send-email-andr345@gmail.com>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A make parameter "L=1" enables relinking vmlinux from existing
objects. Make will only look at toplevel built-in.o and lib.a.
The source and lower-level objects are ignored.
---
 Makefile |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 921d6b4..74a5e5f 100644
--- a/Makefile
+++ b/Makefile
@@ -75,6 +75,17 @@ ifdef M
   endif
 endif
 
+# Use 'make L=1' to skip compilation and relink the existing
+# objects. All objects must exist.
+
+ifdef L
+  ifeq ("$(origin L)", "command line")
+    KBUILD_RELINK := $(L)
+  endif
+endif
+ifndef KBUILD_RELINK
+  KBUILD_RELINK := 0
+endif
 
 # kbuild supports saving output files in a separate directory.
 # To locate output files in a separate directory two syntaxes are supported.
@@ -257,7 +268,7 @@ ifeq ($(MAKECMDGOALS),)
 endif
 
 export KBUILD_MODULES KBUILD_BUILTIN
-export KBUILD_CHECKSRC KBUILD_SRC KBUILD_EXTMOD
+export KBUILD_CHECKSRC KBUILD_SRC KBUILD_EXTMOD KBUILD_RELINK
 
 # Beautify output
 # ---------------------------------------------------------------------------
@@ -459,12 +470,14 @@ else
 # targets and others. In general all targets except *config targets.
 
 ifeq ($(KBUILD_EXTMOD),)
+ifeq ($(KBUILD_RELINK),0)
 # Additional helpers built in scripts/
 # Carefully list dependencies so we do not try to build scripts twice
 # in parallel
 PHONY += scripts
 scripts: scripts_basic include/config/auto.conf
 	$(Q)$(MAKE) $(build)=$(@)
+endif # KBUILD_RELINK
 
 # Objects we will link into vmlinux / subdirs we need to visit
 init-y		:= init/
@@ -692,6 +705,7 @@ quiet_cmd_vmlinux__ ?= LD      $@
       --start-group $(vmlinux-main) $(EXTOBJ) --end-group        \
       $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
 
+ifeq ($(KBUILD_RELINK),0)
 # Generate new vmlinux version
 quiet_cmd_vmlinux_version = GEN     .version
       cmd_vmlinux_version = set -e;                     \
@@ -703,6 +717,7 @@ quiet_cmd_vmlinux_version = GEN     .version
 	  expr 0$$(cat .old_version) + 1 >.version;	\
 	fi;						\
 	$(MAKE) $(build)=init
+endif
 
 # Generate System.map
 quiet_cmd_sysmap = SYSMAP
@@ -851,6 +866,13 @@ modpost-init := $(filter-out init/built-in.o, $(vmlinux-init))
 vmlinux.o: $(modpost-init) $(vmlinux-main) FORCE
 	$(call if_changed_rule,vmlinux-modpost)
 
+relinked-objs := $(vmlinux-init) $(vmlinux-main) $(vmlinux-lds)
+
+ifeq ($(KBUILD_RELINK),1)
+$(relinked-objs): FORCE
+	$(call if_changed,touch)
+else # The endif is way down. Search for next KBUILD_RELINK.
+
 # The actual objects are generated when descending, 
 # make sure no implicit rule kicks in
 $(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds): $(vmlinux-dirs) ;
@@ -1234,6 +1256,7 @@ distclean: mrproper
 		-o -name '*%' -o -name '.*.cmd' -o -name 'core' \) \
 		-type f -print | xargs rm -f
 
+endif # KBUILD_RELINK
 
 # Packaging of the kernel to various formats
 # ---------------------------------------------------------------------------
@@ -1316,6 +1339,7 @@ help:
 	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
+	@echo  '  make L=1   [targets] Skip compilation and relink existing objects.'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
@@ -1556,6 +1580,9 @@ a_flags = -Wp,-MD,$(depfile) $(KBUILD_AFLAGS) $(AFLAGS_KERNEL) \
 quiet_cmd_as_o_S = AS      $@
 cmd_as_o_S       = $(CC) $(a_flags) -c -o $@ $<
 
+quiet_cmd_touch = TOUCH   $@
+cmd_touch = if [ -f $@ ]; then touch $@; else echo $@ missing.; exit 1; fi
+
 # read all saved command lines
 
 targets := $(wildcard $(sort $(targets)))
-- 
1.5.6.3

