Return-Path: <linux-kernel-owner+w=401wt.eu-S1762028AbZAOAV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762028AbZAOAV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbZAOAVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:21:45 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:2409 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102AbZAOAVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:21:44 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=xGaRqZLFcBn2p9D80oQA:9 a=lO0OHRiouRUFJoXzd4YA:7 a=O7sLJ6TtepeSOyOM6BgT3yGrO0MA:4 a=_RhRFcbxBZMA:10
Message-ID: <496E8193.9070603@shaw.ca>
Date: Wed, 14 Jan 2009 18:21:39 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Christian Eggers <ceggers@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Buffer allocation for USB transfers
References: <496E43F4.24792.158F9B@ceggers.gmx.de>
In-Reply-To: <496E43F4.24792.158F9B@ceggers.gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Eggers wrote:
> In different drivers I've found several methods for allocating buffers 
> transfered with usb_control_msg() or usb_submit_urb():
> 
> - usb_stor_msg_common() in "drivers/usb/storage/transport.c" uses buffers 
> allocated with usb_buffer_alloc(). These buffers are used with 
> URB_NO_xxx_DMA_MAP in urb->transfer_flags.
> 
> - asix_read_cmd() in "drivers/net/usb/asix.c" uses kmalloc(GFP_KERNEL).
> 
> - mcs7830_get_reg() in "drivers/net/usb/mcs7830.c" uses buffers from 
> the stack.
> 
> At least the latter does not work on my SH-4 platform. It seems that other 
> variables on the stack are overwritten after calling usb_control_msg(), probably as 
> result of incorrect alignment.

Indeed, DMA to/from the stack is not allowed (on some platforms it may 
invalidate other data in the same cache line, etc. which is likely what 
you are seeing). Assuming that the USB core is DMAing directly to/from 
that memory, it's a bug in that mcs7830 driver.

> 
> For some reason the second example (kmalloc()) doesn't seem to cause problems (on 
> my platform) but is there are guarantee that kmalloc() 
> without GFP_DMA does always return a DMA capable buffer?

Yes, as long as the DMA mapping API is used properly to map the buffer 
(which I'm assuming it is, not being a USB core expert.) GFP_DMA is not 
intended for this, drivers should not be using that flag, unless maybe 
they are doing ISA transfers which is not the case with USB.

> 
> Shall all buffers used for usb_control_msg() and usb_submit_urb() be 
> allocated with usb_buffer_alloc()? It seems that usb_control_msg() doesn't 
> offer a way to set the URB_NO_xxx_DMA_MAP in urb->transfer_flags so that 
> usb_buffer_alloc() can not be used here???
> 
> regards
> Christian Eggers
> 
> Please CC to ceggers@gmx.de
> 

