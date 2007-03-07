Return-Path: <linux-kernel-owner+w=401wt.eu-S1751663AbXCGLhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbXCGLhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXCGLhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:37:20 -0500
Received: from ns2.suse.de ([195.135.220.15]:48568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbXCGLhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:37:19 -0500
Date: Wed, 7 Mar 2007 12:37:18 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: miklos@szeredi.hu, Linux Memory Management List <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 8/6] mm: fix cpdfio vs fault race
Message-ID: <20070307113717.GB18704@wotan.suse.de>
References: <20070307110429.GF5555@wotan.suse.de> <20070307032038.f08333a8.akpm@linux-foundation.org> <20070307033400.83922b12.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307033400.83922b12.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 03:34:00AM -0800, Andrew Morton wrote:
> On Wed, 7 Mar 2007 03:20:38 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > > ===================================================================
> > > --- linux-2.6.orig/mm/memory.c
> > > +++ linux-2.6/mm/memory.c
> > > @@ -1676,6 +1676,17 @@ gotten:
> > >  unlock:
> > >  	pte_unmap_unlock(page_table, ptl);
> > >  	if (dirty_page) {
> > > +		/*
> > > +		 * Yes, Virginia, this is actually required to prevent a race
> > > +		 * with clear_page_dirty_for_io() from clearing the page dirty
> > > +		 * bit after it clear all dirty ptes, but before a racing
> > > +		 * do_wp_page installs a dirty pte.
> > > +		 *
> > > +		 * do_fault is protected similarly by holding the page lock
> > > +		 * after the dirty pte is installed.
> > > +		 */
> > > +		lock_page(dirty_page);
> > > +		unlock_page(dirty_page);
> > >  		set_page_dirty_balance(dirty_page);
> > >  		put_page(dirty_page);
> > 
> > Yes, I think that'll plug it.  A wait_on_page_locked() should suffice.
> 
> Or will it?  Suppose after the unlock_page() a _second_
> clear_page_dirty_for_io() gets run - the same thing happens?
> 
> Extending the lock_page() coverage around the set_page_dirty() would
> prevent that.
> 
> I guess not needed - the second clear_page_dirty_for_io() will have cleaned the
> pte.

Yeah, all we need to do is keep page faults out of that little window
in clear_page_dirty_for_io() where I stuck the comment.

