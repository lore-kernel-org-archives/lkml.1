Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbZGHGkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbZGHGkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbZGHGkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:40:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60495 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399AbZGHGkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:40:46 -0400
Subject: Re: [RFC PATCH 1/3] kmemleak: Allow partial freeing of memory
 blocks
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org
In-Reply-To: <tnxiqi4vchj.fsf@pc1117.cambridge.arm.com>
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com>
	 <20090706105149.16051.99106.stgit@pc1117.cambridge.arm.com>
	 <1246950733.24285.10.camel@penberg-laptop>
	 <tnxtz1ovq8p.fsf@pc1117.cambridge.arm.com>
	 <tnxiqi4vchj.fsf@pc1117.cambridge.arm.com>
Date: Wed, 08 Jul 2009 09:40:43 +0300
Message-Id: <1247035243.15919.28.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 14:39 +0100, Catalin Marinas wrote:
> @@ -552,8 +557,27 @@ static void delete_object(unsigned long ptr)
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
> +	 * from the memory block split. Note that partial freeing is only done
> +	 * by free_bootmem() and this happens before kmemleak_init() is
> +	 * called. The path below is only executed during early log recording
> +	 * in kmemleak_init(), so GFP_KERNEL is enough.
> +	 */
> +	if (ptr > start)
> +		create_object(start, ptr - start, min_count, GFP_KERNEL);
> +	if (ptr + size < end)
> +		create_object(ptr + size, end - ptr - size, min_count,
> +			      GFP_KERNEL);
>  }

Looks good to me. I think it would be better to have
delete_object_full() and delete_object_part(), and extract the common
code to __delete_object() or something instead of passing the magic zero
from kmemleak_free().

In any case:

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

			Pekka

