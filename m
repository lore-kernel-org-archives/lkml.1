Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815AbZD3Ez1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbZD3Ez1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 00:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZD3EzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 00:55:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47580 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbZD3EzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 00:55:12 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Swappiness vs. mmap() and interactive response
Cc: kosaki.motohiro@jp.fujitsu.com, Elladan <elladan@eskimo.com>,
       Theodore Tso <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090429214332.a2b5b469.akpm@linux-foundation.org>
References: <20090430041439.GA6110@eskimo.com> <20090429214332.a2b5b469.akpm@linux-foundation.org>
Message-Id: <20090430135100.D21A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 30 Apr 2009 13:55:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 29 Apr 2009 21:14:39 -0700 Elladan <elladan@eskimo.com> wrote:
> 
> > > Elladan, have you checked to see whether the Mapped: number in
> > > /proc/meminfo is decreasing?
> > 
> > Yes, Mapped decreases while a large file copy is ongoing.  It increases again
> > if I use the GUI.
> 
> OK.  If that's still happening to an appreciable extent after you've
> increased /proc/sys/vm/swappiness then I'd wager that we have a
> bug/regression in that area.
> 
> Local variable `scan' in shrink_zone() is vulnerable to multiplicative
> overflows on large zones, but I doubt if you have enough memory to
> trigger that bug.
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Local variable `scan' can overflow on zones which are larger than
> 
> 	(2G * 4k) / 100 = 80GB.
> 
> Making it 64-bit on 64-bit will fix that up.

Agghh, thanks bugfix.

Note: His meminfo indicate his machine has 3.5GB ram. then this
patch don't fix his problem.



> 
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/vmscan.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN mm/vmscan.c~vmscan-avoid-multiplication-overflow-in-shrink_zone mm/vmscan.c
> --- a/mm/vmscan.c~vmscan-avoid-multiplication-overflow-in-shrink_zone
> +++ a/mm/vmscan.c
> @@ -1479,7 +1479,7 @@ static void shrink_zone(int priority, st
>  
>  	for_each_evictable_lru(l) {
>  		int file = is_file_lru(l);
> -		int scan;
> +		unsigned long scan;
>  
>  		scan = zone_nr_pages(zone, sc, l);
>  		if (priority) {
> _
> 
> 



