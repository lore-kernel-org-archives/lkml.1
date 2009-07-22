Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZGVRyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZGVRyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZGVRye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:54:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60642 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZGVRyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:54:33 -0400
Subject: [RFC][PATCH] flexible array implementation v3
To: akpm@linux-foundation.org
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       menage@google.com, vda.linux@googlemail.com, mikew@google.com,
       lizf@cn.fujitsu.com, xiyou.wangcong@gmail.com,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 22 Jul 2009 10:53:45 -0700
Message-Id: <20090722175345.7154C2F2@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Changes from v2:
- renamed some of the index functions
- added preallocation function
- added flex_array_free_parts() for use with
  statically allocated bases
- killed append() function

Changes from v1:
- to vs too typo
- added __check_part_and_nr() and gave it a warning
- fixed off-by-one check on __nr_part_ptrs()
- added FLEX_ARRAY_INIT() macro
- some kerneldoc comments about the capacity
  with various sized objects
- comments to note lack of locking semantice

--

Once a structure goes over PAGE_SIZE*2, we see occasional
allocation failures.  Some people have chosen to switch
over to things like vmalloc() that will let them keep
array-like access to such a large structures.  But,
vmalloc() has plenty of downsides.

Here's an alternative.  I think it's what Andrew was
suggesting  here:

	http://lkml.org/lkml/2009/7/2/518 

I call it a flexible array.  It does all of its work in
PAGE_SIZE bits, so never does an order>0 allocation.
The base level has PAGE_SIZE-2*sizeof(int) bytes of
storage for pointers to the second level.  So, with a
32-bit arch, you get about 4MB (4183112 bytes) of total
storage when the objects pack nicely into a page.  It
is half that on 64-bit because the pointers are twice
the size.  There's a table detailing this in the code.

There are kerneldocs for the functions, but here's an
overview:

flex_array_alloc() - dynamically allocate a base structure
flex_array_free() - free the array and all of the
		    second-level pages
flex_array_free_parts() - free the second-level pages, but
			  not the base (for static bases)
flex_array_put() - copy into the array at the given index
flex_array_get() - copy out of the array at the given index
flex_array_prealloc() - preallocate the second-level pages
			between the given indexes to
			guarantee no allocs will occur at
			put() time.

We could also potentially just pass the "element_size"
into each of the API functions instead of storing it
internally.  That would get us one more base pointer
on 64-bit.

The last improvement that I thought about was letting
the individual array members span pages.  In this
implementation, if you have a 2049-byte object, it
will only pack one of them into each "part" with
no attempt to pack them.  At this point, I don't think
the added complexity would be worth it.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/include/linux/flex_array.h |   45 ++++
 linux-2.6.git-dave/lib/Makefile               |    2 
 linux-2.6.git-dave/lib/flex_array.c           |  240 ++++++++++++++++++++++++++
 3 files changed, 286 insertions(+), 1 deletion(-)

