Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbYFZHXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbYFZHXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYFZHX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:23:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:54744 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbYFZHX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:23:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,707,1204531200"; 
   d="scan'208";a="345728153"
Subject: Re: [PATCH 2/2] x86 boot: early_res_to_e820
From: "Huang, Ying" <ying.huang@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440806260013u447d15d8v94df7bb7bd00da19@mail.gmail.com>
References: <1214461980.10809.7.camel@caritas-dev.intel.com>
	 <86802c440806260013u447d15d8v94df7bb7bd00da19@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 26 Jun 2008 15:27:12 +0800
Message-Id: <1214465232.11346.18.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 26 Jun 2008 07:23:25.0930 (UTC) FILETIME=[85F33CA0:01C8D75D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 00:13 -0700, Yinghai Lu wrote:
> On Wed, Jun 25, 2008 at 11:33 PM, Huang, Ying <ying.huang@intel.com> wrote:
> > This patch reserves some memory areas of early_res in E820 as
> > E820_RESVD_KERN. This is used mainly on i386, for some memory area
> > from boot-loader and in highmem, such as linked list of setup_data,
> > EFI memory map, etc.
> >
> > This patch is based on latest x86/master branch of git-x86 tree and
> > has been tested on i386 and x86_64 platform.
> >
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> >
> > ---
> >  arch/x86/kernel/e820.c     |   22 ++++++++++++++++++++++
> >  arch/x86/kernel/setup_32.c |    2 ++
> >  include/asm-x86/e820.h     |    1 +
> >  3 files changed, 25 insertions(+)
> >
> > --- a/arch/x86/kernel/e820.c
> > +++ b/arch/x86/kernel/e820.c
> > @@ -844,6 +844,28 @@ void __init early_res_to_bootmem(u64 sta
> >        }
> >  }
> >
> > +void __init early_res_to_e820(u64 start, u64 end)
> > +{
> > +       int i, changed = 0;
> > +       u64 final_start, final_end;
> > +       for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
> > +               struct early_res *r = &early_res[i];
> > +               final_start = max(start, r->start);
> > +               final_end = min(end, r->end);
> > +               if (final_start >= final_end)
> > +                       continue;
> > +               printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
> > +                       final_start, final_end - 1, r->name);
> > +               e820_update_range(final_start, final_end - final_start,
> > +                                 E820_RAM, E820_RESVD_KERN);
> > +               changed = 1;
> > +       }
> > +       if (changed) {
> > +               printk(KERN_INFO "update e820 for early_res\n");
> > +               update_e820();
> > +       }
> > +}
> > +
> >  /* Check for already reserved areas */
> >  static inline int __init bad_addr(u64 *addrp, u64 size, u64 align)
> >  {
> > --- a/include/asm-x86/e820.h
> > +++ b/include/asm-x86/e820.h
> > @@ -96,6 +96,7 @@ extern void reserve_early(u64 start, u64
> >  extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
> >  extern void free_early(u64 start, u64 end);
> >  extern void early_res_to_bootmem(u64 start, u64 end);
> > +extern void early_res_to_e820(u64 start, u64 end);
> >  extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
> >
> >  extern unsigned long e820_end_of_ram(void);
> > --- a/arch/x86/kernel/setup_32.c
> > +++ b/arch/x86/kernel/setup_32.c
> > @@ -447,6 +447,8 @@ void __init setup_arch(char **cmdline_p)
> >         acpi_numa_init();
> >  #endif
> >
> > +       early_res_to_e820(max_low_pfn<<PAGE_SHIFT, -1);
> > +
> >        initmem_init(0, max_pfn);
> >
> >  #ifdef CONFIG_ACPI_SLEEP
> >
> > --
> 
> this one is not needed.

For example, if EFI memory map is allocated in highmem area by
boot-loader, it need to be reserved in kernel. But on i386, bootmem can
only reserve memory area below max_low_pfn. So I think this is needed.

In general, I think it is needed to provide a reservation mechanism for
highmem area on i386. Because some memory area from BIOS or boot-loader
may in highmem area.

Best Regards,
Huang Ying

