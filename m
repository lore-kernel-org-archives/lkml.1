Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYKJHvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYKJHvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYKJHvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:51:31 -0500
Received: from colo.lackof.org ([198.49.126.79]:54621 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbYKJHva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:51:30 -0500
Date: Mon, 10 Nov 2008 00:51:15 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Nobin Mathew <nobin.mathew@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: sharing interrupt between PCI device
Message-ID: <20081110075115.GA13239@colo.lackof.org>
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no> <4910E8AC.7050407@shaw.ca> <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com> <20081108172716.GA28039@colo.lackof.org> <4915E43E.4010206@gmail.com> <20081108191536.GC28039@colo.lackof.org> <8d6898730811092235u4a41c664vd641d2792dee4c50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d6898730811092235u4a41c664vd641d2792dee4c50@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+ingo - question for you about disable_irq() below]

On Mon, Nov 10, 2008 at 12:05:59PM +0530, Nobin Mathew wrote:
> lspci output
> 
> [root@localhost ~]# lspci -vs 1:4
> 01:04.0 System peripheral: Compaq Computer Corporation Integrated
> Lights Out Controller (rev 03)
>         Subsystem: Hewlett-Packard Company Unknown device 3305
>         Flags: medium devsel, IRQ 11
>         I/O ports at 2800 [size=256]
>         Memory at fdee0000 (32-bit, non-prefetchable) [size=512]
>         Capabilities: [f0] Power Management version 3
> 
> 01:04.2 System peripheral: Compaq Computer Corporation Integrated
> Lights Out  Processor (rev 03)
>         Subsystem: Hewlett-Packard Company Unknown device 3305
>         Flags: medium devsel, IRQ 225
>         BIST result: 00
>         I/O ports at 1400 [disabled] [size=256]
>         Memory at fded0000 (32-bit, non-prefetchable) [disabled] [size=2K]
>         Memory at fdec0000 (32-bit, non-prefetchable) [disabled] [size=8K]
>         Memory at fde00000 (32-bit, non-prefetchable) [disabled] [size=512K]
>         [virtual] Expansion ROM at fdd20000 [disabled] [size=64K]
>         Capabilities: [f0] Power Management version 3
> 
> 01:04.4 USB Controller: Hewlett-Packard Company Proliant iLO2 virtual
> USB controller (prog-if 00 [UHCI])
>         Subsystem: Hewlett-Packard Company Unknown device 3305
>         Flags: medium devsel, IRQ 225
>         I/O ports at 1800 [disabled] [size=32]
>         Capabilities: [f0] Power Management version 3

Is this the USB controller that stops working?

The multi-function device makes me suspicious even if it's not the problem.
If rmmod of the "virtual USB" controller driver happens to disable
the IRQ for the entire device, I would consider this a bug in either the
device design or device firmware. But this probably isn't the case.

