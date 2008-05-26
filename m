Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbYEZWIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbYEZWIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 18:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbYEZWIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 18:08:42 -0400
Received: from gw.goop.org ([64.81.55.164]:38951 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbYEZWIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 18:08:41 -0400
Message-ID: <483B34CA.8000600@goop.org>
Date: Mon, 26 May 2008 23:08:10 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Question about interrupt routing and irq allocation
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on a pv driver for hvm Xen guests.  That is, when booting 
Linux in a fully-virtualized Xen domain, it can still access the 
underlying Xen device model to get more efficient device access, 
bypassing all the hardware emulation.

Xen implements this by creating a "Xen platform device" on the emulated 
PCI bus, which is a bit like a PCI-Xenbus bridge:  the pci device driver 
which discovers this device can then use it to register a xenbus, and 
which then allows all the xenbus drivers to discover their devices.  
This device has an interrupt which is asserted when any Xen event 
channel has a pending event.

Now one way to handle this interrupt is just make it a single irq which 
all xenbus drivers share.  They would then treat the event channel bit 
array like an internal device register to disambiguate who should get 
the interrupt.  That's what the current out of tree drivers do, and it 
works OK.  The main problem is that all the interrupts are mushed 
together, and can't be accounted for separately, given separate 
affinities, etc.  It also means that there's a gratuitous difference 
between the pv-on-hvm and pv-on-pv drivers, even though they're 
functionally identical.

The other approach would be to treat it as some kind of interrupt 
daisy-chain device.  The PCI-xenbus driver gets the interrupt, scans the 
event channels, maps those onto distinct irqs and then (re-)delivers 
them appropriately.  This means that the system would have a mixture of 
PIC, APIC and Xen interrupt sources.  The main problem I see with this 
is how to allocate irqs for the routing of event channels to irqs 
(which, as I understand it, is equivalent to mapping IOAPIC pins to 
local APIC irqs).

Is there some way to allocate irqs reliably, in a way which won't 
conflict with APIC-based interrupt sources?  If I scan the irq_desc 
array looking for entries without any chip, can I claim them and use 
them for my Xen-irq-chip, or will that cause later conflicts?  Should I 
just raise NR_IRQs and start using irqs above 224?

This is not an area I've looked at before, so it's quite likely I'm 
getting details wrong.  Are there any other examples of devices like 
this, either in the x86 world, or in general?

Thanks,
    J
