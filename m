Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbZFYNiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbZFYNiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZFYNiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:38:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39376 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbZFYNiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:38:06 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC PATCH] resource: shared I/O region support
To: linux-kernel@vger.kernel.org
Date: Thu, 25 Jun 2009 15:36:34 +0100
Message-ID: <20090625143514.4132.95249.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

SuperIO devices share regions and use lock/unlock operations to chip select.
We therefore need to be able to request a resource and wait for it to be
freed by whichever other SuperIO device currently hogs it. Right now you
have to poll which is horrible.

Add a MUXED field to IO port resources. If the MUXED field is set on the
resource and on the request (via request_muxed_region) then we block until
the previous owner of the muxed resource releases their region.

This allows us to implement proper resource sharing and locking for superio
chips using code of the form

enable_my_superio_dev() {
	request_muxed_region(0x44, 0x02, "superio:watchdog");
	outb() ..sequence to enable chip
}

disable_my_superio_dev() {
	outb() .. sequence of disable chip
	release_region(0x44, 0x02);
}


Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 include/linux/ioport.h |    4 +++-
 kernel/resource.c      |   14 +++++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)


diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 786e7b8..c9a3a41 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -50,6 +50,7 @@ struct resource_list {
 #define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
 
 #define IORESOURCE_MEM_64	0x00100000
+#define IORESOURCE_MUXED	0x00200000	/* Resource is software muxed */
 
 #define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resource */
 #define IORESOURCE_DISABLED	0x10000000
@@ -136,7 +137,8 @@ static inline unsigned long resource_type(struct resource *res)
 }
 
 /* Convenience shorthand with allocation */
-#define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name), 0)
+#define request_region(start,n,name)		__request_region(&ioport_resource, (start), (n), (name), 0)
+#define request_muxed_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name), IORESOURCE_MUXED)
 #define __request_mem_region(start,n,name, excl) __request_region(&iomem_resource, (start), (n), (name), excl)
 #define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name), 0)
 #define request_mem_region_exclusive(start,n,name) \
diff --git a/kernel/resource.c b/kernel/resource.c
index ac5f3a3..7f47f0b 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -592,6 +592,8 @@ resource_size_t resource_alignment(struct resource *res)
  * release_region releases a matching busy region.
  */
 
+static DECLARE_WAIT_QUEUE_HEAD(muxed_resource_wait);
+
 /**
  * __request_region - create a new busy resource region
  * @parent: parent resource descriptor
@@ -604,6 +606,7 @@ struct resource * __request_region(struct resource *parent,
 				   resource_size_t start, resource_size_t n,
 				   const char *name, int flags)
 {
+	DECLARE_WAITQUEUE(wait, current);
 	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 
 	if (!res)
@@ -628,7 +631,14 @@ struct resource * __request_region(struct resource *parent,
 			if (!(conflict->flags & IORESOURCE_BUSY))
 				continue;
 		}
-
+		if (conflict->flags & flags & IORESOURCE_MUXED) {
+			add_wait_queue(&muxed_resource_wait, &wait);
+			write_unlock(&resource_lock);
+			schedule();
+			remove_wait_queue(&muxed_resource_wait, &wait);
+			write_lock(&resource_lock);
+			continue;
+		}
 		/* Uhhuh, that didn't work out.. */
 		kfree(res);
 		res = NULL;
@@ -702,6 +712,8 @@ void __release_region(struct resource *parent, resource_size_t start,
 				break;
 			*p = res->sibling;
 			write_unlock(&resource_lock);
+			if (res->flags & IORESOURCE_MUXED)
+				wake_up(&muxed_resource_wait);
 			kfree(res);
 			return;
 		}