Interesting part of dmesg_all_in (name was typo'd in original attachment):
PCI: Enabling device 0000:01:04.2 (0114 -> 0117)
ACPI: PCI Interrupt 0000:01:04.2[B] -> GSI 23 (level, low) -> IRQ 225
USB Universal Host Controller Interface driver v3.0
...
PCI: Enabling device 0000:01:04.4 (0140 -> 0141)
ACPI: PCI Interrupt 0000:01:04.4[B] -> GSI 23 (level, low) -> IRQ 225
uhci_hcd 0000:01:04.4: UHCI Host Controller
uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 6
uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:01:04.4: irq 225, io base 0x00001800
...

So it was enabled twice.
And /proc/interrupts shows only on ISR registered:
225:         99        102   IO-APIC-level  uhci_hcd:usb6

Ie this IRQ isn't really shared. At least the shared device hasn't
registered an interrupt handler.

And as expected, after the rmmod, dmesg shows:
ACPI: PCI interrupt for device 0000:01:04.2 disabled
...


So I think your original statement is probably right.
Since the hpilo driver never registered an interrupt handler, it's
probably polling the device (maybe via user space) and would not
be affected by rmmod'ing the USB driver. But the converse is not true.

This initially seems to be an ACPI bug. It's calling acpi_unregister_gsi()
without checking if this GSI is shared with another device.
Which then calls iosapic_unregister_intr(gsi) and we can no longer determine
which device asked for the IRQ to be disabled.

The same problem exists with disable_irq() : only takes a global
IRQ# and no additional identifying information to prevent disabling
a shared IRQ. So I'm not sure if this is a bug with ACPI or design
flaw in generic IRQ APIs.  Ingo?
 
hth,
grant

> 01:04.6 IPMI SMIC interface: Hewlett-Packard Company Proliant iLO2
> virtual UART (prog-if 01)
>         Subsystem: Hewlett-Packard Company Unknown device 3305
>         Flags: medium devsel, IRQ 50
>         Memory at fddf0000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [f0] Power Management version 3
> 

> dmesg messages and /proc/interupts are attached.
> 
> 
> command sequence just for reference
> 
> insmod hpilo
> insmod uhci_hcd
> cat /proc/interrupts
> dmesg
> rmmod hpilo
> rmmod uhci_hcd
> dmesg
> 
> Thanks
> Nobin Mathew
> 
> On Sun, Nov 9, 2008 at 12:45 AM, Grant Grundler
> <grundler@parisc-linux.org> wrote:
> > On Sat, Nov 08, 2008 at 08:10:54PM +0100, Jiri Slaby wrote:
> >> Grant Grundler napsal(a):
> >> > So I see how the IRQ is enabled and disabled. I still don't see where
> >> > an interrupt handler is bound to IRQ 225 (output you posted today in
> >> > another email).
> >>
> >> This irq setup is done during pci_enable_device.
> >
> > Sorry, I wasn't quite correct: pci_enable_device() should only assign IRQs,
> > not enable them. request_irq() would enable them.
> >
> >> > Nobin, can you dump /proc/interrupts when both drivers
> >> > are loaded and also send the dmesg output after both are loaded?
> >>
> >> This won't show the hp driver as it doesn't request_irq.
> >
> > Yup - that's what I expect too. But I was afraid something else might
> > be calling request_irq() and I'm just not seeing it. :)
> >
> > grant
> >

> PCI: Enabling device 0000:01:04.2 (0114 -> 0117)
> ACPI: PCI Interrupt 0000:01:04.2[B] -> GSI 23 (level, low) -> IRQ 225
> USB Universal Host Controller Interface driver v3.0
> PCI: Enabling device 0000:00:1d.0 (0000 -> 0001)
> ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 217
> PCI: Setting latency timer of device 0000:00:1d.0 to 64
> uhci_hcd 0000:00:1d.0: UHCI Host Controller
> uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> uhci_hcd 0000:00:1d.0: irq 217, io base 0x00003000
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
> ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 217
> PCI: Setting latency timer of device 0000:00:1d.1 to 64
> uhci_hcd 0000:00:1d.1: UHCI Host Controller
> uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> uhci_hcd 0000:00:1d.1: irq 217, io base 0x00003020
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 2 ports detected
> PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
> ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 21 (level, low) -> IRQ 217
> PCI: Setting latency timer of device 0000:00:1d.2 to 64
> uhci_hcd 0000:00:1d.2: UHCI Host Controller
> uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> uhci_hcd 0000:00:1d.2: irq 217, io base 0x00003040
> usb usb4: configuration #1 chosen from 1 choice
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
> ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 21 (level, low) -> IRQ 217
> PCI: Setting latency timer of device 0000:00:1d.3 to 64
> uhci_hcd 0000:00:1d.3: UHCI Host Controller
> uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> uhci_hcd 0000:00:1d.3: irq 217, io base 0x00003060
> usb usb5: configuration #1 chosen from 1 choice
> hub 5-0:1.0: USB hub found
> hub 5-0:1.0: 2 ports detected
> PCI: Enabling device 0000:01:04.4 (0140 -> 0141)
> ACPI: PCI Interrupt 0000:01:04.4[B] -> GSI 23 (level, low) -> IRQ 225
> uhci_hcd 0000:01:04.4: UHCI Host Controller
> uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 6
> uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
> uhci_hcd 0000:01:04.4: irq 225, io base 0x00001800
> usb usb6: configuration #1 chosen from 1 choice
> hub 6-0:1.0: USB hub found
> hub 6-0:1.0: 2 ports detected
> usb 6-1: new full speed USB device using uhci_hcd and address 2
> usb 6-1: configuration #1 chosen from 1 choice
> input: HP Virtual Keyboard as /class/input/input5
> input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1
> input: HP Virtual Keyboard as /class/input/input6
> input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1
> usb 6-2: new full speed USB device using uhci_hcd and address 3
> usb 6-2: configuration #1 chosen from 1 choice
> hub 6-2:1.0: USB hub found
> hub 6-2:1.0: 7 ports detected

>            CPU0       CPU1       
>   0:     237187          0    IO-APIC-edge  timer
>   1:        695          0    IO-APIC-edge  i8042
>   7:          0          0    IO-APIC-edge  parport0
>   8:          1          0    IO-APIC-edge  rtc
>   9:          0          0   IO-APIC-level  acpi
>  12:        115       3923    IO-APIC-edge  i8042
>  14:         92       1636    IO-APIC-edge  ide0
>  50:        431       1339   IO-APIC-level  ipmi_si
> 169:        434       6421   IO-APIC-level  eth0
> 217:          0          0   IO-APIC-level  ehci_hcd:usb1, uhci_hcd:usb2, uhci_hcd:usb3, uhci_hcd:usb4, uhci_hcd:usb5
> 225:         99        102   IO-APIC-level  uhci_hcd:usb6
> 233:       5633      15459   IO-APIC-level  libata
> NMI:          0          0 
> LOC:     237016     236962 
> ERR:          0
> MIS:          0

> PCI: Enabling device 0000:01:04.2 (0114 -> 0117)
> ACPI: PCI Interrupt 0000:01:04.2[B] -> GSI 23 (level, low) -> IRQ 225
> USB Universal Host Controller Interface driver v3.0
> PCI: Enabling device 0000:00:1d.0 (0000 -> 0001)
> ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 217
> PCI: Setting latency timer of device 0000:00:1d.0 to 64
> uhci_hcd 0000:00:1d.0: UHCI Host Controller
> uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> uhci_hcd 0000:00:1d.0: irq 217, io base 0x00003000
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
> ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 217
> PCI: Setting latency timer of device 0000:00:1d.1 to 64
> uhci_hcd 0000:00:1d.1: UHCI Host Controller
> uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> uhci_hcd 0000:00:1d.1: irq 217, io base 0x00003020
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 2 ports detected
> PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
> ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 21 (level, low) -> IRQ 217
> PCI: Setting latency timer of device 0000:00:1d.2 to 64
> uhci_hcd 0000:00:1d.2: UHCI Host Controller
> uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> uhci_hcd 0000:00:1d.2: irq 217, io base 0x00003040
> usb usb4: configuration #1 chosen from 1 choice
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
> ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 21 (level, low) -> IRQ 217
> PCI: Setting latency timer of device 0000:00:1d.3 to 64
> uhci_hcd 0000:00:1d.3: UHCI Host Controller
> uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> uhci_hcd 0000:00:1d.3: irq 217, io base 0x00003060
> usb usb5: configuration #1 chosen from 1 choice
> hub 5-0:1.0: USB hub found
> hub 5-0:1.0: 2 ports detected
> PCI: Enabling device 0000:01:04.4 (0140 -> 0141)
> ACPI: PCI Interrupt 0000:01:04.4[B] -> GSI 23 (level, low) -> IRQ 225
> uhci_hcd 0000:01:04.4: UHCI Host Controller
> uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 6
> uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
> uhci_hcd 0000:01:04.4: irq 225, io base 0x00001800
> usb usb6: configuration #1 chosen from 1 choice
> hub 6-0:1.0: USB hub found
> hub 6-0:1.0: 2 ports detected
> usb 6-1: new full speed USB device using uhci_hcd and address 2
> usb 6-1: configuration #1 chosen from 1 choice
> input: HP Virtual Keyboard as /class/input/input5
> input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1
> input: HP Virtual Keyboard as /class/input/input6
> input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1
> usb 6-2: new full speed USB device using uhci_hcd and address 3
> usb 6-2: configuration #1 chosen from 1 choice
> hub 6-2:1.0: USB hub found
> hub 6-2:1.0: 7 ports detected
> ACPI: PCI interrupt for device 0000:01:04.2 disabled
> uhci_hcd 0000:01:04.4: remove, state 1
> usb usb6: USB disconnect, address 1
> usb 6-1: USB disconnect, address 2
> usb 6-2: USB disconnect, address 3
> uhci_hcd 0000:01:04.4: USB bus 6 deregistered
> ACPI: PCI interrupt for device 0000:01:04.4 disabled
> uhci_hcd 0000:00:1d.3: remove, state 1
> usb usb5: USB disconnect, address 1
> uhci_hcd 0000:00:1d.3: USB bus 5 deregistered
> ACPI: PCI interrupt for device 0000:00:1d.3 disabled
> uhci_hcd 0000:00:1d.2: remove, state 1
> usb usb4: USB disconnect, address 1
> uhci_hcd 0000:00:1d.2: USB bus 4 deregistered
> ACPI: PCI interrupt for device 0000:00:1d.2 disabled
> uhci_hcd 0000:00:1d.1: remove, state 1
> usb usb3: USB disconnect, address 1
> uhci_hcd 0000:00:1d.1: USB bus 3 deregistered
> ACPI: PCI interrupt for device 0000:00:1d.1 disabled
> uhci_hcd 0000:00:1d.0: remove, state 1
> usb usb2: USB disconnect, address 1
> uhci_hcd 0000:00:1d.0: USB bus 2 deregistered
> ACPI: PCI interrupt for device 0000:00:1d.0 disabled

