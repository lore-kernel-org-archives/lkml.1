Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbZBBUvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbZBBUvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbZBBUvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:51:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579AbZBBUvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:51:23 -0500
Date: Mon, 2 Feb 2009 12:50:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andreas Schwab <schwab@suse.de>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <1233606805.18767.97.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>  <1233568479.18767.86.camel@pasglop>  <alpine.LFD.2.00.0902020902320.4704@localhost.localdomain> <1233606805.18767.97.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
>
> And won't you have a potential problem here if ACPI is doing clock
> gating or turning off the whole power plane ? IE. If that happens, your
> pci_restore_state() done early with interrupts off will fail as well...

Well, it won't fail any worse than it does anyway. 

> Since the root of that problem seems to be related to interrupts, maybe
> the right approach is to have drivers disable it on suspend (ie,
> disable_irq -> disabled at PIC level)

No.

We went through this, you apparently didn't follow it.

You cannot disable_irq() at suspend/resume time, because that means that 
when you have shared interrupts the device can no longer use interrupts in 
those paths - because they may be disabled by totally different devices.

And a lot of devices WILL NOT WORK without interrupts. Including 
suspend/resume events. Think something as common as USB.

> It's not a trivial problem...

That's the understatement of the year.

The whole reason we want to do the two-phase commit thing where 
"suspend()" starts the thing and "suspend_late()" finalizes things is 
exactly all about these inter-connections and interrupts in particular.

I suspect that we could possibly make ACPI happy by actually leaving 
interrupts "enabled" in the suspend-late (and early-resume) paths, but 
with all hardware interrupts actually turned off. But that's really just a 
"let's fool people by turning off interrupts a different way" thing - it 
in no way really changes any fundamental issues.

Whether you use "disable_irq() over all interrupts" or "local_irq_save -> 
local_irq_restore" really doesn't change anything. You cannot do this in a 
single phase, because that means that you randomly disable interrupts too 
early (or enable them too late) when drivers still _require_ them.

So the only workable way to handle interrupts is one of two:

 - the two-phase thing we do. Do a first phase with interrupts enabled, 
   then the actual low-level "turn off" with interrupts disabled (and the 
   reverse on resume), so that device drivers never have to see the case 
   of "interrupt happens with dead device", while still having the 
   _guarantee_ that interrupts work for part of their suspend/resume 
   cycle.

 - expecting all drivers to be perfect and handle interrupts correcly in
   the driver.

Quite frankly, I don't think the second one is workable. It may be the 
optimal one in theory, but it's never worked for us in practice.

		Linus
