Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZA1Ngb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZA1Ngb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZA1Nfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:35:48 -0500
Received: from ozlabs.org ([203.10.76.45]:55190 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbZA1Nfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:35:47 -0500
To: linux-kernel@vger.kernel.org
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 29 Jan 2009 00:05:39 +1030
CC: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 3/6] module: assume first entry in __versions is the layout.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901290005.39407.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This has always been true, but by insisting on it we can avoid
examining the string associated with the symbol name.  This is
important once we change that string to be a pointer, which will need
relocation.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c       |   24 +++++++++++++++++++++++-
 scripts/mod/modpost.c |    6 +++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1022,10 +1022,32 @@ static inline int check_modstruct_versio
 					  struct module *mod)
 {
 	const unsigned long *crc;
+	unsigned int num_versions;
+	struct modversion_info *versions;
 
 	if (IS_ERR_VALUE(find_symbol("module_layout", NULL, &crc, true, false)))
 		BUG();
-	return check_version(sechdrs, versindex, "module_layout", mod, crc);
+
+	/* First symbol is the module_layout version.  This means we
+	 * can check it before relocations are performed (since we
+	 * don't need to look at the name field). */
+
+	/* No versions at all?  modprobe --force does this. */
+	if (versindex == 0)
+		return !try_to_force_load(mod, "no version for module_layout");
+
+	if (sechdrs[versindex].sh_size < sizeof(*versions)) {
+		printk(KERN_WARN "%s: bad __versions section size\n",
+		       mod->name);
+		return 0;
+	}
+
+	versions = (void *)sechdrs[versindex].sh_addr;
+	if (versions->crc == *crc)
+		return 1;
+	printk(KERN_WARNING "%s: disagrees about version of module_layout\n",
+	       mod->name);
+	return 0;
 }
 
 /* First part is kernel version, which we ignore if module has crcs. */
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -14,6 +14,7 @@
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <ctype.h>
+#include <assert.h>
 #include "modpost.h"
 #include "../../include/linux/license.h"
 
@@ -1607,7 +1608,7 @@ static void read_symbols(char *modname)
 	/* Our trick to get versioning for module struct etc. - it's
 	 * never passed as an argument to an exported function, so
 	 * the automatic versioning doesn't pick it up, but it's really
-	 * important anyhow */
+	 * important anyhow.  This has to be the first symbol (last added)! */
 	if (modversions)
 		mod->unres = alloc_symbol("module_layout", 0, mod->unres);
 }
@@ -1769,6 +1770,9 @@ static int add_versions(struct buffer *b
 	buf_printf(b, "static const struct modversion_info ____versions[]\n");
 	buf_printf(b, "__used\n");
 	buf_printf(b, "__attribute__((section(\"__versions\"))) = {\n");
+
+	/* First symbol must be module layout: loader relies on it. */
+	assert(strcmp(mod->unres->name, "module_layout") == 0);
 
 	for (s = mod->unres; s; s = s->next) {
 		if (!s->module)

