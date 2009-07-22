Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZGVT4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZGVT4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 15:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZGVT4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 15:56:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:51134 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbZGVT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 15:56:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Ohr8WYAXPtyk9jKqGdD3FS+3sTlGzlY2B1oQ3Npw+dpGCkgkA6Xp+XmSCUp+7eGGm
	uSymfUjg19ibMklOB1lWQ==
Message-ID: <4A676ECC.1090400@google.com>
Date: Wed, 22 Jul 2009 15:55:56 -0400
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       bblum@google.com, linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com
Subject: Re: [RFCv2][PATCH] flexible array implementation
References: <20090721220017.60A219D3@kernel>
In-Reply-To: <20090721220017.60A219D3@kernel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> Changes from v1:
> - to vs too typo
> - added __check_part_and_nr() and gave it a warning
> - fixed off-by-one check on __nr_part_ptrs()
> - addedFLEX_ARRAY_INIT() macro
> - some kerneldoc comments about the capacity
>   with various sized objects
> - comments to note lack of locking semantice
> 
> --
> 
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
>  linux-2.6.git-dave/include/linux/flex_array.h |   45 +++++
>  linux-2.6.git-dave/lib/Makefile               |    2 
>  linux-2.6.git-dave/lib/flex_array.c           |  230 ++++++++++++++++++++++++++
>  3 files changed, 276 insertions(+), 1 deletion(-)
> 
> diff -puN /dev/null include/linux/flex_array.h
> --- /dev/null	2008-09-02 09:40:19.000000000 -0700
> +++ linux-2.6.git-dave/include/linux/flex_array.h	2009-07-21 14:55:35.000000000 -0700
> @@ -0,0 +1,45 @@
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
> + * This is meant too replace cases where an array-like
> + * structure has gotten to big to fit into kmalloc()
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
> +#define FLEX_ARRAY_INIT(size, total) {{{\
> +	.element_size = (size),		\
> +	.nr_elements = 0,		\
> +}}}
> +

It's not clear how this guy is used.  It will initialize a flex_array, 
but how is somebody expected to free the parts that get associated with it?

Is there a fancy way to make declaring a flex_array on stack a 
compile-time error?
