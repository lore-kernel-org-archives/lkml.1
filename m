Return-Path: <linux-kernel-owner+w=401wt.eu-S1751392AbZL1Clz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbZL1Clz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 21:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZL1Cly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 21:41:54 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42232 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZL1Clx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 21:41:53 -0500
Date: Mon, 28 Dec 2009 11:37:39 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v4 3/4] memcg: rework usage of stats by soft limit
Message-Id: <20091228113739.3c38fd78.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <c2379f3965225b6d62e64c64f8c0e67fee085d7f.1261858972.git.kirill@shutemov.name>
References: <cover.1261858972.git.kirill@shutemov.name>
	<3f29ccc3c93e2defd70fc1c4ca8c133908b70b0b.1261858972.git.kirill@shutemov.name>
	<59a7f92356bf1508f06d12c501a7aa4feffb1bbc.1261858972.git.kirill@shutemov.name>
	<c2379f3965225b6d62e64c64f8c0e67fee085d7f.1261858972.git.kirill@shutemov.name>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009 04:09:01 +0200, "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> Instead of incrementing counter on each page in/out and comparing it
> with constant, we set counter to constant, decrement counter on each
> page in/out and compare it with zero. We want to make comparing as fast
> as possible. On many RISC systems (probably not only RISC) comparing
> with zero is more effective than comparing with a constant, since not
> every constant can be immediate operand for compare instruction.
> 
> Also, I've renamed MEM_CGROUP_STAT_EVENTS to MEM_CGROUP_STAT_SOFTLIMIT,
> since really it's not a generic counter.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  mm/memcontrol.c |   19 ++++++++++++++-----
>  1 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1d71cb4..36eb7af 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -69,8 +69,9 @@ enum mem_cgroup_stat_index {
>  	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
>  	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
>  	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
> -	MEM_CGROUP_STAT_EVENTS,	/* sum of pagein + pageout for internal use */
>  	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
> +	MEM_CGROUP_STAT_SOFTLIMIT, /* decrements on each page in/out.
> +					used by soft limit implementation */
>  
>  	MEM_CGROUP_STAT_NSTATS,
>  };
> @@ -90,6 +91,13 @@ __mem_cgroup_stat_reset_safe(struct mem_cgroup_stat_cpu *stat,
>  	stat->count[idx] = 0;
>  }
>  
> +static inline void
> +__mem_cgroup_stat_set(struct mem_cgroup_stat_cpu *stat,
> +		enum mem_cgroup_stat_index idx, s64 val)
> +{
> +	stat->count[idx] = val;
> +}
> +
I think it would be better to name it __mem_cgroup_stat_set_safe.
And could you remove the definition of __mem_cgroup_stat_reset ?


Thanks,
Daisuke Nishimura.

>  static inline s64
>  __mem_cgroup_stat_read_local(struct mem_cgroup_stat_cpu *stat,
>  				enum mem_cgroup_stat_index idx)
> @@ -380,9 +388,10 @@ static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
>  
>  	cpu = get_cpu();
>  	cpustat = &mem->stat.cpustat[cpu];
> -	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
> -	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
> -		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
> +	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_SOFTLIMIT);
> +	if (unlikely(val < 0)) {
> +		__mem_cgroup_stat_set(cpustat, MEM_CGROUP_STAT_SOFTLIMIT,
> +				SOFTLIMIT_EVENTS_THRESH);
>  		ret = true;
>  	}
>  	put_cpu();
> @@ -515,7 +524,7 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
>  	else
>  		__mem_cgroup_stat_add_safe(cpustat,
>  				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
> -	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_EVENTS, 1);
> +	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_SOFTLIMIT, -1);
>  	put_cpu();
>  }
>  
> -- 
> 1.6.5.7
> 
