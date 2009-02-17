Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbZBQLzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbZBQLzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZBQLzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:55:35 -0500
Received: from mx1.suse.de ([195.135.220.2]:48145 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbZBQLze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:55:34 -0500
Date: Tue, 17 Feb 2009 12:55:32 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryan Hope <rmh3093@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: set_page_dirty races (was: Re: [patch 2/4] vfs: add set_page_dirty_notag)
Message-ID: <20090217115532.GF26402@wotan.suse.de>
References: <18838.49922.215481.399653@edward.zelnet.ru> <1234645893.4695.8.camel@laptop> <18841.60432.329341.514726@edward.zelnet.ru> <1234861781.4744.21.camel@laptop> <20090217093805.GB31323@wotan.suse.de> <1234865116.4744.46.camel@laptop> <20090217102443.GA26402@wotan.suse.de> <1234867200.4744.65.camel@laptop> <20090217112512.GD26402@wotan.suse.de> <1234870772.4744.79.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234870772.4744.79.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 12:39:32PM +0100, Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 12:25 +0100, Nick Piggin wrote:
> 
> > Introduce put_user_pages function.
> > 
> > In order to have more flexibility to deal with issues surrounding
> > get_user_pages difficulties[*], introduce put_user_pages function
> > intended to release pages acquired by get_user_pages. For now, just
> > do the regular put_page thing. If all callers are converted, it could
> > be used to help with such races. In the meantime, it will actually
> > serve as a small extra piece of documentation for the code.
> > 
> > [*] eg. get_user_pages caller can bypass page_mkwrite calls into the
> >     filesystem to notify of page dirty activity if the page gets cleaned
> >     before the caller calls its final set_page_dirty).
> 
> Hmm, if we want to distinguish between .write=1 and .write=0, we would
> have to pass .write to pup too, right?

Doh, yeah. I hand edited the patch to put that parameter in, but quilt
refresh must have outsmarted me!

If nobody thinks it is insane, I'll resend to Andrew in a new thread.

> > ---
> >  include/linux/mm.h |    1 +
> >  mm/memory.c        |   13 ++++++++++++-
> >  2 files changed, 13 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6/include/linux/mm.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/mm.h
> > +++ linux-2.6/include/linux/mm.h
> > @@ -826,6 +826,7 @@ extern int access_process_vm(struct task
> >  int get_user_pages(struct task_struct *tsk, struct mm_struct *mm, unsigned long start,
> >  		int len, int write, int force, struct page **pages, struct vm_area_struct **vmas);
> >  
> > +void put_user_pages(struct page **pages, int nr);
> >  extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
> >  extern void do_invalidatepage(struct page *page, unsigned long offset);
> >  
> > Index: linux-2.6/mm/memory.c
> > ===================================================================
> > --- linux-2.6.orig/mm/memory.c
> > +++ linux-2.6/mm/memory.c
> > @@ -1370,9 +1370,20 @@ int get_user_pages(struct task_struct *t
> >  				start, len, flags,
> >  				pages, vmas);
> >  }
> > -
> >  EXPORT_SYMBOL(get_user_pages);
> >  
> > +/*
> > + * put_user_pages should be used to release pages acquired with get_user_pages.
> > + */
> > +void put_user_pages(struct page **pages, int nr)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < nr; i++)
> > +		put_page(pages[i]);
> > +}
> > +EXPORT_SYMBOL(put_user_pages);
> > +
> >  pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
> >  			spinlock_t **ptl)
> >  {
> > 
