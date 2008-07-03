Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbYGCMoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbYGCMoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760308AbYGCMn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:43:57 -0400
Received: from mail.macqel.be ([194.78.208.39]:10409 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760302AbYGCMn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:43:57 -0400
Date: Thu, 3 Jul 2008 11:37:36 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       libdc1394-devel@lists.sourceforge.net, stefanr@s5r6.in-berlin.de,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: mmap'ed memory in core files ?
Message-ID: <20080703093736.GA14369@frolo.macqel>
References: <20080701132149.GA32510@frolo.macqel> <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com> <20080702105027.GA1111@frolo.macqel> <cfd18e0f0807020358k317575c6ra0187428098f0160@mail.gmail.com> <486C4CC5.2060006@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486C4CC5.2060006@hitachi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry, resent with CC += linux1394-devel@lists.sourceforge.net]
Hello Hidehiro,

On Thu, Jul 03, 2008 at 12:51:33PM +0900, Hidehiro Kawai wrote:
> Hi,
> 
> Michael Kerrisk wrote:
> 
> > [CC+= hidehiro.kawai.ez@hitachi.com]
> > 
> > On Wed, Jul 2, 2008 at 12:50 PM, Philippe De Muyter <phdm@macqel.be> wrote:
> > 
> >>Hi Michael,
> >>
> >>On Tue, Jul 01, 2008 at 08:16:11PM +0200, Michael Kerrisk wrote:
> >>
> >>>On 7/1/08, Philippe De Muyter <phdm@macqel.be> wrote:
> >>>
> >>>>Hello everybody,
> >>>>
> >>>> I develop video acquisition software using the video1394 interface.
> >>>> The images grabbed by the camera and iee1394 bus are kept in kernel
> >>>> memory and made available to the user program through a mmap call done
> >>>> in the libdc1394 library :
> >>>>
> >>>> dma_ring_buffer= mmap(0, vmmap.nb_buffers * vmmap.buf_size,
> >>>>                PROT_READ|PROT_WRITE,MAP_SHARED, craw->capture.dma_fd, 0);
> >>>>
> >>>> Sometimes, my program crashes and produces a core file :)  It seems to
> >>>> me that the core file does not contain the mmap'ed memory and hence
> >>>> I cannot replay my program with the same image for debugging purpose.
> >>>>
> >>>> Is it possible to configure the kernel through /proc, or through the mmap
> >>>> system call to have that mmapped segment in the core file, or do I need
> >>>> to modify the kernel itself to obtain the behaviour I want ?  If I
> >>>> need to modify the kernel, can some kind soul provide me some pointers ?
> >>>
> >>>
> >>>Have a look at the section "Controlling which mappings are written to
> >>>the core dump" in a recent core.5 man page:
> >>>http://www.kernel.org/doc/man-pages/online/pages/man5/core.5.html
> >>
> >>thanks for the info.  I didn't know about /proc/PID/coredump_filter.
> >>
> >>that part was promising :
> >>
> >>      bit 2  Dump file-backed private mappings.
> >>      bit 3  Dump file-backed shared mappings.
> >>
> >>   The default value of coredump_filter is 0x3; this reflects traditional
> >>   Linux behavior and means that only anonymous memory segments are dumped.
> >>
> >>Unfortunately, the part that applies to me (I have tested it) is the next one :
> >>
> >>   Memory-mapped I/O pages such as frame buffer are never dumped, [...],
> >>   regardless of the coredump_filter value.
> >>
> >>Is that a design decision, or a mere finding of the way it is implemented
> >>now ?
> 
> MMIO pages have been not dumped since a long time ago, and I didn't target
> them for the coredump_filter feature because I thought it was generally
> danger to read MMIO pages.  As for frame buffer we would be able to
> safely access to it, but there is no way to tell it from other MMIO
> mappings, AFAIK.
> 
> >>So, back to my original question :
> >>
> >>Can some kind soul provide me some pointers to the way I should modify
> >>the kernel to make the inclusion of the video1394 mmapped segment in
> >>core files possible ?
> > 
> > 
> > Perhaps Hidehiro, who wrote the coredump_filter feature, can provide insight.
> 
> The following patch may help.  To dump MMIO pages, set bit 5 of
> coredump_filter.
> 
> $ echo 0x23 > /proc/<PID>/coredump_filter
> 
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> ---
> This patch is not intended to be merged to the upstream kernel
> because the safeness of reading VM_IO mappings has not been
> proved.
> 
> Index: linux-2.6.26-rc5-mm3/fs/binfmt_elf.c
> ===================================================================
> --- linux-2.6.26-rc5-mm3.orig/fs/binfmt_elf.c
> +++ linux-2.6.26-rc5-mm3/fs/binfmt_elf.c
> @@ -1141,11 +1141,18 @@ static unsigned long vma_dump_size(struc
>  	if (vma->vm_flags & VM_ALWAYSDUMP)
>  		goto whole;
>  
> -	/* Do not dump I/O mapped devices or special mappings */
> -	if (vma->vm_flags & (VM_IO | VM_RESERVED))
> +#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
> +
> +	/* By default, do not dump memory mapped I/O mappings */
> +	if (vma->vm_flags & VM_IO) {
> +		if (FILTER(MMIO))
> +			goto whole;
>  		return 0;
> +	}
>  
> -#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
> +	/* Do not dump special mappings */
> +	if (vma->vm_flags & VM_RESERVED)
> +		return 0;
>  
>  	/* By default, dump shared memory if mapped from an anonymous file. */
>  	if (vma->vm_flags & VM_SHARED) {
> Index: linux-2.6.26-rc5-mm3/include/linux/sched.h
> ===================================================================
> --- linux-2.6.26-rc5-mm3.orig/include/linux/sched.h
> +++ linux-2.6.26-rc5-mm3/include/linux/sched.h
> @@ -403,8 +403,9 @@ extern int get_dumpable(struct mm_struct
>  #define MMF_DUMP_MAPPED_PRIVATE	4
>  #define MMF_DUMP_MAPPED_SHARED	5
>  #define MMF_DUMP_ELF_HEADERS	6
> +#define MMF_DUMP_MMIO		7
>  #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
> -#define MMF_DUMP_FILTER_BITS	5
> +#define MMF_DUMP_FILTER_BITS	6
>  #define MMF_DUMP_FILTER_MASK \
>  	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
>  #define MMF_DUMP_FILTER_DEFAULT \
> 
> 
> 
> Regards,

Thanks for your patch, but it will not help here. Before applying it blindly
I asked myself if the mmapped region was tagged VM_IO, because it is actually
a simple ram zone, not an I/O zone, and the answer is it is not a VM_IO zone.
Details :

drivers/ieee1394/video1394.c:
    static int video1394_mmap(struct file *file, struct vm_area_struct *vma)
    {
    [...]
    return dma_region_mmap(&ctx->current_ctx->dma, file, vma);
    }

drivers/ieee1394/dma.c:
    int dma_region_mmap(struct dma_region *dma, struct file *file,
			struct vm_area_struct *vma)
    {
    [...]
    vma->vm_ops = &dma_region_vm_ops;
    vma->vm_private_data = dma;
    vma->vm_file = file;
    vma->vm_flags |= VM_RESERVED;

    return 0;
    }

So, actually the zone I would like to get dumped in the core file is tagged
VM_RESERVED.

I see the following ways to solve my problem :
    - do not tag the zone as VM_RESERVED in ieee1394::dma_region_mmap
    - tag the zone as VM_ALWAYSDUMP in ieee1394::dma_region_mmap
    - add a bit in coredump_filter to dump the VM_RESERVED zones.

As I don't know the real meaning of VM_RESERVED, I do not know which choice
is the best one for the official kernel tree, but locally I'll go for
adding VM_ALWAYSDUMP in ieee1394::dma_region_mmap.

Philippe
