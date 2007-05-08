Return-Path: <linux-kernel-owner+w=401wt.eu-S967729AbXEHUwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967729AbXEHUwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934439AbXEHUwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:52:34 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:40481 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934437AbXEHUwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:52:33 -0400
Date: Tue, 8 May 2007 22:51:59 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070508225159.3442563f@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508141149.GJ4226@stusta.de>
	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
	<20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
	<20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
	<alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 13:01:21 -0700 (PDT),
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Instead of changing existign probe functionality to be asynchronous, we 
> could *add* a new and asynchronous part to it. For example, we could make 
> the rule for PCI - or other bus - devices be:
> 
>  - the bus will *first* call the "probe()" function synchronously.
> 
>  - after that one has completed, we will call "probe_async()" 
>    asynchronously at some point (it ie might be scheduled immediately 
>    after the "probe()" call, but delayed by some arbitrary issues like 
>    just already having too many asynchronous probes on-going or similar)

Hm. This would mean that probe() would be the decision "I want to use
this device", while probe_async() would be "setup my device, may take
some time"? Could work.

> So an unmodified driver would basically work exactly like it does now, but 
> if a driver is happy with being called asynchronously, it could just 
> change it's 
> 
> 	.probe = mydriver_probe
> 
> thing into a
> 
> 	.probe_async = mydriver_probe
> 
> and we can do that ona per-driver basis with that kind of really simple 
> one-liner change.

But probe would return int, while probe_async would return void? Two
liner :)

> 
> In fact, there is nothing wrong with having *both* a synchronous part, and 
> an async part:
> 
> 	.probe = mydriver_setup,
> 	.probe_async = mydriver_spin_up_and_probe_devices,
> 
> and it would do basic setup (including, for example, the fast enumeration 
> of whatever devices are connected) synchronously, but then do anything 
> more in the async part - and the async part would still be guaranteed that 
> the setup has been run by the time it is scheduled (but not really have 
> any other guarantees).

Looks like an idea.

I'll sleep on it, just too tired to make sense.
