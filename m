Return-Path: <linux-kernel-owner+w=401wt.eu-S1161153AbXBUJCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161153AbXBUJCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 04:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161145AbXBUJCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 04:02:43 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:55541 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161132AbXBUJCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 04:02:41 -0500
Date: Wed, 21 Feb 2007 10:01:26 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Lord <mlord@pobox.com>, Ric Wheeler <ric@emc.com>,
       Dongjun Shin <d.j.shin@samsung.com>, Hannes Reinecke <hare@suse.de>
Subject: Re: libata FUA revisited
Message-ID: <20070221090126.GC3924@kernel.dk>
References: <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no> <45D104F3.7040602@shaw.ca> <45D1D72D.9020509@gmail.com> <45D252CD.5010303@shaw.ca> <45D25CF2.5030508@gmail.com> <20070215180023.GA4438@kernel.dk> <45D9FE7B.60909@shaw.ca> <45DC04DF.8040002@gmail.com> <20070221084613.GB3924@kernel.dk> <45DC0983.6000709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DC0983.6000709@gmail.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21 2007, Tejun Heo wrote:
> Jens Axboe wrote:
> > On Wed, Feb 21 2007, Tejun Heo wrote:
> >> [cc'ing Ric, Hannes and Dongjun, Hello.  Feel free to drag other people in.]
> >>
> >> Robert Hancock wrote:
> >>> Jens Axboe wrote:
> >>>> But we can't really change that, since you need the cache flushed before
> >>>> issuing the FUA write. I've been advocating for an ordered bit for
> >>>> years, so that we could just do:
> >>>>
> >>>> 3. w/FUA+ORDERED
> >>>>
> >>>> normal operation -> barrier issued -> write barrier FUA+ORDERED
> >>>>  -> normal operation resumes
> >>>>
> >>>> So we don't have to serialize everything both at the block and device
> >>>> level. I would have made FUA imply this already, but apparently it's not
> >>>> what MS wanted FUA for, so... The current implementations take the FUA
> >>>> bit (or WRITE FUA) as a hint to boost it to head of queue, so you are
> >>>> almost certainly going to jump ahead of already queued writes. Which we
> >>>> of course really do not.
> >> Yeah, I think if we have tagged write command and flush tagged (or
> >> barrier tagged) things can be pretty efficient.  Again, I'm much more
> >> comfortable with separate opcodes for those rather than bits changing
> >> the behavior.
> > 
> > ORDERED+FUA NCQ would still be preferable to an NCQ enabled flush
> > command, though.
> 
> I think we're talking about two different things here.
> 
> 1. The barrier write (FUA write) combined with flush.  I think it would
> help improving the performance but I think issuing two commands
> shouldn't be too slower than issuing one combined command unless it
> causes extra physical activity (moving head, etc...).

The command overhead is dwarfed by other factors, agree.

> 2. FLUSH currently flushes all writes.  If we can mark certain commands
> requiring ordering, we can selectively flush or order necessary writes.
>  (No need to flush 16M buffer all over the disk when only journal needs
> barriering)

Sure, anything is better than the sledge hammer flush. But my claim is
that an ORDERED+FUA enabled write for critical data would be a good
approach, and simple in software.

> >> Another idea Dongjun talked about while drinking in LSF was ranged
> >> flush.  Not as flexible/efficient as the previous option but much less
> >> intrusive and should help quite a bit, I think.
> > 
> > But that requires extensive tracking, I'm not so sure the implementation
> > of that for barriers would be very clean. It'd probably be good for
> > fsync, though.
> 
> I was mostly thinking about journal area.  Using it for other purposes
> would incur a lot of complexity.  :-(

Yep if it's just for the journal, the range is known and fixed, so the
flush range would work nicely there.

-- 
Jens Axboe

