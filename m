Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab0CAINv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:13:51 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61644 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0CAINt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:13:49 -0500
Date: Mon, 1 Mar 2010 17:05:35 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH -mmotm 1/2] memcg: dirty pages accounting and limiting
 infrastructure
Message-Id: <20100301170535.2f1db0ed.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1267224751-6382-2-git-send-email-arighi@develer.com>
References: <1267224751-6382-1-git-send-email-arighi@develer.com>
	<1267224751-6382-2-git-send-email-arighi@develer.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 23:52:30 +0100, Andrea Righi <arighi@develer.com> wrote:
> Infrastructure to account dirty pages per cgroup and add dirty limit
> interfaces in the cgroupfs:
> 
>  - Active write-out: memory.dirty_ratio, memory.dirty_bytes
>  - Background write-out: memory.dirty_background_ratio, memory.dirty_background_bytes
> 
It looks good for me in general.

> Signed-off-by: Andrea Righi <arighi@develer.com>
> ---
>  include/linux/memcontrol.h |   74 +++++++++-
>  mm/memcontrol.c            |  354 ++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 399 insertions(+), 29 deletions(-)
> 

(snip)

> +s64 mem_cgroup_page_stat(enum mem_cgroup_page_stat_item item)
> +{
> +	struct mem_cgroup_page_stat stat = {};
> +	struct mem_cgroup *memcg;
> +
I think it would be better to add "if (mem_cgroup_disabled())".

> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_task(current);
> +	if (memcg) {
> +		/*
> +		 * Recursively evaulate page statistics against all cgroup
> +		 * under hierarchy tree
> +		 */
> +		stat.item = item;
> +		mem_cgroup_walk_tree(memcg, &stat, mem_cgroup_page_stat_cb);
> +	} else
> +		stat.value = -ENOMEM;
> +	rcu_read_unlock();
> +
> +	return stat.value;
> +}
> +
>  static int mem_cgroup_count_children_cb(struct mem_cgroup *mem, void *data)
>  {
>  	int *val = data;
> @@ -1263,10 +1419,10 @@ static void record_last_oom(struct mem_cgroup *mem)
>  }
>  
>  /*
> - * Currently used to update mapped file statistics, but the routine can be
> - * generalized to update other statistics as well.
> + * Generalized routine to update memory cgroup statistics.
>   */
> -void mem_cgroup_update_file_mapped(struct page *page, int val)
> +void mem_cgroup_update_stat(struct page *page,
> +			enum mem_cgroup_stat_index idx, int val)
>  {
>  	struct mem_cgroup *mem;
>  	struct page_cgroup *pc;
ditto.

> @@ -1286,7 +1442,8 @@ void mem_cgroup_update_file_mapped(struct page *page, int val)
>  	/*
>  	 * Preemption is already disabled. We can use __this_cpu_xxx
>  	 */
> -	__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED], val);
> +	VM_BUG_ON(idx >= MEM_CGROUP_STAT_NSTATS);
> +	__this_cpu_add(mem->stat->count[idx], val);
>  
>  done:
>  	unlock_page_cgroup(pc);


Thanks,
Daisuke Nishimura.
