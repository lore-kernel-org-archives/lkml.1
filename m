Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbXEJVj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbXEJVj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbXEJVjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:39:52 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42466 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbXEJVjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:39:52 -0400
Date: Thu, 10 May 2007 23:37:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/12] crypto: don't pollute the global namespace with  sg_next()
Message-ID: <20070510213743.GY4163@kernel.dk>
References: <11787972373654-git-send-email-jens.axboe@oracle.com> <11787972372499-git-send-email-jens.axboe@oracle.com> <4643243C.8030906@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4643243C.8030906@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10 2007, Benny Halevy wrote:
> Jens Axboe wrote:
> > It's a subsystem function, prefix it as such.
> 
> Jens, Boaz and I talked about this over lunch.
> I wonder whether the crypto code must use your implementation
> instead of its own as it needs to over the sglist, e.g. for
> calculating iscsi (data) digest.

The thought did cross my mind, and yes I think that would be a good
idea. The whole thing should probably just migrate to
lib/scattersomething.c

> The crypto implementation of chained sglists in crypto/scatterwalk.h
> determines the chain link by !sg->length which will sorta work
> with your implementation, however the marker bit on page pointer must
> be cleared to use it.

I don't like using sg->length, as that may be modified for legitimate
reason. That's why I chose to use the lsb bit of the page pointer.

> Also, is it possible that after the original sglist has gone through
> dma_map_sg and entries were merged, some entries will have zero
> length?  I'm not sure... If so, if the crypto implementation scans
> the sg list after it was dma mapped (maybe in a retry path) it
> may hit an entry that looks to it like a chaining link.  This
> might be an existing bug and another reason for the crypto code
> to use your implementation.

It's hard to say, depends heavily on the sub system or arch. Even if
using the pointer tagging mechanism seems a bit nasty, I think it's the
more resilient approach.

-- 
Jens Axboe

