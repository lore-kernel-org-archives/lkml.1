Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbXLLKJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbXLLKJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbXLLKJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:09:04 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:12605 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757584AbXLLKJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:09:01 -0500
Message-ID: <475FB316.6040804@panasas.com>
Date: Wed, 12 Dec 2007 12:08:22 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: 2.6.24-rc3-mm1
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	 <47462F3C.3040700@googlemail.com>	 <20071122201250.f957e280.akpm@linux-foundation.org>	 <47466B5D.90607@googlemail.com>	 <20071126221509.8f437b61.akpm@linux-foundation.org> <1197390783.3812.19.camel@localhost.localdomain>
In-Reply-To: <1197390783.3812.19.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2007 10:08:26.0514 (UTC) FILETIME=[EFC7B720:01C83CA6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11 2007 at 18:33 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Mon, 2007-11-26 at 22:15 -0800, Andrew Morton wrote:
>> OK, thanks.  I'll assume that James and Hannes have this in hand (or will
>> have, by mid-week) and I won't do anything here.
> 
> Just to confirm what I think I'm going to be doing:  rebasing the
> scsi-misc tree to remove this commit:
> 
> commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0
> Author: Hannes Reinecke <hare@suse.de>
> Date:   Tue Nov 6 09:23:40 2007 +0100
> 
>     [SCSI] Do not requeue requests if REQ_FAILFAST is set
> 
> And its allied fix ups:
> 
> commit 983289045faa96fba8841d3c51b98bb8623d9504
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Sat Nov 24 19:47:25 2007 +0200
> 
>     [SCSI] fix up REQ_FASTFAIL not to fail when state is QUIESCE
> 
> commit 9dd15a13b332e9f5c8ee752b1ccd9b84cb5bdf17
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Sat Nov 24 19:55:53 2007 +0200
> 
>     [SCSI] fix domain validation to work again
> 
> James
> 

The problems caused by this patch where nagging me at the back of my head
from the begging. Why should we fail on a check of FAIL_FAST in all kind
of weird places like boots, when the only place that should ever set the 
flag should be one of the multi-path drivers. finally it struck me:

It might be a bug in ll_rw_blk at blk_rq_bio_prep() there is this:

static void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
			    struct bio *bio)
{
	/* first two bits are identical in rq->cmd_flags and bio->bi_rw */
	rq->cmd_flags |= (bio->bi_rw & 3);
	...

Now this is no longer true and is a bug.
Second bit of bio->bi_rw defined in bio.h is:
#define BIO_RW_AHEAD	1
but
Second bit of rq->cmd_flags is __REQ_FAILFAST

so maybe we are getting FAILFAST in the wrong places?

(I will look for an old patch I sent a year ago that fixes
this bug)

Boaz
 
