Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbYCUPzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbYCUPzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbYCUPzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:55:04 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49061 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYCUPzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:55:02 -0400
Subject: Re: [PATCH 1/5] generic __remove_pages() support
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080321235322.2B17.E1E9C6FF@jp.fujitsu.com>
References: <1204829673.7939.59.camel@dyn9047017100.beaverton.ibm.com>
	 <1204829734.7939.61.camel@dyn9047017100.beaverton.ibm.com>
	 <20080321235322.2B17.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 08:55:20 -0800
Message-Id: <1206118520.16127.28.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-22 at 00:25 +0900, Yasunori Goto wrote:
> Badari-san.
> 
> > Index: linux-2.6.25-rc2/mm/memory_hotplug.c
> > ===================================================================
> > --- linux-2.6.25-rc2.orig/mm/memory_hotplug.c	2008-02-27 12:58:17.000000000 -0800
> > +++ linux-2.6.25-rc2/mm/memory_hotplug.c	2008-02-27 16:06:50.000000000 -0800
> > @@ -102,6 +102,21 @@ static int __add_section(struct zone *zo
> >  	return register_new_memory(__pfn_to_section(phys_start_pfn));
> >  }
> >  
> > +static int __remove_section(struct zone *zone, struct mem_section *ms)
> > +{
> > +	int ret = -EINVAL;
> > +
> > +	if (!valid_section(ms))
> > +		return ret;
> > +
> > +	ret = unregister_memory_section(ms);
> > +	if (ret)
> > +		return ret;
> > +
> > +	sparse_remove_one_section(zone, ms);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Reasonably generic function for adding memory.  It is
> >   * expected that archs that support memory hotplug will
> > @@ -135,6 +150,35 @@ int __add_pages(struct zone *zone, unsig
> >  }
> >  EXPORT_SYMBOL_GPL(__add_pages);
> >  
> > +int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
> > +		 unsigned long nr_pages)
> > +{
> > +	unsigned long i, ret = 0;
> > +	int sections_to_remove;
> > +	unsigned long flags;
> > +	struct pglist_data *pgdat = zone->zone_pgdat;
> > +
> > +	/*
> > +	 * We can only remove entire sections
> > +	 */
> > +	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
> > +	BUG_ON(nr_pages % PAGES_PER_SECTION);
> > +
> > +	release_mem_region(phys_start_pfn << PAGE_SHIFT, nr_pages * PAGE_SIZE);
> > +
> > +	sections_to_remove = nr_pages / PAGES_PER_SECTION;
> > +	for (i = 0; i < sections_to_remove; i++) {
> > +		unsigned long pfn = phys_start_pfn + i*PAGES_PER_SECTION;
> > +		pgdat_resize_lock(pgdat, &flags);
> > +		ret = __remove_section(zone, __pfn_to_section(pfn));
> > +		pgdat_resize_unlock(pgdat, &flags);
> > +		if (ret)
> > +			break;
> > +	}
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(__remove_pages);
> 
> Here may be a bug.
> __remove_section() is called with pgdat_resize_lock() which is
> spin_lock_irqsave().
> 
>   __remove_section()
>       |
>       +--> unregister_memory_section()
>               |
>               +--> remove_memory_block()
>                       |
>                       +--> unregister_memory()
>                              |
>                              +--> sysdev_unregister()
> 
> sysdev_unregister() calls mutex_lock().
> It might sleep with irq disable, right?
> I found BUG()'s messages by this.

Hmm. I think you are right. Let me take a look
and see if we can move sysdev_unregister() outside
the lock.

Thanks for finding it.

Thanks,
Badari

