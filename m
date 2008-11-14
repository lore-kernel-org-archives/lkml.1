Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYKNHnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYKNHnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbYKNHnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:43:41 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:55258 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYKNHnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:43:40 -0500
Message-ID: <491D2C21.5000600@linux.vnet.ibm.com>
Date: Fri, 14 Nov 2008 13:13:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080715)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jan Blunck <jblunck@suse.de>, containers@lists.osdl.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: reduce size of per-cpu-stat to be appropriate
 size.
References: <20081113164201.GV29067@bolzano.suse.de> <20081113191837.18ed2ade.akpm@linux-foundation.org> <491CF609.3050203@cn.fujitsu.com> <20081114132840.98d38f12.kamezawa.hiroyu@jp.fujitsu.com> <20081114144926.d91f36fd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081114144926.d91f36fd.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> How about this one ?
> tested on x86-64 + mmotm-Nov10, works well. 
> (test on other arch is welcome.)
> 
> -Kame
> ==
> As  Jan Blunck <jblunck@suse.de> pointed out, allocating
> per-cpu stat for memcg to the size of NR_CPUS is not good.
> 
> This patch changes mem_cgroup's cpustat allocation not based
> on NR_CPUS but based on nr_cpu_ids.
> 
> From: Jan Blunck <jblunck@suse.de>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> ---
>  mm/memcontrol.c |   34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
> 
> Index: mmotm-2.6.28-Nov10/mm/memcontrol.c
> ===================================================================
> --- mmotm-2.6.28-Nov10.orig/mm/memcontrol.c
> +++ mmotm-2.6.28-Nov10/mm/memcontrol.c
> @@ -60,7 +60,7 @@ struct mem_cgroup_stat_cpu {
>  } ____cacheline_aligned_in_smp;
> 
>  struct mem_cgroup_stat {
> -	struct mem_cgroup_stat_cpu cpustat[NR_CPUS];
> +	struct mem_cgroup_stat_cpu cpustat[0];
>  };
> 
>  /*
> @@ -129,11 +129,10 @@ struct mem_cgroup {
> 
>  	int	prev_priority;	/* for recording reclaim priority */
>  	/*
> -	 * statistics.
> +	 * statistics. This must be placed at the end of memcg.
>  	 */
>  	struct mem_cgroup_stat stat;
>  };
> -static struct mem_cgroup init_mem_cgroup;
> 
>  enum charge_type {
>  	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
> @@ -1292,42 +1291,45 @@ static void free_mem_cgroup_per_zone_inf
>  	kfree(mem->info.nodeinfo[node]);
>  }
> 
> +static int mem_cgroup_size(void)

inline this function?

Other than that, I think the cont->parent check for freeing has already been
spotted and pointed out


-- 
	Balbir
