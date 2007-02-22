Return-Path: <linux-kernel-owner+w=401wt.eu-S1751997AbXBVWn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbXBVWn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbXBVWn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:43:29 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:55107 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbXBVWn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:43:27 -0500
Message-ID: <45DE1A7C.1030500@emc.com>
Date: Thu, 22 Feb 2007 17:34:36 -0500
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Robert Hancock <hancockr@shaw.ca>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Lord <mlord@pobox.com>, Dongjun Shin <d.j.shin@samsung.com>,
       Hannes Reinecke <hare@suse.de>
Subject: Re: libata FUA revisited
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no> <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no> <45D104F3.7040602@shaw.ca> <45D1D72D.9020509@gmail.com> <45D252CD.5010303@shaw.ca> <45D25CF2.5030508@gmail.com> <20070215180023.GA4438@kernel.dk> <45D9FE7B <45DC04DF.8040002@gmail.com>
In-Reply-To: <45DC04DF.8040002@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.2.22.140435
X-PerlMx-Spam: Gauge=, SPAM=2%, Reasons='EMC_FROM_0+ -2, RDNS_NXDOMAIN 0, RDNS_SUSP_GENERIC 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> [cc'ing Ric, Hannes and Dongjun, Hello.  Feel free to drag other people in.]
> 
> Robert Hancock wrote:
>> Jens Axboe wrote:
>>> But we can't really change that, since you need the cache flushed before
>>> issuing the FUA write. I've been advocating for an ordered bit for
>>> years, so that we could just do:
>>>
>>> 3. w/FUA+ORDERED
>>>
>>> normal operation -> barrier issued -> write barrier FUA+ORDERED
>>>  -> normal operation resumes
>>>
>>> So we don't have to serialize everything both at the block and device
>>> level. I would have made FUA imply this already, but apparently it's not
>>> what MS wanted FUA for, so... The current implementations take the FUA
>>> bit (or WRITE FUA) as a hint to boost it to head of queue, so you are
>>> almost certainly going to jump ahead of already queued writes. Which we
>>> of course really do not.
> 
> Yeah, I think if we have tagged write command and flush tagged (or
> barrier tagged) things can be pretty efficient.  Again, I'm much more
> comfortable with separate opcodes for those rather than bits changing
> the behavior.
> 
> Another idea Dongjun talked about while drinking in LSF was ranged
> flush.  Not as flexible/efficient as the previous option but much less
> intrusive and should help quite a bit, I think.
> 
>> I think that FUA was designed for a different use case than what Linux
>> is using barriers for currently. The advantage with FUA is when you have
>> "before barrier", "after barrier" and "don't care" sets, where only the
>> specific things you care about ordering are in the before/after barrier
>> sets. Then you can do this:
>>
>> Issue all before barrier requests with FUA bit set
>> Wait for all those to complete
>> Issue all after barrier requests with FUA bit set
>> Wait for all those to complete

A couple of issues with this would be in how to support our current 
semantics of fsync().  Today, the flush behavior of the barrier/fsync 
combination means that applications can have a hard promise of data on 
platter for any file after a successful fsync command.

If I understand correctly, to get a similar semantic from a pure FUA 
implementation would require us to tag all file IO as FUA.

I suspect that this would actually be less efficient since it would not 
allow the drives to reorder IO's up to the point that we actually care 
(fsync time).

The other big user of barriers is the internal transaction of journaled 
file systems.  It would seem that we would need to tag each write from 
the journal with a FUA IO as well.  Again, we might actually go more 
slowly in some cases as you mention below.

The limited queue depth of NCQ would seem to make it much harder to have 
a win in this case...

>>
>> Meanwhile a bunch of "don't care" requests could be going through on the
>> device in the background. If we could do this, then I think there would
>> be an advantage. Right now, it just saves a command to the drive when
>> we're flushing on the post-barrier writes.
>>
>> This would only be efficient with NCQ FUA, because regular FUA forces
>> the requests to complete serially, whereas in this case we don't really
>> care what order the individual requests finish, we just care about the
>> ordering of the pre vs. post barrier requests.
> 
> Yeap, that makes sense too but that possibly requires intrusive changes
> in fs layer and limited NCQ queue depth might become a bottleneck too.
> 
>>> I'm not too nervous about the FUA write commands, I hope we can safely
>>> assume that if you set the FUA supported bit in the id AND the write fua
>>> command doesn't get aborted, that FUA must work. Anything else would
>>> just be an immensely stupid implementation. NCQ+FUA is more tricky, I
>>> agree that it being just a command bit does make it more likely that it
>>> could be ignored. And that is indeed a danger. Given state of NCQ in
>>> early firmware drives, I would not at all be surprised if the drive
>>> vendors screwed that up too.
> 
> Yeap, I bet someone did.  :-)
> 
>>> But, since we don't have the ordered bit for NCQ/FUA anyway, we do need
>>> to drain the drive queue before issuing the WRITE/FUA. And at that point
>>> we may as well not use the NCQ command, just go for the regular non-NCQ
>>> FUA write. I think that should be safe.
> 
> Yeap.
> 
>> Aside from the issue above, as I mentioned elsewhere, lots of NCQ drives
>> don't support non-NCQ FUA writes..
> 
> To me, using the NCQ FUA bit on such drives doesn't seem to be a good
> idea.  Maybe I'm just too chicken but it's not like we can gain a lot
> from doing FUA at this point.  Are there a lot of drives which support
> NCQ but not FUA opcodes?
> 
> Thanks.
> 

Anything new (firmware included) is likely to be shaky on initial 
deployment.  Caution is certainly the way to go on this ;-)

ric


