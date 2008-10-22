Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbYJVTAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbYJVTAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYJVTAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:00:44 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:35001 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbYJVTAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=p8aaQY065rXMvJnm8Fjxul1IBoM6EKBWPZTt6f0oWbMCT+pWk/xi+kXZYnIhhYFlLD
         GUznKhwo/EJy3cjw5q2C8MnqXDUGmiJHIslNSVTAQMv8XeBlfoSIH8n3Hesm+m9yu7oa
         pdik6+c3CKoVDGkzI8in+ugRVJr4O+foszUAo=
Date: Wed, 22 Oct 2008 23:00:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] SLUB: cleanup - define macroses instead of hardcoded
	numbers
Message-ID: <20081022190038.GD4218@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
---

 mm/slub.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Index: linux-2.6.git/mm/slub.c
===================================================================
--- linux-2.6.git.orig/mm/slub.c	2008-10-22 21:11:26.000000000 +0400
+++ linux-2.6.git/mm/slub.c	2008-10-22 22:53:43.000000000 +0400
@@ -153,6 +153,10 @@
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
 
+#define OO_SHIFT	16
+#define OO_MASK		((1 << OO_SHIFT) - 1)
+#define MAX_OBJS_PER_PAGE	65535 /* since page.objects is u16 */
+
 /* Internal SLUB flags */
 #define __OBJECT_POISON		0x80000000 /* Poison object */
 #define __SYSFS_ADD_DEFERRED	0x40000000 /* Not yet visible via sysfs */
@@ -290,7 +294,7 @@ static inline struct kmem_cache_order_ob
 						unsigned long size)
 {
 	struct kmem_cache_order_objects x = {
-		(order << 16) + (PAGE_SIZE << order) / size
+		(order << OO_SHIFT) + (PAGE_SIZE << order) / size
 	};
 
 	return x;
@@ -298,12 +302,12 @@ static inline struct kmem_cache_order_ob
 
 static inline int oo_order(struct kmem_cache_order_objects x)
 {
-	return x.x >> 16;
+	return x.x >> OO_SHIFT;
 }
 
 static inline int oo_objects(struct kmem_cache_order_objects x)
 {
-	return x.x & ((1 << 16) - 1);
+	return x.x & OO_MASK;
 }
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -764,8 +768,8 @@ static int on_freelist(struct kmem_cache
 	}
 
 	max_objects = (PAGE_SIZE << compound_order(page)) / s->size;
-	if (max_objects > 65535)
-		max_objects = 65535;
+	if (max_objects > MAX_OBJS_PER_PAGE)
+		max_objects = MAX_OBJS_PER_PAGE;
 
 	if (page->objects != max_objects) {
 		slab_err(s, page, "Wrong number of objects. Found %d but "
@@ -1819,8 +1823,8 @@ static inline int slab_order(int size, i
 	int rem;
 	int min_order = slub_min_order;
 
-	if ((PAGE_SIZE << min_order) / size > 65535)
-		return get_order(size * 65535) - 1;
+	if ((PAGE_SIZE << min_order) / size > MAX_OBJS_PER_PAGE)
+		return get_order(size * MAX_OBJS_PER_PAGE) - 1;
 
 	for (order = max(min_order,
 				fls(min_objects * size - 1) - PAGE_SHIFT);
