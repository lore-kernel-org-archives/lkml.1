Return-Path: <linux-kernel-owner+w=401wt.eu-S1751901AbYCMJDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbYCMJDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 05:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYCMJDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 05:03:38 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:26147
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbYCMJDh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 05:03:37 -0400
Message-Id: <47D8FC21.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Thu, 13 Mar 2008 09:04:17 +0000
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
 kernel/module.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- linux-2.6.25-rc5/kernel/module.c	2008-03-10 13:24:35.000000000 +0100
+++ 2.6.25-rc5-verify-export-symbols/kernel/module.c	2008-03-04 11:23:05.000000000 +0100
@@ -1383,33 +1383,32 @@ EXPORT_SYMBOL_GPL(__symbol_get);
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
-		if (!IS_ERR_VALUE(__find_symbol(mod->syms[i].name,
-							&owner, &crc, 1))) {
-			name = mod->syms[i].name;
-			ret = -ENOEXEC;
-			goto dup;
-		}
+#define VERIFY(syms) \
+	for (i = 0; i < mod->num_##syms; i++) { \
+		name = mod->syms[i].name; \
+		if (!IS_ERR_VALUE(__find_symbol(name, &owner, &crc, 1))) \
+			goto dup; \
+	}
 
-	for (i = 0; i < mod->num_gpl_syms; i++)
-		if (!IS_ERR_VALUE(__find_symbol(mod->gpl_syms[i].name,
-							&owner, &crc, 1))) {
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
+		mod->name, name, module_name(owner));
 
-	return ret;
+	return -ENOEXEC;
 }
 
 /* Change all symbols so that st_value encodes the pointer directly. */



