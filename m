Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbYBOUzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbYBOUzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYBOUzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:55:13 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:36697 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbYBOUzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:55:10 -0500
Date: Fri, 15 Feb 2008 21:55:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] 4 kbuild fixes for -rc1
Message-ID: <20080215205519.GB4363@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.
Here follows the accomulated kbuild/kconfig related fixes.

I have had them in my tree for a shorter period
and things did not breake for me.

Please pull from:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git

	Sam



Roman Zippel (1):
      kconfig: fix select in combination with default

Sam Ravnborg (3):
      kbuild: allow -fstack-protector to take effect
      kbuild: fix building vmlinux.o
      kbuild: explain why DEBUG_SECTION_MISMATCH is UNDEFINED

 Makefile                 |   11 +++++++----
 lib/Kconfig.debug        |    3 +++
 scripts/kconfig/symbol.c |   34 +++++++++++++++++++++-------------
 3 files changed, 31 insertions(+), 17 deletions(-)


Cumulative diff of all changes.


diff --git a/Makefile b/Makefile
index c162370..0d585c0 100644
--- a/Makefile
+++ b/Makefile
@@ -507,6 +507,10 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+# Force gcc to behave correct even for buggy distributions
+# Arch Makefiles may override this setting
+KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
+
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifdef CONFIG_FRAME_POINTER
@@ -525,9 +529,6 @@ ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
 endif
 
-# Force gcc to behave correct even for buggy distributions
-KBUILD_CFLAGS         += $(call cc-option, -fno-stack-protector)
-
 # arch Makefile may override CC so keep this after arch Makefile is included
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 CHECKFLAGS     += $(NOSTDINC_FLAGS)
@@ -810,7 +811,9 @@ endif
 	$(Q)rm -f .old_version
 
 # build vmlinux.o first to catch section mismatch errors early
-$(kallsyms.o): vmlinux.o
+ifdef CONFIG_KALLSYMS
+.tmp_vmlinux1: vmlinux.o
+endif
 vmlinux.o: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) FORCE
 	$(call if_changed_rule,vmlinux-modpost)
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a370fe8..ab408aa 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -82,6 +82,9 @@ config HEADERS_CHECK
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
 	depends on UNDEFINED
+	# This option is on purpose disabled for now.
+	# It will be enabled when we are down to a resonable number
+	# of section mismatch warnings (< 10 for an allyesconfig build)
 	help
 	  The section mismatch analysis checks if there are illegal
 	  references from one section to another section.
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 3929e5b..4a03191 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -298,22 +298,30 @@ void sym_calc_value(struct symbol *sym)
 		if (sym_is_choice_value(sym) && sym->visible == yes) {
 			prop = sym_get_choice_prop(sym);
 			newval.tri = (prop_get_symbol(prop)->curr.val == sym) ? yes : no;
-		} else if (EXPR_OR(sym->visible, sym->rev_dep.tri) != no) {
-			sym->flags |= SYMBOL_WRITE;
-			if (sym_has_value(sym))
-				newval.tri = sym->def[S_DEF_USER].tri;
-			else if (!sym_is_choice(sym)) {
-				prop = sym_get_default_prop(sym);
-				if (prop)
-					newval.tri = expr_calc_value(prop->expr);
+		} else {
+			if (sym->visible != no) {
+				/* if the symbol is visible use the user value
+				 * if available, otherwise try the default value
+				 */
+				sym->flags |= SYMBOL_WRITE;
+				if (sym_has_value(sym)) {
+					newval.tri = EXPR_AND(sym->def[S_DEF_USER].tri,
+							      sym->visible);
+					goto calc_newval;
+				}
 			}
-			newval.tri = EXPR_OR(EXPR_AND(newval.tri, sym->visible), sym->rev_dep.tri);
-		} else if (!sym_is_choice(sym)) {
-			prop = sym_get_default_prop(sym);
-			if (prop) {
+			if (sym->rev_dep.tri != no)
 				sym->flags |= SYMBOL_WRITE;
-				newval.tri = expr_calc_value(prop->expr);
+			if (!sym_is_choice(sym)) {
+				prop = sym_get_default_prop(sym);
+				if (prop) {
+					sym->flags |= SYMBOL_WRITE;
+					newval.tri = EXPR_AND(expr_calc_value(prop->expr),
+							      prop->visible.tri);
+				}
 			}
+		calc_newval:
+			newval.tri = EXPR_OR(newval.tri, sym->rev_dep.tri);
 		}
 		if (newval.tri == mod && sym_get_type(sym) == S_BOOLEAN)
 			newval.tri = yes;
