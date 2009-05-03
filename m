Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZECQXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZECQXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 12:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbZECQWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 12:22:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35326 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbZECQWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 12:22:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 3/4] PM/Hibernate: Use memory allocations to free memory (rev. 2)
Date: Sun, 3 May 2009 18:22:54 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905030224.21471.rjw@sisk.pl> <20090503115127.GA9661@localhost>
In-Reply-To: <20090503115127.GA9661@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905031822.55260.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 May 2009, Wu Fengguang wrote:
> On Sun, May 03, 2009 at 02:24:20AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Modify the hibernation memory shrinking code so that it will make
> > memory allocations to free memory instead of using an artificial
> > memory shrinking mechanism for that.  Remove the shrinking of
> > memory from the suspend-to-RAM code, where it is not really
> > necessary.  Finally, remove the no longer used memory shrinking
> > functions from mm/vmscan.c .
> > 
> > [rev. 2: Use the existing memory bitmaps for marking preallocated
> >  image pages and use swsusp_free() from releasing them, introduce
> >  GFP_IMAGE, add comments describing the memory shrinking strategy.]
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  kernel/power/main.c     |   20 ------
> >  kernel/power/snapshot.c |  132 +++++++++++++++++++++++++++++++++-----------
> >  mm/vmscan.c             |  142 ------------------------------------------------
> >  3 files changed, 101 insertions(+), 193 deletions(-)
> > 
> > Index: linux-2.6/kernel/power/snapshot.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/power/snapshot.c
> > +++ linux-2.6/kernel/power/snapshot.c
> > @@ -1066,41 +1066,97 @@ void swsusp_free(void)
> >  	buffer = NULL;
> >  }
> >  
> > +/* Helper functions used for the shrinking of memory. */
> > +
> > +#ifdef CONFIG_HIGHMEM
> > +#define GFP_IMAGE	(GFP_KERNEL | __GFP_HIGHMEM | __GFP_NO_OOM_KILL)
> > +#else
> > +#define GFP_IMAGE	(GFP_KERNEL | __GFP_NO_OOM_KILL)
> > +#endif
> 
> The CONFIG_HIGHMEM test is not necessary: __GFP_HIGHMEM is always defined.
> 
> > +#define SHRINK_BITE	10000
> 
> This is ~40MB. A full scan of (for example) 8G pages will be time
> consuming, not to mention we have to do it 2*(8G-500M)/40M = 384 times!
> 
> Can we make it a LONG_MAX? 

No, I don't think so.  The problem is the number of pages we'll need to copy
is generally shrinking  as we allocate memory, so we can't do that in one shot.

We can make it a greater number, but I don't really think it would be a good
idea to make it greater than 100 MB.

Thanks,
Rafael
