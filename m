Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbXHBFdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbXHBFdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 01:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXHBFdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 01:33:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47516 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751071AbXHBFdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 01:33:08 -0400
Date: Wed, 1 Aug 2007 22:33:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] type safe allocator
In-Reply-To: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0708012223520.3265@schroedinger.engr.sgi.com>
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007, Miklos Szeredi wrote:

> I wonder why we don't have type safe object allocators a-la new() in
> C++ or g_new() in glib?
> 
>   fooptr = k_new(struct foo, GFP_KERNEL);
> 
> is nicer and more descriptive than
> 
>   fooptr = kmalloc(sizeof(*fooptr), GFP_KERNEL);
> 
> and more safe than
> 
>   fooptr = kmalloc(sizeof(struct foo), GFP_KERNEL);
> 
> And we have zillions of both variants.

Hmmm yes I think that would be good. However, please clean up the naming.
The variant on zeroing on zering get to be too much.

> + * k_new - allocate given type object
> + * @type: the type of the object to allocate
> + * @flags: the type of memory to allocate.
> + */
> +#define k_new(type, flags) ((type *) kmalloc(sizeof(type), flags))

kalloc?

> +
> + * k_new0 - allocate given type object, zero out allocated space
> + * @type: the type of the object to allocate
> + * @flags: the type of memory to allocate.
> + */
> +#define k_new0(type, flags) ((type *) kzalloc(sizeof(type), flags))

A new notation for zeroing! This is equivalent to

kalloc(type, flags | __GFP_ZERO)

maybe define new GFP_xxx instead?

> +/**
> + * k_new_array - allocate array of given type object
> + * @type: the type of the object to allocate
> + * @len: the length of the array
> + * @flags: the type of memory to allocate.
> + */
> +#define k_new_array(type, len, flags) \
> +	((type *) kmalloc(sizeof(type) * (len), flags))

We already have array initializations using kcalloc.

> +#define k_new0_array(type, len, flags) \
> +	((type *) kzalloc(sizeof(type) * (len), flags))

Same as before.


I do not see any _node variants?

How about the following minimal set


kmalloc(size, flags)		kalloc(struct, flags)
kmalloc_node(size, flags, node)	kalloc_node(struct, flags, node)


The array variants translate into kmalloc anyways and are used
in an inconsistent manner. Sometime this way sometimes the other. Leave 
them?

	kcalloc(n, size, flags) == kmalloc(size, flags)

Then kzalloc is equivalent to adding the __GFP_ZERO flag. Thus

	kzalloc(size, flags) == kmalloc(size, flags | __GFPZERO)

If you define a new flag like GFP_ZERO_ATOMIC and GFP_ZERO_KERNEL you 
could do

	kalloc(struct, GFP_ZERO_KERNEL)

instead of adding new variants?

