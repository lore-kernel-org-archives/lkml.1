Return-Path: <linux-kernel-owner+w=401wt.eu-S932976AbZHUXVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976AbZHUXVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932932AbZHUXVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:21:54 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbZHUXVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:21:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=mUEQvaneoo9z4sw8I90BBnUPI9dtsO1hePraMwAGnnUssCYULpvCu4v2G7kL2oUoc
	Wj4UXwepWqH5JN44rdkqw==
Date: Fri, 21 Aug 2009 16:21:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch 3/4 -mm] flex_array: poison free elements
In-Reply-To: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newly initialized flex_array's and/or flex_array_part's are now poisoned
with a new poison value, FLEX_ARRAY_FREE.  It's value is similar to
POISON_FREE used in the various slab allocators, but is different to
distinguish between flex array's poisoned kmem and slab allocator
poisoned kmem.

This will allow us to identify flex_array_part's that only contain free
elements (and free them with an addition to the flex_array API).  This
could also be extended in the future to identify `get' uses on elements
that have not been `put'.

If __GFP_ZERO is passed for a part's gfp mask, the poisoning is avoided.
These elements are considered to be in-use since they have been
initialized.

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/poison.h |    3 +++
 lib/flex_array.c       |   15 +++++++--------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/poison.h b/include/linux/poison.h
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -65,6 +65,9 @@
 #define MUTEX_DEBUG_INIT	0x11
 #define MUTEX_DEBUG_FREE	0x22
 
+/********** lib/flex_array.c **********/
+#define FLEX_ARRAY_FREE	0x6c	/* for use-after-free poisoning */
+
 /********** security/ **********/
 #define KEY_DESTROY		0xbd
 
diff --git a/lib/flex_array.c b/lib/flex_array.c
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -113,6 +113,8 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 		return NULL;
 	ret->element_size = element_size;
 	ret->total_nr_elements = total;
+	if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
+		memset(ret->parts[0], FLEX_ARRAY_FREE, bytes_left_in_base());
 	return ret;
 }
 
@@ -159,15 +161,12 @@ __fa_get_part(struct flex_array *fa, int part_nr, gfp_t flags)
 {
 	struct flex_array_part *part = fa->parts[part_nr];
 	if (!part) {
-		/*
-		 * This leaves the part pages uninitialized
-		 * and with potentially random data, just
-		 * as if the user had kmalloc()'d the whole.
-		 * __GFP_ZERO can be used to zero it.
-		 */
-		part = kmalloc(FLEX_ARRAY_PART_SIZE, flags);
+		part = kmalloc(sizeof(struct flex_array_part), flags);
 		if (!part)
 			return NULL;
+		if (!(flags & __GFP_ZERO))
+			memset(part, FLEX_ARRAY_FREE,
+				sizeof(struct flex_array_part));
 		fa->parts[part_nr] = part;
 	}
 	return part;
@@ -228,7 +227,7 @@ int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
 			return -EINVAL;
 	}
 	dst = &part->elements[index_inside_part(fa, element_nr)];
-	memset(dst, 0, fa->element_size);
+	memset(dst, FLEX_ARRAY_FREE, fa->element_size);
 	return 0;
 }
 
