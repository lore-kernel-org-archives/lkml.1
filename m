Return-Path: <linux-kernel-owner+w=401wt.eu-S1758494AbYJVR6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbYJVR6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYJVR6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:58:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:44260 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYJVR6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LLFdByfSM7ZTNHPs/5LCeBfncoFtsuaTB4UUjeDHrXA6cy3Uhor6YxAlZxHDLc+ncD
         HpVfuvDx0Of+LwSUsr5tdIeHZYfGzkGY7MvYRqmcV3dqwn/LxTUuiCC/bNbglFf/9Vd0
         TwxL2ttag3UFrk/poRHz5uON09tWbOTXQ0YGU=
Date: Wed, 22 Oct 2008 21:58:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
Message-ID: <20081022175827.GL9639@localhost>
References: <20081022161836.GG9639@localhost> <Pine.LNX.4.64.0810220926130.7633@quilx.com> <20081022163530.GH9639@localhost> <20081022165354.GI9639@localhost> <20081022172103.GJ9639@localhost> <Pine.LNX.4.64.0810221037320.7633@quilx.com> <48FF6800.20705@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF6800.20705@cs.helsinki.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Wed, Oct 22, 2008 at 08:50:56PM +0300]
> Christoph Lameter wrote:
>> On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:
>>
>>> Christoph how about this one?
>>
>> Ok. Looks a bit better but we still have two maxes here
>>
>> s->max which refers to the maximum number of objects per slab page for 
>> a specific slab cache (depends on the runtime configuration). 
>> OO_MAX_OBJS refers to the maximum number of objects per slab page that 
>> any slab cache can be configured for which is a compile time limit.
>>
>> Maybe this is okay, Pekka?
>
> Maybe call the page->objects maximum MAX_OBJS_PER_PAGE as it's not  
> strictly related to the other OO code?
>
> 		Pekka
>

Something like that?

		- Cyrill -
---

 mm/slub.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Index: linux-2.6.git/mm/slub.c
===================================================================
--- linux-2.6.git.orig/mm/slub.c	2008-10-22 21:11:26.000000000 +0400
+++ linux-2.6.git/mm/slub.c	2008-10-22 21:57:11.000000000 +0400
@@ -153,6 +153,10 @@
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
 
+#define OO_SHIFT	16
+#define OO_MASK		((1 << OO_SHIFT) - 1)
+#define MAX_OBJS_PER_PAGE	65535 /* see struct page.objects */
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
