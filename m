Return-Path: <linux-kernel-owner+w=401wt.eu-S1765607AbXKOTXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765607AbXKOTXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758921AbXKOTXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:23:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60742 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbXKOTXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:23:14 -0500
Subject: Re: [RFC] fuse writable mmap design
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <E1IshIR-0000fE-00@dorka.pomaz.szeredi.hu>
References: <E1IshIR-0000fE-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 20:22:10 +0100
Message-Id: <1195154530.22457.16.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-15 at 17:10 +0100, Miklos Szeredi wrote:

> Fuse page writeback design
> --------------------------
> 
> fuse_writepage() allocates a new temporary page with
> GFP_NOFS|__GFP_HIGHMEM.  It copies the contents of the original page,
> and queues a WRITE request to the userspace filesystem using this temp
> page.
> 
> From the VM's point of view, the writeback is finished instantly: the
> page is removed from the radix trees, and the PageDirty and
> PageWriteback flags are cleared.
> 
> The per-bdi writeback count is not decremented until the writeback
> truly completes.  And there's a new 'nr_writeback_temp' counter, that
> is used to track the global count of these writebacks instead of the
> per-zone NR_WRITEBACK (it could be a new per-zone counter in vm_stat,
> but for simplicity, current code just uses a single atomic counter).
> 
> If the writeout was due to memory pressure, in effect this migrates
> data from a full zone to a less full zone.
> 
> On dirtying the page, fuse waits for a previous write to finish before
> proceeding.  This makes sure, there can only be one temporary page used
> at a time for one cached page.
> 
> This approach is wasteful in both memory and CPU bandwidth, so why is
> this complication needed?
> 
> The basic problem is that there can be no guarantee about the time in
> which the userspace filesystem will complete a write.  It may be buggy
> or even malicious, and fail to complete WRITE requests.  We don't want
> unrelated parts of the system to grind to a halt in such cases.
> 
> Also a filesystem may need additional resources (particularly memory)
> to complete a WRITE request.  There's a great danger of a deadlock if
> that allocation may wait for the writepage to finish.
> 
> Currently there are several cases where the kernel can block on page
> writeback:
> 
>   - allocation order is larger than PAGE_ALLOC_COSTLY_ORDER
>   - page migration
>   - throttle_vm_writeout (through NR_WRITEBACK)
>   - sync(2)
> 
> Of course in some cases (fsync, msync) we explicitly want to allow
> blocking.  So for these cases new code has to be added to fuse, since
> the VM is not tracking writeback pages for us any more.

I'm somewhat confused by the complexity. Currently we can already have a
lot of dirty pages from FUSE (up to the per BDI dirty limit - so
basically up to the total dirty limit).

How is having them dirty from mmap'ed writes different?



