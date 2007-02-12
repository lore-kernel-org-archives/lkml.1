Return-Path: <linux-kernel-owner+w=401wt.eu-S1030195AbXBLVqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030195AbXBLVqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030200AbXBLVqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:46:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41616 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030199AbXBLVqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:46:45 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Doug Thompson <norsk5@yahoo.com>
Subject: Re: -mm merge plans for 2.6.21
Date: Mon, 12 Feb 2007 22:46:38 +0100
User-Agent: KMail/1.9.5
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <484858.10028.qm@web50102.mail.yahoo.com>
In-Reply-To: <484858.10028.qm@web50102.mail.yahoo.com>
Organization: -
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702122246.38703.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I am currently developing enhancements to EDAC that provide for L1, L2,
> etc cache ECC event harvesting,

mce.c + mcelog do that already for all x86-64 cpus because
that's all reported as standard x86 machine checks.

> DMA ECC event harvest, interconnect 
> harvesting, and other chipset/processing ECC event harvesting. Some
> events are polled others are software interupt delivered. This is on an
> arch OTHER than x86 or x86_64. But these EDAC features can be used on
> the x86/x86_64 as well.

Well at least the CPU features are redundant.

> As there IS an ECC event consumption race between MCE and EDAC, then at
> least a 'config' mechanism can be utilized to switch between the two. 

Possibly, but it's still unclear why you want another interface
if an already existing one is there and works.

Anyways if you feel strongly about having redundant interfaces
you could probably do it.  For the CPU caches etc. it shouldn't
make much difference, although it is unlikely to be very useful
either.

But as I wrote earlier EDAC could be made a consumer of mce.c
events and munge them in whatever format you like there.

Basically it could be an additional presentation layer
for Alan's enterprise users with the hardware schematics
at hand.

My main objection to the K8 northbridge control was though
that it was done in a somewhat non practical way in EDAC (no
useful decoding) and it actually steals the events from the subsystem
that does the useful decoding.
 
> Better yet,

Beauty in the eye of the beholder i guess @)

> I would like to be able to capture the MCE events and 
> funnel them to EDAC, when loaded, as a downstream consumer of the MCE
> event stream. Then EDAC would process the information and then proceed
> to inform whether the event was handled or not by EDAC. Additionally,
> it would inform whether a panic should occur or not.

Yes, just mce.c has all that logic already. Not sure what adding
another layer would help there.

[In fact it has too much logic already, more powerful than current x86 CPUs
can support]

Or do you want that to be decided by user space code? That would seem
somewhat risky to me.

> When EDAC is not loaded, then MCE would act as it does now.
> 
> The downside with both EDAC and MCE being in place, is that there would
> be ONE MCE processing pattern for the AMD x86_64 processors 

No, mce.c handles all the machine checks on Intel CPUs just fine too.

The thing it doesn't do is process chipset events. I can see
the value of external drivers here, although that should be hopefully
a temporary state until Intel finally has integrated memory controllers
too.

Ok PCI error reporting will be likely always separate, but I'm not
sure that it fits very well because it should rather feed directly
into the drivers for them to report IO errors up the normal stacks.

> and the 
> EDAC pattern for all the other archs/processors. As far as I can tell,
> other MCE processors don't generate the events as advertized. Maybe I
> am wrong on that, but I can't find them. How much hardware specific
> detail should be exported?

All MCE capable processors generate events,
although how many of them are recoverable greatly varies
(often you just get a unrecoverable exception) 

> 
> I assert the better solution is to have the ability to hook into the
> MCE event stream by the EDAC K8 driver, then provide action rules (EDAC
> controls) 

The latest (pre released) mcelog 0.8pre has triggers for excessive
memory errors per DIMM. Is that something you want to do for EDAC too? 

> As to the size of the MCE code doing everything EDAC K8 does, that is
> mostly true. BUT then the x86_64 MCE mechanism becomes the exception
> path. 

Sorry you lost me on that one.

-Andi
