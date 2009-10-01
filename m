Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZJAVf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZJAVf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZJAVf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:35:57 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54091 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZJAVf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:35:56 -0400
Message-ID: <4AC520B5.9080600@austin.ibm.com>
Date: Thu, 01 Oct 2009 16:35:49 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] mm: add notifier in pageblock isolation for balloon
 drivers
References: <20091001195311.GA16667@austin.ibm.com>
In-Reply-To: <20091001195311.GA16667@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Jennings wrote:
> Memory balloon drivers can allocate a large amount of memory which
> is not movable but could be freed to accommodate memory hotplug remove.
> 
> Prior to calling the memory hotplug notifier chain the memory in the
> pageblock is isolated.  If the migrate type is not MIGRATE_MOVABLE the
> isolation will not proceed, causing the memory removal for that page
> range to fail.
> 
> Rather than immediately failing pageblock isolation if the the
> migrateteype is not MIGRATE_MOVABLE, this patch checks if all of the
> pages in the pageblock are owned by a registered balloon driver using a
> notifier chain.  If all of the non-movable pages are owned by a balloon,
> they can be freed later through the memory notifier chain and the range
> can still be isolated in set_migratetype_isolate().
> 
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> 
> ---
>  drivers/base/memory.c  |   19 +++++++++++++++++++
>  include/linux/memory.h |   22 ++++++++++++++++++++++
>  mm/page_alloc.c        |   49 +++++++++++++++++++++++++++++++++++++++++--------
>  3 files changed, 82 insertions(+), 8 deletions(-)
> 
> Index: b/drivers/base/memory.c
> ===================================================================
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -63,6 +63,20 @@ void unregister_memory_notifier(struct n
>  }
>  EXPORT_SYMBOL(unregister_memory_notifier);
>  
> +static BLOCKING_NOTIFIER_HEAD(memory_isolate_chain);
> +
> +int register_memory_isolate_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_register(&memory_isolate_chain, nb);
> +}
> +EXPORT_SYMBOL(register_memory_isolate_notifier);
> +
> +void unregister_memory_isolate_notifier(struct notifier_block *nb)
> +{
> +	blocking_notifier_chain_unregister(&memory_isolate_chain, nb);
> +}
> +EXPORT_SYMBOL(unregister_memory_isolate_notifier);
> +
>  /*
>   * register_memory - Setup a sysfs device for a memory block
>   */
> @@ -157,6 +171,11 @@ int memory_notify(unsigned long val, voi
>  	return blocking_notifier_call_chain(&memory_chain, val, v);
>  }
>  
> +int memory_isolate_notify(unsigned long val, void *v)
> +{
> +	return blocking_notifier_call_chain(&memory_isolate_chain, val, v);
> +}
> +
>  /*
>   * MEMORY_HOTPLUG depends on SPARSEMEM in mm/Kconfig, so it is
>   * OK to have direct references to sparsemem variables in here.
> Index: b/include/linux/memory.h
> ===================================================================
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -50,6 +50,14 @@ struct memory_notify {
>  	int status_change_nid;
>  };
>  
> +#define MEM_ISOLATE_COUNT	(1<<0)
> +
> +struct memory_isolate_notify {
> +	unsigned long start_addr;
> +	unsigned int nr_pages;
> +	unsigned int pages_found;
> +};
> +
>  struct notifier_block;
>  struct mem_section;
>  
> @@ -76,14 +84,28 @@ static inline int memory_notify(unsigned
>  {
>  	return 0;
>  }
> +static inline int register_memory_isolate_notifier(struct notifier_block *nb)
> +{
> +	return 0;
> +}
> +static inline void unregister_memory_isolate_notifier(struct notifier_block *nb)
> +{
> +}
> +static inline int memory_isolate_notify(unsigned long val, void *v)
> +{
> +	return 0;
> +}
>  #else
>  extern int register_memory_notifier(struct notifier_block *nb);
>  extern void unregister_memory_notifier(struct notifier_block *nb);
> +extern int register_memory_isolate_notifier(struct notifier_block *nb);
> +extern void unregister_memory_isolate_notifier(struct notifier_block *nb);
>  extern int register_new_memory(int, struct mem_section *);
>  extern int unregister_memory_section(struct mem_section *);
>  extern int memory_dev_init(void);
>  extern int remove_memory_block(unsigned long, struct mem_section *, int);
>  extern int memory_notify(unsigned long val, void *v);
> +extern int memory_isolate_notify(unsigned long val, void *v);
>  extern struct memory_block *find_memory_block(struct mem_section *);
>  #define CONFIG_MEM_BLOCK_SIZE	(PAGES_PER_SECTION<<PAGE_SHIFT)
>  enum mem_add_context { BOOT, HOTPLUG };
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -48,6 +48,7 @@
>  #include <linux/page_cgroup.h>
>  #include <linux/debugobjects.h>
>  #include <linux/kmemleak.h>
> +#include <linux/memory.h>
>  #include <trace/events/kmem.h>
>  
>  #include <asm/tlbflush.h>
> @@ -4985,23 +4986,55 @@ void set_pageblock_flags_group(struct pa
>  int set_migratetype_isolate(struct page *page)
>  {
>  	struct zone *zone;
> -	unsigned long flags;
> +	unsigned long flags, pfn, iter;
> +	long immobile = 0;
> +	struct memory_isolate_notify arg;
> +	int notifier_ret;
>  	int ret = -EBUSY;
>  	int zone_idx;
>  
>  	zone = page_zone(page);
>  	zone_idx = zone_idx(zone);
> +
> +	pfn = page_to_pfn(page);
> +	arg.start_addr = (unsigned long)page_address(page);
> +	arg.nr_pages = pageblock_nr_pages;
> +	arg.pages_found = 0;
> +
>  	spin_lock_irqsave(&zone->lock, flags);
>  	/*
>  	 * In future, more migrate types will be able to be isolation target.
>  	 */
> -	if (get_pageblock_migratetype(page) != MIGRATE_MOVABLE &&
> -	    zone_idx != ZONE_MOVABLE)
> -		goto out;
> -	set_pageblock_migratetype(page, MIGRATE_ISOLATE);
> -	move_freepages_block(zone, page, MIGRATE_ISOLATE);
> -	ret = 0;
> -out:
> +	do {
> +		if (get_pageblock_migratetype(page) == MIGRATE_MOVABLE &&
> +		    zone_idx == ZONE_MOVABLE) {
> +			ret = 0;
> +			break;
> +		}
> +
> +		/*
> +		 * If all of the pages in a zone are used by a balloon,
> +		 * the range can be still be isolated.  The balloon will
> +		 * free these pages from the memory notifier chain.
> +		 */
> +		notifier_ret = memory_isolate_notify(MEM_ISOLATE_COUNT, &arg);
> +		notifier_ret = notifier_to_errno(ret);

Should this be

		notifier_ret = notifier_to_errno(notifier_ret);

-Nathan

> +		if (notifier_ret || !arg.pages_found)
> +			break;
> +
> +		for (iter = pfn; iter < (pfn + pageblock_nr_pages); iter++)
> +			if (page_count(pfn_to_page(iter)))
> +				immobile++;
> +
> +		if (arg.pages_found == immobile)
> +			ret = 0;
> +	} while (0);
> +
> +	if (!ret) {
> +		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
> +		move_freepages_block(zone, page, MIGRATE_ISOLATE);
> +	}
> +
>  	spin_unlock_irqrestore(&zone->lock, flags);
>  	if (!ret)
>  		drain_all_pages();
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