diff -puN /dev/null include/linux/flex_array.h
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/include/linux/flex_array.h	2009-07-22 10:52:04.000000000 -0700
@@ -0,0 +1,45 @@
+#ifndef _FLEX_ARRAY_H
+#define _FLEX_ARRAY_H
+
+#include <linux/types.h>
+#include <asm/page.h>
+
+#define FLEX_ARRAY_PART_SIZE PAGE_SIZE
+#define FLEX_ARRAY_BASE_SIZE PAGE_SIZE
+
+struct flex_array_part;
+
+/*
+ * This is meant to replace cases where an array-like
+ * structure has gotten to big too fit into kmalloc()
+ * and the developer is getting tempted to use
+ * vmalloc().
+ */
+
+struct flex_array {
+	union {
+		struct {
+			int element_size;
+			struct flex_array_part *parts[0];
+		};
+		/*
+		 * This little trick makes sure that
+		 * sizeof(flex_array) == PAGE_SIZE
+		 */
+		char padding[FLEX_ARRAY_BASE_SIZE];
+	};
+};
+
+#define FLEX_ARRAY_INIT(size, total) { { {\
+	.element_size = (size),		\
+	.nr_elements = 0,		\
+} } }
+
+struct flex_array *flex_array_alloc(int element_size, int total, gfp_t flags);
+int flex_array_prealloc(struct flex_array *fa, int start, int end, gfp_t flags);
+void flex_array_free(struct flex_array *fa);
+void flex_array_free_parts(struct flex_array *fa);
+int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags);
+void *flex_array_get(struct flex_array *fa, int element_nr);
+
+#endif /* _FLEX_ARRAY_H */
diff -puN /dev/null lib/flex_array.c
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/lib/flex_array.c	2009-07-22 10:51:23.000000000 -0700
@@ -0,0 +1,240 @@
+/*
+ * Flexible array managed in PAGE_SIZE parts
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2009
+ *
+ * Author: Dave Hansen <dave@linux.vnet.ibm.com>
+ */
+
+#include <linux/flex_array.h>
+#include <linux/slab.h>
+#include <linux/stddef.h>
+
+struct flex_array_part {
+	char elements[FLEX_ARRAY_PART_SIZE];
+};
+
+static inline int __elements_per_part(int element_size)
+{
+	return FLEX_ARRAY_PART_SIZE / element_size;
+}
+
+static inline int nr_base_part_ptrs(void)
+{
+	int element_offset = offsetof(struct flex_array, parts);
+	int bytes_left = FLEX_ARRAY_BASE_SIZE - element_offset;
+	return bytes_left / sizeof(struct flex_array_part *);
+}
+
+/**
+ * flex_array_alloc - allocate a new flexible array
+ * @element_size:	the size of individual elements in the array
+ * @total:		total number of elements that this should hold
+ *
+ * Note: all locking must be provided by the caller.
+ *
+ * We do not actually use @total to size the allocation at this
+ * point.  It is just used to ensure that the user does not try
+ * to use this structure for something larger than it can handle
+ * later on.
+ *
+ * The maximum number of elements is defined as: the number of
+ * elements that can be stored in a page times the number of
+ * page pointers that we can fit in the base structure or (using
+ * integer math):
+ *
+ * 	(PAGE_SIZE/element_size) * (PAGE_SIZE-8)/sizeof(void *)
+ *
+ * Here's a table showing example capacities.  Note that the maximum
+ * index that the get/put() functions is just nr_objects-1.
+ *
+ * Element size | Objects  | Objects |
+ * PAGE_SIZE=4k |  32-bit  |  64-bit |
+ * ----------------------------------|
+ *      1 byte  |  4186112 | 2093056 |
+ *      2 bytes |  2093056 | 1046528 |
+ *      3 bytes |  1395030 |  697515 |
+ *      4 bytes |  1046528 |  523264 |
+ *     32 bytes |   130816 |   65408 |
+ *     33 bytes |   126728 |   63364 |
+ *   2048 bytes |     2044 |   10228 |
+ *   2049 bytes |     1022 |     511 |
+ *       void * |  1046528 |  261632 |
+ *
+ * Since 64-bit pointers are twice the size, we lose half the
+ * capacity in the base structure.  Also note that no effort is made
+ * to efficiently pack objects across page boundaries.
+ */
+struct flex_array *flex_array_alloc(int element_size, int total, gfp_t flags)
+{
+	struct flex_array *ret;
+	int max_size = nr_base_part_ptrs() * __elements_per_part(element_size);
+
+	/* max_size will end up 0 if element_size > PAGE_SIZE */
+	if (total > max_size)
+		return NULL;
+	ret = kzalloc(sizeof(struct flex_array), flags);
+	if (!ret)
+		return NULL;
+	ret->element_size = element_size;
+	return ret;
+}
+
+static int fa_element_to_part_nr(struct flex_array *fa, int element_nr)
+{
+	return element_nr / __elements_per_part(fa->element_size);
+}
+
+/**
+ * flex_array_free_parts - just free the second-level pages
+ * @src:	address of data to copy into the array
+ * @element_nr:	index of the position in which to insert
+ * 		the new element.
+ *
+ * This is to be used in cases where the base 'struct flex_array'
+ * has been statically allocated and should not be free.
+ */
+void flex_array_free_parts(struct flex_array *fa)
+{
+	int part_nr;
+	int max_part = nr_base_part_ptrs();
+
+	for (part_nr = 0; part_nr < max_part; part_nr++)
+		kfree(fa->parts[part_nr]);
+}
+
+void flex_array_free(struct flex_array *fa)
+{
+	flex_array_free_parts(fa);
+	kfree(fa);
+}
+
+static int fa_index_inside_part(struct flex_array *fa, int element_nr)
+{
+	return (element_nr % __elements_per_part(fa->element_size));
+}
+
+static int index_inside_part(struct flex_array *fa, int element_nr)
+{
+	int part_offset = fa_index_inside_part(fa, element_nr);
+	return part_offset * fa->element_size;
+}
+
+static int __check_part_nr(struct flex_array *fa, int part_nr)
+{
+	if (part_nr >= nr_base_part_ptrs()) {
+		WARN(1, "bad flexible array part number: %d >= %d",
+			part_nr, nr_base_part_ptrs());
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct flex_array_part *
+__fa_get_part(struct flex_array *fa, int part_nr, gfp_t flags)
+{
+	struct flex_array_part *part = NULL;
+	if (__check_part_nr(fa, part_nr))
+		return NULL;
+	part = fa->parts[part_nr];
+	if (!part) {
+		part = kmalloc(FLEX_ARRAY_PART_SIZE, flags);
+		if (!part)
+			return NULL;
+		fa->parts[part_nr] = part;
+	}
+	return part;
+}
+
+/**
+ * flex_array_put - copy data into the array at @element_nr
+ * @src:	address of data to copy into the array
+ * @element_nr:	index of the position in which to insert
+ * 		the new element.
+ *
+ * Note that this *copies* the contents of @src into
+ * the array.  If you are trying to store an array of
+ * pointers, make sure to pass in &ptr instead of ptr.
+ *
+ * Locking must be provided by the caller.
+ */
+int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags)
+{
+	int part_nr = fa_element_to_part_nr(fa, element_nr);
+	struct flex_array_part *part;
+	void *dst;
+
+	part = __fa_get_part(fa, part_nr, flags);
+	if (!part)
+		return -ENOMEM;
+	dst = &part->elements[index_inside_part(fa, element_nr)];
+	memcpy(dst, src, fa->element_size);
+	return 0;
+}
+
+/**
+ * flex_array_prealloc - guarantee that array space exists
+ * @start:	index of first array element for which space is allocated
+ * @end:	index of last (inclusive) element for which space is allocated
+ *
+ * This will guarantee that no future calls to flex_array_put()
+ * will allocate memory.  It can be used if you are expecting to
+ * be holding a lock or in some atomic context while writing
+ * data into the array.
+ *
+ * Locking must be provided by the caller.
+ */
+int flex_array_prealloc(struct flex_array *fa, int start, int end, gfp_t flags)
+{
+	int start_part = fa_element_to_part_nr(fa, start);
+	int end_part   = fa_element_to_part_nr(fa, end);
+	int part_nr;
+	struct flex_array_part *part;
+
+	for (part_nr = start_part; part_nr <= end_part; part_nr++) {
+		part = __fa_get_part(fa, part_nr, flags);
+		if (!part)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+/**
+ * flex_array_get - pull data back out of the array
+ * @element_nr:	index of the element to fetch from the array
+ *
+ * Returns a pointer to the data at index @element_nr.  Note
+ * that this is a copy of the data that was passed in.  If you
+ * are using this to store pointers, you'll get back &ptr.
+ *
+ * Locking must be provided by the caller.
+ */
+void *flex_array_get(struct flex_array *fa, int element_nr)
+{
+	int part_nr = fa_element_to_part_nr(fa, element_nr);
+	struct flex_array_part *part;
+	int offset;
+
+	if (__check_part_nr(fa, part_nr))
+		return NULL;
+	if (!fa->parts[part_nr])
+		return NULL;
+
+	part = fa->parts[part_nr];
+	offset = index_inside_part(fa, element_nr);
+	return &part->elements[index_inside_part(fa, element_nr)];
+}
diff -puN lib/Makefile~fa lib/Makefile
--- linux-2.6.git/lib/Makefile~fa	2009-07-22 10:02:25.000000000 -0700
+++ linux-2.6.git-dave/lib/Makefile	2009-07-22 10:02:25.000000000 -0700
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o
+	 is_single_threaded.o plist.o decompress.o flex_array.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
_
