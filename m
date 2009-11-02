Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZKBRL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZKBRL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbZKBRL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:11:28 -0500
Received: from smtp2.ultrahosting.com ([74.213.174.253]:59230 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750845AbZKBRL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:11:27 -0500
Date: Mon, 2 Nov 2009 12:05:09 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       aarcange@redhat.com, akpm@linux-foundation.org, minchan.kim@gmail.com,
       rientjes@google.com, vedran.furac@gmail.com,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][-mm][PATCH 1/6] oom-killer: updates for classification of
 OOM
In-Reply-To: <20091102162412.107ff8ac.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0911021159120.2028@V090114053VZO-1>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com> <20091102162412.107ff8ac.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, KAMEZAWA Hiroyuki wrote:

>  /*
> - * Types of limitations to the nodes from which allocations may occur
> + * Types of limitations to zones from which allocations may occur
>   */

"Types of limitations that may cause OOMs"? MEMCG limitations are not zone
based.

>   */
>
> -unsigned long badness(struct task_struct *p, unsigned long uptime)
> +static unsigned long __badness(struct task_struct *p,
> +		      unsigned long uptime, enum oom_constraint constraint,
> +		      struct mem_cgroup *mem)
>  {
>  	unsigned long points, cpu_time, run_time;
>  	struct mm_struct *mm;

Why rename this function? You are adding a global_badness anyways.


> +	/*
> +	 * In numa environ, almost all allocation will be against NORMAL zone.

The typical allocations will be against the policy_zone! SGI IA64 (and
others) have policy_zone == GFP_DMA.

> +	 * But some small area, ex)GFP_DMA for ia64 or GFP_DMA32 for x86-64
> +	 * can cause OOM. We can use policy_zone for checking lowmem.
> +	 */

Simply say that we are checking if the zone constraint is below the policy
zone?

> +	 * Now, only mempolicy specifies nodemask. But if nodemask
> +	 * covers all nodes, this oom is global oom.
> +	 */
> +	if (nodemask && !nodes_equal(node_states[N_HIGH_MEMORY], *nodemask))
> +		ret = CONSTRAINT_MEMORY_POLICY;

Huh? A cpuset can also restrict the nodes?

> +	/*
> + 	 * If not __GFP_THISNODE, zonelist containes all nodes. And if

Dont see any __GFP_THISNODE checks here.

>  		panic("out of memory from page fault. panic_on_oom is selected.\n");
>
>  	read_lock(&tasklist_lock);
> -	__out_of_memory(0, 0); /* unknown gfp_mask and order */
> +	/*
> +	 * Considering nature of pages required for page-fault,this must be
> +	 * global OOM (if not cpuset...). Then, CONSTRAINT_NONE is correct.
> +	 * zonelist, nodemasks are unknown...
> +	 */
> +	__out_of_memory(0, CONSTRAINT_NONE, 0, NULL);
>  	read_unlock(&tasklist_lock);

Page faults can occur on processes that have memory restrictions.

