Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbZLOXb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbZLOXb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbZLOXb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:31:26 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:61018 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZLOXbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:31:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=VkDApswDx/hJFPd35ziL+OWnmITUc6KUbg15HB46BnEq8nLDOalT75PLpqfiWCH+IU
         dc+y02xKiYC38YUHRKVjbsvOnPC/pg+WWEBRQnQrgUQ5pRRHcYliVsAVsGBDkL+ZWxzn
         bqdOe3g3usz1roQjcqj4cjIGwwLckVnQom2is=
Date: Wed, 16 Dec 2009 08:25:29 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       cl@linux-foundation.org, minchan.kim@gmail.com, Lee.Schermerhorn@hp.com
Subject: Re: [mmotm][PATCH 1/5] clean up mm_counter
Message-Id: <20091216082529.8fc0d3c4.minchan.kim@barrios-desktop>
In-Reply-To: <20091215181116.ee2c31f7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091215180904.c307629f.kamezawa.hiroyu@jp.fujitsu.com>
	<20091215181116.ee2c31f7.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 18:11:16 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, per-mm statistics counter is defined by macro in sched.h
> 
> This patch modifies it to
>   - defined in mm.h as inlinf functions
>   - use array instead of macro's name creation.
> 
> This patch is for reducing patch size in future patch to modify
> implementation of per-mm counter.
> 
> Changelog: 2009/12/14
>  - added a struct rss_stat instead of bare counters.
>  - use memset instead of for() loop.
>  - rewrite macros into static inline functions.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  fs/proc/task_mmu.c       |    4 -
>  include/linux/mm.h       |  104 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mm_types.h |   33 +++++++++-----
>  include/linux/sched.h    |   54 ------------------------
>  kernel/fork.c            |    3 -
>  kernel/tsacct.c          |    1 
>  mm/filemap_xip.c         |    2 
>  mm/fremap.c              |    2 
>  mm/memory.c              |   56 +++++++++++++++----------
>  mm/oom_kill.c            |    4 -
>  mm/rmap.c                |   10 ++--
>  mm/swapfile.c            |    2 
>  12 files changed, 174 insertions(+), 101 deletions(-)
> 
> Index: mmotm-2.6.32-Dec8-pth/include/linux/mm.h
> ===================================================================
> --- mmotm-2.6.32-Dec8-pth.orig/include/linux/mm.h
> +++ mmotm-2.6.32-Dec8-pth/include/linux/mm.h
> @@ -868,6 +868,110 @@ extern int mprotect_fixup(struct vm_area
>   */
>  int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  			  struct page **pages);
> +/*
> + * per-process(per-mm_struct) statistics.
> + */
> +#if USE_SPLIT_PTLOCKS
> +/*
> + * The mm counters are not protected by its page_table_lock,
> + * so must be incremented atomically.
> + */
> +static inline void set_mm_counter(struct mm_struct *mm, int member, long value)
> +{
> +	atomic_long_set(&mm->rss_stat.count[member], value);
> +}

I can't find mm->rss_stat in this patch.
Maybe it's part of next patch. 
It could break bisect.

Otherwise, Looks good to me. 

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
