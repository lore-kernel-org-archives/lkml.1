Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYKLL0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYKLL0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 06:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYKLL0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 06:26:40 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:38156 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYKLL0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:26:39 -0500
Message-ID: <491ABD61.7090502@linux.vnet.ibm.com>
Date: Wed, 12 Nov 2008 16:56:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] [BUGFIX]cgroup: fix potential deadlock in pre_destroy
 (v2)
References: <20081112133002.15c929c3.kamezawa.hiroyu@jp.fujitsu.com> <20081112163256.b36d6952.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081112163256.b36d6952.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> This is fixed one. Thank you for all help.
> 
> Regards,
> -Kame
> ==
> As Balbir pointed out, memcg's pre_destroy handler has potential deadlock.
> 
> It has following lock sequence.
> 
> 	cgroup_mutex (cgroup_rmdir)
> 	    -> pre_destroy -> mem_cgroup_pre_destroy-> force_empty
> 		-> cpu_hotplug.lock. (lru_add_drain_all->
> 				      schedule_work->
>                                       get_online_cpus)
> 
> But, cpuset has following.
> 	cpu_hotplug.lock (call notifier)
> 		-> cgroup_mutex. (within notifier)
> 
> Then, this lock sequence should be fixed.
> 
> Considering how pre_destroy works, it's not necessary to holding
> cgroup_mutex() while calling it. 
> 
> As side effect, we don't have to wait at this mutex while memcg's force_empty
> works.(it can be long when there are tons of pages.)
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> ---
>  kernel/cgroup.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> Index: mmotm-2.6.28-Nov10/kernel/cgroup.c
> ===================================================================
> --- mmotm-2.6.28-Nov10.orig/kernel/cgroup.c
> +++ mmotm-2.6.28-Nov10/kernel/cgroup.c
> @@ -2475,10 +2475,7 @@ static int cgroup_rmdir(struct inode *un
>  		mutex_unlock(&cgroup_mutex);
>  		return -EBUSY;
>  	}
> -
> -	parent = cgrp->parent;
> -	root = cgrp->root;
> -	sb = root->sb;
> +	mutex_unlock(&cgroup_mutex);
> 
>  	/*
>  	 * Call pre_destroy handlers of subsys. Notify subsystems
> @@ -2486,7 +2483,14 @@ static int cgroup_rmdir(struct inode *un
>  	 */
>  	cgroup_call_pre_destroy(cgrp);
> 
> -	if (cgroup_has_css_refs(cgrp)) {
> +	mutex_lock(&cgroup_mutex);
> +	parent = cgrp->parent;
> +	root = cgrp->root;
> +	sb = root->sb;
> +
> +	if (atomic_read(&cgrp->count)
> +	    || !list_empty(&cgrp->children)
> +	    || cgroup_has_css_refs(cgrp)) {
>  		mutex_unlock(&cgroup_mutex);
>  		return -EBUSY;
>  	}
> 

I think the last statement deserves a comment that after re-acquiring the lock,
we need to check if count, children or references changed. Otherwise looks good,
though I've not yet tested it.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
