Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbZHLNug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbZHLNug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 09:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZHLNug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 09:50:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60696 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbZHLNuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 09:50:35 -0400
Date: Wed, 12 Aug 2009 14:50:36 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-hotplug@vger.kernel.org
Subject: Re: Patch "page-allocator: preserve PFN ordering when __GFP_COLD
	is set" fails on my system
Message-ID: <20090812135036.GE19269@csn.ul.ie>
References: <200908111830.03224.jbe@pengutronix.de> <20090812074753.GL13320@pengutronix.de> <20090812092034.GA19269@csn.ul.ie> <200908121311.35321.jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200908121311.35321.jbe@pengutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 01:11:34PM +0200, Juergen Beisert wrote:
> On Mittwoch, 12. August 2009, Mel Gorman wrote:
> > > > I get the following Ooops message when "udevadm" is running on an ARM
> > > > S3C2440 CPU based system:
> >
> > This is extremely odd. All that patch is doing is changing what order pages
> > are returned in to the caller when __GFP_COLD is specified.  valid memory.
> > Does reverting the patch really make the problem go away?
> 
> At least I can work with the system if I remove this patch. Theres is no oops, 
> so udev creates all the required devnodes and the system comes up into the 
> login prompt.
> 

One reason I can think of that the patch would make a different to booting
is that there is a buffer overrun somewhere. When the pages in one order, the
buffer overrun is into pages that are not being used so it's not spotted. In
the other order, the overrun causes damage. The patch only alters the
order of pages in a linked list and ordinarily that shouldn't make any
functional difference.

Can you enable the config option DEBUG_PAGEALLOC please and tell me if
that blows up in some unexpected fashion? It would also be helpful if
you could enable all slab/slqb/slub debugging (whichever one you are
using).

> > > > [...]
> > > > starting udevd...done
> > > > Unable to handle kernel paging request at virtual address e3540000
> > > > pgd = c39d4000
> > > > [e3540000] *pgd=00000000
> > > > Internal error: Oops: 5 [#1]
> > > > Modules linked in:
> > > > CPU: 0    Not tainted  (2.6.31-rc4-00296-ge084b2d-dirty #10)
> > > > PC is at strlen+0xc/0x20
> > > > LR is at kobject_get_path+0x24/0xa4
> >
> > I haven't tackled this sort of bug before but it looks more likely that
> > there is garbage in the sysfs tree that is being tripped up on.
> 
> Yes, I think so, too. Because the same binary rc5 image runs on an S3C2410 CPU 
> without an oops, but oopses on an S3C2440 (both CPUs are nearly the same, but 
> only nearly). But how to track down such a failure?
> 

Lets start with a full dmesg with CONFIG_DEBUG_KOBJECT and
CONFIG_DEBUG_OBJECTS set and see if anything springs up that looks
unusual on that platform.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
