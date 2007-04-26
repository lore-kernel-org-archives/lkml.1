Return-Path: <linux-kernel-owner+w=401wt.eu-S1750907AbXDZRft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907AbXDZRft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbXDZRft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:35:49 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:60009 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbXDZRfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:35:47 -0400
Date: Thu, 26 Apr 2007 11:35:44 -0600
From: Mike Stroyan <mike.stroyan@hp.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       Mike Stroyan <mike.stroyan@hp.com>, "Luck, Tony" <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
Message-ID: <20070426173544.GA30744@ldl.fc.hp.com>
References: <20070425205548.fd51b301.akpm@linux-foundation.org> <46305A8D.2080003@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46305A8D.2080003@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 05:53:49PM +1000, Nick Piggin wrote:
> I had a couple of questions which I'm hoping someone would be kind
> enough to explain :)
...
> I wonder how this is different to all the other code which calls
> lazy_mmu_prot_update() after set_pte_at(). do_swap_page, for example,
> _could_ fault in executable code, couldn't it?

  The do_swap_page code does look suspect.  It seems to be working on
ia64 because a DMA transfer of data from swap to the allocated page
is removing old lines from the icache.  If code on an anonymous page
was swapping in without direct DMA to the page then the same problem
could occur.  I can't think of a reasonable situation that would cause
swapping in to not use DMA.  Swapping to/from NFS does not seem reasonable
to me anyway.

> It is because do_swap_page uses flush_icache_page()? So why doesn't
> the flush_icache_page() work in do_no_page as well? (It seems to look
> like a superset of lazy_mmu_prot_update on ia64?!?).

flush_icache_page() on ia64 is provided by include/asm-ia64/cacheflush.h.
It doesn't have any effect at all.

#define flush_icache_page(vma,page)             do { } while (0)

  lazy_mmu_prot_update() is supposed to get icache flushes done when they
need to be.  And it is supposed to avoid unneeded flushes when the icache
is known to be clean for a page.

-- 
Mike Stroyan, mike.stroyan@hp.com
