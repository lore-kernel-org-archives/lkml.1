Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbZFDLzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbZFDLzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbZFDLzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:55:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:12436 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbZFDLzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:55:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,305,1241420400"; 
   d="scan'208";a="150598163"
Date: Thu, 4 Jun 2009 19:55:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [6/16] HWPOISON: Add various poison checks in
	mm/memory.c
Message-ID: <20090604115533.GB22118@localhost>
References: <20090603846.816684333@firstfloor.org> <20090603184639.1933B1D028F@basil.firstfloor.org> <20090604042603.GA15682@localhost> <20090604051915.GN1065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604051915.GN1065@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 01:19:15PM +0800, Andi Kleen wrote:
> On Thu, Jun 04, 2009 at 12:26:03PM +0800, Wu Fengguang wrote:
> > On Thu, Jun 04, 2009 at 02:46:38AM +0800, Andi Kleen wrote:
> > >
> > > Bail out early when hardware poisoned pages are found in page fault handling.
> >
> > I suspect this patch is also not absolutely necessary: the poisoned
> > page will normally have been isolated already.
>
> It's needed to prevent new pages comming in when there is a parallel
> fault while the memory failure handling is in process.
> Otherwise the pages could get remapped in that small window.

This patch makes no difference at least for file pages, including tmpfs.

In filemap_fault(), it will first do find_lock_page(), which will lock
the page and then double check if the page->mapping is NULL.  If so,
it drops that page and re-find/re-create one in the radix tree.

That logic automatically avoids the poisoned page that is being
processed, because the poisoned page is now being locked, and when
find_lock_page() eventually is able to lock it, its page->mapping
will be NULL. So the PageHWPoison(vmf.page) test will never be true
for filemap_fault.

shmem_fault() calls shmem_getpage() to get the page, which will return
EIO on !uptodate page. It then returns VM_FAULT_SIGBUS on its own.

> > > --- linux.orig/mm/memory.c	2009-06-03 19:36:23.000000000 +0200
> > > +++ linux/mm/memory.c	2009-06-03 19:36:23.000000000 +0200
> > > @@ -2797,6 +2797,9 @@
> > >  	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
> > >  		return ret;
> > >
> > > +	if (unlikely(PageHWPoison(vmf.page)))
> > > +		return VM_FAULT_HWPOISON;
> > > +
> >
> > Direct return with locked page could lockup someone later.
> > Either drop this patch or fix it with this check?
>
> Fair point. Fixed.

OK, thanks.

Fengguang
