Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbZIVNjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbZIVNjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbZIVNiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:38:55 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:47061 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbZIVNiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:38:52 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-modules@vger.org, Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 3/4] module: unexport each_symbol()
Date: Tue, 22 Sep 2009 14:38:37 +0100
Message-Id: <1253626718-18887-4-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_symbol() is about to be re-written to avoid traversing every single
exported symbol.  each_symbol() has acquired no other in-tree user, so
let us remove it.

Also struct symsearch is useless outside of module.c, so move it there
instead of cluttering up module.h.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 include/linux/module.h |   15 ---------------
 kernel/module.c        |   14 ++++++++++++--
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 65b62e9..df25f99 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -348,17 +348,6 @@ static inline int within_module_init(unsigned long addr, struct module *mod)
 /* Search for module by name: must hold module_mutex. */
 struct module *find_module(const char *name);
 
-struct symsearch {
-	const struct kernel_symbol *start, *stop;
-	const unsigned long *crcs;
-	enum {
-		NOT_GPL_ONLY,
-		GPL_ONLY,
-		WILL_BE_GPL_ONLY,
-	} licence;
-	bool unused;
-};
-
 /* Search for an exported symbol by name. */
 const struct kernel_symbol *find_symbol(const char *name,
 					struct module **owner,
@@ -366,10 +355,6 @@ const struct kernel_symbol *find_symbol(const char *name,
 					bool gplok,
 					bool warn);
 
-/* Walk the exported symbol table */
-bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
-			    unsigned int symnum, void *data), void *data);
-
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
 int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
diff --git a/kernel/module.c b/kernel/module.c
index 2d53718..b24fc55 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -186,6 +186,17 @@ extern const unsigned long __start___kcrctab_unused[];
 extern const unsigned long __start___kcrctab_unused_gpl[];
 #endif
 
+struct symsearch {
+	const struct kernel_symbol *start, *stop;
+	const unsigned long *crcs;
+	enum {
+		NOT_GPL_ONLY,
+		GPL_ONLY,
+		WILL_BE_GPL_ONLY,
+	} licence;
+	bool unused;
+};
+
 #ifndef CONFIG_MODVERSIONS
 #define symversion(base, idx) NULL
 #else
@@ -212,7 +223,7 @@ static bool each_symbol_in_section(const struct symsearch *arr,
 }
 
 /* Returns true as soon as fn returns true, otherwise false. */
-bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
+static bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
 			    unsigned int symnum, void *data), void *data)
 {
 	struct module *mod;
@@ -266,7 +277,6 @@ bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
 	}
 	return false;
 }
-EXPORT_SYMBOL_GPL(each_symbol);
 
 struct find_symbol_arg {
 	/* Input */
-- 
1.6.3.2

