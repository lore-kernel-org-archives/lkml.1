Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199Ab0AYRVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0AYRVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858Ab0AYRVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:21:02 -0500
Received: from www.tglx.de ([62.245.132.106]:53861 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab0AYRVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:21:00 -0500
Date: Mon, 25 Jan 2010 18:20:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Shawn Starr <shawn.starr@rogers.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14859] System timer firing too much without cause
In-Reply-To: <201001251153.59084.shawn.starr@rogers.com>
Message-ID: <alpine.LFD.2.00.1001251808480.5926@localhost.localdomain>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001241734.50803.shawn.starr@rogers.com> <alpine.LFD.2.00.1001251103200.2906@localhost.localdomain> <201001251153.59084.shawn.starr@rogers.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010, Shawn Starr wrote:
> On Monday 25 January 2010 05:35:50 Thomas Gleixner wrote:
> > Shawn, why can't you use dynamic ticks ? In the bugzilla I just see
> > that you worry about the IRQ0 interrupts (which are correct and
> > necessary when the system is in nohz mode) and the extra rescheduling
> > interrupts. How is the system misbehaving ?
> > 

> Well, this all stems from trying to use Radeon KMS with IRQs
> on. Doing so I see system stalls and this is quite noticeable
> however, I am able to show this same stall on the quad core with the
x> same GPU.  Right now, it is unclear to me if there is a underlying
> irq issue or a bug in the radeon driver code that is showing these
> stalls. Since the radeon folks - at the moment - do not think it is
> a coding problem in their driver

Does the stall go away, when you disable dynticks ?

> My impression was using dynamic ticks meant ticks were on demand and

Dynamic ticks are providing a continuous tick long as the machine is
busy. When a core becomes idle, we programm the timer to go off at the
next scheduled timer event, if the event is longer away than the next
tick. When the core goes out of idle (due to the timer or some other
event) we restart the tick.

So you see less timer interrupts (IRQ0 + Local timer interrupts)

> not continuous. On the quad core box, with dynamic ticks on, the
> broadcasts are not increasing IRQ 0 events this only happens on the
> laptop.

Right, that is expected as I explained already. Your desktop does not
use deeper power states. Check /proc/acpi/processor/CPU0/power on both
machines to see the difference. You _cannot_ compare a desktop and a
laptop machine and deduce a regression.

The broadcast mechanism is necessary because the local APIC timer
stops in deeper power states. That's a hardware problem. So if the
core goes into a deeper power state then we arm the broadcast timer
which fires on IRQ0 to wake us up. It is a single timer which is used
by all cores in a system to work around this hardware stupidity. It's
named broadcast because it broadcasts the event to the other cores
when necessary. Your desktop does not use deeper power states,
therefor it does not use the broadcast timer either.

So the timer IRQ0 increasing is neither a Linux BUG nor a regression.

Thanks,

	tglx

