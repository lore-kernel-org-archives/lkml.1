Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbZENLOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbZENLOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZENLOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:14:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44692 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbZENLOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:14:19 -0400
Date: Thu, 14 May 2009 13:14:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       David Rientjes <rientjes@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 6/6] PM/Hibernate: Do not try to allocate too much
	memory too hard
Message-ID: <20090514111413.GB8871@elf.ucw.cz>
References: <200905070040.08561.rjw@sisk.pl> <200905101548.57557.rjw@sisk.pl> <200905131032.53624.rjw@sisk.pl> <200905131042.18137.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905131042.18137.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> We want to avoid attempting to free too much memory too hard during
> hibernation, so estimate the minimum size of the image to use as the
> lower limit for preallocating memory.

Why? Is freeing memory too slow?

It used to be that user controlled image size, so he was able to
balance "time to save image" vs. "responsiveness of system after
resume".

Does this just override user's preference when he chooses too small
image size?

> The approach here is based on the (experimental) observation that we
> can't free more page frames than the sum of:
> 
> * global_page_state(NR_SLAB_RECLAIMABLE)
> * global_page_state(NR_ACTIVE_ANON)
> * global_page_state(NR_INACTIVE_ANON)
> * global_page_state(NR_ACTIVE_FILE)
> * global_page_state(NR_INACTIVE_FILE)
> 
> and even that is usually impossible to free in practice, because some
> of the pages reported as global_page_state(NR_SLAB_RECLAIMABLE) can't
> in fact be freed.  It turns out, however, that if the sum of the
> above numbers is subtracted from the number of saveable pages in the
> system and the result is multiplied by 1.25, we get a suitable
> estimate of the minimum size of the image.



> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/power/snapshot.c |   56 ++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 52 insertions(+), 4 deletions(-)


>  /**
> + * minimum_image_size - Estimate the minimum acceptable size of an image
> + * @saveable: The total number of saveable pages in the system.
> + *
> + * We want to avoid attempting to free too much memory too hard, so estimate the
> + * minimum acceptable size of a hibernation image to use as the lower limit for
> + * preallocating memory.

I don't get it. If user sets image size as 0, we should free as much
memory as we can. I just don't see why "we want to avoid... it".

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
