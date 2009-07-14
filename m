Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZGNQOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZGNQOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbZGNQOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:14:52 -0400
Received: from cmpxchg.org ([85.214.51.133]:48912 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbZGNQOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:14:52 -0400
Date: Tue, 14 Jul 2009 18:14:16 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Bernd Schmidt <bernds_cb1@t-online.de>, Bryan Wu <cooloney@kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] NOMMU: add support for Memory Protection Units (MPU)
Message-ID: <20090714161416.GA19147@cmpxchg.org>
References: <1247581340-20031-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247581340-20031-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 10:22:20AM -0400, Mike Frysinger wrote:
> From: Bernd Schmidt <bernds_cb1@t-online.de>
> 
> Some architectures (like the Blackfin arch) implement some of the
> "simpler" features that one would expect out of a MMU such as memory
> protection.  In our case, we actually get read/write/exec protection
> down to the page boundary so processes can't stomp on each other let
> alone the kernel.  There is a performance decrease (which depends greatly
> on the workload) however as the hardware/software interaction was not
> optimized at design time.
> 
> Signed-off-by: Bernd Schmidt <bernds_cb1@t-online.de>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: David Howells <dhowells@redhat.com>
> ---
>  kernel/module.c |    5 +++++
>  mm/nommu.c      |   25 +++++++++++++++++++++++++
>  2 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 0a04983..e1a3dfc 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -47,6 +47,7 @@
>  #include <linux/rculist.h>
>  #include <asm/uaccess.h>
>  #include <asm/cacheflush.h>
> +#include <asm/mmu_context.h>
>  #include <linux/license.h>
>  #include <asm/sections.h>
>  #include <linux/tracepoint.h>
> @@ -1519,6 +1520,10 @@ static void free_module(struct module *mod)
>  
>  	/* Finally, free the core (containing the module structure) */
>  	module_free(mod, mod->module_core);
> +
> +#ifdef CONFIG_MPU
> +	update_protections(current->mm);
> +#endif
>  }
>  
>  void *__symbol_get(const char *symbol)
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 53cab10..a0269e5 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -33,6 +33,7 @@
>  #include <asm/uaccess.h>
>  #include <asm/tlb.h>
>  #include <asm/tlbflush.h>
> +#include <asm/mmu_context.h>
>  #include "internal.h"
>  
>  static inline __attribute__((format(printf, 1, 2)))
> @@ -640,11 +641,23 @@ static void add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
>  	struct vm_area_struct *pvma, **pp;
>  	struct address_space *mapping;
>  	struct rb_node **p, *parent;
> +#ifdef CONFIG_MPU
> +	long start;
> +#endif
>  
>  	kenter(",%p", vma);
>  
>  	BUG_ON(!vma->vm_region);
>  
> +#ifdef CONFIG_MPU
> +	start = vma->vm_start & PAGE_MASK;
> +	while (start < vma->vm_end) {
> +		protect_page(mm, start, vma->vm_flags);
> +		start += PAGE_SIZE;
> +	}
> +	update_protections(mm);
> +#endif
> +
>  	mm->map_count++;
>  	vma->vm_mm = mm;
>  
> @@ -707,9 +720,21 @@ static void delete_vma_from_mm(struct vm_area_struct *vma)
>  	struct vm_area_struct **pp;
>  	struct address_space *mapping;
>  	struct mm_struct *mm = vma->vm_mm;
> +#ifdef CONFIG_MPU
> +	long start;
> +#endif
>  
>  	kenter("%p", vma);
>  
> +#ifdef CONFIG_MPU
> +	start = vma->vm_start & PAGE_MASK;
> +	while (start < vma->vm_end) {
> +		protect_page(mm, start, 0);
> +		start += PAGE_SIZE;
> +	}
> +	update_protections(mm);
> +#endif

How about refactoring that into one function?  Saves all but one
#ifdef.
