Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbZE3WdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbZE3WdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZE3WdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:33:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:41187 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbZE3WdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:33:01 -0400
Subject: Re: [PATCH] Change ZERO_SIZE_PTR to point at unmapped space
From: Peter Zijlstra <peterz@infradead.org>
To: "Larry H." <research@subreption.com>
Cc: linux-mm@kvack.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090530192829.GK6535@oblivion.subreption.com>
References: <20090530192829.GK6535@oblivion.subreption.com>
Content-Type: text/plain
Date: Sun, 31 May 2009 00:32:51 +0200
Message-Id: <1243722771.6645.162.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-30 at 12:28 -0700, Larry H. wrote:
> [PATCH] Change ZERO_SIZE_PTR to point at unmapped space
> 
> This patch changes the ZERO_SIZE_PTR address to point at top memory
> unmapped space, instead of the original location which could be
> mapped from userland to abuse a NULL (or offset-from-null) pointer
> dereference scenario.

Same goes for the regular NULL pointer, we have bits to disallow
userspace mapping the NULL page, so I'm not exactly seeing what this
patch buys us.

> The ZERO_OR_NULL_PTR macro is changed accordingly. This patch does
> not modify its behavior nor has any performance nor functionality
> impact.

It does generate longer asm.

> The original change was written first by the PaX team for their
> patch.
> 
> Signed-off-by: Larry Highsmith <larry@subreption.com>
> 
> Index: linux-2.6/include/linux/slab.h
> ===================================================================
> --- linux-2.6.orig/include/linux/slab.h
> +++ linux-2.6/include/linux/slab.h
> @@ -73,10 +73,9 @@
>   * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
>   * Both make kfree a no-op.
>   */
> -#define ZERO_SIZE_PTR ((void *)16)
> +#define ZERO_SIZE_PTR ((void *)-1024L)
>  
> -#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
> -				(unsigned long)ZERO_SIZE_PTR)
> +#define ZERO_OR_NULL_PTR(x) (!(x) || (x) == ZERO_SIZE_PTR)
>  
>  /*
>   * struct kmem_cache related prototypes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

