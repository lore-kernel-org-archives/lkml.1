Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbZLOPZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbZLOPZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZLOPZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:25:23 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:41438 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZLOPZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:25:22 -0500
Date: Tue, 15 Dec 2009 09:25:01 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, Lee.Schermerhorn@hp.com
Subject: Re: [mmotm][PATCH 2/5] mm : avoid  false sharing on mm_counter
In-Reply-To: <20091215181337.1c4f638d.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0912150920160.16754@router.home>
References: <20091215180904.c307629f.kamezawa.hiroyu@jp.fujitsu.com> <20091215181337.1c4f638d.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009, KAMEZAWA Hiroyuki wrote:

>  #if USE_SPLIT_PTLOCKS
> +#define SPLIT_RSS_COUNTING
>  struct mm_rss_stat {
>  	atomic_long_t count[NR_MM_COUNTERS];
>  };
> +/* per-thread cached information, */
> +struct task_rss_stat {
> +	int events;	/* for synchronization threshold */

Why count events? Just always increment the task counters and fold them
at appropriate points into mm_struct. Or get rid of the mm_struct counters
and only sum them up on the fly if needed?

Add a pointer to thread rss_stat structure to mm_struct and remove the
counters? If the task has only one thread then the pointer points to the
accurate data (most frequent case). Otherwise it can be NULL and then we
calculate it on the fly?

> +static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
> +{
> +	struct task_struct *task = current;
> +
> +	if (likely(task->mm == mm))
> +		task->rss_stat.count[member] += val;
> +	else
> +		add_mm_counter(mm, member, val);
> +}
> +#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member,1)
> +#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member,-1)
> +

Code will be much simpler if you always increment the task counts.

