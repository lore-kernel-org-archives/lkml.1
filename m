Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbZECLwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbZECLwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 07:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbZECLwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 07:52:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:41362 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbZECLwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 07:52:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,286,1239001200"; 
   d="scan'208";a="138623238"
Date: Sun, 3 May 2009 19:51:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 3/4] PM/Hibernate: Use memory allocations to free
	memory (rev. 2)
Message-ID: <20090503115127.GA9661@localhost>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090502104947.2720f173.akpm@linux-foundation.org> <200905030220.57933.rjw@sisk.pl> <200905030224.21471.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905030224.21471.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 02:24:20AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Modify the hibernation memory shrinking code so that it will make
> memory allocations to free memory instead of using an artificial
> memory shrinking mechanism for that.  Remove the shrinking of
> memory from the suspend-to-RAM code, where it is not really
> necessary.  Finally, remove the no longer used memory shrinking
> functions from mm/vmscan.c .
> 
> [rev. 2: Use the existing memory bitmaps for marking preallocated
>  image pages and use swsusp_free() from releasing them, introduce
>  GFP_IMAGE, add comments describing the memory shrinking strategy.]
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/power/main.c     |   20 ------
>  kernel/power/snapshot.c |  132 +++++++++++++++++++++++++++++++++-----------
>  mm/vmscan.c             |  142 ------------------------------------------------
>  3 files changed, 101 insertions(+), 193 deletions(-)
> 
> Index: linux-2.6/kernel/power/snapshot.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/snapshot.c
> +++ linux-2.6/kernel/power/snapshot.c
> @@ -1066,41 +1066,97 @@ void swsusp_free(void)
>  	buffer = NULL;
>  }
>  
> +/* Helper functions used for the shrinking of memory. */
> +
> +#ifdef CONFIG_HIGHMEM
> +#define GFP_IMAGE	(GFP_KERNEL | __GFP_HIGHMEM | __GFP_NO_OOM_KILL)
> +#else
> +#define GFP_IMAGE	(GFP_KERNEL | __GFP_NO_OOM_KILL)
> +#endif

The CONFIG_HIGHMEM test is not necessary: __GFP_HIGHMEM is always defined.

> +#define SHRINK_BITE	10000

This is ~40MB. A full scan of (for example) 8G pages will be time
consuming, not to mention we have to do it 2*(8G-500M)/40M = 384 times!

Can we make it a LONG_MAX?

Thanks,
Fengguang
