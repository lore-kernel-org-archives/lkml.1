Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYIWP7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYIWP7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYIWP7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:59:39 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:54867 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYIWP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:59:38 -0400
Date: Tue, 23 Sep 2008 08:59:36 -0700
From: Ira Snyder <iws@ovro.caltech.edu>
To: Timur Tabi <timur@freescale.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, leoli@freescale.com, zw@zh-kernel.org,
       Kumar Gala <kumar.gala@freescale.com>
Subject: Re: Problems with Freescale DMA driver
Message-ID: <20080923155935.GA7449@ovro.caltech.edu>
References: <20080825165133.GA20446@ovro.caltech.edu> <e9c3a7c20809181458p4cabccblfde6a92bf35976ee@mail.gmail.com> <48D2D00B.3010001@freescale.com> <20080922230435.GA20825@ovro.caltech.edu> <48D8F73A.4050004@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D8F73A.4050004@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 23 Sep 2008 08:59:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 09:03:38AM -0500, Timur Tabi wrote:
> Ira Snyder wrote:
> 
> > When your patch makes it in, you should probably add the cell-index to
> > all of the dts files that are missing them.
> 
> Ah, I see that Kumar added a bunch of DMA nodes back in June and forgot the
> cell-index properties.
> 
> > I was not able to cause the DMA controller to copy bad data. Perhaps the
> > kernel just had a bug at the time. It was still relatively early on in
> > the development cycle.
> 
> dmatest runs all the time, so it's possible that it's eating up DMA resources.
> Try running your tests without CONFIG_DMATEST.
> 

I am unable to cause any problems without dmatest running. You are
probably correct, it is just using lots of resources.

> > In a related note, I've been somewhat following the discussion on LKML
> > about creating an API for requesting a single DMA channel. This would be
> > great in a driver I've written for PCI communication over a backplane.
> > (I have a test board running in PCI Agent mode. It creates a virtual
> > ethernet interface that passes data over the PCI bus.)
> 
> PCI devices should not be using generic DMA resources, so I don't see how this
> would apply.
> 

Let me try to explain what I'm doing. If you have any ideas of a better
way to do this, I'm completely open to suggestions.

I have the following:
1) A normal x86 desktop computer, running Linux
2) An MPC8349EMDS eval board, running in PCI agent/slave mode. It is
   plugged into a PCI slot in the desktop. It also runs Linux.

Naturally, I want to transfer lots of data between them. They are
already connected by the PCI bus, so transferring data across that seems
logical. Using the network infrastructure in the kernel seemed like a
good solution, since it handles multiplexing/demultiplexing of traffic
nicely. I chose to use an ethernet device because there is some
documentation for them in LDD3.

So I wrote a device driver for both computers which creates an ethernet
interface. The actual data transfer must happen over the PCI bus, which
just shows up as memory in the MPC8349's address space.

Since using the CPU to do data transfer is very slow, I need to use the
DMA controller to transfer the data. I used the DMAEngine API because it
existed, and so I didn't have to program the DMA controller registers
manually. The MPC8349 handles all of the data transfer using its DMA
controller.

I hope that makes sense. I can post the code if anyone would like to see
it. It is not ready for mainline inclusion yet, but it is in a fairly
good state.

> > Also, are there any plans to support the external start feature on the
> > 83XX parts? (According to my datasheet, it is supported.) I will be
> > using this feature in a driver I will be starting fairly soon.
> 
> External start is very device-specific, so I don't see how a generic DMA driver,
> which is intended only for memory-to-memory DMA operations, can coordinate with
> an external master.
> 

Ok. I was just wondering, since drivers/dma/fsl_dma.c has some code that
appears to handle external master. It is 85XX specific though. There are
no users in the kernel tree showing example uses.

I will be using it in the same setup as above. The board I am working on
is based on the MPC8349EMDS board, but with 5 FPGA's on it for data
processing. The FPGA's will do some calculations, then use the external
start to trigger a DMA to copy the data from the FPGA memory to the
MPC8349's DDR, where it is buffered up for later processing.

Sorry if this has gone off topic.

Thanks,
Ira
