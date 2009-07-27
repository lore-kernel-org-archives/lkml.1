Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZG0W6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZG0W6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZG0W6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:58:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbZG0W6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:58:48 -0400
Date: Mon, 27 Jul 2009 15:57:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: jens.axboe@oracle.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] mm: reorder balance_dirty_pages to improve (some)
 write performance
Message-Id: <20090727155739.0e96b9e3.akpm@linux-foundation.org>
In-Reply-To: <1248445717.19856.63.camel@localhost.localdomain>
References: <1248445717.19856.63.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 15:28:37 +0100
Richard Kennedy <richard@rsk.demon.co.uk> wrote:

> Reorder balance_dirty_pages to do less work in the default case &
> improve write performance in some cases.
> 
> Running simple fio mmap write tests on x86_64 with 3gb of memory on
> 2.6.31-rc3 where each test was run 10 times, dropping the slowest &
> fastest results the average write speeds are
> 
> size rc3 | +patch  difference
>      MiB/s (s.d.)
> 
> 400m 374.75  ( 8.15) | 382.575 ( 8.24)  + 7.825
> 500m 363.625 (10.91) | 378.375 (10.86)  +14.75
> 600m 308.875 (10.86) | 374.25  ( 7.91)  +65.375
> 700m 188     ( 4.75) | 209     ( 7.23)  +21
> 800m 140.375 ( 2.56) | 154.5   ( 2.98)  +14.275
> 900m 124.875 ( 0.99) | 125.5   ( 9.62)  +0.625
> 
> 
> This patch helps write performance when the test size is close to the
> allowed number of dirty pages (approx 600m on this machine). Once the
> test size becomes larger than 900m there is no significant difference.
> 
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> ----
> 
> This change only make a difference to workloads where the number of
> dirty pages is close to (dirty_ratio * memory size). Once a test writes
> more than that the speed of the disk is the most important factor so any
> effect of this patch is lost.
> I've only tried this on my desktop, so it really needs testing on
> different hardware.
> Does anyone feel like trying it ? 

So what does the patch actually do?

AFACIT the main change is to move this:

			if (bdi->dirty_exceeded)
				bdi->dirty_exceeded = 0;

from after the loop and into the body of the loop.

So that we no longer clear dirty_exceeded in the three other places
where we break out of the loop.

IOW, dirty_exceeded can be left true (even if it shouldn't be?) on exit
from balance_dirty_pages().

What was the rationale for leaving dirty_exceeded true in those cases,
and why did it speed up that workload?

Thanks.
