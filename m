Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYKJMH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYKJMH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbYKJMHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:07:09 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:43656 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbYKJMHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:07:07 -0500
Date: Mon, 10 Nov 2008 13:05:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: request to revert libata-convert-to-block-tagging patches
Message-ID: <20081110120533.GB26778@kernel.dk>
References: <4917C449.2080504@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4917C449.2080504@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10 2008, Tejun Heo wrote:
> Hello, all.
> 
> I went through libata-convert-to-block-tagging today and found several
> issues.
> 
> 1. libata internal data structure for command context (qc) allocation is
> bound to tag allocation, which means that block layer tagging should be
> enabled for all controllers which have can_queue > 1.

Naturally, is there a problem there?

> 2. blk-tag offsets allocation for non-sync requests.  I'm not confident
> this is safe.  Till now, if there was only single command in flight for
> the port, it was guaranteed that the qc gets tag zero whether the device
> is NCQ capable or not.  qc allocation is tied tightly with hardware
> command slot allocation and I don't think it's wise to change this
> assumption.
> 
> #1 is easy to fix but #2 requires either adding a spinlock or two atomic
> variables to struct blk_queue_tag to keep the current behavior while
> guaranteeing that tags are used in order.  Also, there's delay between
> libata marks a request complete and the request actually gets completed
> and the tag is freed.  If another request gets issued inbetween, the tag
> number can't be guaranteed.  This can be worked around by re-mapping tag
> number in libata depending on command type but, well then, it's worse
> than the original implementation.

Or we could just change the blk-tag.c logic to stop of
find_first_zero_bit() returns >= some_value instead of starting at an
offset? You don't need any extra locking for that.

The second part is more tricky I think, but I'm not sure there's a race
there. For normally issued IO, queueing is restarted when the tag
completes. There's a small softirq delay there, but that delay is before
the tag is completed and queueing restarted. Any non-ncq command (eg
through an ioctl) will have to wait for completion as well.

> So, please revert the following commits.
> 
> 43a49cbdf31e812c0d8f553d433b09b421f5d52c
> e013e13bf605b9e6b702adffbe2853cfc60e7806
> 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e

It's not a big deal to me, it can wait for 2.6.29 if there really are
more issues there. But I'm not sure that your points are very valid, so
lets please discuss it a bit more :-)

-- 
Jens Axboe

