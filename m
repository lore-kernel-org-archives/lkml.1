Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbZKGVE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbZKGVE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZKGVEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:04:52 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:39964 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZKGVEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:04:24 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 10/10] module: fix is_exported() to return true for all types of exports
Date: Sat,  7 Nov 2009 21:04:01 +0000
Message-Id: <1257627841-15817-10-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <4AF5DF9F.5020208@tuffmail.co.uk>
References: <4AF5DF9F.5020208@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/kallsyms annotates module symbols as global (e.g. 'D' for a data
symbol) or local (e.g. 'd'), depending on whether is_exported() returns
true or false.

Historically, is_exported() only returns true if the symbol was exported
using EXPORT_SYMBOL(). EXPORT_SYMBOL_UNUSED(), for example, is not taken
into account. This looks like an oversight, so let's fix it.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 kernel/module.c |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 56a7e65..021b9cc 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1830,33 +1830,19 @@ static void free_modinfo(struct module *mod)
 
 #ifdef CONFIG_KALLSYMS
 
-/* lookup symbol in given range of kernel_symbols */
-static const struct kernel_symbol *lookup_symbol(const char *name,
-	const struct kernel_symbol *syms,
-	unsigned int count)
-{
-	unsigned int i;
-
-	for (i = 0; i < count; i++)
-		if (strcmp(syms[i].name, name) == 0)
-			return &syms[i];
-	return NULL;
-}
-
 static int is_exported(const char *name, unsigned long value,
-		       const struct module *mod)
+		       struct module *mod)
 {
-	const struct ksymtab *symtab;
-	const struct kernel_symbol *ks;
+	const struct kernel_symbol *sym;
+	enum export_type type;
+	const unsigned long *crc;
 
-	if (!mod)
-		symtab = &ksymtab[EXPORT_TYPE_PLAIN];
+	if (mod)
+		sym = find_symbol_in_module(mod, name, &type, &crc);
 	else
-		symtab = &mod->syms[EXPORT_TYPE_PLAIN];
-
-	ks = lookup_symbol(name, symtab->syms, symtab->num_syms);
+		sym = find_symbol_in_kernel(name, &type, &crc);
 
-	return ks != NULL && ks->value == value;
+	return (sym && sym->value == value);
 }
 
 /* As per nm */
-- 
1.6.3.3

