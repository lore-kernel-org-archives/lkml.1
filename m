Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYJ1FTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYJ1FTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYJ1FT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:19:28 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:22524 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751771AbYJ1FT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:19:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2baVEiwUQVTGFXlkn0GG89XV22RlURf1kHaFZB1wJo5X+7ONjw0XqkFvnH87M8v2BeMWPU/IgRs9ENpbseTWWIoV3Swst2aEPcF/lvyKRFYs13lDTAx952rbO6t0cO2c38E8SsUiPcanYYG96vjfMEol8r4OEMEKjv79P9dsxWM=  ;
X-YMail-OSG: rXEPJjAVM1kSFmvWM6jYx8SRpMieFFXpvabioHrrzywwHkmFKSPXE6vnO4SnFkA_91uWfIjldlW_9o1gF0UIkPboKuURKfAFSwhEntcl2gp8DtSaz.Mh1okiQbZlMeToG.XROKFp1.fjuOLxe.uukuVjAugRkDPgD5rVaAmCCZS2sg8_3jRkBFXlv8Vh
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: vm_unmap_aliases and Xen
Date: Tue, 28 Oct 2008 16:19:10 +1100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
References: <49010D41.1080305@goop.org>
In-Reply-To: <49010D41.1080305@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810281619.10388.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2008 10:48, Jeremy Fitzhardinge wrote:
> I've been having a few problems with Xen, I suspect as a result of the
> lazy unmapping in vmalloc.c.
>
> One immediate one is that vm_unmap_aliases() will oops if you call it
> before vmalloc_init() is called, which can happen in the Xen case.  RFC
> patch below.

Sure, we could do that. If you add an unlikely, and a __read_mostly,
I'd ack it. Thanks for picking this up.


> But the bigger problem I'm seeing is that despite calling
> vm_unmap_aliases() at the pertinent places, I'm still seeing errors
> resulting from stray aliases.  Is it possible that vm_unmap_aliases()
> could be missing some, or not completely synchronous?

It's possible, but of course that would not be by design ;)

I've had another look over it, and nothing obvious comes to
mind.

Actually, there may be a slight problem with the per-cpu KVA
flushing (it doesn't clear the dirty map after flushing, so
it would be possible to see the warning in vunmap_pte_range
trigger, I'll have to fix that). But I can't see your problem
yet.

It would be nice to narrow it down... Could you replace
lazy_max_pages call with 0, then change the 3rd and 4th
parameters of __purge_vmap_area_lazy in purge_vmap_area_lazy
with 1 and 1 rather than 0 and 0?


> Subject: vmap: cope with vm_unmap_aliases before vmalloc_init()
>
> Xen can end up calling vm_unmap_aliases() before vmalloc_init() has
> been called.  In this case its safe to make it a simple no-op.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> diff -r 42c8b29f7ccf mm/vmalloc.c
> --- a/mm/vmalloc.c	Wed Oct 22 12:43:39 2008 -0700
> +++ b/mm/vmalloc.c	Wed Oct 22 21:39:00 2008 -0700
> @@ -591,6 +591,8 @@
>
>  #define VMAP_BLOCK_SIZE		(VMAP_BBMAP_BITS * PAGE_SIZE)
>
> +static bool vmap_initialized = false;
> +
>  struct vmap_block_queue {
>  	spinlock_t lock;
>  	struct list_head free;
> @@ -827,6 +829,9 @@
>  	int cpu;
>  	int flush = 0;
>
> +	if (!vmap_initialized)
> +		return;
> +
>  	for_each_possible_cpu(cpu) {
>  		struct vmap_block_queue *vbq = &per_cpu(vmap_block_queue, cpu);
>  		struct vmap_block *vb;
> @@ -940,6 +945,8 @@
>  		INIT_LIST_HEAD(&vbq->dirty);
>  		vbq->nr_dirty = 0;
>  	}
> +
> +	vmap_initialized = true;
>  }
>
>  void unmap_kernel_range(unsigned long addr, unsigned long size)
