Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbZGUQsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbZGUQsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZGUQsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:48:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:11454 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZGUQsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:48:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Kw80Zpk8RN3NlWL/mH0E97rl1fcK0YwG6/2ApauzUx+mSPaoumrt3nqBx4lw5OKrE
	CVdwJ2Df5a59yVWEq1uew==
Message-ID: <4A65F13D.6060506@google.com>
Date: Tue, 21 Jul 2009 12:47:57 -0400
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, menage@google.com,
       containers@lists.linux-foundation.org, bblum@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] flexible array implementation
References: <20090721160333.96AA4D3D@kernel>
In-Reply-To: <20090721160333.96AA4D3D@kernel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> Once a structure goes over PAGE_SIZE*2, we see occasional
> allocation failures.  Some people have chosen to switch
> over to things like vmalloc() that will let them keep
> array-like access to such a large structures.  But,
> vmalloc() has plenty of downsides.
> 
> Here's an alternative.  I think it's what Andrew was
> suggesting  here:
> 
> 	http://lkml.org/lkml/2009/7/2/518 
> 
> I call it a flexible array.  It does all of its work in
> PAGE_SIZE bits, so never does an order>0 allocation.
> The base level has PAGE_SIZE-2*sizeof(int) bytes of
> storage for pointers to the second level.  So, with a
> 32-bit arch, you get about 4MB (4183112 bytes) of total
> storage when the objects pack nicely into a page.  It
> is half that on 64-bit because the pointers are twice
> the size.
> 
> The interface is dirt simple.  4 functions:
> 	alloc_flex_array()
> 	free_flex_array()
> 	flex_array_put()
> 	flex_array_get()
> 
> put() appends an item into the array while get() takes
> indexes and does array-style access.
> 
> One thought is that we should perhaps make the base
> structure half the size on 32-bit arches.  That will
> ensure that someone testing on 32-bit will not get
> bitten by the size shrinking by half when moving to
> 64-bit.
> 
> We could also potentially just pass the "element_size"
> into each of the API functions instead of storing it
> internally.  That would get us one more base pointer
> on 32-bit.
> 
> The last improvement that I thought about was letting
> the individual array members span pages.  In this
> implementation, if you have a 2049-byte object, it
> will only pack one of them into each "part" with
> no attempt to pack them.  At this point, I don't think
> the added complexity would be worth it.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/include/linux/flex_array.h |   39 ++++++
>  linux-2.6.git-dave/lib/Makefile               |    2 
>  linux-2.6.git-dave/lib/flex_array.c           |  163 ++++++++++++++++++++++++++
>  3 files changed, 203 insertions(+), 1 deletion(-)
> 
> diff -puN /dev/null include/linux/flex_array.h
> --- /dev/null	2008-09-02 09:40:19.000000000 -0700
> +++ linux-2.6.git-dave/include/linux/flex_array.h	2009-07-20 15:43:50.000000000 -0700
> @@ -0,0 +1,39 @@
> +#ifndef _FLEX_ARRAY_H
> +#define _FLEX_ARRAY_H
> +
> +#include <linux/types.h>
> +#include <asm/page.h>
> +
> +#define FLEX_ARRAY_PART_SIZE PAGE_SIZE
> +#define FLEX_ARRAY_BASE_SIZE PAGE_SIZE
> +
> +struct flex_array_part;
> +
> +/*
> + * This is meant to replace cases where an array-like
> + * structure has gotten to big to fit into kmalloc()

s/to/too/g

> + * and the developer is getting tempted to use
> + * vmalloc().
> + */
> +
> +struct flex_array {
> +	union {
> +		struct {
> +			int nr_elements;
> +			int element_size;
> +			struct flex_array_part *parts[0];
> +		};
> +		/*
> +		 * This little trick makes sure that
> +		 * sizeof(flex_array) == PAGE_SIZE
> +		 */
> +		char padding[FLEX_ARRAY_BASE_SIZE];
> +	};
> +};
> +
> +struct flex_array *alloc_flex_array(int element_size, int total, gfp_t flags);
> +void free_flex_array(struct flex_array *fa);
> +int flex_array_put(struct flex_array *fa, void *src, gfp_t flags);
> +void *flex_array_get(struct flex_array *fa, int element_nr);

Would a single routine that acted like an lvalue be a bit clearer?  Here 
it looks like the interface is a push to write, but random access to 
read.  Something like:

void **__flex_array_idx(struct flex_rray *fa, int element_nr);
#define flex_array_idx(fa, element_nr) (*__flex_array_idx(fa, element_nr))

may be a bit easier to read so users of the interface could just do:

flex_array_idx(fa, n) = pointer;
pointer = flex_array_idx(fa, n);

I guess this would require that flex_array only store actual pointers 
though, instead of objects.  Hmm.


Is there any reason you defer allocation of parts to flex_array_put() 
given that alloc_flex_array() is told the total number of elements?

