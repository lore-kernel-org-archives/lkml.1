Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0BWTcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:32:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab0BWTcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:32:52 -0500
Date: Tue, 23 Feb 2010 14:32:41 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] block: warn if blk_stack_limits() undermines
 atomicity
Message-ID: <20100223193241.GB24662@redhat.com>
References: <20100222204920.GA24514@redhat.com>
 <yq1635nop2j.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1635nop2j.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23 2010 at 12:10pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> For instance, a 512 byte device and a 4K device may be combined
> Mike> into a single logical DM device; the resulting DM device would
> Mike> have a logical_block_size of 4K.  Filesystems layered on such a
> Mike> hybrid device assume that 4K will be written atomically but in
> Mike> reality that 4K will be split into 8 512 byte IOs when issued to
> Mike> the 512 byte device.
> 
> Not really.  It'll be issued as one I/O with a smaller LBA count but an
> identical data payload.

Can you expand on that a bit?  How does a smaller LBA count relate to
this?  On a 512b device the 4K data payload would touch more LBAs.

In any case, a 4K write to a 512b device is not atomic.

> Mike> Using a 4K logical_block_size for the higher-level DM device
> Mike> increases potential for a partial write to the 512b device if
> Mike> there is a system crash.
> 
> That's a definite maybe :)

If you think what I've raised here is overblown then I'd like to
understand why in more detail.

> Mike> [NOTE: setting "misaligned" for this warning is somewhat awkward
> Mike> but blk_stack_limits() return of -1 can be viewed as there was an
> Mike> "alignment inconsistency".  Would it be better to return -1 but
> Mike> avoid setting t->misaligned?]
> 
> I don't have a problem with printing a warning but I don't think this
> qualifies as misalignment on the grounds that the error scenario is in
> the hypothetical bucket and not a deterministic thing.

OK, I was relying on returning -1 so the blk_stack_limits() caller could
provide additional context (via existing warnings) for which device
"increases potential for partial writes" when it gets stacked.

Otherwise all you have is a largely generic warning (as blk_stack_limits
knows nothing about which devices the provided limits belong to).

Mike
