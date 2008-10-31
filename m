Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYJaEIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYJaEIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 00:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYJaEIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 00:08:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:57199 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYJaEIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 00:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=vpbcG0+0CMVCO1QjUmBXyjNi8sNKm3w4KwYGtnuQ4D8I6QmTyx0X2WMwqi4g0vN86a
         PZzseWuOspeTjj7ha+Lg/tcVzhosTWQc07/r8H9P7qUbwAC+GUbHxugiJDtWX91U6RoC
         lROh3hLUXW81cx5h63RDQ05FX5HTbAQ9kT8Ms=
Message-ID: <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com>
Date: Thu, 30 Oct 2008 21:08:02 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Jonathan Corbet" <corbet@lwn.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.28-rc2 hates my e1000e
Cc: "Robert Hancock" <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081030205851.3208f52f@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no>
	 <490A5532.2000704@shaw.ca> <20081030205851.3208f52f@bike.lwn.net>
X-Google-Sender-Auth: 5e467e2932114bf2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 7:58 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Thu, 30 Oct 2008 18:45:38 -0600
> Robert Hancock <hancockr@shaw.ca> wrote:
>
>> What's in /proc/iomem? Full dmesg output from boot would also be
>> useful.
>
> /proc/iomem looks like this with 2.6.28-rc2:
>
> 00000000-0009fbff : System RAM
> 000f0000-000fffff : reserved
> 00100000-be4ff7ff : System RAM
>  00200000-004a6e45 : Kernel code
>  004a6e46-00649b77 : Kernel data
>  006c4000-007585ff : Kernel bss
> be4ff800-be553bff : ACPI Non-volatile Storage
> be553c00-be555bff : ACPI Tables
> be555c00-beffffff : reserved
> c0000000-cfffffff : 0000:00:02.0
> d0000000-d3ffffff : PCI Bus 0000:02
>  d0000000-d3ffffff : 0000:02:00.0
>    d0000000-d07fffff : ivtv encoder
>    d2000000-d200ffff : ivtv registers
> d4000000-d4000fff : Intel Flush Page
> e0000000-fe7fffff : reserved
> fe800000-fe8fffff : PCI Bus 0000:01
>  fe800000-fe8fffff : reserved
> fe900000-fe9d9aff : reserved
> fe9d9b00-fe9d9bff : 0000:00:1f.3
>  fe9d9b00-fe9d9bff : reserved
> fe9d9c00-fe9d9fff : 0000:00:1a.7
>  fe9d9c00-fe9d9fff : reserved
> fe9da000-fe9dafff : 0000:00:03.3
>  fe9da000-fe9dafff : reserved
> fe9db000-fe9dbfff : 0000:00:19.0
>  fe9db000-fe9dbfff : reserved
> fe9dc000-fe9dffff : 0000:00:1b.0
>  fe9dc000-fe9dffff : reserved
> fe9e0000-fe9fffff : 0000:00:19.0
>  fe9e0000-fe9fffff : reserved

your BIOS allocate that to your nic, and also it put that in reserved
in e820 table.

so before 2.6.28. kernel will allocate another resource to your BAR.

for 2.6.28, it change to honor PCI BAR than others...and at same time
use reserve_region_with_split ...
put the overlapping to reserved..

so solution will be:
1.rework reserve_region_with_split not to put the overlapping to reserved...
2. or update pci_request_region to check if conflicts is with name "reserved"

BTW:
please send out
dmesg -s 262144 > dmesg.txt

YH



