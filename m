Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbXBVWmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbXBVWmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXBVWmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:42:07 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:54917 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbXBVWmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:42:05 -0500
Message-ID: <45DE1BD5.1000902@emc.com>
Date: Thu, 22 Feb 2007 17:40:21 -0500
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Tejun Heo <htejun@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Lord <mlord@pobox.com>, Dongjun Shin <d.j.shin@samsung.com>,
       Hannes Reinecke <hare@suse.de>
Subject: Re: libata FUA revisited
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no> <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no> <45D104F3.7040602@shaw.ca> <45D1D72D.9020509@gmail.com> <45D252CD.5010303@shaw.ca> <45D25CF2.5030508@gmail.com> <20070215180023.GA4438@kernel.dk> <45D9FE7B <20070221084613.GB3924@kernel.dk>
In-Reply-To: <20070221084613.GB3924@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.2.22.142934
X-PerlMx-Spam: Gauge=, SPAM=2%, Reasons='EMC_FROM_0+ -2, RDNS_NXDOMAIN 0, RDNS_SUSP_GENERIC 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Feb 21 2007, Tejun Heo wrote:
>> [cc'ing Ric, Hannes and Dongjun, Hello.  Feel free to drag other people in.]
>>
>> Robert Hancock wrote:
>>> Jens Axboe wrote:
>>>> But we can't really change that, since you need the cache flushed before
>>>> issuing the FUA write. I've been advocating for an ordered bit for
>>>> years, so that we could just do:
>>>>
>>>> 3. w/FUA+ORDERED
>>>>
>>>> normal operation -> barrier issued -> write barrier FUA+ORDERED
>>>>  -> normal operation resumes
>>>>
>>>> So we don't have to serialize everything both at the block and device
>>>> level. I would have made FUA imply this already, but apparently it's not
>>>> what MS wanted FUA for, so... The current implementations take the FUA
>>>> bit (or WRITE FUA) as a hint to boost it to head of queue, so you are
>>>> almost certainly going to jump ahead of already queued writes. Which we
>>>> of course really do not.
>> Yeah, I think if we have tagged write command and flush tagged (or
>> barrier tagged) things can be pretty efficient.  Again, I'm much more
>> comfortable with separate opcodes for those rather than bits changing
>> the behavior.
> 
> ORDERED+FUA NCQ would still be preferable to an NCQ enabled flush
> command, though.
> 
>> Another idea Dongjun talked about while drinking in LSF was ranged
>> flush.  Not as flexible/efficient as the previous option but much less
>> intrusive and should help quite a bit, I think.
> 
> But that requires extensive tracking, I'm not so sure the implementation
> of that for barriers would be very clean. It'd probably be good for
> fsync, though.
> 

If we could invent any mechanism, it would seem that it would be nicest 
if we could have independent sequences of IO requests (say with a 
distinct tag per sequence) and an ability to issue a per sequence flush 
request.  That might tie into the QOS support, but would still have 
issues when you try to map it back up the stack through the journal and 
into application level promises of data integrity.

For example, in data journal mode, we would probably need to flush not 
only the transaction level data, but also all data sequences that had 
IO's in that transaction first.

Pretty rapidly, we start to get into the database notions of nested 
transactions and so on ;-)

ric

