Return-Path: <linux-kernel-owner+w=401wt.eu-S1161440AbXBGVz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161440AbXBGVz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161450AbXBGVz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:55:57 -0500
Received: from raven.upol.cz ([158.194.120.4]:60149 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161440AbXBGVz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:55:56 -0500
Date: Wed, 7 Feb 2007 23:04:35 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: [patch, fix build regression] kbuild: Kbuild.include avoid using spaces in call arguments
Message-ID: <20070207220435.GC22699@flower.upol.cz>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0702071846180.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702071846180.14457@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 06:47:15PM +0100, Roman Zippel wrote:
> Hi,
> 
> On Wed, 7 Feb 2007, Alexey Dobriyan wrote:
> 
> > The change below is shitting i386 defconfig (as well as my usual config)
> > build log with warnings:
> > 
> >   CC      init/main.o
> > `-mcpu=' is deprecated. Use `-mtune=' or '-march=' instead.
> > `-mcpu=' is deprecated. Use `-mtune=' or '-march=' instead.
> > 
> > gcc is 4.1.1.
> > 
> > ------------------
> > $ git-cat-file commit 5de043f4bd11a9e0a3e8daec7d1905da575a76b7
> > tree 1cdafacd6a0f6e12bd5b88d9031a6130169ca868
> > parent f6112ec27a8f0eee6c5a996f65c7bfd9457d9f85
> > author Oleg Verych <olecom@flower.upol.cz> 1170724701 +0100
> > committer Linus Torvalds <torvalds@woody.linux-foundation.org>
> > 1170801049 -0800
> > 
> > [PATCH] kbuild: improve option checking, Kbuild.include cleanup
> > 
> >  GNU binutils, root users, tmpfiles, external modules ro builds must
> >  be fixed to do the right thing now.
> 
> Linus, please revert. Thanks.
 
Roman, while it went so fast to Linus, i didn't expect that, let me
try to fix all this with this little patch.

---
Subject: [patch] kbuild, Kbuild.include: avoid using spaces in call arguments

  Do not use whitespace in arguments of functions in makefiles, as
  they propagate further without notice. Thus we get

  + echo ' y'

  instead of

  + echo y

  Fix misleading comments.

Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
---

 Whitespaces in makefiles are PITA. But i've learnt this already.

 scripts/Kbuild.include |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

Index: linux-2.6.20/scripts/Kbuild.include
===================================================================
--- linux-2.6.20.orig/scripts/Kbuild.include	2007-02-07 22:54:01.814467250 +0100
+++ linux-2.6.20/scripts/Kbuild.include	2007-02-07 22:54:17.099422500 +0100
@@ -58,5 +58,5 @@ endef
 
 # checker-shell
-# Usage: option = $(call checker-shell, $(CC)...-o $$OUT, option-ok, otherwise)
+# Usage: option = $(call checker-shell,$(CC)...-o $$OUT,option-ok,otherwise)
 # Exit code chooses option. $$OUT is safe location for needless output.
 define checker-shell
@@ -75,21 +75,21 @@ endef
 
 # as-option
-# Usage: cflags-y += $(call as-option, -Wa$(comma)-isa=foo,)
-as-option = $(call checker-shell, \
-   $(CC) $(CFLAGS) $(1) -c -xassembler /dev/null -o $$OUT, $(1), $(2))
+# Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
+as-option = $(call checker-shell,\
+   $(CC) $(CFLAGS) $(1) -c -xassembler /dev/null -o $$OUT,$(1),$(2))
 
 # as-instr
-# Usage: cflags-y += $(call as-instr, instr, option1, option2)
-as-instr = $(call checker-shell, \
-   printf "$(1)" | $(CC) $(AFLAGS) -c -xassembler -o $$OUT -, $(2), $(3))
+# Usage: cflags-y += $(call as-instr,instr,option1,option2)
+as-instr = $(call checker-shell,\
+   printf "$(1)" | $(CC) $(AFLAGS) -c -xassembler -o $$OUT -,$(2),$(3))
 
 # cc-option
-# Usage: cflags-y += $(call cc-option, -march=winchip-c6, -march=i586)
-cc-option = $(call checker-shell, \
-   $(CC) $(CFLAGS) $(if $(3),$(3),$(1)) -S -xc /dev/null -o $$OUT, $(1), $(2))
+# Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
+cc-option = $(call checker-shell,\
+   $(CC) $(CFLAGS) $(if $(3),$(3),$(1)) -S -xc /dev/null -o $$OUT,$(1),$(2))
 
 # cc-option-yn
-# Usage: flag := $(call cc-option-yn, -march=winchip-c6)
-cc-option-yn = $(call cc-option, "y", "n", $(1))
+# Usage: flag := $(call cc-option-yn,-march=winchip-c6)
+cc-option-yn = $(call cc-option,"y","n",$(1))
 
 # cc-option-align
@@ -99,5 +99,5 @@ cc-option-align = $(subst -functions=0,,
 
 # cc-version
-# Usage gcc-ver := $(call cc-version, $(CC))
+# Usage gcc-ver := $(call cc-version,$(CC))
 cc-version = $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-version.sh $(CC))
 
@@ -108,6 +108,6 @@ cc-ifversion = $(shell [ $(call cc-versi
 # ld-option
 # Usage: ldflags += $(call ld-option, -Wl$(comma)--hash-style=both)
-ld-option = $(call checker-shell, \
-   $(CC) $(1) -nostdlib -xc /dev/null -o $$OUT, $(1), $(2))
+ld-option = $(call checker-shell,\
+   $(CC) $(1) -nostdlib -xc /dev/null -o $$OUT,$(1),$(2))
 
 ######
@@ -121,13 +121,13 @@ build := -f $(if $(KBUILD_SRC),$(srctree
 # add original to the end
 addtree = $(if \
-	$(filter-out -I/%, $(1)), $(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
+	$(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
 
 # Find all -I options and call addtree
-flags = $(foreach o,$($(1)), \
-	$(if $(filter -I%,$(o)), $(call addtree, $(o)), $(o)))
+flags = $(foreach o,$($(1)),\
+	$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
 
 # echo command.
 # Short version is used, if $(quiet) equals `quiet_', otherwise full one.
-echo-cmd = $(if $($(quiet)cmd_$(1)), \
+echo-cmd = $(if $($(quiet)cmd_$(1)),\
 	echo '  $(call escsq,$($(quiet)cmd_$(1)))$(echo-why)';)
 
@@ -136,5 +136,5 @@ cmd = @$(echo-cmd) $(cmd_$(1))
 
 # Add $(obj)/ for paths that are not absolute
-objectify = $(foreach o,$(1), $(if $(filter /%,$(o)), $(o), $(obj)/$(o)))
+objectify = $(foreach o,$(1),$(if $(filter /%,$(o)),$(o),$(obj)/$(o)))
 
 ###

