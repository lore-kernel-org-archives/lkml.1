Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZEECre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZEECre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 22:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbZEECrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 22:47:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:2106 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360AbZEECrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 22:47:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,294,1239001200"; 
   d="scan'208";a="139174603"
Date: Tue, 5 May 2009 10:46:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-pm@lists.linux-foundation.org" 
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
Message-ID: <20090505024646.GA14621@localhost>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905031830.49690.rjw@sisk.pl> <200905040208.43040.rjw@sisk.pl> <200905040222.39062.rjw@sisk.pl> <20090505022427.GA10880@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505022427.GA10880@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 10:24:27AM +0800, Wu Fengguang wrote:
> On Mon, May 04, 2009 at 08:22:38AM +0800, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Since the hibernation code is now going to use allocations of memory
> > to create enough room for the image, it can also use the page frames
> > allocated at this stage as image page frames.  The low-level
> > hibernation code needs to be rearranged for this purpose, but it
> > allows us to avoid freeing a great number of pages and allocating
> > these same pages once again later, so it generally is worth doing.
> > 
> > [rev. 2: Change the strategy of preallocating memory to allocate as
> >  many pages as needed to get the right image size in one shot (the
> >  excessive allocated pages are released afterwards).]
> 
> Rafael, I tried out your patches and found doubled memory shrink speed!
> 
> [  579.641781] PM: Preallocating image memory ... done (allocated 383900 pages, 128000 image pages kept)
> [  583.087875] PM: Allocated 1535600 kbytes in 3.43 seconds (447.69 MB/s)
 
> For you reference, here is the free memory before/after
> hibernate_preallocate_memory():
> 
>         # free
>                      total       used       free     shared    buffers     cached
>         Mem:          1933       1917         15          0          0       1845
>         -/+ buffers/cache:         72       1861
>         Swap:            0          0          0
> 
>         # free
>                      total       used       free     shared    buffers     cached
>         Mem:          1933        920       1012          0          0        356
>         -/+ buffers/cache:        563       1369
>         Swap:            0          0          0
> 
> It seems that the preallocated memory is not freed on -ENOMEM.

Ah, this was my fault.

I used to do this debugging trick:

        @@ -1207,7 +1207,7 @@ int hibernate_preallocate_memory(void)
                        pages, size);
                swsusp_show_speed(&start, &stop, pages, "Allocated");

        -       return 0;
        +       return -ENOMEM;

          err_out:
                printk(KERN_CONT "\n");

That "return -ENOMEM" should be "error = -ENOMEM" :-)

Here is one more run:

[  194.016991] PM: Preallocating image memory ... done (allocated 383897 pages, 128000 image pages kept)
[  196.505999] PM: Allocated 1535588 kbytes in 2.47 seconds (621.69 MB/s)

Now the free report is back to normal:

# free
             total       used       free     shared    buffers     cached
Mem:          1933         74       1858          0          0         15


Thanks,
Fengguang
