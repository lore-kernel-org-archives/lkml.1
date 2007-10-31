Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbXJaKab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbXJaKab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbXJaKaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:30:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55119 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbXJaKaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:30:21 -0400
Message-ID: <47285921.9070105@garzik.org>
Date: Wed, 31 Oct 2007 06:29:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] "killing" sg_last(), and discussion
References: <20071031084920.GA25202@havoc.gtf.org> <4728569D.9080502@panasas.com>
In-Reply-To: <4728569D.9080502@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On Wed, Oct 31 2007 at 10:49 +0200, Jeff Garzik <jeff@garzik.org> wrote:
>> I looked into killing sg_last(), but really, this is the best its gonna
>> get (moving sg_last to libata-core.c).
>>
>> You could maybe kill one use with caching, but in the other sg_last()
>> callsites there isn't another s/g loop we can stick a "last_sg = sg;"
>> into.
>>
>> libata is stuck because we undertake the highly unusual operation of
>> fiddling with the final S/G element, to enforce 32-bit alignment.
>>
>> Of course we could eliminate all that nasty fiddling/padding
>> completely, including sg_last(), if other areas of the kernel would
>> guarantee ahead of time that buffer lengths are always a multiple
>> of 4........
>>
>> 	Jeff
>>
> OK Now I'm confused. I thought that ULD's can give you SG's 
> that are actually longer than bufflen and that, at the end, the 
> bufflen should govern the transfer length.
> 
> Now FS_PC commands are sector aligned so you do not have
> problems with that.
> 
> The BLOCK_PC commands have 2 main sources that I know of
> one is sg && bsg from user mode that can easily enforce
> 4 bytes alignment. The second is kernel services which 80%
> of these are done by scsi_execute(). All These can be found
> and fixed. Starting with scsi_execute(). Another place can be
> blk_rq_map_sg(), since all IO's are bio based. It can enforce 
> alignment too.
> 
> I would start by sticking a WARN_ON(qc->pad_len) and
> see if it triggers, what are the sources of that.

The whole qc->pad_len etc. machinery was added because it solved 
problems in the field with ATAPI devices.  So sr or some userland 
application is sending lengths that are not padded to 32-bit boundary, 
probably because plenty of trivial commands can send or return odd 
amounts of data.

This used to be irrelevant, but now with SATA, even PIO data xfer 
(normally what is used for non-READ/WRITE CDBs) must be 32-bit aligned 
because both SATA DMA and SATA PIO are converted into dword-based SATA 
FIS's on the wire.

	Jeff



