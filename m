Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbZHOIWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbZHOIWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 04:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZHOIWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 04:22:21 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43011 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZHOIWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 04:22:20 -0400
Date: Sat, 15 Aug 2009 10:22:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH]: Implementation of blk_rq_map_kern_sg() (aka New
	implementation  of scsi_execute_async() v3)
Message-ID: <20090815082220.GJ12579@kernel.dk>
References: <4A563368.5040407@vlnb.net> <4A830016.5020304@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A830016.5020304@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12 2009, Vladislav Bolkhovitin wrote:
> This patch implements function blk_rq_map_kern_sg(), which allows to map
> a kernel-originated SG vector to a block request. It is necessary to execute
> SCSI commands with from kernel going SG buffer. At the moment SCST is the only
> user of this functionality. It needs it, because its target drivers, which
> are, basically, SCSI drivers, can deal only with SGs, not with BIOs. But,
> according to the latest discussions, there can be other potential users for of
> this functionality, so I'm sending this patch in a hope that it will be
> also useful for them and eventually will be merged in the mainline kernel.
> 
> In the previous submissions this patch was called "New implementation of
> scsi_execute_async()", but since in this version scsi_execute_async() was
> removed from it by request of Boaz Harrosh the name was changed accordingly.

Generally this patch looks great, I just have one little thing I'd like
to point out:

> +	while (hbio != NULL) {
> +		bio = hbio;
> +		hbio = hbio->bi_next;
> +		bio->bi_next = NULL;
> +
> +		blk_queue_bounce(q, &bio);
> +
> +		res = blk_rq_append_bio(q, rq, bio);
> +		if (unlikely(res != 0)) {
> +			bio->bi_next = hbio;
> +			hbio = bio;
> +			/* We can have one or more bios bounced */
> +			goto out_unmap_bios;
> +		}
> +	}

Constructs like this are always dangerous, because of how mempools work.
__blk_queue_bounce() will internally do:

        bio = bio_alloc(GFP_NOIO, cnt);

so you could potentially enter a deadlock if a) you are the only one
allocating a bio currently, and b) the alloc fails and we wait for a bio
to be returned to the pool. This is highly unlikely and requires other
conditions to be dire, but it is a problem. This is not restricted to
the swap out path, the problem is purely lack of progress. So the golden
rule is always that you either allocate these units from a private pool
(which is hard for bouncing, since it does both page and bio allocations
from a mempool), or that you always ensure that a previously allocated
bio is in flight before attempting a new alloc.

-- 
Jens Axboe

