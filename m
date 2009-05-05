Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbZEEKYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbZEEKYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZEEKYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:24:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbZEEKYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:24:02 -0400
Date: Tue, 5 May 2009 12:23:59 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@android.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] lowmemorykiller: Only iterate over process list when needed.
Message-ID: <20090505102359.GD28917@wotan.suse.de>
References: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 05:26:50PM -0700, David Rientjes wrote:
> From: Arve Hjønnevåg <arve@android.com>
> 
> Use NR_ACTIVE plus NR_INACTIVE as a size estimate for our fake cache
> instead the sum of rss. Neither method is accurate.
> 
> Also skip the process scan, if the amount of memory available is above
> the largest threshold set.
> 
> Signed-off-by: Arve Hjønnevåg <arve@android.com>

Didn't really look at the android stuff because I didn't even know
it was there before. But I asume it is going to be "submitted" to
the kernel proper at some stage (by some means other than a git rename) :)

> ---
>  drivers/staging/android/lowmemorykiller.c |   35 +++++++++++++++++-----------
>  1 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
> --- a/drivers/staging/android/lowmemorykiller.c
> +++ b/drivers/staging/android/lowmemorykiller.c
> @@ -71,23 +71,30 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
>  	}
>  	if(nr_to_scan > 0)
>  		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma %d\n", nr_to_scan, gfp_mask, other_free, min_adj);
> +	rem = global_page_state(NR_ACTIVE) + global_page_state(NR_INACTIVE);
> +	if (nr_to_scan <= 0 || min_adj == OOM_ADJUST_MAX + 1) {
> +		lowmem_print(5, "lowmem_shrink %d, %x, return %d\n", nr_to_scan, gfp_mask, rem);
> +		return rem;
> +	}
> +
>  	read_lock(&tasklist_lock);
>  	for_each_process(p) {
> -		if(p->oomkilladj >= 0 && p->mm) {
> -			tasksize = get_mm_rss(p->mm);
> -			if(nr_to_scan > 0 && tasksize > 0 && p->oomkilladj >= min_adj) {
> -				if(selected == NULL ||
> -				   p->oomkilladj > selected->oomkilladj ||
> -				   (p->oomkilladj == selected->oomkilladj &&
> -				    tasksize > selected_tasksize)) {
> -					selected = p;
> -					selected_tasksize = tasksize;
> -					lowmem_print(2, "select %d (%s), adj %d, size %d, to kill\n",
> -					             p->pid, p->comm, p->oomkilladj, tasksize);
> -				}
> -			}
> -			rem += tasksize;
> +		if (p->oomkilladj < min_adj || !p->mm)
> +			continue;
> +		tasksize = get_mm_rss(p->mm);
> +		if (tasksize <= 0)
> +			continue;
> +		if (selected) {
> +			if (p->oomkilladj < selected->oomkilladj)
> +				continue;
> +			if (p->oomkilladj == selected->oomkilladj &&
> +			    tasksize <= selected_tasksize)
> +				continue;
>  		}
> +		selected = p;
> +		selected_tasksize = tasksize;
> +		lowmem_print(2, "select %d (%s), adj %d, size %d, to kill\n",
> +		             p->pid, p->comm, p->oomkilladj, tasksize);
>  	}
>  	if(selected != NULL) {
>  		lowmem_print(1, "send sigkill to %d (%s), adj %d, size %d\n",
