Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbYGKUcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbYGKUcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbYGKUb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:31:58 -0400
Received: from smtp7.server.rpi.edu ([128.113.2.227]:56761 "EHLO
	smtp7.server.rpi.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbYGKUb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:31:56 -0400
Message-ID: <4877C325.7070903@rpi.edu>
Date: Fri, 11 Jul 2008 16:31:33 -0400
From: David Brigada <brigad@rpi.edu>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
CC: Jordan Crouse <jordan.crouse@amd.com>, jim.cromie@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, linux-geode@lists.infradead.org
Subject: Re: PCI-ISA Bridge not operating
References: <487774F9.6000001@rpi.edu> <20080711164845.GB28720@cosmic.amd.com> <4877908C.4060706@rpi.edu> <4877AD63.3000405@rpi.edu> <20080711191045.GB29570@cosmic.amd.com> <4877BF32.9040304@rpi.edu> <20080711202906.GF29570@cosmic.amd.com> (sfid-20080711_212610_009250_8DD595D4)
In-Reply-To: <20080711202906.GF29570@cosmic.amd.com> (sfid-20080711_212610_009250_8DD595D4)
Content-Type: multipart/mixed;
 boundary="------------040500090200020005080105"
X-RPI-SA-Score: undef - spam scanning disabled
X-CanItPRO-Stream: default
X-Canit-Stats-ID: Bayes signature not available
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040500090200020005080105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jordan Crouse wrote:
> On 11/07/08 16:14 -0400, David Brigada wrote:
>> Jordan Crouse wrote:
>>> On 11/07/08 14:58 -0400, David Brigada wrote:
>>>> David Brigada wrote:
>>>>> Jordan Crouse wrote:
>>>>>> On 11/07/08 10:58 -0400, David Brigada wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I'm working with the MSM800XEV board from Digital-Logic.  This board 
>>>>>>> uses a Geode LX800 for a CPU and has the CS5536 companion board also 
>>>>>>> installed.  The board works with an IT8888G IC that provides a PCI/ISA 
>>>>>>> bridge to a PC/104 bus that is externally provided.
>>>>>>>
>>>>>>> If I boot with FreeDOS, I can twiddle I/O ports, and the proper ISA 
>>>>>>> signaling comes over the PC/104 bus.  In Linux, the /IOW or /IOR line 
>>>>>>> goes low as expected, but the address doesn't come over the bus.  The 
>>>>>>> DOS that I'm running doesn't seem to have any specific drivers for the 
>>>>>>> chip, I'm guessing that the hardware should "just work" --- the IT8888G 
>>>>>>> is designed to grab I/O requests in the ISA range off the PCI bus after 
>>>>>>> a short delay if nothing else grabs them first.
>>>>>>>
>>>>>>> I have a feeling that it has something to do with the CS5536 companion 
>>>>>>> chip, as it seems as though there is a driver for a PCI/ISA bridge on 
>>>>>>> that chip, though I can't get much detail from AMD's datasheet on that 
>>>>>>> functionality.  I do know that on the MSM800XEV, any such functionality 
>>>>>>> is wired to the IT8888G, not the CS5536.
>>>>>>>
>>>>>>> There are two kernel config options related to the PCI IDs of the parts 
>>>>>>> of the device that handle the ISA bus, CONFIG_SCx200_ACB and 
>>>>>>> CONFIG_CS5535_GPIO.  I've tried disabling both, but it doesn't seem to help.
>>>>>>>
>>>>>>> In lspci, the CS5536 PCI/ISA bridge is shown, but not the IT8888G.
>>>>>>>
>>>>>>> Any ideas?
>>>>>> ISA should indeed "just work".  The only thing I'm wondering is if
>>>>>> the kernel is interfering (it shouldn't).  I assume that since it works
>>>>>> in FreeDOS that there is no possibility that something on the PCI bus
>>>>>> is grabbing the cycles instead.
>>>>> That's what I'm thinking --- that the CS5536 PCI/ISA bridge is claiming 
>>>>> the cycles.
>>>>>
>>>>>> How are you trying to access the device in Linux?  Through a kernel module
>>>>>> or a user application running as root?
>>>>> I've tried both.  I have a kernel module that I wrote for the hardware. 
>>>>>   When I couldn't get that working, I tried looping some code that keeps 
>>>>> touching the same I/O port that I'm using.
>>>>>
>>>>>> Jordan
>>>>>>
>>>>> Dave
>>>> Looking through the documentation for the CS5536, in the "CS56536 
>>>> Companion Device Data Book," section 5.2.8, it says the following:
>>>>
>>>>  > If the SDOFF (Subtractive Decode Off) bit in the GLPCI_MSR_CTRL (MSR
>>>>  > 51000010h[10]) is cleared (reset value), any PCI transaction, other
>>>>  > than Configuration Read/Write, Interrupt Acknowledge, and Special
>>>>  > Cycle transactions, not claimed by any device (i.3., not asserting
>>>>  > DEVSEL#) within the default active decode cycles (three cycles
>>>>  > immediately after FRAME# being asserted) will be accepted by GLPCI_SB
>>>>  > at the fourth clock edge.
>>>>
>>>> This is the same behavior that the IT8888G chip uses --- it waits three 
>>>> cycles for another device to claim it and then passes the transaction 
>>>> along.  I'm guessing that the CS5536 might be grabbing it (maybe it's 
>>>> electrically closer, or the logic is more optimized) before the IT8888G 
>>>> can handle it.
>>>>
>>>> Does this seem feasible as to what could be happening?
>>> Sure, but then why does FreeDOS work?  It shouldn't be any different
>>> when the bits hit the line.
>>>
>>> Jordan
>> That *is* puzzling.  When I do lspci, the entry for the IT8888G does not 
>> appear.  I don't have much experience with PCI internals.  Would that be 
>> because there is no driver for it in the kernel, or is there something 
>> more insidious afoot?
> 
> Well - the first step would be to get a dmesg output.  if the kernel
> is doing anything to the device at all, the dmesg will show it.
> 
> Jordan
> 

[Sorry, Jordan about the double-mail]

The dmesg output doesn't have anything related to the device.  I have 
attached my dmesg output for completeness.  Ignore the last four lines, 
that's my testing.  The PCI ID of the IT8888G is 1283:8888.

Dave

--------------040500090200020005080105
Content-Type: text/plain;
 name="dmesg-out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-out"

Linux version 2.6.26-rc9 (root@brigad-thz-linux) (gcc version 4.3.1 (Debian 4.3.1-2) ) #2 Fri Jul 11 06:23:00 EDT 2008
PAT not supported by CPU.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000e7b0000 (usable)
 BIOS-e820: 000000000e7b0000 - 000000000e7bffc0 (ACPI data)
 BIOS-e820: 000000000e7bffc0 - 000000000e7c0000 (ACPI NVS)
 BIOS-e820: 0000000040400000 - 0000000040440004 (reserved)
 BIOS-e820: 00000000f0000000 - 0000000100000000 (reserved)
231MB LOWMEM available.
Entering add_active_range(0, 0, 59312) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    59312
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    59312
On node 0 totalpages: 59312
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 432 pages used for memmap
  Normal zone: 54784 pages, LIFO batch:15
  Movable zone: 0 pages used for memmap
DMI not present or invalid.
ACPI: RSDP 000E9010, 0014 (r0 OID_00)
ACPI: RSDT 0E7B2AE0, 0030 (r1 AMD    RSDT_000 31303030 AMD  31303030)
ACPI: FACP 0E7B29E0, 0084 (r1 AMD    FACP_000 31303030 AMD  31303030)
ACPI: DSDT 0E7B0000, 29D6 (r1 INSYDE CS553x       1007 INTL 20030122)
ACPI: FACS 0E7BFFC0, 0040
ACPI: BOOT 0E7B2A70, 0028 (r1 AMD    BOOT_000 31303030 AMD  31303030)
ACPI: DBGP 0E7B2AA0, 0034 (r1 AMD    DBGP_000 31303030 AMD  31303030)
ACPI: PM-Timer IO Port: 0x9c10
Allocating PCI resources starting at 50000000 (gap: 40440004:afbbfffc)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 58848
Kernel command line: root=/dev/hdb1 ro 
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 499.585 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 231248k/237248k available (2085k kernel code, 5428k reserved, 846k data, 176k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffff6000 - 0xfffff000   (  36 kB)
    vmalloc : 0xcf000000 - 0xffff4000   ( 783 MB)
    lowmem  : 0xc0000000 - 0xce7b0000   ( 231 MB)
      .init : 0xc03e0000 - 0xc040c000   ( 176 kB)
      .data : 0xc03095f2 - 0xc03dcfd8   ( 846 kB)
      .text : 0xc0100000 - 0xc03095f2   (2085 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 1000.29 BogoMIPS (lpj=500145)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
CPU: L2 Cache: 128K (32 bytes/line)
CPU: AMD Geode(TM) Integrated Processor by AMD PCS stepping 02
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20080321
ACPI: setting ELCR to 0200 (from 0c00)
net_namespace: 640 bytes
NET: Registered protocol family 16
geode-mfgpt:  0 MFGPT timers available.
mfgpt-timer:  Could not allocate a MFPGT timer
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xff157, last bus=0
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs *10)
ACPI: PCI Interrupt Link [LNKB] (IRQs *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs *10)
ACPI: PCI Interrupt Link [LNKD] (IRQs *11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
Switched to high resolution mode on CPU 0
ACPI: RTC can wake from S4
system 00:03: iomem range 0x0-0x9ffff could not be reserved
system 00:03: iomem range 0xe0000-0xfffff could not be reserved
system 00:03: iomem range 0x100000-0xe7affff could not be reserved
system 00:03: iomem range 0x40400000-0x4041ffff could not be reserved
system 00:03: iomem range 0xf0000000-0xffffffff could not be reserved
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x3f set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1215772026.266:1): initialized
Total HugeTLB memory allocated, 0
msgmni has been set to 452
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:01.1: Boot video device
pci 0000:00:13.0: Firmware left e100 interrupts enabled; disabling
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:01.1[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
lxfb 0000:00:01.1: 24576 KB of video memory at 0x50000000
Console: switching to colour frame buffer device 60x34
fb0: Geode LX frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
AMD Geode RNG detected
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:00:13.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
e100: eth0: e100_probe: addr 0xefb00000, irq 10, MAC addr 00:30:59:03:07:e8
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
AMD5536: 0000:00:0f.2 (rev 01) UDMA100 controller
AMD5536: IDE controller (0x1022:0x209a rev 0x01) at  PCI slot 0000:00:0f.2
AMD5536: not 100% native mode: will probe irqs later
AMD5536: IDE port disabled
    ide0: BM-DMA at 0xeff0-0xeff7
Probing IDE interface ide0...
hdb: CF CARD 2GB, ATA DISK drive
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO2
hdb: host side 80-wire cable detection failed, limiting max speed to UDMA33
hdb: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hdb: max request size: 128KiB
hdb: 3915072 sectors (2004 MB) w/1KiB Cache, CHS=3884/16/63
 hdb: hdb1
ide-floppy driver 1.00
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0f.5[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:0f.5 to 64
ehci_hcd 0000:00:0f.5: EHCI Host Controller
ehci_hcd 0000:00:0f.5: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0f.5: irq 11, io mem 0xefc00000
ehci_hcd 0000:00:0f.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
input: AT Translated Set 2 keyboard as /class/input/input0
geodewdt:  No timers were available
cpuidle: using governor ladder
cpuidle: using governor menu
ACPI: PCI Interrupt 0000:00:01.2[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
geode-aes: GEODE AES engine enabled.
Advanced Linux Sound Architecture Driver Version 1.0.16.
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0f.3[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:0f.3 to 64
Failure reading codec reg 0x7e,Last value=0x7e805375
Failure reading codec reg 0x7e,Last value=0x7e805375
ALSA device list:
  #0: CS5535 Audio cs5535audio at 0xdf80, irq 11
TCP bic registered
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
NET: Registered protocol family 17
Using IPI Shortcut mode
registered taskstats version 1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 176k freed
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 16 throttling states)
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: AC Adapter [AC] (on-line)
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:0f.4[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:0f.4 to 64
ohci_hcd 0000:00:0f.4: OHCI Host Controller
ohci_hcd 0000:00:0f.4: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0f.4: irq 11, io mem 0xeff00000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
input: PC Speaker as /class/input/input3
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
parport_pc 00:0c: disabled
parport_pc: probe of 00:0c failed with error -22
Marking TSC unstable due to: TSC halts in idle.
EXT3 FS on hdb1, internal journal
loop: module loaded
ADDRCONF(NETDEV_UP): eth1: link is not ready
e100: eth1: e100_watchdog: link up, 100Mbps, full-duplex
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
eth1: no IPv6 routers present
miniz_ts.c: Allocated character device at (252, 0)
input: Unspecified device as /class/input/input4
miniz_ts.c: Allocated character device at (252, 0)
input: Unspecified device as /class/input/input5

--------------040500090200020005080105--
