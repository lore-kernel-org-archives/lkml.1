Return-Path: <linux-kernel-owner+w=401wt.eu-S1031070AbXEDQKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031070AbXEDQKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031075AbXEDQKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:10:00 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:18189 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031070AbXEDQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:09:59 -0400
X-IronPort-AV: i="4.14,492,1170651600"; 
   d="scan'208"; a="29070854:sNHT24574585"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg Ungerer" <gerg@snapgear.com>
Subject: Re: [PATCH]: linux-2.6.21-uc0 (MMU-less updates)
Date: Fri, 4 May 2007 12:12:03 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "David Howells" <dhowells@redhat.com>,
       "Paul Mundt" <lethal@linux-sh.org>
References: <46382055.8030203@snapgear.com> <200705030735.36879.rgetz@blackfin.uclinux.org> <4639E40D.6030809@snapgear.com>
In-Reply-To: <4639E40D.6030809@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705041212.03614.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 04 May 2007 16:09:49.0021 (UTC) FILETIME=[A3DB38D0:01C78E66]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 3 May 2007 09:30, Greg Ungerer pondered:
> Robin Getz wrote:
> > On Thu 3 May 2007 07:03, Greg Ungerer pondered:
> >> Robin Getz wrote:
> >>> On Wed 2 May 2007 07:32, Greg Ungerer pondered:
> >>>> Robin Getz wrote:
> >>>>> I was trying to understand why we don't want to do the same checking
> >>>>> on noMMU?
> >>>>
> >>>> The problem is on systems that have RAM mapped at high physical
> >>>> addresses. TASK_SIZE may well be a numerically smaller number
> >>>> than the address range that RAM sits in. So this test fails when
> >>>> it shouldn't.

Put the patch back, since I added some new cc'

 > diff -Naur linux-2.6.21/fs/namei.c linux-2.6.21-uc0/fs/namei.c
 > --- linux-2.6.21/fs/namei.c     2007-05-01 17:12:53.000000000 +1000
 > +++ linux-2.6.21-uc0/fs/namei.c 2007-05-01 17:16:18.000000000 +1000
 > @@ -120,12 +120,14 @@
 >         int retval;
 >         unsigned long len = PATH_MAX;
 >
 > +#ifdef CONFIG_MMU
 >         if (!segment_eq(get_fs(), KERNEL_DS)) {
 >                 if ((unsigned long) filename >= TASK_SIZE)
 >                         return -EFAULT;
 >                 if (TASK_SIZE - (unsigned long) filename < PATH_MAX)
 >                         len = TASK_SIZE - (unsigned long) filename;
 >         }
 > +#endif
 >
 >         retval = strncpy_from_user(page, filename, len);
 >         if (retval > 0) {


> >>>
> >>> So, then this is a problem only on one or two architectures, not all
> >>> noMMU platforms?
> >>
> >> Its not an architecture problem. It can effect any board that
> >> has RAM mapped at a large numerical addresses (larger than TASK_SIZE).
> >> So it can effect any non-MMU platform.
> >
> > Depending on how TASK_SIZE is defined - it looks like everyone else
> > forces it to end of memory, except 68k[nommu].
> >
> > asm-arm/memory.h:#define TASK_SIZE              (CONFIG_DRAM_SIZE)
> > asm-blackfin/processor.h:#define TASK_SIZE      (memory_end)
> > asm-frv/mem-layout.h:#define TASK_SIZE                 
> > __UL(0xFFFFFFFFUL)
> >
> > asm-m68k/processor.h:#define TASK_SIZE  (0xF0000000UL)
> > asm-m68k/processor.h:#define TASK_SIZE  (0x0E000000)
> > asm-m68k/processor.h:#define TASK_SIZE  (0x0E000000UL)
> > asm-m68knommu/processor.h:#define TASK_SIZE     (0xF0000000UL)
>
> Probably too:
>
> asm-sh/processor.h:#define TASK_SIZE    0x7c000000UL
>
> which has some parts with MMU.
>
> There have been others out of tree that have it like this to.
>
> > I'm happy to learn we are doing something wrong, but I think that we just
> > copied the arm/frv setup.
>
> That is one way to handle it. Have you followed all the other
> uses of TASK_SIZE and verified it is not a problem?

No, I assumed that Russell/David were smarter than we were, and that doing so 
would not be a problem :)

Not looking at ./arch or ./include TASK_SIZE looks like it is only used in 

fs/hugetlbfs/inode.c
fs/binfmt_elf.c
fs/namespace.c
fs/binfmt_aout.c
fs/namei.c
kernel/kexec.c
mm/mremap.c
mm/mempolicy.c
mm/memory.c 
mm/nommu.c 
mm/mmap.c

I poked through some, and from first glance, it mostly looked OK with setting 
TASK_SIZE to CONFIG_DRAM_SIZE or memory_end.

-Robin
