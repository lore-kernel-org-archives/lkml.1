Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbXJIVGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbXJIVGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 17:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbXJIVG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 17:06:29 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:33189 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbXJIVG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 17:06:28 -0400
Date: Tue, 9 Oct 2007 23:06:23 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: chandru <chandru@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, mark_salyzyn@adaptec.com, ak@suse.de,
       vgoyal@in.ibm.com
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables in kdump
Message-ID: <20071009210623.GK4335@rhun.haifa.ibm.com>
References: <1191962414.24134.68.camel@chandru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191962414.24134.68.camel@chandru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chandru,

Thanks for the patch. Comments on the patch below, but first a general
question for my education: the main problem here that aacraid
continues DMA'ing when it shouldn't. Why can't we shut it down
cleanly? Even without the presence of an IOMMU, it seems dangerous to
let an adapter continue DMA'ing to and from memory when the kernel is
an inconsistent state.

The patch below looks reasonable *if* that is the least worst way of
doing it - let's see if we can come up with something cleaner that
doesn't rely in the new kernel on data (which may or may not be
corrupted...) from the old kernel.

Cheers,
Muli

On Wed, Oct 10, 2007 at 02:10:13AM +0530, chandru wrote:

> kdump kernel fails to boot with calgary iommu and aacraid driver on
> a x366 box.  The ongoing dma's of aacraid from the first kernel
> continue to exist until the driver is loaded in the kdump
> kernel. Calgary is initialized prior to aacraid and creation of new
> tce tables causes wrong dma's to occur.
> 
> Here we try to grab the tce tables of the first kernel in kdump
> kernel and use them. While in the kdump kernel we do not allocate
> new tce tables but rather read the base address register contents of
> calgary iommu and use the tables that the registers point to. With
> these changes the kdump kernel and hence aacraid now boots normally.

