Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXEHU2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXEHU2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXEHU22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:28:28 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:53261
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbXEHU21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:28:27 -0400
Date: Tue, 8 May 2007 13:26:00 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
 <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
 <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
 <20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
 <alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Linus Torvalds wrote:

> Instead of changing existign probe functionality to be asynchronous, we
> could *add* a new and asynchronous part to it. For example, we could make
> the rule for PCI - or other bus - devices be:
>
> - the bus will *first* call the "probe()" function synchronously.
>
> - after that one has completed, we will call "probe_async()"
>   asynchronously at some point (it ie might be scheduled immediately
>   after the "probe()" call, but delayed by some arbitrary issues like
>   just already having too many asynchronous probes on-going or similar)
>
> (A variation of the above might be that *everybody*s synchronous probe
> function will be called first, and then the asynchronous probe functions
> will be called only when they are all done. That might help with drivers
> that have dependencies between different PCI functions - Cardbus comes to
> mind, where the different slots look like independent PCI devices, but
> slot zero is literally the master and controls some of the functions on
> slot 1 too - similar issues may well happen in other multi-function
> devices, and it might simplify things if you knew that the serial probe
> had completed fully before the asynchronous parallel part even starts).

is it really enough to do the sync followed by the async piece?

it seems to me that there may be a need for three steps

1. prep (sync, what we do today)
which will all complete before
2. parallel (async)
which will all complete before
3. cleanup (sync)

for some busses you can do the device enumeration in the prep phase, but I 
would expect that for others you can't enumerate the devices until you 
actually go looking for them. so by allowing the cleanup phase you have a 
spot that can order everything as if the second phase was sequential.

I would expect that almost no drivers would use all three, but I could see 
some useing #1 and #2 while others use #2 and #3

in any case there needs to be a way to wait until the async portion 
finishes before going on to next steps (you don't want to try to probe 
drives for md partitions until the drives have finished spinning up for 
example)

David Lang