> fea00000-fea7ffff : 0000:00:02.0
>  fea00000-fea7ffff : reserved
> fea80000-feafffff : 0000:00:02.1
>  fea80000-feafffff : reserved
> feb00000-febfffff : 0000:00:02.0
>  feb00000-febfffff : reserved
> fec00000-fed003ff : reserved
>  fec00000-fec00fff : IOAPIC 0
>  fed00000-fed003ff : HPET 0
> fed20000-fed9ffff : reserved
> fedad000-fedad00f : 0000:00:03.0
> fee00000-feefffff : reserved
>  fee00000-fee00fff : Local APIC
> ff980800-ff980bff : 0000:00:1d.7
>  ff980800-ff980bff : ehci_hcd
> ffb00000-ffffffff : reserved
>
> Remember that I/O memory is alleged to be at:
>
>>       Region 0: Memory at fe9e0000 (32-bit, non-prefetchable) [size=128K]
>>       Region 1: Memory at fe9db000 (32-bit, non-prefetchable) [size=4K]
>
> These regions are marked "reserved" in this map.
>
> The 2.6.27 view of I/O memory is rather different:
>
> 00000000-0009fbff : System RAM
> 000f0000-000fffff : reserved
> 00100000-be4ff7ff : System RAM
>  00200000-004b4d12 : Kernel code
>  004b4d13-0073000f : Kernel data
>  011b6000-0127e58f : Kernel bss
> be4ff800-be553bff : ACPI Non-volatile Storage
> be553c00-be555bff : ACPI Tables
> be555c00-beffffff : reserved
> c0000000-cfffffff : 0000:00:02.0
> d0000000-d3ffffff : PCI Bus 0000:02
>  d0000000-d3ffffff : 0000:02:00.0
>    d0000000-d07fffff : ivtv encoder
>    d2000000-d200ffff : ivtv registers
> d4000000-d40fffff : 0000:00:02.0
> d4100000-d417ffff : 0000:00:02.0
> d4180000-d41fffff : 0000:00:02.1
> d4200000-d421ffff : 0000:00:19.0
>  d4200000-d421ffff : e1000e
> d4220000-d4223fff : 0000:00:1b.0
>  d4220000-d4223fff : ICH HD audio
> d4224000-d4224fff : 0000:00:03.3
> d4225000-d4225fff : 0000:00:19.0
>  d4225000-d4225fff : e1000e
> d4226000-d42263ff : 0000:00:1a.7
>  d4226000-d42263ff : ehci_hcd
> d4226400-d42264ff : 0000:00:1f.3
> d4227000-d4227fff : Intel Flush Page
> e0000000-fed003ff : reserved
>  fec00000-fec00fff : IOAPIC 0
>  fed00000-fed003ff : HPET 0
> fed20000-fed9ffff : reserved
> fedad000-fedad00f : 0000:00:03.0
> fee00000-feefffff : reserved
>  fee00000-fee00fff : Local APIC
> ff980800-ff980bff : 0000:00:1d.7
>  ff980800-ff980bff : ehci_hcd
> ffb00000-ffffffff : reserved
>
> The 2.6.28-rc2 dmesg output follows.
>
>> GSI 23 (level, low) -> IRQ 23
> [    5.480562] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    5.480565] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    5.480688] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> [    5.484666] ehci_hcd 0000:00:1d.7: debug port 1
> [    5.484719] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [    5.484734] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff980800
> [    5.496687] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    5.496900] usb usb1: configuration #1 chosen from 1 choice
> [    5.497008] hub 1-0:1.0: USB hub found
> [    5.497062] hub 1-0:1.0: 6 ports detected
> [    5.497327] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.497382] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.497455] usb usb1: Product: EHCI Host Controller
> [    5.497505] usb usb1: Manufacturer: Linux 2.6.28-rc2 ehci_hcd
> [    5.497557] usb usb1: SerialNumber: 0000:00:1d.7
> [    5.497647] uhci_hcd: USB Universal Host Controller Interface driver
> [    5.497726] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    5.497786] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    5.497789] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    5.497884] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
> [    5.497986] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff20
> [    5.498146] usb usb2: configuration #1 chosen from 1 choice
> [    5.498250] hub 2-0:1.0: USB hub found
> [    5.498303] hub 2-0:1.0: 2 ports detected
> [    5.498520] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.498576] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.498648] usb usb2: Product: UHCI Host Controller
> [    5.498698] usb usb2: Manufacturer: Linux 2.6.28-rc2 uhci_hcd
> [    5.498751] usb usb2: SerialNumber: 0000:00:1a.0
> [    5.498818] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    5.498878] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    5.498881] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    5.498976] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
> [    5.499079] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000ff00
> [    5.499255] usb usb3: configuration #1 chosen from 1 choice
> [    5.499358] hub 3-0:1.0: USB hub found
> [    5.499416] hub 3-0:1.0: 2 ports detected
> [    5.499634] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.499690] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.499762] usb usb3: Product: UHCI Host Controller
> [    5.499813] usb usb3: Manufacturer: Linux 2.6.28-rc2 uhci_hcd
> [    5.499865] usb usb3: SerialNumber: 0000:00:1a.1
> [    5.499931] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    5.499990] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    5.499993] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    5.500098] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
> [    5.500193] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000ff80
> [    5.500359] usb usb4: configuration #1 chosen from 1 choice
> [    5.500463] hub 4-0:1.0: USB hub found
> [    5.500515] hub 4-0:1.0: 2 ports detected
> [    5.500736] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.500792] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.500865] usb usb4: Product: UHCI Host Controller
> [    5.503087] usb usb4: Manufacturer: Linux 2.6.28-rc2 uhci_hcd
> [    5.503139] usb usb4: SerialNumber: 0000:00:1d.0
> [    5.503205] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    5.503265] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    5.503268] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    5.503369] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
> [    5.503463] uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000ff60
> [    5.503627] usb usb5: configuration #1 chosen from 1 choice
> [    5.503737] hub 5-0:1.0: USB hub found
> [    5.503789] hub 5-0:1.0: 2 ports detected
> [    5.504020] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.504076] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.504149] usb usb5: Product: UHCI Host Controller
> [    5.504199] usb usb5: Manufacturer: Linux 2.6.28-rc2 uhci_hcd
> [    5.504251] usb usb5: SerialNumber: 0000:00:1d.1
> [    5.504317] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    5.504376] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    5.504379] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    5.504485] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
> [    5.504580] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
> [    5.504751] usb usb6: configuration #1 chosen from 1 choice
> [    5.504858] hub 6-0:1.0: USB hub found
> [    5.504910] hub 6-0:1.0: 2 ports detected
> [    5.505145] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.505201] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.505274] usb usb6: Product: UHCI Host Controller
> [    5.505324] usb usb6: Manufacturer: Linux 2.6.28-rc2 uhci_hcd
> [    5.505376] usb usb6: SerialNumber: 0000:00:1d.2
> [    5.505526] usbcore: registered new interface driver usblp
> [    5.505580] Initializing USB Mass Storage driver...
> [    5.505690] usbcore: registered new interface driver usb-storage
> [    5.505745] USB Mass Storage support registered.
> [    5.505951] PNP: No PS/2 controller found. Probing ports directly.
> [    5.508550] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    5.508603] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    5.508780] mice: PS/2 mouse device common for all mice
> [    5.509019] coretemp coretemp.0: Using relative temperature scale!
> [    5.509172] coretemp coretemp.1: Using relative temperature scale!
> [    5.509284] EDAC MC: Ver: 2.1.0 Oct 30 2008
> [    5.509919] TCP bic registered
> [    5.509967] NET: Registered protocol family 17
> [    5.510236] registered taskstats version 1
> [    5.634462] kjournald starting.  Commit interval 5 seconds
> [    5.634555] EXT3-fs: mounted filesystem with ordered data mode.
> [    5.634623] VFS: Mounted root (ext3 filesystem) readonly.
> [    5.634686] Freeing unused kernel memory: 340k freed
> [    5.803374] usb 1-3: new high speed USB device using ehci_hcd and address 2
> [    5.927226] usb 1-3: configuration #1 chosen from 1 choice
> [    5.927526] hub 1-3:1.0: USB hub found
> [    5.927678] hub 1-3:1.0: 4 ports detected
> [    5.928869] usb 1-3: New USB device found, idVendor=050d, idProduct=0234
> [    5.928925] usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    6.140038] usb 2-2: new low speed USB device using uhci_hcd and address 2
> [    6.314237] usb 2-2: configuration #1 chosen from 1 choice
> [    6.317404] usb 2-2: New USB device found, idVendor=046d, idProduct=c01b
> [    6.317462] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    6.317518] usb 2-2: Product: USB-PS/2 Optical Mouse
> [    6.317569] usb 2-2: Manufacturer: Logitech
> [    6.543376] usb 6-2: new full speed USB device using uhci_hcd and address 2
> [    6.716827] usb 6-2: configuration #1 chosen from 1 choice
> [    6.719722] hub 6-2:1.0: USB hub found
> [    6.721625] hub 6-2:1.0: 3 ports detected
> [    6.726875] usb 6-2: New USB device found, idVendor=046d, idProduct=0b04
> [    6.726940] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    6.726999] usb 6-2: Product: Logitech BT Mini-Receiver
> [    6.727053] usb 6-2: Manufacturer: Logitech
> [    6.994617] usb 6-2.2: new full speed USB device using uhci_hcd and address 3
> [    7.138819] usb 6-2.2: configuration #1 chosen from 1 choice
> [    7.144935] usb 6-2.2: New USB device found, idVendor=046d, idProduct=c713
> [    7.144993] usb 6-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    7.145070] usb 6-2.2: Product: Logitech BT Mini-Receiver
> [    7.145123] usb 6-2.2: Manufacturer: Logitech
> [    7.145174] usb 6-2.2: SerialNumber: 0007617AC3F9
> [    7.211612] usb 6-2.3: new full speed USB device using uhci_hcd and address 4
> [    7.359357] usb 6-2.3: configuration #1 chosen from 1 choice
> [    7.364932] usb 6-2.3: New USB device found, idVendor=046d, idProduct=c714
> [    7.364934] usb 6-2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    7.364937] usb 6-2.3: Product: Logitech BT Mini-Receiver
> [    7.364939] usb 6-2.3: Manufacturer: Logitech
> [    7.364940] usb 6-2.3: SerialNumber: 0007617AC3F9
> [    8.984747] input: Power Button (FF) as /class/input/input0
> [    9.006919] ACPI: Power Button (FF) [PWRF]
> [    9.007004] input: Power Button (CM) as /class/input/input1
> [    9.021113] ACPI: Power Button (CM) [VBTN]
> [    9.048989] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    9.049031] scsi 0:0:1:0: Attached scsi generic sg1 type 5
> [    9.049071] sd 1:0:0:0: Attached scsi generic sg2 type 0
> [    9.060794] processor ACPI0007:00: registered as cooling_device0
> [    9.060845] processor ACPI0007:01: registered as cooling_device1
> [    9.065667] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    9.073608] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
> [    9.073725] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    9.080203] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
> [    9.080206] e1000e: Copyright (c) 1999-2008 Intel Corporation.
> [    9.080270] e1000e 0000:00:19.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> [    9.080277] e1000e 0000:00:19.0: BAR 0: can't reserve mem region [0xfe9e0000-0xfe9fffff]
> [    9.080284] e1000e 0000:00:19.0: PCI INT A disabled
> [    9.080290] e1000e: probe of 0000:00:19.0 failed with error -16
> [    9.080958] input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
> [    9.196488] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    9.204233] generic-usb 0003:046D:C01B.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-2/input0
> [    9.210127] input: Logitech Logitech BT Mini-Receiver as /class/input/input3
> [    9.219007] Driver 'sr' needs updating - please use bus_type methods
> [    9.257039] generic-usb 0003:046D:C713.0002: input,hidraw1: USB HID v1.11 Keyboard [Logitech Logitech BT Mini-Receiver] on usb-0000:00:1d.2-2.2/input0
> [    9.258865] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> [    9.258870] Uniform CD-ROM driver Revision: 3.20
> [    9.258979] sr 0:0:1:0: Attached scsi CD-ROM sr0
> [    9.260082] usbcore: registered new interface driver usbhid
> [    9.260085] usbhid: v2.6:USB HID core driver
> [    9.360339] input: Logitech Logitech BT Mini-Receiver as /class/input/input4
> [    9.361821] serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    9.362186] 0000:00:03.3: ttyS1 at I/O 0xec98 (irq = 17) is a 16550A
> [    9.393684] logitech 0003:046D:C714.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech Logitech BT Mini-Receiver] on usb-0000:00:1d.2-2.3/input0
> [    9.791132] Linux video capture interface: v2.00
> [    9.827980] i2c_algo_bit: exports duplicate symbol i2c_bit_add_numbered_bus (owned by kernel)
> [    9.838420] ivtv:  Start initialization, version 1.4.0
> [    9.838493] ivtv0: Initializing card #0
> [    9.838495] ivtv0: Autodetected Hauppauge card (cx23416 based)
> [    9.838563] ivtv 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    9.892690] tveeprom 1-0050: Hauppauge model 32062, rev C199, serial# 8510288
> [    9.892694] tveeprom 1-0050: tuner model is TCL 2002N 5H (idx 99, type 50)
> [    9.892697] tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
> [    9.892699] tveeprom 1-0050: audio processor is MSP3445 (idx 12)
> [    9.892701] tveeprom 1-0050: decoder processor is SAA7115 (idx 19)
> [    9.892704] tveeprom 1-0050: has no radio, has IR receiver, has no IR transmitter
> [    9.892706] ivtv0: Autodetected Hauppauge WinTV PVR-250
> [    9.947760] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    9.947771] HDA Intel 0000:00:1b.0: BAR 0: can't reserve mem region [0xfe9dc000-0xfe9dffff]
> [    9.947776] HDA Intel 0000:00:1b.0: PCI INT A disabled
> [    9.947789] HDA Intel: probe of 0000:00:1b.0 failed with error -16
> [    9.985899] saa7115 1-0021: saa7115 found (1f7115d0e100000) @ 0x42 (ivtv i2c driver #0)
> [   10.121484] msp3400 1-0040: MSP3445G-B8 found @ 0x80 (ivtv i2c driver #0)
> [   10.121486] msp3400 1-0040: msp3400 supports radio, mode is autodetect and autoselect
> [   10.122792] tuner 1-0061: chip found @ 0xc2 (ivtv i2c driver #0)
> [   10.122800] simple_tuner_attach: driver disabled by Kconfig
> [   10.123193] ivtv0: Registered device video0 for encoder MPG (4096 kB)
> [   10.123227] ivtv0: Registered device video32 for encoder YUV (2048 kB)
> [   10.123260] ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
> [   10.123293] ivtv0: Registered device video24 for encoder PCM (320 kB)
> [   10.123296] ivtv0: Initialized card #0: Hauppauge WinTV PVR-250
> [   10.123316] ivtv:  End initialization
> [   12.984403] EXT3 FS on sda7, internal journal
> [   13.293069] kjournald starting.  Commit interval 5 seconds
> [   13.293232] EXT3 FS on sda1, internal journal
> [   13.293240] EXT3-fs: mounted filesystem with ordered data mode.
> [   13.334912] kjournald starting.  Commit interval 5 seconds
> [   13.335067] EXT3 FS on sda8, internal journal
> [   13.335074] EXT3-fs: mounted filesystem with ordered data mode.
> [   13.346061] kjournald starting.  Commit interval 5 seconds
> [   13.346203] EXT3 FS on sda6, internal journal
> [   13.346210] EXT3-fs: mounted filesystem with ordered data mode.
> [   13.363127] kjournald starting.  Commit interval 5 seconds
> [   13.363274] EXT3 FS on sda5, internal journal
> [   13.363281] EXT3-fs: mounted filesystem with ordered data mode.
> [   13.386583] kjournald starting.  Commit interval 5 seconds
> [   13.386747] EXT3 FS on sda2, internal journal
> [   13.386754] EXT3-fs: mounted filesystem with ordered data mode.
> [   13.411607] kjournald starting.  Commit interval 5 seconds
> [   13.411738] EXT3 FS on sda3, internal journal
> [   13.411744] EXT3-fs: mounted filesystem with ordered data mode.
> [   13.426394] kjournald starting.  Commit interval 5 seconds
> [   13.426698] EXT3 FS on sdb1, internal journal
> [   13.426705] EXT3-fs: mounted filesystem with ordered data mode.
> [   14.732391] Adding 1020088k swap on /dev/sda9.  Priority:-1 extents:1 across:1020088k
> [   15.130376] platform microcode: firmware: requesting intel-ucode/06-0f-0d
> [   15.147907] platform microcode: firmware: requesting intel-ucode/06-0f-0d
> [   15.151183] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk> <peter.oruba@amd.com>
> [   15.357831] microcode: CPU0 updated from revision 0xa1 to 0xa3, date = 2007-08-13
> [   15.359162] microcode: CPU1 updated from revision 0xa1 to 0xa3, date = 2007-08-13
> [   15.382263] Microcode Update Driver: v2.00 removed.
> [   16.935369] RPC: Registered udp transport module.
> [   16.935373] RPC: Registered tcp transport module.
> [   17.620320] fuse init (API version 7.10)
> [   23.180051] ivtv 0000:02:00.0: firmware: requesting v4l-cx2341x-enc.fw
> [   23.381383] ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
> [   23.580158] ivtv0: Encoder revision: 0x02060039
> [   23.601314] tuner 1-0061: Tuner has no way to set tv freq
> [   23.666053] tuner 1-0061: Tuner has no way to set tv freq
> [   26.775435] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   26.775439] pci 0000:00:02.0: enabling bus mastering
> [   26.775443] pci 0000:00:02.0: setting latency timer to 64
> [   26.775508] pci 0000:00:02.0: irq 46 for MSI/MSI-X
> [   26.775657] [drm] Initialized i915 1.6.0 20080730 on minor 0
> [   26.788761] mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
>
> Thanks,
>
> jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
