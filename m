Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYGRHko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYGRHko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbYGRHkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:40:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:50116 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbYGRHkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ZceBJYmc36vpPkGrQgPX3+M4a6ybnOGpVbye0dYgP+DVVgtn4oIVgTSJ+HHPpoyN0c
         oOwfvBKPkn5S1rVxab6BBxgMFiHVfMT2NzRdptCd8KAu79IgOhvrCOGPhcpAZEOIqniI
         RjWXmsRSSw/f46ZF5nZ8GYfPiOA9KPuzj7Lxo=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, gregkh@suse.de, lethal@linux-sh.org,
       i2c@lm-sensors.org, Magnus Damm <magnus.damm@gmail.com>,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 16:40:18 +0900
Message-Id: <20080718074018.32713.11976.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
Subject: [PATCH 02/05] resource: add resource_type() and IORESOURCE_TYPE_BITS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds resource_type() and IORESOURCE_TYPE_BITS. They make it
easier to add more resource types without having to rewrite tons of code.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/base/platform.c |   31 +++++++++++++++++--------------
 include/linux/ioport.h  |    7 ++++++-
 2 files changed, 23 insertions(+), 15 deletions(-)

--- 0001/drivers/base/platform.c
+++ work/drivers/base/platform.c	2008-07-09 20:19:16.000000000 +0900
@@ -42,10 +42,8 @@ struct resource *platform_get_resource(s
 	for (i = 0; i < dev->num_resources; i++) {
 		struct resource *r = &dev->resource[i];
 
-		if ((r->flags & (IORESOURCE_IO|IORESOURCE_MEM|
-				 IORESOURCE_IRQ|IORESOURCE_DMA)) == type)
-			if (num-- == 0)
-				return r;
+		if (type == resource_type(r) && num-- == 0)
+			return r;
 	}
 	return NULL;
 }
@@ -78,10 +76,8 @@ struct resource *platform_get_resource_b
 	for (i = 0; i < dev->num_resources; i++) {
 		struct resource *r = &dev->resource[i];
 
-		if ((r->flags & (IORESOURCE_IO|IORESOURCE_MEM|
-				 IORESOURCE_IRQ|IORESOURCE_DMA)) == type)
-			if (!strcmp(r->name, name))
-				return r;
+		if (type == resource_type(r) && !strcmp(r->name, name))
+			return r;
 	}
 	return NULL;
 }
@@ -259,9 +255,9 @@ int platform_device_add(struct platform_
 
 		p = r->parent;
 		if (!p) {
-			if (r->flags & IORESOURCE_MEM)
+			if (resource_type(r) == IORESOURCE_MEM)
 				p = &iomem_resource;
-			else if (r->flags & IORESOURCE_IO)
+			else if (resource_type(r) == IORESOURCE_IO)
 				p = &ioport_resource;
 		}
 
@@ -282,9 +278,14 @@ int platform_device_add(struct platform_
 		return ret;
 
  failed:
-	while (--i >= 0)
-		if (pdev->resource[i].flags & (IORESOURCE_MEM|IORESOURCE_IO))
-			release_resource(&pdev->resource[i]);
+	while (--i >= 0) {
+		struct resource *r = &pdev->resource[i];
+		unsigned long type = resource_type(r);
+
+		if (type == IORESOURCE_MEM || type == IORESOURCE_IO)
+			release_resource(r);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(platform_device_add);
@@ -306,7 +307,9 @@ void platform_device_del(struct platform
 
 		for (i = 0; i < pdev->num_resources; i++) {
 			struct resource *r = &pdev->resource[i];
-			if (r->flags & (IORESOURCE_MEM|IORESOURCE_IO))
+			unsigned long type = resource_type(r);
+
+			if (type == IORESOURCE_MEM || type == IORESOURCE_IO)
 				release_resource(r);
 		}
 	}
--- 0002/include/linux/ioport.h
+++ work/include/linux/ioport.h	2008-07-09 15:16:48.000000000 +0900
@@ -34,7 +34,8 @@ struct resource_list {
  */
 #define IORESOURCE_BITS		0x000000ff	/* Bus-specific bits */
 
-#define IORESOURCE_IO		0x00000100	/* Resource type */
+#define IORESOURCE_TYPE_BITS	0x00000f00	/* Resource type */
+#define IORESOURCE_IO		0x00000100
 #define IORESOURCE_MEM		0x00000200
 #define IORESOURCE_IRQ		0x00000400
 #define IORESOURCE_DMA		0x00000800
@@ -117,6 +118,10 @@ static inline resource_size_t resource_s
 {
 	return res->end - res->start + 1;
 }
+static inline unsigned long resource_type(struct resource *res)
+{
+	return res->flags & IORESOURCE_TYPE_BITS;
+}
 
 /* Convenience shorthand with allocation */
 #define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name))
