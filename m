Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYJPXex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYJPXex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYJPXen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:34:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1430 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752113AbYJPXem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:34:42 -0400
Date: Thu, 16 Oct 2008 19:34:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: Re: Oops in UHCI when encountering "host controller process error"
In-Reply-To: <48F7B9E0.90407@goop.org>
Message-ID: <Pine.LNX.4.44L0.0810161921460.31660-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Jeremy Fitzhardinge wrote:

> Alan Stern wrote:
> > uhci-hcd uses dma_allocate_coherent() and dma_pool_create() with 
> > dma_pool_alloc().  If either of these returned an area of memory that 
> > crossed a physical page boundary then there might be trouble -- but 
> > there probably would already be trouble in non-virtualized systems too!
> >   
> 
> Hm, that should be OK then.  No chance something is simply using __pa() 
> on an address rather than using the proper dma address?

No, no chance.

> >> The RIP corresponds to:
> >> 0xffffffff803acb56 is in uhci_scan_schedule 
> >> (/home/jeremy/hg/xen/paravirt/linux/drivers/usb/host/uhci-q.c:1740).
> >>
> >> 1740                uhci->next_qh = list_entry(qh->node.next,
> >> 1741                        struct uhci_qh, node);
> >>     
> >
> > Does this mean that qh is NULL?  I don't have a 64-bit system so I 
> > can't tell just where in the instruction stream the fault occurred.  
> > Maybe you can add one or two debugging printks in there to figure out 
> > exactly what's going wrong.
> >   
> 
> Yes, it must be qh which is NULL.  uhci is the only other dereference 
> there, and must be non-NULL to get to that point.

And at that point qh must be equal to uhci->next_qh.  There are only 
about five places where uhci->next_qh is assigned to; you could test 
each of them for NULL.

> OK, with uhci-hcd.debug=2 on the kernel command line I still get an 
> oops, but in a different function.  I guess the qh list is corrupt 
> either way?

It sure looks that way.

> uhci_hcd 0000:00:1d.0: host controller process error, something bad happened!
> usb usb2: default language 0x0409
> uhci_hcd 0000:00:1d.0: host controller halted, very bad!
> BUG: unable to handle kernel NULL pointer dereference<7>usb usb2: uevent
>  at 0000000000000020
> IP: [<ffffffff803b0d29>] uhci_show_qh+0x228/0x59d

I guess you also better add code to uhci_sprint_schedule() in 
uhci-debug.c to check each assignment to qh (there are only two) for 
NULL, and jump directly to the next iteration of the "for i" loop when 
you see it.

Maybe make this change first, since it will be easier and it might give 
a good idea of where to look in uhci-q.c.

By the way, would there be any problem caused by the fact that the 
hardware can only use 32-bit DMA addresses?

Alan Stern

