Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbYCCCkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbYCCCkc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 21:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbYCCCkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 21:40:22 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:26521 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbYCCCkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 21:40:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=wIPuXF9Qlzdl4xRBXZNmxuTAyupX9AE3cCt0pG4wPhKff9k+g5680VwOFgK+ProKKlqgwpTY5V1DLKsGidaOR5Nc+NMPe8GHVua3mzxwy9XFj4hignD56Y8o1qas6g5qDYNZqAS5xPzBNpjBrVnGzqd00bjOsY9NbQI4fLewr6U=
Message-ID: <47CB6508.3040206@gmail.com>
Date: Mon, 03 Mar 2008 11:40:08 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com,
       efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH] block: fix residual byte count handling
References: <1204303656.4003.19.camel@localhost.localdomain>	<20080229201123.GK6704@kernel.dk>	<47C8F4FC.1040505@gmail.com> <20080302235223X.tomof@acm.org>
In-Reply-To: <20080302235223X.tomof@acm.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> sum(sg) == rq->data_len is already broken; sg sends such requests
> (though it would be nice if it doesn't).
> 
> I've not followed the earlier discussion (because I thought the drain
> buffer stuff affected only libata but seems it doesn't ...). Why did
> we need to change the meaning of rq->data_len?

At this point, it's not clear what the original meaning of rq->data_len
is because before moving alignment and padding to block layer,
rq->data_len equaled both the requested data length and the length of sg
list.  AFAIK, it's SCSI midlayer which makes sg list and data length
mismatch not block layer.

>From the POV of the block layer, as now it might extend the sg list, it
has to decide what rq->data_len means in this case - the requested
transfer length from userland or the length of mapped sg list.

I think that currently the biggest problem is that drivers which don't
require request size adjustment are getting it because alignment setting
doesn't distinguish between start address alignment and size alignment.
For drivers which don't require data size adjustment from block layer,
data_len or raw_data_len doesn't matter.  They're equal anyway.  I'm
prepping a patch for this now.

For drivers which do require request size adjustments, I think it's
better to keep rq->data_len in line with the size of mapped sg list.
The rationales are...

- Those are dumb controllers which want to see requests which meet
certain size requirements and they're likely to care more about actual
data buffer size than user requested buffer size.  IOW, they wanna see
sizes which meet certain requirements, so give them those values.

- I think bugs caused by using raw_data_len instead of data_len are more
subtle than the other way around.  Using data_len instead of
raw_data_len usually affects the application layer while using
raw_data_len instead of data_len affects the DMA engine and transport layer.

> rq->data_len meant the true data length and the patch to change it
> doesn't look to make anything simple. Can we revert the meaning of
> rq->data_len? I'm not sure that we need to add rq->extra_len but it's
> fine as long as it's only for drivers that want to use it.
> 
> This is only compile tested.

If we're gonna go this way, we'll need blk_rq_total_data_len() and use
it for drivers which requires request size adjustments.

Thanks.

-- 
tejun
