Return-Path: <linux-kernel-owner+w=401wt.eu-S1751198AbXBUItK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbXBUItK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXBUItK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:49:10 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:45438 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbXBUItI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:49:08 -0500
Date: Wed, 21 Feb 2007 09:44:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, edmudama@gmail.com,
       Nicolas.Mailhot@LaPoste.net, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <mlord@pobox.com>
Subject: Re: libata FUA revisited
Message-ID: <20070221084427.GA3924@kernel.dk>
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no> <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no> <45D104F3.7040602@shaw.ca> <45D1D72D.9020509@gmail.com> <45D252CD.5010303@shaw.ca> <45D25CF2.5030508@gmail.com> <20070215180023.GA4438@kernel.dk> <45D9FE7B.60909@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D9FE7B.60909@shaw.ca>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19 2007, Robert Hancock wrote:
> Jens Axboe wrote:
> >But we can't really change that, since you need the cache flushed before
> >issuing the FUA write. I've been advocating for an ordered bit for
> >years, so that we could just do:
> >
> >3. w/FUA+ORDERED
> >
> >normal operation -> barrier issued -> write barrier FUA+ORDERED
> > -> normal operation resumes
> >
> >So we don't have to serialize everything both at the block and device
> >level. I would have made FUA imply this already, but apparently it's not
> >what MS wanted FUA for, so... The current implementations take the FUA
> >bit (or WRITE FUA) as a hint to boost it to head of queue, so you are
> >almost certainly going to jump ahead of already queued writes. Which we
> >of course really do not.
> 
> I think that FUA was designed for a different use case than what Linux 
> is using barriers for currently. The advantage with FUA is when you have 

[snip]

Yes that's pretty obvious, my point is just that FUA+ORDERED would be a
nice thing to have for us.

> >I'm not too nervous about the FUA write commands, I hope we can safely
> >assume that if you set the FUA supported bit in the id AND the write fua
> >command doesn't get aborted, that FUA must work. Anything else would
> >just be an immensely stupid implementation. NCQ+FUA is more tricky, I
> >agree that it being just a command bit does make it more likely that it
> >could be ignored. And that is indeed a danger. Given state of NCQ in
> >early firmware drives, I would not at all be surprised if the drive
> >vendors screwed that up too.
> >
> >But, since we don't have the ordered bit for NCQ/FUA anyway, we do need
> >to drain the drive queue before issuing the WRITE/FUA. And at that point
> >we may as well not use the NCQ command, just go for the regular non-NCQ
> >FUA write. I think that should be safe.
> 
> Aside from the issue above, as I mentioned elsewhere, lots of NCQ drives 
> don't support non-NCQ FUA writes..

"Lots" meaning how many? All the ones I have here support FUA.

-- 
Jens Axboe

