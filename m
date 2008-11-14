Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYKNX0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYKNX0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbYKNX0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:26:04 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42269 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755592AbYKNX0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:26:03 -0500
Date: Fri, 14 Nov 2008 18:25:58 -0500 (EST)
From: Tim Abbott <tabbott@MIT.EDU>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Compare symbol values when marking symbols as exported in
 /proc/kallsyms.
Message-ID: <alpine.DEB.2.00.0811141508350.15564@vinegar-pot.mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there are two symbols in a module with the same name, one of
which is exported, both will be marked as exported in /proc/kallsyms.
There aren't any instances of this in the current kernel, but it is
easy to construct a simple module with two compilation units that
exhibits the problem.

$ objdump -j .text -t testmod.ko | grep foo
00000000 l     F .text	00000032 foo
00000080 g     F .text	00000001 foo
$ sudo insmod testmod.ko
$ grep "T foo" /proc/kallsyms
c28e8000 T foo	[testmod]
c28e8080 T foo	[testmod]

Fix this by comparing the symbol values once we've found the exported
symbol table entry matching the symbol name.  Tested using Ksplice:

$ ksplice-create --patch=this_commit.patch --id=bar .
$ sudo ksplice-apply ksplice-bar.tar.gz
Done!
$ grep "T foo" /proc/kallsyms
c28e8080 T foo	[testmod]

Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 kernel/module.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1f4cc00..689222b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1725,15 +1725,15 @@ static const struct kernel_symbol *lookup_symbol(const char *name,
 	return NULL;
 }

-static int is_exported(const char *name, const struct module *mod)
+static int is_exported(const char *name, unsigned long value,
+		       const struct module *mod)
 {
-	if (!mod && lookup_symbol(name, __start___ksymtab, __stop___ksymtab))
-		return 1;
+	const struct kernel_symbol *ks;
+	if (!mod)
+		ks = lookup_symbol(name, __start___ksymtab, __stop___ksymtab);
 	else
-		if (mod && lookup_symbol(name, mod->syms, mod->syms + mod->num_syms))
-			return 1;
-		else
-			return 0;
+		ks = lookup_symbol(name, mod->syms, mod->syms + mod->num_syms);
+	return ks != NULL && ks->value == value;
 }

 /* As per nm */
@@ -2513,7 +2513,7 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 			strlcpy(name, mod->strtab + mod->symtab[symnum].st_name,
 				KSYM_NAME_LEN);
 			strlcpy(module_name, mod->name, MODULE_NAME_LEN);
-			*exported = is_exported(name, mod);
+			*exported = is_exported(name, *value, mod);
 			preempt_enable();
 			return 0;
 		}
-- 
1.5.6.5
