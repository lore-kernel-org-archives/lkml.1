Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYILL6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYILL6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 07:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYILL5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 07:57:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62229 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbYILL5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:57:54 -0400
Message-ID: <48CA58A4.8020902@cn.fujitsu.com>
Date: Fri, 12 Sep 2008 19:55:16 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 1/2] sort: Add obj_sort() for sorting all kinds of random-accessible
 objects
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


current sort can only sort objects on continuous memory,
but sometimes we need to sort objects on noncontinuous memory,
this patch provide obj_sort() for this.

Sometimes a C struct(the container of objects, or objects) may be designed
with some high-level language's semantic meaning. obj_sort() can sort
for them.

obj_sort() is need for sort pids for cgroup.tasks file.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/sort.h b/include/linux/sort.h
index d534da2..d1e2f71 100644
--- a/include/linux/sort.h
+++ b/include/linux/sort.h
@@ -7,4 +7,8 @@ void sort(void *base, size_t num, size_t size,
 	  int (*cmp)(const void *, const void *),
 	  void (*swap)(void *, void *, int));
 
+void obj_sort(void *container, size_t begin, size_t end,
+		int (*cmp)(const void *container, size_t left, size_t right),
+		void (*swap)(void *container, size_t left, size_t right));
+
 #endif
diff --git a/lib/sort.c b/lib/sort.c
index 6abbaf3..d0c80ce 100644
--- a/lib/sort.c
+++ b/lib/sort.c
@@ -2,6 +2,9 @@
  * A fast, small, non-recursive O(nlog n) sort for the Linux kernel
  *
  * Jan 23 2005  Matt Mackall <mpm@selenic.com>
+ *
+ * Sep 12 2008  Lai Jiangshan <laijs@cn.fujitsu.com>
+ *       Add obj_sort for sorting all kinds of random-accessible objects.
  */
 
 #include <linux/kernel.h>
@@ -56,7 +59,7 @@ void sort(void *base, size_t num, size_t size,
 
 	/* heapify */
 	for ( ; i >= 0; i -= size) {
-		for (r = i; r * 2 + size < n; r  = c) {
+		for (r = i; r * 2 + size < n; r = c) {
 			c = r * 2 + size;
 			if (c < n - size && cmp(base + c, base + c + size) < 0)
 				c += size;
@@ -82,6 +85,63 @@ void sort(void *base, size_t num, size_t size,
 
 EXPORT_SYMBOL(sort);
 
+/**
+ * obj_sort - sort objects of an random-accessible objects container
+ * @container: pointer to container of objects.
+ * @begin: begin pos for sort
+ * @end: end pos for sort
+ * @cmp: pointer to comparison function
+ * @swap: pointer to swap function
+ *
+ * This function does a heapsort on the given random-accessible
+ * objects container.
+ * Sort the region [begin, end) of the container.
+ *
+ * sort() is recommended for sorting objects on continuous memory
+ * for performance(sort an array, etc).
+ *
+ * Sorting time is O(n log n) both on average and worst-case. While
+ * qsort is about 20% faster on average, it suffers from exploitable
+ * O(n*n) worst-case behavior and extra memory requirements that make
+ * it less suitable for kernel use.
+ */
+
+void obj_sort(void *container, size_t begin, size_t end,
+		int (*cmp)(const void *container, size_t left, size_t right),
+		void (*swap)(void *container, size_t left, size_t right))
+{
+	ssize_t i, c, r, n = end - begin;
+
+	/* heapify */
+	for (i = n/2 - 1; i >= 0; i--) {
+		for (r = i; r * 2 + 1 < n; r = c) {
+			c = r * 2 + 1;
+			if (c < n - 1 && cmp(container, begin + c,
+					begin + c + 1) < 0)
+				c++;
+			if (cmp(container, begin + r, begin + c) >= 0)
+				break;
+			swap(container, begin + r, begin + c);
+		}
+	}
+
+	/* sort */
+	for (i = n - 1; i > 0; i--) {
+		swap(container, begin, begin + i);
+		for (r = 0; r * 2 + 1 < i; r = c) {
+			c = r * 2 + 1;
+			if (c < i - 1 && cmp(container, begin + c,
+					begin + c + 1) < 0)
+				c++;
+			if (cmp(container, begin + r, begin + c) >= 0)
+				break;
+			swap(container, begin + r, begin + c);
+		}
+	}
+}
+
+EXPORT_SYMBOL(obj_sort);
+
 #if 0
 /* a simple boot-time regression test */
 


