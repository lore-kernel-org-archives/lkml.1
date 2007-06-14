Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbXFNJeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbXFNJeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXFNJeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:34:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55437 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbXFNJeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:34:08 -0400
Date: Thu, 14 Jun 2007 18:32:32 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: mm: Fix memory/cpu hotplug section mismatch and oops.
In-Reply-To: <20070614061316.GA22543@linux-sh.org>
References: <20070614061316.GA22543@linux-sh.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070614183015.9DD7.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks. I tested compile with cpu/memory hotplug off/on.
It was OK.

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>


> (This is a resend of the earlier patch, this issue still needs to be
> fixed.)
> 
> When building with memory hotplug enabled and cpu hotplug disabled, we
> end up with the following section mismatch:
> 
> WARNING: mm/built-in.o(.text+0x4e58): Section mismatch: reference to
> .init.text: (between 'free_area_init_node' and '__build_all_zonelists')
> 
> This happens as a result of:
> 
>         -> free_area_init_node()
>           -> free_area_init_core()
>             -> zone_pcp_init() <-- all __meminit up to this point
>               -> zone_batchsize() <-- marked as __cpuinit                     fo
> 
> This happens because CONFIG_HOTPLUG_CPU=n sets __cpuinit to __init, but
> CONFIG_MEMORY_HOTPLUG=y unsets __meminit.
> 
> Changing zone_batchsize() to __devinit fixes this.
> 
> __devinit is the only thing that is common between CONFIG_HOTPLUG_CPU=y and
> CONFIG_MEMORY_HOTPLUG=y. In the long run, perhaps this should be moved to
> another section identifier completely. Without this, memory hot-add
> of offline nodes (via hotadd_new_pgdat()) will oops if CPU hotplug is
> not also enabled.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> --
> 
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bd8e335..05ace44 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1968,7 +1968,7 @@ void zone_init_free_lists(struct pglist_data *pgdat, struct zone *zone,
>  	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
>  #endif
>  
> -static int __cpuinit zone_batchsize(struct zone *zone)
> +static int __devinit zone_batchsize(struct zone *zone)
>  {
>  	int batch;
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Yasunori Goto 


