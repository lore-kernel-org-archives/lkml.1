Return-Path: <linux-kernel-owner+w=401wt.eu-S941860AbXHNGSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941860AbXHNGSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 02:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760291AbXHNGSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 02:18:44 -0400
Received: from waste.org ([66.93.16.53]:33646 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759453AbXHNGSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 02:18:43 -0400
Date: Tue, 14 Aug 2007 01:19:40 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       John Berthels <jjberthels@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PSS(proportional set size) accounting in smaps
Message-ID: <20070814061940.GU30556@waste.org>
References: <20070814013350.GA9182@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814013350.GA9182@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 09:33:50AM +0800, Fengguang Wu wrote:
> The "proportional set size" (PSS) of a process is the count of pages it has in
> memory, where each page is divided by the number of processes sharing it. So if
> a process has 1000 pages all to itself, and 1000 shared with one other process,
> its PSS will be 1500.
>                - lwn.net: "ELC: How much memory are applications really using?"
> 
> The PSS proposed by Matt Mackall is a very nice metic for measuring an process's
> memory footprint. So collect and export it via /proc/<pid>/smaps.
> 
> Matt Mackall's pagemap/kpagemap and John Berthels's exmap can also do the job,
> providing pretty much details.  But for PSS, let's do it in a simple way. 

Yes, if people actually want to use this particular metric a lot (and
I obviously personally think it makes a lot of sense), then it should
be done in kernel like this.

> Cc: Matt Mackall <mpm@selenic.com>
> Cc: John Berthels <jjberthels@gmail.com>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  fs/proc/task_mmu.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.23-rc2-mm2.orig/fs/proc/task_mmu.c
> +++ linux-2.6.23-rc2-mm2/fs/proc/task_mmu.c
> @@ -319,6 +319,7 @@ const struct file_operations proc_maps_o
>  struct mem_size_stats
>  {
>  	unsigned long resident;
> +	u64 	      pss;	/* proportional set size: my share of rss */

64 bits?

>  	unsigned long shared_clean;
>  	unsigned long shared_dirty;
>  	unsigned long private_clean;
> @@ -341,6 +342,7 @@ static int smaps_pte_range(pmd_t *pmd, u
>  	pte_t *pte, ptent;
>  	spinlock_t *ptl;
>  	struct page *page;
> +	int mapcount;
>  
>  	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>  	for (; addr != end; pte++, addr += PAGE_SIZE) {
> @@ -357,16 +359,19 @@ static int smaps_pte_range(pmd_t *pmd, u
>  		/* Accumulate the size in pages that have been accessed. */
>  		if (pte_young(ptent) || PageReferenced(page))
>  			mss->referenced += PAGE_SIZE;
> -		if (page_mapcount(page) >= 2) {
> +		mapcount = page_mapcount(page);
> +		if (mapcount >= 2) {
>  			if (pte_dirty(ptent))
>  				mss->shared_dirty += PAGE_SIZE;
>  			else
>  				mss->shared_clean += PAGE_SIZE;
> +			mss->pss += (PAGE_SIZE << 12) / mapcount;

Hmm, what's that shift for? Oh, you're doing fixed-point math.

64-bit divisions are quite expensive on some platforms. The compiler
might be able to do something smarter with common constants like:

   if (mapcount == 1)
      mss->pss += PAGE_SIZE;
   else if (mapcount == 2)
      mss->pss += PAGE_SIZE / 2;
   else if (mapcount == 3)
      mss->pss += PAGE_SIZE / 3;
   else if (mapcount == 4)
      mss->pss += PAGE_SIZE / 4;
   else
      mss->pss += PAGE_SIZE / mapcount;

..but I don't know. I suspect we'll at least want to special-case
mapcount == 1 though.

> +		   sarg.mss.resident      >> 10,
> +		   (unsigned long)(mss->pss >> 22),

And then you're throwing away 22 bits of precision. 10 bits wasn't
enough? Hmmm.. Looks like the worst case is sharing a 4k page 2049
ways, where we'll be off by .999 bytes per 4k page for nearly 50%
error. Your extra 12 bits drops this to .2% error, so I suppose it's
worth it.

But it probably needs a comment.

> -		   sarg.mss.referenced >> 10);
> +		   sarg.mss.referenced    >> 10);

Unrelated change.

-- 
Mathematics is the supreme nostalgia of our time.
