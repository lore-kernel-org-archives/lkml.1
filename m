Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbZJHWSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbZJHWSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 18:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbZJHWSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 18:18:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756559AbZJHWSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 18:18:42 -0400
Date: Thu, 8 Oct 2009 15:17:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nis@tyo205.gate.nec.co.jp>
Subject: Re: [PATCH 1/2] memcg: coalescing uncharge at unmap and truncation
 (fixed coimpile bug)
Message-Id: <20091008151710.1216a615.akpm@linux-foundation.org>
In-Reply-To: <20091002160213.32ae2bb5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091002135531.3b5abf5c.kamezawa.hiroyu@jp.fujitsu.com>
	<20091002140126.61d15e5e.kamezawa.hiroyu@jp.fujitsu.com>
	<4AC5A1FA.1080208@ct.jp.nec.com>
	<20091002160213.32ae2bb5.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009 16:02:13 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

>
> ...
>
> In massive parallel enviroment, res_counter can be a performance bottleneck.
> One strong techinque to reduce lock contention is reducing calls by
> coalescing some amount of calls into one.
> 
> Considering charge/uncharge chatacteristic,
> 	- charge is done one by one via demand-paging.
> 	- uncharge is done by
> 		- in chunk at munmap, truncate, exit, execve...
> 		- one by one via vmscan/paging.
> 
> It seems we have a chance in uncharge at unmap/truncation.
> 
> This patch is a for coalescing uncharge. For avoiding scattering memcg's
> structure to functions under /mm, this patch adds memcg batch uncharge
> information to the task. 
> 
> The degree of coalescing depends on callers
>   - at invalidate/trucate... pagevec size
>   - at unmap ....ZAP_BLOCK_SIZE
> (memory itself will be freed in this degree.)
> Then, we'll not coalescing too much.
> 
>
> ...
>
> +static void
> +__do_uncharge(struct mem_cgroup *mem, const enum charge_type ctype)
> +{
> +	struct memcg_batch_info *batch = NULL;
> +	bool uncharge_memsw = true;
> +	/* If swapout, usage of swap doesn't decrease */
> +	if (!do_swap_account || ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
> +		uncharge_memsw = false;
> +	/*
> +	 * do_batch > 0 when unmapping pages or inode invalidate/truncate.
> +	 * In those cases, all pages freed continously can be expected to be in
> +	 * the same cgroup and we have chance to coalesce uncharges.
> +	 * And, we do uncharge one by one if this is killed by OOM.
> +	 */
> +	if (!current->memcg_batch.do_batch || test_thread_flag(TIF_MEMDIE))
> +		goto direct_uncharge;
> +
> +	batch = &current->memcg_batch;
> +	/*
> +	 * In usual, we do css_get() when we remember memcg pointer.
> +	 * But in this case, we keep res->usage until end of a series of
> +	 * uncharges. Then, it's ok to ignore memcg's refcnt.
> +	 */
> +	if (!batch->memcg)
> +		batch->memcg = mem;
> +	/*
> +	 * In typical case, batch->memcg == mem. This means we can
> +	 * merge a series of uncharges to an uncharge of res_counter.
> +	 * If not, we uncharge res_counter ony by one.
> +	 */
> +	if (batch->memcg != mem)
> +		goto direct_uncharge;
> +	/* remember freed charge and uncharge it later */
> +	batch->pages += PAGE_SIZE;

->pages is really confusingly named.  It doesn't count pages, it counts
bytes!

We could call it `bytes', but perhaps charge_bytes would be more
communicative?

> +/*
> + * batch_start/batch_end is called in unmap_page_range/invlidate/trucate.
> + * In that cases, pages are freed continuously and we can expect pages
> + * are in the same memcg. All these calls itself limits the number of
> + * pages freed at once, then uncharge_start/end() is called properly.
> + */
> +
> +void mem_cgroup_uncharge_start(void)
> +{
> +	if (!current->memcg_batch.do_batch) {
> +		current->memcg_batch.memcg = NULL;
> +		current->memcg_batch.pages = 0;
> +		current->memcg_batch.memsw = 0;

what's memsw?

> +	}
> +	current->memcg_batch.do_batch++;
> +}
> +
>
> ...
>
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
> +	struct memcg_batch_info {
> +		int do_batch;
> +		struct mem_cgroup *memcg;
> +		long pages, memsw;
> +	} memcg_batch;
> +#endif

I find the most valuable documetnation is that which is devoted to the
data structures.  This one didn't get any :(

Negative values of `pages' and `memsw' are meaningless, so it would be
better to give them an unsigned type.  That matches the
res_counter_charge() expectations also.