> Another point that came when talking with Vivek was to reserve part
> of the tce table space in first kernel for use in the kdump kernel.
> 
> Signed-off-by: Chandru S <chandru@in.ibm.com>
> ---
> 
> --- linux-2.6.23-rc9/arch/x86_64/kernel/pci-calgary.c.orig
> 2007-10-09 23:39:22.000000000 +0530
> +++ linux-2.6.23-rc9/arch/x86_64/kernel/pci-calgary.c   2007-10-10
> 01:25:53.000000000 +0530
> @@ -35,6 +35,7 @@
>  #include <linux/pci_ids.h>
>  #include <linux/pci.h>
>  #include <linux/delay.h>
> +#include <linux/bootmem.h>
>  #include <asm/iommu.h>
>  #include <asm/calgary.h>
>  #include <asm/tce.h>
> @@ -165,6 +166,7 @@ static void calgary_dump_error_regs(stru
>  static void calioc2_handle_quirks(struct iommu_table *tbl, struct
> pci_dev *dev);
>  static void calioc2_tce_cache_blast(struct iommu_table *tbl);
>  static void calioc2_dump_error_regs(struct iommu_table *tbl);
> +static int  calgary_bus_has_devices(int , unsigned short ) __init;

Please add parameter names (int bus, etc).

>  static struct cal_chipset_ops calgary_chip_ops = {
>         .handle_quirks = calgary_handle_quirks,
> @@ -819,7 +821,23 @@ static int __init calgary_setup_tar(stru
> 
>         tbl = pci_iommu(dev->bus);
>         tbl->it_base = (unsigned
> long)bus_info[dev->bus->number].tce_space;
> -       tce_free(tbl, 0, tbl->it_size);
> +#ifdef CONFIG_CRASH_DUMP
> +        if (is_kdump_kernel()){
> +                u64 *tp;
> +                unsigned int index;
> +                tp = ((u64*)tbl->it_base);
> +                for(index=0;index < tbl->it_size; index++ ){
> +                        if ( *tp != 0x0 )
> +                                set_bit(index,tbl->it_map);
> +
> +                        tp++;
> +                }
> +        }
> +        else
> +#endif
> +       {
> +               tce_free(tbl, 0, tbl->it_size);
> +       }

Please no #ifdefs in here. Do it like this:

if (is_kdump_kernel())
   something()
else
   something_else()

Where is_kdump_kernel() is defined to 0 if CONFIG_CRASH_DUMP is not
set.

Also, please move the part where we scan the table into a suitably
named function, e.g., calgary_init_bitmap_from_tce_table().

Also, coding style - please run the patch through checkpatch.pl.

> +#ifdef CONFIG_CRASH_DUMP
> +       /*
> +        * If this is a kdump kernel, then try grabbing the tce tables
> +        * from first kernel by reading the contents of the base
> +        * address register of calgary iommu
> +        */
> +       if(is_kdump_kernel()){

Same comments as above.

> +               for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
> +                       struct calgary_bus_info *info = &bus_info[bus];
> +                       unsigned short pci_device;
> +                       unsigned long tce_space;
> +                       u32 val;
> +
> +                       val = read_pci_config(bus, 0, 0, 0);
> +                       pci_device = (val & 0xFFFF0000) >> 16;
> +
> +                       if (!is_cal_pci_dev(pci_device))
> +                               continue;
> +
> +                       if (info->translation_disabled)
> +                               continue;
> +
> +                       if (calgary_bus_has_devices(bus, pci_device) ||
> +                               translate_empty_slots ){
> +
> +                               target = calgary_reg(bus_info[bus].bbar,
> tar_offset(bus));
> +                               tce_space = be64_to_cpu(readq(target));
> +                               tce_space = tce_space & TAR_SW_BITS;
> +
> +                               BUG_ON(specified_table_size >
> TCE_TABLE_SIZE_8M);
> +
> +                               tce_space = tce_space & ( ~specified_table_size);
> +                               info->tce_space = (u64
> *)__va(tce_space);
> +                       }
> +               }
> +       }
> +#endif

This should be encapsulated in a function. Something like:

if (is_kdump_kernel())
   grab_tce_space_from_tar()

>         return 0;
> 
>  error:
> @@ -1380,7 +1435,10 @@ void __init detect_calgary(void)
>                 return;
>         }
> 
> -       specified_table_size = determine_tce_table_size(end_pfn *
> PAGE_SIZE);
> +       if(is_kdump_kernel())
> +               specified_table_size =
> determine_tce_table_size(saved_max_pfn * PAGE_SIZE);
> +       else
> +               specified_table_size = determine_tce_table_size(end_pfn
> * PAGE_SIZE);

What is the value of saved_max_pfn if !kdump? Can we just use it
unconditionally? If not, I prefer this as

max_pfn = is_kdump_kernel() ? saved_max_pfn : end_pfn;
...

>         for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
>                 struct calgary_bus_info *info = &bus_info[bus];
> @@ -1398,10 +1456,17 @@ void __init detect_calgary(void)
> 
>                 if (calgary_bus_has_devices(bus, pci_device) ||
>                     translate_empty_slots) {
> -                       tbl = alloc_tce_table();
> -                       if (!tbl)
> -                               goto cleanup;
> -                       info->tce_space = tbl;
> +               /*
> +                * If this is the kdump kernel then do not allocate
> +                * new tce tables, try using the tce tables from the
> +                * first kernel 
> +                */
> +                       if(!is_kdump_kernel()){
> +                               tbl = alloc_tce_table();
> +                               if (!tbl)
> +                                       goto cleanup;
> +                               info->tce_space = tbl;
> +                       }

Coding style, but otherwise looks ok.

>                         calgary_found = 1;
>                 }
>         }
> --- linux-2.6.23-rc9/include/linux/bootmem.h.orig       2007-10-09
> 23:39:32.000000000 +0530
> +++ linux-2.6.23-rc9/include/linux/bootmem.h    2007-10-09
> 23:26:19.000000000 +0530
> @@ -21,6 +21,12 @@ extern unsigned long max_pfn;
> 
>  #ifdef CONFIG_CRASH_DUMP
>  extern unsigned long saved_max_pfn;
> +static inline int is_kdump_kernel(void)
> +{
> +       return reset_devices ? 1 : 0 ;
> +}
> +#else
> +static inline is_kdump_kernel(void) { return 0; }
>  #endif

Please define is_kdump_kernel() even if CONFIG_CRASH_DUMP is set, that
will let us avoid the ifdef in C files.

Cheers,
Muli
-- 
SYSTOR 2007 --- 1st Annual Haifa Systems and Storage Conference 2007
http://www.haifa.il.ibm.com/Workshops/systor2007/

Virtualization workshop: Oct 29th, 2007 | Storage workshop: Oct 30th, 2007
