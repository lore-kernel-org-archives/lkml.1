Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0CLABO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:01:14 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:37275 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0CLABL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:01:11 -0500
Subject: [PATCH v1 1/3] resources: add interfaces that return conflict
	information
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yanko Kaneti <yaneti@declera.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
Date: Thu, 11 Mar 2010 17:01:09 -0700
Message-ID: <20100312000108.4355.47777.stgit@bob.kio>
In-Reply-To: <20100311235954.4355.23100.stgit@bob.kio>
References: <20100311235954.4355.23100.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


request_resource() and insert_resource() only return success or failure,
which no information about what existing resource conflicted with the
proposed new reservation.  This patch adds request_resource_conflict()
and insert_resource_conflict(), which return the conflicting resource.

Callers may use this for better error messages or to adjust the new
resource and retry the request.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 include/linux/ioport.h |    2 ++
 kernel/resource.c      |   44 +++++++++++++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 7 deletions(-)


diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index dda9841..1d95f75 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -110,12 +110,14 @@ struct resource_list {
 extern struct resource ioport_resource;
 extern struct resource iomem_resource;
 
+extern struct resource *request_resource_conflict(struct resource *root, struct resource *new);
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
 void release_child_resources(struct resource *new);
 extern void reserve_region_with_split(struct resource *root,
 			     resource_size_t start, resource_size_t end,
 			     const char *name);
+extern struct resource *insert_resource_conflict(struct resource *parent, struct resource *new);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
 extern int allocate_resource(struct resource *root, struct resource *new,
diff --git a/kernel/resource.c b/kernel/resource.c
index 2d5be5d..9c358e2 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -219,19 +219,34 @@ void release_child_resources(struct resource *r)
 }
 
 /**
- * request_resource - request and reserve an I/O or memory resource
+ * request_resource_conflict - request and reserve an I/O or memory resource
  * @root: root resource descriptor
  * @new: resource descriptor desired by caller
  *
- * Returns 0 for success, negative error code on error.
+ * Returns 0 for success, conflict resource on error.
  */
-int request_resource(struct resource *root, struct resource *new)
+struct resource *request_resource_conflict(struct resource *root, struct resource *new)
 {
 	struct resource *conflict;
 
 	write_lock(&resource_lock);
 	conflict = __request_resource(root, new);
 	write_unlock(&resource_lock);
+	return conflict;
+}
+
+/**
+ * request_resource - request and reserve an I/O or memory resource
+ * @root: root resource descriptor
+ * @new: resource descriptor desired by caller
+ *
+ * Returns 0 for success, negative error code on error.
+ */
+int request_resource(struct resource *root, struct resource *new)
+{
+	struct resource *conflict;
+
+	conflict = request_resource_conflict(root, new);
 	return conflict ? -EBUSY : 0;
 }
 
@@ -474,25 +489,40 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
 }
 
 /**
- * insert_resource - Inserts a resource in the resource tree
+ * insert_resource_conflict - Inserts resource in the resource tree
  * @parent: parent of the new resource
  * @new: new resource to insert
  *
- * Returns 0 on success, -EBUSY if the resource can't be inserted.
+ * Returns 0 on success, conflict resource if the resource can't be inserted.
  *
- * This function is equivalent to request_resource when no conflict
+ * This function is equivalent to request_resource_conflict when no conflict
  * happens. If a conflict happens, and the conflicting resources
  * entirely fit within the range of the new resource, then the new
  * resource is inserted and the conflicting resources become children of
  * the new resource.
  */
-int insert_resource(struct resource *parent, struct resource *new)
+struct resource *insert_resource_conflict(struct resource *parent, struct resource *new)
 {
 	struct resource *conflict;
 
 	write_lock(&resource_lock);
 	conflict = __insert_resource(parent, new);
 	write_unlock(&resource_lock);
+	return conflict;
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
+	struct resource *conflict;
+
+	conflict = insert_resource_conflict(parent, new);
 	return conflict ? -EBUSY : 0;
 }
 

