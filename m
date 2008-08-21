Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYHUDJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYHUDJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbYHUDIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:08:55 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:45996 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbYHUDIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:08:53 -0400
Date: Wed, 20 Aug 2008 23:06:50 -0400 (EDT)
From: Oren Laadan <orenl@cs.columbia.edu>
X-X-Sender: orenl@takamine.ncl.cs.columbia.edu
To: dave@linux.vnet.ibm.com
cc: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: [RFC v2][PATCH 7/9] Infrastructure for shared objects
In-Reply-To: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
Message-ID: <Pine.LNX.4.64.0808202306170.17436@takamine.ncl.cs.columbia.edu>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Infrastructure to handle objects that may be shared and referenced by
multiple tasks or other objects, e..g open files, memory address space
etc.

The state of shared objects is saved once. On the first encounter, the
state is dumped and the object is assigned a unique identifier and also
stored in a hash table (indexed by its physical kenrel address). From
then on the object will be found in the hash and only its identifier is
saved.

On restart the identifier is looked up in the hash table; if not found
then the state is read, the object is created, and added to the hash
table (this time indexed by its identifier). Otherwise, the object in
the hash table is used.

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
  Documentation/checkpoint.txt |   44 ++++++++++
  checkpoint/Makefile          |    2 +-
  checkpoint/ckpt.h            |   18 ++++
  checkpoint/objhash.c         |  193 ++++++++++++++++++++++++++++++++++++++++++
  checkpoint/sys.c             |    4 +
  5 files changed, 260 insertions(+), 1 deletions(-)
  create mode 100644 checkpoint/objhash.c

diff --git a/Documentation/checkpoint.txt b/Documentation/checkpoint.txt
index fdc69cb..923ec10 100644
--- a/Documentation/checkpoint.txt
+++ b/Documentation/checkpoint.txt
@@ -163,6 +163,50 @@ cr_hdr + cr_hdr_task
  cr_hdr + cr_hdr_tail


+=== Shared resources (objects)
+
+Many resources used by tasks may be shared by more than one task (e.g.
+file descriptors, memory address space, etc), or even have multiple
+references from other resources (e.g. a single inode that represents
+two ends of a pipe).
+
+Clearly, the state of shared objects need only be saved once, even if
+they occur multiple times. We use a hash table (ctx->objhash) to keep
+track of shared objects in the following manner.
+
+On the first encounter, the state is dumped and the object is assigned
+a unique identifier and also stored in the hash table (indexed by its
+physical kenrel address). From then on the object will be found in the
+hash and only its identifier is saved.
+ 
+On restart the identifier is looked up in the hash table; if not found
+then the state is read, the object is created, and added to the hash
+table (this time indexed by its identifier). Otherwise, the object in
+the hash table is used.
+
+The interface for the hash table is the following:
+
+int cr_obj_get_by_ptr(struct cr_ctx *ctx, void *ptr, unsigned short type);
+  [checkpoint] find the unique identifier (tag) of the object that
+  is pointer to by ptr (or 0 if not found).
+
+int cr_obj_add_ptr(struct cr_ctx *ctx, void *ptr, int *tag,
+		   unsigned short type, unsigned short flags);
+  [checkpoint] add the object pointed to by ptr to the hash table if
+  it isn't already there, and fill its unique identifier (tag); will
+  return 0 if already found in the has, or 1 otherwise.
+
+void *cr_obj_get_by_tag(struct cr_ctx *ctx, int tag, unsigned short type);
+  [restart] return the pointer to the object whose unique identifier
+  is equal to tag.
+
+int cr_obj_add_tag(struct cr_ctx *ctx, void *ptr, int tag,
+		   unsigned short type, unsigned short flags);
+  [restart] add the object with unique identifier tag, pointed to by
+  ptr to the hash table if it isn't already there; will return 0 if
+  already found in the has, or 1 otherwise.
+
+
  === Changelog

  [2008-Jul-29] v1:
diff --git a/checkpoint/Makefile b/checkpoint/Makefile
index 41e0877..cd57d9d 100644
--- a/checkpoint/Makefile
+++ b/checkpoint/Makefile
@@ -1,2 +1,2 @@
-obj-y += sys.o checkpoint.o restart.o ckpt_mem.o rstr_mem.o
+obj-y += sys.o checkpoint.o restart.o objhash.o ckpt_mem.o rstr_mem.o
  obj-$(CONFIG_X86) += ckpt_x86.o rstr_x86.o
