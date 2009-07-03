Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbZGCUsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbZGCUsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 16:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbZGCUso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 16:48:44 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:43737 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbZGCUsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 16:48:43 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
Date: Fri, 3 Jul 2009 15:48:39 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200907031314.36243.lkml@morethan.org> <86802c440907031307s43fca3c0j77d4df78450ff757@mail.gmail.com> <86802c440907031308j3f996db6g9dfb1b8f9ccb7e7f@mail.gmail.com>
In-Reply-To: <86802c440907031308j3f996db6g9dfb1b8f9ccb7e7f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907031548.42690.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri July 3 2009, Yinghai Lu wrote:
> On Fri, Jul 3, 2009 at 1:07 PM, Yinghai Lu<yhlu.kernel@gmail.com> wrote:
> > On Fri, Jul 3, 2009 at 11:14 AM, Michael S. Zick<lkml@morethan.org> wrote:
> >> Here is one I have found useful in my VIA processor bug hunting:
> >>
> >> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> >> index 3068388..2303d86 100644
> >> --- a/arch/x86/kernel/head_32.S
> >> +++ b/arch/x86/kernel/head_32.S
> >> @@ -61,7 +61,7 @@
> >>
> >>  /* Enough space to fit pagetables for the low memory linear map */
> >>  MAPPING_BEYOND_END = \
> >> -       PAGE_TABLE_SIZE(((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
> >> +       PAGE_TABLE_SIZE((1<<20) - (__PAGE_OFFSET >> PAGE_SHIFT)) << PAGE_SHIFT
> >>
> >>  /*
> >>  * Worst-case size of the kernel mapping we need to make:
> >>
> >> = = =
> >>
> >> Before:
> >>
> >>  #5 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
> >>  #6 [0000011000 - 0000015000]          BOOTMAP ==> [0000011000 - 0000015000]
> >>
> >> After:
> >>
> >>  #5 [0000010000 - 000007d000]          PGTABLE ==> [0000010000 - 000007d000]
> >>  #6 [000007d000 - 0000081000]          BOOTMAP ==> [000007d000 - 0000081000]
> >>
> >
> > that PGTABLE is from early resource. and it is filled by init_memory_mapping()
> >
> > it mean preallocated pgtable to MAPPING_BEYOND_END is small now after
> > patch. and init_memory_mapping try to get more.
> >
> > please send out whole dmesg. with and without your patch. it could
> > print out initial mapped before e820 allocation is involved for 32bit
> >        printk(KERN_DEBUG "initial memory mapped : 0 - %08lx\n",
> >                        max_pfn_mapped<<PAGE_SHIFT);
> >
> >
> > your patch should be right. except to change that 12 to PAGE_SHIFT
> >
> mean
>

Yes, want to get the 8K page machines correct also.

> 
> >>  /* Enough space to fit pagetables for the low memory linear map */
> >>  MAPPING_BEYOND_END = \
> >> -       PAGE_TABLE_SIZE(((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
> >> +       PAGE_TABLE_SIZE((1<<(32 - PAGE_SHIFT)) - (__PAGE_OFFSET >> PAGE_SHIFT)) << PAGE_SHIFT
> 

You read my mind, thanks.

Mike
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


