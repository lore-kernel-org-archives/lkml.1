Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYLBHsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYLBHsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 02:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbYLBHsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 02:48:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47476 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYLBHsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 02:48:43 -0500
Date: Tue, 2 Dec 2008 16:47:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] memcg: mem_cgroup->prev_priority protected by lock.
 take2
Message-Id: <20081202164751.0db6ea01.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081202164334.1D0C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081202164334.1D0C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Dec 2008 16:44:18 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> Currently, mem_cgroup doesn't have own lock and almost its member doesn't need.
>  (e.g. mem_cgroup->info is protected by zone lock, mem_cgroup->stat is
>   per cpu variable)
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
> Then "reclaim_param_lock" name is better than "prev_priority_lock".
> 
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Thank you, I'll queue this.

-Kame

> ---
>  mm/memcontrol.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> Index: b/mm/memcontrol.c
> ===================================================================
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -142,6 +142,11 @@ struct mem_cgroup {
>  	 */
>  	struct mem_cgroup_lru_info info;
>  
> +	/*
> +	  protect against reclaim related member.
> +	*/
> +	spinlock_t reclaim_param_lock;
> +
>  	int	prev_priority;	/* for recording reclaim priority */
>  
>  	/*
> @@ -393,18 +398,28 @@ int mem_cgroup_calc_mapped_ratio(struct 
>   */
>  int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
>  {
> -	return mem->prev_priority;
> +	int prev_priority;
> +
> +	spin_lock(&mem->reclaim_param_lock);
> +	prev_priority = mem->prev_priority;
> +	spin_unlock(&mem->reclaim_param_lock);
> +
> +	return prev_priority;
>  }
>  
>  void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem, int priority)
>  {
> +	spin_lock(&mem->reclaim_param_lock);
>  	if (priority < mem->prev_priority)
>  		mem->prev_priority = priority;
> +	spin_unlock(&mem->reclaim_param_lock);
>  }
>  
>  void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem, int priority)
>  {
> +	spin_lock(&mem->reclaim_param_lock);
>  	mem->prev_priority = priority;
> +	spin_unlock(&mem->reclaim_param_lock);
>  }
>  
>  /*
> @@ -1967,6 +1982,7 @@ mem_cgroup_create(struct cgroup_subsys *
>  	}
>  
>  	mem->last_scanned_child = NULL;
> +	spin_lock_init(&mem->reclaim_param_lock);
>  
>  	return &mem->css;
>  free_out:
> 
> 
> 

