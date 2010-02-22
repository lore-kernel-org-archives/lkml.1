Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0BVSVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:21:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52564 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0BVSVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:21:04 -0500
Subject: Re: [PATCH 2/2] memcg: dirty pages instrumentation
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>, Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1266765525-30890-3-git-send-email-arighi@develer.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
	 <1266765525-30890-3-git-send-email-arighi@develer.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 19:20:09 +0100
Message-ID: <1266862809.6122.436.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-21 at 16:18 +0100, Andrea Righi wrote:
> @@ -137,10 +137,11 @@ static struct prop_descriptor vm_dirties;
>   */
>  static int calc_period_shift(void)
>  {
> -       unsigned long dirty_total;
> +       unsigned long dirty_total, dirty_bytes;
>  
> -       if (vm_dirty_bytes)
> -               dirty_total = vm_dirty_bytes / PAGE_SIZE;
> +       dirty_bytes = mem_cgroup_dirty_bytes();
> +       if (dirty_bytes)
> +               dirty_total = dirty_bytes / PAGE_SIZE;
>         else
>                 dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
>                                 100;
> @@ -406,14 +407,20 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
>   */
>  unsigned long determine_dirtyable_memory(void)
>  {
> -       unsigned long x;
> -
> -       x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
> -
> +       unsigned long memcg_memory, memory;
> +
> +       memory = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
> +       memcg_memory = mem_cgroup_page_state(MEMCG_NR_FREE_PAGES);
> +       if (memcg_memory > 0) {
> +               memcg_memory +=
> +                       mem_cgroup_page_state(MEMCG_NR_RECLAIMABLE_PAGES);
> +               if (memcg_memory < memory)
> +                       return memcg_memory;
> +       }
>         if (!vm_highmem_is_dirtyable)
> -               x -= highmem_dirtyable_memory(x);
> +               memory -= highmem_dirtyable_memory(memory);
>  
> -       return x + 1;   /* Ensure that we never return 0 */
> +       return memory + 1;      /* Ensure that we never return 0 */
>  }
>  
>  void
> @@ -421,12 +428,13 @@ get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
>                  unsigned long *pbdi_dirty, struct backing_dev_info *bdi)
>  {
>         unsigned long background;
> -       unsigned long dirty;
> +       unsigned long dirty, dirty_bytes;
>         unsigned long available_memory = determine_dirtyable_memory();
>         struct task_struct *tsk;
>  
> -       if (vm_dirty_bytes)
> -               dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
> +       dirty_bytes = mem_cgroup_dirty_bytes();
> +       if (dirty_bytes)
> +               dirty = DIV_ROUND_UP(dirty_bytes, PAGE_SIZE);
>         else {
>                 int dirty_ratio;
>  
> @@ -505,9 +513,17 @@ static void balance_dirty_pages(struct address_space *mapping,
>                 get_dirty_limits(&background_thresh, &dirty_thresh,
>                                 &bdi_thresh, bdi);
>  
> -               nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
> +               nr_reclaimable = mem_cgroup_page_state(MEMCG_NR_FILE_DIRTY);
> +               if (nr_reclaimable == 0) {
> +                       nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
>                                         global_page_state(NR_UNSTABLE_NFS);
> -               nr_writeback = global_page_state(NR_WRITEBACK);
> +                       nr_writeback = global_page_state(NR_WRITEBACK);
> +               } else {
> +                       nr_reclaimable +=
> +                               mem_cgroup_page_state(MEMCG_NR_UNSTABLE_NFS);
> +                       nr_writeback =
> +                               mem_cgroup_page_state(MEMCG_NR_WRITEBACK);
> +               }
>  
>                 bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
>                 bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> @@ -660,6 +676,8 @@ void throttle_vm_writeout(gfp_t gfp_mask)
>         unsigned long dirty_thresh;
>  
>          for ( ; ; ) {
> +               unsigned long dirty;
> +
>                 get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
>  
>                  /*
> @@ -668,10 +686,15 @@ void throttle_vm_writeout(gfp_t gfp_mask)
>                   */
>                  dirty_thresh += dirty_thresh / 10;      /* wheeee... */
>  
> -                if (global_page_state(NR_UNSTABLE_NFS) +
> -                       global_page_state(NR_WRITEBACK) <= dirty_thresh)
> -                               break;
> -                congestion_wait(BLK_RW_ASYNC, HZ/10);
> +               dirty = mem_cgroup_page_state(MEMCG_NR_WRITEBACK);
> +               if (dirty < 0)
> +                       dirty = global_page_state(NR_UNSTABLE_NFS) +
> +                               global_page_state(NR_WRITEBACK);
> +               else
> +                       dirty += mem_cgroup_page_state(MEMCG_NR_UNSTABLE_NFS);
> +               if (dirty <= dirty_thresh)
> +                       break;
> +               congestion_wait(BLK_RW_ASYNC, HZ/10);
>  
>                 /*
>                  * The caller might hold locks which can prevent IO completion 


This stuff looks really rather horrible, 

Relying on these cgroup functions returning 0 seems fragile, some of
them can really be 0. Also sprinkling all that if cgroup foo all over
the place leads to these ugly indentation problems you have.

How about pulling all these things into separate functions, and using a
proper mem_cgroup_has_dirty() function to select on?

