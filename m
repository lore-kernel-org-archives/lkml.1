Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbXKNEMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbXKNEMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXKNEMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:12:23 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:36984 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXKNEMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:12:21 -0500
Date: Tue, 13 Nov 2007 22:11:56 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB
In-reply-to: <47392B3D.1020101@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Message-id: <473A758C.1020105@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <4738DE21.8090702@shaw.ca> <47390B2F.7090105@gmail.com>
 <47392768.3030509@shaw.ca> <47392B3D.1020101@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> Could be done.. but, I don't want to constrain the ADMA APRD/CPB area in
>> that way (there are some dual-socket Opteron boxes with this controller,
>> forcing an allocation below 4GB for this could force a non-optimal node
>> allocation I think..) To do this I'd have to raise the mask for the APRD
>> allocation, drop it again, then raise it again in ADMA mode, which is
>> kind of ugly.
> 
> I don't think it really matters.  The table isn't too big and it's not
> like access to the table has any processor locality.  Maybe it's better
> to allocate to the same node as the irq but raising DMA mask doesn't
> help at all.

It's quite possible that restricting the DMA mask will also restrict 
what node that can get allocated on. I'm not so much thinking of the CPU 
access to the table but the controller's banging on the thing several 
times for each command..

> 
> I think performance impact is nil either way but even in highly unlikely
> case it has any impact, allocating PRDs under 4G should be better as it
> avoids DAC cycles on the bus.  But again, this is just irrelevant.
> 
> I'd say just allocate everything under 4G.

The DAC issue shouldn't matter as these controllers are integrated into 
the chipset so it will be using all HT bus transactions, not PCI.

We can do it without all that mess in slave_config though, just by 
delaying raising the DMA mask until after the PRD/pad buffers are allocated.

> 
>> Also, I'd rather not allocate the legacy PRD at all if we're in ADMA
>> mode. That way, if some bug causes us to try and do legacy DMA in ADMA
>> mode, we'll crash from null pointer dereference instead of potentially
>> transferring incorrect data (as we had in this case) and corrupting things.
> 
> Yeap, I can agree with this.  But can you add BUG_ON()/WARN_ON() at
> places instead?  I know blanking pointers feel safer but I think it's
> best to keep resource allocation / release in ->port_start/stop().

Yeah, I've got rid of that stuff now and added some BUG_ONs for this. 
Will submit the patches shortly.
