Return-Path: <linux-kernel-owner+w=401wt.eu-S1751194AbXBUIh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbXBUIh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXBUIh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:37:58 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:26304 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbXBUIh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:37:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hAbl2CApYKkAcjA4otQH0kVqRUsLiqjcWzEEMONuey1UTcakL64/GImVJSWj7M1latzIj6HuZu/yRGNWvCWEraxjHdQtYPPuc7fRH3H0Rk9NAYwDZC+3QW7QsrfNAlC4dv/AQKYV30rQYb8yByBXpsBCLyYXWraCExIQbUJ1Rlc=
Message-ID: <45DC04DF.8040002@gmail.com>
Date: Wed, 21 Feb 2007 17:37:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Lord <mlord@pobox.com>, Ric Wheeler <ric@emc.com>,
       Dongjun Shin <d.j.shin@samsung.com>, Hannes Reinecke <hare@suse.de>
Subject: Re: libata FUA revisited
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no> <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no> <45D104F3.7040602@shaw.ca> <45D1D72D.9020509@gmail.com> <45D252CD.5010303@shaw.ca> <45D25CF2.5030508@gmail.com> <20070215180023.GA4438@kernel.dk> <45D9FE7B.60909@shaw.ca>
In-Reply-To: <45D9FE7B.60909@shaw.ca>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Ric, Hannes and Dongjun, Hello.  Feel free to drag other people in.]

Robert Hancock wrote:
> Jens Axboe wrote:
>> But we can't really change that, since you need the cache flushed before
>> issuing the FUA write. I've been advocating for an ordered bit for
>> years, so that we could just do:
>>
>> 3. w/FUA+ORDERED
>>
>> normal operation -> barrier issued -> write barrier FUA+ORDERED
>>  -> normal operation resumes
>>
>> So we don't have to serialize everything both at the block and device
>> level. I would have made FUA imply this already, but apparently it's not
>> what MS wanted FUA for, so... The current implementations take the FUA
>> bit (or WRITE FUA) as a hint to boost it to head of queue, so you are
>> almost certainly going to jump ahead of already queued writes. Which we
>> of course really do not.

Yeah, I think if we have tagged write command and flush tagged (or
barrier tagged) things can be pretty efficient.  Again, I'm much more
comfortable with separate opcodes for those rather than bits changing
the behavior.

Another idea Dongjun talked about while drinking in LSF was ranged
flush.  Not as flexible/efficient as the previous option but much less
intrusive and should help quite a bit, I think.

> I think that FUA was designed for a different use case than what Linux
> is using barriers for currently. The advantage with FUA is when you have
> "before barrier", "after barrier" and "don't care" sets, where only the
> specific things you care about ordering are in the before/after barrier
> sets. Then you can do this:
> 
> Issue all before barrier requests with FUA bit set
> Wait for all those to complete
> Issue all after barrier requests with FUA bit set
> Wait for all those to complete
> 
> Meanwhile a bunch of "don't care" requests could be going through on the
> device in the background. If we could do this, then I think there would
> be an advantage. Right now, it just saves a command to the drive when
> we're flushing on the post-barrier writes.
> 
> This would only be efficient with NCQ FUA, because regular FUA forces
> the requests to complete serially, whereas in this case we don't really
> care what order the individual requests finish, we just care about the
> ordering of the pre vs. post barrier requests.

Yeap, that makes sense too but that possibly requires intrusive changes
in fs layer and limited NCQ queue depth might become a bottleneck too.

>> I'm not too nervous about the FUA write commands, I hope we can safely
>> assume that if you set the FUA supported bit in the id AND the write fua
>> command doesn't get aborted, that FUA must work. Anything else would
>> just be an immensely stupid implementation. NCQ+FUA is more tricky, I
>> agree that it being just a command bit does make it more likely that it
>> could be ignored. And that is indeed a danger. Given state of NCQ in
>> early firmware drives, I would not at all be surprised if the drive
>> vendors screwed that up too.

Yeap, I bet someone did.  :-)

>> But, since we don't have the ordered bit for NCQ/FUA anyway, we do need
>> to drain the drive queue before issuing the WRITE/FUA. And at that point
>> we may as well not use the NCQ command, just go for the regular non-NCQ
>> FUA write. I think that should be safe.

Yeap.

> Aside from the issue above, as I mentioned elsewhere, lots of NCQ drives
> don't support non-NCQ FUA writes..

To me, using the NCQ FUA bit on such drives doesn't seem to be a good
idea.  Maybe I'm just too chicken but it's not like we can gain a lot
from doing FUA at this point.  Are there a lot of drives which support
NCQ but not FUA opcodes?

Thanks.

-- 
tejun
