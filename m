Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbYH3IAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbYH3IAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 04:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYH3H7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 03:59:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:38181 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbYH3H7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 03:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZFvMB/Rs0oSbbnqBNv8Q07bLcVLSo1U5uba9okp6pTrgZRhKj48UmeEQIHP4fzu+Wg
         dCbQUjndjFLtcvD9oMaF1YCvQILs/HC5XMUG+rqbM+iRkap5hXRIcuc9JdskZ9/B7x3k
         4fJZV4V8J1ZW4WxQjruffIUBSLN5odV9mMFI8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: split e820 reserved entries record to late v4 - fix v3
Date: Sat, 30 Aug 2008 00:58:42 -0700
Message-Id: <1220083122-4058-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220083122-4058-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220083122-4058-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try to insert_resource second time, by expand the resource...

for case: e820 reserved entry is partially overlapped with bar res...

hope it will never happen

v2: according to Linus, add insert_resource_expand_to_fit, and change
	__insert_resource to static without lock

v3: use reserve_region_with_split() instead to hand overlapping
	with test case by extend 0xe0000000 - 0xeffffff to 0xdd800000 -
	get
		e0000000-efffffff : PCI MMCONFIG 0
			 e0000000-efffffff : reserved
	in /proc/iomem
	get
		found conflict for reserved [dd800000, efffffff], try to reserve with split
		    __reserve_region_with_split: (PCI Bus #80) [dd000000, ddffffff], res: (reserved) [dd800000, efffffff]
		    __reserve_region_with_split: (PCI Bus #00) [de000000, dfffffff], res: (reserved) [de000000, efffffff]
		initcall pci_subsys_init+0x0/0x121 returned 0 after 381 msecs
	in dmesg

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |    8 +++-
 include/linux/ioport.h |    3 +
 kernel/resource.c      |   95 ++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 92 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1319,8 +1319,12 @@ void __init e820_reserve_resources_late(
 
 	res = e820_res;
 	for (i = 0; i < e820.nr_map; i++) {
-		if (!res->parent && res->end)
-			insert_resource(&iomem_resource, res);
+		if (!res->parent && res->end && insert_resource(&iomem_resource, res)) {
+			printk(KERN_WARNING "found conflict for %s [%08llx, %08llx], try to reserve with split\n",
+				res->name, res->start, res->end);
+
+			reserve_region_with_split(&iomem_resource, res->start, res->end, res->name);
+		}
 		res++;
 	}
 }
Index: linux-2.6/include/linux/ioport.h
===================================================================
--- linux-2.6.orig/include/linux/ioport.h
+++ linux-2.6/include/linux/ioport.h
@@ -108,6 +108,9 @@ extern struct resource iomem_resource;
 
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
+extern void reserve_region_with_split(struct resource *root,
+			     resource_size_t start, resource_size_t end,
+			     char *name);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern int allocate_resource(struct resource *root, struct resource *new,
 			     resource_size_t size, resource_size_t min,
Index: linux-2.6/kernel/resource.c
===================================================================
--- linux-2.6.orig/kernel/resource.c
+++ linux-2.6/kernel/resource.c
@@ -363,32 +363,30 @@ int allocate_resource(struct resource *r
 EXPORT_SYMBOL(allocate_resource);
 
 /**
- * insert_resource - Inserts a resource in the resource tree
+ * __insert_resource - Inserts a resource in the resource tree
  * @parent: parent of the new resource
  * @new: new resource to insert
  *
- * Returns 0 on success, -EBUSY if the resource can't be inserted.
+ * Returns NULL on success, or first conflict resource.
  *
- * This function is equivalent to request_resource when no conflict
+ * This function is equivalent to __request_resource when no conflict
  * happens. If a conflict happens, and the conflicting resources
  * entirely fit within the range of the new resource, then the new
  * resource is inserted and the conflicting resources become children of
  * the new resource.
  */
-int insert_resource(struct resource *parent, struct resource *new)
+static struct resource *__insert_resource(struct resource *parent, struct resource *new)
 {
-	int result;
+	struct resource *ret_res;
 	struct resource *first, *next;
 
-	write_lock(&resource_lock);
-
 	for (;; parent = first) {
-	 	result = 0;
+		ret_res = NULL;
 		first = __request_resource(parent, new);
 		if (!first)
 			goto out;
 
-		result = -EBUSY;
+		ret_res = first;
 		if (first == parent)
 			goto out;
 
@@ -400,15 +398,17 @@ int insert_resource(struct resource *par
 
 	for (next = first; ; next = next->sibling) {
 		/* Partial overlap? Bad, and unfixable */
-		if (next->start < new->start || next->end > new->end)
+		if (next->start < new->start || next->end > new->end) {
+			ret_res = next;
 			goto out;
+		}
 		if (!next->sibling)
 			break;
 		if (next->sibling->start > new->end)
 			break;
 	}
 
-	result = 0;
+	ret_res = NULL;
 
 	new->parent = parent;
 	new->sibling = next->sibling;
@@ -428,8 +428,79 @@ int insert_resource(struct resource *par
 	}
 
  out:
+	return ret_res;
+}
+
+/**
+ * insert_resource - Inserts a resource in the resource tree
+ * @parent: parent of the new resource
+ * @new: new resource to insert
+ *
+ * Returns 0 on success, -EBUSY if the resource can't be inserted.
+ */
+int insert_resource(struct resource *parent, struct resource *new)
+{
+	struct resource *res_conflict;
+
+	write_lock(&resource_lock);
+	res_conflict = __insert_resource(parent, new);
+	write_unlock(&resource_lock);
+
+	return res_conflict ? -EBUSY : 0;
+}
+
+static void __init __reserve_region_with_split(struct resource *root,
+		resource_size_t start, resource_size_t end,
+		char *name)
+{
+	struct resource *parent = root;
+	struct resource *conflict;
+	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
+
+	if (!res)
+		return;
+
+	res->name = name;
+	res->start = start;
+	res->end = end;
+	res->flags = IORESOURCE_BUSY;
+
+	for (;;) {
+		conflict = __request_resource(parent, res);
+		if (!conflict)
+			break;
+		if (conflict != parent) {
+			parent = conflict;
+			if (!(conflict->flags & IORESOURCE_BUSY))
+				continue;
+		}
+
+		/* Uhhuh, that didn't work out.. */
+		kfree(res);
+		res = NULL;
+		break;
+	}
+
+	if (!res) {
+		printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
+			 conflict->name, conflict->start, conflict->end,
+			 name, start, end);
+		/* failed, split and try again */
+		if (conflict->start > start)
+			__reserve_region_with_split(root, start, conflict->start, name);
+		if (conflict->end < end)
+			__reserve_region_with_split(root, conflict->end+1, end, name);
+	}
+
+}
+
+void reserve_region_with_split(struct resource *root,
+		resource_size_t start, resource_size_t end,
+		char *name)
+{
+	write_lock(&resource_lock);
+	__reserve_region_with_split(root, start, end, name);
 	write_unlock(&resource_lock);
-	return result;
 }
 
 /**
