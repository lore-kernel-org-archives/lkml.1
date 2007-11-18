Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbXKRQKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbXKRQKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 11:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbXKRQKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 11:10:46 -0500
Received: from rtr.ca ([76.10.145.34]:3905 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbXKRQKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 11:10:45 -0500
Message-ID: <47406400.5070804@rtr.ca>
Date: Sun, 18 Nov 2007 11:10:40 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org> <4739ADA2.4060604@rtr.ca> <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca>
In-Reply-To: <473C7495.40805@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> I have been reporting this off and on since 2.6.23 was released.
> This problem was not apparent up to perhaps 2.6.23-rc8,
> but definitely became common in 2.6.23 and 2.6.23.1.
> 
> Most of the time, a resume-from-RAM on my notebook takes about 2.1 seconds
> of kernel time to complete.
> 
> Once in a while, it takes *much* longer, in the 14-20 second range.
> These long events *seem* to be mostly after the notebook has been
> in suspend for a longish time, but there's really nothing consistent here.
> 
> So git-bisect isn't going to work for this one.   I recently rebuilt the 
> kernel
> to include printk timestamps, and then it went 2 days without the issue 
> happening,
> until this morning (after an overnight suspend) finally.
> 
> The machine is a Dell Inspiron 9400, Intel chipset + Core2Duo 2.1GHZ 
> w/3GB DDR2.
> PCIe express chipset, ATI graphics, SATA hard drive.
> 
> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 
> 945GT Express Memory Controller Hub (rev 03)
> 00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 
> 945GT Express PCI Express Root Port (rev 03)
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
> Definition Audio Controller (rev 01)
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
> Port 1 (rev 01)
> 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
> Port 2 (rev 01)
> 00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
> Port 4 (rev 01)
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
> #1 (rev 01)
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
> #2 (rev 01)
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
> #3 (rev 01)
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
> #4 (rev 01)
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
> Controller (rev 01)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
> 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface 
> Bridge (rev 01)
> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) 
> Serial ATA Storage Controller IDE (rev 01)
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller 
> (rev 01)
> 01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility 
> X1400
> 03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX 
> (rev 02)
> 03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832
> 03:01.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 
> SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19)
> 03:01.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 01)
> 03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host 
> Adapter (rev 0a)
> 03:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
> 0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG 
> Network Connection (rev 02)
> 
> There's also a USB2 hub connected, with the Logitech mouse being the
> only thing plugged into it at present.
> 
> The best clue I have of what is happening, other than that it was first
> seen during the late 2.6.23-rc* series, are the following two sets of
> kernel logs.  The first set is from a "normal" fast wake-up,
> and the second set is from the "slow" wake-up seen this morning.
> 
> Both logs show the same information, in pretty much the same order.
> The BIG difference is a bunch of unexplained pauses of exactly 1-second
> each that occur during the slow wakeup.
> 
> The only other difference is that the SATA disk messages are placed
> differently within the two logs.  I'm thinking on that one but it
> doesn't look significant to me.
> 
> The real question is, why the 1-sec pauses?
> 
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> 
> HERE IS THE NORMAL RESUME LOG.
> 
> 
> [  820.147914] CPU1 is down
> [    0.355669] Back to C!
> [    0.356120] Enabling non-boot CPUs ...
> [    0.377167] SMP alternatives: switching to SMP code
> [    0.378565] Booting processor 1/1 eip 3000
> [    0.378568] CPU 1 irqstacks, hard=c0375000 soft=c0373000
> [    0.389374] Initializing CPU#1
> [    0.470225] Calibrating delay using timer specific routine.. 4324.85 
> BogoMIPS (lpj=7204571)
> [    0.470235] CPU: After generic identify, caps: bfebfbff 20100000 
> 00000000 00000000 0000e3bd 00000000 00000001 00000000
> [    0.470244] monitor/mwait feature present.
> [    0.470248] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.470252] CPU: L2 cache: 4096K
> [    0.470255] CPU: Physical Processor ID: 0
> [    0.470257] CPU: Processor Core ID: 1
> [    0.470260] CPU: After all inits, caps: bfebfbff 20100000 00000000 
> 00003940 0000e3bd 00000000 00000001 00000000
> [    0.471330] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz 
> stepping 06
> [    0.471724] CPU1 is up
> [    0.474787] Switched to high resolution mode on CPU 1
> [    0.483415] PM: Writing back config space on device 0000:00:01.0 at 
> offset a (was f, writing 0)
> [    0.483422] PM: Writing back config space on device 0000:00:01.0 at 
> offset 7 (was e0e0, writing 2000e0e0)
> [    0.483428] PM: Writing back config space on device 0000:00:01.0 at 
> offset 3 (was 10000, writing 10010)
> [    0.483869] PCI: Setting latency timer of device 0000:00:01.0 to 64
> [    0.484224] PM: Writing back config space on device 0000:00:1b.0 at 
> offset f (was 100, writing 10b)
> [    0.484244] PM: Writing back config space on device 0000:00:1b.0 at 
> offset 4 (was ffa7c004, writing efffc004)
> [    0.484250] PM: Writing back config space on device 0000:00:1b.0 at 
> offset 3 (was 0, writing 10)
> [    0.484258] PM: Writing back config space on device 0000:00:1b.0 at 
> offset 1 (was 100000, writing 100102)
> [    0.484282] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, 
> low) -> IRQ 20
> [    0.484292] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> [    0.486711] PM: Writing back config space on device 0000:00:1c.0 at 
> offset f (was 100, writing 20100)
> [    0.486725] PM: Writing back config space on device 0000:00:1c.0 at 
> offset 9 (was 10001, writing 1fff1)
> [    0.486731] PM: Writing back config space on device 0000:00:1c.0 at 
> offset 8 (was 0, writing fff0)
> [    0.486738] PM: Writing back config space on device 0000:00:1c.0 at 
> offset 7 (was 0, writing f0)
> [    0.486744] PM: Writing back config space on device 0000:00:1c.0 at 
> offset 6 (was 0, writing b0b00)
> [    0.486753] PM: Writing back config space on device 0000:00:1c.0 at 
> offset 3 (was 810000, writing 810010)
> [    0.486761] PM: Writing back config space on device 0000:00:1c.0 at 
> offset 1 (was 100000, writing 100007)
> [    0.486782] PCI: Setting latency timer of device 0000:00:1c.0 to 64
> [    0.486788] pciehp_resume ENTRY
> [    0.486829] PM: Writing back config space on device 0000:00:1c.1 at 
> offset f (was 200, writing 20200)
> [    0.486841] PM: Writing back config space on device 0000:00:1c.1 at 
> offset 9 (was 10001, writing 1fff1)
> [    0.486848] PM: Writing back config space on device 0000:00:1c.1 at 
> offset 8 (was 0, writing efc0efc0)
> [    0.486854] PM: Writing back config space on device 0000:00:1c.1 at 
> offset 7 (was 20000000, writing 200000f0)
> [    0.486861] PM: Writing back config space on device 0000:00:1c.1 at 
> offset 6 (was 0, writing c0c00)
> [    0.486870] PM: Writing back config space on device 0000:00:1c.1 at 
> offset 3 (was 810000, writing 810010)
> [    0.486877] PM: Writing back config space on device 0000:00:1c.1 at 
> offset 1 (was 100000, writing 100107)
> [    0.486898] PCI: Setting latency timer of device 0000:00:1c.1 to 64
> [    0.486903] pciehp_resume ENTRY
> [    0.488916] pciehp: Device 0000:0c:00.0 already exists at c:0, cannot 
> hot-add
> [    0.488920] pciehp: Cannot add device 0xc:0
> [    0.488949] PM: Writing back config space on device 0000:00:1c.3 at 
> offset f (was 400, writing 20400)
> [    0.488963] PM: Writing back config space on device 0000:00:1c.3 at 
> offset 9 (was 10001, writing e011e001)
> [    0.488969] PM: Writing back config space on device 0000:00:1c.3 at 
> offset 8 (was 0, writing efb0efa0)
> [    0.488976] PM: Writing back config space on device 0000:00:1c.3 at 
> offset 7 (was 0, writing d0d0)
> [    0.488982] PM: Writing back config space on device 0000:00:1c.3 at 
> offset 6 (was 0, writing e0d00)
> [    0.488991] PM: Writing back config space on device 0000:00:1c.3 at 
> offset 3 (was 810000, writing 810010)
> [    0.488998] PM: Writing back config space on device 0000:00:1c.3 at 
> offset 1 (was 100000, writing 100007)
> [    0.489020] PCI: Setting latency timer of device 0000:00:1c.3 to 64
> [    0.489025] pciehp_resume ENTRY
> [    0.489063] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, 
> low) -> IRQ 19
> [    0.489070] PCI: Setting latency timer of device 0000:00:1d.0 to 64
> [    0.489121] usb usb1: root hub lost power or was reset
> [    0.489144] PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
> [    0.489149] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, 
> low) -> IRQ 20
> [    0.489157] PCI: Setting latency timer of device 0000:00:1d.1 to 64
> [    0.489164] PM: Writing back config space on device 0000:00:1d.1 at 
> offset f (was 200, writing 20b)
> [    0.489178] PM: Writing back config space on device 0000:00:1d.1 at 
> offset 8 (was 1, writing bf61)
> [    0.489214] usb usb2: root hub lost power or was reset
> [    0.489236] PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
> [    0.489240] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, 
> low) -> IRQ 21
> [    0.489248] PCI: Setting latency timer of device 0000:00:1d.2 to 64
> [    0.489255] PM: Writing back config space on device 0000:00:1d.2 at 
> offset f (was 300, writing 309)
> [    0.489269] PM: Writing back config space on device 0000:00:1d.2 at 
> offset 8 (was 1, writing bf41)
> [    0.489307] usb usb3: root hub lost power or was reset
> [    0.489329] PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
> [    0.489333] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, 
> low) -> IRQ 22
> [    0.489341] PCI: Setting latency timer of device 0000:00:1d.3 to 64
> [    0.489348] PM: Writing back config space on device 0000:00:1d.3 at 
> offset f (was 400, writing 407)
> [    0.489363] PM: Writing back config space on device 0000:00:1d.3 at 
> offset 8 (was 1, writing bf21)
> [    0.489400] usb usb4: root hub lost power or was reset
> [    0.489535] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, 
> low) -> IRQ 19
> [    0.489543] PCI: Setting latency timer of device 0000:00:1d.7 to 64
> [    0.489622] PM: Writing back config space on device 0000:00:1e.0 at 
> offset 9 (was 100f1, writing 1fff1)
> [    0.489629] PM: Writing back config space on device 0000:00:1e.0 at 
> offset 8 (was 90, writing ef90ef90)
> [    0.489635] PM: Writing back config space on device 0000:00:1e.0 at 
> offset 7 (was 2280e0f0, writing 228000f0)
> [    0.489648] PM: Writing back config space on device 0000:00:1e.0 at 
> offset 1 (was 100007, writing 100107)
> [    0.489668] PCI: Setting latency timer of device 0000:00:1e.0 to 64
> [    0.489707] PM: Writing back config space on device 0000:00:1f.0 at 
> offset 1 (was 2100007, writing 2100107)
> [    0.489872] PM: Writing back config space on device 0000:00:1f.2 at 
> offset f (was 200, writing 205)
> [    0.489908] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, 
> low) -> IRQ 17
> [    0.489915] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> [    0.489933] PM: Writing back config space on device 0000:00:1f.3 at 
> offset f (was 200, writing 205)
> [    0.489963] PM: Writing back config space on device 0000:00:1f.3 at 
> offset 1 (was 2800001, writing 2800101)
> [    0.489981] PM: Writing back config space on device 0000:01:00.0 at 
> offset f (was 1ff, writing 104)
> [    0.489996] PM: Writing back config space on device 0000:01:00.0 at 
> offset 3 (was 0, writing 10)
> [    0.490053] PM: Writing back config space on device 0000:0c:00.0 at 
> offset f (was 100, writing 105)
> [    0.490119] PM: Writing back config space on device 0000:0c:00.0 at 
> offset 4 (was 0, writing efcff000)
> [    0.490133] PM: Writing back config space on device 0000:0c:00.0 at 
> offset 3 (was 0, writing 10)
> [    0.490152] PM: Writing back config space on device 0000:0c:00.0 at 
> offset 1 (was 100000, writing 100106)
> [    0.490217] PM: Writing back config space on device 0000:03:00.0 at 
> offset f (was 100, writing 105)
> [    0.490236] PM: Writing back config space on device 0000:03:00.0 at 
> offset 4 (was 0, writing ef9fe000)
> [    0.490242] PM: Writing back config space on device 0000:03:00.0 at 
> offset 3 (was 0, writing 4000)
> [    0.490250] PM: Writing back config space on device 0000:03:00.0 at 
> offset 1 (was 100000, writing 100106)
> [    0.490267] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, 
> low) -> IRQ 17
> [    0.492382] PM: Writing back config space on device 0000:03:01.0 at 
> offset f (was 4020100, writing 4020103)
> [    0.492403] PM: Writing back config space on device 0000:03:01.0 at 
> offset 4 (was 0, writing ef9fd800)
> [    0.492410] PM: Writing back config space on device 0000:03:01.0 at 
> offset 3 (was 800000, writing 804000)
> [    0.492417] PM: Writing back config space on device 0000:03:01.0 at 
> offset 1 (was 2100000, writing 2100106)
> [    0.493339] PM: Writing back config space on device 0000:03:01.1 at 
> offset f (was 200, writing 209)
> [    0.493361] PM: Writing back config space on device 0000:03:01.1 at 
> offset 4 (was 0, writing ef9fd400)
> [    0.493368] PM: Writing back config space on device 0000:03:01.1 at 
> offset 3 (was 800000, writing 804000)
> [    0.493376] PM: Writing back config space on device 0000:03:01.1 at 
> offset 1 (was 2100000, writing 2100106)
> [    0.493397] ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 18 (level, 
> low) -> IRQ 23
> [    0.493428] PM: Writing back config space on device 0000:03:01.2 at 
> offset f (was 200, writing 209)
> [    0.493449] PM: Writing back config space on device 0000:03:01.2 at 
> offset 4 (was 0, writing ef9fd500)
> [    0.493459] PM: Writing back config space on device 0000:03:01.2 at 
> offset 1 (was 2100000, writing 2100106)
> [    0.493480] PM: Writing back config space on device 0000:03:01.3 at 
> offset f (was 200, writing 209)
> [    0.493500] PM: Writing back config space on device 0000:03:01.3 at 
> offset 4 (was 0, writing ef9fd600)
> [    0.493509] PM: Writing back config space on device 0000:03:01.3 at 
> offset 1 (was 2100000, writing 2100102)
> [    0.493530] PM: Writing back config space on device 0000:03:01.4 at 
> offset f (was 200, writing 209)
> [    0.493550] PM: Writing back config space on device 0000:03:01.4 at 
> offset 4 (was 0, writing ef9fd700)
> [    0.493559] PM: Writing back config space on device 0000:03:01.4 at 
> offset 1 (was 2100000, writing 2100102)
> [    0.493599] pciehp_resume ENTRY
> [    0.493633] pciehp_resume ENTRY
> [    0.503412] ata2.00: configured for UDMA/33
> [    0.505628] pciehp: Device 0000:0c:00.0 already exists at c:0, cannot 
> hot-add
> [    0.505633] pciehp: Cannot add device 0xc:0
> [    0.505654] pciehp_resume ENTRY
> [    0.505972] sd 0:0:0:0: [sda] Starting disk
> [    0.601233] ata1.00: configured for UDMA/133
> [    0.624888] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors 
> (160042 MB)
> [    0.624910] sd 0:0:0:0: [sda] Write Protect is off
> [    0.624914] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.624943] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
> enabled, doesn't support DPO or FUA
> [    0.801255] b44: eth0: Link is up at 100 Mbps, full duplex.
> [    0.801260] b44: eth0: Flow control is off for TX and off for RX.
> [    0.834760] Restarting tasks ... <6>usb 5-1: USB disconnect, address 17
> [    0.972042] done.
> [    0.998126] usb 5-1: new high speed USB device using ehci_hcd and 
> address 21
> [    1.121762] usb 5-1: configuration #1 chosen from 1 choice
> [    1.121912] hub 5-1:1.0: USB hub found
> [    1.121994] hub 5-1:1.0: 4 ports detected
> [    1.224647] usb 5-7: USB disconnect, address 18
> [    1.224651] usb 5-7.1: USB disconnect, address 20
> [    1.334249] usb 5-7: new high speed USB device using ehci_hcd and 
> address 22
> [    1.479331] usb 5-7: configuration #1 chosen from 1 choice
> [    1.479760] hub 5-7:1.0: USB hub found
> [    1.480770] hub 5-7:1.0: 4 ports detected
> [    1.782796] usb 5-1.4: new full speed USB device using ehci_hcd and 
> address 23
> [    1.884536] usb 5-1.4: configuration #1 chosen from 1 choice
> [    2.079252] usb 5-7.1: new low speed USB device using ehci_hcd and 
> address 24
> [    2.166603] usb 5-7.1: configuration #1 chosen from 1 choice
> [    2.169524] input: Logitech Optical USB Mouse as /class/input/input11
> [    2.170506] input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] 
> on usb-0000:00:1d.7-7.1
> 
> 
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> 
> HERE IS THE SLOW RESUME LOG.  Note the 1-second pauses..
> 
> 
> [ 3725.539992] CPU1 is down
> [    0.354353] Back to C!
> [    0.354793] Enabling non-boot CPUs ...
> [    0.389097] SMP alternatives: switching to SMP code
> [    0.389884] Booting processor 1/1 eip 3000
> [    0.389886] CPU 1 irqstacks, hard=c0375000 soft=c0373000
> [    0.401516] Initializing CPU#1
> [    0.482207] Calibrating delay using timer specific routine.. 4324.78 
> BogoMIPS (lpj=7204462)
> [    0.482212] CPU: After generic identify, caps: bfebfbff 20100000 
> 00000000 00000000 0000e3bd 00000000 00000001 00000000
> [    0.482217] monitor/mwait feature present.
> [    0.482219] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.482221] CPU: L2 cache: 4096K
> [    0.482222] CPU: Physical Processor ID: 0
> [    0.482223] CPU: Processor Core ID: 1
> [    0.482225] CPU: After all inits, caps: bfebfbff 20100000 00000000 
> 00003940 0000e3bd 00000000 00000001 00000000
> [    0.482814] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz 
> stepping 06
> [    0.483053] CPU1 is up
> [    0.486165] Switched to high resolution mode on CPU 1
> [    0.490338] PM: Writing back config space on device 0000:00:01.0 at 
> offset a (was f, writing 0)
> [    0.490342] PM: Writing back config space on device 0000:00:01.0 at 
> offset 7 (was e0e0, writing 2000e0e0)
> [    0.490345] PM: Writing back config space on device 0000:00:01.0 at 
> offset 3 (was 10000, writing 10010)
> [    0.490351] PCI: Setting latency timer of device 0000:00:01.0 to 64
> [    0.490605] PM: Writing back config space on device 0000:00:1b.0 at 
> offset f (was 100, writing 10b)
> [    0.490626] PM: Writing back config space on device 0000:00:1b.0 at 
> offset 4 (was ffa7c004, writing efffc004)
> [    0.490632] PM: Writing back config space on device 0000:00:1b.0 at 
> offset 3 (was 0, writing 10)
> [    0.490640] PM: Writing back config space on device 0000:00:1b.0 at 
> offset 1 (was 100000, writing 100102)
> [    0.490665] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, 
> low) -> IRQ 20
> [    0.490674] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> [    1.492418] PM: Writing back config space on device 0000:00:1c.0 at 
> offset f (was 100, writing 20100)
> [    1.492432] PM: Writing back config space on device 0000:00:1c.0 at 
> offset 9 (was 10001, writing 1fff1)
> [    1.492438] PM: Writing back config space on device 0000:00:1c.0 at 
> offset 8 (was 0, writing fff0)
> [    1.492445] PM: Writing back config space on device 0000:00:1c.0 at 
> offset 7 (was 0, writing f0)
> [    1.492451] PM: Writing back config space on device 0000:00:1c.0 at 
> offset 6 (was 0, writing b0b00)
> [    1.492460] PM: Writing back config space on device 0000:00:1c.0 at 
> offset 3 (was 810000, writing 810010)
> [    1.492468] PM: Writing back config space on device 0000:00:1c.0 at 
> offset 1 (was 100000, writing 100007)
> [    1.492490] PCI: Setting latency timer of device 0000:00:1c.0 to 64
> [    1.492496] pciehp_resume ENTRY
> [    1.492539] PM: Writing back config space on device 0000:00:1c.1 at 
> offset f (was 200, writing 20200)
> [    1.492552] PM: Writing back config space on device 0000:00:1c.1 at 
> offset 9 (was 10001, writing 1fff1)
> [    1.492559] PM: Writing back config space on device 0000:00:1c.1 at 
> offset 8 (was 0, writing efc0efc0)
> [    1.492565] PM: Writing back config space on device 0000:00:1c.1 at 
> offset 7 (was 20000000, writing f0)
> [    1.492572] PM: Writing back config space on device 0000:00:1c.1 at 
> offset 6 (was 0, writing c0c00)
> [    1.492581] PM: Writing back config space on device 0000:00:1c.1 at 
> offset 3 (was 810000, writing 810010)
> [    1.492588] PM: Writing back config space on device 0000:00:1c.1 at 
> offset 1 (was 100000, writing 100107)
> [    1.492610] PCI: Setting latency timer of device 0000:00:1c.1 to 64
> [    1.492615] pciehp_resume ENTRY
> [    1.493885] pciehp: Device 0000:0c:00.0 already exists at c:0, cannot 
> hot-add
> [    1.493889] pciehp: Cannot add device 0xc:0
> [    1.493916] PM: Writing back config space on device 0000:00:1c.3 at 
> offset f (was 400, writing 20400)
> [    1.493929] PM: Writing back config space on device 0000:00:1c.3 at 
> offset 9 (was 10001, writing e011e001)
> [    1.493936] PM: Writing back config space on device 0000:00:1c.3 at 
> offset 8 (was 0, writing efb0efa0)
> [    1.493942] PM: Writing back config space on device 0000:00:1c.3 at 
> offset 7 (was 0, writing d0d0)
> [    1.493949] PM: Writing back config space on device 0000:00:1c.3 at 
> offset 6 (was 0, writing e0d00)
> [    1.493958] PM: Writing back config space on device 0000:00:1c.3 at 
> offset 3 (was 810000, writing 810010)
> [    1.493966] PM: Writing back config space on device 0000:00:1c.3 at 
> offset 1 (was 100000, writing 100007)
> [    1.493987] PCI: Setting latency timer of device 0000:00:1c.3 to 64
> [    1.493992] pciehp_resume ENTRY
> [    1.494028] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, 
> low) -> IRQ 19
> [    1.494036] PCI: Setting latency timer of device 0000:00:1d.0 to 64
> [    1.494088] usb usb1: root hub lost power or was reset
> [    1.494110] PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
> [    1.494114] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, 
> low) -> IRQ 20
> [    1.494122] PCI: Setting latency timer of device 0000:00:1d.1 to 64
> [    1.494130] PM: Writing back config space on device 0000:00:1d.1 at 
> offset f (was 200, writing 20b)
> [    1.494144] PM: Writing back config space on device 0000:00:1d.1 at 
> offset 8 (was 1, writing bf61)
> [    1.494180] usb usb2: root hub lost power or was reset
> [    1.494202] PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
> [    1.494206] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, 
> low) -> IRQ 21
> [    1.494214] PCI: Setting latency timer of device 0000:00:1d.2 to 64
> [    1.494222] PM: Writing back config space on device 0000:00:1d.2 at 
> offset f (was 300, writing 309)
> [    1.494236] PM: Writing back config space on device 0000:00:1d.2 at 
> offset 8 (was 1, writing bf41)
> [    1.494273] usb usb3: root hub lost power or was reset
> [    1.494295] PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
> [    1.494299] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, 
> low) -> IRQ 22
> [    1.494307] PCI: Setting latency timer of device 0000:00:1d.3 to 64
> [    1.494314] PM: Writing back config space on device 0000:00:1d.3 at 
> offset f (was 400, writing 407)
> [    1.494328] PM: Writing back config space on device 0000:00:1d.3 at 
> offset 8 (was 1, writing bf21)
> [    1.494365] usb usb4: root hub lost power or was reset
> [    1.496460] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, 
> low) -> IRQ 19
> [    1.496468] PCI: Setting latency timer of device 0000:00:1d.7 to 64
> [    1.496534] PM: Writing back config space on device 0000:00:1e.0 at 
> offset 9 (was 100f1, writing 1fff1)
> [    1.496542] PM: Writing back config space on device 0000:00:1e.0 at 
> offset 8 (was 90, writing ef90ef90)
> [    1.496551] PM: Writing back config space on device 0000:00:1e.0 at 
> offset 7 (was 2280e0f0, writing 228000f0)
> [    1.496570] PM: Writing back config space on device 0000:00:1e.0 at 
> offset 1 (was 100007, writing 100107)
> [    1.496590] PCI: Setting latency timer of device 0000:00:1e.0 to 64
> [    1.496629] PM: Writing back config space on device 0000:00:1f.0 at 
> offset 1 (was 2100007, writing 2100107)
> [    1.745307] PM: Writing back config space on device 0000:00:1f.2 at 
> offset f (was 200, writing 205)
> [    1.745344] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, 
> low) -> IRQ 17
> [    1.745351] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> [    1.745369] PM: Writing back config space on device 0000:00:1f.3 at 
> offset f (was 200, writing 205)
> [    1.745406] PM: Writing back config space on device 0000:00:1f.3 at 
> offset 1 (was 2800001, writing 2800101)
> [    1.745430] PM: Writing back config space on device 0000:01:00.0 at 
> offset f (was 1ff, writing 104)
> [    1.745453] PM: Writing back config space on device 0000:01:00.0 at 
> offset 3 (was 0, writing 10)
> [    1.745514] PM: Writing back config space on device 0000:0c:00.0 at 
> offset f (was 100, writing 105)
> [    1.745584] PM: Writing back config space on device 0000:0c:00.0 at 
> offset 4 (was 0, writing efcff000)
> [    1.745600] PM: Writing back config space on device 0000:0c:00.0 at 
> offset 3 (was 0, writing 10)
> [    1.745623] PM: Writing back config space on device 0000:0c:00.0 at 
> offset 1 (was 100000, writing 100106)
> [    1.745709] PM: Writing back config space on device 0000:03:00.0 at 
> offset f (was 100, writing 105)
> [    1.745729] PM: Writing back config space on device 0000:03:00.0 at 
> offset 4 (was 0, writing ef9fe000)
> [    1.745735] PM: Writing back config space on device 0000:03:00.0 at 
> offset 3 (was 0, writing 4000)
> [    1.745743] PM: Writing back config space on device 0000:03:00.0 at 
> offset 1 (was 100000, writing 100106)
> [    1.745765] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, 
> low) -> IRQ 17
> [    2.753018] PM: Writing back config space on device 0000:03:01.0 at 
> offset f (was 4020100, writing 4020103)
> [    2.753038] PM: Writing back config space on device 0000:03:01.0 at 
> offset 4 (was 0, writing ef9fd800)
> [    2.753045] PM: Writing back config space on device 0000:03:01.0 at 
> offset 3 (was 800000, writing 804000)
> [    2.753053] PM: Writing back config space on device 0000:03:01.0 at 
> offset 1 (was 2100000, writing 2100106)
> [    3.756771] ata1.00: configured for UDMA/133
> [    3.756818] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors 
> (160042 MB)
> [    3.756836] sd 0:0:0:0: [sda] Write Protect is off
> [    3.756840] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.756868] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
> enabled, doesn't support DPO or FUA
> [    4.763813] b44: eth0: Link is up at 100 Mbps, full duplex.
> [    4.763817] b44: eth0: Flow control is off for TX and off for RX.
> [    4.764090] PM: Writing back config space on device 0000:03:01.1 at 
> offset f (was 200, writing 209)
> [    4.764111] PM: Writing back config space on device 0000:03:01.1 at 
> offset 4 (was 0, writing ef9fd400)
> [    4.764118] PM: Writing back config space on device 0000:03:01.1 at 
> offset 3 (was 800000, writing 804000)
> [    4.764126] PM: Writing back config space on device 0000:03:01.1 at 
> offset 1 (was 2100000, writing 2100106)
> [    4.764145] ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 18 (level, 
> low) -> IRQ 23
> [    4.764171] PM: Writing back config space on device 0000:03:01.2 at 
> offset f (was 200, writing 209)
> [    4.764191] PM: Writing back config space on device 0000:03:01.2 at 
> offset 4 (was 0, writing ef9fd500)
> [    4.764201] PM: Writing back config space on device 0000:03:01.2 at 
> offset 1 (was 2100000, writing 2100106)
> [    4.764222] PM: Writing back config space on device 0000:03:01.3 at 
> offset f (was 200, writing 209)
> [    4.764242] PM: Writing back config space on device 0000:03:01.3 at 
> offset 4 (was 0, writing ef9fd600)
> [    4.764251] PM: Writing back config space on device 0000:03:01.3 at 
> offset 1 (was 2100000, writing 2100102)
> [    4.764273] PM: Writing back config space on device 0000:03:01.4 at 
> offset f (was 200, writing 209)
> [    4.764293] PM: Writing back config space on device 0000:03:01.4 at 
> offset 4 (was 0, writing ef9fd700)
> [    4.764303] PM: Writing back config space on device 0000:03:01.4 at 
> offset 1 (was 2100000, writing 2100102)
> [    4.764340] pciehp_resume ENTRY
> [    4.764369] pciehp_resume ENTRY
> [    5.765432] ata2.00: configured for UDMA/33
> [    5.767529] pciehp: Device 0000:0c:00.0 already exists at c:0, cannot 
> hot-add
> [    5.767532] pciehp: Cannot add device 0xc:0
> [    5.767547] pciehp_resume ENTRY
> [    5.767864] sd 0:0:0:0: [sda] Starting disk
> [    7.750047] Restarting tasks ... done.
> [    7.830571] usb 5-1: USB disconnect, address 21
> [    8.126832] usb 5-1: new high speed USB device using ehci_hcd and 
> address 25
> [   10.230397] usb 5-1: configuration #1 chosen from 1 choice
> [   10.230517] hub 5-1:1.0: USB hub found
> [   10.230545] hub 5-1:1.0: 4 ports detected
> [   10.281481] usb 5-7: USB disconnect, address 22
> [   10.281489] usb 5-7.1: USB disconnect, address 24
> [   10.889785] usb 5-7: new high speed USB device using ehci_hcd and 
> address 26
> [   11.658319] usb 5-7: configuration #1 chosen from 1 choice
> [   11.658631] hub 5-7:1.0: USB hub found
> [   11.658985] hub 5-7:1.0: 4 ports detected
> [   13.190055] usb 5-1.4: new full speed USB device using ehci_hcd and 
> address 27
> [   13.961678] usb 5-1.4: configuration #1 chosen from 1 choice
> [   14.171766] usb 5-7.1: new low speed USB device using ehci_hcd and 
> address 28
> [   14.295838] usb 5-7.1: configuration #1 chosen from 1 choice
> [   14.298596] input: Logitech Optical USB Mouse as /class/input/input12
> [   14.299091] input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] 
> on usb-0000:00:1d.7-7.1
..

This is still happening.  I was hoping my PCIe hotplug bug+fix might have
been related, but no it happened just now after that fix.

Since Ingo's latency trace patches lock up the machine on resume,
the next thing I'll try instead is to re-enable CONFIG_IRQBALANCE=y.

I think that I turned that flag off at around the same time as this
problem began, maybe they're related (?).

I did notice that CONFIG_IRQBALANCE=y *is* necessary to keep my myth box
from having 1-second audio dropouts (2.6.23.1) during playback, so maybe
that same 1-second lockout is happening on this box as well (?).

Cheers 
