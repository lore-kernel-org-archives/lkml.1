Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbZEGMVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbZEGMVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZEGMVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:21:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36047 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZEGMVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:21:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@gmail.com>
Subject: Re: [PATCH 5/5] PM/Hibernate: Do not release preallocated memory unnecessarily (rev. 2)
Date: Thu, 7 May 2009 14:20:42 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "alan-jenkins@tuffmail.co.uk" <alan-jenkins@tuffmail.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905062254.10227.rjw@sisk.pl> <20090507015803.GA12281@localhost>
In-Reply-To: <20090507015803.GA12281@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905071420.43491.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, Wu Fengguang wrote:
> On Thu, May 07, 2009 at 04:54:09AM +0800, Rafael J. Wysocki wrote:
> > On Wednesday 06 May 2009, Wu Fengguang wrote:
> > > On Wed, May 06, 2009 at 07:05:09AM +0800, Rafael J. Wysocki wrote:
> > > > On Tuesday 05 May 2009, Wu Fengguang wrote:
> > > > > On Mon, May 04, 2009 at 08:22:38AM +0800, Rafael J. Wysocki wrote:
> > > > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > 
> > > > > > Since the hibernation code is now going to use allocations of memory
> > > > > > to create enough room for the image, it can also use the page frames
> > > > > > allocated at this stage as image page frames.  The low-level
> > > > > > hibernation code needs to be rearranged for this purpose, but it
> > > > > > allows us to avoid freeing a great number of pages and allocating
> > > > > > these same pages once again later, so it generally is worth doing.
> > > > > > 
> > > > > > [rev. 2: Change the strategy of preallocating memory to allocate as
> > > > > >  many pages as needed to get the right image size in one shot (the
> > > > > >  excessive allocated pages are released afterwards).]
> > > > > 
> > > > > Rafael, I tried out your patches and found doubled memory shrink speed!
> > > > >
> > > > > [  579.641781] PM: Preallocating image memory ... done (allocated 383900 pages, 128000 image pages kept)
> > > > > [  583.087875] PM: Allocated 1535600 kbytes in 3.43 seconds (447.69 MB/s)
> > > > 
> > > > Unfortunately, I'm observing a regression and a huge one.
> > > > 
> > > > On my Atom-based test box with 1 GB of RAM after a fresh boot and starting X
> > > > with KDE 4 there are ~256 MB free.  To create an image we need to free ~300 MB
> > > > and that takes ~2 s with the old code and ~15 s with the new one.
> > > > 
> > > > It helps to call shrink_all_memory() once with a sufficiently large argument
> > > > before the preallocation.
> > > [snip]
> > > > > At last, I'd express my major concern about the transition to preallocate
> > > > > based memory shrinking: will it lead to more random swapping IOs?
> > > > 
> > > > Hmm.  I don't see immediately why would it.  Maybe the regression I'm seeing
> > > > is related to that ...
> > > 
> > > So you do have swap file enabled? hibernate_preallocate_memory() will
> > > firstly try to allocate as much pages as possible(savable+free), and
> > > then to free up (allocated-image_size) pages.
> > 
> > No.  It's going to allocate (total RAM - anticipated image size) and then free
> > up (allocated-image_size) pages.
> 
> Ah yes - I didn't notice that count was subtracted here:
> 
>         for (count -= size; count > 0; count--) {
> 
> Make "count -= size" a standalone line to make that more obvious?

That should be clear in the new patches:
http://patchwork.kernel.org/patch/22193/
http://patchwork.kernel.org/patch/22191/

Thanks,
Rafael
