Return-Path: <linux-kernel-owner+w=401wt.eu-S1764342AbXJRLDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764342AbXJRLDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbXJRLDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:03:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50797 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914AbXJRLDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:03:06 -0400
Message-ID: <47173D5A.9050508@garzik.org>
Date: Thu, 18 Oct 2007 07:02:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tejun Heo <htejun@gmail.com>, Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] Re: [bug] ata subsystem related crash with latest -git
References: <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk> <471720FE.4090004@garzik.org> <20071018091706.GO5063@kernel.dk> <4717281B.6070301@garzik.org> <20071018094128.GP5063@kernel.dk> <47172FB1.5020704@garzik.org> <20071018100959.GQ5063@kernel.dk> <471738A6.2020201@garzik.org> <20071018105438.GB9658@elte.hu>
In-Reply-To: <20071018105438.GB9658@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>>> Tomo and I agreed to kill sg_last() a few days ago anyways, so this 
>>> is perfectly fine with me.
>> Yep, the [attached] patch that kills ata_sg_is_last() is working here 
>> on both machines that were previously croaking.
>>
>> It would be nice to get pdc_adma, sata_sil24 and ipr it-works test 
>> done, but IMO the patch is pretty straightforward and should be OK.
> 
> just a quick question: i have Jens's workarounds applied right now (see 
> patch below). Am i now crash/corruption-safe, or do i need your patch 
> too? And once your patch [and the other sg_*() patches] are upstream i 
> dont need the workaround anymore, correct?

You need my patch if and only if you use one of the drivers touched by 
the patch.  ata_sg_is_last() was a driver helper function, so my fix 
never really touched core code.

I never had to apply the changes you included, to fix problems here.

And looking at those changes...
> -	q->max_phys_segments = max_segments;
> +	q->max_phys_segments = max_segments - 1;
  ...
> -#define SCSI_MAX_SG_SEGMENTS	128
> +#define SCSI_MAX_SG_SEGMENTS	129

I wonder if libata should be doing

	blk_queue_max_phys_segments(q, q->max_phys_segments - 1)

to account for the pad entry that libata owns.

	Jeff



