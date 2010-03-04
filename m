Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab0CDTmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:42:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab0CDTma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:42:30 -0500
Date: Thu, 4 Mar 2010 14:41:44 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 4/4] memcg: dirty pages instrumentation
Message-ID: <20100304194144.GE18786@redhat.com>
References: <1267699215-4101-1-git-send-email-arighi@develer.com> <1267699215-4101-5-git-send-email-arighi@develer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267699215-4101-5-git-send-email-arighi@develer.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 11:40:15AM +0100, Andrea Righi wrote:

[..]
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 5a0f8f3..c5d14ea 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -137,13 +137,16 @@ static struct prop_descriptor vm_dirties;
>   */
>  static int calc_period_shift(void)
>  {
> +	struct dirty_param dirty_param;
>  	unsigned long dirty_total;
>  
> -	if (vm_dirty_bytes)
> -		dirty_total = vm_dirty_bytes / PAGE_SIZE;
> +	get_dirty_param(&dirty_param);
> +
> +	if (dirty_param.dirty_bytes)
> +		dirty_total = dirty_param.dirty_bytes / PAGE_SIZE;
>  	else
> -		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
> -				100;
> +		dirty_total = (dirty_param.dirty_ratio *
> +				determine_dirtyable_memory()) / 100;
>  	return 2 + ilog2(dirty_total - 1);
>  }
>  

Hmm.., I have been staring at this for some time and I think something is
wrong. I don't fully understand the way floating proportions are working
but this function seems to be calculating the period over which we need
to measuer the proportions. (vm_completion proportion and vm_dirties
proportions).

And we this period (shift), when admin updates dirty_ratio or dirty_bytes
etc. In that case we recalculate the global dirty limit and take log2 and
use that as period over which we monitor and calculate proportions.

If yes, then it should be global and not per cgroup (because all our 
accouting of bdi completion is global and not per cgroup).

PeterZ, can tell us more about it. I am just raising the flag here to be
sure.

Thanks
Vivek
