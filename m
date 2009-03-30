Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbZC3Ucd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbZC3Ucd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZC3UcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:32:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55956 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbZC3UcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:32:22 -0400
Message-ID: <49D12C2B.7020805@garzik.org>
Date: Mon, 30 Mar 2009 16:31:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       =?ISO-8859-1?Q?Fernando_Luis_?= =?ISO-8859-1?Q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
References: <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <49D11A8D.1090600@garzik.org> <alpine.LFD.2.00.0903301248500.4093@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903301248500.4093@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 30 Mar 2009, Jeff Garzik wrote:
>> Indeed -- if the drive tells us it failed the cache flush, it seems
>> self-evident that we should be passing that failure back to userspace where
>> possible.

> EOPNOTSUPP doesn't mean "the cache flush failed". It just means "I don't 
> support cache flushing".
> 
> No failure anywhere. See?

Hence my statement of

	the aim is simply to return zero rather than EOPNOTSUPP [...]
	which is quite reasonable

I think we are all getting a bit confused whether we are discussing

	(a) EOPNOTSUPP return value,
		or
	(b) _all possible_ blkdev_issue_flush() error return values.

As I read it, you are talking about (a) and Jens responded to (b).  But 
maybe I am wrong.

So I have these observations:

1) fsync(2) should not return EOPNOTSUPP, if the block device does not 
support cache flushing.  This seems to agree with Linus's patch.

2) A Linux filesystem MIGHT care about EOPNOTSUPP return value, as that 
return value does provide information about the future value of cache 
flushes.

3) However, at present NONE of the blkdev_issue_flush() callers use 
EOPNOTSUPP in any way.  In fact, none of the current callers check the 
return value at all.

4) Furthermore, handling lack of cache flush support at the block layer, 
rather than per-filesystem, makes more sense to me.

But I am biased towards storage, so what do I know :)

5) Based on observation #3, the current kernel should be changed to 
return USEFUL blkdev_issue_flush() return values back to userspace. 
Fernando's patches head in this direction, as does my most recent 
file_fsync patch.

	Jeff





