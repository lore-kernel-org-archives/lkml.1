Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYK1KwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYK1KwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYK1KwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:52:10 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41315 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYK1KwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:52:09 -0500
Date: Fri, 28 Nov 2008 19:51:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH -mmotm 1/2] take account of memsw
Message-Id: <20081128195117.a7e7a159.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081128180737.9d6553b8.nishimura@mxp.nes.nec.co.jp>
References: <20081128180252.b7a73c86.nishimura@mxp.nes.nec.co.jp>
	<20081128180737.9d6553b8.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 18:07:37 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> mem_cgroup_hierarchical_reclaim checks only mem->res now.
> It should also check mem->memsw when do_swap_account.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

make sense

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  mm/memcontrol.c |   17 +++++++++++++++--
>  1 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 20e1d90..e7806fc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -567,6 +567,19 @@ done:
>  	return ret;
>  }
>  
> +static int mem_cgroup_check_under_limit(struct mem_cgroup *mem)
> +{
> +	if (do_swap_account) {
> +		if (res_counter_check_under_limit(&mem->res) &&
> +		    res_counter_check_under_limit(&mem->memsw))
> +			return 1;
> +	} else
> +		if (res_counter_check_under_limit(&mem->res))
> +			return 1;
> +
> +	return 0;
> +}
> +
>  /*
>   * Dance down the hierarchy if needed to reclaim memory. We remember the
>   * last child we reclaimed from, so that we don't end up penalizing
> @@ -588,7 +601,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
>  	 * have left.
>  	 */
>  	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap);
> -	if (res_counter_check_under_limit(&root_mem->res))
> +	if (mem_cgroup_check_under_limit(root_mem))
>  		return 0;
>  
>  	next_mem = mem_cgroup_get_first_node(root_mem);
> @@ -602,7 +615,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
>  			continue;
>  		}
>  		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap);
> -		if (res_counter_check_under_limit(&root_mem->res))
> +		if (mem_cgroup_check_under_limit(root_mem))
>  			return 0;
>  		cgroup_lock();
>  		next_mem = mem_cgroup_get_next_node(next_mem, root_mem);
> 

