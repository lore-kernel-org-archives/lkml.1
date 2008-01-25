Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYAYDJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYAYDJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYAYDJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:09:04 -0500
Received: from mga03.intel.com ([143.182.124.21]:18346 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbYAYDJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:09:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,247,1199692800"; 
   d="scan'208";a="371070706"
Subject: Re: [RFC] some page can't be migrated
From: Shaohua Li <shaohua.li@intel.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, clameter <clameter@sgi.com>
In-Reply-To: <200801251403.23236.nickpiggin@yahoo.com.au>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
	 <200801251403.23236.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 11:09:31 +0800
Message-Id: <1201230571.28282.2.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-25 at 14:03 +1100, Nick Piggin wrote:
> On Wednesday 23 January 2008 17:22, Shaohua Li wrote:
> > Anonymous page might have fs-private metadata, the page is truncated. As
> > the page hasn't mapping, page migration refuse to migrate the page. It
> > appears the page is only freed in page reclaim and if zone watermark is
> > low, the page is never freed, as a result migration always fail. I
> > thought we could free the metadata so such page can be freed in
> > migration and make migration more reliable?
> 
> Anonymous pages should not have fs-private metadata.
> 
> Orphaned pages I guess you mean?
yes, maybe, but the comments in truncate_complete_page called the page
anonymous.
> They should not be accessable via
> the pagecache or the page tables, so how do they keep tangling up
> migration? Where/how is migration finding these pages?!
the page is still in lru list. Memory hot remove will try to migrate the
page.

Thanks,
Shaohua

> >
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 6a207e8..6bc38f7 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -633,6 +633,17 @@ static int unmap_and_move(new_page_t get_new_page,
> > unsigned long private, goto unlock;
> >  		wait_on_page_writeback(page);
> >  	}
> > +
> > +	/*
> > +	 * See truncate_complete_page(). Anonymous page might have
> > +	 * fs-private metadata, the page is truncated. Such page can't be
> > +	 * migrated. Try to free metadata, so the page can be freed.
> > +	 */
> > +	if (!page->mapping && !PageAnon(page) && PagePrivate(page)) {
> > +		try_to_release_page(page, GFP_KERNEL);
> > +		goto unlock;
> > +	}
> > +
> >  	/*
> >  	 * By try_to_unmap(), page->mapcount goes down to 0 here. In this case,
> >  	 * we cannot notice that anon_vma is freed while we migrates a page.
> >
> >
> > --

