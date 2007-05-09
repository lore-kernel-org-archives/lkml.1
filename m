Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbXEIIf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbXEIIf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXEIIfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:35:50 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:58412
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbXEIIft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:35:49 -0400
Date: Wed, 9 May 2007 01:33:14 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070509095812.016035ee@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.64.0705090128180.2213@asgard.lang.hm>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
 <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
 <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
 <20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
 <alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
 <Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
 <20070509095812.016035ee@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Cornelia Huck wrote:

> On Tue, 8 May 2007 13:26:00 -0700 (PDT),
> david@lang.hm wrote:
>
>> is it really enough to do the sync followed by the async piece?
>>
>> it seems to me that there may be a need for three steps
>>
>> 1. prep (sync, what we do today)
>> which will all complete before
>> 2. parallel (async)
>> which will all complete before
>> 3. cleanup (sync)
>>
>> for some busses you can do the device enumeration in the prep phase, but I
>> would expect that for others you can't enumerate the devices until you
>> actually go looking for them. so by allowing the cleanup phase you have a
>> spot that can order everything as if the second phase was sequential.
>>
>> I would expect that almost no drivers would use all three, but I could see
>> some useing #1 and #2 while others use #2 and #3
>
> Hm, how about:
> 1. ->probe() called (wait until it is finished)
> 2. ->probe_async() called (only kick off, don't wait, go to next device)
> 3. bus waits until all async probes have returned
>
> This would imply a wait mechanism on the bus, like upping a counter for
> each successfully called ->probe_async(), the driver downing the
> counter when all actions triggered by ->probe_async() have finshed, and
> the bus waiting until the counter has reached 0.
>
> (Individual drivers can have 1., 2., or 1. & 2. A bus may support 1.
> (like now), 2. & 3. or 1., 2. and 3.)
>
>> in any case there needs to be a way to wait until the async portion
>> finishes before going on to next steps (you don't want to try to probe
>> drives for md partitions until the drives have finished spinning up for
>> example)
>
> Agreed. Would it be enough if we only have one bus in flight
> simuntaneously?

two things I see

1. why should different, unrelated busses need to wait for each other? 
picking two, why can't you have SCSI and USB going through their timeouts 
at the same time?

2. I'm not sure that you can always do the device enumeration before you 
do the slow probing, there's another message in this thread that talks 
about a USB device where you need to load firmware to it before you can 
find out what is really there. in a case like this devices would either 
show up in a random order during step #2, or they should not be added to 
the system until step #3, which makes step #3 more then just waiting for 
the async portions to finish.

David Lang
