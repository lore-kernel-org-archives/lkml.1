Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbZLNOVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbZLNOVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbZLNOVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:21:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359AbZLNOVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:21:11 -0500
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
From: Larry Woodman <lwoodman@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
In-Reply-To: <87pr6hya86.fsf@basil.nowhere.org>
References: <20091210185626.26f9828a@cuia.bos.redhat.com>
	 <87pr6hya86.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 09:23:19 -0500
Message-Id: <1260800599.6666.4.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 14:08 +0100, Andi Kleen wrote:
> Rik van Riel <riel@redhat.com> writes:
> 
> > +max_zone_concurrent_reclaim:
> > +
> > +The number of processes that are allowed to simultaneously reclaim
> > +memory from a particular memory zone.
> > +
> > +With certain workloads, hundreds of processes end up in the page
> > +reclaim code simultaneously.  This can cause large slowdowns due
> > +to lock contention, freeing of way too much memory and occasionally
> > +false OOM kills.
> > +
> > +To avoid these problems, only allow a smaller number of processes
> > +to reclaim pages from each memory zone simultaneously.
> > +
> > +The default value is 8.
> 
> I don't like the hardcoded number. Is the same number good for a 128MB
> embedded system as for as 1TB server?  Seems doubtful.
> 
> This should be perhaps scaled with memory size and number of CPUs?

Remember this a per-zone number.

> 
> > +/*
> > + * Maximum number of processes concurrently running the page
> > + * reclaim code in a memory zone.  Having too many processes
> > + * just results in them burning CPU time waiting for locks,
> > + * so we're better off limiting page reclaim to a sane number
> > + * of processes at a time.  We do this per zone so local node
> > + * reclaim on one NUMA node will not block other nodes from
> > + * making progress.
> > + */
> > +int max_zone_concurrent_reclaimers = 8;
> 
> __read_mostly
> 
> > +
> >  static LIST_HEAD(shrinker_list);
> >  static DECLARE_RWSEM(shrinker_rwsem);
> >  
> > @@ -1600,6 +1612,29 @@ static void shrink_zone(int priority, struct zone *zone,
> >  	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
> >  	int noswap = 0;
> >  
> > +	if (!current_is_kswapd() && atomic_read(&zone->concurrent_reclaimers) >
> > +					max_zone_concurrent_reclaimers) {
> > +		/*
> > +		 * Do not add to the lock contention if this zone has
> > +		 * enough processes doing page reclaim already, since
> > +		 * we would just make things slower.
> > +		 */
> > +		sleep_on(&zone->reclaim_wait);
> 
> wait_event()? sleep_on is a really deprecated racy interface.
> 
> This would still badly thunder the herd if not enough memory is freed
> , won't it? It would be better to only wake up a single process if memory got freed.
> 
> How about for each page freed do a wake up for one thread?
> 
> 
> -Andi

