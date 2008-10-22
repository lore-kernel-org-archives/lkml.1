Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYJVQSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYJVQSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYJVQSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:18:42 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:12955 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYJVQSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hXcRZk7bTCPPV6cjsoI0pHJwbe+xbTZ4Zi/AUqj11vq0Atdy2sfNXLBYAvpVlu/TBh
         qxdSav4PyYr2cWfOGCVpKfTM4/P1t1ENa19MWCwXKzqxJ1z64uJx3Egkd61uRUrio8tJ
         9/lMFHZCCR+i6mDvLtWCs16E3YqRrvW2r4AAw=
Date: Wed, 22 Oct 2008 20:18:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
Message-ID: <20081022161836.GG9639@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

Please check -- wouldn't it be better to use such a macro?
At least it makes easy to understand the 65535 constant is
coming from if only I didn't miss anything :)

 mm/slub.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Index: linux-2.6.git/mm/slub.c
===================================================================
--- linux-2.6.git.orig/mm/slub.c	2008-09-26 13:45:16.000000000 +0400
+++ linux-2.6.git/mm/slub.c	2008-10-22 20:10:59.000000000 +0400
@@ -153,6 +153,10 @@
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
 
+#define OO_SHIFT	16
+#define OO_MASK		((1 << OO_SHIFT) - 1)
+#define OO_MAX		OO_MASK
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
+	if (max_objects > OO_MAX)
+		max_objects = OO_MAX;
 
 	if (page->objects != max_objects) {
 		slab_err(s, page, "Wrong number of objects. Found %d but "
@@ -1819,8 +1823,8 @@ static inline int slab_order(int size, i
 	int rem;
 	int min_order = slub_min_order;
 
-	if ((PAGE_SIZE << min_order) / size > 65535)
-		return get_order(size * 65535) - 1;
+	if ((PAGE_SIZE << min_order) / size > OO_MAX)
+		return get_order(size * OO_MAX) - 1;
 
 	for (order = max(min_order,
 				fls(min_objects * size - 1) - PAGE_SHIFT);
