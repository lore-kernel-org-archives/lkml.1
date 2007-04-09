Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXDIStO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXDIStO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXDIStN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:49:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53331 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753424AbXDIStM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:49:12 -0400
Date: Mon, 9 Apr 2007 11:49:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Optimize compound_head() by avoiding a shared page
 flag
In-Reply-To: <20070409114545.3858d8f1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704091146320.8783@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
 <20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
 <20070406222336.4dcdd663.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704071509550.31503@schroedinger.engr.sgi.com>
 <20070407155148.94da92e8.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704071718530.31790@schroedinger.engr.sgi.com>
 <20070407182506.4386dc13.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704071825510.32544@schroedinger.engr.sgi.com>
 <20070407184801.b6f3f549.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704091105550.8331@schroedinger.engr.sgi.com>
 <20070409114545.3858d8f1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007, Andrew Morton wrote:

> > The patch adds PageTail(page) and PageHead(page) to check if a page is the
> > head or the tail of a compound page. This is done by masking the two
> > bits describing the state of a compound page and then comparing them. So 
> > one comparision and a branch instead of two bit checks and two branches.
> > 
> 
> OK.  I'm still a bit concerned about bypassing the bitops synchronisation:
> barriers, volatile, etc.  We had lengthy ruminations on that a few years
> ago, I think when working on free_pages_check().

Those are important for bits that are changing while a page is in use. 
These are constant.

> > +#define __SetPageTail(page)	page->flags |= PG_head_tail_mask
> > +#define __ClearPageTail(page)	page->flags ~= PG_head_tail_mask
> 
> hm.  The lack of parenthesisation here _might_ be OK, but I haven't
> thought it through.

This is a command and not an expression. Ok will inline.
 
> And I'd prefer not to have to, because I know that the do { } while (0)
> thing works.  As do static inline functions.
> 
> > +#define PageHead(page)	((page->flags & PG_head_tail_mask) \
> > +				== (1L << PG_compound))
> > +#define __SetPageHead(page)	__SetCompoundPage(page)
> > +#define __ClearPageHead(page)	__ClearCompoundPage(page)
> 
> You meant __SetPageCompound and __ClearPageCompound.

Right.

