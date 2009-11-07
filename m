Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZKGVFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZKGVFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZKGVFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:05:53 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:39914 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZKGVEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:04:14 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 03/10] module: make MODULE_SYMBOL_PREFIX into a CONFIG option
Date: Sat,  7 Nov 2009 21:03:54 +0000
Message-Id: <1257627841-15817-3-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <4AF5DF9F.5020208@tuffmail.co.uk>
References: <4AF5DF9F.5020208@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next commit will require the use of MODULE_SYMBOL_PREFIX in
.tmp_exports-asm.S.  Currently it is mixed in with C structure
definitions in "asm/module.h".  Move the definition of this arch option
into Kconfig, so it can be easily accessed by any code.

This also lets modpost.c use the same definition.  Previously modpost
relied on a hardcoded list of architectures in mk_elfconfig.c.

A build test for blackfin, one of the two MODULE_SYMBOL_PREFIX archs,
showed the generated code was unchanged.  vmlinux was identical save
for build ids, and an apparently randomized suffix on a single "__key"
symbol in the kallsyms data).

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Acked-by: Mike Frysinger <vapier@gentoo.org> (blackfin)
CC: Sam Ravnborg <sam@ravnborg.org>
---
 arch/blackfin/Kconfig              |    4 ++++
 arch/blackfin/include/asm/module.h |    2 --
 arch/blackfin/kernel/vmlinux.lds.S |    2 --
 arch/h8300/Kconfig                 |    4 ++++
 arch/h8300/include/asm/module.h    |    2 --
 arch/h8300/kernel/vmlinux.lds.S    |    1 -
 include/asm-generic/vmlinux.lds.h  |    8 ++++++--
 include/linux/module.h             |    6 ++++--
 scripts/Makefile.lib               |    5 +++++
 scripts/mod/Makefile               |    2 +-
 scripts/mod/mk_elfconfig.c         |    9 ---------
 scripts/mod/modpost.c              |    9 +++++++++
 12 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 9a01d44..1983662 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -5,6 +5,10 @@
 
 mainmenu "Blackfin Kernel Configuration"
 
+config SYMBOL_PREFIX
+	string
+	default "_"
+
 config MMU
 	def_bool n
 
diff --git a/arch/blackfin/include/asm/module.h b/arch/blackfin/include/asm/module.h
index e3128df..81d8b90 100644
--- a/arch/blackfin/include/asm/module.h
+++ b/arch/blackfin/include/asm/module.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_BFIN_MODULE_H
 #define _ASM_BFIN_MODULE_H
 
-#define MODULE_SYMBOL_PREFIX "_"
-
 #define Elf_Shdr        Elf32_Shdr
 #define Elf_Sym         Elf32_Sym
 #define Elf_Ehdr        Elf32_Ehdr
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index ffd90fb..1f585e8 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -27,8 +27,6 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#define VMLINUX_SYMBOL(_sym_) _##_sym_
-
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/mem_map.h>
 #include <asm/page.h>
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 9420648..53cc669 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -10,6 +10,10 @@ config H8300
 	default y
 	select HAVE_IDE
 
+config SYMBOL_PREFIX
+	string
+	default "_"
+
 config MMU
 	bool
 	default n
diff --git a/arch/h8300/include/asm/module.h b/arch/h8300/include/asm/module.h
index de23231..8e46724 100644
--- a/arch/h8300/include/asm/module.h
+++ b/arch/h8300/include/asm/module.h
@@ -8,6 +8,4 @@ struct mod_arch_specific { };
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
 
-#define MODULE_SYMBOL_PREFIX "_"
-
 #endif /* _ASM_H8/300_MODULE_H */
diff --git a/arch/h8300/kernel/vmlinux.lds.S b/arch/h8300/kernel/vmlinux.lds.S
index b9e2490..03d356d 100644
--- a/arch/h8300/kernel/vmlinux.lds.S
+++ b/arch/h8300/kernel/vmlinux.lds.S
@@ -1,4 +1,3 @@
-#define VMLINUX_SYMBOL(_sym_) _##_sym_
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/page.h>
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b6e818f..67e6520 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -52,8 +52,12 @@
 #define LOAD_OFFSET 0
 #endif
 
