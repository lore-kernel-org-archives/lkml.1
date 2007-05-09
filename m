Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbXEIJ2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbXEIJ2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbXEIJ1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:27:51 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:57312
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbXEIJ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:27:50 -0400
Date: Wed, 9 May 2007 02:25:10 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070509111515.0cb3e63a@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.64.0705090216030.2213@asgard.lang.hm>
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
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Cornelia Huck wrote:

> On Wed, 9 May 2007 01:33:14 -0700 (PDT),
> david@lang.hm wrote:
>
>> 1. why should different, unrelated busses need to wait for each other?
>> picking two, why can't you have SCSI and USB going through their timeouts
>> at the same time?
>
> If they don't have dependencies on each other, yes. Some busses should
> be finished before probing for others start (e.g. low-level busses).

I think we are agreeing on this, I was responding to your question of if 
we could get away to limiting things to one bus at a time.

>> 2. I'm not sure that you can always do the device enumeration before you
>> do the slow probing, there's another message in this thread that talks
>> about a USB device where you need to load firmware to it before you can
>> find out what is really there. in a case like this devices would either
>> show up in a random order during step #2, or they should not be added to
>> the system until step #3, which makes step #3 more then just waiting for
>> the async portions to finish.
>
> I'm not sure whether that is not really a question of "one depends upon
> the other". If the low level bus knows where to point its probe at, the
> higher level should be able to look at sane devices after the firmware
> has been loaded (or am I misunderstanding the situation here?)

makeing up an example

today the process would be
call driver X to initialize it's devices.

driver X follows these steps

1. see if a compatible chipset/device appears to be available

2. initialize the chipset/device (loading firmware)

3. query the now partially initialized chipset/device to see what specific 
options are enabled in the hardware

4. for each 'thing' that's enabled in hardware, initialize and register 
it.

step 2 can take a long time and so you want it to be async so that it's 
timeouts can be running in parallel (for that matter step 1 may have some 
timeouts as well)

however, you can't tell what devices to register until after step 3

so in at least some cases, it seems as if the registratin of devices needs 
to be after the async section.

Linus made a good case fo an example (hard drives) where the registration 
can happen first and fast, but the async section (spinning up) takes a 
while and could come second.

to acommodate both of these device models it seems to me that you can't 
defice either
async followed by sync
or
sync followed by async
but instead need to support the combined
sync followed by async followed by sync.

now, it's very possible that I'm mistaken and one of the two-part models 
can be used for everything, if so then it's definantly simpler to do so.

David Lang
