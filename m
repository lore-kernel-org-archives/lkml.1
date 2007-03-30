Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbXC3Bsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbXC3Bsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 21:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXC3Bsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 21:48:52 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:42487 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbXC3Bsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 21:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=es9waty+iJmglbAkXMYLjyHpvyg69eYAWRnuTKcS4XOo3bpZ5k3db6ezxegvy3jWeBVkNLBgNOg9KetSlBsmtPWlCx9chepGReec9B7+Z4oTaaijfSFpcz4rOFR/ONE/qaLIUxbobJYX1T0bbXbq9k+xS3nYJhcew316SIPnJtE=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [3/6] 2.6.21-rc4: known regressions
Date: Fri, 30 Mar 2007 03:48:38 +0300
User-Agent: KMail/1.9.6
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
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703300129.27474.maximlevitsky@gmail.com> <200703291709.17085.david-b@pacbell.net>
In-Reply-To: <200703291709.17085.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703300348.38402.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 March 2007 03:09:14 David Brownell wrote:
> On Thursday 29 March 2007 4:29 pm, Maxim Levitsky wrote:
> > On Friday 30 March 2007 00:33:35 David Brownell wrote:
> > > On Wednesday 28 March 2007 2:27 pm, Maxim wrote:
> 
> > > > 	So the only way out is to emulate RTC using HPET,
> > > > 	It is done this way in old rtc driver, rtc-cmos should do the same.
> > > 
> > > No.  Patches like
> > > 
> > >   http://marc.info/?l=linux-kernel&m=117219531503973&w=2
> 
> also:   http://marc.info/?l=linux-kernel&m=117219531526317&w=2
> 
> > > should be merged (I hope they're in the 2.6.22 queue!), making
> > > HPET run in "Standard Mode" so that HPET can stop sticking its
> > > fingers in code where they don't belong.
> > >
> > > ...
> >
> > 	It is not that simple,
> > 
> > 	Only in legacy replacement mode HPET can be put on IRQ0 (and sadly  IRQ8)
> > 	At least this is true on some systems, on mine for example
> 
> Right, that's the entire point of legacy replacement mode.
> 
> But so what?  In standard mode, HPET just uses other IRQs.
> Nothing would care about irq0, and irq8 would be used by
> the RTC as necessary.
> 
> 
> > 	this will make it difficult to use it as a clockevents source
> 
> Why?  It's not like the clockevent logic cares what IRQ a given
> programmable timer uses.  So long as the HPET driver can receive
> its IRQ, it'll make a fine clockevent.  There's no reason to have
> HPET prevent other drivers from working, by insisting it use that
> nasty "prevent other hardware from issuing IRQs" mode.
> 
> The patches from Venkatesh sure seem to have behaved for him.
> And while he might have complained about difficulty, I think
> that'd be more likely due to the SMP issues he also addressed
> than because of some (historical?) attachment to irq0.
> 
> 
> > 	Not to mention the fact that current code assumes that BIOS
> > 	assigned IRQs to all timers which is not true on my system. 
> 
> Getting IRQ routing sorted out is a problem that's been solved
> numerous times before.  And again, the patches referenced above
> seem to have resolved any such issues.
No they don't, 

First patch does that:

                        hd.hd_irq[i] = (timer->hpet_config &
                                        Tn_INT_ROUTE_CNF_MASK) >>                                
					Tn_INT_ROUTE_CNF_SHIFT;

This just reads values assigned by BIOS.


> 
> 
> > 	What is wrong with relying on HPET to provide RTC IRQ ?
> 
> For starters, it's not an RTC.  Why in the world would you want to
> make the OS think it's an RTC ... unless you're Microsoft, and are
> desperate to get another periodic timer (and don't much care about
> the other RTC functionality?
> 
> 
> ... that's all off-topic for 2.6.21 regressions though; it's too
> late to merge x86_64 clockevent support, or fix HPET issues like
> not using "standard mode".
> 
> - Dave
> 
> 

Hi,
	I feel that you are right,

	You meant that one of HPET timers will be used as clock source and will be assigned some IRQ (not IRQ0)
	
	Seems fine,

	Only one thing: the kernel must assign IRQs to HPETS , relying on bios is not good,
	Also the IRQ for clocksource should be not shared, but maybe I am wrong here 
	(I am afraid that latencies might be a problem here)

	By the way I never thought about the fact that legacy replacement mode  is a 'virtual legacy'

	I mean that it is intended to simulate RTCs and PITs on systems that don't have them, am I right here ?
	HPET spec says that RTC is still requred to provide all its usial functions except periodic freq.

	Best regards,
		Maxim Levitsky
