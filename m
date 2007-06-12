Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbXFLPS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbXFLPS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXFLPST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:18:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55543 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbXFLPSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:18:18 -0400
Message-ID: <466EB937.6050807@garzik.org>
Date: Tue, 12 Jun 2007 11:18:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Albert Lee <albertcc@tw.ibm.com>
Subject: Re: libata passthru: support PIO multi commands
References: <200706112200.l5BM0qFn005767@hera.kernel.org>	<20070611233917.4bd8c6d7@the-village.bc.nu>	<466DE438.70108@garzik.org> <20070612111621.10074408@the-village.bc.nu>
In-Reply-To: <20070612111621.10074408@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>>> +		if (multi_count != dev->multi_count)
>>>> +			ata_dev_printk(dev, KERN_WARNING,
>>>> +				       "invalid multi_count %u ignored\n",
>>>> +				       multi_count);
>>>> +	}
>>> What limits log spamming here ?
>> Intelligence of the user with privs?
> 
> Not ever SG_IO call requires priviledges.

All calls relevant to this thread require CAP_SYS_RAWIO.


> Issue a multi count sized write. Acidentally collide with another program
> which mucks up the multiwrite count (for once it probably won't be HAL
> making a mess ;)) and send data. The state of the disk at the point a
> short multiwrite terminates is undefined, it may have written some of the
> sectors, it may have blanked them all (Optical media) etc. Far better
> just to error the invalid command - especially as in some cases without
> Mark's fixes for DRQ cleanup on error it may even hang in one direction.

ata_scsi_pass_thru() is not executed at ioctl submission time (block 
queue submission time), but rather immediately before it is issued to 
the drive.  At that point you know the bus is idle, all other commands 
have finished executing, and dev->multi_count is fresh not stale.  The 
code path goes from ata_scsi_pass_thru() to ata_qc_issue() without 
releasing the spinlock, even.

But the last point is true -- we should error rather than just warn 
there, AFAICS.

	Jeff


