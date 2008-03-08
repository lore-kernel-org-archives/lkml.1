Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYCHFeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYCHFeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 00:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYCHFeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 00:34:16 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33716 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbYCHFeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 00:34:15 -0500
Date: Sat, 08 Mar 2008 14:33:45 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Fix memory hotplug and bouncing in block layer
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
In-Reply-To: <20080306204124.GA17154@basil.nowhere.org>
References: <20080306204124.GA17154@basil.nowhere.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080308141539.0498.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oh, thanks for your fixing.

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>


> Fix memory hotplug and bouncing in block layer
> 
> Only noticed this while hacking something else, no test case.
> 
> blk_max_low_pfn is initialized once at bootup by the block layer
> from max_low_pfn. But max_low_pfn is not necessarily constant
> over the runtime of the system when you consider memory hotplug.
> What could happen if that someone adds memory later the block
> layer wouldn't get updated and then start bouncing memory unnecessarily.
> 
> Also on 64bit blk_max_low_pfn actually isn't needed because
> it just disables bouncing essentially and there is no highmem.
> And nobody can pass pfns > max_low_pfn to the block layer, 
> because those wouldn't have a struct page and I suspect
> block layer wouldn't be very happy without that.
> 
> So set BLK_BOUNCE_HIGH to infinity (-1ULL) on 64bit. That
> avoids the problem of having to update it on memory hotadd.
> 
> On 32bit I kept the same behaviour because at least on i386
> memory hotadd only adds HIGHMEM, never lowmem.
> 
> BLK_BOUNCE_ANY is always set to infinity on both 32 and 64bit.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  include/linux/blkdev.h |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux/include/linux/blkdev.h
> ===================================================================
> --- linux.orig/include/linux/blkdev.h
> +++ linux/include/linux/blkdev.h
> @@ -532,8 +532,13 @@ extern unsigned long blk_max_low_pfn, bl
>   * BLK_BOUNCE_ANY	: don't bounce anything
>   * BLK_BOUNCE_ISA	: bounce pages above ISA DMA boundary
>   */
> +
> +#if BITS_PER_LONG == 32
>  #define BLK_BOUNCE_HIGH		((u64)blk_max_low_pfn << PAGE_SHIFT)
> -#define BLK_BOUNCE_ANY		((u64)blk_max_pfn << PAGE_SHIFT)
> +#else
> +#define BLK_BOUNCE_HIGH		-1ULL
> +#endif
> +#define BLK_BOUNCE_ANY		(-1ULL)
>  #define BLK_BOUNCE_ISA		(ISA_DMA_THRESHOLD)

-- 
Yasunori Goto 


