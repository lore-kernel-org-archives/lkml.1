Return-Path: <linux-kernel-owner+w=401wt.eu-S1752309AbZIWR3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbZIWR3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZIWR3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:29:42 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:44945 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbZIWR3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:29:41 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rusty@rustcorp.com.au, linux-kbuild@vger.kernel.org,
       linux-modules@vger.kernel.org, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 1/2] lib: Add generic binary search function to the kernel.
Date: Wed, 23 Sep 2009 13:28:45 -0400
Message-Id: <1253726926-5504-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253626718-18887-5-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1253626718-18887-5-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There a large number hand-coded binary searches in the kernel (run
"git grep search | grep binary" to find many of them).  Since in my
experience, hand-coding binary searches can be error-prone, it seems
worth cleaning this up by providing a generic binary search function.

This generic binary search implementation comes from Ksplice.  It has
the same basic API as the C library bsearch() function.  Ksplice uses
it in half a dozen places with 4 different comparison functions, and I
think our code is substantially cleaner because of this.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 include/linux/bsearch.h |    9 ++++++++
 lib/Makefile            |    2 +-
 lib/bsearch.c           |   53 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/bsearch.h
 create mode 100644 lib/bsearch.c

diff --git a/include/linux/bsearch.h b/include/linux/bsearch.h
new file mode 100644
index 0000000..90b1aa8
--- /dev/null
+++ b/include/linux/bsearch.h
@@ -0,0 +1,9 @@
+#ifndef _LINUX_BSEARCH_H
+#define _LINUX_BSEARCH_H
+
+#include <linux/types.h>
+
+void *bsearch(const void *key, const void *base, size_t num, size_t size,
+	      int (*cmp)(const void *key, const void *elt));
+
+#endif /* _LINUX_BSEARCH_H */
diff --git a/lib/Makefile b/lib/Makefile
index 2e78277..fb60af1 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o
+	 string_helpers.o gcd.o bsearch.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/bsearch.c b/lib/bsearch.c
new file mode 100644
index 0000000..4297c98
--- /dev/null
+++ b/lib/bsearch.c
@@ -0,0 +1,53 @@
+/*
+ * A generic implementation of binary search for the Linux kernel
+ *
+ * Copyright (C) 2008-2009 Ksplice, Inc.
+ * Author: Tim Abbott <tabbott@ksplice.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2.
+ */
+
+#include <linux/module.h>
+#include <linux/bsearch.h>
+
+/*
+ * bsearch - binary search an array of elements
+ * @key: pointer to item being searched for
+ * @base: pointer to data to sort
+ * @num: number of elements
+ * @size: size of each element
+ * @cmp: pointer to comparison function
+ *
+ * This function does a binary search on the given array.  The
+ * contents of the array should already be in ascending sorted order
+ * under the provided comparison function.
+ *
+ * Note that the key need not have the same type as the elements in
+ * the array, e.g. key could be a string and the comparison function
+ * could compare the string with the struct's name field.  However, if
+ * the key and elements in the array are of the same type, you can use
+ * the same comparison function for both sort() and bsearch().
+ */
+void *bsearch(const void *key, const void *base, size_t num, size_t size,
+	      int (*cmp)(const void *key, const void *elt))
+{
+	int start = 0, end = num - 1, mid, result;
+	if (num == 0)
+		return NULL;
+
+	while (start <= end) {
+		mid = (start + end) / 2;
+		result = cmp(key, base + mid * size);
+		if (result < 0)
+			end = mid - 1;
+		else if (result > 0)
+			start = mid + 1;
+		else
+			return (void *)base + mid * size;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(bsearch);
-- 
1.6.3.3

