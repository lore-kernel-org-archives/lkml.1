Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZHQUny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZHQUny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbZHQUnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:43:53 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46003 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbZHQUnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:43:52 -0400
Subject: [RFC][PATCH] flex_array: conditionally optimize out divides
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 17 Aug 2009 13:43:51 -0700
Message-Id: <20090817204351.EEE0DDDB@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are three flex_array operations that require divides:
1. figuring out into which "part" we should access
2. figuring out where into that part we fit
3. figuring out in how many elements fit into a part

Division can get expensive, and we may incur one or two
divides for each put() or get() that is performed.  If we
rounded the elements to a power-of-two and stored shifts
and masks, we could rid ourselves of the divides, but we
would lose storage space with oddly-sized objects.  We
could code the implementation to handle divides and special-
case the shifts when they can be used, but that would
complicate the code.

This is an alternative.  We introduce variants of
flex_array_get() and flex_array_put() since they are the
most common operations.  We append an _es() to their names
(for Element Size) and get flex_array_get_es() and
flex_array_put_es().  The allocation and free functions
remain unoptimized since they're not indended to be hot
paths.

Passing the element size into each operation, and using it
like this:

	flex_array_get(fa, nr, sizeof(struct my_struct));

lets the compiler turn the divides into shifts if 'my_struct'
is a power-of-two in size.

It seems that only gcc 4.1 and up are smart enough to figure
this out, though.

---

 linux-2.6.git-dave/include/linux/flex_array.h |   54 ++++++++++++++++++++++++++
 linux-2.6.git-dave/lib/flex_array.c           |   52 +++++++++++++------------
 2 files changed, 82 insertions(+), 24 deletions(-)

diff -puN include/linux/flex_array.h~precalc include/linux/flex_array.h
--- linux-2.6.git/include/linux/flex_array.h~precalc	2009-08-17 13:13:21.000000000 -0700
+++ linux-2.6.git-dave/include/linux/flex_array.h	2009-08-17 13:34:45.000000000 -0700
@@ -1,6 +1,7 @@
 #ifndef _FLEX_ARRAY_H
 #define _FLEX_ARRAY_H
 
+#include <linux/errno.h>
 #include <linux/types.h>
 #include <asm/page.h>
 
@@ -36,6 +37,59 @@ struct flex_array {
 	.total_nr_elements = (total),	\
 } } }
 
+/*
+ * The 'unsigned' here seems to make gcc more happy
+ * to optimize the divide.
+ */
+static inline unsigned int __elements_per_part(int element_size)
+{
+	return FLEX_ARRAY_PART_SIZE / element_size;
+}
+
+static inline int __fa_element_to_part_nr(int element_size, int element_nr)
+{
+	return element_nr / __elements_per_part(element_size);
+}
+
+static inline int __fa_index_inside_part(int element_size, int element_nr)
+{
+	return element_nr % __elements_per_part(element_size);
+}
+
+int flex_array_put_precalc(struct flex_array *fa, int part_nr,
+			   int index_inside_part, void *src, gfp_t flags);
+void *flex_array_get_precalc(struct flex_array *fa, int part_nr,
+			     int index_inside_part);
+
+/*
+ * Use the _es() variants when you want the compiler to
+ * be able to optimize the divides like when you have a
+ * power-of-two element_size.
+ */
+static inline void *flex_array_get_es(struct flex_array *fa,
+		int element_nr, int element_size)
+{
+	int part_nr = __fa_element_to_part_nr(element_size, element_nr);
+	int index_inside = __fa_index_inside_part(element_size, element_nr);
+
+	if (element_nr >= fa->total_nr_elements)
+		return NULL;
+
+	return flex_array_get_precalc(fa, part_nr, index_inside);
+}
+
+static inline int flex_array_put_es(struct flex_array *fa, int element_nr,
+		int element_size, void *src, gfp_t flags)
+{
+	int part_nr = __fa_element_to_part_nr(element_size, element_nr);
+	int index_inside = __fa_index_inside_part(element_size, element_nr);
+
+	if (element_nr >= fa->total_nr_elements)
+		return -ENOSPC;
+
+	return flex_array_put_precalc(fa, part_nr, index_inside, src, flags);
+}
+
 struct flex_array *flex_array_alloc(int element_size, int total, gfp_t flags);
 int flex_array_prealloc(struct flex_array *fa, int start, int end, gfp_t flags);
 void flex_array_free(struct flex_array *fa);
