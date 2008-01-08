Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYAHW3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYAHW3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYAHW3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:29:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbYAHW3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:29:09 -0500
Date: Tue, 8 Jan 2008 17:28:56 -0500
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [patch 03/19] define page_file_cache() function
Message-ID: <20080108172856.4196bd4b@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0801081414230.4281@schroedinger.engr.sgi.com>
References: <20080108205939.323955454@redhat.com>
	<20080108205959.952424899@redhat.com>
	<Pine.LNX.4.64.0801081414230.4281@schroedinger.engr.sgi.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 14:18:40 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 8 Jan 2008, Rik van Riel wrote:
> 
> > Define page_file_cache() function to answer the question:
> > 	is page backed by a file?
> 
> > +static inline int page_file_cache(struct page *page)
> > +{
> > +	if (PageSwapBacked(page))
> > +		return 0;
> 
> Could we call this PageNotFileBacked or so? PageSwapBacked is true for 
> pages that are RAM based. Its a bit confusing.

PageNotFileBacked confuses me a little, since shared memory segments live
in tmpfs and are kinda sorta file backed, but go to swap instead of to a
filesystem when there is memory pressure.

I'm always open to better naming ideas, though.

> > Index: linux-2.6.24-rc6-mm1/mm/migrate.c
> > ===================================================================
> > --- linux-2.6.24-rc6-mm1.orig/mm/migrate.c	2008-01-02 12:37:14.000000000 -0500
> > +++ linux-2.6.24-rc6-mm1/mm/migrate.c	2008-01-02 12:37:22.000000000 -0500
> > @@ -546,6 +546,8 @@ static int move_to_new_page(struct page 
> >  	/* Prepare mapping for the new page.*/
> >  	newpage->index = page->index;
> >  	newpage->mapping = page->mapping;
> > +	if (PageSwapBacked(page))
> > +		SetPageSwapBacked(newpage);
> >  
> >  	mapping = page_mapping(page);
> >  	if (!mapping)
> 
> That hunk belongs into migrate_page_copy()? Or is there a reason that we 
> need this flag that early?

We want the page added to the right LRU list.  I'll have to re-read the
migration code to make sure whether the above can or cannot be done in
migrate_page_copy() - I agree it would fit in better there.

Thanks for the suggestions.

-- 
All rights reversed.
