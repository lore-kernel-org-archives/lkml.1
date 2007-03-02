Return-Path: <linux-kernel-owner+w=401wt.eu-S1422856AbXCBEat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422856AbXCBEat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422875AbXCBEat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:30:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42511 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422870AbXCBEao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:30:44 -0500
Date: Fri, 2 Mar 2007 04:30:39 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, support@coraid.com,
       "Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: PATCH 2.6.21-rc1 aoe: handle zero _count pages in bios
Message-ID: <20070302043039.GA18651@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, support@coraid.com,
	"Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org,
	Greg KH <greg@kroah.com>
References: <20070301231510.GC8524@coraid.com> <20070301174204.a550dd3a.akpm@linux-foundation.org> <20070302022919.GA26285@infradead.org> <20070301192245.bf034385.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301192245.bf034385.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 07:22:45PM -0800, Andrew Morton wrote:
> Well I spose slab _could_ take a ref on these pages.

What it would need to do is:

 - add a reference for every object touching this page
 - don't give the page back to the page allocator or reuse any
   single object inside it until there are no more reference to the page.

I don't think this is a very good idea, although the netowkring references
tend to be rather short-term once making this not a that bad burden.

> Networking internally maintains caller memory lifetimes, and it assumes
> that the caller allocated memory via __alloc_pages() - because it uses
> get_page() and put_page().
> 
> BIO, however, does not internally manage caller memory lifetime.  This is
> because the caller's ->bi_end_io is always called, so the caller can do it.
> 
> So where we've come unstuck is in a module which has gone and fed BIO
> memory into networking.  The differing design philosophies are clashing.
> 
> I'm surprised this doesn't happen in other places - aren't there any other
> drivers which take a BIO and stuff it down the network?
> 
> Anyway, where's the bug?
> 
> Really, I'd say it's XFS (and ext3).  Even though BIO doesn't presently
> manage page lifetimes, it _could_.  After all, the function is called
> bio_add_page(), not bio_add_virtual_address().  It's a bit hacky to kmalloc
> some memory, run virt_to_page() and to then present that page to BIO even
> though the caller (thanks to the slab optimisation) doesn't actually have
> control of that page's lifetime.

That was the conclusion I came to when this was brought up initially.
Fixing up XFS would be easyish and only waste a tiny amount of memory,
and the same is true for ext3 (I did in fact suggest just using get_free_page
for this case but got shot down for stupid reasons when the slab debug
alignment issues in that area came up)

But in this case we'd really need to enforce this, and add a
BUG_ON(PageSlab(page)) in bio_add_page to trip everyone submit
this kind of pages.

> So we have a few options to look at:
> 
> a) kludge things in AOE.  Unpleasing, and might cause memory leaks
>    (although it won't, because the caller hasn't run bi_end_io yet).
> 
> b) Take a ref on slab pages in slab.  A bit costly, perhaps.
> 
> c) teach ext3 and XFS to take a ref on these pages as they are added to
>    the BIOs, undo that ref in bi_end_io.
> 
> I think c)?

Yes.  I'm perfectly fine with this as long as we document and enforce
this.
