Return-Path: <linux-kernel-owner+w=401wt.eu-S1763988AbXFCERS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763988AbXFCERS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 00:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXFCERJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 00:17:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:53858 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbXFCERH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 00:17:07 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Tear <tarrqt@yahoo.com>
Subject: Re: [RFC][PATCH] IO-APIC blacklist
Date: Sun, 3 Jun 2007 00:16:54 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <857571.26181.qm@web63612.mail.re1.yahoo.com>
In-Reply-To: <857571.26181.qm@web63612.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706030016.54555.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 June 2007 19:53, Tear wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Sat, 2 Jun 2007, Tear wrote:

> > Now, I doubt it's the timer, and the UHCI irq thing sounds more likely to 
> > be a problem anyway, since it's USB that's slow, so it would be 
> > interesting to hear whether:
> > 
> > 	acpi=force pci=routeirq
> > 
> > is still slow (it should enable ACPI, but then force the interrupt routing 
> > to use the PIRQ table anyway). 

I think you meant to suggest acpi=force plus "acpi=noirq", which will
cause all of ACPI except its interrupt routing code to run.
(similarly, "pci=noacpi" causes all of ACPI to run except its
 interrupt code and PCI bus enumeration code)

pci=routeirq actually just goes and forces the interrupt routing
for all PCI devices to be set up before driver probe time
when it is normally done.  This is a workaround for PCI drivers
that don't call pci_enable_device() to enable their IRQ.

In any case, it is possible that the assumption that IRQs
are broken on this box may be invalid.  In the case of
the PCI interrupts above 15 on this box -- they are
all "hard coded" in the _PRT -- there is no run-time
interrupt link to program, Linux will always use the
same IRQ for each device and it has no choice in the matter
in ACPI mode.  So the same is likely true in legacy mode.

> > Also, if you can figure out which USB ports are on the _other_ controller 
> > (the one that gets irq 18 regardless of whether ACPI is on or off), it 
> > would also be interesting to hear whether the camera is always fast (or 
> > perhaps always slow) when connected to a part that is off that 
> > controller..
> 
> Originally I have been using the USB ports on the front panel of
> the computer. I had not tested the USB ports on the rear panel
> of the computer. I have just tested the USB ports on the rear
> panel of the computer with acpi=ht, and surprise, the camera is fast!

When we talk about "fast" and "slow" here, what are we talking about?
What are the relative speeds?
I see uhci only in dmesg, I guess there is no ehci on this box?

Also, can you associate the physical ports on back and front
with the software drivers loaded by performing an operation
on the port and observing which line in /proc/interrupts increments?

do all of the USB interfaces tested have their own unshared
IRQ in /proc/interrupts?

thanks,
-Len

ps. there could still be some "ACPI magic" going on here.
We've seen motherboards that enable parts of USB based
on what OS they think they are running.  Try
acpi=force acpi_os_name=Linux acpi_osi=
and if that makes USB go slow, that is proof
of where the magic lives.

Also, please capture the output from acpidump
and attach it to a bug report here:
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
If you don't have acpidump installed, you can get it
from pmtools here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/

