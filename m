Return-Path: <linux-kernel-owner+w=401wt.eu-S1751541AbZGaHq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbZGaHq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 03:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZGaHq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 03:46:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:40825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZGaHq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 03:46:58 -0400
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Bligh <mbligh@google.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Chad Talbott <ctalbott@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, wfg@mail.ustc.edu.cn,
       Michael Rubin <mrubin@google.com>, sandeen@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <33307c790907301548t2ef1bb72k4adbe81865d2bde9@mail.gmail.com>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
	 <20090730213956.GH12579@kernel.dk>
	 <33307c790907301501v4c605ea8oe57762b21d414445@mail.gmail.com>
	 <20090730221727.GI12579@kernel.dk>
	 <33307c790907301534v64c08f59o66fbdfbd3174ff5f@mail.gmail.com>
	 <20090730224308.GJ12579@kernel.dk>
	 <33307c790907301548t2ef1bb72k4adbe81865d2bde9@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 31 Jul 2009 09:50:04 +0200
Message-Id: <1249026604.6391.58.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 15:48 -0700, Martin Bligh wrote:

> There's another issue I was discussing with Peter Z. earlier that the
> bdi changes might help with - if you look at where the dirty pages
> get to, they are capped hard at the average of the dirty and
> background thresholds, meaning we can only dirty about half the
> pages we should be able to. That does very slowly go away when
> the bdi limit catches up, but it seems to start at 0, and it's progess
> seems glacially slow (at least if you're impatient ;-))
> 
> This seems to affect some of our workloads badly when they have
> a sharp spike in dirty data to one device, they get throttled heavily
> when they wouldn't have before the per-bdi dirty limits.

Right, currently that adjustment period is about the same order as
writing out the full dirty page capacity. If your system has unbalanced
memory vs io capacity this might indeed end up being glacial.

I've been considering making it a sublinear function wrt the memory
size, so that larger machines get less and therefore adjust faster.

Something like the below perhaps -- the alternative is yet another
sysctl :/

Not sure how the sqrt works out on a wide variety of machines though,..
we'll have to test and see.

---
 mm/page-writeback.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 81627eb..64aa140 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -152,7 +152,7 @@ static int calc_period_shift(void)
 	else
 		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
 				100;
-	return 2 + ilog2(dirty_total - 1);
+	return 2 + ilog2(int_sqrt(dirty_total) - 1);
 }
 
 /*

