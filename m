Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbXDFUEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbXDFUEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932785AbXDFUEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:04:13 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60912 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773AbXDFUEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:04:12 -0400
Date: Fri, 6 Apr 2007 13:04:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Make page->private usable in compound pages V1
Message-Id: <20070406130401.b380b8da.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704060958430.25652@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
	<20070405164300.a5d24329.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704060958430.25652@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007 10:01:38 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 5 Apr 2007, Andrew Morton wrote:
> 
> > > We add PageTail as an alias of PageReclaim. Compound pages cannot
> > > currently be reclaimed. Because of the alias one needs to check
> > > PageCompound first.
> > 
> > So slub is using compound pages so that it can locate the head page in
> > higher-order pages, whereas slab uses per-object (or per-order-0-page?)
> > metadata for that?
> 
> Both SLAB and SLUB use compound pages.

Not really.  slab sets the page->lru.prev of each constituent page to point
at the controlling slab.

I assume the PageCompound() handling in (for example) page_get_cache() is
for the NOMMU special case.

> > 
> > I see four instances of
> > 
> > +	page = virt_to_page(p);
> > +
> > +	if (unlikely(PageCompound(page)))
> > +		page = page->first_page;
> > 
> > A new virt_to_head_page() is needed.
> 
> Ok.
>  
>  > Sigh.  We're seeing rather a lot of churn to accommodate slub.  Do we
> > actually have any justification for all this?  If we end up deciding to
> > merge slub and to deprecate then remove slab, what would our reasons have
> > been?
> 
> This is not SLUB specific. SLAB does the same. SLAB does special casing 
> for page size slabs and does not allow slab debugging because it would 
> use page->private if debugging would be enabled. Which would get into 
> trouble on i386.
> 
> If you want less SLUB churn on other fronts then I can add the special 
> casing for PAGE_SIZE slabs back into SLUB. Then we keep all the 
> inconsistencies in SLAB use in the code.
> 
> I'd rather clean up the stuff and then also remove the special casing from 
> SLAB.
> 

Will slub handle NOMMU anonymous pages appropriately?
