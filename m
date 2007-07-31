Return-Path: <linux-kernel-owner+w=401wt.eu-S939743AbXGaE2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939743AbXGaE2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbXGaE2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:28:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60818 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbXGaE2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:28:20 -0400
Date: Tue, 31 Jul 2007 13:29:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "David Mosberger-Tang" <dmosberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "Zoltan.Menyhart@bull.net" <Zoltan.Menyhart@bull.net>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] flush icache before set_pte take6. [4/4] optimization
 for cpus other than montecito
Message-Id: <20070731132932.8e21d48c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <ed5aea430707302115h484620f1le51fc054436b273a@mail.gmail.com>
References: <20070731113543.93ffd964.kamezawa.hiroyu@jp.fujitsu.com>
	<20070731114155.5785123c.kamezawa.hiroyu@jp.fujitsu.com>
	<ed5aea430707302115h484620f1le51fc054436b273a@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007 22:15:50 -0600
"David Mosberger-Tang" <dmosberger@gmail.com> wrote:

> This seems crazy to me.  Flushing should occur according to the
> *architecture*, not model-by-model.  Even if we happen to get "lucky"
> on pre-Montecito CPUs, that doesn't justify such ugly hacks.  

I'm not sure this can happen before Montecito because L1 was write-through
and L2 was mixed. 

> Or you really want to debug this *again* come next CPU?

No. 
I should add RFC to this patch. I just want to hear opinions.
This is why I separated this patch. I can drop this.

Thanks,
-Kame





 
>   --david
> 
> On 7/30/07, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > Add "L2 cache is separated? check flag" as read_mostly global variable.
> >
> > This add one memory reference to global variable to page faults of "executable"
> > map in do_wp_page(page copy case), file-mapped page fault and some system calls
> > which does memory map changes. But not so bad as calling sync_icache_dcache in
> > architectures which doesn't need it.
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> >
> > ---
> >  arch/ia64/kernel/setup.c   |    7 +++++++
> >  include/asm-ia64/pgtable.h |    3 ++-
> >  2 files changed, 9 insertions(+), 1 deletion(-)
> >
> > Index: linux-2.6.23-rc1.test/arch/ia64/kernel/setup.c
> > ===================================================================
> > --- linux-2.6.23-rc1.test.orig/arch/ia64/kernel/setup.c
> > +++ linux-2.6.23-rc1.test/arch/ia64/kernel/setup.c
> > @@ -106,6 +106,8 @@ struct io_space io_space[MAX_IO_SPACES];
> >  EXPORT_SYMBOL(io_space);
> >  unsigned int num_io_spaces;
> >
> > +int separated_l2_icache_dcache __read_mostly;
> > +
> >  /*
> >   * "flush_icache_range()" needs to know what processor dependent stride size to use
> >   * when it makes i-cache(s) coherent with d-caches.
> > @@ -718,6 +720,11 @@ get_model_name(__u8 family, __u8 model)
> >                 printk(KERN_ERR
> >                        "%s: Table overflow. Some processor model information will be missing\n",
> >                        __FUNCTION__);
> > +       /* Montecito has separated L2 Icache and Dcache. This requires
> > +          synchronize Icache and Dcache before set_pte() */
> > +       if (family == 0x20)
> > +               separated_l2_icache_dcache = 1;
> > +
> >         return "Unknown";
> >  }
> >
> > Index: linux-2.6.23-rc1.test/include/asm-ia64/pgtable.h
> > ===================================================================
> > --- linux-2.6.23-rc1.test.orig/include/asm-ia64/pgtable.h
> > +++ linux-2.6.23-rc1.test/include/asm-ia64/pgtable.h
> > @@ -489,9 +489,10 @@ extern struct page *zero_page_memmap_ptr
> >   * as an executable pte.
> >   */
> >  extern void __sync_icache_dcache(pte_t pte);
> > +extern int separated_l2_icache_dcache;
> >  static inline void sync_icache_dcache(pte_t pte)
> >  {
> > -       if (pte_exec(pte))
> > +       if (pte_exec(pte) && separated_l2_icache_dcache)
> >                 __sync_icache_dcache(pte);
> >  }
> >  #define __HAVE_ARCH_SYNC_ICACHE_DCACHE
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-ia64" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> -- 
> Mosberger Consulting LLC, http://www.mosberger-consulting.com/
> 

