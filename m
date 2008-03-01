Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbYCAGRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbYCAGRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 01:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYCAGRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 01:17:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:59602 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYCAGRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 01:17:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hYM4KS5fCwoo3Z5RgOERiuJDz9HdqFHTJJnyCsuSAA8z93lOPd5E2osQr9A5zwdy+0oVEzhwRD9mE9QPbe8uAGxJK0mbe+E45RPfl33IUmyeojbR7msBoWDtRAcZesBcvSFFe7+dd83zoq8kmG4xA2pjS2OIcV0OfCKKya8YAJw=
Message-ID: <47C8F4FC.1040505@gmail.com>
Date: Sat, 01 Mar 2008 15:17:32 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] block: fix residual byte count handling
References: <20080226150845.2196bc1a.akpm@linux-foundation.org> <1204079075.26640.8.camel@homer.simson.net> <1204092010.9934.31.camel@homer.simson.net> <1204096025.1623.9.camel@homer.simson.net> <47C6661E.9010504@gmail.com> <1204186800.7362.7.camel@homer.simson.net> <47C675C6.8000904@gmail.com> <20080228153542.GZ6704@kernel.dk> <47C6D73E.4030302@gmail.com> <1204303656.4003.19.camel@localhost.localdomain> <20080229201123.GK6704@kernel.dk>
In-Reply-To: <20080229201123.GK6704@kernel.dk>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens, James.

Jens Axboe wrote:
>> With the original patch, I have to run through the whole of libsas and
>> scsi_transport_sas doing
>>
>> s/data_len/raw_data_len/
>>
>> With your update it looks like I have to run through them all doing
>>
>> s/data_len/data_len - extra_len/

blk_rq_raw_data_len() should do.

>> which is even worse.  Can't we put things back to a point where data_len
>> means exactly that and extra_len means how much we have spare on the
>> end, so you know you can DMA up to data_len + extra_len if need be?
>>
>> That way we don't have to sweep through every block driver altering the
>> way it uses data_len.

If SMP is broken because it needs start address alignment but not
padding to align the size, what should be done is to make that exact
requirement visible to the block layer.  Say,
blk_queue_dma_start_alignment() or maybe change
blk_queue_dma_alignment() such that it only indicates start address
alignment and add blk_queue_dma_size_alignment() for drivers which
require size to be aligned too.  I think those are few.

I think the decision which value rq->data_len represents comes down to
which size is used more in low level drivers because no matter which way
we choose we'll have to update some of the drivers which expects the
other thing from rq->data_len.

blk_rq_raw_data_len() is needed iff a driver needs dummy buffers
attached at the end and still needs to know the original request size
which isn't the common case.

> Fully agree. The reason why I think it's so ugly is that you have to
> keep these two seperate variables in sync. The burning was just one bug,
> there will be others...

The posted modification isn't too bad as the maintenance of the two
variables is at places where the nasty things happen.  I think what
rq->data_len should represent when seen from LLDs is more important and
please note that if SMP is broken because it simply doesn't require
512byte size alignment, it's a different issue.

As long as both raw_data_len and data_len are accessible, I'm okay
either way.  My biggest reluctance is against breaking sum(sg) ==
rq->data_len.  I think this can lead to much more subtle problems such
as programming the controller w/ wrong bytes count and wrapped-around
resid calculation.

Thanks.

-- 
tejun
