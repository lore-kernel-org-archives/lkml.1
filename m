Return-Path: <linux-kernel-owner+w=401wt.eu-S1767418AbXDEXYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767418AbXDEXYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 19:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767417AbXDEXYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 19:24:52 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56999 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767273AbXDEXYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 19:24:51 -0400
Date: Thu, 5 Apr 2007 16:24:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: root@programming.kicks-ass.net
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       a.p.zijlstra@chello.nl, nikita@clusterfs.com
Subject: Re: [PATCH 12/12] mm: per BDI congestion feedback
Message-Id: <20070405162425.eb78c701.akpm@linux-foundation.org>
In-Reply-To: <20070405174320.649550491@programming.kicks-ass.net>
References: <20070405174209.498059336@programming.kicks-ass.net>
	<20070405174320.649550491@programming.kicks-ass.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 19:42:21 +0200
root@programming.kicks-ass.net wrote:

> Now that we have per BDI dirty throttling is makes sense to also have oer BDI
> congestion feedback; why wait on another device if the current one is not
> congested.

Similar comments apply.  congestion_wait() should be called
throttle_at_a_rate_proportional_to_the_speed_of_presently_uncongested_queues().

If a process is throttled in the page allocator waiting for pages to become
reclaimable, that process absolutely does not care whether those pages were
previously dirty against /dev/sda or against /dev/sdb.  It wants to be woken
up for writeout completion against any queue.


-		wbc.encountered_congestion = 0;
+		wbc.encountered_congestion = NULL;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
 		writeback_inodes(&wbc);
 		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
	 			/* Wrote less than expected */
-			congestion_wait(WRITE, HZ/10);
-			if (!wbc.encountered_congestion)
+			if (wbc.encountered_congestion)
+				congestion_wait(wbc.encountered_congestion,
+						WRITE, HZ/10);
+			else

Well that confused me.  You'd be needing to rename
wbc.encountered_congestion to congested_bdi or something.

