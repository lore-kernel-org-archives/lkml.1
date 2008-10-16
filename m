Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbYJPODp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbYJPODp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYJPODg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:03:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41221 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751425AbYJPODf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:03:35 -0400
Date: Thu, 16 Oct 2008 10:03:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: Re: Oops in UHCI when encountering "host controller process error"
In-Reply-To: <48F67FF5.8010501@goop.org>
Message-ID: <Pine.LNX.4.44L0.0810160949100.2487-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Jeremy Fitzhardinge wrote:

> I'm trying to get UHCI working in a Xen dom0.  This is essentially akin 
> to making it work with an iommu, as physical memory pages are not 
> contiguous, and their kernel-visible addresses are not directly usable 
> as DMA addresses.  I'm not too surprised that I'm seeing driver errors 
> (though e1000 and mpt fusion work fine), so the fact that I'm getting 
> this error probably isn't a reflection on  the UHCI driver.

uhci-hcd uses dma_allocate_coherent() and dma_pool_create() with 
dma_pool_alloc().  If either of these returned an area of memory that 
crossed a physical page boundary then there might be trouble -- but 
there probably would already be trouble in non-virtualized systems too!

> The problem I'm seeing is this:
> 
> xen_create_contiguous_region: vstart=ffff880073ff0000 order=0 addr_bits=20
> uhci_hcd 0000:00:1d.0:  -> ret ffff880073ff0000 dma 79b6c000
> uhci_hcd 0000:00:1d.0: host controller process error, something bad happened!
> uhci_hcd 0000:00:1d.0: host controller halted, very bad!
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff803acb56>] uhci_scan_schedule+0xa8/0x85f
> PGD 0 
> Thread overran stack, or stack corrupted

That last line sounds bad in and of itself.

> Call Trace:
>  <IRQ> <0> [<ffffffff80243df5>] ? __mod_timer+0xb8/0xca
>  [<ffffffff803253c3>] ? __const_udelay+0x44/0x46
>  [<ffffffff80328d89>] ? _raw_spin_lock+0x68/0x10b
>  [<ffffffff803aef89>] uhci_irq+0x13f/0x158
>  [<ffffffff8039744a>] usb_hcd_irq+0x42/0x90

> I'm not too surprised its getting hardware errors, and I wouldn't assume 
> its a USB-level bug at this point (though if its misusing the DMA API, 
> it could be a driver bug; I think I saw an iommu-related bug go past, 
> which could be a clue).
> 
> But the crash as a result of the "host controller process error" does 
> look like a UHCI driver bug.

Yes; it shouldn't happen.

> The RIP corresponds to:
> 0xffffffff803acb56 is in uhci_scan_schedule 
> (/home/jeremy/hg/xen/paravirt/linux/drivers/usb/host/uhci-q.c:1740).
> 
> 1740                uhci->next_qh = list_entry(qh->node.next,
> 1741                        struct uhci_qh, node);

Does this mean that qh is NULL?  I don't have a 64-bit system so I 
can't tell just where in the instruction stream the fault occurred.  
Maybe you can add one or two debugging printks in there to figure out 
exactly what's going wrong.

> If you have any hints as to what's causing the host controller process 
> error and how I might go about debugging it, that would be very useful.

You should start by loading uhci-hcd with the debug=2 parameter setting
(you'll have to enable CONFIG_USB_DEBUG).  Then when an HC process
error occurs, the driver will dump its internal data structures to the 
system log.

Alan Stern

