Return-Path: <linux-kernel-owner+w=401wt.eu-S1030228AbXAXIrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030228AbXAXIrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 03:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030239AbXAXIrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 03:47:18 -0500
Received: from raven.upol.cz ([158.194.120.4]:60624 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030228AbXAXIrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 03:47:16 -0500
Date: Wed, 24 Jan 2007 08:54:30 +0000
To: Horst Schirmeier <horst@schirmeier.com>, Andi Kleen <ak@suse.de>,
       Valdis.Kletnieks@vt.edu, Jan Beulich <jbeulich@novell.com>,
       dsd@gentoo.org, kernel@gentoo.org, draconx@gmail.com,
       jpdenheijer@gmail.com, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [patch] kbuild: improving option checking (Re: [PATCH -mm] replacement for broken kbuild-dont-put-temp-files-in-the-source-tree.patch)
Message-ID: <20070124085430.GA8160@flower.upol.cz>
References: <20061029120858.GB3491@quickstop.soohrt.org> <slrnekcu6m.2vm.olecom@flower.upol.cz> <20061031001235.GE2933@quickstop.soohrt.org> <200610310119.10567.ak@suse.de> <20061031011416.GG2933@quickstop.soohrt.org> <20061031135136.GB16063@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061031135136.GB16063@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo. Tmpfiles, root users, external mod-builds again.

On Tue, Oct 31, 2006 at 02:51:36PM +0100, olecom wrote:
> On Tue, Oct 31, 2006 at 02:14:16AM +0100, Horst Schirmeier wrote:
> > On Tue, 31 Oct 2006, Andi Kleen wrote:
> > > 
> > > > The problem is, this brings us back to the problem where this whole
> > > > patch orgy began: Gentoo Portage sandbox violations when writing (the
> > > > null symlink) to the kernel tree when building external modules. What
> > > > about using $(M) as a base directory if it is defined?
> > > 
> > > I think Jan's $(objdir)/.tmp proposal would be cleanest. Just someone
> > > has to implement it :)
> > > 
> > > -Andi
> 
> $(objtree) here,
> 
> > I'm not sure what you mean by $(objdir); I just got something to work
> > which creates the /dev/null symlink in a (newly created if necessary)
> > directory named
> 
> $(objtree) is a directory for all possible outputs of the build precess,
> it's set up by `O=' or `KBUILD_OUTPUT', and this is *not* output for ready
> external modules `$(M)'. Try to play with this, please.

