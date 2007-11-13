Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbXKME13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbXKME13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 23:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXKME1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 23:27:20 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:56434 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbXKME1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 23:27:19 -0500
Date: Mon, 12 Nov 2007 22:26:16 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB
In-reply-to: <47390B2F.7090105@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Message-id: <47392768.3030509@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <4738DE21.8090702@shaw.ca> <47390B2F.7090105@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> How about always initialize DMA mask to ATA_DMA_MASK regardless of ADMA
> mode such that PRD and PAD buffers are always accessible by register
> mode and just raising PCI dma mask and queue bounce limit if ADMA mode
> is active?

Could be done.. but, I don't want to constrain the ADMA APRD/CPB area in 
that way (there are some dual-socket Opteron boxes with this controller, 
forcing an allocation below 4GB for this could force a non-optimal node 
allocation I think..) To do this I'd have to raise the mask for the APRD 
allocation, drop it again, then raise it again in ADMA mode, which is 
kind of ugly.

Also, I'd rather not allocate the legacy PRD at all if we're in ADMA 
mode. That way, if some bug causes us to try and do legacy DMA in ADMA 
mode, we'll crash from null pointer dereference instead of potentially 
transferring incorrect data (as we had in this case) and corrupting things.

> 
>> +	/* Set appropriate DMA mask. */
>> +	pci_set_dma_mask(pdev, bounce_limit);
>> +	pci_set_consistent_dma_mask(pdev, bounce_limit);
> 
> These can fail.

Yes, it should likely do something with these return values. Though 
theoretically it shouldn't fail, since the DMA mask is either 32-bit, 
which shouldn't fail, or one that was successfully set before. Also I 
don't think the SCSI layer actually checks the slave_config return 
value.. sigh.

> 
> Also, please separate out the result TF handling to a separate patch.  I
> know it's a small change but as both introduces important behavior
> changes, I think it would be nice to have a bisection point inbetween.

Could do. That change would have to come first though, as the change to 
not allocate the PRD except when necessary would cause some cases there 
to blow up when before they might have worked in some cases.

> 
> Thanks.
> 
