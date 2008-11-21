Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYKUKdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYKUKdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYKUKc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:32:59 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39163 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbYKUKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:32:59 -0500
Date: Fri, 21 Nov 2008 19:32:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] memcontrol: rcu_read_lock() to protect
 mm_match_cgroup()
Message-Id: <20081121193210.d7760fd6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49267627.80103@cn.fujitsu.com>
References: <49267627.80103@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 16:49:43 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> 
> mm_match_cgroup() calls cgroup_subsys_state().
> 
> we must use rcu_read_lock() to protect cgroup_subsys_state().
> 
Thanks,
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 1fbe14d..ce89ff0 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -47,8 +47,15 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
>  
>  extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
>  
> -#define mm_match_cgroup(mm, cgroup)	\
> -	((cgroup) == mem_cgroup_from_task((mm)->owner))
> +static inline
> +int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
> +{
> +	struct mem_cgroup *mem;
> +	rcu_read_lock();
> +	mem = mem_cgroup_from_task((mm)->owner);
> +	rcu_read_unlock();
> +	return cgroup == mem;
> +}
>  
>  extern int
>  mem_cgroup_prepare_migration(struct page *page, struct page *newpage);
> 
> 