> +
> +#endif /* _FLEX_ARRAY_H */
> diff -puN /dev/null lib/flex_array.c
> --- /dev/null	2008-09-02 09:40:19.000000000 -0700
> +++ linux-2.6.git-dave/lib/flex_array.c	2009-07-20 15:44:09.000000000 -0700
> @@ -0,0 +1,163 @@
> +/*
> + * Flexible array managed in PAGE_SIZE parts
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright IBM Corporation, 2009
> + *
> + * Author: Dave Hansen <dave@linux.vnet.ibm.com>
> + */
> +
> +#include <linux/flex_array.h>
> +#include <linux/slab.h>
> +#include <linux/stddef.h>
> +
> +struct flex_array_part {
> +	char elements[FLEX_ARRAY_PART_SIZE];
> +};
> +
> +static inline int __elements_per_part(int element_size)
> +{
> +	return FLEX_ARRAY_PART_SIZE / element_size;

Micro-optimization, but perhaps the general case could use a bit shift 
stored inside the flex_array?  That way we could avoid excessive divide 
operations.

> +}
> +
> +static inline int __nr_part_ptrs(void)
> +{
> +	int element_offset = offsetof(struct flex_array, parts);
> +	int bytes_left = FLEX_ARRAY_BASE_SIZE - element_offset;
> +	return bytes_left / sizeof(struct flex_array_part *);
> +}
> +
> +/**
> + * alloc_flex_array - allocate a new flexible array
> + * @element_size:	the size of individual elements in the array
> + * @total:		total number of elements that this should hold
> + *
> + * We do not actually use @total to size the allocation at this
> + * point.  It is just used to ensure that the user does not try
> + * to use this structure for something larger than it can handle
> + * later on.
> + */
> +struct flex_array *alloc_flex_array(int element_size, int total, gfp_t flags)
> +{
> +	struct flex_array *ret;
> +	int max_size = __nr_part_ptrs() * __elements_per_part(element_size);
> +
> +	/* max_size will end up 0 if element_size > PAGE_SIZE */
> +	if (total > max_size)
> +		return NULL;
> +	ret = kzalloc(sizeof(struct flex_array), flags);
> +	if (!ret)
> +		return NULL;
> +	ret->element_size = element_size;
> +	return ret;
> +}
> +
> +static int fa_element_to_part_nr(struct flex_array *fa, int element_nr)
> +{
> +	return element_nr / __elements_per_part(fa->element_size);
> +}
> +
> +void free_flex_array(struct flex_array *fa)
> +{
> +	int part_nr;
> +	int max_part;
> +
> +	/* keeps us from getting the index of -1 below */
> +	if (!fa->nr_elements)
> +		goto free_base;
> +
> +	/* we really want the *index* of the last element, thus the -1 */
> +	max_part = fa_element_to_part_nr(fa, fa->nr_elements-1);
> +	for (part_nr = 0; part_nr <= max_part; part_nr++)
> +		kfree(fa->parts[part_nr]);
> +free_base:
> +	kfree(fa);
> +}
> +
> +static int fa_index_inside_part(struct flex_array *fa, int element_nr)
> +{
> +	return (element_nr % __elements_per_part(fa->element_size));
> +}
> +
> +static int offset_inside_part(struct flex_array *fa, int element_nr)
> +{
> +	int part_offset = fa_index_inside_part(fa, element_nr);
> +	return part_offset * fa->element_size;
> +}
> +
> +static inline struct flex_array_part *
> +__fa_get_part(struct flex_array *fa, int part_nr, gfp_t flags)
> +{
> +	struct flex_array_part *part = NULL;
> +	if (part_nr > __nr_part_ptrs())
> +		return NULL;
> +	part = fa->parts[part_nr];
> +	if (!part) {
> +		part = kmalloc(FLEX_ARRAY_PART_SIZE, flags);
> +		if (!part)
> +			return NULL;
> +		fa->parts[part_nr] = part;
> +	}
> +	return part;
> +}
> +
> +/**
> + * flex_array_put - append a new member into the array
> + * @src:	address of data to copy into the array
> + *
> + * Note that this *copies* the contents of @src into
> + * the array.  If you are trying to store an array of
> + * pointers, make sure to pass in &ptr instead of ptr.
> + */
> +int flex_array_put(struct flex_array *fa, void *src, gfp_t flags)
> +{
> +	int element_nr = fa->nr_elements;
> +	int part_nr = fa_element_to_part_nr(fa, element_nr);
> +	struct flex_array_part *part;
> +	void *dst;
> +
> +	part = __fa_get_part(fa, part_nr, flags);
> +	if (!part)
> +		return -ENOMEM;
> +	dst = &part->elements[offset_inside_part(fa, element_nr)];
> +	fa->nr_elements++;
> +	memcpy(dst, src, fa->element_size);
> +	return 0;
> +}
> +
> +/**
> + * flex_array_get - pull data back out of the array
> + * @element_nr:	index of the element to fetch from the array
> + *
> + * Returns a pointer to the data at index @element_nr.  Note
> + * that this is a copy of the data that was passed in.  If you
> + * are using this to store pointers, you'll get back &ptr.
> + */
> +void *flex_array_get(struct flex_array *fa, int element_nr)
> +{
> +	int part_nr = fa_element_to_part_nr(fa, element_nr);
> +	struct flex_array_part *part;
> +	int offset;
> +
> +	if (part_nr > __nr_part_ptrs())

if (part_nr >= __nr_part_ptrs())

> +		return NULL;

ERR_PTR(-EINVAL) ?

Would it make sense to WARN here?  A more precise test could be to 
compare element_nr vs fa->nr_elements?

> + 	if (!fa->parts[part_nr])
> +		return NULL;
> +
> +	part = fa->parts[part_nr];
> +	offset = offset_inside_part(fa, element_nr);
> +	return &part->elements[offset_inside_part(fa, element_nr)];
> +}
> diff -puN lib/Makefile~fa lib/Makefile
> --- linux-2.6.git/lib/Makefile~fa	2009-07-16 11:40:31.000000000 -0700
> +++ linux-2.6.git-dave/lib/Makefile	2009-07-20 15:44:11.000000000 -0700
> @@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
>  	 idr.o int_sqrt.o extable.o prio_tree.o \
>  	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
>  	 proportions.o prio_heap.o ratelimit.o show_mem.o \
> -	 is_single_threaded.o plist.o decompress.o
> +	 is_single_threaded.o plist.o decompress.o flex_array.o
>  
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
> _
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers

