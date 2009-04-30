Return-Path: <linux-kernel-owner+w=401wt.eu-S1751584AbZD3ErJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbZD3ErJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 00:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbZD3Eqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 00:46:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbZD3Eqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 00:46:54 -0400
Date: Wed, 29 Apr 2009 21:43:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Elladan <elladan@eskimo.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Theodore Tso <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
Subject: Re: Swappiness vs. mmap() and interactive response
Message-Id: <20090429214332.a2b5b469.akpm@linux-foundation.org>
In-Reply-To: <20090430041439.GA6110@eskimo.com>
References: <20090428090916.GC17038@localhost>
	<20090428120818.GH22104@mit.edu>
	<20090429130430.4B11.A69D9226@jp.fujitsu.com>
	<20090428233455.614dcf3a.akpm@linux-foundation.org>
	<20090430041439.GA6110@eskimo.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 21:14:39 -0700 Elladan <elladan@eskimo.com> wrote:

> > Elladan, have you checked to see whether the Mapped: number in
> > /proc/meminfo is decreasing?
> 
> Yes, Mapped decreases while a large file copy is ongoing.  It increases again
> if I use the GUI.

OK.  If that's still happening to an appreciable extent after you've
increased /proc/sys/vm/swappiness then I'd wager that we have a
bug/regression in that area.

Local variable `scan' in shrink_zone() is vulnerable to multiplicative
overflows on large zones, but I doubt if you have enough memory to
trigger that bug.


From: Andrew Morton <akpm@linux-foundation.org>

Local variable `scan' can overflow on zones which are larger than

	(2G * 4k) / 100 = 80GB.

Making it 64-bit on 64-bit will fix that up.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-avoid-multiplication-overflow-in-shrink_zone mm/vmscan.c
--- a/mm/vmscan.c~vmscan-avoid-multiplication-overflow-in-shrink_zone
+++ a/mm/vmscan.c
@@ -1479,7 +1479,7 @@ static void shrink_zone(int priority, st
 
 	for_each_evictable_lru(l) {
 		int file = is_file_lru(l);
-		int scan;
+		unsigned long scan;
 
 		scan = zone_nr_pages(zone, sc, l);
 		if (priority) {
_


