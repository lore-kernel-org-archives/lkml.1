Return-Path: <linux-kernel-owner+w=401wt.eu-S1762044AbZEAWhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044AbZEAWhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZEAWhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:37:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586AbZEAWhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:37:45 -0400
Date: Fri, 1 May 2009 15:32:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: kosaki.motohiro@jp.fujitsu.com, peterz@infradead.org, elladan@eskimo.com,
       linux-kernel@vger.kernel.org, tytso@mit.edu, linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first (v3)
Message-Id: <20090501153255.0f412420.akpm@linux-foundation.org>
In-Reply-To: <20090429131436.640f09ab@cuia.bos.redhat.com>
References: <20090428044426.GA5035@eskimo.com>
	<20090428192907.556f3a34@bree.surriel.com>
	<1240987349.4512.18.camel@laptop>
	<20090429114708.66114c03@cuia.bos.redhat.com>
	<2f11576a0904290907g48e94e74ye97aae593f6ac519@mail.gmail.com>
	<20090429131436.640f09ab@cuia.bos.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 13:14:36 -0400
Rik van Riel <riel@redhat.com> wrote:

> When the file LRU lists are dominated by streaming IO pages,
> evict those pages first, before considering evicting other
> pages.
> 
> This should be safe from deadlocks or performance problems
> because only three things can happen to an inactive file page:
> 1) referenced twice and promoted to the active list
> 2) evicted by the pageout code
> 3) under IO, after which it will get evicted or promoted
> 
> The pages freed in this way can either be reused for streaming
> IO, or allocated for something else. If the pages are used for
> streaming IO, this pageout pattern continues. Otherwise, we will
> fall back to the normal pageout pattern.
> 
> ..
>
> +int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg)
> +{
> +	unsigned long active;
> +	unsigned long inactive;
> +
> +	inactive = mem_cgroup_get_local_zonestat(memcg, LRU_INACTIVE_FILE);
> +	active = mem_cgroup_get_local_zonestat(memcg, LRU_ACTIVE_FILE);
> +
> +	return (active > inactive);
> +}

This function could trivially be made significantly more efficient by
changing it to do a single pass over all the zones of all the nodes,
rather than two passes.

>  static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
>  	struct zone *zone, struct scan_control *sc, int priority)
>  {
>  	int file = is_file_lru(lru);
>  
> -	if (lru == LRU_ACTIVE_FILE) {
> +	if (lru == LRU_ACTIVE_FILE && inactive_file_is_low(zone, sc)) {
>  		shrink_active_list(nr_to_scan, zone, sc, priority, file);
>  		return 0;
>  	}

And it does get called rather often.
