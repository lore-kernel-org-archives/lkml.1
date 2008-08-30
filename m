Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbYH3C55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbYH3C55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 22:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYH3C5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 22:57:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbYH3C5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 22:57:47 -0400
Date: Fri, 29 Aug 2008 19:56:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <200808292157.24179.rjw@sisk.pl>  <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>  <200808300031.16708.rjw@sisk.pl>  <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
  <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>  <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>  <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>
 <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com> <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Linus Torvalds wrote:
> 
> Yes. And I do think this is a workable model.

Ok, and here's the patch to do

	insert_resource_expand_to_fit(root, new);

and while I still haven't actually tested it, it looks sane and compiles 
to code that also looks sane.

I'll happily commit this as basic infrastructure as soon as somebody ack's 
it and tests that it works (and I'll try it myself soon enough, just for 
fun)

		Linus

---
 include/linux/ioport.h |    1 +
 kernel/resource.c      |   88 ++++++++++++++++++++++++++++++++++-------------
 2 files changed, 64 insertions(+), 25 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 22d2115..8d3b7a9 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -109,6 +109,7 @@ extern struct resource iomem_resource;
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
 extern int insert_resource(struct resource *parent, struct resource *new);
+extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
 extern int allocate_resource(struct resource *root, struct resource *new,
 			     resource_size_t size, resource_size_t min,
 			     resource_size_t max, resource_size_t align,
diff --git a/kernel/resource.c b/kernel/resource.c
index f5b518e..72ee95b 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -362,35 +362,21 @@ int allocate_resource(struct resource *root, struct resource *new,
 
 EXPORT_SYMBOL(allocate_resource);
 
-/**
- * insert_resource - Inserts a resource in the resource tree
- * @parent: parent of the new resource
- * @new: new resource to insert
- *
- * Returns 0 on success, -EBUSY if the resource can't be inserted.
- *
- * This function is equivalent to request_resource when no conflict
- * happens. If a conflict happens, and the conflicting resources
- * entirely fit within the range of the new resource, then the new
- * resource is inserted and the conflicting resources become children of
- * the new resource.
+/*
+ * Insert a resource into the resource tree. If successful, return NULL,
+ * otherwise return the conflicting resource (compare to __request_resource())
  */
-int insert_resource(struct resource *parent, struct resource *new)
+static struct resource * __insert_resource(struct resource *parent, struct resource *new)
 {
-	int result;
 	struct resource *first, *next;
 
-	write_lock(&resource_lock);
-
 	for (;; parent = first) {
-	 	result = 0;
 		first = __request_resource(parent, new);
 		if (!first)
-			goto out;
+			return first;
 
-		result = -EBUSY;
 		if (first == parent)
-			goto out;
+			return first;
 
 		if ((first->start > new->start) || (first->end < new->end))
 			break;
@@ -401,15 +387,13 @@ int insert_resource(struct resource *parent, struct resource *new)
 	for (next = first; ; next = next->sibling) {
 		/* Partial overlap? Bad, and unfixable */
 		if (next->start < new->start || next->end > new->end)
-			goto out;
+			return next;
 		if (!next->sibling)
 			break;
 		if (next->sibling->start > new->end)
 			break;
 	}
 
-	result = 0;
-
 	new->parent = parent;
 	new->sibling = next->sibling;
 	new->child = first;
@@ -426,10 +410,64 @@ int insert_resource(struct resource *parent, struct resource *new)
 			next = next->sibling;
 		next->sibling = new;
 	}
+	return NULL;
+}
 
- out:
+/**
+ * insert_resource - Inserts a resource in the resource tree
+ * @parent: parent of the new resource
+ * @new: new resource to insert
+ *
+ * Returns 0 on success, -EBUSY if the resource can't be inserted.
+ *
+ * This function is equivalent to request_resource when no conflict
+ * happens. If a conflict happens, and the conflicting resources
+ * entirely fit within the range of the new resource, then the new
+ * resource is inserted and the conflicting resources become children of
+ * the new resource.
+ */
+int insert_resource(struct resource *parent, struct resource *new)
+{
+	struct resource *conflict;
+
+	write_lock(&resource_lock);
+	conflict = __insert_resource(parent, new);
 	write_unlock(&resource_lock);
-	return result;
+	return conflict ? -EBUSY : 0;
+}
+
+/**
+ * insert_resource_expand_to_fit - Insert a resource into the resource tree
+ * @parent: parent of the new resource
+ * @new: new resource to insert
+ *
+ * Insert a resource into the resource tree, possibly expanding it in order
+ * to make it encompass any conflicting resources.
+ */
+void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
+{
+	if (new->parent)
+		return;
+
+	write_lock(&resource_lock);
+	for (;;) {
+		struct resource *conflict;
+
+		conflict = __insert_resource(root, new);
+		if (!conflict)
+			break;
+		if (conflict == root)
+			break;
+
+		/* Ok, expand resource to cover the conflict, then try again .. */
+		if (conflict->start < new->start)
+			new->start = conflict->start;
+		if (conflict->end > new->end)
+			new->end = conflict->end;
+
+		printk("Expanded resource %s due to conflict with %s", new->name, conflict->name);
+	}
+	write_unlock(&resource_lock);	
 }
 
 /**
