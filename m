Return-Path: <linux-kernel-owner+w=401wt.eu-S1946231AbXBCCPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946231AbXBCCPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946230AbXBCCPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:15:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:64007 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946231AbXBCCPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:15:00 -0500
Date: Sat, 3 Feb 2007 03:08:14 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Andrew Morton <akpm@osdl.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH/RFC] alternative aproach to: Ban module license tag string
 termination trick
Message-ID: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX1+SgOjwphoqwArHuhta9Lx85VTlViEfzFEtFyxXoNt1UC/FNbfodisTqemousA83YPxHF2hMNvpCutOAmb0qnWMTqhzkOdeoawSm+Ttn/Zx3w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the module license handling code to:
- allow modules to have multiple licenses
- access GPL symbols if at least one license is GPL-compatible
- prevent the "GPL\0 for nothing"-trick
- fix an off-by-one buffer overflow
  (exploitable only if the attacker can load modules)
- move the ndiswrapper check into the new license checking routine

Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
---

The license handling code was kind of strange:
 - The kernel itself would only consider the first license, while modpost
   looks at all of them.
 - If you offer your module under a non-GPL license in addition to GPL,
   modpost would consider this module to be non-GPL. Therefore you can't
   say MODULE_LICENSE("GPL");\nMODULE_LICENSE("completely free");

Since I had to rewrite this part, I changed the behaviour to accept all 
modules having _at_least_ one GPL-compatible license.


Prohibiting the \0-trick is done by storing the length of the license
behind the license itself, uuencoded, as $=xyz.

Currently, only 18 bits (256 KB) of the length are stored, but storing up
to 30 bits is possible without changing anything besides the macro.

You can still trick this code by including "...\0license=GPL\0$=$\0..." or
by manually fabricating this string into .modinfo. Fix: Document this to
mean that you actually GPL-license the module. 


TODO: get_modinfo: make sure the value returned does not exceed the end of 
      the buffer.


 include/linux/license.h     |   27 +++++++++---
 include/linux/module.h      |    3 -
 include/linux/moduleinfo.h  |   19 +++++++++
 include/linux/moduleparam.h |   11 +++++
 kernel/Makefile             |    2 
 kernel/module.c             |   92 +++++++++++++++++++++++++-------------------
 kernel/moduleinfo.c         |   73 ++++++++++++++++++++++++++++++++++
 scripts/mod/Makefile        |    2 
 scripts/mod/modpost.c       |   42 +++++---------------
 scripts/mod/moduleinfo.c    |    3 +
 10 files changed, 195 insertions(+), 79 deletions(-)

diff -X dontdiff -pruN 2.6.19/include/linux/license.h 2.6.19.license/include/linux/license.h
--- 2.6.19/include/linux/license.h	2006-11-29 22:57:37.000000000 +0100
+++ 2.6.19.license/include/linux/license.h	2007-02-02 18:30:44.000000000 +0100
@@ -1,14 +1,27 @@
 #ifndef __LICENSE_H
 #define __LICENSE_H
 
-static inline int license_is_gpl_compatible(const char *license)
+static inline int license_is_gpl_compatible(const char *license,
+                                            int length)
 {
-	return (strcmp(license, "GPL") == 0
-		|| strcmp(license, "GPL v2") == 0
-		|| strcmp(license, "GPL and additional rights") == 0
-		|| strcmp(license, "Dual BSD/GPL") == 0
-		|| strcmp(license, "Dual MIT/GPL") == 0
-		|| strcmp(license, "Dual MPL/GPL") == 0);
+	static char *gpl_compatible[] = {
+	    "GPL",
+		"GPL v2",
+		"GPL and additional rights",
+		"Dual BSD/GPL",
+		"Dual MIT/GPL",
+		"Dual MPL/GPL",
+		NULL
+	};
+	char **p = gpl_compatible;
+
+	while (*p) {
+		if(!strcmp(license, *p)
+		&& length == strlen(*p))
+			return 1;
+		p++;
+	}
+	return 0;
 }
 
 #endif
