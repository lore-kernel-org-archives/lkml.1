Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZA1Ngq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZA1Ngq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbZA1Nf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:35:58 -0500
Received: from ozlabs.org ([203.10.76.45]:55200 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbZA1Nf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:35:57 -0500
To: linux-kernel@vger.kernel.org
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 29 Jan 2009 00:05:42 +1030
CC: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 4/6] module: check versions *after* relocation.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901290005.42702.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rather than checking versions as we look up symbols, we save all the
symbols we resolved and then check them afterwards.

This will allow us to use char *'s in the __versions section, which
need relocations before they can be dereferenced.

krealloc and the loop isn't all that efficient, but there are rarely
very many unresolved symbols in a module.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |  163 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 113 insertions(+), 50 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -975,35 +975,20 @@ static int try_to_force_load(struct modu
 }
 
 #ifdef CONFIG_MODVERSIONS
-static int check_version(Elf_Shdr *sechdrs,
-			 unsigned int versindex,
-			 const char *symname,
-			 struct module *mod, 
-			 const unsigned long *crc)
+static bool check_version(struct module *mod,
+			  const struct modversion_info *versions,
+			  unsigned int num_versions,
+			  const char *symname,
+			  const unsigned long crc)
 {
-	unsigned int i, num_versions;
-	struct modversion_info *versions;
-
-	/* Exporting module didn't supply crcs?  OK, we're already tainted. */
-	if (!crc)
-		return 1;
-
-	/* No versions at all?  modprobe --force does this. */
-	if (versindex == 0)
-		return try_to_force_load(mod, symname) == 0;
-
-	versions = (void *) sechdrs[versindex].sh_addr;
-	num_versions = sechdrs[versindex].sh_size
-		/ sizeof(struct modversion_info);
+	unsigned int i;
 
 	for (i = 0; i < num_versions; i++) {
 		if (strcmp(versions[i].name, symname) != 0)
 			continue;
 
-		if (versions[i].crc == *crc)
+		if (versions[i].crc == crc)
 			return 1;
-		DEBUGP("Found checksum %lX vs module %lX\n",
-		       *crc, versions[i].crc);
 		goto bad_version;
 	}
 
@@ -1017,12 +1002,45 @@ bad_version:
 	return 0;
 }
 
