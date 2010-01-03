Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925Ab0ACX7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0ACX7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 18:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837Ab0ACX7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 18:59:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54747 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab0ACX7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 18:59:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 4 Jan 2010 08:56:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] memcg: rework usage of stats by soft limit
Message-Id: <20100104085632.1ac97a5a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <03152dd4f660cff87b16bb581718b1c53d4775aa.1262186098.git.kirill@shutemov.name>
References: <cover.1262186097.git.kirill@shutemov.name>
	<9411cbdd545e1232c916bfef03a60cf95510016d.1262186098.git.kirill@shutemov.name>
	<34fedc324199dd64149889ed6eac5d8f9441a9db.1262186098.git.kirill@shutemov.name>
	<03152dd4f660cff87b16bb581718b1c53d4775aa.1262186098.git.kirill@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Dec 2009 17:57:58 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

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
> 
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> 
> KAMEZAWA-san, I've changed the patch a bit. Can I reuse your Acked-by?
> 
> ---
>  mm/memcontrol.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1d71cb4..c36d4f3 100644
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
> @@ -84,10 +85,10 @@ struct mem_cgroup_stat {
>  };
>  
>  static inline void
> -__mem_cgroup_stat_reset_safe(struct mem_cgroup_stat_cpu *stat,
> -				enum mem_cgroup_stat_index idx)
> +__mem_cgroup_stat_set_safe(struct mem_cgroup_stat_cpu *stat,
> +				enum mem_cgroup_stat_index idx, s64 val)
>  {
> -	stat->count[idx] = 0;
> +	stat->count[idx] = val;
>  }
>  
>  static inline s64
> @@ -380,9 +381,10 @@ static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
>  
>  	cpu = get_cpu();
>  	cpustat = &mem->stat.cpustat[cpu];
> -	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
> -	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
> -		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
> +	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_SOFTLIMIT);
> +	if (unlikely(val < 0)) {
> +		__mem_cgroup_stat_set_safe(cpustat, MEM_CGROUP_STAT_SOFTLIMIT,
> +				SOFTLIMIT_EVENTS_THRESH);
>  		ret = true;
>  	}
>  	put_cpu();
> @@ -515,7 +517,7 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
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
> 

