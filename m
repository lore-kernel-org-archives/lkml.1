Return-Path: <linux-kernel-owner+w=401wt.eu-S965948AbXDGWQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965948AbXDGWQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 18:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965961AbXDGWQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 18:16:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41674 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965948AbXDGWQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 18:16:19 -0400
Date: Sat, 7 Apr 2007 15:16:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Optimize compound_head() by avoiding a shared page
 flag
In-Reply-To: <20070406222336.4dcdd663.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704071509550.31503@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
 <20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
 <20070406222336.4dcdd663.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007, Andrew Morton wrote:

> Did you investigate
> 
> static inline int page_tail(struct page *page)
> {
> 	return ((page->flags & (PG_compound|PG_tail)) == (PG_compound|PG_tail));
> }

The usual test_bit that we are using there uses a volatile reference 
so these wont be combined if I check them separately.

A working example of the above would be much uglier:

static inline int page_tail(struct page *page)
{
 	return ((page->flags & ((1L << PG_compound)|(1L << PG_tail))) == 
((1L << PG_compound)|(1L << PG_tail)));
}

May be this can be cleaned up somehow.

> 
> and
> 
> static inline int page_tail(struct page *page)
> {
> 	return unlikely(PageCompound(page)) && unlikely(PageTail(page));
> }

Two volatile references in the bit opes that the compiler cannot combine. 
Wont work unless we clean up the bitops first. This means we still have 
two branches in the code. Maybe I can make the first one work.

> In the latter case we _should_ have a not-taken branch to not-inline code. 
> If the compiler doesn't do that, we can make the PageTail() test an
> out-of-line function.  Or make the whole thing an uninlined function.

Still two branches which cannot be optimized in the same way as the single 
on on IA64 as shown by the asm that I included.
 
> More work needed, please.  I don't expect that a not-taken branch to
> not-inline code is worth a new page flag.  Especially as it does not
> actually reduce the number of branch decisions in the common case.

A new page flag does reduce the number of branches. On several platforms
it eliminates the branch completely since a single instruction can be
conditionally skipped.
 
> (I'm assuming in all of this that !PageCompound() is the very common case
> with slub.  If that is not true, we need to talk).

Yes, it is common for slabs to only have a single page.

The most promising avenue seems to be the simultaneous check for two bits.

