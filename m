Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYKJWzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYKJWzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYKJWzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:55:22 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45973 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbYKJWzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:55:21 -0500
Message-ID: <4918BBD4.3060306@garzik.org>
Date: Mon, 10 Nov 2008 17:55:16 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: IDE/ATA development list <linux-ide@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: request to revert libata-convert-to-block-tagging patches
References: <4917C449.2080504@kernel.org>
In-Reply-To: <4917C449.2080504@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, all.
> 
> I went through libata-convert-to-block-tagging today and found several
> issues.
> 
> 1. libata internal data structure for command context (qc) allocation is
> bound to tag allocation, which means that block layer tagging should be
> enabled for all controllers which have can_queue > 1.
> 
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
> 
> So, please revert the following commits.
> 
> 43a49cbdf31e812c0d8f553d433b09b421f5d52c
> e013e13bf605b9e6b702adffbe2853cfc60e7806
> 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e

A bit late, since they're already in, but, ACK.  (I'm on East Coast 
Vampire time, apparently)

Now that this is resolved, please allow me a bit of grumbling.  I always 
thought the original course -- 2.6.29 -- was best for these patches.  I 
had even queued them for 2.6.29, when they found their way into 2.6.28 
anyway.  Without /any/ testing by libata maintainers or linux-next. 
Without even being tested on non-NCQ setups, apparently.

The process broke down completely with this patchset :(

I still want to see this stuff in 2.6.29 though; it is the right way to 
go: following the theme of using block rather than SCSI bits in libata 
generic code [when those bits are, themselves, generic rather than 
SCSI-specific].

	Jeff