diff -X dontdiff -pruN 2.6.19/include/linux/module.h 2.6.19.license/include/linux/module.h
--- 2.6.19/include/linux/module.h	2006-11-29 22:57:37.000000000 +0100
+++ 2.6.19.license/include/linux/module.h	2007-02-02 23:56:39.000000000 +0100
@@ -92,6 +92,7 @@ extern struct module __this_module;
 
 /* Generic info of form tag = "info" */
 #define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
+#define MODULE_INFO_I(tag, info) __MODULE_INFO_I(tag, tag, info)
 
 /* For userspace: you can also call me... */
 #define MODULE_ALIAS(_alias) MODULE_INFO(alias, _alias)
@@ -124,7 +125,7 @@ extern struct module __this_module;
  * 2.	So the community can ignore bug reports including proprietary modules
  * 3.	So vendors can do likewise based on their own policies
  */
-#define MODULE_LICENSE(_license) MODULE_INFO(license, _license)
+#define MODULE_LICENSE(_license) MODULE_INFO_I(license, _license)
 
 /* Author, ideally of form NAME <EMAIL>[, NAME <EMAIL>]*[ and NAME <EMAIL>] */
 #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
diff -X dontdiff -pruN 2.6.19/include/linux/moduleinfo.h 2.6.19.license/include/linux/moduleinfo.h
--- 2.6.19/include/linux/moduleinfo.h	1970-01-01 01:00:00.000000000 +0100
+++ 2.6.19.license/include/linux/moduleinfo.h	2007-02-02 20:33:26.000000000 +0100
@@ -0,0 +1,19 @@
+#ifndef __MODULEINFO_H
+#define __MODULEINFO_H
+
+struct pstring_len {
+	char * s;
+	unsigned long i;
+};
+
+extern void do_get_next_modinfo_len(struct pstring_len *ret,
+                                    char * start,
+                                    unsigned long size,
+                                    const char *tag);
+
+/**
+ * Parse tag=value strings
+ **/
+extern char *next_string(char *string, unsigned long *secsize);
+
+#endif
diff -X dontdiff -pruN 2.6.19/include/linux/moduleparam.h 2.6.19.license/include/linux/moduleparam.h
--- 2.6.19/include/linux/moduleparam.h	2006-11-29 22:57:37.000000000 +0100
+++ 2.6.19.license/include/linux/moduleparam.h	2007-02-02 18:19:20.000000000 +0100
@@ -20,8 +20,19 @@
 static const char __module_cat(name,__LINE__)[]				  \
   __attribute_used__							  \
   __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info
+#define __MODULE_INFO_I(tag, name, info)                                  \
+static const char __module_cat(name,__LINE__)[]                           \
+  __attribute_used__                                                      \
+  __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info;\
+static const char __module_cat(name ## _len,__LINE__)[]                   \
+  __attribute_used__                                                      \
+  __attribute__((section(".modinfo"),unused)) = {'$','=',                 \
+     (sizeof(info)        & 0x3f) + 32,                                   \
+    ((sizeof(info) >>  6) & 0x3f) + 32,                                   \
+    ((sizeof(info) >> 12) & 0x3f) + 32, 0 }
 #else  /* !MODULE */
 #define __MODULE_INFO(tag, name, info)
+#define __MODULE_INFO_I(tag, name, info)
 #endif
 #define __MODULE_PARM_TYPE(name, _type)					  \
   __MODULE_INFO(parmtype, name##type, #name ":" _type)
diff -X dontdiff -pruN 2.6.19/kernel/Makefile 2.6.19.license/kernel/Makefile
--- 2.6.19/kernel/Makefile	2006-11-29 22:57:37.000000000 +0100
+++ 2.6.19.license/kernel/Makefile	2007-02-02 21:03:15.000000000 +0100
@@ -29,7 +29,7 @@ obj-$(CONFIG_SMP) += cpu.o spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
-obj-$(CONFIG_MODULES) += module.o
+obj-$(CONFIG_MODULES) += module.o moduleinfo.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_STACK_UNWIND) += unwind.o
 obj-$(CONFIG_PM) += power/
diff -X dontdiff -pruN 2.6.19/kernel/module.c 2.6.19.license/kernel/module.c
--- 2.6.19/kernel/module.c	2006-11-29 22:57:37.000000000 +0100
+++ 2.6.19.license/kernel/module.c	2007-02-02 21:27:54.000000000 +0100
@@ -44,6 +44,7 @@
 #include <asm/semaphore.h>
 #include <asm/cacheflush.h>
 #include <linux/license.h>
+#include <linux/moduleinfo.h>
 
 #if 0
 #define DEBUGP printk
@@ -1335,38 +1336,6 @@ static void layout_sections(struct modul
 	}
 }
 
