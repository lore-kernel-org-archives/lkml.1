Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbZEDJ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbZEDJ2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 05:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZEDJ2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 05:28:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43206 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZEDJ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 05:28:23 -0400
Date: Mon, 4 May 2009 11:31:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 3/4] PM/Hibernate: Use memory allocations to free
	memory (rev. 2)
Message-ID: <20090504093121.GB30306@elf.ucw.cz>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905030224.21471.rjw@sisk.pl> <20090503115127.GA9661@localhost> <200905031822.55260.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905031822.55260.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-05-03 18:22:54, Rafael J. Wysocki wrote:
> On Sunday 03 May 2009, Wu Fengguang wrote:
> > On Sun, May 03, 2009 at 02:24:20AM +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Modify the hibernation memory shrinking code so that it will make
> > > memory allocations to free memory instead of using an artificial
> > > memory shrinking mechanism for that.  Remove the shrinking of
> > > memory from the suspend-to-RAM code, where it is not really
> > > necessary.  Finally, remove the no longer used memory shrinking
> > > functions from mm/vmscan.c .
> > > 
> > > [rev. 2: Use the existing memory bitmaps for marking preallocated
> > >  image pages and use swsusp_free() from releasing them, introduce
> > >  GFP_IMAGE, add comments describing the memory shrinking strategy.]
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > ---
> > >  kernel/power/main.c     |   20 ------
> > >  kernel/power/snapshot.c |  132 +++++++++++++++++++++++++++++++++-----------
> > >  mm/vmscan.c             |  142 ------------------------------------------------
> > >  3 files changed, 101 insertions(+), 193 deletions(-)
> > > 
> > > Index: linux-2.6/kernel/power/snapshot.c
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/power/snapshot.c
> > > +++ linux-2.6/kernel/power/snapshot.c
> > > @@ -1066,41 +1066,97 @@ void swsusp_free(void)
> > >  	buffer = NULL;
> > >  }
> > >  
> > > +/* Helper functions used for the shrinking of memory. */
> > > +
> > > +#ifdef CONFIG_HIGHMEM
> > > +#define GFP_IMAGE	(GFP_KERNEL | __GFP_HIGHMEM | __GFP_NO_OOM_KILL)
> > > +#else
> > > +#define GFP_IMAGE	(GFP_KERNEL | __GFP_NO_OOM_KILL)
> > > +#endif
> > 
> > The CONFIG_HIGHMEM test is not necessary: __GFP_HIGHMEM is always defined.
> > 
> > > +#define SHRINK_BITE	10000
> > 
> > This is ~40MB. A full scan of (for example) 8G pages will be time
> > consuming, not to mention we have to do it 2*(8G-500M)/40M = 384 times!
> > 
> > Can we make it a LONG_MAX? 
> 
> No, I don't think so.  The problem is the number of pages we'll need to copy
> is generally shrinking  as we allocate memory, so we can't do that in one shot.
> 
> We can make it a greater number, but I don't really think it would be a good
> idea to make it greater than 100 MB.

Well, even 100MB is quite big: on 128MB machine, that will probably
mean freeing all the memory (instead of "as much as needed"). And that
memory needs to go to disk, so it will be slow.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
