Return-Path: <linux-kernel-owner+w=401wt.eu-S1763867AbXJOG3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763867AbXJOG3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 02:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbXJOG3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 02:29:31 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40729 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbXJOG3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 02:29:30 -0400
Date: Mon, 15 Oct 2007 11:59:20 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: chandru <chandru@in.ibm.com>, linux-kernel@vger.kernel.org,
       mark_salyzyn@adaptec.com, ak@suse.de
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables in kdump
Message-ID: <20071015062919.GA4598@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <1191962414.24134.68.camel@chandru> <20071009210623.GK4335@rhun.haifa.ibm.com> <20071010053057.GA24434@in.ibm.com> <20071014054110.GB4399@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071014054110.GB4399@rhun.haifa.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 07:41:10AM +0200, Muli Ben-Yehuda wrote:
> On Wed, Oct 10, 2007 at 11:00:58AM +0530, Vivek Goyal wrote:
> > On Tue, Oct 09, 2007 at 11:06:23PM +0200, Muli Ben-Yehuda wrote:
> > > Hi Chandru,
> > > 
> > > Thanks for the patch. Comments on the patch below, but first a general
> > > question for my education: the main problem here that aacraid
> > > continues DMA'ing when it shouldn't. Why can't we shut it down
> > > cleanly? Even without the presence of an IOMMU, it seems dangerous to
> > > let an adapter continue DMA'ing to and from memory when the kernel is
> > > an inconsistent state.
> > > 
> > 
> > Hi Muli,
> > 
> > After the kernel crash, we can't rely on the crashed kernel's data
> > structures or methods any more. We can't call the device shutdown
> > methods of all the device drivers as we might be invoking a driver
> > which actually might have caused the crash. Hence we don't perform
> > any device shutdown in the case of kdump. Instead after the crash,
> > we try to take the shortest route to second kernel (Execute minimum
> > code in crashed kernel).
> > 
> > Whatever special handling is required to bring up the second kernel on 
> > a potentially unknown state hardware, is taken in second kernel.
> 
> That makes sense, but does it really make more sense to set-up proper
> IOMMU translation tables for DMA's which have been triggered from the
> first kernel than to either quiesce the device ASAP (this means before
> enabling IOMMU translation...) or to trap such DMA's and continue,
> rather than letting them go through?
> 

Trapping DMA and ignoring will make sense. I don't know how it can be done.
Toggle write permissions in TCE table and handle it in exception handler?

> > We will not be too concerned about ongoing DMA's as long as there is no
> > corruption of tce tables. That would mean DMA is happening in first
> > kernel's memory buffer and second kernel is not impacted. But if TCE
> > tables themselves are corrupted, then it can potentially interfere with
> > second kernel's operation. Don't know how it can be addressed.
> 
> I worry about two cases: the first is TCE table corruption, the second
> is DMA's to areas which were fine in the first kernel but are wrong
> for the second kernel.
> 
> > > The patch below looks reasonable *if* that is the least worst way
> > > of doing it - let's see if we can come up with something cleaner
> > > that doesn't rely in the new kernel on data (which may or may not
> > > be corrupted...) from the old kernel.
> > 
> > I think the issue here is that some DMA was going on when first
> > kernel crashed. After the crash, second kernel booted and created
> > new TCE tables and switched to it. This resulted in ongoing DMA
> > failure and hardware raised an alarm.
> > 
> > In this case, probably it would make sense to re-use the TCE tables
> > of previous kernel (until and unless we have a way to tell hardware
> > not to flag a DMA error if TCE mapping is changed while DMA is going
> > on ?)
> 
> We don't have a way to do that, but we should be able to trap the DMA,
> figure out that we're in a kdump kernel, and then just ignore it and
> continue.
> 

What does ignoring DMA mean here? Acutual DMA does not take place but device
thinks DMA is complete? 

Trapping DMA and ignoring in kdump kernel (if possible), seems to be better
than letting DMA happen. This will reduce chances of corruption of second
kernel.  

Can you please give little more details in terms of how to trap DMA. I think
chandru should be able to write a patch for this.

> > I think, we also need to reserve some TCE table entries (in first
> > kernel), which can be used by second kernel for saving kernel core
> > file to disk. There might be a case where first kernel has used up
> > all TCE entries and second kernel can't allocate more. I think ppc64
> > has taken the approach of freeing some entries in second kernel but
> > that will have the problem as you might be clearing an entry which
> > is being used by ongoing DMA.
> 
> That's a good point - how do PPC (or other architectures with an
> isolation-capable IOMMU) handle this whole issue?
> 

Right now ppc64 just uses the TCE tables from first kernel and allows the 
older DMA's to finish. Then they free up some TCE table entries (2K) to 
make space for DMA entries from second kernel. 

Mohan, please corret me, if I am wrong.

Thanks
Vivek
