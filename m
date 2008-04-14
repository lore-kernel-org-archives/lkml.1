Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbYDNHLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbYDNHLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbYDNHLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:11:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59104 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbYDNHLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:11:19 -0400
Date: Mon, 14 Apr 2008 16:14:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: fix oops in oom handling
Message-Id: <20080414161428.27f3ee59.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4802FF10.6030905@cn.fujitsu.com>
References: <4802FF10.6030905@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 14:52:00 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> It's reproducable in a x86_64 box, but doesn't happen in x86_32.
> 
> This is because tsk->sighand is not guarded by RCU, so we have to
> hold tasklist_lock, just as what out_of_memory() does.
> 

Good catch! and patch seems good.

Paul, I have one confirmation. Lock hierarchy of
	cgroup_lock()
	->	read_lock(&tasklist_lock)

is ok ? (I think this is ok.)

Thanks,
-Kame

> Signed-off-by: Li Zefan <lizf@cn.fujitsu>
> ---
>  mm/oom_kill.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index f255eda..beb592f 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -423,7 +423,7 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
>  	struct task_struct *p;
>  
>  	cgroup_lock();
> -	rcu_read_lock();
> +	read_lock(&tasklist_lock);
>  retry:
>  	p = select_bad_process(&points, mem);
>  	if (PTR_ERR(p) == -1UL)
> @@ -436,7 +436,7 @@ retry:
>  				"Memory cgroup out of memory"))
>  		goto retry;
>  out:
> -	rcu_read_unlock();
> +	read_unlock(&tasklist_lock);
>  	cgroup_unlock();
>  }
>  #endif
> -- 1.5.4.rc3 
> 
> 
> 
> 

