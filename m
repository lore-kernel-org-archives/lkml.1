Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbZIDHrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbZIDHrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932596AbZIDHrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:47:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50237 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbZIDHrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:47:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Sep 2009 16:45:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [mmotm][BUGFIX][PATCH] memcg: fix softlimit css refcnt
 handling.
Message-Id: <20090904164517.fb2bf3c5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090904163758.a5604fee.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090902093438.eed47a57.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902134114.b6f1a04d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902182923.c6d98fd6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090903141727.ccde7e91.nishimura@mxp.nes.nec.co.jp>
	<20090904131835.ac2b8cc8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904141157.4640ec1e.nishimura@mxp.nes.nec.co.jp>
	<20090904142143.15ffcb53.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904142654.08dd159f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904154050.25873aa5.nishimura@mxp.nes.nec.co.jp>
	<20090904163758.a5604fee.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 16:37:58 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> ==
> SoftLimit tree 'find next one' loop uses next_mz to remember
> next one to be visited if reclaimd==0.
> But css'refcnt handling for next_mz is not enough and it makes
> css->refcnt leak.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
maybe this patch can be applied after
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch

Thanks,
-Kmae



> 
> ---
>  mm/memcontrol.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> Index: mmotm-2.6.31-Aug27/mm/memcontrol.c
> ===================================================================
> --- mmotm-2.6.31-Aug27.orig/mm/memcontrol.c
> +++ mmotm-2.6.31-Aug27/mm/memcontrol.c
> @@ -2261,6 +2261,8 @@ unsigned long mem_cgroup_soft_limit_recl
>  		if (!reclaimed) {
>  			do {
>  				/*
> +				 * Loop until we find yet another one.
> +				 *
>  				 * By the time we get the soft_limit lock
>  				 * again, someone might have aded the
>  				 * group back on the RB tree. Iterate to
> @@ -2271,7 +2273,12 @@ unsigned long mem_cgroup_soft_limit_recl
>  				 */
>  				next_mz =
>  				__mem_cgroup_largest_soft_limit_node(mctz);
> -			} while (next_mz == mz);
> +				if (next_mz == mz) {
> +					css_put(&next_mz->mem->css);
> +					next_mz = NULL;
> +				} else /* next_mz == NULL or other memcg */
> +					break;
> +			} while (1);
>  		}
>  		mz->usage_in_excess =
>  			res_counter_soft_limit_excess(&mz->mem->res);
> @@ -2299,6 +2306,8 @@ unsigned long mem_cgroup_soft_limit_recl
>  			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
>  			break;
>  	} while (!nr_reclaimed);
> +	if (next_mz)
> +		css_put(&next_mz->mem->css);
>  	return nr_reclaimed;
>  }
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

