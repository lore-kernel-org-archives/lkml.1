Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbXF2VuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbXF2VuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbXF2Vti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:49:38 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2532 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbXF2Vtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:49:35 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 29 Jun 2007 14:48:52 -0700
Subject: [patch 1/6] sys_indirect RFC - fast sequential allocator
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.28360.1183153733.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This file implements a fast, sequential allocator. Chunks of memory
are allocated in blocks of pages, and inside these blocks memory is
allocated is a sequential fashion. All the allocated memory is released
in one single sweep by freeing the backing pages. Indeed, there is not
an fsa_free() function to deallocate a single block. The user can provide
an initial allocation backing store, if needed, to avoid the alocator to
call page allocation functions for the first "in cache" allocations.
The FSA allocator provides no locking, so it is up to the caller serialize
fsa_alloc() calls if ever needed.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 include/linux/fsalloc.h |   34 ++++++++++++++++
 lib/Makefile            |    2 
 lib/fsalloc.c           |  102 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/lib/Makefile
===================================================================
--- linux-2.6.mod.orig/lib/Makefile	2007-06-29 12:12:42.000000000 -0700
+++ linux-2.6.mod/lib/Makefile	2007-06-29 12:12:45.000000000 -0700
@@ -5,7 +5,7 @@
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
-	 sha1.o irq_regs.o reciprocal_div.o
+	 sha1.o irq_regs.o reciprocal_div.o fsalloc.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
Index: linux-2.6.mod/include/linux/fsalloc.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.mod/include/linux/fsalloc.h	2007-06-29 12:12:45.000000000 -0700
@@ -0,0 +1,34 @@
+/*
+ *  include/linux/fsalloc.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_FSALLOC_H
+#define _LINUX_FSALLOC_H
+
+#ifdef __KERNEL__
+
+struct fsa_page {
+	struct fsa_page *next;
+	int order;
+	unsigned long avail;
+	void *data;
+};
+
+struct fsa_context {
+	struct fsa_page *first, *curr;
+	struct fsa_page cached;
+	int order;
+};
+
+void fsa_init(struct fsa_context *ator, void *buffer,
+	      unsigned long csize);
+void fsa_cleanup(struct fsa_context *ator);
+void *fsa_alloc(struct fsa_context *ator, unsigned long size);
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_FSALLOC_H */
+
Index: linux-2.6.mod/lib/fsalloc.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.mod/lib/fsalloc.c	2007-06-29 12:12:45.000000000 -0700
@@ -0,0 +1,102 @@
+/*
+ *  lib/fsalloc.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ *  This file implements a fast, sequential allocator. Chunks of memory
+ *  are allocated in blocks of pages, and inside these blocks memory is
+ *  allocated is a sequential fashion. All the allocated memory is released
+ *  in one single sweep by freeing the backing pages. Indeed, there is not
+ *  an fsa_free() function to deallocate a single block. The user can provide
+ *  an initial allocation backing store, if needed, to avoid the alocator to
+ *  call page allocation functions for the first "in cache" allocations.
+ *  The FSA allocator provides no locking, so it is up to the caller serialize
+ *  fsa_alloc() calls if ever needed.
+ */
+
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/kernel.h>
+#include <linux/fsalloc.h>
+
+#define FSA_MEM_ALIGN	sizeof(unsigned long)
+#define FSA_FIT_FACTOR	8
+#define FSA_MIN_ORDER	1
+#define FSA_MAX_ORDER	8
+
+/**
+ * fsa_init - Initializes a grow-only allocator
+ *
+ * @ator:    [in] Pointer to the allocator structure
+ * @buffer:  [in] Pointer to a buffer to be used as initial cached buffer
+ *                for the allocator
+ * @csize:   [in] Size of @buffer or 0 in case @buffer is NULL
+ *
+ */
+void fsa_init(struct fsa_context *ator, void *buffer,
+	      unsigned long csize)
+{
+	ator->order = FSA_MIN_ORDER;
+	ator->cached.next = NULL;
+	ator->cached.order = -1;
+	ator->cached.avail = csize;
+	ator->cached.data = buffer;
+	ator->first = ator->curr = &ator->cached;
+}
+
+/**
+ * fsa_cleanup - Cleanups all the memory allocated by the grow-only allocator
+ *
+ * @ator:    [in] Pointer to the allocator structure
+ *
+ */
+void fsa_cleanup(struct fsa_context *ator)
+{
+	struct fsa_page *curr, *next;
+
+	for (next = ator->first; (curr = next) != NULL;) {
+		next = curr->next;
+		if (curr->order >= 0)
+			free_pages((unsigned long) curr, curr->order);
+	}
+}
+
+/**
+ * fsa_alloc - Allocated a buffer inside the grow-only allocator
+ *
+ * @ator:    [in] Pointer to the allocator structure
+ * @size:    [in] Size of the requested buffer
+ *
+ * Returns a pointer to the allocated buffer, or NULL in case of error.
+ */
+void *fsa_alloc(struct fsa_context *ator, unsigned long size)
+{
+	int order;
+	struct fsa_page *new;
+	void *data;
+
+	size = roundup(size, FSA_MEM_ALIGN);
+	if (unlikely(ator->curr->avail < size)) {
+		if (size >= (PAGE_SIZE << FSA_MAX_ORDER) - sizeof(struct fsa_page))
+			return NULL;
+		order = get_order(FSA_FIT_FACTOR * size + sizeof(struct fsa_page));
+		order = max(order, ator->order);
+		order = min(order, FSA_MAX_ORDER);
+		new = (struct fsa_page *) __get_free_pages(GFP_KERNEL, order);
+		if (!new)
+			return NULL;
+		ator->order = order;
+		new->order = order;
+		new->avail = (PAGE_SIZE << order) - sizeof(struct fsa_page);
+		new->data = (char *) new + sizeof(struct fsa_page);
+		new->next = NULL;
+		ator->curr->next = new;
+		ator->curr = new;
+	}
+	data = ator->curr->data;
+	ator->curr->data = data + size;
+	ator->curr->avail -= size;
+	return data;
+}
+

