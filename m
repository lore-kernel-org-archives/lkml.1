Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbZGGHMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbZGGHMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZGGHMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:12:12 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43391 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZGGHML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:12:11 -0400
Subject: Re: [RFC PATCH 1/3] kmemleak: Allow partial freeing of memory
 blocks
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org
In-Reply-To: <20090706105149.16051.99106.stgit@pc1117.cambridge.arm.com>
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com>
	 <20090706105149.16051.99106.stgit@pc1117.cambridge.arm.com>
Date: Tue, 07 Jul 2009 10:12:13 +0300
Message-Id: <1246950733.24285.10.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 11:51 +0100, Catalin Marinas wrote:
> @@ -552,8 +558,29 @@ static void delete_object(unsigned long ptr)
>  	 */
>  	spin_lock_irqsave(&object->lock, flags);
>  	object->flags &= ~OBJECT_ALLOCATED;
> +	start = object->pointer;
> +	end = object->pointer + object->size;
> +	min_count = object->min_count;
>  	spin_unlock_irqrestore(&object->lock, flags);
>  	put_object(object);
> +
> +	if (!size)
> +		return;
> +
> +	/*
> +	 * Partial freeing. Just create one or two objects that may result
> +	 * from the memory block split.
> +	 */
> +	if (in_atomic())
> +		gfp_flags = GFP_ATOMIC;
> +	else
> +		gfp_flags = GFP_KERNEL;

Are you sure we can do this? There's a big fat comment on top of
in_atomic() that suggest this is not safe. Why do we need to create the
object here anyway and not in the _alloc_ paths where gfp flags are
explicitly passed?

> +
> +	if (ptr > start)
> +		create_object(start, ptr - start, min_count, gfp_flags);
> +	if (ptr + size < end)
> +		create_object(ptr + size, end - ptr - size, min_count,
> +			      gfp_flags);
>  }
>  
>  /*


