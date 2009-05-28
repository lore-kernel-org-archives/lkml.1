Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbZE1AZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbZE1AZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758665AbZE1AZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:25:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51762 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895AbZE1AZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:25:19 -0400
Date: Thu, 28 May 2009 09:23:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, riel@redhat.com,
       hugh.dickins@tiscali.co.uk
Subject: Re: [patch] mm: release swap slots for actively used pages
Message-Id: <20090528092345.58f31056.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090527161535.ac2dd1ba.akpm@linux-foundation.org>
References: <1243388859-9760-1-git-send-email-hannes@cmpxchg.org>
	<20090527161535.ac2dd1ba.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 16:15:35 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 27 May 2009 03:47:39 +0200
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > For anonymous pages activated by the reclaim scan or faulted from an
> > evicted page table entry we should always try to free up swap space.
> > 
> > Both events indicate that the page is in active use and a possible
> > change in the working set.  Thus removing the slot association from
> > the page increases the chance of the page being placed near its new
> > LRU buddies on the next eviction and helps keeping the amount of stale
> > swap cache entries low.
> > 
> > try_to_free_swap() inherently only succeeds when the last user of the
> > swap slot vanishes so it is safe to use from places where that single
> > mapping just brought the page back to life.
> > 
> 
> Seems that this has a risk of worsening swap fragmentation for some
> situations.  Or not, I have no way of knowing, really.
> 
I'm afraid, too.

> > diff --git a/mm/memory.c b/mm/memory.c
> > index 8b4e40e..407ebf7 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2671,8 +2671,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
> >  	mem_cgroup_commit_charge_swapin(page, ptr);
> >  
> >  	swap_free(entry);
> > -	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
> > -		try_to_free_swap(page);
> > +	try_to_free_swap(page);
> >  	unlock_page(page);
> >  
> >  	if (write_access) {
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 621708f..2f0549d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -788,7 +788,7 @@ cull_mlocked:
> >  
> >  activate_locked:
> >  		/* Not a candidate for swapping, so reclaim swap space. */
> > -		if (PageSwapCache(page) && vm_swap_full())
> > +		if (PageSwapCache(page))
> >  			try_to_free_swap(page);
> >  		VM_BUG_ON(PageActive(page));
> >  		SetPageActive(page);
> 
> How are we to know that this is a desirable patch for Linux??

I'm not sure what is the "purpose/benefit" of this patch...
In patch description,
"we should always try to free up swap space" ...then, why "should" ?

Thanks,
-Kame

