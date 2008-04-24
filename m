Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbYDXFCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbYDXFCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 01:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbYDXFBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 01:01:41 -0400
Received: from ozlabs.org ([203.10.76.45]:37186 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201AbYDXFBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 01:01:39 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 24 Apr 2008 00:01:30 -0500
Subject: [PATCH 5/6] module: Enhance verify_export_symbols
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241501.30180.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make verify_export_symbols check the modules unused, unused_gpl and
gpl_future syms.

Inspired by Jan Beulich's fix, but table-driven.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |   48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff -r 08e60e418777 kernel/module.c
--- a/kernel/module.c	Tue Mar 18 11:30:06 2008 +1100
+++ b/kernel/module.c	Tue Mar 18 14:05:37 2008 +1100
@@ -1397,33 +1397,33 @@ EXPORT_SYMBOL_GPL(__symbol_get);
  */
 static int verify_export_symbols(struct module *mod)
 {
-	const char *name = NULL;
-	unsigned long i, ret = 0;
+	unsigned int i;
 	struct module *owner;
-	const unsigned long *crc;
+	const struct kernel_symbol *s;
+	struct {
+		const struct kernel_symbol *sym;
+		unsigned int num;
+	} arr[] = {
+		{ mod->syms, mod->num_syms },
+		{ mod->gpl_syms, mod->num_gpl_syms },
+		{ mod->gpl_future_syms, mod->num_gpl_future_syms },
+		{ mod->unused_syms, mod->num_unused_syms },
+		{ mod->unused_gpl_syms, mod->num_unused_gpl_syms },
+	};
 
-	for (i = 0; i < mod->num_syms; i++)
-		if (!IS_ERR_VALUE(find_symbol(mod->syms[i].name,
-					      &owner, &crc, true, false))) {
-			name = mod->syms[i].name;
-			ret = -ENOEXEC;
-			goto dup;
+	for (i = 0; i < ARRAY_SIZE(arr); i++) {
+		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
+			if (!IS_ERR_VALUE(find_symbol(s->name, &owner,
+						      NULL, true, false))) {
+				printk(KERN_ERR
+				       "%s: exports duplicate symbol %s"
+				       " (owned by %s)\n",
+				       mod->name, s->name, module_name(owner));
+				return -ENOEXEC;
+			}
 		}
-
-	for (i = 0; i < mod->num_gpl_syms; i++)
-		if (!IS_ERR_VALUE(find_symbol(mod->gpl_syms[i].name,
-					      &owner, &crc, true, false))) {
-			name = mod->gpl_syms[i].name;
-			ret = -ENOEXEC;
-			goto dup;
-		}
-
-dup:
-	if (ret)
-		printk(KERN_ERR "%s: exports duplicate symbol %s (owned by %s)\n",
-			mod->name, name, module_name(owner));
-
-	return ret;
+	}
+	return 0;
 }
 
 /* Change all symbols so that st_value encodes the pointer directly. */

