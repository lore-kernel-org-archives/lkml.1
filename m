Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYLIBEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYLIBEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 20:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbYLIBEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 20:04:43 -0500
Received: from gw.goop.org ([64.81.55.164]:41512 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbYLIBEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 20:04:41 -0500
Message-ID: <493DC426.8010307@goop.org>
Date: Mon, 08 Dec 2008 17:04:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>,
       Ian Jackson <Ian.Jackson@eu.citrix.com>
Subject: Re: Oops in UHCI when encountering "host controller process error"
References: <Pine.LNX.4.44L0.0810211601340.2353-100000@iolanthe.rowland.org> <493DB61F.70403@goop.org>
In-Reply-To: <493DB61F.70403@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Alan Stern wrote:
>> On Thu, 16 Oct 2008, Jeremy Fitzhardinge wrote:
>>
>>  
>>> Looks like this is the relevent detail: "uhci->skelqh[1]->node.next 
>>> is NULL" for all the queues.  Haven't looked into it yet.
>>>     
>>
>> Any news?
>
> The problem went away for a while, but then came back.  I still have 
> no idea why, but I'm back to debugging it.
>
> The most strange thing I'm seeing is this:
>
> uhci_hcd 0000:00:1d.0: irq 29, io base 0x0000bce0
> uhci_alloc_td uhci ffff88002e1a3d58 td ffff88002e105000 dma_handle 
> 4ce2f000
> uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e106000 handle=4ce36000
> uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e106080 handle=4ce36080
> uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e106000 handle=4ce36000
> uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e106001 
> handle=4ce36001 <<<
> uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e107000 handle=7e546000
> uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e107080 handle=7e546080
> uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e107000 handle=7e546000
> uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e107001 
> handle=7e546001 <<<
> uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e108000 handle=7e22d000
> uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e108080 handle=7e22d080
> uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e108000 handle=7e22d000
> usb usb1: configuration #1 chosen from 1 choice
> uhci_hcd 0000:00:1d.0: host controller process error, something bad 
> happened!
> uhci_hcd 0000:00:1d.0: host controller halted, very bad!
> general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
>
>
> For some reason dma_pool_alloc() is returning unaligned, overlapping 
> memory chunks.  That that point everything else is no surprise...
>
> So I'm trying to figure out how the dma pool stuff is malfunctioning, 
> and whether anything we've done is causing it. 

On other runs the allocations turn out OK:

uhci_alloc_td: uhci ffff88002e631b08 td ffff88002e621000 dma_handle 4ce2f000
uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622000 handle=4ce36000
uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622080 handle=4ce36080
uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622100 handle=4ce36100
uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622180 handle=4ce36180
uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622200 handle=4ce36200
uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622280 handle=4ce36280
uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622300 handle=4ce36300
uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622380 handle=4ce36380
uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622400 handle=4ce36400
uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622000 handle=4ce36000
uhci_alloc_qh: uhci=ffff88002e631b08 qh=ffff88002e622000 handle=4ce36000


but the controller crashes and the structures seem to have been corrupted:

uhci_hcd 0000:00:1d.0: host controller process error, something bad happened!
uhci_hcd 0000:00:1d.0: host controller halted, very bad!
[lots of WARN_ONs I added about NULL qh->queue.nexts omitted ]
Root-hub state: running   FSBR: 0
HC status
  usbcmd    =     00c0   Maxp64 CF 
  usbstat   =     0020   HCHalted 
  usbint    =     000f
  usbfrnum  =   (0)000
  flbaseadd = 7dd2b000
  sof       =       40
  stat1     =     0080  
  stat2     =     0080  
Most recent frame: 0 (0)   Last ISO frame: 0 (0)
Periodic load table
        0       0       0       0       0       0       0       0
        0       0       0       0       0       0       0       0
        0       0       0       0       0       0       0       0
        0       0       0       0       0       0       0       0
Total: 0, #INT: 0, #ISO: 0
Frame List
Skeleton QHs
- skel_unlink_qh
    [ffff88002e622000] Skel QH link (4ce36002) element (00000000)
      Element is NULL (bug?)
      queue is empty
[ffff88002e621000] link (00000001) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=7f, PI
    last QH not linked to next skeleton!
- skel_iso_qh
    [ffff88002e622080] CTL QH link (00000000) element (00000000)
      Element is NULL (bug?)
qh->queue.next == NULL
    last QH not linked to next skeleton!
- skel_int128_qh
    [ffff88002e622100] CTL QH link (4ce36002) element (00000000)
      Element is NULL (bug?)
qh->queue.next == NULL
- skel_int64_qh
    [ffff88002e622180] CTL QH link (4ce36002) element (00000000)
      Element is NULL (bug?)
qh->queue.next == NULL
- skel_int32_qh
    [ffff88002e622200] CTL QH link (4ce36002) element (00000000)
      Element is NULL (bug?)
qh->queue.next == NULL
- skel_int16_qh
    [ffff88002e622280] CTL QH link (4ce36002) element (00000000)
      Element is NULL (bug?)
qh->queue.next == NULL
- skel_int8_qh
    [ffff88002e622300] CTL QH link (4ce36002) element (00000000)
      Element is NULL (bug?)
qh->queue.next == NULL
- skel_int4_qh
    [ffff88002e622380] Skel QH link (4ce36002) element (00000001)
      queue is empty
- skel_int2_qh
    [ffff88002e622400] Skel QH link (4ce36002) element (00000001)
      queue is empty
- skel_async_qh
    [ffff88002e622000] Skel QH link (4ce36002) element (00000000)
      Element is NULL (bug?)
      queue is empty
[ffff88002e621000] link (00000001) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=7f, PI
    last QH not linked to next skeleton!
- skel_term_qh
    [ffff88002e622000] Skel QH link (4ce36002) element (00000000)
      Element is NULL (bug?)
      queue is empty
[ffff88002e621000] link (00000001) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=7f, PI


Any clues about what this means?  Also, where's the best place to dump 
all the structures before kicking off the hardware to make sure they're 
correct from the outset?

Thanks,
    J
