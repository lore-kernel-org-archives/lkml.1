Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbZKCKIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbZKCKIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbZKCKII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:08:08 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:46931 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbZKCKHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:07:37 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: greg@kroah.com
Cc: linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 04/10] module: make MODULE_SYMBOL_PREFIX into a CONFIG option
Date: Tue,  3 Nov 2009 10:06:16 +0000
Message-Id: <1257242782-10496-5-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
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
---
 arch/blackfin/Kconfig              |    1 +
 arch/blackfin/include/asm/module.h |    2 --
 arch/h8300/Kconfig                 |    1 +
 arch/h8300/include/asm/module.h    |    2 --
 include/linux/mod_export.h         |    6 ++----
 init/Kconfig                       |   11 +++++++++++
 scripts/mod/Makefile               |    2 +-
 scripts/mod/mk_elfconfig.c         |    9 ---------
 scripts/mod/modpost.c              |    4 ++++
 9 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 9a01d44..6c99419 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -26,6 +26,7 @@ config BLACKFIN
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select HAVE_OPROFILE
+	select HAVE_SYMBOL_PREFIX
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 
 config GENERIC_BUG
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
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 9420648..cc03bbf 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -9,6 +9,7 @@ config H8300
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_SYMBOL_PREFIX
 
 config MMU
 	bool
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
diff --git a/include/linux/mod_export.h b/include/linux/mod_export.h
index 3d80057..56b817a 100644
--- a/include/linux/mod_export.h
+++ b/include/linux/mod_export.h
@@ -4,10 +4,8 @@
 #include <linux/compiler.h>
 #include <asm/module.h>
 
-/* some toolchains uses a `_' prefix for all user symbols */
-#ifndef MODULE_SYMBOL_PREFIX
-#define MODULE_SYMBOL_PREFIX ""
-#endif
+/* Some toolchains use a `_' prefix for all user symbols. */
+#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
 
 struct kernel_symbol {
 	unsigned long value;
diff --git a/init/Kconfig b/init/Kconfig
index c7bac39..fe43d6d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1171,6 +1171,17 @@ config MODULE_SRCVERSION_ALL
 
 endif # MODULES
 
+config HAVE_SYMBOL_PREFIX
+	bool
+	help
+	  Some arch toolchains use a `_' prefix for all user symbols.
+	  This option will be taken into account when loading modules.
+
+config SYMBOL_PREFIX
+	string
+	default "_" if HAVE_SYMBOL_PREFIX
+	default ""
+
 config INIT_ALL_POSSIBLE
 	bool
 	help
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
index 801a16a..3867481 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -15,8 +15,12 @@
 #include <stdio.h>
 #include <ctype.h>
 #include "modpost.h"
+#include "../../include/linux/autoconf.h"
 #include "../../include/linux/license.h"
 
+/* Some toolchains use a `_' prefix for all user symbols. */
+#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
+
 /* Are we using CONFIG_MODVERSIONS? */
 int modversions = 0;
 /* Warn about undefined symbols? (do so if we have vmlinux) */
-- 
1.6.3.2

