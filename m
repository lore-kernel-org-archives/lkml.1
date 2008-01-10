Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbYAJQhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbYAJQhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbYAJQgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:36:52 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:1067
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbYAJQgw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:36:52 -0500
Message-Id: <478657C8.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 10 Jan 2008 16:37:12 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix verify_export_symbols()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the newer export flavors were added, it was apparently forgotten
to add respective code here.
In order to not double the (source) size of the function, add some
abstraction to reduce code duplication.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
---

 kernel/module.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- linux-2.6.24-rc7/kernel/module.c	2008-01-10 16:50:54.000000000 +0100
+++ 2.6.24-rc7-verify-export-symbols/kernel/module.c	2008-01-08 16:42:35.000000000 +0100
@@ -1344,31 +1344,32 @@ EXPORT_SYMBOL_GPL(__symbol_get);
  */
 static int verify_export_symbols(struct module *mod)
 {
-	const char *name = NULL;
-	unsigned long i, ret = 0;
+	const char *name;
+	unsigned int i;
 	struct module *owner;
 	const unsigned long *crc;
 
-	for (i = 0; i < mod->num_syms; i++)
-		if (__find_symbol(mod->syms[i].name, &owner, &crc, 1)) {
-			name = mod->syms[i].name;
-			ret = -ENOEXEC;
-			goto dup;
-		}
+#define VERIFY(syms) \
+	for (i = 0; i < mod->num_##syms; i++) { \
+		name = mod->syms[i].name; \
+		if (__find_symbol(name, &owner, &crc, 1)) \
+			goto dup; \
+	}
 
-	for (i = 0; i < mod->num_gpl_syms; i++)
-		if (__find_symbol(mod->gpl_syms[i].name, &owner, &crc, 1)) {
-			name = mod->gpl_syms[i].name;
-			ret = -ENOEXEC;
-			goto dup;
-		}
+	VERIFY(syms);
+	VERIFY(gpl_syms);
+	VERIFY(gpl_future_syms);
+	VERIFY(unused_syms);
+	VERIFY(unused_gpl_syms);
+#undef VERIFY
+
+	return 0;
 
 dup:
-	if (ret)
-		printk(KERN_ERR "%s: exports duplicate symbol %s (owned by %s)\n",
-			mod->name, name, module_name(owner));
+	printk(KERN_ERR "%s: exports duplicate symbol %s (owned by %s)\n",
+	       mod->name, name, module_name(owner));
 
-	return ret;
+	return -ENOEXEC;
 }
 
 /* Change all symbols so that st_value encodes the pointer directly. */



