Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbYHNLmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbYHNLmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 07:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbYHNLmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 07:42:13 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15877 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbYHNLmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 07:42:12 -0400
Date: Thu, 14 Aug 2008 13:42:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Alex Dubov <oakad@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: can block drivers get non-fs requests?
Message-ID: <20080814114209.GB20055@kernel.dk>
References: <20080814133810.746751cf@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814133810.746751cf@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14 2008, Pierre Ossman wrote:
> Hi Jens,
> 
> There is one part of the block layer I'm having trouble completely
> understanding (well there are loads really, but right now there's one in
> particular :)):
> 
> Do block drivers need to watch out for requests that aren't "normal"
> reads and writes? The MMC block driver has a funky prepare function
> that checks for FS and PC requests and discards anything else. I
> believe this is wrong in two regards:

You should check in the driver whether the request type is supported. So
if you can only handle fs requests, you should do a check for
!blk_fs_request() after elv_next_request() and call
end_(de)queued_request() appropriately.

> a) PC requests seem to be prepared SCSI cmds, and the MMC driver just
> expects normal transfer requests. Therefore, such requests should not
> be accepted by this driver.

Yes, that is correct. A PC request is essentially a SCSI command sent
directly.

> b) The block layer won't throw weird stuff at us unless explicitly told
> so. I.e. a normal block queue will only produce normal FS requests.

Normal IO activity will only produce fs requests. However, if someone
uses eg SG_IO on your block device, you will be sent pc requests. There
are no checks for this, it is left to the driver.

-- 
Jens Axboe

