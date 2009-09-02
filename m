Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbZIBDOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbZIBDOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 23:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZIBDOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 23:14:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15382 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbZIBDOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 23:14:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=sDoxeep/irXwf2O9XG37Zm7wO//Y3kPT3dO7ducqAWw6AIbtSV+TP1fFfYzrZpPLe
	+LH4fP9dssIXxRBBjmdXw==
Date: Tue, 1 Sep 2009 20:14:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/2 -mm] flex_array: introduce DEFINE_FLEX_ARRAY
Message-ID: <alpine.DEB.1.00.0909012013180.13377@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FLEX_ARRAY_INIT(element_size, total_nr_elements) cannot determine if
either parameter is valid, so flex arrays which are statically allocated
with this interface can easily become corrupted or reference beyond its
allocated memory.

This removes FLEX_ARRAY_INIT() as a struct flex_array initializer since
no initializer may perform the required checking.  Instead, the array
is now defined with a new interface:

	DEFINE_FLEX_ARRAY(name, element_size, total_nr_elements)

This may be prefixed with `static' for file scope.

This interface includes compile-time checking of the parameters to
ensure they are valid.  Since the validity of both element_size and
total_nr_elements depend on FLEX_ARRAY_BASE_SIZE and
FLEX_ARRAY_PART_SIZE, the kernel build will fail if either of these
predefined values changes such that the array parameters are no longer
valid.

Since BUILD_BUG_ON() requires compile time constants, several of the
static inline functions that were once local to lib/flex_array.c had to
be moved to include/linux/flex_array.h.

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/flex_array.h |   30 ++++++++++++++++++++++++++----
 lib/flex_array.c           |   36 ++++++++++--------------------------
 2 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
--- a/include/linux/flex_array.h
+++ b/include/linux/flex_array.h
@@ -31,10 +31,32 @@ struct flex_array {
 	};
 };
 
-#define FLEX_ARRAY_INIT(size, total) { { {\
-	.element_size = (size),		\
-	.total_nr_elements = (total),	\
-} } }
+/* Number of bytes left in base struct flex_array, excluding metadata */
+#define FLEX_ARRAY_BASE_BYTES_LEFT					\
+	(FLEX_ARRAY_BASE_SIZE - offsetof(struct flex_array, parts))
+
+/* Number of pointers in base to struct flex_array_part pages */
+#define FLEX_ARRAY_NR_BASE_PTRS						\
+	(FLEX_ARRAY_BASE_BYTES_LEFT / sizeof(struct flex_array_part *))
+
+/* Number of elements of size that fit in struct flex_array_part */
+#define FLEX_ARRAY_ELEMENTS_PER_PART(size)				\
+	(FLEX_ARRAY_PART_SIZE / size)
+
+/*
+ * Defines a statically allocated flex array and ensures its parameters are
+ * valid.
+ */
+#define DEFINE_FLEX_ARRAY(__arrayname, __element_size, __total)		\
+	struct flex_array __arrayname = { { {				\
+		.element_size = (__element_size),			\
+		.total_nr_elements = (__total),				\
+	} } };								\
+	static inline void __arrayname##_invalid_parameter(void)	\
+	{								\
+		BUILD_BUG_ON((__total) > FLEX_ARRAY_NR_BASE_PTRS *	\
+			FLEX_ARRAY_ELEMENTS_PER_PART(__element_size));	\
+	}
 
 struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 		gfp_t flags);
diff --git a/lib/flex_array.c b/lib/flex_array.c
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -28,23 +28,6 @@ struct flex_array_part {
 	char elements[FLEX_ARRAY_PART_SIZE];
 };
 
-static inline int __elements_per_part(int element_size)
-{
-	return FLEX_ARRAY_PART_SIZE / element_size;
-}
-
-static inline int bytes_left_in_base(void)
-{
-	int element_offset = offsetof(struct flex_array, parts);
-	int bytes_left = FLEX_ARRAY_BASE_SIZE - element_offset;
-	return bytes_left;
-}
-
-static inline int nr_base_part_ptrs(void)
-{
-	return bytes_left_in_base() / sizeof(struct flex_array_part *);
-}
-
 /*
  * If a user requests an allocation which is small
  * enough, we may simply use the space in the
@@ -54,7 +37,7 @@ static inline int nr_base_part_ptrs(void)
 static inline int elements_fit_in_base(struct flex_array *fa)
 {
 	int data_size = fa->element_size * fa->total_nr_elements;
-	if (data_size <= bytes_left_in_base())
+	if (data_size <= FLEX_ARRAY_BASE_BYTES_LEFT)
 		return 1;
 	return 0;
 }
@@ -103,7 +86,8 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 					gfp_t flags)
 {
 	struct flex_array *ret;
-	int max_size = nr_base_part_ptrs() * __elements_per_part(element_size);
+	int max_size = FLEX_ARRAY_NR_BASE_PTRS *
+				FLEX_ARRAY_ELEMENTS_PER_PART(element_size);
 
 	/* max_size will end up 0 if element_size > PAGE_SIZE */
 	if (total > max_size)
@@ -114,14 +98,15 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 	ret->element_size = element_size;
 	ret->total_nr_elements = total;
 	if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
-		memset(ret->parts[0], FLEX_ARRAY_FREE, bytes_left_in_base());
+		memset(ret->parts[0], FLEX_ARRAY_FREE,
+						FLEX_ARRAY_BASE_BYTES_LEFT);
 	return ret;
 }
 
 static int fa_element_to_part_nr(struct flex_array *fa,
 					unsigned int element_nr)
 {
-	return element_nr / __elements_per_part(fa->element_size);
+	return element_nr / FLEX_ARRAY_ELEMENTS_PER_PART(fa->element_size);
 }
 
 /**
@@ -133,11 +118,10 @@ static int fa_element_to_part_nr(struct flex_array *fa,
 void flex_array_free_parts(struct flex_array *fa)
 {
 	int part_nr;
-	int max_part = nr_base_part_ptrs();
 
 	if (elements_fit_in_base(fa))
 		return;
-	for (part_nr = 0; part_nr < max_part; part_nr++)
+	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++)
 		kfree(fa->parts[part_nr]);
 }
 
@@ -152,7 +136,8 @@ static unsigned int index_inside_part(struct flex_array *fa,
 {
 	unsigned int part_offset;
 
-	part_offset = element_nr % __elements_per_part(fa->element_size);
+	part_offset = element_nr %
+				FLEX_ARRAY_ELEMENTS_PER_PART(fa->element_size);
 	return part_offset * fa->element_size;
 }
 
@@ -313,13 +298,12 @@ static int part_is_free(struct flex_array_part *part)
 int flex_array_shrink(struct flex_array *fa)
 {
 	struct flex_array_part *part;
-	int max_part = nr_base_part_ptrs();
 	int part_nr;
 	int ret = 0;
 
 	if (elements_fit_in_base(fa))
 		return ret;
-	for (part_nr = 0; part_nr < max_part; part_nr++) {
+	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++) {
 		part = fa->parts[part_nr];
 		if (!part)
 			continue;
