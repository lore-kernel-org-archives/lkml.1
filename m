Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZELJYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZELJYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZELJXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:23:53 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43293 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbZELJXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:23:52 -0400
Date: Tue, 12 May 2009 10:23:48 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 02/11 -mmotm] lowmemorykiller: Don't count free space
	unless it meets the specified limit by itself
Message-ID: <20090512092347.GB25923@csn.ul.ie>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101459370.18804@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.0905101459370.18804@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 03:07:10PM -0700, David Rientjes wrote:
> From: Arve Hjønnevåg <arve@android.com>
> 
> This allows processes to be killed when the kernel evict cache pages in
> an attempt to get more contiguous free memory.
> 

I'm not seeing what this patch has to do with contiguous free memory. I
see what the patch is doing - lowering the threshold allowing a
particular min_adj value to be used, but not why.


> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> ---
>  drivers/staging/android/lowmemorykiller.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
> --- a/drivers/staging/android/lowmemorykiller.c
> +++ b/drivers/staging/android/lowmemorykiller.c
> @@ -58,20 +58,25 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
>  	int min_adj = OOM_ADJUST_MAX + 1;
>  	int selected_tasksize = 0;
>  	int array_size = ARRAY_SIZE(lowmem_adj);
> -	int other_free = global_page_state(NR_FREE_PAGES) + global_page_state(NR_FILE_PAGES);
> +	int other_free = global_page_state(NR_FREE_PAGES);
> +	int other_file = global_page_state(NR_FILE_PAGES);
>  	if(lowmem_adj_size < array_size)
>  		array_size = lowmem_adj_size;
>  	if(lowmem_minfree_size < array_size)
>  		array_size = lowmem_minfree_size;
>  	for(i = 0; i < array_size; i++) {

It would appear that lowmem_adj_size is making assumptions on
the number of zones that exist in the system. It's not clear why
sysctl_lowmem_reserve_ratio[] is not being used or how they differ.

> -		if(other_free < lowmem_minfree[i]) {
> +		if (other_free < lowmem_minfree[i] &&
> +		    other_file < lowmem_minfree[i]) {
>  			min_adj = lowmem_adj[i];
>  			break;
>  		}
>  	}
>  	if(nr_to_scan > 0)
> -		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma %d\n", nr_to_scan, gfp_mask, other_free, min_adj);
> -	rem = global_page_state(NR_ACTIVE) + global_page_state(NR_INACTIVE);
> +		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d %d, ma %d\n", nr_to_scan, gfp_mask, other_free, other_file, min_adj);
> +	rem = global_page_state(NR_ACTIVE_ANON) +
> +		global_page_state(NR_ACTIVE_FILE) +
> +		global_page_state(NR_INACTIVE_ANON) +
> +		global_page_state(NR_INACTIVE_FILE);

This looks like it's a compile fix since changes made to 4f98a2fe. This
should have been in a separate patch and prioritised.

>  	if (nr_to_scan <= 0 || min_adj == OOM_ADJUST_MAX + 1) {
>  		lowmem_print(5, "lowmem_shrink %d, %x, return %d\n", nr_to_scan, gfp_mask, rem);
>  		return rem;

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
