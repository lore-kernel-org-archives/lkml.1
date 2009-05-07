Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbZEGUuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbZEGUuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZEGUuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:50:37 -0400
Received: from mail.crca.org.au ([67.207.131.56]:48354 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbZEGUug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:50:36 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [RFC][PATCH 4/5] PM/Hibernate: Rework shrinking of memory
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200905071418.05035.rjw@sisk.pl>
References: <200905070040.08561.rjw@sisk.pl>
	 <200905070044.13857.rjw@sisk.pl> <1241652436.19600.176.camel@nigel-laptop>
	 <200905071418.05035.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 08 May 2009 06:51:34 +1000
Message-Id: <1241729494.19600.218.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2009-05-07 at 14:18 +0200, Rafael J. Wysocki wrote:
> On Thursday 07 May 2009, Nigel Cunningham wrote:
> > Hi.
> 
> Hi,
> 
> > On Thu, 2009-05-07 at 00:44 +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Rework swsusp_shrink_memory() so that it calls shrink_all_memory()
> > > just once to make some room for the image and then allocates memory
> > > to apply more pressure to the memory management subsystem, if
> > > necessary.
> > > 
> > > Unfortunately, we don't seem to be able to drop shrink_all_memory()
> > > entirely just yet, because that would lead to huge performance
> > > regressions in some test cases.
> > 
> > I know it doesn't fit with your current way of doing things, but have
> > you considered trying larger order allocations as a means of getting
> > memory freed?
> 
> Actually, I was thinking about that.  What's your experience with this
> approach?

I can't give you statistics, but it seems faster and the VM seems to
work better with the implicit hint that we want larger amounts of memory
than just single pages. The main difficulty is making sure that drivers
can still do allocations with order > 0 later. Some of them seem to want
to do that instead of vmallocing.

> > I have code in tuxonice_prepare_image.c (look for extra_pages_allocated) that
> > might be helpful for this purpose.
> 
> OK, thanks.  I'll have a look at it.
> 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > ---
> > >  kernel/power/snapshot.c |  145 ++++++++++++++++++++++++++++++++----------------
> > >  1 file changed, 98 insertions(+), 47 deletions(-)
> > > 
> > > Index: linux-2.6/kernel/power/snapshot.c
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/power/snapshot.c
> > > +++ linux-2.6/kernel/power/snapshot.c
> > > @@ -1066,69 +1066,120 @@ void swsusp_free(void)
> > >  	buffer = NULL;
> > >  }
> > >  
> > > +/* Helper functions used for the shrinking of memory. */
> > > +
> > >  /**
> > > - *	swsusp_shrink_memory -  Try to free as much memory as needed
> > > - *
> > > - *	... but do not OOM-kill anyone
> > > + * preallocate_image_memory - Allocate given number of page frames
> > > + * @nr_pages: Number of page frames to allocate
> > >   *
> > > - *	Notice: all userland should be stopped before it is called, or
> > > - *	livelock is possible.
> > > + * Return value: Number of page frames actually allocated
> > >   */
> > > -
> > > -#define SHRINK_BITE	10000
> > > -static inline unsigned long __shrink_memory(long tmp)
> > > +static unsigned long preallocate_image_memory(unsigned long nr_pages)
> > >  {
> > > -	if (tmp > SHRINK_BITE)
> > > -		tmp = SHRINK_BITE;
> > > -	return shrink_all_memory(tmp);
> > > +	unsigned long nr_alloc = 0;
> > > +
> > > +	while (nr_pages-- > 0) {
> > > +		struct page *page;
> > > +
> > > +		page = alloc_image_page(GFP_KERNEL | __GFP_NOWARN);
> > 
> > Ah... now I see you're using __GFP_NOWARN already :)
> > 
> > > +		if (!page)
> > > +			break;
> > > +		nr_alloc++;
> > > +	}
> > > +
> > > +	return nr_alloc;
> > >  }
> > >  
> > > +/**
> > > + * swsusp_shrink_memory -  Make the kernel release as much memory as needed
> > > + *
> > > + * To create a hibernation image it is necessary to make a copy of every page
> > > + * frame in use.  We also need a number of page frames to be free during
> > > + * hibernation for allocations made while saving the image and for device
> > > + * drivers, in case they need to allocate memory from their hibernation
> > > + * callbacks (these two numbers are given by PAGES_FOR_IO and SPARE_PAGES,
> > > + * respectively, both of which are rough estimates).  To make this happen, we
> > > + * compute the total number of available page frames and allocate at least
> > > + *
> > > + * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2 + 2 * SPARE_PAGES
> > > + *
> > > + * of them, which corresponds to the maximum size of a hibernation image.
> > > + *
> > > + * If image_size is set below the number following from the above formula,
> > > + * the preallocation of memory is continued until the total number of page
> > > + * frames in use is below the requested image size or it is impossible to
> > > + * allocate more memory, whichever happens first.
> > > + */
> > 
> > You should also be taking into account how much storage is available
> > here - that would make things more reliable. If compression is begin
> > used, you could also apply an 'expected compression ratio' so that you
> > don't unnecessarily free memory that will fit once compressed.
> 
> Currently compression is only done in user space so I don't know in advance
> whether or not it's going to be used.

k. I guess it's more worth the effort in our case, but would it be that
hard to do? An extra ioctl, I guess?

