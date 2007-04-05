Return-Path: <linux-kernel-owner+w=401wt.eu-S1767432AbXDEXnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767432AbXDEXnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 19:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767438AbXDEXnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 19:43:10 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57582 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767432AbXDEXnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 19:43:08 -0400
Date: Thu, 5 Apr 2007 16:43:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Make page->private usable in compound pages V1
Message-Id: <20070405164300.a5d24329.akpm@linux-foundation.org>
In-Reply-To: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Apr 2007 15:36:51 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> If we add a new flag so that we can distinguish between the
> first page and the tail pages then we can avoid to use page->private
> in the first page. page->private == page for the first page, so there
> is no real information in there.
> 
> Freeing up page->private makes the use of compound pages more transparent.
> They become more usable like real pages. Right now we have to be careful f.e.
> if we are going beyond PAGE_SIZE allocations in the slab on i386 because we
> can then no longer use the private field. This is one of the issues that
> cause us not to support debugging for page size slabs in SLAB.
> 
> Having page->private available for SLUB would allow more meta information
> in the page struct. I can probably avoid the 16 bit ints that I have in
> there right now.
> 
> Also if page->private is available then a compound page may be equipped
> with buffer heads. This may free up the way for filesystems to support
> larger blocks than page size.
> 
> We add PageTail as an alias of PageReclaim. Compound pages cannot
> currently be reclaimed. Because of the alias one needs to check
> PageCompound first.

So slub is using compound pages so that it can locate the head page in
higher-order pages, whereas slab uses per-object (or per-order-0-page?)
metadata for that?

I see four instances of

+	page = virt_to_page(p);
+
+	if (unlikely(PageCompound(page)))
+		page = page->first_page;

A new virt_to_head_page() is needed.


Sigh.  We're seeing rather a lot of churn to accommodate slub.  Do we
actually have any justification for all this?  If we end up deciding to
merge slub and to deprecate then remove slab, what would our reasons have
been?
