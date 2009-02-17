Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZBQJeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZBQJeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbZBQJd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:33:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45721 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbZBQJd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:33:59 -0500
Subject: Re: [PATCH] Add tracepoints to track pagecache transition
From: Peter Zijlstra <peterz@infradead.org>
To: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Kazuto Miyoshi <miyoshi@linux.bs1.fc.nec.co.jp>, rostedt@goodmis.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <499A7CAD.9030409@bk.jp.nec.com>
References: <499A7CAD.9030409@bk.jp.nec.com>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 10:33:40 +0100
Message-Id: <1234863220.4744.34.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 18:00 +0900, Atsushi Tsuji wrote:

> The below patch adds instrumentation for pagecache.

And somehow you forgot to CC any of the mm people.. ;-)

> I thought it would be useful to trace pagecache behavior for problem
> analysis (performance bottlenecks, behavior differences between stable
> time and trouble time).
> 
> By using those tracepoints, we can describe and visualize pagecache
> transition (file-by-file basis) in kernel and  pagecache
> consumes most of the memory in running system and pagecache hit rate
> and writeback behavior will influence system load and performance.

> Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
> ---
> diff --git a/include/trace/filemap.h b/include/trace/filemap.h
> new file mode 100644
> index 0000000..196955e
> --- /dev/null
> +++ b/include/trace/filemap.h
> @@ -0,0 +1,13 @@
> +#ifndef _TRACE_FILEMAP_H
> +#define _TRACE_FILEMAP_H
> +
> +#include <linux/tracepoint.h>
> +
> +DECLARE_TRACE(filemap_add_to_page_cache,
> +	TPPROTO(struct address_space *mapping, pgoff_t offset),
> +	TPARGS(mapping, offset));
> +DECLARE_TRACE(filemap_remove_from_page_cache,
> +	TPPROTO(struct address_space *mapping),
> +	TPARGS(mapping));

This is rather asymmetric, why don't we care about the offset for the
removed page?

> +#endif
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 23acefe..76a6887 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -34,6 +34,7 @@
>  #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
>  #include <linux/memcontrol.h>
>  #include <linux/mm_inline.h> /* for page_is_file_cache() */
> +#include <trace/filemap.h>
>  #include "internal.h"
>  
>  /*
> @@ -43,6 +44,8 @@
>  
>  #include <asm/mman.h>
>  
> +DEFINE_TRACE(filemap_add_to_page_cache);
> +DEFINE_TRACE(filemap_remove_from_page_cache);
>  
>  /*
>   * Shared mappings implemented 30.11.1994. It's not fully working yet,
> @@ -120,6 +123,7 @@ void __remove_from_page_cache(struct page *page)
>  	page->mapping = NULL;
>  	mapping->nrpages--;
>  	__dec_zone_page_state(page, NR_FILE_PAGES);
> +	trace_filemap_remove_from_page_cache(mapping);
>  	BUG_ON(page_mapped(page));
>  	mem_cgroup_uncharge_cache_page(page);
>  
> @@ -475,6 +479,7 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
>  		if (likely(!error)) {
>  			mapping->nrpages++;
>  			__inc_zone_page_state(page, NR_FILE_PAGES);
> +			trace_filemap_add_to_page_cache(mapping, offset);
>  		} else {
>  			page->mapping = NULL;
>  			mem_cgroup_uncharge_cache_page(page);
> 
> 

