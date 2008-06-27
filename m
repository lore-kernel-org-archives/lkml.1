Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbYF0QJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbYF0QJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbYF0QJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:09:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15815 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbYF0QJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:09:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=BkJpKpSOHVG9k72h8GsY+DDy3mWB9k4aSxaEQbjxdBaDrYHcgmohl7Gt1yw89N8Fd
	9Fk7UTf08kosUtrD4nqUw==
Message-ID: <6599ad830806270909w6a2c26d8mcf406856c06c5da@mail.gmail.com>
Date: Fri, 27 Jun 2008 09:09:10 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC 5/5] Memory controller soft limit reclaim on contention
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080627151906.31664.7247.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080627151808.31664.36047.sendpatchset@balbir-laptop>
	 <20080627151906.31664.7247.sendpatchset@balbir-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 8:19 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> +/*
> + * Create a heap of memory controller structures. The heap is reverse
> + * sorted by size. This heap is used for implementing soft limits. Our
> + * current heap implementation does not allow dynamic heap updates, but
> + * eventually, the costliest controller (over it's soft limit should

it's -> its

> +                       old_mem = heap_insert(&mem_cgroup_heap, mem,
> +                                               HEAP_REP_LEAF);
> +                       mem->on_heap = 1;
> +                       if (old_mem)
> +                               old_mem->on_heap = 0;

Maybe a comment here that mem might == old_mem?

> + * When the soft limit is exceeded, look through the heap and start
> + * reclaiming from all groups over thier soft limit

thier -> their

> +               if (!res_counter_check_under_soft_limit(&mem->res)) {
> +                       /*
> +                        * The current task might already be over it's soft
> +                        * limit and trying to aggressively grow. We check to
> +                        * see if it the memory group associated with the
> +                        * current task is on the heap when the current group
> +                        * is over it's soft limit. If not, we add it
> +                        */
> +                       if (!mem->on_heap) {
> +                               struct mem_cgroup *old_mem;
> +
> +                               old_mem = heap_insert(&mem_cgroup_heap, mem,
> +                                                       HEAP_REP_LEAF);
> +                               mem->on_heap = 1;
> +                               if (old_mem)
> +                                       old_mem->on_heap = 0;
> +                       }
> +               }

This and the other similar code for adding to the heap should be
refactored into a separate function.

>
> +static int mem_cgroup_compare_soft_limits(void *p1, void *p2)
> +{
> +       struct mem_cgroup *mem1 = (struct mem_cgroup *)p1;
> +       struct mem_cgroup *mem2 = (struct mem_cgroup *)p2;
> +       unsigned long long delta1, delta2;
> +
> +       delta1 = res_counter_soft_limit_delta(&mem1->res);
> +       delta2 = res_counter_soft_limit_delta(&mem2->res);
> +
> +       return delta1 > delta2;
> +}

This isn't a valid comparator, since it isn't a constant function of
its two input pointers - calling mem_cgroup_compare_soft_limits(m1,
m2) can give different results at different times. So your heap
invariant will become invalid over time.

I think if you want to do this, you're going to need to periodically
take a snapshot of each cgroup's excess and use that snapshot in the
comparator; whenever you update the snapshots, you'll need to restore
the heap invariant.

Paul
