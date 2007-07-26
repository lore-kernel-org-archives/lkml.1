Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbXGZAmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbXGZAmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXGZAmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:42:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:33965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbXGZAmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:42:37 -0400
Date: Thu, 26 Jul 2007 02:42:36 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@gmail.com, magnade@gmail.com, davej@codemonkey.org.uk
Subject: Re: [patch] agp: don't lock pages
Message-ID: <20070726004236.GB17294@wotan.suse.de>
References: <20070725111922.GF29011@wotan.suse.de> <1185398813.5439.342.camel@localhost.localdomain> <20070726004114.GA17294@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726004114.GA17294@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[one more try]

On Thu, Jul 26, 2007 at 02:41:14AM +0200, Nick Piggin wrote:
> [forgot to cc Dave Jones...]
> 
> 
> On Thu, Jul 26, 2007 at 07:26:53AM +1000, Benjamin Herrenschmidt wrote:
> > On Wed, 2007-07-25 at 13:19 +0200, Nick Piggin wrote:
> > > Hi,
> > > 
> > > Does this patch solve the X problem? Does anyone see anything wrong
> > > with it or know why agp was locking the pages?
> > 
> > We need to do a little bit of auditing here, but I suspect it will turn
> > out all right. I think the reason it locked them in the first place was
> > to avoid AGP pages mapped into process space from being swapped out.
> > 
> > I think that should be taken care of by appropriate vma flags nowadays,
> > but we need to double check. It also might have been a way around dodgy
> > refcounting at one point but I think we got that right nowadays (I
> > remember fixing issues in that area when we removed PageReserved from
> > those pages back then).
> 
> Yeah I had a bit of a look around, and it seems OK (but would
> appreciate an ack from someone who knows the code).
> 
> These pages will never get seen by page reclaim, so we're OK
> there. There is a get_page before the SetPageLocked and a put_page
> right before the unlock_page, so refcounting should not be broken
> if it wasn't already: note that the lock_page doesn't pin a
> reference on a page in general -- we can use it as such for pagecache
> (although it isn't very clean), because the lock pins the page in
> pagecache and the pagecache holds a ref.
> 
> Anyway, if Dave or David can take a look, that would be appreciated.
> We'll need this for 2.6.23.
> 
> Nick
> 
> > 
> > Ben.
> > 
> > > --
> > > AGP should not need to lock pages. They are not protecting any race
> > > because there is no lock_page calls, only SetPageLocked.
> > > 
> > > This is causing hangs with d00806b183152af6d24f46f0c33f14162ca1262a.
> > > 
> > > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > > 
> > > diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
> > > index d535c40..3db4f40 100644
> > > --- a/drivers/char/agp/generic.c
> > > +++ b/drivers/char/agp/generic.c
> > > @@ -1170,7 +1170,6 @@ void *agp_generic_alloc_page(struct agp_
> > >  	map_page_into_agp(page);
> > >  
> > >  	get_page(page);
> > > -	SetPageLocked(page);
> > >  	atomic_inc(&agp_bridge->current_memory_agp);
> > >  	return page_address(page);
> > >  }
> > > @@ -1187,7 +1186,6 @@ void agp_generic_destroy_page(void *addr
> > >  	page = virt_to_page(addr);
> > >  	unmap_page_from_agp(page);
> > >  	put_page(page);
> > > -	unlock_page(page);
> > >  	free_page((unsigned long)addr);
> > >  	atomic_dec(&agp_bridge->current_memory_agp);
> > >  }
> > > diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> > > index a124060..2f319f4 100644
> > > --- a/drivers/char/agp/intel-agp.c
> > > +++ b/drivers/char/agp/intel-agp.c
> > > @@ -213,7 +213,6 @@ static void *i8xx_alloc_pages(void)
> > >  	}
> > >  	global_flush_tlb();
> > >  	get_page(page);
> > > -	SetPageLocked(page);
> > >  	atomic_inc(&agp_bridge->current_memory_agp);
> > >  	return page_address(page);
> > >  }
> > > @@ -229,7 +228,6 @@ static void i8xx_destroy_pages(void *add
> > >  	change_page_attr(page, 4, PAGE_KERNEL);
> > >  	global_flush_tlb();
> > >  	put_page(page);
> > > -	unlock_page(page);
> > >  	__free_pages(page, 2);
> > >  	atomic_dec(&agp_bridge->current_memory_agp);
> > >  }
> > > diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
> > > index cda608c..98cf8ab 100644
> > > --- a/drivers/char/agp/sgi-agp.c
> > > +++ b/drivers/char/agp/sgi-agp.c
> > > @@ -51,7 +51,6 @@ static void *sgi_tioca_alloc_page(struct
> > >  		return NULL;
> > >  
> > >  	get_page(page);
> > > -	SetPageLocked(page);
> > >  	atomic_inc(&agp_bridge->current_memory_agp);
> > >  	return page_address(page);
> > >  }
