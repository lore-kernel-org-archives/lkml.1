Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbXDFRBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbXDFRBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbXDFRBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:01:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41912 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750978AbXDFRBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:01:39 -0400
Date: Fri, 6 Apr 2007 10:01:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Make page->private usable in compound pages V1
In-Reply-To: <20070405164300.a5d24329.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704060958430.25652@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
 <20070405164300.a5d24329.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007, Andrew Morton wrote:

> > We add PageTail as an alias of PageReclaim. Compound pages cannot
> > currently be reclaimed. Because of the alias one needs to check
> > PageCompound first.
> 
> So slub is using compound pages so that it can locate the head page in
> higher-order pages, whereas slab uses per-object (or per-order-0-page?)
> metadata for that?

Both SLAB and SLUB use compound pages.

> 
> I see four instances of
> 
> +	page = virt_to_page(p);
> +
> +	if (unlikely(PageCompound(page)))
> +		page = page->first_page;
> 
> A new virt_to_head_page() is needed.

Ok.
 
 > Sigh.  We're seeing rather a lot of churn to accommodate slub.  Do we
> actually have any justification for all this?  If we end up deciding to
> merge slub and to deprecate then remove slab, what would our reasons have
> been?

This is not SLUB specific. SLAB does the same. SLAB does special casing 
for page size slabs and does not allow slab debugging because it would 
use page->private if debugging would be enabled. Which would get into 
trouble on i386.

If you want less SLUB churn on other fronts then I can add the special 
casing for PAGE_SIZE slabs back into SLUB. Then we keep all the 
inconsistencies in SLAB use in the code.

I'd rather clean up the stuff and then also remove the special casing from 
SLAB.

 