diff --git a/checkpoint/ckpt.h b/checkpoint/ckpt.h
index 0addb63..8b02c4c 100644
--- a/checkpoint/ckpt.h
+++ b/checkpoint/ckpt.h
@@ -29,6 +29,8 @@ struct cr_ctx {
  	void *hbuf;		/* header: to avoid many alloc/dealloc */
  	int hpos;

+	struct cr_objhash *objhash;
+
  	struct cr_pgarr *pgarr;
  	struct cr_pgarr *pgcur;

@@ -56,6 +58,22 @@ int cr_kread(struct cr_ctx *ctx, void *buf, int count);
  void *cr_hbuf_get(struct cr_ctx *ctx, int n);
  void cr_hbuf_put(struct cr_ctx *ctx, int n);

+/* shared objects handling */
+
+enum {
+	CR_OBJ_FILE = 1,
+	CR_OBJ_MAX
+};
+ 
+void cr_objhash_free(struct cr_ctx *ctx);
+int cr_objhash_alloc(struct cr_ctx *ctx);
+void *cr_obj_get_by_tag(struct cr_ctx *ctx, int tag, unsigned short type);
+int cr_obj_get_by_ptr(struct cr_ctx *ctx, void *ptr, unsigned short type);
+int cr_obj_add_ptr(struct cr_ctx *ctx, void *ptr, int *tag,
+		   unsigned short type, unsigned short flags);
+int cr_obj_add_tag(struct cr_ctx *ctx, void *ptr, int tag,
+		   unsigned short type, unsigned short flags);
+
  struct cr_hdr;

  int cr_write_obj(struct cr_ctx *ctx, struct cr_hdr *h, void *buf);
diff --git a/checkpoint/objhash.c b/checkpoint/objhash.c
new file mode 100644
index 0000000..aca32c6
--- /dev/null
+++ b/checkpoint/objhash.c
@@ -0,0 +1,193 @@
+/*
+ *  Checkpoint-restart - object hash infrastructure to manage shared objects 
+ *
+ *  Copyright (C) 2008 Oren Laadan
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License.  See the file COPYING in the main directory of the Linux
+ *  distribution for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/file.h>
+#include <linux/hash.h>
+
+#include "ckpt.h"
+
+struct cr_obj {
+	int tag;
+	void *ptr;
+	unsigned short type;
+	unsigned short flags;
+	struct cr_obj *next;
+};
+
+struct cr_objhash {
+	struct cr_obj **hash;
+	int next_tag;
+};
+
+#define CR_OBJHASH_NBITS  10	/* 10 bits = 1K buckets */
+#define CR_OBJHASH_ORDER  0	/* 1K buckets * 4 bytes/bucket = 1 page */
+#define CR_OBJHASH_TOTAL  (1 << CR_OBJHASH_NBITS)
+
+static void cr_obj_ref_drop(struct cr_obj *obj)
+{
+	switch (obj->type) {
+	case CR_OBJ_FILE:
+		fput((struct file *) obj->ptr);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static void cr_obj_ref_grab(struct cr_obj *obj)
+{
+	switch (obj->type) {
+	case CR_OBJ_FILE:
+		get_file((struct file *) obj->ptr);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static void cr_objhash_clear(struct cr_objhash *objhash)
+{
+	struct cr_obj **hash = objhash->hash;
+	struct cr_obj *obj, *next;
+	int n;
+
+	for (n = 0; n < CR_OBJHASH_TOTAL; n++) {
+		for (obj = hash[n]; obj; obj = next) {
+			next = obj->next;
+			cr_obj_ref_drop(obj);
+			kfree(obj);
+		}
+	}
+}
+
+void cr_objhash_free(struct cr_ctx *ctx)
+{
+	struct cr_objhash *objhash = ctx->objhash;
+
+	if (objhash) {
+		cr_objhash_clear(objhash);
+		free_pages((unsigned long) objhash->hash, CR_OBJHASH_ORDER);
+		kfree(ctx->objhash);
+		ctx->objhash = NULL;
+	}
+}
+
+int cr_objhash_alloc(struct cr_ctx *ctx)
+{
+	struct cr_objhash *objhash;
+
+	objhash = kzalloc(sizeof(*objhash), GFP_KERNEL);
+	if (!objhash)
+		return -ENOMEM;
+	objhash->hash = (struct cr_obj **)
+		__get_free_pages(GFP_KERNEL, CR_OBJHASH_ORDER);
+	if (!objhash->hash) {
+		kfree(objhash);
+		return -ENOMEM;
+	}
+	memset(objhash->hash, 0, PAGE_SIZE << CR_OBJHASH_ORDER);
+	objhash->next_tag = 1;
+
+	ctx->objhash = objhash;
+	return 0;
+}
+
+static struct cr_obj *cr_obj_find_by_ptr(struct cr_ctx *ctx, void *ptr)
+{
+	struct cr_obj *obj;
+
+	obj = ctx->objhash->hash[hash_ptr(ptr, CR_OBJHASH_NBITS)];
+	while (obj && obj != ptr)
+		obj = obj->next;
+	return obj;
+}
+
+static struct cr_obj *cr_obj_find_by_tag(struct cr_ctx *ctx, int tag)
+{
+	struct cr_obj *obj;
+
+	obj = ctx->objhash->hash[hash_ptr((void *) tag, CR_OBJHASH_NBITS)];
+	while (obj && obj->tag != tag)
+		obj = obj->next;
+	return obj;
+}
+
+static struct cr_obj *cr_obj_new(struct cr_ctx *ctx, void *ptr, int tag,
+				 unsigned short type, unsigned short flags)
+{
+	struct cr_obj *obj;
+	int n;
+
+	obj = kmalloc(sizeof(*obj), GFP_KERNEL);
+	if (obj) {
+		obj->ptr = ptr;
+		obj->type = type;
+		obj->flags = flags;
+		obj->tag = (tag ? tag : ctx->objhash->next_tag++);
+
+		cr_obj_ref_grab(obj);
+
+		n = hash_ptr(ptr, CR_OBJHASH_NBITS);
+		obj->next = ctx->objhash->hash[n];
+		ctx->objhash->hash[n] = obj;
+	}
+	return obj;
+}
+
+int cr_obj_add_ptr(struct cr_ctx *ctx, void *ptr, int *tag,
+		   unsigned short type, unsigned short flags)
+{
+	struct cr_obj *obj;
+	int ret = 0;
+
+	obj = cr_obj_find_by_ptr(ctx, ptr);
+	if (!obj) {
+		obj = cr_obj_new(ctx, ptr, 0, type, flags);
+		if (!obj)
+			return -ENOMEM;
+		else
+			ret = 1;
+	} else if (obj->type != type)	/* sanity check */
+		return -EINVAL;
+	*tag = obj->tag;
+	return ret;
+}
+
+int cr_obj_add_tag(struct cr_ctx *ctx, void *ptr, int tag,
+		   unsigned short type, unsigned short flags)
+{
+	struct cr_obj *obj;
+
+	obj = cr_obj_new(ctx, ptr, tag, type, flags);
+	return (obj ? 0 : -ENOMEM);
+}
+
+int cr_obj_get_by_ptr(struct cr_ctx *ctx, void *ptr, unsigned short type)
+{
+	struct cr_obj *obj;
+
+	obj = cr_obj_find_by_ptr(ctx, ptr);
+	if (obj)
+		return (obj->type == type ? obj->tag : -EINVAL);
+	else
+		return -ESRCH;
+}
+
+void *cr_obj_get_by_tag(struct cr_ctx *ctx, int tag, unsigned short type)
+{
+	struct cr_obj *obj;
+
+	obj = cr_obj_find_by_tag(ctx, tag);
+	if (obj)
+		return (obj->type == type ? obj->ptr : ERR_PTR(-EINVAL));
+	else
+		return NULL;
+}
diff --git a/checkpoint/sys.c b/checkpoint/sys.c
index eec5032..7b2670a 100644
--- a/checkpoint/sys.c
+++ b/checkpoint/sys.c
@@ -122,6 +122,7 @@ void cr_ctx_free(struct cr_ctx *ctx)
  	free_pages((unsigned long) ctx->hbuf, CR_HBUF_ORDER);

  	cr_pgarr_free(ctx);
+	cr_objhash_free(ctx);

  	kfree(ctx);
  }
@@ -142,6 +143,9 @@ struct cr_ctx *cr_ctx_alloc(pid_t pid, struct file *file, unsigned long flags)
  	if (!cr_pgarr_alloc(ctx, &ctx->pgarr))
  		goto nomem;

+	if (cr_objhash_alloc(ctx) < 0)
+		goto nomem;
+
  	ctx->pid = pid;
  	ctx->flags = flags;

-- 
1.5.4.3

