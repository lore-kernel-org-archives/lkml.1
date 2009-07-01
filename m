Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbZGACLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbZGACLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 22:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZGACLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 22:11:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZGACLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 22:11:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=vO0CncZwpbf3lp6sYjsTUgllu8bgu1zC3IaOrhtDqCQHYB0B3kVcRA8PPHpT84mnb
	nPHt0E5S/9Tdl3M9/LpdA==
Date: Tue, 30 Jun 2009 19:11:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>,
       linux-mm@kvack.org, "elladan@eskimo.com" <elladan@eskimo.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH v2] Show kernel stack usage to /proc/meminfo and OOM
 log
In-Reply-To: <20090701103622.85CD.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0906301858270.7103@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0906301011210.6124@gentwo.org> <20090701082531.85C2.A69D9226@jp.fujitsu.com> <20090701103622.85CD.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, KOSAKI Motohiro wrote:

> Subject: [PATCH] Show kernel stack usage to /proc/meminfo and OOM log
> 
> if the system have a lot of thread, kernel stack consume unignorable large size
> memory.
> IOW, it make a lot of unaccountable memory.
> 
> Tons unaccountable memory bring to harder analyse memory related trouble.
> 
> Then, kernel stack account is useful.
> 
> 

I know this is the second revision of the patch, apologies for not 
responding to the first.

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  fs/proc/meminfo.c      |    2 ++
>  include/linux/mmzone.h |    3 ++-
>  kernel/fork.c          |   12 ++++++++++++
>  mm/page_alloc.c        |    6 ++++--
>  mm/vmstat.c            |    1 +
>  5 files changed, 21 insertions(+), 3 deletions(-)
> 
> Index: b/fs/proc/meminfo.c
> ===================================================================
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -85,6 +85,7 @@ static int meminfo_proc_show(struct seq_
>  		"SReclaimable:   %8lu kB\n"
>  		"SUnreclaim:     %8lu kB\n"
>  		"PageTables:     %8lu kB\n"
> +		"KernelStack     %8lu kB\n"

Missing :.

>  #ifdef CONFIG_QUICKLIST
>  		"Quicklists:     %8lu kB\n"
>  #endif
> @@ -129,6 +130,7 @@ static int meminfo_proc_show(struct seq_
>  		K(global_page_state(NR_SLAB_RECLAIMABLE)),
>  		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
>  		K(global_page_state(NR_PAGETABLE)),
> +		K(global_page_state(NR_KERNEL_STACK)),
>  #ifdef CONFIG_QUICKLIST
>  		K(quicklist_total_size()),
>  #endif
> Index: b/include/linux/mmzone.h
> ===================================================================
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -94,10 +94,11 @@ enum zone_stat_item {
>  	NR_SLAB_RECLAIMABLE,
>  	NR_SLAB_UNRECLAIMABLE,
>  	NR_PAGETABLE,		/* used for pagetables */
> +	NR_KERNEL_STACK,
> +	/* Second 128 byte cacheline */
>  	NR_UNSTABLE_NFS,	/* NFS unstable pages */
>  	NR_BOUNCE,
>  	NR_VMSCAN_WRITE,
> -	/* Second 128 byte cacheline */
>  	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
>  #ifdef CONFIG_NUMA
>  	NUMA_HIT,		/* allocated in intended node */
> Index: b/kernel/fork.c
> ===================================================================
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -137,9 +137,18 @@ struct kmem_cache *vm_area_cachep;
>  /* SLAB cache for mm_struct structures (tsk->mm) */
>  static struct kmem_cache *mm_cachep;
>  
> +static void account_kernel_stack(struct thread_info *ti, int on)
> +{
> +	struct zone *zone = page_zone(virt_to_page(ti));
> +	int pages = THREAD_SIZE / PAGE_SIZE;
> +
> +	mod_zone_page_state(zone, NR_KERNEL_STACK, on ? pages : -pages);
> +}
> +
>  void free_task(struct task_struct *tsk)
>  {
>  	prop_local_destroy_single(&tsk->dirties);
> +	account_kernel_stack(tsk->stack, 0);

I think it would be better to do

	#define THREAD_PAGES	(THREAD_SIZE / PAGE_SIZE)

since it's currently unused and then

	struct zone *zone = page_zone(virt_to_page(tsk->stack));
	mod_zone_page_state(zone, NR_KERNEL_STACK, THREAD_PAGES);

in free_task() and

	struct zone *zone = page_zone(virt_to_page(ti));
	mod_zone_page_state(zone, NR_KERNEL_STACK, -THREAD_PAGES);

in dup_task_struct().

>  	free_thread_info(tsk->stack);
>  	rt_mutex_debug_task_free(tsk);
>  	ftrace_graph_exit_task(tsk);
> @@ -255,6 +264,9 @@ static struct task_struct *dup_task_stru
>  	tsk->btrace_seq = 0;
>  #endif
>  	tsk->splice_pipe = NULL;
> +
> +	account_kernel_stack(ti, 1);
> +
>  	return tsk;
>  
>  out:
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2119,7 +2119,8 @@ void show_free_areas(void)
>  		" inactive_file:%lu"
>  		" unevictable:%lu"
>  		" dirty:%lu writeback:%lu unstable:%lu\n"
> -		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
> +		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n"
> +		" kernel_stack:%lu\n",

Does kernel_stack really need to be printed on its own line?
