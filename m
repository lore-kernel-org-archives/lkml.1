Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbXHYCQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbXHYCQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 22:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXHYCP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 22:15:57 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:33622 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbXHYCP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 22:15:57 -0400
Date: Fri, 24 Aug 2007 22:15:33 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] include linux/pagemap.h in asm-generic/tlb.h
Message-ID: <20070825021533.GA12544@c2.user-mode-linux.org>
References: <20070824184616.GA9442@c2.user-mode-linux.org> <20070824172027.0ad5d2c0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824172027.0ad5d2c0.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 05:20:27PM -0700, Andrew Morton wrote:
> This is worrisome.  If you look at pagemap.h, it includes a pile of things
> which could easily themsleves try to include tlb.h via some path or
> another.  I fear that this patch will cause explosions with some config
> and/or architecture.

I agree, I looked at the includes and had the same thoughts.  I sent
it in because there is a problem here, and it fixes a UML config
without noticably breaking anything else.

> So I think a better fix would be better, but I'm not able to suggest what,
> as there is little detail about the failure here and I can find no mention
> of page_cache_release and release_pages in asm-generic/tlb.h.  Presumably
> they're getting pulled in via some macro and then instantiated in some
> inline function or something?

Yes, it's straightforward - 

tlb.h:

static inline void
tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
{
	...
		free_pages_and_swap_cache(tlb->pages, tlb->nr);
	...
}

swap.h:
#define free_pages_and_swap_cache(pages, nr) \
	release_pages((pages), (nr), 0);

Feel free to drop it, and I'll look at this some more.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
