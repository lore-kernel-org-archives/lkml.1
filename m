Return-Path: <linux-kernel-owner+w=401wt.eu-S934368AbXC3AJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368AbXC3AJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 20:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934366AbXC3AJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 20:09:21 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:44656 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934367AbXC3AJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 20:09:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=R0cbNsHzuVkGqvfhEBQ14XJ/yEVo8JTg7ZqGsbHBhFcfMzWcSrwj6P30gI+zlG7zI4AIOHbTYfJyRCwiesZAMWx93vEaCQAs4CP73LWaIZx7zTGmKqHPd/rnupz6tZnbD6ialGvBOoMrUUMlxukqWxMFmHG6OwrK9/PoA+Az8Q8=  ;
X-YMail-OSG: eKe37akVM1n7KFEpWzKnbYrEjYDOtBPX9zDnpcFidkEgjkk7XUMV7Z2Siap3cl_p3R38SUtyTHdvZBIrd3QUBYDW3Uo91tqxUFpa_VJULdwwdXmaQzA-
From: David Brownell <david-b@pacbell.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [linux-pm] [3/6] 2.6.21-rc4: known regressions
Date: Thu, 29 Mar 2007 17:09:14 -0700
User-Agent: KMail/1.7.1
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, gregkh@suse.de,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, jgarzik@pobox.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-pm@lists.linux-foundation.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703291533.38002.david-b@pacbell.net> <200703300129.27474.maximlevitsky@gmail.com>
In-Reply-To: <200703300129.27474.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291709.17085.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 4:29 pm, Maxim Levitsky wrote:
> On Friday 30 March 2007 00:33:35 David Brownell wrote:
> > On Wednesday 28 March 2007 2:27 pm, Maxim wrote:

> > > 	So the only way out is to emulate RTC using HPET,
> > > 	It is done this way in old rtc driver, rtc-cmos should do the same.
> > 
> > No.  Patches like
> > 
> >   http://marc.info/?l=linux-kernel&m=117219531503973&w=2

also:   http://marc.info/?l=linux-kernel&m=117219531526317&w=2

> > should be merged (I hope they're in the 2.6.22 queue!), making
> > HPET run in "Standard Mode" so that HPET can stop sticking its
> > fingers in code where they don't belong.
> >
> > ...
>
> 	It is not that simple,
> 
> 	Only in legacy replacement mode HPET can be put on IRQ0 (and sadly  IRQ8)
> 	At least this is true on some systems, on mine for example

Right, that's the entire point of legacy replacement mode.

But so what?  In standard mode, HPET just uses other IRQs.
Nothing would care about irq0, and irq8 would be used by
the RTC as necessary.


> 	this will make it difficult to use it as a clockevents source

Why?  It's not like the clockevent logic cares what IRQ a given
programmable timer uses.  So long as the HPET driver can receive
its IRQ, it'll make a fine clockevent.  There's no reason to have
HPET prevent other drivers from working, by insisting it use that
nasty "prevent other hardware from issuing IRQs" mode.

The patches from Venkatesh sure seem to have behaved for him.
And while he might have complained about difficulty, I think
that'd be more likely due to the SMP issues he also addressed
than because of some (historical?) attachment to irq0.


> 	Not to mention the fact that current code assumes that BIOS
> 	assigned IRQs to all timers which is not true on my system. 

Getting IRQ routing sorted out is a problem that's been solved
numerous times before.  And again, the patches referenced above
seem to have resolved any such issues.


> 	What is wrong with relying on HPET to provide RTC IRQ ?

For starters, it's not an RTC.  Why in the world would you want to
make the OS think it's an RTC ... unless you're Microsoft, and are
desperate to get another periodic timer (and don't much care about
the other RTC functionality?


... that's all off-topic for 2.6.21 regressions though; it's too
late to merge x86_64 clockevent support, or fix HPET issues like
not using "standard mode".

- Dave

