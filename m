Return-Path: <linux-kernel-owner+w=401wt.eu-S1762485AbZEACyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762485AbZEACyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbZEACyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:54:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755257AbZEACyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:54:09 -0400
Date: Thu, 30 Apr 2009 19:49:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 20/22] vmscan: avoid multiplication overflow in
 shrink_zone()
Message-Id: <20090430194907.82b31565.akpm@linux-foundation.org>
In-Reply-To: <20090501012212.GA5848@localhost>
References: <200904302208.n3UM8t9R016687@imap1.linux-foundation.org>
	<20090501012212.GA5848@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009 09:22:12 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Fri, May 01, 2009 at 06:08:55AM +0800, Andrew Morton wrote:
> > 
> > Local variable `scan' can overflow on zones which are larger than
> > 
> > 	(2G * 4k) / 100 = 80GB.
> > 
> > Making it 64-bit on 64-bit will fix that up.
> 
> A side note about the "one HUGE scan inside shrink_zone":
> 
> Isn't this low level scan granularity way tooooo large?
> 
> It makes things a lot worse on memory pressure:
> - the over reclaim, somehow workarounded by Rik's early bail out patch
> - the throttle_vm_writeout()/congestion_wait() guards could work in a
>   very sparse manner and hence is useless: imagine to stop and wait
>   after shooting away every 1GB memory.
> 
> The long term fix could be to move the granularity control up to the
> shrink_zones() level: there it can bail out early without hurting the
> balanced zone aging.
> 

I guess it could be bad in some circumstances.  Normally we'll bail out
way early because (nr_reclaimed > swap_cluster_max) comes true.  If it
_doesn't_ come true, we have little choice but to keep scanning.


The code is mystifying:

: 	for_each_evictable_lru(l) {
: 		int file = is_file_lru(l);
: 		unsigned long scan;
: 
: 		scan = zone_nr_pages(zone, sc, l);
: 		if (priority) {
: 			scan >>= priority;
: 			scan = (scan * percent[file]) / 100;
: 		}
: 		if (scanning_global_lru(sc)) {
: 			zone->lru[l].nr_scan += scan;

Here we increase zone->lru[l].nr_scan by (say) 1000000.

: 			nr[l] = zone->lru[l].nr_scan;

locally save away the number of pages to scan

: 			if (nr[l] >= swap_cluster_max)
: 				zone->lru[l].nr_scan = 0;

err, wot?  This makes no sense at all afacit.

: 			else
: 				nr[l] = 0;

ok, this is doing some batching I think.

: 		} else
: 			nr[l] = scan;

so we didn't update the zone's nr_scan at all here.  But we display
nr_scan in /proc/zoneinfo as "scanned".  So we're filing to inform
userspace about scanning on this zone which is due to memcgroup
constraints.  I think.

: 	}
: 
: 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
: 					nr[LRU_INACTIVE_FILE]) {
: 		for_each_evictable_lru(l) {
: 			if (nr[l]) {
: 				nr_to_scan = min(nr[l], swap_cluster_max);
: 				nr[l] -= nr_to_scan;
: 
: 				nr_reclaimed += shrink_list(l, nr_to_scan,
: 							    zone, sc, priority);
: 			}
: 		}
: 		/*
: 		 * On large memory systems, scan >> priority can become
: 		 * really large. This is fine for the starting priority;
: 		 * we want to put equal scanning pressure on each zone.
: 		 * However, if the VM has a harder time of freeing pages,
: 		 * with multiple processes reclaiming pages, the total
: 		 * freeing target can get unreasonably large.
: 		 */
: 		if (nr_reclaimed > swap_cluster_max &&
: 			priority < DEF_PRIORITY && !current_is_kswapd())
: 			break;

here we bale out after scanning 32 pages, without updating ->nr_scan.

: 	}


What on earth does zone->lru[l].nr_scan mean after wending through all
this stuff?

afacit this will muck up /proc/zoneinfo, but nothing else.

