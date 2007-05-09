Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbXEIQVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbXEIQVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbXEIQVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:21:00 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:54664
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbXEIQU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:20:59 -0400
Date: Wed, 9 May 2007 09:18:10 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070509152024.1a57d82a@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.64.0705090910050.4467@asgard.lang.hm>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
 <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
 <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
 <20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
 <alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
 <Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
 <20070509095812.016035ee@gondolin.boeblingen.de.ibm.com>
 <Pine.LNX.4.64.0705090128180.2213@asgard.lang.hm>
 <20070509111515.0cb3e63a@gondolin.boeblingen.de.ibm.com>
 <Pine.LNX.4.64.0705090216030.2213@asgard.lang.hm>
 <20070509152024.1a57d82a@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Cornelia Huck wrote:

> On Wed, 9 May 2007 02:25:10 -0700 (PDT),
> david@lang.hm wrote:
>
>> makeing up an example
>>
>> today the process would be
>> call driver X to initialize it's devices.
>>
>> driver X follows these steps
>>
>> 1. see if a compatible chipset/device appears to be available
>>
>> 2. initialize the chipset/device (loading firmware)
>>
>> 3. query the now partially initialized chipset/device to see what specific
>> options are enabled in the hardware
>>
>> 4. for each 'thing' that's enabled in hardware, initialize and register
>> it.
>
> The sync ->probe() could return after step 1 (when it is clear the
> driver wants to bind to the device). The remainder should be done in
> the async function, so that the bus could go on with other devices. The
> driver should then signal when it is done with its registrations.

but then won't the devices get registered in a random order? (i.e. 
whenever the async portion finishes the probing and finds the details of 
what there is to register)

>> to acommodate both of these device models it seems to me that you can't
>> defice either
>> async followed by sync
>> or
>> sync followed by async
>> but instead need to support the combined
>> sync followed by async followed by sync.
>>
>> now, it's very possible that I'm mistaken and one of the two-part models
>> can be used for everything, if so then it's definantly simpler to do so.
>
> Hm, maybe I'm dense, but I really don't understand the problem here.
> Why should (optional) sync followed by (optional) async followed by bus
> synchonization not cover all cases? The async portion can also do some
> "sync" stuff and then signal completion, can't it?
>
> If you're worried about notifications to userspace, you could first
> suppress the add uevent via uevent_suppress and then generate it when
> you signal completion to the bus.

I'm not worried about notification to userspace, I'm worried about devices 
getting registered during the async stage appearing in different orders on 
different boots due to different timeings.

if you can identify the device well enough to register it quickly then the 
approach that Linus proposed works well, which is

sync probe, identify devices, register devices
async initialize devices
wait for all async to complete

however I'm talking about cases where you can't fully identify the devices 
(at least not well enough to register them with the kernel) and am saying 
that doing

sync probe
async initialize device, register device
wait for all async to complete

results in unpredictable device ordering, but if instead you did

sync probe
async initialize device
sync wait for all async to complete, register device

you can get back to predictable ordering

David Lang

