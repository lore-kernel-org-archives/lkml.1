Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbXFLXkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbXFLXkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbXFLXju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:39:50 -0400
Received: from raven.upol.cz ([158.194.120.4]:41898 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbXFLXjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:39:48 -0400
Message-Id: <20070612234558.648949000@flower.upol.cz>
References: <20070612233650.486224000@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: quilt + emacs + jed (x86_64-pc-linux-glibc-debian)
X-Mailer: formail(procmail)
Date: Wed, 13 Jun 2007 01:36:51 +0200
From: Oleg Verych <olecom@flower.upol.cz>
To: Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, kbuild-devel@lists.sourceforge.net
Subject: [patch 01/03] kbuild, asm-values: infrastructure
Content-Disposition: inline; filename=kbuild-asm-values-infrastructure.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	* header with widely used value definitions
	* handle all asm-related things in one file (Makefile.asm)
	* move some asm bits from Makefile.build there
	  (rule %.s:%.c)
	* add script to generate headers from assembles output
	  (hopefully better output, MIPS testing/joining to all arch
	   probably needed)

rfc-by: Oleg Verych
---
 See next patches, to know how to use it

 include/asm-generic/asm-values.h |    7 ++++
 scripts/Makefile.asm             |   26 ++++++++++++++++++
 scripts/Makefile.build           |    6 ----
 scripts/mkasm-values.sh          |   55 +++++++++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+), 6 deletions(-)

Index: linux-2.6.22-rc4-mm2/scripts/Makefile.asm
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc4-mm2/scripts/Makefile.asm	2007-06-12 23:43:41.070624500 +0200
@@ -0,0 +1,26 @@
+#
+# Help generate definitions needed by assembly language modules.
+#
+ifndef asm-values_h
+    asm-values := $(shell test -e $(srctree)/$(src)/asm-values.c && echo ok)
+    ifneq ($(asm-values),)
+	asm-values_h := asm-values.h
+	asm-values   := asm-values.s
+    endif
+endif
+
+always		+= $(asm-values_h)
+targets		+= $(asm-values_h) $(asm-values)
+mkasm-values	:= $(srctree)/scripts/mkasm-values.sh
+
+quiet_cmd_mkasm-values = GEN     $@
+      cmd_mkasm-values = $(CONFIG_SHELL) $(mkasm-values) $< $@ $(2)
+
+quiet_cmd_cc_s_c = CC $(quiet_modtag)  $@
+      cmd_cc_s_c = $(CC) $(c_flags) -fverbose-asm -S -o $@ $<
+
+$(obj)/asm-values.h: $(obj)/asm-values.s
+	$(call cmd,mkasm-values,$(ASM_NS))
+
+$(obj)/%.s: $(src)/%.c FORCE
+	$(call if_changed_dep,cc_s_c)
Index: linux-2.6.22-rc4-mm2/scripts/Makefile.build
===================================================================
--- linux-2.6.22-rc4-mm2.orig/scripts/Makefile.build	2007-06-13 00:45:54.195930250 +0200
+++ linux-2.6.22-rc4-mm2/scripts/Makefile.build	2007-06-12 22:10:31.481297000 +0200
@@ -145,10 +145,4 @@ $(multi-objs-y:.o=.s)   : modname = $(mo
 $(multi-objs-y:.o=.lst) : modname = $(modname-multi)
 
-quiet_cmd_cc_s_c = CC $(quiet_modtag)  $@
-cmd_cc_s_c       = $(CC) $(c_flags) -fverbose-asm -S -o $@ $<
-
-$(obj)/%.s: $(src)/%.c FORCE
-	$(call if_changed_dep,cc_s_c)
-
 quiet_cmd_cc_i_c = CPP $(quiet_modtag) $@
 cmd_cc_i_c       = $(CPP) $(c_flags)   -o $@ $<
Index: linux-2.6.22-rc4-mm2/scripts/mkasm-values.sh
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc4-mm2/scripts/mkasm-values.sh	2007-06-12 21:49:05.096903000 +0200
@@ -0,0 +1,55 @@
+#!/bin/sh
+
+# Input file "*.s", made by Kbuild from a "*.c" source, where values of
+# interest are calculated, is processed in a suitable output header file.
+#
+# $1 - input filename;
+# $2 - output filename;
+# $3 - generate (private) file with given namespace (optional)
+
+set -e
+
+[ -z "$1" ] || [ -z "$2" ] && {
+	echo "$0:
+
+Two parameters needed. Exiting.
+"
+	exit 1
+}
+
+NS=`echo $3 | tr a-z A-Z`
+case $NS in
+	MIPS)
+SED_SCRIPT='
+/^@@@/{
+s|^@@@||;
+s| #.*$||;
+p;
+}'	;;
+	*)
+TAB="`printf '\t'`"
+SED_SCRIPT="
+/^->/{
+s|^->||;
+s|^\([^ ]*\) [\$#]*\([^ ]*\) \([^$TAB]*\).*|#define \1 \2$TAB/* \3 */|;
+p;
+}"	;;
+esac
+
+NS=__ASM_VALUES_${NS:=H}__
+
+exec 1>$2
+echo "\
+#if !defined($NS)
+#define $NS
+
+/*
+ * $2
+ * was generated from
+ * $1
+ */
+"
+sed -ne "$SED_SCRIPT" $1
+
+echo "
+#endif"
Index: linux-2.6.22-rc4-mm2/include/asm-generic/asm-values.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc4-mm2/include/asm-generic/asm-values.h	2007-06-12 23:33:34.176696000 +0200
@@ -0,0 +1,7 @@
+#define DEFINE(sym, val) \
+	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+
+#define BLANK() asm volatile("\n->" : : )
+
+#define OFFSET(sym, str, mem) \
+	DEFINE(sym, offsetof(struct str, mem));

--

