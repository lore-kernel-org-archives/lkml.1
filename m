Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbZCZIJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbZCZIJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbZCZIIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:08:49 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:31572 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756214AbZCZIIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:08:46 -0400
Message-ID: <49CB3765.4070406@panasas.com>
Date: Thu, 26 Mar 2009 10:05:57 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 03/14] block: implement blk_rq_map_kern_prealloc()
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <1237910776-10983-4-git-send-email-tj@kernel.org> <49CA4B4B.50408@panasas.com> <49CAE425.5050009@kernel.org> <49CB31DB.2040608@gmail.com>
In-Reply-To: <49CB31DB.2040608@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2009 08:07:34.0279 (UTC) FILETIME=[EB42F970:01C9ADE9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2009 09:42 AM, Tejun Heo wrote:
> Hello,
> 
> A few issues.
> 
> Tejun Heo wrote:
>>> Perhaps you could reorder the code below a bit?
>>>
>>> My proposal is:
>>> * blk_rq_map_kern_prealloc => is simplified to be
>>>     int blk_rq_map_bio(struct request_queue *q, struct request *rq,
>>> 		       struct bio *bio);
> 
> The thing is that the prealloc variant should be allowed to be called
> from IRQ context and blk_queue_bounce() shouldn't be called.
> Hmmm... well, the caller is supposed to know what it's doing and maybe
> we can just add a comment that it shouldn't be called with buffers
> which might get bounced from IRQ context.
> 

Hmm that is a problem. I would suggest a flag or a check. My bios come
from VFS they need bouncing.

Can you think of a solution?

We could just call blk_queue_bounce(). IRQ callers need to make sure their
buffers don't need bouncing anyway, so there is no such bug right? If a programmer
gets it wrong he will get a BUG check that tells him that.

>>> * The extra checks currently inside blk_rq_map_kern_prealloc are moved
>>>   to bio_map_kern_prealloc()
>>>
>>> * Users call bio_map_kern_prealloc() directly and then use blk_rq_map_bio()
>>>   in a two stage process.
> 
> This breaks consistency with blk_rq_map_*() family of functions.  Do
> you have a plan to make them all consistent?  I think we really need
> to maintain API consistency.
> 

I agree, that is why I called it blk_make_request originally. But this is not good
for you since your request is pre-allocated as well as the bio.

It needs a different name, blk_rq_set_bio(), I don't know do you have any ideas?

> Thanks.
> 

Thanks

Boaz


