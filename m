Return-Path: <linux-kernel-owner+w=401wt.eu-S1030406AbXBOSBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030406AbXBOSBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030405AbXBOSBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:01:14 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:33995 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030398AbXBOSBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:01:13 -0500
Date: Thu, 15 Feb 2007 19:00:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Lord <mlord@pobox.com>
Subject: Re: libata FUA revisited
Message-ID: <20070215180023.GA4438@kernel.dk>
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no> <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no> <45D104F3.7040602@shaw.ca> <45D1D72D.9020509@gmail.com> <45D252CD.5010303@shaw.ca> <45D25CF2.5030508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D25CF2.5030508@gmail.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13 2007, Tejun Heo wrote:
> >>So, actually, I was thinking about *always* using the non-NCQ FUA 
> >>opcode.  As currently implemented, FUA request is always issued by 
> >>itself, so NCQ doesn't make any difference there.  So, I think it 
> >>would be better to turn on FUA on driver-by-driver basis whether the 
> >>controller supports NCQ or not.
> >
> >Unfortunately not all drives that support NCQ support the non-NCQ FUA 
> >commands (my Seagates are like this).
> 
> And I'm a bit scared to set FUA bit on such drives and trust that it 
> will actually do FUA, so our opinions aren't too far away from each 
> other.  :-)
> 
> >There's definitely a potential advantage to FUA with NCQ - if you have 
> >non-synchronous accesses going on concurrently with synchronous ones, if 
> >you have to use non-NCQ FUA or flush cache commands, you have to wait 
> >for all the IOs of both types to drain out before you can issue the 
> >flush (since those can't be overlapped with the NCQ read/writes). And if 
> >you can only use flush cache, then you're forcing all the writes to be 
> >flushed including the non-synchronous ones you didn't care about. 
> >Whether or not the block layer currently exploits this I don't know, but 
> >it definitely could.
> 
> The current barrier implementation uses the following sequences for 
> no-FUA and FUA cases.
> 
> 1. w/o FUA
> 
> normal operation -> barrier issued -> drain IO -> flush -> barrier 
> written -> flush -> normal operation resumes
> 
> 2. w/ FUA
> 
> normal operation -> barrier issued -> drain IO -> flush -> barrier 
> written / FUA -> normal operation resumes
> 
> So, the FUA write is issued by itself.  This isn't really efficient and 
> frequent barriers impact the performance badly.  If we can change that 
> NCQ FUA will be certainly beneficial.

But we can't really change that, since you need the cache flushed before
issuing the FUA write. I've been advocating for an ordered bit for
years, so that we could just do:

3. w/FUA+ORDERED

normal operation -> barrier issued -> write barrier FUA+ORDERED
 -> normal operation resumes

So we don't have to serialize everything both at the block and device
level. I would have made FUA imply this already, but apparently it's not
what MS wanted FUA for, so... The current implementations take the FUA
bit (or WRITE FUA) as a hint to boost it to head of queue, so you are
almost certainly going to jump ahead of already queued writes. Which we
of course really do not.

> >>Well, I might be being too paranoid but silent FUA failure would be 
> >>really hard to diagnose if that ever happens (and I'm fairly certain 
> >>that it will on some firmwares).
> >
> >Well, there are also probably drives that ignore flush cache commands or 
> > fail to do other things that they should. There's only so far we can go 
> >in coping if the firmware authors are being retarded. If any drive is 
> >broken like that we should likely just blacklist NCQ on it entirely as 
> >obviously little thought or testing went into the implementation..
> 
> FLUSH has been around quite long time now and most drives don't have 
> problem with that.  FUA on ATA is still quite new and libata will be the 
> first major user of it if we enable it by default.  It just seems too 
> easy to ignore that bit and successfully complete the write - there 
> isn't any safety net as opposed to using a separate opcode.  So, I'm a 
> bit nervous.

I'm not too nervous about the FUA write commands, I hope we can safely
assume that if you set the FUA supported bit in the id AND the write fua
command doesn't get aborted, that FUA must work. Anything else would
just be an immensely stupid implementation. NCQ+FUA is more tricky, I
agree that it being just a command bit does make it more likely that it
could be ignored. And that is indeed a danger. Given state of NCQ in
early firmware drives, I would not at all be surprised if the drive
vendors screwed that up too.

But, since we don't have the ordered bit for NCQ/FUA anyway, we do need
to drain the drive queue before issuing the WRITE/FUA. And at that point
we may as well not use the NCQ command, just go for the regular non-NCQ
FUA write. I think that should be safe.

-- 
Jens Axboe

