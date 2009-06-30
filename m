Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZF3L5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZF3L5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZF3L5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:57:24 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46356 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbZF3L5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:57:24 -0400
Message-Id: <4A4A19C60200007800008353@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 30 Jun 2009 12:57:26 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <sam@ravnborg.org>, "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <tony.luck@intel.com>, "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Paul Mackerras" <paulus@samba.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] also discard .*init sections after module
	 initialization
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like .init, these sections are supposed to be unneeded after init,
and modpost warns about improper section references anyway. Likewise
for .*exit which, other than .exit, aren't needed for the module unload
path.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/ia64/kernel/module.c       |    3 ++-
 arch/powerpc/kernel/module_32.c |   14 ++++++++------
 arch/powerpc/kernel/module_64.c |    5 ++---
 include/linux/module.h          |    2 ++
 kernel/module.c                 |   37 +++++++++++++++++++++++++++++++++++--
 5 files changed, 49 insertions(+), 12 deletions(-)

--- linux-2.6.31-rc1/arch/ia64/kernel/module.c	2009-06-26 17:49:37.000000000 +0200
+++ 2.6.31-rc1-module-discard-xxxinit/arch/ia64/kernel/module.c	2009-04-27 12:06:09.000000000 +0200
@@ -473,7 +473,8 @@ module_frob_arch_sections (Elf_Ehdr *ehd
 
 		gots += count_gots(rels, numrels);
 		fdescs += count_fdescs(rels, numrels);
-		if (strstr(secstrings + s->sh_name, ".init"))
+		if (is_init_section_name(secstrings
+					 + sechdrs[s->sh_info].sh_name))
 			init_plts += count_plts(rels, numrels);
 		else
 			core_plts += count_plts(rels, numrels);
--- linux-2.6.31-rc1/arch/powerpc/kernel/module_32.c	2009-03-24 00:12:14.000000000 +0100
+++ 2.6.31-rc1-module-discard-xxxinit/arch/powerpc/kernel/module_32.c	2009-04-27 12:06:09.000000000 +0200
@@ -111,17 +111,19 @@ static unsigned long get_plt_size(const 
 	/* Everything marked ALLOC (this includes the exported
            symbols) */
 	for (i = 1; i < hdr->e_shnum; i++) {
-		/* If it's called *.init*, and we're not init, we're
-                   not interested */
-		if ((strstr(secstrings + sechdrs[i].sh_name, ".init") != 0)
-		    != is_init)
-			continue;
-
 		/* We don't want to look at debug sections. */
 		if (strstr(secstrings + sechdrs[i].sh_name, ".debug") != 0)
 			continue;
 
 		if (sechdrs[i].sh_type == SHT_RELA) {
+			/* If it's .init-like, and we're not init, we're
+			   not interested */
+			if (is_init_section_name(secstrings
+						 + sechdrs[sechdrs[i].sh_info]
+						   .sh_name)
+			    != is_init)
+				continue;
+
 			DEBUGP("Found relocations in section %u\n", i);
 			DEBUGP("Ptr: %p.  Number: %u\n",
 			       (void *)hdr + sechdrs[i].sh_offset,
--- linux-2.6.31-rc1/arch/powerpc/kernel/module_64.c	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc1-module-discard-xxxinit/arch/powerpc/kernel/module_64.c	2009-04-27 12:06:09.000000000 +0200
@@ -206,7 +206,6 @@ int module_frob_arch_sections(Elf64_Ehdr
 
 	/* Find .toc and .stubs sections, symtab and strtab */
 	for (i = 1; i < hdr->e_shnum; i++) {
-		char *p;
 		if (strcmp(secstrings + sechdrs[i].sh_name, ".stubs") == 0)
 			me->arch.stubs_section = i;
 		else if (strcmp(secstrings + sechdrs[i].sh_name, ".toc") == 0)
@@ -216,8 +215,8 @@ int module_frob_arch_sections(Elf64_Ehdr
 					  sechdrs[i].sh_size);
 
 		/* We don't handle .init for the moment: rename to _init */
-		while ((p = strstr(secstrings + sechdrs[i].sh_name, ".init")))
-			p[0] = '_';
+		if (is_init_section_name(secstrings + sechdrs[i].sh_name))
+			secstrings[sechdrs[i].sh_name] = '_';
 
 		if (sechdrs[i].sh_type == SHT_SYMTAB)
 			dedotify((void *)hdr + sechdrs[i].sh_offset,
--- linux-2.6.31-rc1/include/linux/module.h	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-module-discard-xxxinit/include/linux/module.h	2009-04-27 12:07:17.000000000 +0200
@@ -401,6 +401,8 @@ static inline int within_module_init(uns
 	       addr < (unsigned long)mod->module_init + mod->init_size;
 }
 
+bool is_init_section_name(const char *);
+
 /* Search for module by name: must hold module_mutex. */
 struct module *find_module(const char *name);
 
--- linux-2.6.31-rc1/kernel/module.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-module-discard-xxxinit/kernel/module.c	2009-04-27 12:11:51.000000000 +0200
@@ -1655,6 +1655,39 @@ static long get_offset(struct module *mo
 	return ret;
 }
 
+bool is_init_section_name(const char *name)
+{
+	unsigned int i, n;
+	static const char *const prefixes[] = {
+#ifndef CONFIG_HOTPLUG_CPU
+		"cpu",
+#endif
+#ifndef CONFIG_HOTPLUG
+		"dev",
+#endif
+#ifndef CONFIG_MEMORY_HOTPLUG
+		"mem",
+#endif
+		""
+	};
+
+	if (*name++ != '.')
+		return false;
+	for (i = 0; i < ARRAY_SIZE(prefixes); ++i) {
+		n = strlen(prefixes[i]);
+		if (strncmp(name, prefixes[i], n) == 0)
+			break;
+	}
+	if (i >= ARRAY_SIZE(prefixes))
+		return false;
+#ifdef CONFIG_MODULE_UNLOAD
+	if (n == 0 && strncmp(name, "exit", 4) == 0)
+		return false;
+#endif
+	return strncmp(name + n, "init", 4) == 0
+	       || strncmp(name + n, "exit", 4) == 0;
+}
+
 /* Lay out the SHF_ALLOC sections in a way not dissimilar to how ld
    might -- code, read-only data, read-write data, small data.  Tally
    sizes, and place the offsets into sh_entsize fields: high bit means it
@@ -1686,7 +1719,7 @@ static void layout_sections(struct modul
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
 			    || s->sh_entsize != ~0UL
-			    || strstarts(secstrings + s->sh_name, ".init"))
+			    || is_init_section_name(secstrings + s->sh_name))
 				continue;
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
@@ -1703,7 +1736,7 @@ static void layout_sections(struct modul
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
 			    || s->sh_entsize != ~0UL
-			    || !strstarts(secstrings + s->sh_name, ".init"))
+			    || !is_init_section_name(secstrings + s->sh_name))
 				continue;
 			s->sh_entsize = (get_offset(mod, &mod->init_size, s, i)
 					 | INIT_OFFSET_MASK);


