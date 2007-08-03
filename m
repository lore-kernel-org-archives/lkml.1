Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbXHCUBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbXHCUBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762897AbXHCUBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:01:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:60599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761876AbXHCUBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:01:22 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Asus A8N-SLI Deluxe latest BIOS wants acpi_use_timer_override
Date: Fri, 3 Aug 2007 22:01:15 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <46B37619.2030205@shaw.ca>
In-Reply-To: <46B37619.2030205@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708032201.15355.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007 20:38:17 Robert Hancock wrote:
> It appears that the latest BIOS version 1805 for the ASUS A8N-SLI Deluxe
> board fixes the broken ACPI timer override that was in earlier versions,
> and which the kernel ignores on nForce4 chipsets. Now the same override:
> 
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> 
> seems to be needed, since without acpi_use_timer_override we end up
> getting this (with apic=verbose):

That's really bad.
 
> ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
> ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> ...trying to set up timer (IRQ0) through the 8259A ...  failed.
> ...trying to set up timer as Virtual Wire IRQ... failed.
> ...trying to set up timer as ExtINT IRQ... works.
> 
> and the timer IRQ ends up routed as XT-PIC instead of IO-APIC-edge. With 
> acpi_use_timer_override we just get:
> 
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> 
> and it works through the IO-APIC.
> 
> I should think there must be a better way to handle this automatically.. 

I have pending patches to key the NF5 case on the PCI-ID, but
that obviously cannot be done for NF4.

I cannot think of anything good but putting DMI BIOS version
checks in for that specific board.

> Is there some way we can tell, given we have a chipset with a 
> potentially broken BIOS, from the configuration of the IOAPIC whether 
> the timer override is needed or not? Unfortunately I don't have output 
> from apic=verbose with the old BIOS with the broken override, but maybe 
> somebody else can provide that..

We don't really know which pins are connected where. This means they
likely have some bits they tweaked to get the different behaviour, but they're 
unknown. There are also some northbridge bits that can be tweaked
(e.g. some of the ATI BIOS workarounds used to use that) 
but it's still unknown what the Nvidia chipset actually does and if
they really help here.

Ok in theory you could diff config space dumps between the two BIOS 
versions to try to figure it out, but that would be still pretty risky
and I don't think it would be a good idea to trust such results.

-Andi

 
