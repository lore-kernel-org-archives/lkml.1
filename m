Return-Path: <linux-kernel-owner+w=401wt.eu-S932158AbXAVT7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbXAVT7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbXAVT7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:59:53 -0500
Received: from [212.12.190.79] ([212.12.190.79]:33026 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932416AbXAVT7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:59:52 -0500
From: Al Boldi <a1426z@gawab.com>
To: "yunfeng zhang" <zyf.zeroos@gmail.com>
Subject: Re: [PATCH 2.6.20-rc5 1/1] MM: enhance Linux swap subsystem
Date: Mon, 22 Jan 2007 23:00:41 +0300
User-Agent: KMail/1.5
Cc: "Rik van Riel" <riel@redhat.com>, "Pavel Machek" <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
References: <4df04b840701212309l2a283357jbdaa88794e5208a7@mail.gmail.com>
In-Reply-To: <4df04b840701212309l2a283357jbdaa88794e5208a7@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <200701222300.41960.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

yunfeng zhang wrote:
> My patch is based on my new idea to Linux swap subsystem, you can find
> more in Documentation/vm_pps.txt which isn't only patch illustration but
> also file changelog. In brief, SwapDaemon should scan and reclaim pages on
> UserSpace::vmalist other than current zone::active/inactive. The change
> will conspicuously enhance swap subsystem performance by
>
> 1) SwapDaemon can collect the statistic of process acessing pages and by
> it unmaps ptes, SMP specially benefits from it for we can use
> flush_tlb_range to unmap ptes batchly rather than frequently TLB IPI
> interrupt per a page in current Linux legacy swap subsystem.
> 2) Page-fault can issue better readahead requests since history data shows
> all related pages have conglomerating affinity. In contrast, Linux
> page-fault readaheads the pages relative to the SwapSpace position of
> current page-fault page.
> 3) It's conformable to POSIX madvise API family.
> 4) It simplifies Linux memory model dramatically. Keep it in mind that new
> swap strategy is from up to down. In fact, Linux legacy swap subsystem is
> maybe the only one from down to up.
>
> Other problems asked about my pps are
> 1) There isn't new lock order in my pps, it's compliant to Linux lock
> order defined in mm/rmap.c.
> 2) When a memory inode is low, you can set scan_control::reclaim_node to
> let my kppsd to reclaim the memory inode page.

Patched against 2.6.19 leads to:

mm/vmscan.c: In function `shrink_pvma_scan_ptes':
mm/vmscan.c:1340: too many arguments to function `page_remove_rmap'

So changed
 page_remove_rmap(series.pages[i], vma);
to
 page_remove_rmap(series.pages[i]);

But your patch doesn't offer any swap-performance improvement for both swsusp 
or tmpfs.  Swap-in is still half speed of Swap-out.


Thanks!

--
Al

