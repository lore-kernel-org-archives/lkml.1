Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbZIWRej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbZIWRej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZIWReh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:34:37 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:47552 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbZIWRee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:34:34 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rusty@rustcorp.com.au, linux-kbuild@vger.kernel.org,
       linux-modules@vger.kernel.org, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 2/2] module: use bsearch in find_symbol_in_kernel_section.
Date: Wed, 23 Sep 2009 13:28:46 -0400
Message-Id: <1253726926-5504-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253626718-18887-5-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1253626718-18887-5-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 kernel/module.c |   34 +++++++++++++++-------------------
 1 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 9b19f23..25ff16b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -55,6 +55,7 @@
 #include <linux/async.h>
 #include <linux/percpu.h>
 #include <linux/kmemleak.h>
+#include <linux/bsearch.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -209,31 +210,26 @@ struct symsearch {
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
-/* binary search on sorted symbols */
+static int symbol_compare(const void *key, const void *elt)
+{
+	const char *str = key;
+	const struct kernel_symbol *sym = elt;
+	return strcmp(sym->name, str);
+}
+
 static bool find_symbol_in_kernel_section(const struct symsearch *syms,
 					  const char *name,
 					  unsigned int *symnum)
 {
-	int lo = 0, hi = syms->stop - syms->start - 1;
-	int mid, cmp;
-
-	while (lo <= hi) {
-		mid = (lo + hi) / 2;
-		cmp = strcmp(syms->start[mid].name, name);
-		if (cmp == 0) {
-			*symnum = mid;
-			return true;
-		}
-		else if (cmp < 0)
-			hi = mid - 1;
-		else
-			lo = mid + 1;
-	}
-
-	return false;
+	const struct kernel_symbol *sym =
+	    bsearch(name, syms->start, syms->stop - syms->start,
+		    sizeof(*syms->start), symbol_compare);
+	if (sym == NULL)
+		return false;
+	*symnum = sym - syms->start;
+	return true;
 }
 
-
 static bool find_symbol_in_kernel(const char *name,
 				  struct symsearch *sym,
 				  unsigned int *symnum)
-- 
1.6.3.3