Kind of fix has finally landed. Instead for `O=/$dir' a patch...

Anyway i whould like propose my solution of:
-- external modules build without KBUILD_OUTPUT set;
-- /dev/null, GNU binutils and root users;
-- beauty;

For external modules, there must be information after
`make modules_prepare' in shipped linux-sources. Any build output is
put in $(objtree), and i don't understand why you don't using that.
Please, *try* `make O=/tmp/build M=/usr/local/src/nvatia'. Thank you.

As some kind of buga-feature, "null" isn't in any clean/mrproper
target (for a while ;).

-*- patch -*-
kbuild: improving option checking

 GNU binutils, root users, tmpfiles, external modules ro builds must
 be fixed to do the right thing now.

 In "safe" environment new /dev/null replacement may be used as simply as
 `echo > null', `gcc -o null'. In aggressive starting with $(null) is
 recommended.

 Feature: file $(objtree)/null isn't in any "clear" target (yet).

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
---
-o--=O`C
 #oo'L O
<___=E M

--- linux~2.6.20-rc5/scripts/Kbuild.include~blackhole-4-tmpfiles	2007-01-12 19:54:26.000000000 +0100
+++ linux~2.6.20-rc5/scripts/Kbuild.include	2007-01-24 09:19:01.386426000 +0100
@@ -2,5 +2,5 @@
 # kbuild: Generic definitions
 
-# Convinient variables
+# Convinient constants
 comma   := ,
 squote  := '
@@ -8,4 +8,7 @@
 space   := $(empty) $(empty)
 
+# Immortal black-hole for mortals and roots
+null = $(shell test -L null || (rm -f null; ln -s /dev/null null); echo null)
+
 ###
 # Name of target with a '.' as filename prefix. foo/bar.o => foo/.bar.o
@@ -57,33 +60,43 @@
 # See documentation in Documentation/kbuild/makefiles.txt
 
-# output directory for tests below
-TMPOUT := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)
-
 # as-option
 # Usage: cflags-y += $(call as-option, -Wa$(comma)-isa=foo,)
-
-as-option = $(shell if $(CC) $(CFLAGS) $(1) -Wa,-Z -c -o /dev/null \
-	     -xassembler /dev/null > /dev/null 2>&1; then echo "$(1)"; \
-	     else echo "$(2)"; fi ;)
+define as-option
+  $(shell
+    if $(CC) $(CFLAGS) $(1) -c -o $(null) -xassembler null >null 2>&1; \
+      then echo $(1); \
+      else echo $(2); \
+    fi)
+endef
 
 # as-instr
 # Usage: cflags-y += $(call as-instr, instr, option1, option2)
-
-as-instr = $(shell if echo -e "$(1)" | \
-		      $(CC) $(AFLAGS) -c -xassembler - \
-			    -o $(TMPOUT)astest$$$$.out > /dev/null 2>&1; \
-		   then rm $(TMPOUT)astest$$$$.out; echo "$(2)"; \
-		   else echo "$(3)"; fi)
+define as-instr
+  $(shell \
+    if printf "$(1)" | $(AS) >$(null) 2>&1 -W -o null; \
+      then echo "$(2)"; \
+      else echo "$(3)"; \
+    fi)
+endef
 
 # cc-option
 # Usage: cflags-y += $(call cc-option, -march=winchip-c6, -march=i586)
-
-cc-option = $(shell if $(CC) $(CFLAGS) $(1) -S -o /dev/null -xc /dev/null \
-             > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
+define cc-option
+  $(shell \
+    if $(CC) $(CFLAGS) $(1) -S -o $(null) -xc null >null 2>&1; \
+      then echo "$(1)"; \
+      else echo "$(2)"; \
+    fi)
+endef
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn, -march=winchip-c6)
-cc-option-yn = $(shell if $(CC) $(CFLAGS) $(1) -S -o /dev/null -xc /dev/null \
-                > /dev/null 2>&1; then echo "y"; else echo "n"; fi;)
+define cc-option-yn
+  $(shell \
+    if $(CC) $(CFLAGS) $(1) -S -o $(null) -xc null >null 2>&1; \
+      then echo "y"; \
+      else echo "n"; \
+    fi)
+endef
 
 # cc-option-align
@@ -103,8 +116,11 @@
 # ld-option
 # Usage: ldflags += $(call ld-option, -Wl$(comma)--hash-style=both)
-ld-option = $(shell if $(CC) $(1) -nostdlib -xc /dev/null \
-			     -o $(TMPOUT)ldtest$$$$.out > /dev/null 2>&1; \
-             then rm $(TMPOUT)ldtest$$$$.out; echo "$(1)"; \
-             else echo "$(2)"; fi)
+define ld-option
+  $(shell \
+    if $(CC) $(1) -nostdlib -o $(null) -xc null >null 2>&1; \
+      then echo "$(1)"; \
+      else echo "$(2)"; \
+    fi)
+endef
 
 ###
@@ -116,4 +132,5 @@
 # Prefix -I with $(srctree) if it is not an absolute path
 addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
+
 # Find all -I options and call addtree
 flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
@@ -126,5 +143,5 @@
 
 ###
-# if_changed      - execute command if any prerequisite is newer than 
+# if_changed      - execute command if any prerequisite is newer than
 #                   target, or command line has changed
 # if_changed_dep  - as if_changed, but uses fixdep to reveal dependencies
