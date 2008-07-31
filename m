Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbYGaSne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbYGaSne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYGaSnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:43:19 -0400
Received: from smtp.net4india.com ([202.71.148.84]:59977 "EHLO
	smtp.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbYGaSnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:43:18 -0400
Subject: Re: PCIe device driver question
From: "V.Radhakrishnan" <rk@atr-labs.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Sanka Piyaratna <cesanka@yahoo.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4891F847.7030100@shaw.ca>
References: <fa.PmBLCqOb4Xo53y3W9hAdnsU50Og@ifi.uio.no>
	 <fa.42mxuHHJP7XQmYeyxNoEC/NFUHA@ifi.uio.no> <4890BF39.6060608@shaw.ca>
	 <1217509868.2156.18.camel@atlas>  <4891F847.7030100@shaw.ca>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 00:17:26 +0530
Message-Id: <1217530046.7668.29.camel@atlas>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> My guess there was a bug in your DMA mapping code. I don't think kmap is 
> what is normally used for this. I think with get_user_pages one usually 
> takes the returned page pointers to create an SG list and uses 
> dma_map_sg to create a DMA mapping for them.

Looking at the actual code, I see that I had used kmap() only to obtain
kernel virtual addresses for the array of struct pages obtained from
user space by using get_user_pages.

Subsequently, I had used dma_map_single() and dma_unmap_single() calls
for single buffer calls.

The code didn't have bugs IMHO since it was used for extensive stress
testing the initial FPGA prototype as well as the final ASIC chip ,
sometimes running for over 4 days non-stop without breaking.

However, using Test Access Points on the board and using a Logic
Analyzer showed that DMA was NOT taking place when RAM > 896 MB was
used. The hardware gurus said that PCI bus cycles just didn't seem to be
taking place when RAM > 896 MB was used as the source OR destination
address.

Perhaps this was a problem in the earlier kernel(s) and has since been
rectified ? ( I was using 2.6.15 then ... )

I am just curious since Sanka Piyaratna reported a 'similar' kind of
situation.

Regards

V. Radhakrishnan



On Thu, 2008-07-31 at 11:37 -0600, Robert Hancock wrote:
> V.Radhakrishnan wrote:
> > Hi Robert,
> > 
> > Thanks for the reply. I was thinking that the MMIO and reserve memory
> > will be below 4 GB was only applicable for 32-bit environments, since I
> > don't have much experience in 64-bit.
> > 
> > However, I had an IDENTICAL problem over 2 years ago. I had used
> > posix_memalign() in user space to allocate pages aligned to 4096 byte
> > pages, allocated several additional memaligned pages in user space, used
> > mlock() to lock all these pages, gathered the user space addresses into
> > the original pages as arrays of structures, passed this array into the
> > kernel using an ioctl() call, used get_user_pages() to extract the
> > struct page pointers, performed a kmap() to get the kernel virtual
> > addresses and then extracted the physical addresses and 'sent' this to
> > the chip to perform DMA.
> > 
> > This situation is almost identical to what has been reported and hence
> > my interest.
> > 
> > However, I had a PCI access problem. The DMA was just NOT happening on
> > any machine which had highmem, i.e over 896 MB.
> 
> My guess there was a bug in your DMA mapping code. I don't think kmap is 
> what is normally used for this. I think with get_user_pages one usually 
> takes the returned page pointers to create an SG list and uses 
> dma_map_sg to create a DMA mapping for them.
> 
> > 
> > I "solved" the problem since I didn't have much time to do R&D, by
> > booting with kernel command line option of mem=512M and the DMA went
> > thru successfully.
> > 
> > This was the linux-2.6.15 kernel then. Since the project was basically
> > to test the DMA capability of the device, the actual address to where it
> > was DMA-ed didn't matter, and I got paid for my work. However, this
> > matter was always at the back of my head.
> > 
> > What could have been the problem with the x86 32-bit PCI ? 
> > 
> > Thanks and regards
> > 
> > V. Radhakrishnan
> > www.atr-labs.com
> > 
> > On Wed, 2008-07-30 at 13:21 -0600, Robert Hancock wrote:
> >> V.Radhakrishnan wrote:
> >>>>> am testing this in an X86_64 architecture machine with 4 GB of RAM. I
> >>>>> am able to successfully dma data into any memory (dma) address >
> >>>>> 0x0000_0001_0000_0000.
> >>> How can you DMA "successfully" into this address which is > 4 GB when
> >>> you have only 4 GB RAM ? Or am I missing something ?
> >> The MMIO and other reserved memory space at the top of the 32-bit memory 
> >> space will cause the top part of memory to be relocated above 4GB.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

