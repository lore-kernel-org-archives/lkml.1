Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZEOOkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZEOOkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZEOOjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:39:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38529 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZEOOju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:39:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 6/6] PM/Hibernate: Do not try to allocate too much memory too hard
Date: Fri, 15 May 2009 16:40:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       David Rientjes <rientjes@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <200905070040.08561.rjw@sisk.pl> <200905141959.53810.rjw@sisk.pl> <20090515131421.GD1976@elf.ucw.cz>
In-Reply-To: <20090515131421.GD1976@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905151640.01954.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 May 2009, Pavel Machek wrote:
> Hi!
> 
> > > > We want to avoid attempting to free too much memory too hard during
> > > > hibernation, so estimate the minimum size of the image to use as the
> > > > lower limit for preallocating memory.
> > > 
> > > Why? Is freeing memory too slow?
> > > 
> > > It used to be that user controlled image size, so he was able to
> > > balance "time to save image" vs. "responsiveness of system after
> > > resume".
> > > 
> > > Does this just override user's preference when he chooses too small
> > > image size?
> > > 
> > > > The approach here is based on the (experimental) observation that we
> > > > can't free more page frames than the sum of:
> > > > 
> > > > * global_page_state(NR_SLAB_RECLAIMABLE)
> > > > * global_page_state(NR_ACTIVE_ANON)
> > > > * global_page_state(NR_INACTIVE_ANON)
> > > > * global_page_state(NR_ACTIVE_FILE)
> > > > * global_page_state(NR_INACTIVE_FILE)
> > > > 
> > > > and even that is usually impossible to free in practice, because some
> > > > of the pages reported as global_page_state(NR_SLAB_RECLAIMABLE) can't
> > > > in fact be freed.  It turns out, however, that if the sum of the
> > > > above numbers is subtracted from the number of saveable pages in the
> > > > system and the result is multiplied by 1.25, we get a suitable
> > > > estimate of the minimum size of the image.
> ...
> > > >  /**
> > > > + * minimum_image_size - Estimate the minimum acceptable size of an image
> > > > + * @saveable: The total number of saveable pages in the system.
> > > > + *
> > > > + * We want to avoid attempting to free too much memory too hard, so estimate the
> > > > + * minimum acceptable size of a hibernation image to use as the lower limit for
> > > > + * preallocating memory.
> > > 
> > > I don't get it. If user sets image size as 0, we should free as much
> > > memory as we can. I just don't see why "we want to avoid... it".
> > 
> > The "as much memory as we can" is not well defined.
> 
> Well, while (1) kmalloc(1024, GFP_KERNEL | GFP_NO_OOMKILL); is
> basically "as much memory as we can". I believe it is pretty well defined.
> 
> > Patches [4/6] and [5/6] make hibernation use memory allocations to force some
> > memory to be freed.  However, it is not really reasonable to try to allocate
> > until the allocation fails, because that stresses the memory management
> > subsystem too much.  It is better to predict when it fails and stop allocating
> > at that point, which is what the patch does.
> 
> Why is it wrong to stress memory management? It is a computer; it can
> handle it. Does it take too long?

Yes.

> Should the user just set image_size higher in such case?

Yes, he should.

> > The prediction is not very precise, but I think it need not be.  Even if it
> > leaves a few pages more in memory, that won't be a disaster.
> 
> Well, on 128MB machine, you'll fail suspend even if it would fit if
> code tried little harder...?

No.  Did you notice the min_t(unsigned long, pages, max_size) in the patch?
It's there exactly for this purpose (although I don't think it's really going
to trigger in practice). :-)

Thanks,
Rafael
