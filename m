Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbYDAMqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbYDAMqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYDAMqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:46:01 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14410 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbYDAMqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:46:00 -0400
Date: Tue, 1 Apr 2008 14:45:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Andrew Morton <akpm@osdl.org>, Yang Shi <yang.shi@windriver.com>,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: regression breaks lowmem reserved RAM
Message-ID: <20080401124553.GM12346@kernel.dk>
References: <20080328194909.GA10617@duo.random> <20080401105331.GH12427@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401105331.GH12427@duo.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01 2008, Andrea Arcangeli wrote:
> Looking a bit closer into this regression the reason this can't be
> right is that dma_addr common default is BLK_BOUNCE_HIGH and most
> machines have less than 4G. So if you do:
> 
>     if (b_pfn <= (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
> 	dma = 1
> 
> that will translate to:
> 
>      if (BLK_BOUNCE_HIGH <= BLK_BOUNCE_HIGH)
>      	dma = 1
> 
> So for 99% of hardware this will trigger unnecessary GFP_DMA
> allocations and isa pooling operations.
> 
> Also note how the 32bit code still does b_pfn < blk_max_low_pfn.
> 
> I guess this is what you were looking after. I didn't verify but as
> far as I can tell, this will stop the regression with isa dma
> operations at boot for 99% of blkdev/memory combinations out there and
> I guess this fixes the setups with >4G of ram and 32bit pci cards as
> well (this also retains symmetry with the 32bit code).
> 
> Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>

Thanks Andrea, this looks much saner!

-- 
Jens Axboe

