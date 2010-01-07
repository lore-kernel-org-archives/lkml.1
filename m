Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949Ab0AGFm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0AGFm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 00:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811Ab0AGFm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 00:42:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60863 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0AGFm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 00:42:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 14:39:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] vmalloc: simplify vread()/vwrite()
Message-Id: <20100107143902.a04573e3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107052403.GA25203@localhost>
References: <20100107012458.GA9073@localhost>
	<20100107103825.239ffcf9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107025054.GA11252@localhost>
	<1262834141.17852.23.camel@yhuang-dev.sh.intel.com>
	<20100107122304.b5c1d777.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107052403.GA25203@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 13:24:03 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Thu, Jan 07, 2010 at 11:23:04AM +0800, KAMEZAWA Hiroyuki wrote:
> > On Thu, 07 Jan 2010 11:15:41 +0800
> > Huang Ying <ying.huang@intel.com> wrote:
> > 
> > > > > 
> > > > > > The page_is_ram() check is necessary because kmap_atomic() is not
> > > > > > designed to work with non-RAM pages.
> > > > > > 
> > > > > I think page_is_ram() is not a complete method...on x86, it just check
> > > > > e820's memory range. checking VM_IOREMAP is better, I think.
> > > > 
> > > > (double check) Not complete or not safe?
> > > > 
> > > > EFI seems to not update e820 table by default.  Ying, do you know why?
> > > 
> > > In EFI system, E820 table is constructed from EFI memory map in boot
> > > loader, so I think you can rely on E820 table.
> > > 
> > Yes, we can rely on. But concerns here is that we cannot get any
> > information of ioremap via e820 map. 
> > 
> > But yes,
> > == ioremap()
> >  140         for (pfn = phys_addr >> PAGE_SHIFT;
> >  141                                 (pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
> >  142                                 pfn++) {
> >  143 
> >  144                 int is_ram = page_is_ram(pfn);
> >  145 
> >  146                 if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
> >  147                         return NULL;
> >  148                 WARN_ON_ONCE(is_ram);
> >  149         }
> > ==
> > you'll get warned before access if "ram" area is remapped...
> 
> Right.
> 
> > But, about this patch, it seems that page_is_ram() is not free from architecture
> > dependecy.
> 
> Yes this is a problem. We can provide a generic page_is_ram() as below.
> And could further convert the existing x86 (and others) page_is_ram()
> to be resource-based -- since at least for now the e820 table won't be
> updated on memory hotplug.
> 
> Thanks,
> Fengguang

seems nice :)

Thanks,
-Kame

> ---
>  include/linux/ioport.h |    2 ++
>  kernel/resource.c      |   18 ++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> --- linux-mm.orig/kernel/resource.c	2010-01-07 12:40:55.000000000 +0800
> +++ linux-mm/kernel/resource.c	2010-01-07 13:13:46.000000000 +0800
> @@ -297,6 +297,24 @@ int walk_system_ram_range(unsigned long 
>  
>  #endif
>  
> +static int __page_is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
> +{
> +	int *is_ram = arg;
> +
> +	*is_ram = 1;
> +
> +	return 1;
> +}
> +
> +int __attribute__((weak)) page_is_ram(unsigned long pagenr)
> +{
> +	int is_ram = 0;
> +
> +	walk_system_ram_range(pagenr, 1, &is_ram, __page_is_ram);
> +
> +	return is_ram;
> +}
> +
>  /*
>   * Find empty slot in the resource tree given range and alignment.
>   */
> --- linux-mm.orig/include/linux/ioport.h	2010-01-07 13:11:43.000000000 +0800
> +++ linux-mm/include/linux/ioport.h	2010-01-07 13:12:37.000000000 +0800
> @@ -188,5 +188,7 @@ extern int
>  walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
>  		void *arg, int (*func)(unsigned long, unsigned long, void *));
>  
> +extern int page_is_ram(unsigned long pagenr);
> +
>  #endif /* __ASSEMBLY__ */
>  #endif	/* _LINUX_IOPORT_H */
> 

