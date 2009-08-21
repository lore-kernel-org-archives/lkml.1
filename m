Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbZHUHHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbZHUHHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 03:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbZHUHH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 03:07:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43009 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbZHUHH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 03:07:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Aug 2009 16:05:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH -mmotm] memcg: show swap usage in stat file
Message-Id: <20090821160542.542a490b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090821152549.038e6953.nishimura@mxp.nes.nec.co.jp>
References: <20090821152549.038e6953.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009 15:25:49 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> We now count MEM_CGROUP_STAT_SWAPOUT, so we can show swap usage.
> It would be useful for users to show swap usage in memory.stat file,
> because they don't need calculate memsw.usage - res.usage to know swap usage.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Indeed.
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Thanks,
-Kame


> ---
>  mm/memcontrol.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8b06c05..ae80de0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2663,6 +2663,7 @@ enum {
>  	MCS_MAPPED_FILE,
>  	MCS_PGPGIN,
>  	MCS_PGPGOUT,
> +	MCS_SWAP,
>  	MCS_INACTIVE_ANON,
>  	MCS_ACTIVE_ANON,
>  	MCS_INACTIVE_FILE,
> @@ -2684,6 +2685,7 @@ struct {
>  	{"mapped_file", "total_mapped_file"},
>  	{"pgpgin", "total_pgpgin"},
>  	{"pgpgout", "total_pgpgout"},
> +	{"swap", "total_swap"},
>  	{"inactive_anon", "total_inactive_anon"},
>  	{"active_anon", "total_active_anon"},
>  	{"inactive_file", "total_inactive_file"},
> @@ -2708,6 +2710,10 @@ static int mem_cgroup_get_local_stat(struct mem_cgroup *mem, void *data)
>  	s->stat[MCS_PGPGIN] += val;
>  	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGOUT_COUNT);
>  	s->stat[MCS_PGPGOUT] += val;
> +	if (do_swap_account) {
> +		val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_SWAPOUT);
> +		s->stat[MCS_SWAP] += val;
> +	}
>  
>  	/* per zone stat */
>  	val = mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_ANON);
> @@ -2739,8 +2745,11 @@ static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
>  	memset(&mystat, 0, sizeof(mystat));
>  	mem_cgroup_get_local_stat(mem_cont, &mystat);
>  
> -	for (i = 0; i < NR_MCS_STAT; i++)
> +	for (i = 0; i < NR_MCS_STAT; i++) {
> +		if (i == MCS_SWAP && !do_swap_account)
> +			continue;
>  		cb->fill(cb, memcg_stat_strings[i].local_name, mystat.stat[i]);
> +	}
>  
>  	/* Hierarchical information */
>  	{
> @@ -2753,9 +2762,11 @@ static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
>  
>  	memset(&mystat, 0, sizeof(mystat));
>  	mem_cgroup_get_total_stat(mem_cont, &mystat);
> -	for (i = 0; i < NR_MCS_STAT; i++)
> +	for (i = 0; i < NR_MCS_STAT; i++) {
> +		if (i == MCS_SWAP && !do_swap_account)
> +			continue;
>  		cb->fill(cb, memcg_stat_strings[i].total_name, mystat.stat[i]);
> -
> +	}
>  
>  #ifdef CONFIG_DEBUG_VM
>  	cb->fill(cb, "inactive_ratio", calc_inactive_ratio(mem_cont, NULL));
> 

