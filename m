Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbZECTUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbZECTUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZECTUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:20:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52504 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbZECTUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:20:19 -0400
Message-ID: <49FDEE64.5090302@garzik.org>
Date: Sun, 03 May 2009 15:20:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>,
       Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>,
       Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>	 <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com>	 <20090503071619.GP8822@parisc-linux.org>	 <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>	 <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com>	 <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com>	 <49FDE3BB.505@garzik.org>  <49FDE50A.4060503@garzik.org> <1241377472.5596.88.camel@mulgrave.int.hansenpartnership.com>
In-Reply-To: <1241377472.5596.88.camel@mulgrave.int.hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Sun, 2009-05-03 at 14:40 -0400, Jeff Garzik wrote:
>> Jeff Garzik wrote:
>>> (2) determine at init if queue (a) supports explicit DISCARD and/or (b) 
>>> supports DISCARD flag passed with READ or WRITE
>>
>> As an aside -- does any existing command set support case #b, above?
> 
> Not to my knowledge.
> 
> I think discard was modelled on barrier (which can be associated with
> data or stand on its own).

Yeah -- I am thinking we can reduce complexity if no real hardware 
supports "associated with data."


>> AFAICT, ATA, SCSI and NVMHCI all have a single, explicit hardware 
>> command to discard/deallocate unused sectors.
>>
>> Therefore, creating REQ_TYPE_DISCARD seems to eliminate any need for new 
>> hook ->prepare_discard().
> 
> Well, yes and no ... in the SCSI implementation of either UNMAP or WRITE
> SAME, we still need a data buffer to store either the extents or the
> actual same data.

Sure, UNMAP's extents would quite naturally travel with the 
REQ_TYPE_DISCARD struct request, and can be set up at struct request 
allocation time.  In all of ATA, SCSI and NVMHCI, they appear to want 
the extents.

Is WRITE SAME associated with this current DISCARD work, or is that just 
a similar example?  I'm unfamiliar with its issues...


>> This provides a 1:1 correspondence between hardware and struct request, 
>> most closely matching the setup of known hardware.
> 
> Agreed ... but we still have to allocate the adjunct buffer
> somewhere ....

Agreed.  I merely argue ->prep_rq_fn() would be a better place -- it can 
at least return a useful return value -- than ->prepare_discard(), which 
would be the natural disposition for a REQ_TYPE_DISCARD -- or 
->request_fn() itself, if a block driver so chooses.

The extents would be an argument to REQ_TYPE_DISCARD, and should be 
associated with struct request somehow, by struct request's creator. 
The extent info needs to be in some generic form, because all of 
ATA|SCSI|NVMHCI seem to want it.


[tangent...]

Does make you wonder if a ->init_rq_fn() would be helpful, one that 
could perform gfp_t allocations rather than GFP_ATOMIC?  The idea being 
to call ->init_rq_fn() almost immediately after creation of struct 
request, by the struct request creator.

I obviously have not thought in depth about this, but it does seem that 
init_rq_fn(), called earlier in struct request lifetime, could eliminate 
the need for ->prepare_flush, ->prepare_discard, and perhaps could be a 
better place for some of the ->prep_rq_fn logic.

The creator of struct request generally has more freedom to sleep, and 
it seems logical to give low-level drivers a "fill in LLD-specific info" 
hook BEFORE the request is ever added to a request_queue.

Who knows...

	Jeff




