Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYFIS2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYFIS2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYFIS2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:28:01 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54706 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752154AbYFIS2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:28:00 -0400
Date: Mon, 9 Jun 2008 11:28:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Russ Anderson <rja@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 2/3] mm: Avoid putting a bad page back on the LRU v6
In-Reply-To: <20080609161933.GC14939@sgi.com>
Message-ID: <Pine.LNX.4.64.0806091123400.30605@schroedinger.engr.sgi.com>
References: <20080609161933.GC14939@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Russ Anderson wrote:

> -#define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
> +#define PAGE_FLAGS_BASE	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
>  			 1 << PG_buddy | 1 << PG_writeback | \
>  			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active)
> +
> +#ifdef CONFIG_PAGEFLAGS_EXTENDED
> +PAGEFLAG(MemError, memerror)
> +#define	PAGE_FLAGS	(PAGE_FLAGS_BASE | 1UL << PG_memerror)
> +#else
> +PAGEFLAG_FALSE(MemError)
> +#define	PAGE_FLAGS	(PAGE_FLAGS_BASE)
> +#endif

Hmmmm... That doesnt look nice. It would be good if we had some definition 
that  allows the simple oring with a flag mask. That mask should be 
zero if the flag is always false.

#ifdef CONFIG_PAGEFLAGS_EXTENDED
PAGEFLAG(MemError, memerror)
#define MemError_mask (1 << PG_memerror)
#else
PAGEFLAG_FALSE(MemError)
#define MemError_mask 0
#endif

#define	PAGE_FLAGS	(PAGE_FLAGS_BASE | MemError_mask)

Maybe we could have the PAGEFLAG and the PAGEFLAG_FALSE macros generate 
these definitions?