+static inline bool check_versions(struct module *mod,
+				  Elf_Shdr *sechdrs, unsigned int versindex,
+				  char **syms)
+{
+	unsigned int i, num_versions;
+	bool ok = true;
+	const struct modversion_info *versions;
+
+	/* No versions at all?  modprobe --force does this. */
+	if (versindex == 0)
+		return try_to_force_load(mod, "no symbol versions") == 0;
+
+	versions = (void *)sechdrs[versindex].sh_addr;
+	num_versions = sechdrs[versindex].sh_size / sizeof(*versions);
+
+	for (i = 0; syms[i]; i++) {
+		const unsigned long *crc;
+
+		/* We shouldn't get here unless all symbols resolved. */
+		if (IS_ERR_VALUE(find_symbol(syms[i], NULL, &crc, true, false)))
+			BUG();
+
+		/* Exporting module didn't supply crcs?  OK, we're
+		 * already tainted. */
+		if (!crc)
+			continue;
+
+		/* We report all of them, instead of breaking out of loop. */
+		if (!check_version(mod, versions, num_versions, syms[i], *crc))
+			ok = false;
+	}
+	return ok;
+}
+
 static inline int check_modstruct_version(Elf_Shdr *sechdrs,
 					  unsigned int versindex,
 					  struct module *mod)
 {
 	const unsigned long *crc;
-	unsigned int num_versions;
 	struct modversion_info *versions;
 
 	if (IS_ERR_VALUE(find_symbol("module_layout", NULL, &crc, true, false)))
@@ -1037,7 +1055,7 @@ static inline int check_modstruct_versio
 		return !try_to_force_load(mod, "no version for module_layout");
 
 	if (sechdrs[versindex].sh_size < sizeof(*versions)) {
-		printk(KERN_WARN "%s: bad __versions section size\n",
+		printk(KERN_WARNING "%s: bad __versions section size\n",
 		       mod->name);
 		return 0;
 	}
@@ -1060,14 +1078,30 @@ static inline int same_magic(const char 
 	}
 	return strcmp(amagic, bmagic) == 0;
 }
+
+static bool add_resolved(char ***resolved, const char *name)
+{
+	unsigned long i;
+	char **new;
+
+	for (i = 0; (*resolved)[i]; i++)
+		if (strcmp((*resolved)[i], name) == 0)
+			return true;
+	new = krealloc(*resolved, (i+2)*sizeof(char *), GFP_KERNEL);
+	if (!new)
+		return false;
+	new[i] = (char *)name;
+	new[i+1] = NULL;
+	*resolved = new;
+	return true;
+}
 #else
-static inline int check_version(Elf_Shdr *sechdrs,
-				unsigned int versindex,
-				const char *symname,
-				struct module *mod, 
-				const unsigned long *crc)
+static inline bool check_versions(struct module *mod,
+				  Elf_Shdr *sechdrs,
+				  unsigned int versindex,
+				  char **resolved)
 {
-	return 1;
+	return true;
 }
 
 static inline int check_modstruct_version(Elf_Shdr *sechdrs,
@@ -1082,6 +1116,11 @@ static inline int same_magic(const char 
 {
 	return strcmp(amagic, bmagic) == 0;
 }
+
+static bool add_resolved(char ***resolved, const char *name)
+{
+	return true;
+}
 #endif /* CONFIG_MODVERSIONS */
 
 /* Resolve a symbol for this module.  I.e. if we find one, record usage.
@@ -1093,15 +1132,13 @@ static unsigned long resolve_symbol(Elf_
 {
 	struct module *owner;
 	unsigned long ret;
-	const unsigned long *crc;
 
-	ret = find_symbol(name, &owner, &crc,
+	ret = find_symbol(name, &owner, NULL,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
 	if (!IS_ERR_VALUE(ret)) {
 		/* use_module can fail due to OOM,
 		   or module initialization or unloading */
-		if (!check_version(sechdrs, versindex, name, mod, crc) ||
-		    !use_module(mod, owner))
+		if (!use_module(mod, owner))
 			ret = -EINVAL;
 	}
 	return ret;
@@ -1552,18 +1589,25 @@ static int verify_export_symbols(struct 
 	return 0;
 }
 
-/* Change all symbols so that st_value encodes the pointer directly. */
-static int simplify_symbols(Elf_Shdr *sechdrs,
-			    unsigned int symindex,
-			    const char *strtab,
-			    unsigned int versindex,
-			    unsigned int pcpuindex,
-			    struct module *mod)
+/* Change all symbols so that st_value encodes the pointer directly.
+ * Returns NULL-terminated array of what symbols were resolved, for
+ * modversions. */
+static char **simplify_symbols(Elf_Shdr *sechdrs,
+			       unsigned int symindex,
+			       const char *strtab,
+			       unsigned int versindex,
+			       unsigned int pcpuindex,
+			       struct module *mod)
 {
 	Elf_Sym *sym = (void *)sechdrs[symindex].sh_addr;
 	unsigned long secbase;
 	unsigned int i, n = sechdrs[symindex].sh_size / sizeof(Elf_Sym);
-	int ret = 0;
+	char **resolved;
+	int err = 0;
+
+	resolved = kzalloc(sizeof(char *), GFP_KERNEL);
+	if (!resolved)
+		return ERR_PTR(-ENOMEM);
 
 	for (i = 1; i < n; i++) {
 		switch (sym[i].st_shndx) {
@@ -1573,7 +1617,7 @@ static int simplify_symbols(Elf_Shdr *se
 			DEBUGP("Common symbol: %s\n", strtab + sym[i].st_name);
 			printk("%s: please compile with -fno-common\n",
 			       mod->name);
-			ret = -ENOEXEC;
+			err = -ENOEXEC;
 			break;
 
 		case SHN_ABS:
@@ -1588,15 +1632,19 @@ static int simplify_symbols(Elf_Shdr *se
 					   strtab + sym[i].st_name, mod);
 
 			/* Ok if resolved.  */
-			if (!IS_ERR_VALUE(sym[i].st_value))
+			if (!IS_ERR_VALUE(sym[i].st_value)) {
+				if (!add_resolved(&resolved,
+						  strtab + sym[i].st_name))
+					err = -ENOMEM;
 				break;
+			}
 			/* Ok if weak.  */
 			if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
 				break;
 
 			printk(KERN_WARNING "%s: Unknown symbol %s\n",
 			       mod->name, strtab + sym[i].st_name);
-			ret = -ENOENT;
+			err = -ENOENT;
 			break;
 
 		default:
@@ -1610,7 +1658,11 @@ static int simplify_symbols(Elf_Shdr *se
 		}
 	}
 
-	return ret;
+	if (err) {
+		kfree(resolved);
+		resolved = ERR_PTR(err);
+	}
+	return resolved;
 }
 
 /* Additional bytes needed by arch in front of individual sections */
@@ -1888,6 +1940,7 @@ static noinline struct module *load_modu
 	Elf_Shdr *sechdrs;
 	char *secstrings, *args, *modmagic, *strtab = NULL;
 	char *staging;
+	char **resolved;
 	unsigned int i;
 	unsigned int symindex = 0;
 	unsigned int strindex = 0;
@@ -2131,10 +2184,12 @@ static noinline struct module *load_modu
 	setup_modinfo(mod, sechdrs, infoindex);
 
 	/* Fix up syms, so that st_value is a pointer to location. */
-	err = simplify_symbols(sechdrs, symindex, strtab, versindex, pcpuindex,
-			       mod);
-	if (err < 0)
-		goto cleanup;
+	resolved = simplify_symbols(sechdrs, symindex, strtab, versindex,
+				    pcpuindex, mod);
+	if (IS_ERR(resolved)) {
+		err = PTR_ERR(resolved);
+		goto free_kobjs;
+	}
 
 	/* Now we've got everything in the final locations, we can
 	 * find optional sections. */
@@ -2218,6 +2273,11 @@ static noinline struct module *load_modu
 			goto cleanup;
 	}
 
+	if (!check_versions(mod, sechdrs, versindex, resolved)) {
+		err = -EINVAL;
+		goto cleanup;
+	}
+
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
 	if (err < 0)
@@ -2296,6 +2356,7 @@ static noinline struct module *load_modu
 
 	/* Get rid of temporary copy */
 	vfree(hdr);
+	kfree(resolved);
 
 	stop_machine_destroy();
 	/* Done! */
@@ -2305,6 +2366,8 @@ static noinline struct module *load_modu
 	stop_machine(__unlink_module, mod, NULL);
 	module_arch_cleanup(mod);
  cleanup:
+	kfree(resolved);
+ free_kobjs:
 	kobject_del(&mod->mkobj.kobj);
 	kobject_put(&mod->mkobj.kobj);
 	ftrace_release(mod->module_core, mod->core_size);

