Return-Path: <linux-kernel-owner+w=401wt.eu-S1763392AbYBTSPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763392AbYBTSPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYBTSPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:15:33 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:46169 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbYBTSPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:15:32 -0500
Message-ID: <47BC6E42.10409@s5r6.in-berlin.de>
Date: Wed, 20 Feb 2008 19:15:30 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.25-rc2: ohci1394 problem
References: <47BBDB07.80409@m3y3r.de> <47BBF771.40203@s5r6.in-berlin.de> <47BC6918.4000203@m3y3r.de>
In-Reply-To: <47BC6918.4000203@m3y3r.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> Stefan Richter schrieb:
>> Thomas Meyer wrote at LKML:
>>> With 2.6.25-rc2 my kernel log consists mainly of:
>>>
>>> "ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c

There are junk interrupt events sent to ohci1394's IRQ handler.

...
>> Do you have any hardware attached to the FireWire bus at that time?
>>   
> No. I have no firewire equipment at all.
>> What does /proc/interrupts contain?
>>   
> $ cat /proc/interrupts
>            CPU0       CPU1
>   0:      38097          0   IO-APIC-edge      timer
>   9:       5600          0   IO-APIC-fasteoi   acpi
>  14:         85          0   IO-APIC-edge      ata_piix
>  15:          0          0   IO-APIC-edge      ata_piix
>  16:         40          0   IO-APIC-fasteoi   uhci_hcd:usb5
>  17:        724          0   IO-APIC-fasteoi   wifi0
>  18:         42          0   IO-APIC-fasteoi   uhci_hcd:usb4
>  19:      13870          0   IO-APIC-fasteoi   ata_piix, ohci1394, 
> uhci_hcd:usb3
>  22:       1797          0   IO-APIC-fasteoi   HDA Intel
>  23:       2720          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
> 219:          1          0   PCI-MSI-edge      eth0

OK, ohci1394 shares an interrupt with IDE and USB.  (Normally not a
problem.)

...
> Kernel version is:
> $ git describe
> v2.6.25-rc2-342-g5d9c4a7
> 
> $ lsmod
> Module                  Size  Used by
...
> firewire_ohci          17280  0
> firewire_core          38432  1 firewire_ohci
...
> ohci1394               29232  0
...
> ieee1394               81672  1 ohci1394

It is not an issue to build firewire-ohci and ohci1394, but you should
only load one of them.  Since recent distributions insert modules
automatically according to found hardware on one hand and module aliases
on the other hand, you can achieve this by the line

blacklist firewire-ohci

or blacklist ohci1394 in /etc/modprobe.conf.  Note, many distributions
generate modprobe.conf from files in /etc/modprobe.d/, hence you should
put that line into a file in that directory, then tell the system to
regenerate modprobe.conf.  (E.g. Gentoo uses the command
"update-modules" to regenerate modprobe.conf.)

That said, I assumed so far that inserting both drivers doesn't pose a
problem.  The driver core should simply bind one of these two drivers to
the actual hardware, shouldn't it?  The only problem would be that it is
somewhat unclear which of the two drivers will be used.  (In your case,
ohci1394 won the interrupt.  You can also check the symlinks in sysfs to
find out which driver is bound to the respective PCI device.)

One thing you could quickly test is what happens if you make manually
sure that (a) only ohci1394 is inserted, (b) only firewire-ohci is inserted.

Anybody please correct me if my assumption about two PCI drivers for the
same class of PCI devices is wrong.

...
> config is:
...
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=m
> CONFIG_FIREWIRE_OHCI=m
> CONFIG_FIREWIRE_SBP2=m
> CONFIG_IEEE1394=m
...
> CONFIG_IEEE1394_OHCI1394=m
...

I thought about preventing this sort of configuration --- but in the
end, it is an entirely valid configuration.

So, could somebody clue us in where the false interrupts might come from?
-- 
Stefan Richter
-=====-==--- --=- =-=--
http://arcgraph.de/sr/
