Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab0BPGOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 01:14:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:60158 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab0BPGOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 01:14:32 -0500
Date: Tue, 16 Feb 2010 17:14:27 +1100
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 1/9 v2] oom: filter tasks not sharing the same
 cpuset
Message-ID: <20100216061427.GY5723@laptop>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1002151417330.26927@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002151417330.26927@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 02:20:01PM -0800, David Rientjes wrote:
> Tasks that do not share the same set of allowed nodes with the task that
> triggered the oom should not be considered as candidates for oom kill.
> 
> Tasks in other cpusets with a disjoint set of mems would be unfairly
> penalized otherwise because of oom conditions elsewhere; an extreme
> example could unfairly kill all other applications on the system if a
> single task in a user's cpuset sets itself to OOM_DISABLE and then uses
> more memory than allowed.
> 
> Killing tasks outside of current's cpuset rarely would free memory for
> current anyway.
> 
> Acked-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Nick Piggin <npiggin@suse.de>

> ---
>  mm/oom_kill.c |   12 +++---------
>  1 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -35,7 +35,7 @@ static DEFINE_SPINLOCK(zone_scan_lock);
>  /* #define DEBUG */
>  
>  /*
> - * Is all threads of the target process nodes overlap ours?
> + * Do all threads of the target process overlap our allowed nodes?
>   */
>  static int has_intersects_mems_allowed(struct task_struct *tsk)
>  {
> @@ -167,14 +167,6 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
>  		points /= 4;
>  
>  	/*
> -	 * If p's nodes don't overlap ours, it may still help to kill p
> -	 * because p may have allocated or otherwise mapped memory on
> -	 * this node before. However it will be less likely.
> -	 */
> -	if (!has_intersects_mems_allowed(p))
> -		points /= 8;
> -
> -	/*
>  	 * Adjust the score by oom_adj.
>  	 */
>  	if (oom_adj) {
> @@ -266,6 +258,8 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
>  			continue;
>  		if (mem && !task_in_mem_cgroup(p, mem))
>  			continue;
> +		if (!has_intersects_mems_allowed(p))
> +			continue;
>  
>  		/*
>  		 * This task already has access to memory reserves and is
