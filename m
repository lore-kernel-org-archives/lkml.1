Return-Path: <linux-kernel-owner+w=401wt.eu-S941362AbXHNF31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941362AbXHNF31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933858AbXHNF24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:28:56 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:37631 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940470AbXHNF2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:28:54 -0400
Message-ID: <46C13D43.8070502@linux.vnet.ibm.com>
Date: Tue, 14 Aug 2007 10:57:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: WU Fengguang <wfg@mail.ustc.edu.cn>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       John Berthels <jjberthels@gmail.com>, Matt Mackall <mpm@selenic.com>
Subject: [Fwd: Re: [PATCH] PSS(proportional set size) accounting in smaps]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I keep forgetting to check that you are on the cc. My email client
loves dropping you from the to/cc list.



-------- Original Message --------
Subject: Re: [PATCH] PSS(proportional set size) accounting in smaps
Date: Tue, 14 Aug 2007 10:56:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
To: Andrew Morton <akpm@linux-foundation.org>,  Matt Mackall <mpm@selenic.com>, John Berthels <jjberthels@gmail.com>,  linux-kernel <linux-kernel@vger.kernel.org>
References: <387055231.26624@ustc.edu.cn>

Fengguang Wu wrote:
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
> 
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: John Berthels <jjberthels@gmail.com>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

I like the idea of moving towards PSS. I had sent some patches back in December
last year

http://marc.info/?l=linux-mm&m=116738715329816&w=4


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

This accounting is of-course racy. Mapcount can change any moment.


>  			if (pte_dirty(ptent))
>  				mss->shared_dirty += PAGE_SIZE;
>  			else
>  				mss->shared_clean += PAGE_SIZE;
> +			mss->pss += (PAGE_SIZE << 12) / mapcount;
>  		} else {
>  			if (pte_dirty(ptent))
>  				mss->private_dirty += PAGE_SIZE;
>  			else
>  				mss->private_clean += PAGE_SIZE;
> +			mss->pss += (PAGE_SIZE << 12);
>  		}
>  	}
>  	pte_unmap_unlock(pte - 1, ptl);
> @@ -395,18 +400,20 @@ static int show_smap(struct seq_file *m,
>  	seq_printf(m,
>  		   "Size:           %8lu kB\n"
>  		   "Rss:            %8lu kB\n"
> +		   "Pss:            %8lu kB\n"
>  		   "Shared_Clean:   %8lu kB\n"
>  		   "Shared_Dirty:   %8lu kB\n"
>  		   "Private_Clean:  %8lu kB\n"
>  		   "Private_Dirty:  %8lu kB\n"
>  		   "Referenced:     %8lu kB\n",
>  		   (vma->vm_end - vma->vm_start) >> 10,
> -		   sarg.mss.resident >> 10,
> +		   sarg.mss.resident      >> 10,
> +		   (unsigned long)(mss->pss >> 22),
>  		   sarg.mss.shared_clean  >> 10,
>  		   sarg.mss.shared_dirty  >> 10,
>  		   sarg.mss.private_clean >> 10,
>  		   sarg.mss.private_dirty >> 10,
> -		   sarg.mss.referenced >> 10);
> +		   sarg.mss.referenced    >> 10);
> 
>  	return ret;
>  }
> 

If we are reasonably sure that mapping will not change at the time
of page_rmap_xxxxx() operations, we could handle shared accounting
at those points and implement accurate shared accounting.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
