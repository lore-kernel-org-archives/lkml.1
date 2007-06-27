Return-Path: <linux-kernel-owner+w=401wt.eu-S1762742AbXF0TDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742AbXF0TDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbXF0TDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:03:16 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:53116 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbXF0TDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:03:16 -0400
Date: Wed, 27 Jun 2007 20:02:41 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Casey Leedom <casey_leedom@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: ZERO_PAGE() vs. loadable modules in Redhat 4.4 i386 kernels ...
In-Reply-To: <20070627181208.98426.qmail@web30504.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0706271956430.30942@blonde.wat.veritas.com>
References: <20070627181208.98426.qmail@web30504.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAAmluYm94AGNhc2V5X2xlZWRvbUB5YWhvby5jb20AbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Casey Leedom wrote:
> 
>   I'm working on a driver that does a get_user_pages() for a DMA write.  We
> have a timeout on the DMA completion where we mark the pages as COW and return
> to the application so it can potentially generate more data in order to
> increase throughput, etc.  The problem is that when we traverse the
> PGT/PUD/PMD/PTE hierarchy to mark the pages, we sometime fault out when the PUD
> covering [0x80000000, 0xc0000000) comes out as zero when that entire region is
> covered by a single large malloc()'ed buffer.  This happens because
> get_user_pages() returns a reference to empty_zero_page without passing through
> the fault path when a page is backed by anonymous memory.  I put a check this
> in my driver using ZERO_PAGE() and everything is great.  Except that it doesn't
> work on 32-bit i386 Redhat 4.4 kernels because the symbol for empty_zero_page
> is not only not exported via EXPORT_SYMBOL() but has also somehow been stripped
> from the kallsyms table.  This means that I can't check for the ZERO_PAGE() in
> a module.
> 
>  Can someone suggest a better way of doing this?  Either by some subterfuge to
> get empty_zero_page or perhaps by asking the kernel to instantiate the
> PGT/PUD/PMD/PTE hierarchy for a page?  I'm sort of stuck here.  Thanks for any
> help and/or advice you can offer.

I can't speak for Red Hat 4.4; but in general, you should be passing the
write flag to get_user_pages if you're going to modify the content of
those pages, which will then allocate the hierarchy needed and break
COW where necessary.  If that doesn't suit you (e.g. it's supposed to
be a readonly area in userspace), then you proably shouldn't be using
get_user_pages at all, but letting userspace mmap your driver pages
into its space instead.  Definitely don't play empty_zero_page games.

Hugh
