Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYLBHQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYLBHQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 02:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYLBHQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 02:16:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43368 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYLBHQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 02:16:36 -0500
Date: Tue, 2 Dec 2008 16:15:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] memcg: mem_cgroup->prev_priority protected by lock.
Message-Id: <20081202161545.abb884e8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081202160949.1CFE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081202160949.1CFE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Dec 2008 16:11:07 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> Currently, mem_cgroup doesn't have own lock and almost its member doesn't need.
>  (e.g. info is protected by zone lock, stat is per cpu variable)
> 
> However, there is one explict exception. mem_cgroup->prev_priorit need lock,
> but doesn't protect.
> Luckly, this is NOT bug because prev_priority isn't used for current reclaim code.
> 
> However, we plan to use prev_priority future again.
> Therefore, fixing is better.
> 
> 
> In addision, we plan to reuse this lock for another member.
> Then "misc_lock" name is better than "prev_priority_lock".
> 
please use better name...reclaim_param_lock or some ?

-Kame


> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |   20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> Index: b/mm/memcontrol.c
> ===================================================================
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -142,6 +142,13 @@ struct mem_cgroup {
>  	 */
>  	struct mem_cgroup_lru_info info;
>  
> +	/*
> +	  Almost mem_cgroup member doesn't need lock.
> +	  (e.g. info is protected by zone lock, stat is per cpu variable)
> +	  However, rest few member need explict lock.
> +	*/
> +	spinlock_t misc_lock;
> +
>  	int	prev_priority;	/* for recording reclaim priority */
>  
>  	/*
> @@ -393,18 +400,28 @@ int mem_cgroup_calc_mapped_ratio(struct 
>   */
>  int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
>  {
> -	return mem->prev_priority;
> +	int prev_priority;
> +
> +	spin_lock(&mem->misc_lock);
> +	prev_priority = mem->prev_priority;
> +	spin_unlock(&mem->misc_lock);
> +
> +	return prev_priority;
>  }
>  
>  void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem, int priority)
>  {
> +	spin_lock(&mem->misc_lock);
>  	if (priority < mem->prev_priority)
>  		mem->prev_priority = priority;
> +	spin_unlock(&mem->misc_lock);
>  }
>  
>  void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem, int priority)
>  {
> +	spin_lock(&mem->misc_lock);
>  	mem->prev_priority = priority;
> +	spin_unlock(&mem->misc_lock);
>  }
>  
>  /*
> @@ -1967,6 +1984,7 @@ mem_cgroup_create(struct cgroup_subsys *
>  	}
>  
>  	mem->last_scanned_child = NULL;
> +	spin_lock_init(&mem->misc_lock);
>  
>  	return &mem->css;
>  free_out:
> 
> 
> 

