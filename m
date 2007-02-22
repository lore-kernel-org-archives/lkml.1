Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbXBVWqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbXBVWqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXBVWqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:46:09 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:55461 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbXBVWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:46:08 -0500
Message-ID: <45DE1CEB.4030107@emc.com>
Date: Thu, 22 Feb 2007 17:44:59 -0500
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Lord <mlord@pobox.com>, Dongjun Shin <d.j.shin@samsung.com>,
       Hannes Reinecke <hare@suse.de>
Subject: Re: libata FUA revisited
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no> <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no> <45D104F3.7040602@shaw.ca> <45D1D72D.9020509@gmail.com> <45D252CD.5010303@shaw.ca> <45D25CF2.5030508@gmail.com> <20070215180023.GA4438@kernel.dk> <45D9FE7B <45DC0983.6000709@gmail.com>
In-Reply-To: <45DC0983.6000709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.2.22.142934
X-PerlMx-Spam: Gauge=, SPAM=2%, Reasons='EMC_FROM_0+ -2, RDNS_NXDOMAIN 0, RDNS_SUSP_GENERIC 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Jens Axboe wrote:
>> On Wed, Feb 21 2007, Tejun Heo wrote:
>>> [cc'ing Ric, Hannes and Dongjun, Hello.  Feel free to drag other people in.]
>>>
>>> Robert Hancock wrote:
>>>> Jens Axboe wrote:
>>>>> But we can't really change that, since you need the cache flushed before
>>>>> issuing the FUA write. I've been advocating for an ordered bit for
>>>>> years, so that we could just do:
>>>>>
>>>>> 3. w/FUA+ORDERED
>>>>>
>>>>> normal operation -> barrier issued -> write barrier FUA+ORDERED
>>>>>  -> normal operation resumes
>>>>>
>>>>> So we don't have to serialize everything both at the block and device
>>>>> level. I would have made FUA imply this already, but apparently it's not
>>>>> what MS wanted FUA for, so... The current implementations take the FUA
>>>>> bit (or WRITE FUA) as a hint to boost it to head of queue, so you are
>>>>> almost certainly going to jump ahead of already queued writes. Which we
>>>>> of course really do not.
>>> Yeah, I think if we have tagged write command and flush tagged (or
>>> barrier tagged) things can be pretty efficient.  Again, I'm much more
>>> comfortable with separate opcodes for those rather than bits changing
>>> the behavior.
>> ORDERED+FUA NCQ would still be preferable to an NCQ enabled flush
>> command, though.
> 
> I think we're talking about two different things here.
> 
> 1. The barrier write (FUA write) combined with flush.  I think it would
> help improving the performance but I think issuing two commands
> shouldn't be too slower than issuing one combined command unless it
> causes extra physical activity (moving head, etc...).
> 
> 2. FLUSH currently flushes all writes.  If we can mark certain commands
> requiring ordering, we can selectively flush or order necessary writes.
>  (No need to flush 16M buffer all over the disk when only journal needs
> barriering)

We can certainly (given time to play in the lab!) try to measure this in 
with a micro-benchmark (with an analyzer or with block trace?).

A normal flush command in my old tests seemed to be in the 20 ms range 
(mixed in with and occasional "freebie" cache flush which returns in 50 
usecs or so - cache must be empty).


>>> Another idea Dongjun talked about while drinking in LSF was ranged
>>> flush.  Not as flexible/efficient as the previous option but much less
>>> intrusive and should help quite a bit, I think.
>> But that requires extensive tracking, I'm not so sure the implementation
>> of that for barriers would be very clean. It'd probably be good for
>> fsync, though.
> 
> I was mostly thinking about journal area.  Using it for other purposes
> would incur a lot of complexity.  :-(
> 

