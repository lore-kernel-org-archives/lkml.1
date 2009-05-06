Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbZEFN5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbZEFN5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759224AbZEFN50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:57:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:8995 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbZEFN5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WMm9VCNWzW+qtGYTStoWpeAh4cpSvu/1hUSNO9+sMeTDZUnrseEzaLaPhRaCve2HBg
         8r1Ni66vJ1Z0leY8TJKq0VBzJ7mYaGkhfA8l6+yF28d9d1+GGqe3Ws2LpVenoR+U4mci
         4EPZuXZtXkCm+XId/fNDm96TZ/7vbu+BJm1Yw=
Date: Wed, 6 May 2009 21:56:59 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "alan-jenkins@tuffmail.co.uk" <alan-jenkins@tuffmail.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 5/5] PM/Hibernate: Do not release preallocated memory
	unnecessarily (rev. 2)
Message-ID: <20090506135659.GB26233@localhost>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905040222.39062.rjw@sisk.pl> <20090505022427.GA10880@localhost> <200905060105.10800.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905060105.10800.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 07:05:09AM +0800, Rafael J. Wysocki wrote:
> On Tuesday 05 May 2009, Wu Fengguang wrote:
> > On Mon, May 04, 2009 at 08:22:38AM +0800, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Since the hibernation code is now going to use allocations of memory
> > > to create enough room for the image, it can also use the page frames
> > > allocated at this stage as image page frames.  The low-level
> > > hibernation code needs to be rearranged for this purpose, but it
> > > allows us to avoid freeing a great number of pages and allocating
> > > these same pages once again later, so it generally is worth doing.
> > > 
> > > [rev. 2: Change the strategy of preallocating memory to allocate as
> > >  many pages as needed to get the right image size in one shot (the
> > >  excessive allocated pages are released afterwards).]
> > 
> > Rafael, I tried out your patches and found doubled memory shrink speed!
> >
> > [  579.641781] PM: Preallocating image memory ... done (allocated 383900 pages, 128000 image pages kept)
> > [  583.087875] PM: Allocated 1535600 kbytes in 3.43 seconds (447.69 MB/s)
> 
> Unfortunately, I'm observing a regression and a huge one.
> 
> On my Atom-based test box with 1 GB of RAM after a fresh boot and starting X
> with KDE 4 there are ~256 MB free.  To create an image we need to free ~300 MB
> and that takes ~2 s with the old code and ~15 s with the new one.
> 
> It helps to call shrink_all_memory() once with a sufficiently large argument
> before the preallocation.
[snip]
> > At last, I'd express my major concern about the transition to preallocate
> > based memory shrinking: will it lead to more random swapping IOs?
> 
> Hmm.  I don't see immediately why would it.  Maybe the regression I'm seeing
> is related to that ...

So you do have swap file enabled? hibernate_preallocate_memory() will
firstly try to allocate as much pages as possible(savable+free), and
then to free up (allocated-image_size) pages. That means *all*
swappable pages will be swapped out in the process - that's a major
performance regression!  And the zones are likely to be *over scanned*
and go to *all unreclaimable* state! (Hopefully they may be already
small at the time.)
