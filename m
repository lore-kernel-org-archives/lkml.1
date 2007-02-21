Return-Path: <linux-kernel-owner+w=401wt.eu-S1423019AbXBUUDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423019AbXBUUDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423014AbXBUUDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:03:04 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:48914 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423019AbXBUUDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:03:01 -0500
Subject: Re: Linux 2.6.21-rc1
From: Daniel Walker <dwalker@mvista.com>
To: tglx@linutronix.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1172085792.25076.119.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
	 <1172078340.8577.43.camel@imap.mvista.com>
	 <1172079671.25076.80.camel@localhost.localdomain>
	 <1172079523.8577.48.camel@imap.mvista.com>
	 <1172081931.25076.95.camel@localhost.localdomain>
	 <1172082200.8577.56.camel@imap.mvista.com>
	 <1172085792.25076.119.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 12:00:50 -0800
Message-Id: <1172088050.8577.71.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 20:23 +0100, Thomas Gleixner wrote:
> On Wed, 2007-02-21 at 10:23 -0800, Daniel Walker wrote:
> > Right, but eventually there isn't a regular timer interrupt through the
> > io-apic. I don't think in the past IRQ0 stops without the system
> > crashing, so check_timer() could assume the timer (IRQ0) is _always_
> > regular.
> > 
> > do you know what the requirement are for routing the NMI through the
> > io-apic? 
> 
> Sorry. I checked. switching PIT off really breaks nmi_watchdog=1, as
> this just mirrors IRQ#0 to the NMI. No IRQ#0 from PIT, no NMI
> 
> We could keep PIT running with an empty interrupt handler when
> nmi_watchdog=1 is set, but this interferes nicely with broadcasting.
> 
> Does nmi_watchdog=2 work ? We might switch to that, when a local APIC is
> available. 
> 
> 	tglx
> 
> 


There's a compile failure during my bisect.

distcc[3863] ERROR: compile /tmp//hrtimer.tmp.dwalker1.3795.i on dwalker3/120 failed
kernel/hrtimer.c: In function 'hrtimer_cpu_notify':
kernel/hrtimer.c:884: warning: implicit declaration of function 'clockevents_notify'
kernel/hrtimer.c:884: error: 'CLOCK_EVT_NOTIFY_CPU_DEAD' undeclared (first use in this function)
kernel/hrtimer.c:884: error: (Each undeclared identifier is reported only once 
kernel/hrtimer.c:884: error: for each function it appears in.)
drivers/ide/setup-pci.c: In function 'ide_scan_pcibus':
drivers/ide/setup-pci.c:866: warning: ignoring return value of '__pci_register_driver', declared with attribute warn_unused_result
make[1]: *** [kernel/hrtimer.o] Error 1


from this commit,

commit f8381cba04ba8173fd5a2b8e5cd8b3290ee13a98
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Feb 16 01:28:02 2007 -0800

    [PATCH] tick-management: broadcast functionality
    
    With Ingo Molnar <mingo@elte.hu>
    
    Add broadcast functionality, so per cpu clock event devices can be registere
    as dummy devices or switched from/to broadcast on demand.  The broadcast
    function distributes the events via the broadcast function of the clock even
    device.  This is primarily designed to replace the switch apic timer to / fr
    IPI in power states, where the apic stops.
    


