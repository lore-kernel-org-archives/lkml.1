Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYJVRVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYJVRVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYJVRVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:21:10 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:18120 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbYJVRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pZfpXk6uuVugKxF/haE4IZsF1UJIW6IyU6zzA58qInZbp8t+uspSeS5e0bvM07AKSR
         5TXn8PuafYCMFtoqgPqSYmtVPrulcmtGg/pUsqrUTJaBZS2zokJwJa+H3zo0mzxCQd/B
         zkPit0EYCNqlF40TFImXtXUUbtxVIiDMjNd5g=
Date: Wed, 22 Oct 2008 21:21:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
Message-ID: <20081022172103.GJ9639@localhost>
References: <20081022161836.GG9639@localhost> <Pine.LNX.4.64.0810220926130.7633@quilx.com> <20081022163530.GH9639@localhost> <20081022165354.GI9639@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022165354.GI9639@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Wed, Oct 22, 2008 at 08:53:54PM +0400]
| [Cyrill Gorcunov - Wed, Oct 22, 2008 at 08:35:30PM +0400]
| | [Christoph Lameter - Wed, Oct 22, 2008 at 09:28:14AM -0700]
| | > On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:
| | >
| | >> Please check -- wouldn't it be better to use such a macro?
| | >
| | > Looks good. But could you rename OO_MAX to something different? There is  
| | > already s->max which may cause confusion because s->max is the maximum  
| | > number of objects in a slab. OO_MAX is the maximum mask?
| | >
| | 
| | I supposed it would mean maximum object number inside page (ie quantity) which
| | is happen to be the same value as OO_MASK. Maybe OO_MAX_OBJ?
| | 
| | 		- Cyrill -
| 
| Btw Christoph fix me if I'm wrong but this 65535 is directly related to
| 16 bit shift. If we change the first value without changing the second we
| just break the SLUB I guess. I didn't read/understand SLUB code in details
| so could be wrong.
| 
| 		- Cyrill -

Christoph how about this one?

		- Cyrill -
---

 mm/slub.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Index: linux-2.6.git/mm/slub.c
===================================================================
--- linux-2.6.git.orig/mm/slub.c	2008-10-22 21:11:26.000000000 +0400
+++ linux-2.6.git/mm/slub.c	2008-10-22 21:19:12.000000000 +0400
@@ -153,6 +153,10 @@
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
 
+#define OO_SHIFT	16
+#define OO_MASK		((1 << OO_SHIFT) - 1)
+#define OO_MAX_OBJS	65535 /* see struct page.objects */
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
+	if (max_objects > OO_MAX_OBJS)
+		max_objects = OO_MAX_OBJS;
 
 	if (page->objects != max_objects) {
 		slab_err(s, page, "Wrong number of objects. Found %d but "
@@ -1819,8 +1823,8 @@ static inline int slab_order(int size, i
 	int rem;
 	int min_order = slub_min_order;
 
-	if ((PAGE_SIZE << min_order) / size > 65535)
-		return get_order(size * 65535) - 1;
+	if ((PAGE_SIZE << min_order) / size > OO_MAX_OBJS)
+		return get_order(size * OO_MAX_OBJS) - 1;
 
 	for (order = max(min_order,
 				fls(min_objects * size - 1) - PAGE_SHIFT);