diff -puN lib/flex_array.c~precalc lib/flex_array.c
--- linux-2.6.git/lib/flex_array.c~precalc	2009-08-17 13:13:21.000000000 -0700
+++ linux-2.6.git-dave/lib/flex_array.c	2009-08-17 13:41:24.000000000 -0700
@@ -28,11 +28,6 @@ struct flex_array_part {
 	char elements[FLEX_ARRAY_PART_SIZE];
 };
 
-static inline int __elements_per_part(int element_size)
-{
-	return FLEX_ARRAY_PART_SIZE / element_size;
-}
-
 static inline int bytes_left_in_base(void)
 {
 	int element_offset = offsetof(struct flex_array, parts);
@@ -115,11 +110,6 @@ struct flex_array *flex_array_alloc(int 
 	return ret;
 }
 
-static int fa_element_to_part_nr(struct flex_array *fa, int element_nr)
-{
-	return element_nr / __elements_per_part(fa->element_size);
-}
-
 /**
  * flex_array_free_parts - just free the second-level pages
  * @src:	address of data to copy into the array
@@ -151,12 +141,6 @@ static int fa_index_inside_part(struct f
 	return element_nr % __elements_per_part(fa->element_size);
 }
 
-static int index_inside_part(struct flex_array *fa, int element_nr)
-{
-	int part_offset = fa_index_inside_part(fa, element_nr);
-	return part_offset * fa->element_size;
-}
-
 static struct flex_array_part *
 __fa_get_part(struct flex_array *fa, int part_nr, gfp_t flags)
 {
@@ -176,6 +160,12 @@ __fa_get_part(struct flex_array *fa, int
 	return part;
 }
 
+
+static int fa_element_to_part_nr(struct flex_array *fa, int element_nr)
+{
+	return __fa_element_to_part_nr(fa->element_size, element_nr);
+}
+
 /**
  * flex_array_put - copy data into the array at @element_nr
  * @src:	address of data to copy into the array
@@ -186,23 +176,30 @@ __fa_get_part(struct flex_array *fa, int
  * the array.  If you are trying to store an array of
  * pointers, make sure to pass in &ptr instead of ptr.
  *
+ * The _es() variant is if you want to pass in the element
+ * size yourself.  This allows the compiler to do some more
+ * optimization and possibly eliminate all the divides.
+ *
  * Locking must be provided by the caller.
  */
 int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags)
 {
-	int part_nr = fa_element_to_part_nr(fa, element_nr);
+	return flex_array_put_es(fa, element_nr, fa->element_size, src, flags);
+}
+
+int flex_array_put_precalc(struct flex_array *fa, int part_nr,
+			   int index_inside_part, void *src, gfp_t flags)
+{
 	struct flex_array_part *part;
 	void *dst;
 
-	if (element_nr >= fa->total_nr_elements)
-		return -ENOSPC;
 	if (elements_fit_in_base(fa))
 		part = (struct flex_array_part *)&fa->parts[0];
 	else
 		part = __fa_get_part(fa, part_nr, flags);
 	if (!part)
 		return -ENOMEM;
-	dst = &part->elements[index_inside_part(fa, element_nr)];
+	dst = &part->elements[index_inside_part];
 	memcpy(dst, src, fa->element_size);
 	return 0;
 }
@@ -248,20 +245,27 @@ int flex_array_prealloc(struct flex_arra
  * that this is a copy of the data that was passed in.  If you
  * are using this to store pointers, you'll get back &ptr.
  *
+ * The _es() variant is if you want to pass in the element
+ * size yourself.  This allows the compiler to do some more
+ * optimization and possibly eliminate all the divides.
+ *
  * Locking must be provided by the caller.
  */
 void *flex_array_get(struct flex_array *fa, int element_nr)
 {
-	int part_nr = fa_element_to_part_nr(fa, element_nr);
+	return flex_array_get_es(fa, element_nr, fa->element_size);
+}
+
+void *flex_array_get_precalc(struct flex_array *fa, int part_nr,
+			     int index_inside_part)
+{
 	struct flex_array_part *part;
 
-	if (element_nr >= fa->total_nr_elements)
-		return NULL;
 	if (!fa->parts[part_nr])
 		return NULL;
 	if (elements_fit_in_base(fa))
 		part = (struct flex_array_part *)&fa->parts[0];
 	else
 		part = fa->parts[part_nr];
-	return &part->elements[index_inside_part(fa, element_nr)];
+	return &part->elements[index_inside_part];
 }
diff -L include/linux/flex_array.hcd -puN /dev/null /dev/null
_
