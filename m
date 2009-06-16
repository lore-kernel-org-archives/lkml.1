Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbZFPWEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbZFPWEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbZFPWEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:04:23 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:47587 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbZFPWEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:04:22 -0400
Subject: [PATCH] Recurse when searching for empty slots in resources trees
To: linux-pci@vger.kernel.org
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Date: Tue, 16 Jun 2009 16:04:25 -0600
Message-ID: <20090616220425.14021.5777.stgit@bob.kio>
In-Reply-To: <20090616220419.14021.84524.stgit@bob.kio>
References: <20090616220419.14021.84524.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recurse when searching for empty slots in resources trees

The function pci_assign_resource() is called to allocate address
ranges for PCI device BARs in the parent bridges resource tree during
hot add operations (such as during physical hot-plug, logical
hot-plug, or PCI error recovery) of a PCI device.  This function in
turn calls find_resource() to see if resources are available, and then
allocate_resource() to insert the resource into the tree. Both of
these functions only check the immediate children and its siblings of
the root resource passed to them.  This algorithm can fail in certain
topologies where a resource is only available further down the
resource tree.

This patch changes find_resources() and allocate_resources() so that
they recursively descend the resource tree instead of just checking the
immediate child and its siblings.

Descendents are checked after the immediate child and its siblings to
maintain as much as possible the existing tree resource layout.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/kernel/resource.c b/kernel/resource.c
index ac5f3a3..636c3b0 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -301,19 +301,28 @@ static int find_resource(struct resource *root, struct resource *new,
 	struct resource *this = root->child;
 
 	new->start = root->start;
+
 	/*
-	 * Skip past an allocated resource that starts at 0, since the assignment
-	 * of this->start - 1 to new->end below would cause an underflow.
+	 * See if there is room before, after, or in between child
+	 * and/or its siblings.
 	 */
-	if (this && this->start == 0) {
-		new->start = this->end + 1;
-		this = this->sibling;
-	}
 	for(;;) {
-		if (this)
-			new->end = this->start - 1;
-		else
+		if (this) {
 			new->end = root->end;
+			if (new->start + size - 1 < this->start)
+				new->end = new->start + size - 1;
+			else {
+				if (this->sibling) {
+					if (this->sibling->start - this->end >= size - 1) {
+						new->start = this->end + 1;
+						new->end = this->sibling->start - 1;
+					} else
+						goto next;
+				} else
+					new->start = this->end + 1;
+			}
+		}
+
 		if (new->start < min)
 			new->start = min;
 		if (new->end > max)
@@ -327,9 +336,22 @@ static int find_resource(struct resource *root, struct resource *new,
 		}
 		if (!this)
 			break;
+next:
 		new->start = this->end + 1;
 		this = this->sibling;
 	}
+
+	/* See if there is room inside the child or its siblings. */
+	if (root->child) {
+		for (this = root->child; this; this = this->sibling) {
+			if (find_resource(this, new,
+					  size, min, max, align,
+					  alignf, alignf_data) == 0) {
+				return 0;
+			}
+		}
+	}
+
 	return -EBUSY;
 }
 
@@ -352,11 +374,21 @@ int allocate_resource(struct resource *root, struct resource *new,
 		      void *alignf_data)
 {
 	int err;
+	struct resource *parent, *first;
 
 	write_lock(&resource_lock);
 	err = find_resource(root, new, size, min, max, align, alignf, alignf_data);
-	if (err >= 0 && __request_resource(root, new))
-		err = -EBUSY;
+	if (err >= 0) {
+		for (parent = root;; parent = first) {
+			first = __request_resource(parent, new);
+			if (!first)
+				break;
+			if (first == parent) {
+				err = -EBUSY;
+				break;
+			}
+		}
+	}
 	write_unlock(&resource_lock);
 	return err;
 }
@@ -627,6 +659,11 @@ struct resource * __request_region(struct resource *parent,
 			parent = conflict;
 			if (!(conflict->flags & IORESOURCE_BUSY))
 				continue;
+			/* May have a duplicate that is not busy */
+			if (conflict->child) {
+				parent = conflict->child;
+				continue;
+			}
 		}
 
 		/* Uhhuh, that didn't work out.. */

