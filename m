Return-Path: <linux-kernel-owner+w=401wt.eu-S932777AbYEISGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbYEISGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759946AbYEISGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:06:43 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:8098 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758223AbYEISGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:06:41 -0400
Subject: Re: Spinlocks waiting with interrupts disabled / preempt disabled.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Olaf Weber <olaf@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805091059050.19252@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
	 <20080507073017.GJ32195@elte.hu>  <bzymymzv3j7.fsf@fransum.emea.sgi.com>
	 <1210355814.13978.255.camel@twins>
	 <Pine.LNX.4.64.0805091059050.19252@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 09 May 2008 20:06:40 +0200
Message-Id: <1210356400.13978.262.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-09 at 11:00 -0700, Christoph Lameter wrote:
> On Fri, 9 May 2008, Peter Zijlstra wrote:
> 
> > > A third solution would be to look at this problem on a case-by-case
> > > basis.  In the case under discussion, there may be other kernel bugs
> > > that aggravate the problem (it is an old kernel after all) and maybe
> > > this just means the address_space.tree_lock ought to be replaced with
> > > something else (though I wouldn't claim to know what).
> > 
> > That has been done by Nick Piggin, the lockless pagecache work removes
> > the read side of the tree_lock.
> 
> When is that going to get merged? find_get_page is still:
> 
> struct page * find_get_page(struct address_space *mapping, pgoff_t offset)
> {
>         struct page *page;
> 
>         read_lock_irq(&mapping->tree_lock);
>         page = radix_tree_lookup(&mapping->page_tree, offset);
>         if (page)
>                 page_cache_get(page);
>         read_unlock_irq(&mapping->tree_lock);
>         return page;
> }
> EXPORT_SYMBOL(find_get_page);

Yeah, no idea when - although it looks like Nick has got another
speculative reference user lined up, which would greatly help its case.

Nick, can you post a series of patches against something recent that has
the latest lockless pagecache and all the fast_gup work in it, including
the power bits that use sepculative get?

We can then go over all this stuff and perhaps manage to trick Andrew
and Linus into taking it for .27.

Linus seemed interrested enough in the fast_gup bits.

And just in case someone forgot, the lockless pagecache has been in -rt
for a long long time - so far I've never seen issues with it.