-static void set_license(struct module *mod, const char *license)
-{
-	if (!license)
-		license = "unspecified";
-
-	if (!license_is_gpl_compatible(license)) {
-		if (!(tainted & TAINT_PROPRIETARY_MODULE))
-			printk(KERN_WARNING "%s: module license '%s' taints "
-				"kernel.\n", mod->name, license);
-		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
-	}
-}
-
-/* Parse tag=value strings from .modinfo section */
-static char *next_string(char *string, unsigned long *secsize)
-{
-	/* Skip non-zero chars */
-	while (string[0]) {
-		string++;
-		if ((*secsize)-- <= 1)
-			return NULL;
-	}
-
-	/* Skip any zero padding. */
-	while (!string[0]) {
-		string++;
-		if ((*secsize)-- <= 1)
-			return NULL;
-	}
-	return string;
-}
-
 static char *get_modinfo(Elf_Shdr *sechdrs,
 			 unsigned int info,
 			 const char *tag)
@@ -1376,12 +1345,62 @@ static char *get_modinfo(Elf_Shdr *sechd
 	unsigned long size = sechdrs[info].sh_size;
 
 	for (p = (char *)sechdrs[info].sh_addr; p; p = next_string(p, &size)) {
-		if (strncmp(p, tag, taglen) == 0 && p[taglen] == '=')
+		if (taglen + 1 < size
+		&&  strncmp(p, tag, taglen) == 0 && p[taglen] == '=')
 			return p + taglen + 1;
 	}
 	return NULL;
 }
 
