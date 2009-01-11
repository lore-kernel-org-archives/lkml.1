Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZAKXE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZAKXE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 18:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZAKXEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 18:04:50 -0500
Received: from cmpxchg.org ([85.214.51.133]:55138 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZAKXEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 18:04:50 -0500
Date: Mon, 12 Jan 2009 00:04:30 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: fix vmalloc breakage
Message-ID: <20090111230430.GA17873@cmpxchg.org>
References: <20090107230144.GA30170@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107230144.GA30170@jurassic.park.msu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 02:01:44AM +0300, Ivan Kokshaysky wrote:
> On alpha, we have to map some stuff in the VMALLOC space very
> early in the boot process (to make SRM console callbacks work
> and so on, see arch/alpha/mm/init.c). For old VM allocator,
> we just manually placed a vm_struct onto the global vmlist
> and this worked for ages.
> Unfortunately, the new allocator isn't aware of this, so it constantly
> tries to allocate the VM space which is already in use, making vmalloc
> on alpha defunct.
> 
> This patch forces KVA to import vmlist entries on init.
> 
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> ---
>  mm/vmalloc.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c5db9a7..0dd9c2e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -24,6 +24,7 @@
>  #include <linux/rbtree.h>
>  #include <linux/radix-tree.h>
>  #include <linux/rcupdate.h>
> +#include <linux/bootmem.h>
>  
>  #include <asm/atomic.h>
>  #include <asm/uaccess.h>
> @@ -984,6 +985,8 @@ EXPORT_SYMBOL(vm_map_ram);
>  
>  void __init vmalloc_init(void)
>  {
> +	struct vmap_area *va;
> +	struct vm_struct *tmp;
>  	int i;
>  
>  	for_each_possible_cpu(i) {
> @@ -996,6 +999,16 @@ void __init vmalloc_init(void)
>  		vbq->nr_dirty = 0;
>  	}
>  
> +	/* Import existing vmlist entries. */
> +	for (tmp = vmlist; tmp; tmp = tmp->next) {
> +		va = alloc_bootmem(sizeof(struct vmap_area));
> +		if (!va)
> +			break;

You don't need this check, alloc_bootmem() panics when it fails.

	Hannes
