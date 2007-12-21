Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbXLUEqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbXLUEqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 23:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbXLUEqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 23:46:09 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:53998 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbXLUEqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 23:46:07 -0500
Date: Fri, 21 Dec 2007 10:15:08 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, htejun@gmail.com,
       gregkh@suse.de, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
Message-ID: <20071221044508.GA11996@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071214095023.b5327703.akpm@linux-foundation.org> <20071214182802.GC2576@linux.vnet.ibm.com> <20071214150533.aa30efd4.akpm@linux-foundation.org> <20071215035200.GA22082@linux.vnet.ibm.com> <20071214220030.325f82b8.akpm@linux-foundation.org> <20071215104434.GA26325@linux.vnet.ibm.com> <20071217045904.GB31386@linux.vnet.ibm.com> <Pine.LNX.4.64.0712171143280.12871@schroedinger.engr.sgi.com> <20071217120720.e078194b.akpm@linux-foundation.org> <Pine.LNX.4.64.0712171222470.29500@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712171222470.29500@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It was just
> > 
> > 	while echo ; do cat /sys/kernel/<some file> ; done
> > 
> > it's all in the email threads somewhere..
> 
> The patch that was posted in the thread that I mentioned earlier is here. 
> I ran the test for 15 minutes and things are still fine.
> 
> 
> 
> quicklist: Set tlb->need_flush if pages are remaining in quicklist 0
> 
> This ensures that the quicklists are drained. Otherwise draining may only 
> occur when the processor reaches an idle state.
> 

Hi Christoph,

No, it does not stop the oom I am seeing here.

Thanks,

> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> Index: linux-2.6/include/asm-generic/tlb.h
> ===================================================================
> --- linux-2.6.orig/include/asm-generic/tlb.h	2007-12-13 14:45:38.000000000 -0800
> +++ linux-2.6/include/asm-generic/tlb.h	2007-12-13 14:51:07.000000000 -0800
> @@ -14,6 +14,7 @@
>  #define _ASM_GENERIC__TLB_H
> 
>  #include <linux/swap.h>
> +#include <linux/quicklist.h>
>  #include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
> 
> @@ -85,6 +86,9 @@ tlb_flush_mmu(struct mmu_gather *tlb, un
>  static inline void
>  tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
>  {
> +#ifdef CONFIG_QUICKLIST
> +	tlb->need_flush += &__get_cpu_var(quicklist)[0].nr_pages != 0;
> +#endif
>  	tlb_flush_mmu(tlb, start, end);
> 
>  	/* keep the page table cache within bounds */

-- 
regards,
Dhaval
