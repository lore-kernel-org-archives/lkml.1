Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYLIAFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYLIAFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 19:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYLIAEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 19:04:51 -0500
Received: from gw.goop.org ([64.81.55.164]:37914 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbYLIAEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 19:04:50 -0500
Message-ID: <493DB61F.70403@goop.org>
Date: Mon, 08 Dec 2008 16:04:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>,
       Ian Jackson <Ian.Jackson@eu.citrix.com>
Subject: Re: Oops in UHCI when encountering "host controller process error"
References: <Pine.LNX.4.44L0.0810211601340.2353-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0810211601340.2353-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 16 Oct 2008, Jeremy Fitzhardinge wrote:
>
>   
>> Looks like this is the relevent detail: "uhci->skelqh[1]->node.next is 
>> NULL" for all the queues.  Haven't looked into it yet.
>>     
>
> Any news?

The problem went away for a while, but then came back.  I still have no 
idea why, but I'm back to debugging it.

The most strange thing I'm seeing is this:

uhci_hcd 0000:00:1d.0: irq 29, io base 0x0000bce0
uhci_alloc_td uhci ffff88002e1a3d58 td ffff88002e105000 dma_handle 4ce2f000
uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e106000 handle=4ce36000
uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e106080 handle=4ce36080
uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e106000 handle=4ce36000
uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e106001 handle=4ce36001 <<<
uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e107000 handle=7e546000
uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e107080 handle=7e546080
uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e107000 handle=7e546000
uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e107001 handle=7e546001 <<<
uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e108000 handle=7e22d000
uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e108080 handle=7e22d080
uhci_alloc_qh: uhci=ffff88002e1a3d58 qh=ffff88002e108000 handle=7e22d000
usb usb1: configuration #1 chosen from 1 choice
uhci_hcd 0000:00:1d.0: host controller process error, something bad happened!
uhci_hcd 0000:00:1d.0: host controller halted, very bad!
general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC


For some reason dma_pool_alloc() is returning unaligned, overlapping 
memory chunks.  That that point everything else is no surprise...

So I'm trying to figure out how the dma pool stuff is malfunctioning, 
and whether anything we've done is causing it.

    J
