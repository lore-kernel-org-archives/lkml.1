Return-Path: <linux-kernel-owner+w=401wt.eu-S1761372AbZCaEp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372AbZCaEp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 00:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZCaEpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 00:45:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5636 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCaEpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 00:45:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=IbwUrBt2jlgKcW/U5EZUZeKHHo8j6cMv9K64wF/xNakvrnMpgLqGMhx7vqGPqZn77
	XOSanNvKqaZ7rs52YZOSg==
Date: Mon, 30 Mar 2009 21:44:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] slub: add per-cache slab thrash ratio
In-Reply-To: <alpine.DEB.2.00.0903301545200.30928@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0903302140250.27065@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <alpine.DEB.1.10.0903301026580.13333@qirst.com> <alpine.DEB.2.00.0903301309010.21074@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903301718080.25929@qirst.com> <alpine.DEB.2.00.0903301545200.30928@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, David Rientjes wrote:

> The way the code is currently written, this acts as an initialization when 
> there was no previous object count (i.e. its coming from 
> kmem_cache_open()) and acts as an adjustment when there was a previous 
> count (i.e. /sys/kernel/slab/cache/order was changed).  The only way to 
> avoid adding this to calculate_sizes() would be to add logic to 
> order_store() to adjust the watermark when the order changes, but that 
> duplicates the same calculation that is required for initialization if 
> s->min_free_watermark does get a default value in kmem_cache_open() as 
> Pekka suggested.

I applied the following to the patchset so that the initialization of the 
watermark is always separate from the updating as a result of changing 
/sys/kernel/slab/cache/order.

Since the setting of a default watermark in kmem_cache_open() will require 
a calculation to find the corresponding min_free_watermark depending on 
the object size for a pre-defined default ratio, it will require the same 
calculation that is now in order_store(), but I agree it's simpler to 
understand and justifies the code duplication.
---
diff --git a/mm/slub.c b/mm/slub.c
index 76fa5a6..61ae612 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2187,7 +2187,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	unsigned long flags = s->flags;
 	unsigned long size = s->objsize;
 	unsigned long align = s->align;
-	u16 thrash_ratio = 0;
 	int order;
 
 	/*
@@ -2293,13 +2292,10 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	/*
 	 * Determine the number of objects per slab
 	 */
-	if (oo_objects(s->oo))
-		thrash_ratio = s->min_free_watermark * 100 / oo_objects(s->oo);
 	s->oo = oo_make(order, size);
 	s->min = oo_make(get_order(size), size);
 	if (oo_objects(s->oo) > oo_objects(s->max))
 		s->max = s->oo;
-	s->min_free_watermark = oo_objects(s->oo) * thrash_ratio / 100;
 
 	return !!oo_objects(s->oo);
 
@@ -3824,6 +3820,7 @@ static ssize_t order_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
 	unsigned long order;
+	unsigned long thrash_ratio;
 	int err;
 
 	err = strict_strtoul(buf, 10, &order);
@@ -3833,7 +3830,9 @@ static ssize_t order_store(struct kmem_cache *s,
 	if (order > slub_max_order || order < slub_min_order)
 		return -EINVAL;
 
+	thrash_ratio = s->min_free_watermark * 100 / oo_objects(s->oo);
 	calculate_sizes(s, order);
+	s->min_free_watermark = oo_objects(s->oo) * thrash_ratio / 100;
 	return length;
 }
 