-#ifndef VMLINUX_SYMBOL
-#define VMLINUX_SYMBOL(_sym_) _sym_
+#ifndef SYMBOL_PREFIX
+#define VMLINUX_SYMBOL(sym) sym
+#else
+#define PASTE2(x,y) x##y
+#define PASTE(x,y) PASTE2(x,y)
+#define VMLINUX_SYMBOL(sym) PASTE(SYMBOL_PREFIX, sym)
 #endif
 
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
diff --git a/include/linux/module.h b/include/linux/module.h
index 482efc8..6cb1a3c 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -25,8 +25,10 @@
 /* Not Yet Implemented */
 #define MODULE_SUPPORTED_DEVICE(name)
 
-/* some toolchains uses a `_' prefix for all user symbols */
-#ifndef MODULE_SYMBOL_PREFIX
+/* Some toolchains use a `_' prefix for all user symbols. */
+#ifdef CONFIG_SYMBOL_PREFIX
+#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
+#else
 #define MODULE_SYMBOL_PREFIX ""
 #endif
 
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 7a77787..f9f1f6c 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -127,6 +127,11 @@ _c_flags += $(if $(patsubst n%,, \
 		$(CFLAGS_GCOV))
 endif
 
+ifdef CONFIG_SYMBOL_PREFIX
+_cpp_flags += -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
+endif
+
+
 # If building the kernel in a separate objtree expand all occurrences
 # of -Idir to -I$(srctree)/dir except for absolute paths (starting with '/').
 
diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index 11d69c3..ff954f8 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -8,7 +8,7 @@ modpost-objs	:= modpost.o file2alias.o sumversion.o
 $(obj)/modpost.o $(obj)/file2alias.o $(obj)/sumversion.o: $(obj)/elfconfig.h
 
 quiet_cmd_elfconfig = MKELF   $@
-      cmd_elfconfig = $(obj)/mk_elfconfig $(ARCH) < $< > $@
+      cmd_elfconfig = $(obj)/mk_elfconfig < $< > $@
 
 $(obj)/elfconfig.h: $(obj)/empty.o $(obj)/mk_elfconfig FORCE
 	$(call if_changed,elfconfig)
diff --git a/scripts/mod/mk_elfconfig.c b/scripts/mod/mk_elfconfig.c
index 6a96d47..639bca7 100644
--- a/scripts/mod/mk_elfconfig.c
+++ b/scripts/mod/mk_elfconfig.c
@@ -9,9 +9,6 @@ main(int argc, char **argv)
 	unsigned char ei[EI_NIDENT];
 	union { short s; char c[2]; } endian_test;
 
-	if (argc != 2) {
-		fprintf(stderr, "Error: no arch\n");
-	}
 	if (fread(ei, 1, EI_NIDENT, stdin) != EI_NIDENT) {
 		fprintf(stderr, "Error: input truncated\n");
 		return 1;
@@ -55,12 +52,6 @@ main(int argc, char **argv)
 	else
 		exit(1);
 
-	if ((strcmp(argv[1], "h8300") == 0)
-	    || (strcmp(argv[1], "blackfin") == 0))
-		printf("#define MODULE_SYMBOL_PREFIX \"_\"\n");
-	else
-		printf("#define MODULE_SYMBOL_PREFIX \"\"\n");
-
 	return 0;
 }
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 801a16a..fb0f9b7 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -15,8 +15,17 @@
 #include <stdio.h>
 #include <ctype.h>
 #include "modpost.h"
+#include "../../include/linux/autoconf.h"
 #include "../../include/linux/license.h"
 
+/* Some toolchains use a `_' prefix for all user symbols. */
+#ifdef CONFIG_SYMBOL_PREFIX
+#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
+#else
+#define MODULE_SYMBOL_PREFIX ""
+#endif
+
+
 /* Are we using CONFIG_MODVERSIONS? */
 int modversions = 0;
 /* Warn about undefined symbols? (do so if we have vmlinux) */
-- 
1.6.3.3

