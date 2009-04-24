Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbZDXOnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbZDXOnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbZDXOnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:43:31 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:36951 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbZDXOna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:43:30 -0400
Date: Fri, 24 Apr 2009 18:43:27 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: exception table sorting
Message-ID: <20090424144327.GB32087@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exception fixups for sections other than .text (like one in
futex_init()) break the natural ordering of fixup entries,
so sorting is required.

Without that the result of the exception table search depends
on phase of the moon.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/include/asm/uaccess.h |    2 +
 arch/alpha/mm/extable.c          |   40 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/include/asm/uaccess.h b/arch/alpha/include/asm/uaccess.h
index 163f305..b49ec2f 100644
--- a/arch/alpha/include/asm/uaccess.h
+++ b/arch/alpha/include/asm/uaccess.h
@@ -507,5 +507,7 @@ struct exception_table_entry
 	(pc) + (_fixup)->fixup.bits.nextinsn;			\
 })
 
+#define ARCH_HAS_SORT_EXTABLE
+#define ARCH_HAS_SEARCH_EXTABLE
 
 #endif /* __ALPHA_UACCESS_H */
diff --git a/arch/alpha/mm/extable.c b/arch/alpha/mm/extable.c
index dc7aeda..62dc379 100644
--- a/arch/alpha/mm/extable.c
+++ b/arch/alpha/mm/extable.c
@@ -3,11 +3,49 @@
  */
 
 #include <linux/module.h>
+#include <linux/sort.h>
 #include <asm/uaccess.h>
 
+static inline unsigned long ex_to_addr(const struct exception_table_entry *x)
+{
+	return (unsigned long)&x->insn + x->insn;
+}
+
+static void swap_ex(void *a, void *b, int size)
+{
+	struct exception_table_entry *ex_a = a, *ex_b = b;
+	unsigned long addr_a = ex_to_addr(ex_a), addr_b = ex_to_addr(ex_b);
+	unsigned int t = ex_a->fixup.unit;
+
+	ex_a->fixup.unit = ex_b->fixup.unit;
+	ex_b->fixup.unit = t;
+	ex_a->insn = (int)(addr_b - (unsigned long)&ex_a->insn);
+	ex_b->insn = (int)(addr_a - (unsigned long)&ex_b->insn);
+}
+
+/*
+ * The exception table needs to be sorted so that the binary
+ * search that we use to find entries in it works properly.
+ * This is used both for the kernel exception table and for
+ * the exception tables of modules that get loaded.
+ */
+static int cmp_ex(const void *a, const void *b)
+{
+	const struct exception_table_entry *x = a, *y = b;
+
+	/* avoid overflow */
+	if (ex_to_addr(x) > ex_to_addr(y))
+		return 1;
+	if (ex_to_addr(x) < ex_to_addr(y))
+		return -1;
+	return 0;
+}
+
 void sort_extable(struct exception_table_entry *start,
 		  struct exception_table_entry *finish)
 {
+	sort(start, finish - start, sizeof(struct exception_table_entry),
+	     cmp_ex, swap_ex);
 }
 
 const struct exception_table_entry *
@@ -20,7 +58,7 @@ search_extable(const struct exception_table_entry *first,
 		unsigned long mid_value;
 
 		mid = (last - first) / 2 + first;
-		mid_value = (unsigned long)&mid->insn + mid->insn;
+		mid_value = ex_to_addr(mid);
                 if (mid_value == value)
                         return mid;
                 else if (mid_value < value)
