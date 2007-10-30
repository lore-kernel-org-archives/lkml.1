Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbXJ3X6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbXJ3X6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbXJ3X5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:57:54 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52957 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbXJ3X5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:57:53 -0400
Date: Tue, 30 Oct 2007 17:59:52 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv and dynamically changing DMA mask?
In-reply-to: <20071030100542.3efe01ee@the-village.bc.nu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>
Message-id: <4727C578.80900@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4726B064.3000906@shaw.ca>
 <20071030100542.3efe01ee@the-village.bc.nu>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, 29 Oct 2007 22:17:40 -0600
> Robert Hancock <hancockr@shaw.ca> wrote:
> 
>> In the sata_nv driver, when running in ADMA mode, we can do 64-bit DMA. 
>> However, when an ATAPI device like a DVD drive is connected, we can't 
>> use ADMA mode, and so we have to abide by the restrictions of a normal 
>> SFF ATA controller and can only do 32-bit DMA. We detect this and try to 
>> set the blk_queue_bounce_limit, blk_queue_segment_boundary and 
>> blk_queue_max_hw_segments to the values corresponding to a normal SFF 
>> controller.
> 
> What about the DMA padding buffer from nv_adma_port_start and internal
> buffers for commands like request sense that don't come via the request
> queue directly.

Indeed we do call ata_port_start from nv_adma_port_start, which calls 
dmam_alloc_coherent to allocate the SFF PRD table. Since the DMA mask is 
64-bit, this could indeed be allocated above 4GB which would be bad.

I suppose what we could do is just not call ata_port_start there, but 
move it into nv_adma_slave_config and call it when going into non-ADMA 
mode. We'd have to drop the DMA mask down to 32-bit first as well as 
setting blk_queue_bounce_limit though, which is one of my questions, is 
this OK to do?

> Also it seems nv_adma_use_reg_mode() can decide to send other commands
> via the non ADMA interface even for ATA devices. Are we 100% certain it
> never decides to let through a command with DMA via the register
> interface in this case - what do you see if you instrument the function ?

The only cases where that could happen are for polling DMA commands 
(which I presume we never do) or where result taskfile is requested. The 
latter could be a problem for ATA passthrough commands using DMA, I 
suppose.. Question is what we can do about it.. We have to switch out of 
ADMA mode to read a result taskfile. I guess that's not really a problem 
unless somebody starts issuing NCQ commands via ATA pass-through. Do we 
allow that?
