Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbXCDXqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbXCDXqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 18:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXCDXqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 18:46:31 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:39077 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbXCDXqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 18:46:30 -0500
Message-ID: <45EB5A52.1020907@garzik.org>
Date: Sun, 04 Mar 2007 18:46:26 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: CK804 SATA Errors (still got them)
References: <200703011339.52895.s0348365@sms.ed.ac.uk> <200703020120.52879.s0348365@sms.ed.ac.uk> <45E78E8A.2090202@shaw.ca> <200703021547.09121.s0348365@sms.ed.ac.uk> <45EB555C.9050606@shaw.ca>
In-Reply-To: <45EB555C.9050606@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Alistair John Strachan wrote:
>>> Can you try reverting commit 721449bf0d51213fe3abf0ac3e3561ef9ea7827a
>>> (link below) and see what effect that has?
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h 
>>>
>>> =721449bf0d51213fe3abf0ac3e3561ef9ea7827a
>>
>> Obviously, I'll let you know if it happens again, but I've reverted 
>> this commit and transferred 22.5GB over 45 minutes onto a RAID5 with 4 
>> HDs on an NVIDIA sata controller, and this error hasn't appeared.
>>
>> So I'm inclined to (very unscientifically) say that this brings it 
>> back to 2.6.20's level of stability.
> 
> Interesting. Can you try un-reverting that patch, and applying this one?
> 
> The reading of the status register is something that was part of the 
> original
> NVidia code, which I'm not really sure why is there. Given that reading
> the status register clears the drive's interrupt status, that might be
> causing some wierd interaction with the ADMA controller. Also, I added in
> a printk for cases where notifiers are triggered but the command doesn't
> indicate completion - if you still get problems, let me know if you see
> that message.


AFAICS, when in ADMA mode, you absolutely should not touch the ATA 
shadow registers at all.

This is normal for all controllers with both a "legacy mode" and an 
"enhanced DMA mode" of some sort:  the internal silicon state machines 
"own" the ATA shadow registers while in enhanced DMA mode.  Reading or 
writing the ATA shadow registers while in enhanced DMA mode can lead to 
undefined results, running the gamut from no-op to data corruption and 
hardware lock-ups.

You may only access the ATA shadow registers when NV_ADMA_CTL_GO is 
cleared, and then NV_ADMA_STAT_LEGACY is set, indicating the NVIDIA chip 
is in register mode (aka legacy mode).

	Jeff



