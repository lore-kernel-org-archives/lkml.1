Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbYFHU6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbYFHU6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYFHU6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:58:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489AbYFHU6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:58:23 -0400
Date: Sun, 8 Jun 2008 13:57:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, eric.whitney@hp.com
Subject: Re: [PATCH -mm 13/25] Noreclaim LRU Infrastructure
Message-Id: <20080608135704.a4b0dbe1.akpm@linux-foundation.org>
In-Reply-To: <20080608163413.08d46427@bree.surriel.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.291472052@redhat.com>
	<20080606180506.081f686a.akpm@linux-foundation.org>
	<20080608163413.08d46427@bree.surriel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008 16:34:13 -0400 Rik van Riel <riel@redhat.com> wrote:

> On Fri, 6 Jun 2008 18:05:06 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 06 Jun 2008 16:28:51 -0400
> > Rik van Riel <riel@redhat.com> wrote:
> > 
> > > 
> > > From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> 
> > > The noreclaim infrastructure is enabled by a new mm Kconfig option
> > > [CONFIG_]NORECLAIM_LRU.
> > 
> > Having a config option for this really sucks, and needs extra-special
> > justification, rather than none.
> 
> I believe the justification is that it uses a page flag.
> 
> PG_noreclaim would be the 20th page flag used, meaning there are
> 4 more free if 8 bits are used for zone and node info, which would
> give 6 bits for NODE_SHIFT or 64 NUMA nodes - probably overkill
> for 32 bit x86.
> 
> If you want I'll get rid of CONFIG_NORECLAIM_LRU and make everything
> just compile in always.

Seems unlikely to be useful?  The only way in which this would be an
advantage if if we hae some other feature which also needs a page flag
but which will never be concurrently enabled with this one.

> Please let me know what your preference is.

Don't use another page flag?

> > > --- linux-2.6.26-rc2-mm1.orig/include/linux/page-flags.h	2008-05-29 16:21:04.000000000 -0400
> > > +++ linux-2.6.26-rc2-mm1/include/linux/page-flags.h	2008-06-06 16:05:15.000000000 -0400
> > > @@ -94,6 +94,9 @@ enum pageflags {
> > >  	PG_reclaim,		/* To be reclaimed asap */
> > >  	PG_buddy,		/* Page is free, on buddy lists */
> > >  	PG_swapbacked,		/* Page is backed by RAM/swap */
> > > +#ifdef CONFIG_NORECLAIM_LRU
> > > +	PG_noreclaim,		/* Page is "non-reclaimable"  */
> > > +#endif
> > 
> > I fear that we're messing up the terminology here.
> > 
> > Go into your 2.6.25 tree and do `grep -i reclaimable */*.c'.  The term
> > already means a few different things, but in the vmscan context,
> > "reclaimable" means that the page is unreferenced, clean and can be
> > stolen.  "reclaimable" also means a lot of other things, and we just
> > made that worse.
> > 
> > Can we think of a new term which uniquely describes this new concept
> > and use that, rather than flogging the old horse?
> 
> Want to reuse the BSD term "pinned" instead?

mm, "pinned" in Linuxland means "someone took a ref on it to prevent it
from being reclaimed".

As a starting point: what, in your english-language-paragraph-length
words, does this flag mean?

> > > +/**
> > > + * add_page_to_noreclaim_list
> > > + * @page:  the page to be added to the noreclaim list
> > > + *
> > > + * Add page directly to its zone's noreclaim list.  To avoid races with
> > > + * tasks that might be making the page reclaimble while it's not on the
> > > + * lru, we want to add the page while it's locked or otherwise "invisible"
> > > + * to other tasks.  This is difficult to do when using the pagevec cache,
> > > + * so bypass that.
> > > + */
> > 
> > How does a task "make a page reclaimable"?  munlock()?  fsync()? 
> > exit()?
> > 
> > Choice of terminology matters...
> 
> Lee?  Kosaki-san?

