Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbZLVXD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbZLVXD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 18:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZLVXDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 18:03:50 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56862 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbZLVXDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 18:03:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 22 Dec 2009 15:02:22 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/14] resource: add release_child_resources
In-reply-to: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1261522954-12591-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.0.2
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-v2: change name to release_child_resources according to Jesse
-v3: according to Linus, move release_child_resources to resource.c
     also need to put the lock around them all to avoid recursive deep.
     (my test case only have one level that need to be released)
-v4: seperate to another patch

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/ioport.h |    1 +
 kernel/resource.c      |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 83aa812..23a5fd1 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -112,6 +112,7 @@ extern struct resource iomem_resource;
 
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
+void release_child_resources(struct resource *new);
 extern void reserve_region_with_split(struct resource *root,
 			     resource_size_t start, resource_size_t end,
 			     const char *name);
diff --git a/kernel/resource.c b/kernel/resource.c
index dc15686..5051617 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -188,6 +188,36 @@ static int __release_resource(struct resource *old)
 	return -EINVAL;
 }
 
+static void __release_child_resources(struct resource *r)
+{
+	struct resource *tmp, *p;
+	resource_size_t size;
+
+	p = r->child;
+	r->child = NULL;
+	while (p) {
+		tmp = p;
+		p = p->sibling;
+
+		tmp->parent = NULL;
+		tmp->sibling = NULL;
+		__release_child_resources(tmp);
+
+		printk(KERN_DEBUG "release child resource %pR\n", tmp);
+		/* need to restore size, and keep flags */
+		size = resource_size(tmp);
+		tmp->start = 0;
+		tmp->end = size - 1;
+	}
+}
+
+void release_child_resources(struct resource *r)
+{
+	write_lock(&resource_lock);
+	__release_child_resources(r);
+	write_unlock(&resource_lock);
+}
+
 /**
  * request_resource - request and reserve an I/O or memory resource
  * @root: root resource descriptor
-- 
1.6.0.2

