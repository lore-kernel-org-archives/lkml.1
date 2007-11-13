Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbXKMEm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbXKMEm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 23:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbXKMEmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 23:42:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:1382 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343AbXKMEmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 23:42:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=D/Vgp80nPLqq2+TZ+/FOFXK8WaPyZWLYa9Pn9/fSQkDkVSxJRmCF0fNDFrSHjmmTohHv2kh/Y9GS7itBzgj7RbKge3GpiuKNKDY94oFPQUzTcVHRs0L3XjDdwiJ+PRpwR8snSqc8kvBy1VyfBN3hAnhB61N9pE7RR1ofz0O4yhA=
Message-ID: <47392B3D.1020101@gmail.com>
Date: Tue, 13 Nov 2007 13:42:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB
References: <4738DE21.8090702@shaw.ca> <47390B2F.7090105@gmail.com> <47392768.3030509@shaw.ca>
In-Reply-To: <47392768.3030509@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Tejun Heo wrote:
>> How about always initialize DMA mask to ATA_DMA_MASK regardless of ADMA
>> mode such that PRD and PAD buffers are always accessible by register
>> mode and just raising PCI dma mask and queue bounce limit if ADMA mode
>> is active?
> 
> Could be done.. but, I don't want to constrain the ADMA APRD/CPB area in
> that way (there are some dual-socket Opteron boxes with this controller,
> forcing an allocation below 4GB for this could force a non-optimal node
> allocation I think..) To do this I'd have to raise the mask for the APRD
> allocation, drop it again, then raise it again in ADMA mode, which is
> kind of ugly.

I don't think it really matters.  The table isn't too big and it's not
like access to the table has any processor locality.  Maybe it's better
to allocate to the same node as the irq but raising DMA mask doesn't
help at all.

I think performance impact is nil either way but even in highly unlikely
case it has any impact, allocating PRDs under 4G should be better as it
avoids DAC cycles on the bus.  But again, this is just irrelevant.

I'd say just allocate everything under 4G.

> Also, I'd rather not allocate the legacy PRD at all if we're in ADMA
> mode. That way, if some bug causes us to try and do legacy DMA in ADMA
> mode, we'll crash from null pointer dereference instead of potentially
> transferring incorrect data (as we had in this case) and corrupting things.

Yeap, I can agree with this.  But can you add BUG_ON()/WARN_ON() at
places instead?  I know blanking pointers feel safer but I think it's
best to keep resource allocation / release in ->port_start/stop().

>>> +    /* Set appropriate DMA mask. */
>>> +    pci_set_dma_mask(pdev, bounce_limit);
>>> +    pci_set_consistent_dma_mask(pdev, bounce_limit);
>>
>> These can fail.
> 
> Yes, it should likely do something with these return values. Though
> theoretically it shouldn't fail, since the DMA mask is either 32-bit,
> which shouldn't fail, or one that was successfully set before. Also I
> don't think the SCSI layer actually checks the slave_config return
> value.. sigh.

Then please at least add WARN_ON() && another reason why allocating /
deallocating resources from ->slave_config isn't such a good idea.

>> Also, please separate out the result TF handling to a separate patch.  I
>> know it's a small change but as both introduces important behavior
>> changes, I think it would be nice to have a bisection point inbetween.
> 
> Could do. That change would have to come first though, as the change to
> not allocate the PRD except when necessary would cause some cases there
> to blow up when before they might have worked in some cases.

Yes, please.

Thanks.

-- 
tejun
