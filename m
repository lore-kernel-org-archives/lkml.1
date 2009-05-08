Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZEHCBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZEHCBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 22:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZEHCBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:01:24 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:56450 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752041AbZEHCBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:01:23 -0400
Date: Fri, 8 May 2009 11:01:23 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Xen-devel <xen-devel@lists.xensource.com>,
       Alex Nixon <alex.nixon@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] [PATCH 03/11] Xen: Rename the balloon lock
Message-ID: <20090508020123.GE25512%yamahata@valinux.co.jp>
References: <1241732737-7669-1-git-send-email-jeremy@goop.org> <1241732737-7669-4-git-send-email-jeremy@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241732737-7669-4-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Please please don't move the arch common variable
into x86 specific file. It causes link error on ia64.

Before I sent the patches to fix it twice or so,
but it seems to be dropped.


On Thu, May 07, 2009 at 02:45:29PM -0700, Jeremy Fitzhardinge wrote:
> From: Alex Nixon <alex.nixon@citrix.com>
> 
> Impact: cleanup
> 
> * xen_create_contiguous_region needs access to the balloon lock to
>   ensure memory doesn't change under its feet, so expose the balloon
>   lock
> * Change the name of the lock to xen_reservation_lock, to imply it's
>   now less-specific usage.
> 
> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/xen/mmu.c             |    7 +++++++
>  drivers/xen/balloon.c          |   15 ++++-----------
>  include/xen/interface/memory.h |    8 ++++++++
>  3 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index d673b03..218cf79 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -67,6 +67,13 @@
>  
>  #define MMU_UPDATE_HISTO	30
>  
> +/*
> + * Protects atomic reservation decrease/increase against concurrent increases.
> + * Also protects non-atomic updates of current_pages and driver_pages, and
> + * balloon lists.
> + */
> +DEFINE_SPINLOCK(xen_reservation_lock);
> +
>  #ifdef CONFIG_XEN_DEBUG_FS
>  
>  static struct {
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index efa4b36..1e7984d 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -84,13 +84,6 @@ static struct sys_device balloon_sysdev;
>  
>  static int register_balloon(struct sys_device *sysdev);
>  
> -/*
> - * Protects atomic reservation decrease/increase against concurrent increases.
> - * Also protects non-atomic updates of current_pages and driver_pages, and
> - * balloon lists.
> - */
> -static DEFINE_SPINLOCK(balloon_lock);
> -
>  static struct balloon_stats balloon_stats;
>  
>  /* We increase/decrease in batches which fit in a page */
> @@ -209,7 +202,7 @@ static int increase_reservation(unsigned long nr_pages)
>  	if (nr_pages > ARRAY_SIZE(frame_list))
>  		nr_pages = ARRAY_SIZE(frame_list);
>  
> -	spin_lock_irqsave(&balloon_lock, flags);
> +	spin_lock_irqsave(&xen_reservation_lock, flags);
>  
>  	page = balloon_first_page();
>  	for (i = 0; i < nr_pages; i++) {
> @@ -267,7 +260,7 @@ static int increase_reservation(unsigned long nr_pages)
>  	totalram_pages = balloon_stats.current_pages;
>  
>   out:
> -	spin_unlock_irqrestore(&balloon_lock, flags);
> +	spin_unlock_irqrestore(&xen_reservation_lock, flags);
>  
>  	return 0;
>  }
> @@ -312,7 +305,7 @@ static int decrease_reservation(unsigned long nr_pages)
>  	kmap_flush_unused();
>  	flush_tlb_all();
>  
> -	spin_lock_irqsave(&balloon_lock, flags);
> +	spin_lock_irqsave(&xen_reservation_lock, flags);
>  
>  	/* No more mappings: invalidate P2M and add to balloon. */
>  	for (i = 0; i < nr_pages; i++) {
> @@ -329,7 +322,7 @@ static int decrease_reservation(unsigned long nr_pages)
>  	balloon_stats.current_pages -= nr_pages;
>  	totalram_pages = balloon_stats.current_pages;
>  
> -	spin_unlock_irqrestore(&balloon_lock, flags);
> +	spin_unlock_irqrestore(&xen_reservation_lock, flags);
>  
>  	return need_sleep;
>  }
> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> index f548f7c..9df4bd0 100644
> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -9,6 +9,8 @@
>  #ifndef __XEN_PUBLIC_MEMORY_H__
>  #define __XEN_PUBLIC_MEMORY_H__
>  
> +#include <linux/spinlock.h>
> +
>  /*
>   * Increase or decrease the specified domain's memory reservation. Returns a
>   * -ve errcode on failure, or the # extents successfully allocated or freed.
> @@ -184,4 +186,10 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_memory_map);
>   */
>  #define XENMEM_machine_memory_map   10
>  
> +/*
> + * Prevent the balloon driver from changing the memory reservation during a driver
> + * critical region.
> + */
> +extern spinlock_t xen_reservation_lock;
> +
>  #endif /* __XEN_PUBLIC_MEMORY_H__ */

-- 
yamahata