> > >  int swsusp_shrink_memory(void)
> > >  {
> > > -	long tmp;
> > >  	struct zone *zone;
> > > -	unsigned long pages = 0;
> > > -	unsigned int i = 0;
> > > -	char *p = "-\\|/";
> > > +	unsigned long saveable, size, max_size, count, pages = 0;
> > >  	struct timeval start, stop;
> > > +	int error = 0;
> > >  
> > > -	printk(KERN_INFO "PM: Shrinking memory...  ");
> > > +	printk(KERN_INFO "PM: Shrinking memory ... ");
> > 
> > Without the space is normal, at least to my mind.
> 
> OK
> 
> > >  	do_gettimeofday(&start);
> > > -	do {
> > > -		long size, highmem_size;
> > >  
> > > -		highmem_size = count_highmem_pages();
> > > -		size = count_data_pages() + PAGES_FOR_IO + SPARE_PAGES;
> > > -		tmp = size;
> > > -		size += highmem_size;
> > > -		for_each_populated_zone(zone) {
> > > -			tmp += snapshot_additional_pages(zone);
> > > -			if (is_highmem(zone)) {
> > > -				highmem_size -=
> > > -					zone_page_state(zone, NR_FREE_PAGES);
> > > -			} else {
> > > -				tmp -= zone_page_state(zone, NR_FREE_PAGES);
> > > -				tmp += zone->lowmem_reserve[ZONE_NORMAL];
> > > -			}
> > > -		}
> > > +	/* Count the number of saveable data pages. */
> > > +	saveable = count_data_pages() + count_highmem_pages();
> > > +
> > > +	/*
> > > +	 * Compute the total number of page frames we can use (count) and the
> > > +	 * number of pages needed for image metadata (size).
> > > +	 */
> > > +	count = saveable;
> > > +	size = 0;
> > > +	for_each_populated_zone(zone) {
> > > +		size += snapshot_additional_pages(zone);
> > > +		count += zone_page_state(zone, NR_FREE_PAGES);
> > > +		if (!is_highmem(zone))
> > > +			count -= zone->lowmem_reserve[ZONE_NORMAL];
> > > +	}
> > >  
> > > -		if (highmem_size < 0)
> > > -			highmem_size = 0;
> > 
> > You're not taking watermarks into account here - that isn't a problem
> > with shrink_all_memory because it usually frees more than you ask for
> > (or has done in the past), but if you're getting exactly what you ask
> > for, you might run into trouble if more than half of memory is in use to
> > start with.
> 
> Hmm, why exactly?

You can't allocate the memory in the watermarks. Or at least, you're not
supposed to - it's supposed to be for 'emergency' allocations - so
things can still make progress in low memory situations. Personally, I
think watermarks should be irrelevant in the hibernation case. We know
almost exactly what's going on in the system. If our code is well
written, we should be able to account for every page being allocated and
freed. (Okay, maybe some leeway for the lowlevel bio code).

> > > +	/* Compute the maximum number of saveable pages to leave in memory. */
> > > +	max_size = (count - (size + PAGES_FOR_IO)) / 2 - 2 * SPARE_PAGES;
> > > +	size = DIV_ROUND_UP(image_size, PAGE_SIZE);
> > > +	if (size > max_size)
> > > +		size = max_size;
> > > +	/*
> > > +	 * If the maximum is not lesser than the current number of saveable
> > 
> > s/lesser/less/
> 
> Right, thanks.
> 
> > > +	 * pages in memory, we don't need to do anything more.
> > > +	 */
> > > +	if (size >= saveable)
> > > +		goto out;
> > >  
> > > -		tmp += highmem_size;
> > > -		if (tmp > 0) {
> > > -			tmp = __shrink_memory(tmp);
> > > -			if (!tmp)
> > > -				return -ENOMEM;
> > > -			pages += tmp;
> > > -		} else if (size > image_size / PAGE_SIZE) {
> > > -			tmp = __shrink_memory(size - (image_size / PAGE_SIZE));
> > > -			pages += tmp;
> > > -		}
> > > -		printk("\b%c", p[i++%4]);
> > > -	} while (tmp > 0);
> > > +	/*
> > > +	 * Let the memory management subsystem know that we're going to need a
> > > +	 * large number of page frames to allocate and make it free some memory.
> > > +	 * NOTE: If this is not done, performance is heavily affected in some
> > > +	 * test cases.
> > > +	 */
> > > +	shrink_all_memory(saveable - size);
> > > +
> > > +	/*
> > > +	 * The number of saveable pages in memory was too high, so apply some
> > > +	 * pressure to decrease it.  First, make room for the largest possible
> > > +	 * image and fail if that doesn't work.  Next, try to decrease the size
> > > +	 * of the image as much as indicated by image_size.
> > > +	 */
> > > +	count -= max_size;
> > > +	pages = preallocate_image_memory(count);
> > > +	if (pages < count)
> > > +		error = -ENOMEM;
> > > +	else
> > > +		pages += preallocate_image_memory(max_size - size);
> > > +
> > > +	/* Release all of the preallocated page frames. */
> > > +	swsusp_free();
> > > +
> > > +	if (error) {
> > > +		printk(KERN_CONT "\n");
> > > +		return error;
> > > +	}
> > > +
> > > + out:
> > >  	do_gettimeofday(&stop);
> > > -	printk("\bdone (%lu pages freed)\n", pages);
> > > +	printk(KERN_CONT "done (preallocated %lu free pages)\n", pages);
> > >  	swsusp_show_speed(&start, &stop, pages, "Freed");
> > >  
> > >  	return 0;

Regards,

Nigel

