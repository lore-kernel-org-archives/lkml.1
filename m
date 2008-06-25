Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYFYIYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYFYIYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 04:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYFYIYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 04:24:25 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8044 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbYFYIYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 04:24:23 -0400
Date: Wed, 25 Jun 2008 10:24:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
Message-ID: <20080625082421.GU20851@kernel.dk>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com> <20080624080744.GL20851@kernel.dk> <Pine.LNX.4.64.0806241017390.23052@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806241017390.23052@engineering.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24 2008, Mikulas Patocka wrote:
> 
> 
> On Tue, 24 Jun 2008, Jens Axboe wrote:
> 
> >On Tue, Jun 24 2008, Mikulas Patocka wrote:
> >>Hi
> >>
> >>bio_endio calls bi_end_io callback. In case of stacked devices (raid, dm),
> >>bio_end_io may call bio_endio again, up to an unspecified length.
> >>
> >>The crash because of stack overflow was really observed on sparc64. And
> >>this recursion was one of the contributing factors (using 9 stack frames
> >>--- that is 1728 bytes).
> >
> >Looks good, I like the concept. Can you please make it a little less
> >goto driven, though? The next_bio and goto next_bio could just be a
> >while().
> >
> >-- 
> >Jens Axboe
> >
> 
> Hi.
> 
> This is the patch, slightly de-goto-ized. (it still contains one, I think 
> that while (1) { ... break ... } is no better readable than goto).

Sure, that looks better.

> I found another problem in my previous patch, I forgot about the "error" 
> variable (it would cause misbehavior for example if disk fails, submits an 
> error and raid driver turns this failure into success). We need to save 
> the error variable somewhere in the bio, there is no other place where it 
> could be placed. I temporarily saved it to bi_idx, because it's unused at 
> this place.

I don't think bi_idx is a fantastic idea, I could easily imagine the
bi_end_io function wanting to do a segment loop on the bio. Use
bi_phys_segments instead (or bi_hw_segemnts, no difference), they should
only be used when queuing and building IO, not for completion purposes.
And put a big fat comment there explaining the overload. Plus they are
just a cache, so if you use either of those and at the same time clear
BIO_SEG_VALID in bi_flags, then it's guarenteed to be safe.

Also please put the per-cpu definition outside of bio_endio(). And I
don't think you need to disable interrupts, a plain preempt_disable() /
preempt_enable() should be enough.


-- 
Jens Axboe

