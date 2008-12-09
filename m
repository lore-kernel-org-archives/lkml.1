Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbYLICNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbYLICNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 21:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYLICNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 21:13:35 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2143 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750922AbYLICNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 21:13:34 -0500
Date: Mon, 8 Dec 2008 21:13:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>,
       Ian Jackson <Ian.Jackson@eu.citrix.com>
Subject: Re: Oops in UHCI when encountering "host controller process error"
In-Reply-To: <493DC426.8010307@goop.org>
Message-ID: <Pine.LNX.4.44L0.0812082105170.30007-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008, Jeremy Fitzhardinge wrote:

> Jeremy Fitzhardinge wrote:
> > Alan Stern wrote:
> >> On Thu, 16 Oct 2008, Jeremy Fitzhardinge wrote:
> >>
> >>  
> >>> Looks like this is the relevent detail: "uhci->skelqh[1]->node.next 
> >>> is NULL" for all the queues.  Haven't looked into it yet.
> >>>     
> >>
> >> Any news?
> >
> > The problem went away for a while, but then came back.  I still have 
> > no idea why, but I'm back to debugging it.
> >
> > The most strange thing I'm seeing is this:
> >
> > uhci_hcd 0000:00:1d.0: irq 29, io base 0x0000bce0
> > uhci_alloc_td uhci ffff88002e1a3d58 td ffff88002e105000 dma_handle 
> > 4ce2f000
> > uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e106000 handle=4ce36000
> > uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e106080 handle=4ce36080
> > uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e106000 handle=4ce36000
> > uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e106001 
> > handle=4ce36001 <<<
> > uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e107000 handle=7e546000
> > uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e107080 handle=7e546080
> > uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e107000 handle=7e546000
> > uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e107001 
> > handle=7e546001 <<<
> > uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e108000 handle=7e22d000
> > uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e108080 handle=7e22d080
> > uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e108000 handle=7e22d000
> > usb usb1: configuration #1 chosen from 1 choice
> > uhci_hcd 0000:00:1d.0: host controller process error, something bad 
> > happened!
> > uhci_hcd 0000:00:1d.0: host controller halted, very bad!
> > general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> >
> >
> > For some reason dma_pool_alloc() is returning unaligned, overlapping 
> > memory chunks.  That that point everything else is no surprise...

Truly weird.

> > So I'm trying to figure out how the dma pool stuff is malfunctioning, 
> > and whether anything we've done is causing it. 
> 
> On other runs the allocations turn out OK:
> 
> uhci_alloc_td: uhci ffff88002e631b08 td ffff88002e621000 dma_handle 4ce2f000
> uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622000 handle=4ce36000
> uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622080 handle=4ce36080
> uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622100 handle=4ce36100
> uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622180 handle=4ce36180
> uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622200 handle=4ce36200
> uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622280 handle=4ce36280
> uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622300 handle=4ce36300
> uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622380 handle=4ce36380
> uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622400 handle=4ce36400
> uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622000 handle=4ce36000
> uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622000 handle=4ce36000

The last two are the same, and they are the same as the second one.  
Does that mean you're getting duplicated allocations?

> but the controller crashes and the structures seem to have been corrupted:
> 
> uhci_hcd 0000:00:1d.0: host controller process error, something bad happened!
> uhci_hcd 0000:00:1d.0: host controller halted, very bad!
> [lots of WARN_ONs I added about NULL qh->queue.nexts omitted ]
> Root-hub state: running   FSBR: 0
> HC status
>   usbcmd    =     00c0   Maxp64 CF 
>   usbstat   =     0020   HCHalted 
>   usbint    =     000f
>   usbfrnum  =   (0)000
>   flbaseadd = 7dd2b000
>   sof       =       40
>   stat1     =     0080  
>   stat2     =     0080  
> Most recent frame: 0 (0)   Last ISO frame: 0 (0)
> Periodic load table
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
> Total: 0, #INT: 0, #ISO: 0
> Frame List
> Skeleton QHs
> - skel_unlink_qh
>     [ffff88002e622000] Skel QH link (4ce36002) element (00000000)
>       Element is NULL (bug?)
>       queue is empty
> [ffff88002e621000] link (00000001) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=7f, PI
>     last QH not linked to next skeleton!
> - skel_iso_qh
>     [ffff88002e622080] CTL QH link (00000000) element (00000000)
>       Element is NULL (bug?)
> qh->queue.next == NULL
>     last QH not linked to next skeleton!
> - skel_int128_qh
>     [ffff88002e622100] CTL QH link (4ce36002) element (00000000)
>       Element is NULL (bug?)
> qh->queue.next == NULL
> - skel_int64_qh
>     [ffff88002e622180] CTL QH link (4ce36002) element (00000000)
>       Element is NULL (bug?)
> qh->queue.next == NULL
> - skel_int32_qh
>     [ffff88002e622200] CTL QH link (4ce36002) element (00000000)
>       Element is NULL (bug?)
> qh->queue.next == NULL
> - skel_int16_qh
>     [ffff88002e622280] CTL QH link (4ce36002) element (00000000)
>       Element is NULL (bug?)
> qh->queue.next == NULL
> - skel_int8_qh
>     [ffff88002e622300] CTL QH link (4ce36002) element (00000000)
>       Element is NULL (bug?)
> qh->queue.next == NULL
> - skel_int4_qh
>     [ffff88002e622380] Skel QH link (4ce36002) element (00000001)
>       queue is empty
> - skel_int2_qh
>     [ffff88002e622400] Skel QH link (4ce36002) element (00000001)
>       queue is empty
> - skel_async_qh
>     [ffff88002e622000] Skel QH link (4ce36002) element (00000000)
>       Element is NULL (bug?)
>       queue is empty
> [ffff88002e621000] link (00000001) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=7f, PI
>     last QH not linked to next skeleton!
> - skel_term_qh
>     [ffff88002e622000] Skel QH link (4ce36002) element (00000000)
>       Element is NULL (bug?)
>       queue is empty
> [ffff88002e621000] link (00000001) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=7f, PI

skel_term_qh is definitely _not_ supposed to be equal to skel_async_qh 
or to skel_unlink_qh.  The allocation is still messed up.

> Any clues about what this means?  Also, where's the best place to dump 
> all the structures before kicking off the hardware to make sure they're 
> correct from the outset?

The hardware starts running right at the end of uhci_start(), in the
call to start_rh().  However according to those debugging lines you
added to uhci_alloc_qh(), the DMA pool allocations are all messed up.  
Those initial allocations all occur within uhci_start(), in the

	for (i = 0; i < UHCI_NUM_SKELQH; ++i)

loop.  It sure looks like the DMA pool memory management needs 
attention.

Alan Stern

