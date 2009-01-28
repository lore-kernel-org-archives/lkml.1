Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbZA1NgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbZA1NgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZA1Nfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:35:45 -0500
Received: from ozlabs.org ([203.10.76.45]:55189 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbZA1Nfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:35:44 -0500
To: linux-kernel@vger.kernel.org
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 29 Jan 2009 00:05:35 +1030
CC: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 2/6] module: include struct modversion_info in module version check
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901290005.35801.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With CONFIG_MODVERSIONS, we version 'struct module' using a dummy
export, but other things matter too: we are about to change 'struct
modversion_info' which means the layout of the __versions section
would change, and this should be reflected in modversions.

So we rename 'struct_module' to 'module_layout' and include the
'struct modversion_info' in the signature.  Now it's general we can
add others later on without confusion.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c       |   11 ++++++-----
 scripts/mod/modpost.c |    4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1023,9 +1023,9 @@ static inline int check_modstruct_versio
 {
 	const unsigned long *crc;
 
-	if (IS_ERR_VALUE(find_symbol("struct_module", NULL, &crc, true, false)))
+	if (IS_ERR_VALUE(find_symbol("module_layout", NULL, &crc, true, false)))
 		BUG();
-	return check_version(sechdrs, versindex, "struct_module", mod, crc);
+	return check_version(sechdrs, versindex, "module_layout", mod, crc);
 }
 
 /* First part is kernel version, which we ignore if module has crcs. */
@@ -2778,9 +2778,10 @@ void print_modules(void)
 }
 
 #ifdef CONFIG_MODVERSIONS
-/* Generate the signature for struct module here, too, for modversions. */
-void struct_module(struct module *mod) { return; }
-EXPORT_SYMBOL(struct_module);
+/* Generate the signature for module structures here, too, for modversions.
+ * If these change, we don't want to try to parse the module. */
+void module_layout(struct module *mod, struct modversion_info *ver) { return; }
+EXPORT_SYMBOL(module_layout);
 #endif
 
 #ifdef CONFIG_MARKERS
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1604,12 +1604,12 @@ static void read_symbols(char *modname)
 
 	parse_elf_finish(&info);
 
-	/* Our trick to get versioning for struct_module - it's
+	/* Our trick to get versioning for module struct etc. - it's
 	 * never passed as an argument to an exported function, so
 	 * the automatic versioning doesn't pick it up, but it's really
 	 * important anyhow */
 	if (modversions)
-		mod->unres = alloc_symbol("struct_module", 0, mod->unres);
+		mod->unres = alloc_symbol("module_layout", 0, mod->unres);
 }
 
 #define SZ 500

