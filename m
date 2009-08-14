Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbZHNWyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbZHNWyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbZHNWyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:54:13 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:27398 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241AbZHNWyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rm5B9cGAUbeLyzSwRHCrs3OPWBoLuKuNoOFKjXzuj/PeTqesRMayjXqMZS606GLegF
         qksHkwFP9GKt0s24B6m8UwD5LTFOLsN9U3y+fxb9tr/Ihuy0SyE24J0hCIDw+eMrQYwm
         GuZeBzi4hB7Mi+q8l1Yaa+KovcpvqU94x1gHQ=
MIME-Version: 1.0
In-Reply-To: <4A85DF1E.3050801@rtr.ca>
References: <200908122007.43522.ngupta@vflare.org>
	 <Pine.LNX.4.64.0908122312380.25501@sister.anvils>
	 <20090813151312.GA13559@linux.intel.com>
	 <20090813162621.GB1915@phenom2.trippelsdorf.de>
	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>
	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
	 <1250191095.3901.116.camel@mulgrave.site> <4A85DF1E.3050801@rtr.ca>
Date: Fri, 14 Aug 2009 18:54:11 -0400
Message-ID: <87f94c370908141554ia447f5fo87c74d5d8c517c1c@mail.gmail.com>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap 
	slot is freed)
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Mark Lord <liml@rtr.ca>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, david@lang.hm,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 6:03 PM, Mark Lord<liml@rtr.ca> wrote:
> James Bottomley wrote:
>>
>> On Thu, 2009-08-13 at 14:15 -0400, Greg Freemyer wrote:
>>>
>>> On Thu, Aug 13, 2009 at 12:33 PM, <david@lang.hm> wrote:
>>>>
>>>> On Thu, 13 Aug 2009, Markus Trippelsdorf wrote:
>>>>
>>>>> On Thu, Aug 13, 2009 at 08:13:12AM -0700, Matthew Wilcox wrote:
>>>>>>
>>>>>> I am planning a complete overhaul of the discard work.  Users can send
>>>>>> down discard requests as frequently as they like.  The block layer
>>>>>> will
>>>>>> cache them, and invalidate them if writes come through.  Periodically,
>>>>>> the block layer will send down a TRIM or an UNMAP (depending on the
>>>>>> underlying device) and get rid of the blocks that have remained
>>>>>> unwanted
>>>>>> in the interim.
>>>>>
>>>>> That is a very good idea. I've tested your original TRIM implementation
>>>>> on
>>>>> my Vertex yesterday and it was awful ;-). The SSD needs hundreds of
>>>>> milliseconds to digest a single TRIM command. And since your
>>>>> implementation
>>>>> sends a TRIM for each extent of each deleted file, the whole system is
>>>>> unusable after a short while.
>>>>> An optimal solution would be to consolidate the discard requests,
>>>>> bundle
>>>>> them and send them to the drive as infrequent as possible.
>>>>
>>>> or queue them up and send them when the drive is idle (you would need to
>>>> keep track to make sure the space isn't re-used)
>>>>
>>>> as an example, if you would consider spinning down a drive you don't
>>>> hurt
>>>> performance by sending accumulated trim commands.
>>>>
>>>> David Lang
>>>
>>> An alternate approach is the block layer maintain its own bitmap of
>>> used unused sectors / blocks. Unmap commands from the filesystem just
>>> cause the bitmap to be updated.  No other effect.
>>>
>>> (Big unknown: Where will the bitmap live between reboots?  Require DM
>>> volumes so we can have a dedicated bitmap volume in the mix to store
>>> the bitmap to? Maybe on mount, the filesystem has to be scanned to
>>> initially populate the bitmap?   Other options?)
>>
>> I wouldn't really have it live anywhere.  Discard is best effort; it's
>> not required for fs integrity.  As long as we don't discard an in-use
>> block we're free to do anything else (including forget to discard,
>> rediscard a discarded block etc).
>>
>> It is theoretically possible to run all of this from user space using
>> the fs mappings, a bit like a defrag command.
>
> ..
>
> Already a work-in-progress -- see my wiper.sh script on the hdparm page
> at sourceforge.  Trimming 50+GB of free space on a 120GB Vertex
> (over 100 million sectors) takes a *single* TRIM command,
> and completes in only a couple of seconds.
>
> Cheers
>
Mark,

What filesystems does your script support?  Running a tool like this
in the middle of the night makes a lot of since to me even from the
perspective of many / most enterprise users.

How do prevent a race where a block becomes used between userspace
asking status and it sending the discard request?

ps: I tried to pull wiper.sh straight from sourceforge, but I'm
getting some crazy page asking all sorts of questions and not letting
me bypass it.  I hope sourceforge is broken.  The other option is they
meant to do this. :(

Greg
-- 
Greg Freemyer