+void get_next_modinfo_len(struct pstring_len *ret,
+                  Elf_Shdr *sechdrs,
+                  unsigned int info,
+                  const char *tag)
+{
+	do_get_next_modinfo_len(ret, (char *)sechdrs[info].sh_addr,
+	                        sechdrs[info].sh_size, tag);
+	                        
+}
+
+static void set_license(struct module *mod,
+                        Elf_Shdr *sechdrs,
+                        unsigned int info)
+{
+	char * license_gpl    = NULL;
+	char * license_nongpl = NULL;
+	struct pstring_len ret = { .s = NULL };
+	
+	while (1) {
+		get_next_modinfo_len(&ret, sechdrs, info, "license");
+		if (!ret.s)
+			break;
+		if (license_is_gpl_compatible(ret.s, ret.i)) {
+			if (!license_gpl)
+				license_gpl = ret.s;
+				break; /* we'll use this one */
+		} else {
+			if (!license_nongpl)
+				license_nongpl = ret.s;
+			/* loop for a possible GPL-compatible license */
+		}
+	}
+
+	/* We'll consider the kernel to be tainted by ndiswrapper
+	 * & co., since they'll usurally load proprietary code */
+	if (!license_gpl
+	||  strcmp(mod->name, "ndiswrapper") == 0
+	||  strcmp(mod->name, "driverloader") == 0) {
+		if (!license_nongpl)
+			license_nongpl = "No license specified";
+		if (!(tainted & TAINT_PROPRIETARY_MODULE)
+		&&  !license_gpl)
+			printk(KERN_WARNING "%s: module license '%s' taints "
+				"kernel.\n", mod->name, license_nongpl);
+		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
+	}
+	/* todo: possibly do something about the found license */
+}
+
 static void setup_modinfo(struct module *mod, Elf_Shdr *sechdrs,
 			  unsigned int infoindex)
 {
@@ -1715,12 +1734,7 @@ static struct module *load_module(void _
 	module_unload_init(mod);
 
 	/* Set up license info based on the info section */
-	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
-
-	if (strcmp(mod->name, "ndiswrapper") == 0)
-		add_taint(TAINT_PROPRIETARY_MODULE);
-	if (strcmp(mod->name, "driverloader") == 0)
-		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
+	set_license(mod, sechdrs, infoindex);
 
 	/* Set up MODINFO_ATTR fields */
 	setup_modinfo(mod, sechdrs, infoindex);
diff -X dontdiff -pruN 2.6.19/kernel/moduleinfo.c 2.6.19.license/kernel/moduleinfo.c
--- 2.6.19/kernel/moduleinfo.c	1970-01-01 01:00:00.000000000 +0100
+++ 2.6.19.license/kernel/moduleinfo.c	2007-02-03 01:03:28.000000000 +0100
@@ -0,0 +1,73 @@
+#ifdef __KERNEL__
+#include <linux/moduleinfo.h>
+#include <linux/stddef.h>
+#include <linux/string.h>
+#endif
+
+char *next_string(char *string, unsigned long *secsize)
+{
+	/* Skip non-zero chars */
+	while (string[0]) {
+		string++;
+		if ((*secsize)-- <= 1)
+			return NULL;
+	}
+
+	/* Skip any zero padding. */
+	while (!string[0]) {
+		string++;
+		if ((*secsize)-- <= 1)
+			return NULL;
+	}
+	return string;
+}
+
+void do_get_next_modinfo_len(struct pstring_len *ret,
+                             char * start,
+                             unsigned long size,
+                             const char *tag)
+{
+	char *p, *q;
+	unsigned int taglen = strlen(tag);
+	unsigned int nexttag; /* distance to the ~ */
+	unsigned int length = 0;
+	unsigned int c = 1;
+	int shift = -6;
+
+	if (ret->s) {
+		size -= (ret->s - start)
+		       + ret->i;
+		start = next_string(  ret->s
+                           + ret->i, &size);
+	}
+
+	for (p = start; p; p = next_string(p, &size)) {
+		if (taglen + 1 < size
+		&&  strncmp(p, tag, taglen) == 0 && p[taglen] == '=') {
+			q = next_string(p, &size);
+			nexttag = q - p;
+			if (q && *q == '$' && *(q+1) == '=') {
+				q += 2;
+				size -= 2;
+				while (size-- > 0 && (c=*q++) && shift <= 30) {
+					shift += 6;
+					c-=32;
+					if (c & ~0x3f)
+						goto out; // paranoid?
+					length |= c << shift;
+				}
+				if (!c) {
+					/* we terminated the loop because we found the
+					   end of the string */
+					if(nexttag < length + taglen + 1)
+						goto out;
+					ret->i = length - 1; /* account for the \0 */
+					ret->s = p + taglen + 1;
+					return;
+				}
+			}
+		}
+	}
+	out:
+	ret->s = NULL;
+}
diff -X dontdiff -pruN 2.6.19/scripts/mod/Makefile 2.6.19.license/scripts/mod/Makefile
--- 2.6.19/scripts/mod/Makefile	2006-11-29 22:57:37.000000000 +0100
+++ 2.6.19.license/scripts/mod/Makefile	2007-02-02 20:20:34.000000000 +0100
@@ -1,7 +1,7 @@
 hostprogs-y	:= modpost mk_elfconfig
 always		:= $(hostprogs-y) empty.o
 
-modpost-objs	:= modpost.o file2alias.o sumversion.o
+modpost-objs	:= modpost.o file2alias.o sumversion.o moduleinfo.o
 
 # dependencies on generated files need to be listed explicitly
 
diff -X dontdiff -pruN 2.6.19/scripts/mod/modpost.c 2.6.19.license/scripts/mod/modpost.c
--- 2.6.19/scripts/mod/modpost.c	2006-11-29 22:57:37.000000000 +0100
+++ 2.6.19.license/scripts/mod/modpost.c	2007-02-03 00:26:04.000000000 +0100
@@ -14,6 +14,8 @@
 #include <ctype.h>
 #include "modpost.h"
 #include "../../include/linux/license.h"
+#include "../../include/linux/moduleinfo.h"
+#define get_next_modinfo_len do_get_next_modinfo_len
 
 /* Are we using CONFIG_MODVERSIONS? */
 int modversions = 0;
@@ -491,27 +493,6 @@ static void handle_modversions(struct mo
 	}
 }
 
-/**
- * Parse tag=value strings from .modinfo section
- **/
-static char *next_string(char *string, unsigned long *secsize)
-{
-	/* Skip non-zero chars */
-	while (string[0]) {
-		string++;
-		if ((*secsize)-- <= 1)
-			return NULL;
-	}
-
-	/* Skip any zero padding. */
-	while (!string[0]) {
-		string++;
-		if ((*secsize)-- <= 1)
-			return NULL;
-	}
-	return string;
-}
-
 static char *get_next_modinfo(void *modinfo, unsigned long modinfo_len,
 			      const char *tag, char *info)
 {
@@ -525,7 +506,8 @@ static char *get_next_modinfo(void *modi
 	}
 
 	for (p = modinfo; p; p = next_string(p, &size)) {
-		if (strncmp(p, tag, taglen) == 0 && p[taglen] == '=')
+		if (taglen + 1 < size
+		&&  strncmp(p, tag, taglen) == 0 && p[taglen] == '=')
 			return p + taglen + 1;
 	}
 	return NULL;
@@ -1029,7 +1011,7 @@ static void read_symbols(char *modname)
 {
 	const char *symname;
 	char *version;
-	char *license;
+	struct pstring_len license;
 	struct module *mod;
 	struct elf_info info = { };
 	Elf_Sym *sym;
@@ -1045,16 +1027,16 @@ static void read_symbols(char *modname)
 		mod->skip = 1;
 	}
 
-	license = get_modinfo(info.modinfo, info.modinfo_len, "license");
-	while (license) {
-		if (license_is_gpl_compatible(license))
+	/* A module is GPL if at least one of it's licenses is GPL-compatible */
+	license.s = NULL;
+	get_next_modinfo_len(&license, info.modinfo, info.modinfo_len, "license");
+	mod->gpl_compatible = 0;
+	while (license.s) {
+		if (license_is_gpl_compatible(license.s, license.i)) {
 			mod->gpl_compatible = 1;
-		else {
-			mod->gpl_compatible = 0;
 			break;
 		}
-		license = get_next_modinfo(info.modinfo, info.modinfo_len,
-					   "license", license);
+		get_next_modinfo_len(&license, info.modinfo, info.modinfo_len, "license");
 	}
 
 	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
diff -X dontdiff -pruN 2.6.19/scripts/mod/moduleinfo.c 2.6.19.license/scripts/mod/moduleinfo.c
--- 2.6.19/scripts/mod/moduleinfo.c	1970-01-01 01:00:00.000000000 +0100
+++ 2.6.19.license/scripts/mod/moduleinfo.c	2007-02-02 20:25:25.000000000 +0100
@@ -0,0 +1,3 @@
+#include <string.h>
+#include "../../include/linux/moduleinfo.h"
+#include "../../kernel/moduleinfo.c"
