Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbZECTsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZECTsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZECTru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:47:50 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59196 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837AbZECTrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:47:48 -0400
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>,
       Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>,
       Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
In-Reply-To: <49FDEE64.5090302@garzik.org>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
	 <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com>
	 <20090503071619.GP8822@parisc-linux.org>
	 <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>
	 <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com>
	 <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com>
	 <49FDE3BB.505@garzik.org>  <49FDE50A.4060503@garzik.org>
	 <1241377472.5596.88.camel@mulgrave.int.hansenpartnership.com>
	 <49FDEE64.5090302@garzik.org>
Content-Type: text/plain
Date: Sun, 03 May 2009 14:47:47 -0500
Message-Id: <1241380067.5596.103.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-03 at 15:20 -0400, Jeff Garzik wrote:
> [tangent...]
> 
> Does make you wonder if a ->init_rq_fn() would be helpful, one that 
> could perform gfp_t allocations rather than GFP_ATOMIC?  The idea being 
> to call ->init_rq_fn() almost immediately after creation of struct 
> request, by the struct request creator.

Isn't that what the current prep_fn actually is?

> I obviously have not thought in depth about this, but it does seem that 
> init_rq_fn(), called earlier in struct request lifetime, could eliminate 
> the need for ->prepare_flush, ->prepare_discard, and perhaps could be a 
> better place for some of the ->prep_rq_fn logic.

It's hard to see how ... prep_rq_fn is already called pretty early ...
almost as soon as the elevator has decided to spit out the request

> The creator of struct request generally has more freedom to sleep, and 
> it seems logical to give low-level drivers a "fill in LLD-specific info" 
> hook BEFORE the request is ever added to a request_queue.

Unfortunately it's not really possible to find a sleeping context in
there:  The elevators have to operate from the current
elv_next_request() context, which, in most drivers can either be user or
interrupt.

The way the block layer is designed is to pull allocations up the stack
much closer to the process (usually at the bio creation point) because
that allows the elevators to operate even in memory starved conditions.
If we pushed the allocation down into the request level, we'd need some
type of threading (bad for performance) and the request processing would
stall when some GFP_KERNEL allocation went out to lunch finding memory.

The ideal for REQ_TYPE_DISCARD seems to be to force a page allocation
tied to a bio when it's issued at the top.  That way everyone has enough
memory when it comes down the stack (both extents and WRITE SAME sector
will fit into a page ... although only just for WRITE SAME on 4k
sectors).

James


