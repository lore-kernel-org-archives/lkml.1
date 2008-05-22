Return-Path: <linux-kernel-owner+w=401wt.eu-S934338AbYEVVTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934338AbYEVVTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933888AbYEVVS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:18:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763625AbYEVVS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:18:56 -0400
Date: Thu, 22 May 2008 17:18:26 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] debug printk infrastructure -convert DEBUGP calls to pr_debug module.c
Message-ID: <20080522211826.GF28070@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 kernel/module.c |   40 +++++++++++++++++-----------------------
 1 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 2dd2ef6..0de259a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -48,12 +48,6 @@
 #include <linux/license.h>
 #include <asm/sections.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(fmt , a...)
-#endif
-
 #ifndef ARCH_SHF_SMALL
 #define ARCH_SHF_SMALL 0
 #endif
@@ -290,7 +284,7 @@ static unsigned long __find_symbol(const char *name,
 			return ks->value;
 		}
 	}
-	DEBUGP("Failed to find symbol %s\n", name);
+	pr_debug("Failed to find symbol %s\n", name);
 	return -ENOENT;
 }
 
@@ -539,11 +533,11 @@ static int already_uses(struct module *a, struct module *b)
 
 	list_for_each_entry(use, &b->modules_which_use_me, list) {
 		if (use->module_which_uses == a) {
-			DEBUGP("%s uses %s!\n", a->name, b->name);
+			pr_debug("%s uses %s!\n", a->name, b->name);
 			return 1;
 		}
 	}
-	DEBUGP("%s does not use %s!\n", a->name, b->name);
+	pr_debug("%s does not use %s!\n", a->name, b->name);
 	return 0;
 }
 
@@ -568,7 +562,7 @@ static int use_module(struct module *a, struct module *b)
 	if (err)
 		return 0;
 
-	DEBUGP("Allocating new usage for %s.\n", a->name);
+	pr_debug("Allocating new usage for %s.\n", a->name);
 	use = kmalloc(sizeof(*use), GFP_ATOMIC);
 	if (!use) {
 		printk("%s: out of memory loading\n", a->name);
@@ -592,7 +586,7 @@ static void module_unload_free(struct module *mod)
 
 		list_for_each_entry(use, &i->modules_which_use_me, list) {
 			if (use->module_which_uses == mod) {
-				DEBUGP("%s unusing %s\n", mod->name, i->name);
+				pr_debug("%s unusing %s\n", mod->name, i->name);
 				module_put(i);
 				list_del(&use->list);
 				kfree(use);
@@ -667,7 +661,7 @@ static void wait_for_zero_refcount(struct module *mod)
 	/* Since we might sleep for some time, release the mutex first */
 	mutex_unlock(&module_mutex);
 	for (;;) {
-		DEBUGP("Looking at refcount...\n");
+		pr_debug("Looking at refcount...\n");
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (module_refcount(mod) == 0)
 			break;
@@ -710,7 +704,7 @@ sys_delete_module(const char __user *name_user, unsigned int flags)
 	if (mod->state != MODULE_STATE_LIVE) {
 		/* FIXME: if (force), slam module count and wake up
                    waiter --RR */
-		DEBUGP("%s already dying\n", mod->name);
+		pr_debug("%s already dying\n", mod->name);
 		ret = -EBUSY;
 		goto out;
 	}
@@ -911,7 +905,7 @@ static int check_version(Elf_Shdr *sechdrs,
 			return 1;
 		printk("%s: disagrees about version of symbol %s\n",
 		       mod->name, symname);
-		DEBUGP("Found checksum %lX vs module %lX\n",
+		pr_debug("Found checksum %lX vs module %lX\n",
 		       *crc, versions[i].crc);
 		return 0;
 	}
@@ -1433,7 +1427,7 @@ static int simplify_symbols(Elf_Shdr *sechdrs,
 		case SHN_COMMON:
 			/* We compiled with -fno-common.  These are not
 			   supposed to happen.  */
-			DEBUGP("Common symbol: %s\n", strtab + sym[i].st_name);
+			pr_debug("Common symbol: %s\n", strtab + sym[i].st_name);
 			printk("%s: please compile with -fno-common\n",
 			       mod->name);
 			ret = -ENOEXEC;
@@ -1441,7 +1435,7 @@ static int simplify_symbols(Elf_Shdr *sechdrs,
 
 		case SHN_ABS:
 			/* Don't need to do anything */
-			DEBUGP("Absolute symbol: 0x%08lx\n",
+			pr_debug("Absolute symbol: 0x%08lx\n",
 			       (long)sym[i].st_value);
 			break;
 
@@ -1509,7 +1503,7 @@ static void layout_sections(struct module *mod,
 	for (i = 0; i < hdr->e_shnum; i++)
 		sechdrs[i].sh_entsize = ~0UL;
 
-	DEBUGP("Core section allocation order:\n");
+	pr_debug("Core section allocation order:\n");
 	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
 		for (i = 0; i < hdr->e_shnum; ++i) {
 			Elf_Shdr *s = &sechdrs[i];
@@ -1521,13 +1515,13 @@ static void layout_sections(struct module *mod,
 				       ".init", 5) == 0)
 				continue;
 			s->sh_entsize = get_offset(&mod->core_size, s);
-			DEBUGP("\t%s\n", secstrings + s->sh_name);
+			pr_debug("\t%s\n", secstrings + s->sh_name);
 		}
 		if (m == 0)
 			mod->core_text_size = mod->core_size;
 	}
 
-	DEBUGP("Init section allocation order:\n");
+	pr_debug("Init section allocation order:\n");
 	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
 		for (i = 0; i < hdr->e_shnum; ++i) {
 			Elf_Shdr *s = &sechdrs[i];
@@ -1540,7 +1534,7 @@ static void layout_sections(struct module *mod,
 				continue;
 			s->sh_entsize = (get_offset(&mod->init_size, s)
 					 | INIT_OFFSET_MASK);
-			DEBUGP("\t%s\n", secstrings + s->sh_name);
+			pr_debug("\t%s\n", secstrings + s->sh_name);
 		}
 		if (m == 0)
 			mod->init_text_size = mod->init_size;
@@ -1730,7 +1724,7 @@ static struct module *load_module(void __user *umod,
 	struct exception_table_entry *extable;
 	mm_segment_t old_fs;
 
-	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
+	pr_debug("load_module: umod=%p, len=%lu, uargs=%p\n",
 	       umod, len, uargs);
 	if (len < sizeof(*hdr))
 		return ERR_PTR(-ENOEXEC);
@@ -1905,7 +1899,7 @@ static struct module *load_module(void __user *umod,
 	mod->module_init = ptr;
 
 	/* Transfer each section which specifies SHF_ALLOC */
-	DEBUGP("final section addresses:\n");
+	pr_debug("final section addresses:\n");
 	for (i = 0; i < hdr->e_shnum; i++) {
 		void *dest;
 
@@ -1923,7 +1917,7 @@ static struct module *load_module(void __user *umod,
 			       sechdrs[i].sh_size);
 		/* Update sh_addr to point to copy in image. */
 		sechdrs[i].sh_addr = (unsigned long)dest;
-		DEBUGP("\t0x%lx %s\n", sechdrs[i].sh_addr, secstrings + sechdrs[i].sh_name);
+		pr_debug("\t0x%lx %s\n", sechdrs[i].sh_addr, secstrings + sechdrs[i].sh_name);
 	}
 	/* Module has been moved. */
 	mod = (void *)sechdrs[modindex].sh_addr;
-- 
1.5.4.5

