Return-Path: <linux-kernel-owner+w=401wt.eu-S1031933AbXEHUCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031933AbXEHUCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031927AbXEHUCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:02:44 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031925AbXEHUCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:02:40 -0400
Date: Tue, 8 May 2007 13:01:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
 <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
 <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
 <20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 May 2007, Linus Torvalds wrote:
> 
> But the final nail in the coffin is that doing it at the bus level is 
> INFERIOR. As you yourself admitted, it's better to do some things 
> synchronously.

Side note: there may well be clever combinations of "bus side" support 
*together* with per-device rules.

For example, right now we probe devices by calling their "probe()" 
routines synchronously. Changing that to be asynchronous simply isn't an 
option, because we've seen drivers that get  unhappy (and the hotplug 
argument isn't an argument: *most* drivers aren't even hotplug-capable 
anyway).

BUT. 

Instead of changing existign probe functionality to be asynchronous, we 
could *add* a new and asynchronous part to it. For example, we could make 
the rule for PCI - or other bus - devices be:

 - the bus will *first* call the "probe()" function synchronously.

 - after that one has completed, we will call "probe_async()" 
   asynchronously at some point (it ie might be scheduled immediately 
   after the "probe()" call, but delayed by some arbitrary issues like 
   just already having too many asynchronous probes on-going or similar)

(A variation of the above might be that *everybody*s synchronous probe 
function will be called first, and then the asynchronous probe functions 
will be called only when they are all done. That might help with drivers 
that have dependencies between different PCI functions - Cardbus comes to 
mind, where the different slots look like independent PCI devices, but 
slot zero is literally the master and controls some of the functions on 
slot 1 too - similar issues may well happen in other multi-function 
devices, and it might simplify things if you knew that the serial probe 
had completed fully before the asynchronous parallel part even starts).

So an unmodified driver would basically work exactly like it does now, but 
if a driver is happy with being called asynchronously, it could just 
change it's 

	.probe = mydriver_probe

thing into a

	.probe_async = mydriver_probe

and we can do that ona per-driver basis with that kind of really simple 
one-liner change.

In fact, there is nothing wrong with having *both* a synchronous part, and 
an async part:

	.probe = mydriver_setup,
	.probe_async = mydriver_spin_up_and_probe_devices,

and it would do basic setup (including, for example, the fast enumeration 
of whatever devices are connected) synchronously, but then do anything 
more in the async part - and the async part would still be guaranteed that 
the setup has been run by the time it is scheduled (but not really have 
any other guarantees).

Hmm? Would something like this work? I dunno, but it seems a hell of a lot 
safer and more capable than the aborted PCI multithreaded probing that was 
an "all or nothing" approach.

		Linus
