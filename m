Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbZHMSXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbZHMSXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 14:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZHMSXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 14:23:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49089 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbZHMSXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 14:23:35 -0400
Message-ID: <4A8459F3.5060703@redhat.com>
Date: Thu, 13 Aug 2009 14:22:43 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
References: <200908122007.43522.ngupta@vflare.org>	 <Pine.LNX.4.64.0908122312380.25501@sister.anvils>	 <20090813151312.GA13559@linux.intel.com> <1250178192.3901.54.camel@mulgrave.site>
In-Reply-To: <1250178192.3901.54.camel@mulgrave.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 11:43 AM, James Bottomley wrote:
> On Thu, 2009-08-13 at 08:13 -0700, Matthew Wilcox wrote:
>    
>> On Wed, Aug 12, 2009 at 11:48:27PM +0100, Hugh Dickins wrote:
>>      
>>> But fundamentally, though I can see how this cutdown communication
>>> path is useful to compcache, I'd much rather deal with it by the more
>>> general discard route if we can.  (I'm one of those still puzzled by
>>> the way swap is mixed up with block device in compcache: probably
>>> because I never found time to pay attention when you explained.)
>>>
>>> You're right to question the utility of the current swap discard
>>> placement.  That code is almost a year old, written from a position
>>> of great ignorance, yet only now do we appear to be on the threshold
>>> of having an SSD which really supports TRIM (ah, the Linux ATA TRIM
>>> support seems to have gone missing now, but perhaps it's been
>>> waiting for a reality to check against too - Willy?).
>>>        
>> I am indeed waiting for hardware with TRIM support to appear on my
>> desk before resubmitting the TRIM code.  It'd also be nice to be able to
>> get some performance numbers.
>>
>>      
>>> I won't be surprised if we find that we need to move swap discard
>>> support much closer to swap_free (though I know from trying before
>>> that it's much messier there): in which case, even if we decided to
>>> keep your hotline to compcache (to avoid allocating bios etc.), it
>>> would be better placed alongside.
>>>        
>> It turns out there are a lot of tradeoffs involved with discard, and
>> they're different between TRIM and UNMAP.
>>
>> Let's start with UNMAP.  This SCSI command is used by giant arrays.
>> They want to do Thin Provisioning, so allocate physical storage to virtual
>> LUNs on demand, and want to deallocate it when they get an UNMAP command.
>> They allocate storage in large chunks (hundreds of kilobytes at a time).
>> They only care about discards that enable them to free an entire chunk.
>> The vast majority of users *do not care* about these arrays, because
>> they don't have one, and will never be able to afford one.  We should
>> ignore the desires of these vendors when designing our software.
>>      
>
> Fundamentally, unmap, trim and write_same do similar things, so
> realistically they all map to discard in linux.
>
> Ignoring the desires of the enterprise isn't an option, since they are a
> good base for us.  However, they really do need to step up with a useful
> patch set for discussion that does what they want, so in the interim I'm
> happy with any proposal that doesn't actively damage what the enterprise
> wants to do with trim/write_same.
>    

I definitely agree - the UNMAP support and the needs of array users is a 
critical part of the solution.

I would also dispute the contention that this is irrelevant to most 
users - even those of us who don't personally use arrays almost always 
use them indirectly since major banks, airlines, etc all use them to 
store our data :-)

>    
>> Solid State Drives are introducing an ATA command called TRIM.  SSDs
>> generally have an intenal mapping layer, and due to their low, low seek
>> penalty, will happily remap blocks anywhere on the flash.  They want
>> to know when a block isn't in use any more, so they don't have to copy
>> it around when they want to erase the chunk of storage that it's on.
>> The unfortunate thing about the TRIM command is that it's not NCQ, so
>> all NCQ commands have to finish, then we can send the TRIM command and
>> wait for it to finish, then we can send NCQ commands again.
>>      
>
> That's a bit of a silly protocol oversight ... I assume there's no way
> it can be corrected?
>
>    
>> So TRIM isn't free, and there's a better way for the drive to find
>> out that the contents of a block no longer matter -- write some new
>> data to it.  So if we just swapped a page in, and we're going to swap
>> something else back out again soon, just write it to the same location
>> instead of to a fresh location.  You've saved a command, and you've
>> saved the drive some work, plus you've allowed other users to continue
>> accessing the drive in the meantime.
>>
>> I am planning a complete overhaul of the discard work.  Users can send
>> down discard requests as frequently as they like.  The block layer will
>> cache them, and invalidate them if writes come through.  Periodically,
>> the block layer will send down a TRIM or an UNMAP (depending on the
>> underlying device) and get rid of the blocks that have remained unwanted
>> in the interim.
>>
>> Thoughts on that are welcome.
>>      
>
> What you're basically planning is discard accumulation ... it's
> certainly closer to what the enterprise is looking for, so no objections
> from me.
>
> James
>
>    

This sounds like a good approach to me as well. I think that both TRIM 
and UNMAP use case will benefit from coalescing these discard requests,

Ric

