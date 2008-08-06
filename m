Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYHFV2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYHFV2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbYHFVSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:18:33 -0400
Received: from cpsmtpo-eml05.kpnxchange.com ([213.75.38.154]:13342 "EHLO
	cpsmtpo-eml05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762907AbYHFVSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:18:15 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [regression?] usb: new errors during device detection
Date: Wed, 6 Aug 2008 23:10:58 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0808041006060.2815-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808041006060.2815-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_jNhmInBanxjaRgQ"
Message-Id: <200808062310.59360.elendil@planet.nl>
X-OriginalArrivalTime: 06 Aug 2008 21:11:19.0389 (UTC) FILETIME=[F89350D0:01C8F808]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_jNhmInBanxjaRgQ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Alan,

On Monday 04 August 2008, Alan Stern wrote:
> > +usb 3-1: device not accepting address 2, error -71
> > +hub 3-0:1.0: unable to enumerate USB device on port 1
>
> The difference is most likely meaningless; it is probably caused a
> different order of initialization of the EHCI and UHCI controllers.

Meaningless, but annoying. Especially as such "errors" get through to the 
console when you boot with the 'quiet' boot parameter and thus draw more 
attention with "regular" users than they are really worth.

> > Note that 3-1 is first assigned address 2 and then 4. With 2.6.26 3-1
> > did not have any problem accepting address 2. I assume the "unable to
> > enumerate" error is a result of the rejection of the address?
>
> No.  It is caused by the EHCI controller being initialized.
>
> When an EHCI controller is initialized, it switches all the USB
> connections from its companion controllers to itself.  Hence any device
> which _was_ connected to the UHCI controller will _now_ be connected to
> the EHCI controller.  Consequently the UHCI controller is unable to
> communicate with the device and cannot enumerate it.
>
> After a short time, the EHCI controller driver realizes that the device
> can't run at high speed and switches it back to the UHCI controller.
> At that point it gets enumerated for the second time, successfully.
>
> The difference must have been that under 2.6.26 the EHCI controller was
> initialized _before_ the 3-1 device was detected, so there was no
> aborted attempt at enumeration.

Thanks for the explanation. Attached boot messages (for -rc2) with usb 
debug enabled as suggested by Felipe Balbi. Messages have been extracted 
from kern.log (dmesg had already overflowed).

If I filter out messages related to bus 3 (PCI 1d.2) what I see is:
[...]
! usb 3-1: new low speed USB device using uhci_hcd and address 2
[ EHCI Host Controller gets initialized here for bus 5 ]
! usb 3-1: uhci_result_common: failed with status 440000
! usb 3-1: device not accepting address 2, error -71
! hub 3-0:1.0: unable to enumerate USB device on port 1
! hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
! hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
! uhci_hcd 0000:00:1d.2: port 1 portsc 01a3,00
! hub 3-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
! hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
! usb 3-1: new low speed USB device using uhci_hcd and address 4
[...]

I guess that does match your description.

I do find it a bit strange though that EHCI is allowed to grab bus 3 when 
UHCI has already identified a low speed device on that bus.

> If you want to prevent all errors of this sort, all you have to do is
> insure that ehci-hcd is loaded before either uhci-hcd or ohci-hcd
> during system startup.

Hmmm. Also not sure that I'm ready to agree with this conclusion.

Shouldn't the kernel itself be smart enough to prevent error messages in 
apparently predictable and probably fairly common scenarios?

To me this seems a lot like an issue discussed during the .25 cycle in
   http://lkml.org/lkml/2008/5/2/256
which was eventually fixed by you with
   3a31155c Alan Stern, "USB: EHCI: suppress unwanted error messages"

Cheers,
FJP


--Boundary-00=_jNhmInBanxjaRgQ
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="usb-debug_2.6.27-rc2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="usb-debug_2.6.27-rc2"

Aug  6 22:05:32 faramir kernel: Linux version 2.6.27-rc2 (root@faramir) (gcc version 4.3.1 (Debian 4.3.1-8) ) #38 SMP Wed Aug 6 12:00:16 CEST 2008
Aug  6 22:05:32 faramir kernel: Command line: root=/dev/mapper/main-root ro vga=791 quiet
Aug  6 22:05:32 faramir kernel: KERNEL supported cpus:
Aug  6 22:05:32 faramir kernel:   Intel GenuineIntel
Aug  6 22:05:32 faramir kernel:   AMD AuthenticAMD
Aug  6 22:05:32 faramir kernel:   Centaur CentaurHauls
Aug  6 22:05:32 faramir kernel: BIOS-provided physical RAM map:
Aug  6 22:05:32 faramir kernel:  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Aug  6 22:05:32 faramir kernel:  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Aug  6 22:05:32 faramir kernel:  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Aug  6 22:05:32 faramir kernel:  BIOS-e820: 0000000000100000 - 000000007f674000 (usable)
Aug  6 22:05:32 faramir kernel:  BIOS-e820: 000000007f674000 - 000000007f6e9000 (ACPI NVS)
Aug  6 22:05:32 faramir kernel:  BIOS-e820: 000000007f6e9000 - 000000007f6ec000 (usable)
Aug  6 22:05:32 faramir kernel:  BIOS-e820: 000000007f6ec000 - 000000007f6ff000 (ACPI data)
Aug  6 22:05:32 faramir kernel:  BIOS-e820: 000000007f6ff000 - 000000007f700000 (usable)
Aug  6 22:05:32 faramir kernel: last_pfn = 0x7f700 max_arch_pfn = 0x3ffffffff
Aug  6 22:05:32 faramir kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Aug  6 22:05:32 faramir kernel: init_memory_mapping
Aug  6 22:05:32 faramir kernel:  0000000000 - 007f600000 page 2M
Aug  6 22:05:32 faramir kernel:  007f600000 - 007f700000 page 4k
Aug  6 22:05:32 faramir kernel: kernel direct mapping tables up to 7f700000 @ 8000-c000
Aug  6 22:05:32 faramir kernel: last_map_addr: 7f700000 end: 7f700000
Aug  6 22:05:32 faramir kernel: RAMDISK: 37c00000 - 37fef25e
Aug  6 22:05:32 faramir kernel: DMI 2.3 present.
Aug  6 22:05:32 faramir kernel: ACPI: RSDP 000FE020, 0014 (r0 INTEL )
Aug  6 22:05:32 faramir kernel: ACPI: RSDT 7F6FDE48, 0058 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: FACP 7F6FCF10, 0074 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: DSDT 7F6F7010, 4348 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: FACS 7F6E2C40, 0040
Aug  6 22:05:32 faramir kernel: ACPI: APIC 7F6FCE10, 0078 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: WDDT 7F6F6F90, 0040 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: MCFG 7F6F6F10, 003C (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: ASF! 7F6FCD10, 00A6 (r32 INTEL  D945GCZ       FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: HPET 7F6F6E90, 0038 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: SSDT 7F6FDC10, 01BC (r1 INTEL     CpuPm      FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: SSDT 7F6FDA10, 0175 (r1 INTEL   Cpu0Ist      FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: SSDT 7F6FD810, 0175 (r1 INTEL   Cpu1Ist      FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: SSDT 7F6FD610, 0175 (r1 INTEL   Cpu2Ist      FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: SSDT 7F6FD410, 0175 (r1 INTEL   Cpu3Ist      FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: SSDT 7F6F6E10, 002F (r1 INTEL  SetupVar      FF9 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: ACPI: TCPA 7F6E4D90, 0032 (r1 INTEL  TIANO           2 MSFT  1000013)
Aug  6 22:05:32 faramir kernel: No NUMA configuration found
Aug  6 22:05:32 faramir kernel: Faking a node at 0000000000000000-000000007f700000
Aug  6 22:05:32 faramir kernel: Bootmem setup node 0 0000000000000000-000000007f700000
Aug  6 22:05:32 faramir kernel:   NODE_DATA [0000000000001000 - 0000000000005fff]
Aug  6 22:05:32 faramir kernel:   bootmap [000000000000a000 -  0000000000019edf] pages 10
Aug  6 22:05:32 faramir kernel: (6 early reservations) ==> bootmem [0000000000 - 007f700000]
Aug  6 22:05:32 faramir kernel:   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Aug  6 22:05:32 faramir kernel:   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Aug  6 22:05:32 faramir kernel:   #2 [0000200000 - 00008cc8c8]    TEXT DATA BSS ==> [0000200000 - 00008cc8c8]
Aug  6 22:05:32 faramir kernel:   #3 [0037c00000 - 0037fef25e]          RAMDISK ==> [0037c00000 - 0037fef25e]
Aug  6 22:05:32 faramir kernel:   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
Aug  6 22:05:32 faramir kernel:   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
Aug  6 22:05:32 faramir kernel: Scan SMP from ffff880000000000 for 1024 bytes.
Aug  6 22:05:32 faramir kernel: Scan SMP from ffff88000009fc00 for 1024 bytes.
Aug  6 22:05:32 faramir kernel: Scan SMP from ffff8800000f0000 for 65536 bytes.
Aug  6 22:05:32 faramir kernel: found SMP MP-table at [ffff8800000fe680] 000fe680
Aug  6 22:05:32 faramir kernel:  [ffffe20000000000-ffffe20002bfffff] PMD -> [ffff880001200000-ffff880003dfffff] on node 0
Aug  6 22:05:32 faramir kernel: Zone PFN ranges:
Aug  6 22:05:32 faramir kernel:   DMA      0x00000000 -> 0x00001000
Aug  6 22:05:32 faramir kernel:   DMA32    0x00001000 -> 0x00100000
Aug  6 22:05:32 faramir kernel:   Normal   0x00100000 -> 0x00100000
Aug  6 22:05:32 faramir kernel: Movable zone start PFN for each node
Aug  6 22:05:32 faramir kernel: early_node_map[4] active PFN ranges
Aug  6 22:05:32 faramir kernel:     0: 0x00000000 -> 0x0000009f
Aug  6 22:05:32 faramir kernel:     0: 0x00000100 -> 0x0007f674
Aug  6 22:05:32 faramir kernel:     0: 0x0007f6e9 -> 0x0007f6ec
Aug  6 22:05:32 faramir kernel:     0: 0x0007f6ff -> 0x0007f700
Aug  6 22:05:32 faramir kernel: On node 0 totalpages: 521751
Aug  6 22:05:32 faramir kernel:   DMA zone: 2068 pages, LIFO batch:0
Aug  6 22:05:32 faramir kernel:   DMA32 zone: 506625 pages, LIFO batch:31
Aug  6 22:05:32 faramir kernel: ACPI: PM-Timer IO Port: 0x408
Aug  6 22:05:32 faramir kernel: ACPI: Local APIC address 0xfee00000
Aug  6 22:05:32 faramir kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Aug  6 22:05:32 faramir kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Aug  6 22:05:32 faramir kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
Aug  6 22:05:32 faramir kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
Aug  6 22:05:32 faramir kernel: ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
Aug  6 22:05:32 faramir kernel: ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
Aug  6 22:05:32 faramir kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Aug  6 22:05:32 faramir kernel: IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
Aug  6 22:05:32 faramir kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Aug  6 22:05:32 faramir kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Aug  6 22:05:32 faramir kernel: ACPI: IRQ0 used by override.
Aug  6 22:05:32 faramir kernel: ACPI: IRQ2 used by override.
Aug  6 22:05:32 faramir kernel: ACPI: IRQ9 used by override.
Aug  6 22:05:32 faramir kernel: Setting APIC routing to flat
Aug  6 22:05:32 faramir kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
Aug  6 22:05:32 faramir kernel: Using ACPI (MADT) for SMP configuration information
Aug  6 22:05:32 faramir kernel: SMP: Allowing 4 CPUs, 2 hotplug CPUs
Aug  6 22:05:32 faramir kernel: PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Aug  6 22:05:32 faramir kernel: PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
Aug  6 22:05:32 faramir kernel: PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Aug  6 22:05:32 faramir kernel: PM: Registered nosave memory: 000000007f674000 - 000000007f6e9000
Aug  6 22:05:32 faramir kernel: PM: Registered nosave memory: 000000007f6ec000 - 000000007f6ff000
Aug  6 22:05:32 faramir kernel: Allocating PCI resources starting at 80000000 (gap: 7f700000:80900000)
Aug  6 22:05:32 faramir kernel: PERCPU: Allocating 46784 bytes of per cpu data
Aug  6 22:05:32 faramir kernel: NR_CPUS: 8, nr_cpu_ids: 4, nr_node_ids 1
Aug  6 22:05:32 faramir kernel: Built 1 zonelists in Node order, mobility grouping on.  Total pages: 508693
Aug  6 22:05:32 faramir kernel: Policy zone: DMA32
Aug  6 22:05:32 faramir kernel: Kernel command line: root=/dev/mapper/main-root ro vga=791 quiet
Aug  6 22:05:32 faramir kernel: Initializing CPU#0
Aug  6 22:05:32 faramir kernel: PID hash table entries: 4096 (order: 12, 32768 bytes)
Aug  6 22:05:32 faramir kernel: TSC calibrated against PM_TIMER
Aug  6 22:05:32 faramir kernel: Detected 3199.877 MHz processor.
Aug  6 22:05:32 faramir kernel: Console: colour dummy device 80x25
Aug  6 22:05:32 faramir kernel: console [tty0] enabled
Aug  6 22:05:32 faramir kernel: Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Aug  6 22:05:32 faramir kernel: ... MAX_LOCKDEP_SUBCLASSES:    8
Aug  6 22:05:32 faramir kernel: ... MAX_LOCK_DEPTH:          48
Aug  6 22:05:32 faramir kernel: ... MAX_LOCKDEP_KEYS:        2048
Aug  6 22:05:32 faramir kernel: ... CLASSHASH_SIZE:           1024
Aug  6 22:05:32 faramir kernel: ... MAX_LOCKDEP_ENTRIES:     8192
Aug  6 22:05:32 faramir kernel: ... MAX_LOCKDEP_CHAINS:      16384
Aug  6 22:05:32 faramir kernel: ... CHAINHASH_SIZE:          8192
Aug  6 22:05:32 faramir kernel:  memory used by lock dependency info: 1776 kB
Aug  6 22:05:32 faramir kernel:  per task-struct memory footprint: 2688 bytes
Aug  6 22:05:32 faramir kernel: Checking aperture...
Aug  6 22:05:32 faramir kernel: No AGP bridge found
Aug  6 22:05:32 faramir kernel: Calgary: detecting Calgary via BIOS EBDA area
Aug  6 22:05:32 faramir kernel: Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Aug  6 22:05:32 faramir kernel: Memory: 2030512k/2087936k available (2292k kernel code, 56492k reserved, 1439k data, 368k init)
Aug  6 22:05:32 faramir kernel: CPA: page pool initialized 1 of 1 pages preallocated
Aug  6 22:05:32 faramir kernel: SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Aug  6 22:05:32 faramir kernel: hpet clockevent registered
Aug  6 22:05:32 faramir kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 6399.75 BogoMIPS (lpj=12799508)
Aug  6 22:05:32 faramir kernel: Security Framework initialized
Aug  6 22:05:32 faramir kernel: SELinux:  Disabled at boot.
Aug  6 22:05:32 faramir kernel: Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Aug  6 22:05:32 faramir kernel: Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Aug  6 22:05:32 faramir kernel: Mount-cache hash table entries: 256
Aug  6 22:05:32 faramir kernel: CPU: Trace cache: 12K uops, L1 D cache: 16K
Aug  6 22:05:32 faramir kernel: CPU: L2 cache: 1024K
Aug  6 22:05:32 faramir kernel: CPU 0/0 -> Node 0
Aug  6 22:05:32 faramir kernel: CPU: Physical Processor ID: 0
Aug  6 22:05:32 faramir kernel: CPU: Processor Core ID: 0
Aug  6 22:05:32 faramir kernel: CPU0: Thermal monitoring enabled (TM1)
Aug  6 22:05:32 faramir kernel: using mwait in idle threads.
Aug  6 22:05:32 faramir kernel: ACPI: Core revision 20080609
Aug  6 22:05:32 faramir kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Aug  6 22:05:32 faramir kernel: CPU0:               Intel(R) Pentium(R) D CPU 3.20GHz stepping 07
Aug  6 22:05:32 faramir kernel: Using local APIC timer interrupts.
Aug  6 22:05:32 faramir kernel: APIC timer calibration result 12499523
Aug  6 22:05:32 faramir kernel: Detected 12.499 MHz APIC timer.
Aug  6 22:05:32 faramir kernel: lockdep: fixing up alternatives.
Aug  6 22:05:32 faramir kernel: Booting processor 1/1 ip 6000
Aug  6 22:05:32 faramir kernel: Initializing CPU#1
Aug  6 22:05:32 faramir kernel: Calibrating delay using timer specific routine.. 6399.95 BogoMIPS (lpj=12799908)
Aug  6 22:05:32 faramir kernel: CPU: Trace cache: 12K uops, L1 D cache: 16K
Aug  6 22:05:32 faramir kernel: CPU: L2 cache: 1024K
Aug  6 22:05:32 faramir kernel: CPU 1/1 -> Node 0
Aug  6 22:05:32 faramir kernel: CPU: Physical Processor ID: 0
Aug  6 22:05:32 faramir kernel: CPU: Processor Core ID: 1
Aug  6 22:05:32 faramir kernel: CPU1: Thermal monitoring enabled (TM1)
Aug  6 22:05:32 faramir kernel: x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
Aug  6 22:05:32 faramir kernel: CPU1:               Intel(R) Pentium(R) D CPU 3.20GHz stepping 07
Aug  6 22:05:32 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Aug  6 22:05:32 faramir kernel: Brought up 2 CPUs
Aug  6 22:05:32 faramir kernel: Total of 2 processors activated (12799.70 BogoMIPS).
Aug  6 22:05:32 faramir kernel: CPU0 attaching sched-domain:
Aug  6 22:05:32 faramir kernel:  domain 0: span 0-1 level CPU
Aug  6 22:05:32 faramir kernel:   groups: 0 1
Aug  6 22:05:32 faramir kernel:   domain 1: span 0-1 level NODE
Aug  6 22:05:32 faramir kernel:    groups: 0-1
Aug  6 22:05:32 faramir kernel: CPU1 attaching sched-domain:
Aug  6 22:05:32 faramir kernel:  domain 0: span 0-1 level CPU
Aug  6 22:05:32 faramir kernel:   groups: 1 0
Aug  6 22:05:32 faramir kernel:   domain 1: span 0-1 level NODE
Aug  6 22:05:32 faramir kernel:    groups: 0-1
Aug  6 22:05:32 faramir kernel: net_namespace: 1624 bytes
Aug  6 22:05:32 faramir kernel: NET: Registered protocol family 16
Aug  6 22:05:32 faramir kernel: ACPI: bus type pci registered
Aug  6 22:05:32 faramir kernel: PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub without MMCONFIG support.
Aug  6 22:05:32 faramir kernel: PCI: Using configuration type 1 for base access
Aug  6 22:05:32 faramir kernel: ACPI: EC: Look up EC in DSDT
Aug  6 22:05:32 faramir kernel: ACPI: Interpreter enabled
Aug  6 22:05:32 faramir kernel: ACPI: (supports S0 S1 S3 S4 S5)
Aug  6 22:05:32 faramir kernel: ACPI: Using IOAPIC for interrupt routing
Aug  6 22:05:32 faramir kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Aug  6 22:05:32 faramir kernel: pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Aug  6 22:05:32 faramir kernel: pci 0000:00:1b.0: PME# disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.0: PME# disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.2: PME# disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.3: PME# disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.4: PME# disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.5: PME# disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
Aug  6 22:05:32 faramir kernel: pci 0000:00:1d.7: PME# disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
Aug  6 22:05:32 faramir kernel: pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
Aug  6 22:05:32 faramir kernel: pci 0000:00:1f.2: PME# supported from D3hot
Aug  6 22:05:32 faramir kernel: pci 0000:00:1f.2: PME# disabled
Aug  6 22:05:32 faramir kernel: pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
Aug  6 22:05:32 faramir kernel: pci 0000:01:00.0: PME# disabled
Aug  6 22:05:32 faramir kernel: pci 0000:01:00.3: PME# supported from D0 D3hot D3cold
Aug  6 22:05:32 faramir kernel: pci 0000:01:00.3: PME# disabled
Aug  6 22:05:32 faramir kernel: pci 0000:01:00.4: PME# supported from D0 D3hot D3cold
Aug  6 22:05:32 faramir kernel: pci 0000:01:00.4: PME# disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1e.0: transparent bridge
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
Aug  6 22:05:32 faramir kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 *9 10 11 12)
Aug  6 22:05:32 faramir kernel: Linux Plug and Play Support v0.97 (c) Adam Belay
Aug  6 22:05:32 faramir kernel: pnp: PnP ACPI init
Aug  6 22:05:32 faramir kernel: ACPI: bus type pnp registered
Aug  6 22:05:32 faramir kernel: pnp 00:00: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:00:   add io  0xcf8-0xcff flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:01: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:01:   add mem 0xf0000000-0xf3ffffff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:01:   add mem 0xfed13000-0xfed13fff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:01:   add mem 0xfed14000-0xfed17fff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:01:   add mem 0xfed18000-0xfed18fff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:01:   add mem 0xfed19000-0xfed19fff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:01:   add mem 0xfed1c000-0xfed1ffff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:01:   add mem 0xfed20000-0xfed3ffff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:01:   add mem 0xfed45000-0xfed99fff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:01:   add mem 0xc0000-0xdffff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:01:   add mem 0xe0000-0xfffff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:01: PNP0c02: calling quirk_system_pci_resources+0x0/0x179
Aug  6 22:05:32 faramir kernel: pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:02: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:02:   add io  0x0-0xf flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:02:   add io  0x81-0x83 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:02:   add io  0x87-0x87 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:02:   add io  0x89-0x8b flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:02:   add io  0x8f-0x8f flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:02:   add io  0xc0-0xdf flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:02:   add dma 4 flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:03: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:03:   add io  0x70-0x71 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:03:   add io  0x74-0x77 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:03:   add irq 8 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:04: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:04:   add io  0xf0-0xf0 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:04:   add irq 13 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:05: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:05:   add io  0x61-0x61 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:06: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:06:   add io  0x500-0x53f flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:06:   add io  0x400-0x47f flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:06:   add io  0x92-0x92 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:06:   add io  0x680-0x6ff flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:06:   add io  0x10-0x1f flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:06:   add io  0x72-0x73 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:06:   add io  0x80-0x80 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:06:   add io  0x84-0x86 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:06:   add io  0x88-0x88 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:06:   add io  0x8c-0x8e flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:06:   add io  0x90-0x9f flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:06: PNP0c02: calling quirk_system_pci_resources+0x0/0x179
Aug  6 22:05:32 faramir kernel: pnp 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:07: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:07:   add mem 0xfed40000-0xfed44fff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:07: PNP0c02: calling quirk_system_pci_resources+0x0/0x179
Aug  6 22:05:32 faramir kernel: pnp 00:07: Plug and Play ACPI device, IDs PNP0c31 PNP0c02 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:08: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:08:   add io  0x60-0x60 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:08:   add io  0x64-0x64 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:08: PNP0c02: calling quirk_system_pci_resources+0x0/0x179
Aug  6 22:05:32 faramir kernel: pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:09: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:09:   add io  0x3f0-0x3f5 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:09:   add io  0x3f0-0x3f0 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:09:   add irq 6 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:09:   add dma 2 flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:09: parse resource options
Aug  6 22:05:32 faramir kernel: pnp 00:09:   dependent set 0 (preferred) io  min 0x3f0 max 0x3f0 align 1 size 6 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:09:   dependent set 0 (preferred) io  min 0x3f7 max 0x3f7 align 1 size 1 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:09:   dependent set 0 (preferred) irq 6 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:09:   dependent set 0 (preferred) dma 2 (bitmask 0x4) flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:09: Plug and Play ACPI device, IDs PNP0700 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:0a: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   add io  0x378-0x37f flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   add io  0x778-0x77f flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   add irq 7 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   add dma 0 flags 0x10000000
Aug  6 22:05:32 faramir kernel: pnp 00:0a: parse resource options
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   dependent set 0 (preferred) io  min 0x378 max 0x378 align 1 size 8 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   dependent set 0 (preferred) io  min 0x778 max 0x778 align 1 size 8 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   dependent set 0 (preferred) irq 5 7 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   dependent set 0 (preferred) dma 1 3 (bitmask 0xa) flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   dependent set 1 (preferred) io  min 0x278 max 0x278 align 1 size 8 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   dependent set 1 (preferred) io  min 0x678 max 0x678 align 1 size 8 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   dependent set 1 (preferred) irq 5 7 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   dependent set 1 (preferred) dma 1 3 (bitmask 0xa) flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   dependent set 2 (preferred) io  min 0x3bc max 0x3bc align 1 size 4 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   dependent set 2 (preferred) io  min 0x7bc max 0x7bc align 1 size 4 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   dependent set 2 (preferred) irq 5 7 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0a:   dependent set 2 (preferred) dma 1 3 (bitmask 0xa) flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:0b: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:0b:   add io  0x3f8-0x3ff flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0b:   add irq 4 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0b: parse resource options
Aug  6 22:05:32 faramir kernel: pnp 00:0b:   dependent set 0 (preferred) io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0b:   dependent set 0 (preferred) irq 4 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0b:   dependent set 1 (preferred) io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0b:   dependent set 1 (preferred) irq 4 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0b:   dependent set 2 (preferred) io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0b:   dependent set 2 (preferred) irq 3 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0b:   dependent set 3 (preferred) io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0b:   dependent set 3 (preferred) irq 3 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0b:   dependent set 4 (functional) io  min 0x100 max 0x3f8 align 8 size 8 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0b:   dependent set 4 (functional) irq 1 3 4 5 6 7 8 10 11 12 13 14 15 flags 0x1
Aug  6 22:05:32 faramir kernel: pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:0c: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:0c:   add mem 0xfec00000-0xfec000ff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:0c: Plug and Play ACPI device, IDs PNP0003 (active)
Aug  6 22:05:32 faramir kernel: pnp 00:0d: parse allocated resources
Aug  6 22:05:32 faramir kernel: pnp 00:0d:   add mem 0xfed00000-0xfed003ff flags 0x0
Aug  6 22:05:32 faramir kernel: pnp 00:0d: Plug and Play ACPI device, IDs PNP0103 (active)
Aug  6 22:05:32 faramir kernel: pnp: PnP ACPI: found 14 devices
Aug  6 22:05:32 faramir kernel: ACPI: ACPI bus type pnp unregistered
Aug  6 22:05:32 faramir kernel: usbcore: registered new interface driver usbfs
Aug  6 22:05:32 faramir kernel: usbcore: registered new interface driver hub
Aug  6 22:05:32 faramir kernel: usbcore: registered new device driver usb
Aug  6 22:05:32 faramir kernel: PCI: Using ACPI for IRQ routing
Aug  6 22:05:32 faramir kernel: PCI-GART: No AMD northbridge found.
Aug  6 22:05:32 faramir kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Aug  6 22:05:32 faramir kernel: hpet0: 3 64-bit timers, 14318180 Hz
Aug  6 22:05:32 faramir kernel: ACPI: RTC can wake from S4
Aug  6 22:05:32 faramir kernel: pnp: the driver 'system' has been registered
Aug  6 22:05:32 faramir kernel: system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
Aug  6 22:05:32 faramir kernel: system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
Aug  6 22:05:32 faramir kernel: system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
Aug  6 22:05:32 faramir kernel: system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
Aug  6 22:05:32 faramir kernel: system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
Aug  6 22:05:32 faramir kernel: system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
Aug  6 22:05:32 faramir kernel: system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
Aug  6 22:05:32 faramir kernel: system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
Aug  6 22:05:32 faramir kernel: system 00:01: iomem range 0xc0000-0xdffff has been reserved
Aug  6 22:05:32 faramir kernel: system 00:01: iomem range 0xe0000-0xfffff could not be reserved
Aug  6 22:05:32 faramir kernel: system 00:01: driver attached
Aug  6 22:05:32 faramir kernel: system 00:06: ioport range 0x500-0x53f has been reserved
Aug  6 22:05:32 faramir kernel: system 00:06: ioport range 0x400-0x47f has been reserved
Aug  6 22:05:32 faramir kernel: system 00:06: ioport range 0x680-0x6ff has been reserved
Aug  6 22:05:32 faramir kernel: system 00:06: driver attached
Aug  6 22:05:32 faramir kernel: system 00:07: iomem range 0xfed40000-0xfed44fff has been reserved
Aug  6 22:05:32 faramir kernel: system 00:07: driver attached
Aug  6 22:05:32 faramir kernel: system 00:08: driver attached
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.0:   MEM window: 0x90000000-0x901fffff
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.0:   PREFETCH window: disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.2: PCI bridge, secondary bus 0000:02
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.2:   IO window: disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.2:   MEM window: 0x90300000-0x903fffff
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.2:   PREFETCH window: disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.3: PCI bridge, secondary bus 0000:03
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.3:   IO window: disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.3:   MEM window: 0x90400000-0x904fffff
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.3:   PREFETCH window: disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.4:   IO window: disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.4:   MEM window: 0x90500000-0x905fffff
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.4:   PREFETCH window: disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.5: PCI bridge, secondary bus 0000:05
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.5:   IO window: disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.5:   MEM window: 0x90600000-0x906fffff
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.5:   PREFETCH window: disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
Aug  6 22:05:32 faramir kernel: pci 0000:00:1e.0:   IO window: disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1e.0:   MEM window: disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1e.0:   PREFETCH window: disabled
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.0: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.2: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.3: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.4: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
Aug  6 22:05:32 faramir kernel: pci 0000:00:1c.5: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: pci 0000:00:1e.0: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: NET: Registered protocol family 2
Aug  6 22:05:32 faramir kernel: IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
Aug  6 22:05:32 faramir kernel: TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
Aug  6 22:05:32 faramir kernel: TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
Aug  6 22:05:32 faramir kernel: TCP: Hash tables configured (established 262144 bind 65536)
Aug  6 22:05:32 faramir kernel: TCP reno registered
Aug  6 22:05:32 faramir kernel: NET: Registered protocol family 1
Aug  6 22:05:32 faramir kernel: checking if image is initramfs... it is
Aug  6 22:05:32 faramir kernel: Switched to high resolution mode on CPU 1
Aug  6 22:05:32 faramir kernel: Switched to high resolution mode on CPU 0
Aug  6 22:05:32 faramir kernel: Freeing initrd memory: 4028k freed
Aug  6 22:05:32 faramir kernel: audit: initializing netlink socket (disabled)
Aug  6 22:05:32 faramir kernel: type=2000 audit(1218053100.640:1): initialized
Aug  6 22:05:32 faramir kernel: VFS: Disk quotas dquot_6.5.1
Aug  6 22:05:32 faramir kernel: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Aug  6 22:05:32 faramir kernel: msgmni has been set to 3973
Aug  6 22:05:32 faramir kernel: io scheduler noop registered
Aug  6 22:05:32 faramir kernel: io scheduler anticipatory registered
Aug  6 22:05:32 faramir kernel: io scheduler deadline registered
Aug  6 22:05:32 faramir kernel: io scheduler cfq registered (default)
Aug  6 22:05:32 faramir kernel: pci 0000:00:02.0: Boot video device
Aug  6 22:05:32 faramir kernel: pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f10
Aug  6 22:05:32 faramir kernel: pci 0000:00:1d.0: Performing full reset
Aug  6 22:05:32 faramir kernel: pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
Aug  6 22:05:32 faramir kernel: pci 0000:00:1d.1: Performing full reset
Aug  6 22:05:32 faramir kernel: pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
Aug  6 22:05:32 faramir kernel: pci 0000:00:1d.2: Performing full reset
Aug  6 22:05:32 faramir kernel: pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0010
Aug  6 22:05:32 faramir kernel: pci 0000:00:1d.3: Performing full reset
Aug  6 22:05:32 faramir kernel: pcieport-driver 0000:00:1c.0: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: pcieport-driver 0000:00:1c.0: found MSI capability
Aug  6 22:05:32 faramir kernel: pci_express 0000:00:1c.0:pcie00: allocate port service
Aug  6 22:05:32 faramir kernel: pci_express 0000:00:1c.0:pcie02: allocate port service
Aug  6 22:05:32 faramir kernel: pcieport-driver 0000:00:1c.2: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: pcieport-driver 0000:00:1c.2: found MSI capability
Aug  6 22:05:32 faramir kernel: pci_express 0000:00:1c.2:pcie00: allocate port service
Aug  6 22:05:32 faramir kernel: pci_express 0000:00:1c.2:pcie02: allocate port service
Aug  6 22:05:32 faramir kernel: pcieport-driver 0000:00:1c.3: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: pcieport-driver 0000:00:1c.3: found MSI capability
Aug  6 22:05:32 faramir kernel: pci_express 0000:00:1c.3:pcie00: allocate port service
Aug  6 22:05:32 faramir kernel: pci_express 0000:00:1c.3:pcie02: allocate port service
Aug  6 22:05:32 faramir kernel: pcieport-driver 0000:00:1c.4: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: pcieport-driver 0000:00:1c.4: found MSI capability
Aug  6 22:05:32 faramir kernel: pci_express 0000:00:1c.4:pcie00: allocate port service
Aug  6 22:05:32 faramir kernel: pci_express 0000:00:1c.4:pcie02: allocate port service
Aug  6 22:05:32 faramir kernel: pcieport-driver 0000:00:1c.5: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: pcieport-driver 0000:00:1c.5: found MSI capability
Aug  6 22:05:32 faramir kernel: pci_express 0000:00:1c.5:pcie00: allocate port service
Aug  6 22:05:32 faramir kernel: pci_express 0000:00:1c.5:pcie02: allocate port service
Aug  6 22:05:32 faramir kernel: vesafb: framebuffer at 0x80000000, mapped to 0xffffc20000b80000, using 3072k, total 7872k
Aug  6 22:05:32 faramir kernel: vesafb: mode is 1024x768x16, linelength=2048, pages=4
Aug  6 22:05:32 faramir kernel: vesafb: scrolling: redraw
Aug  6 22:05:32 faramir kernel: vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Aug  6 22:05:32 faramir kernel: Console: switching to colour frame buffer device 128x48
Aug  6 22:05:32 faramir kernel: fb0: VESA VGA frame buffer device
Aug  6 22:05:32 faramir kernel: hpet_resources: 0xfed00000 is busy
Aug  6 22:05:32 faramir kernel: Linux agpgart interface v0.103
Aug  6 22:05:32 faramir kernel: Serial: 8250/16550 driver4 ports, IRQ sharing enabled
Aug  6 22:05:32 faramir kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Aug  6 22:05:32 faramir kernel: pnp: the driver 'serial' has been registered
Aug  6 22:05:32 faramir kernel: 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Aug  6 22:05:32 faramir kernel: serial 00:0b: driver attached
Aug  6 22:05:32 faramir kernel: serial 0000:01:00.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Aug  6 22:05:32 faramir kernel: 0000:01:00.3: ttyS1 at I/O 0x1020 (irq = 18) is a 16550A
Aug  6 22:05:32 faramir kernel: brd: module loaded
Aug  6 22:05:32 faramir kernel: pnp: the driver 'i8042 kbd' has been registered
Aug  6 22:05:32 faramir kernel: pnp: the driver 'i8042 aux' has been registered
Aug  6 22:05:32 faramir kernel: pnp: the driver 'i8042 kbd' has been unregistered
Aug  6 22:05:32 faramir kernel: pnp: the driver 'i8042 aux' has been unregistered
Aug  6 22:05:32 faramir kernel: PNP: No PS/2 controller found. Probing ports directly.
Aug  6 22:05:32 faramir kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Aug  6 22:05:32 faramir kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Aug  6 22:05:32 faramir kernel: mice: PS/2 mouse device common for all mice
Aug  6 22:05:32 faramir kernel: cpuidle: using governor ladder
Aug  6 22:05:32 faramir kernel: cpuidle: using governor menu
Aug  6 22:05:32 faramir kernel: TCP bic registered
Aug  6 22:05:32 faramir kernel: NET: Registered protocol family 17
Aug  6 22:05:32 faramir kernel: Freeing unused kernel memory: 368k freed
Aug  6 22:05:32 faramir kernel: processor ACPI0007:00: registered as cooling_device0
Aug  6 22:05:32 faramir kernel: processor ACPI0007:01: registered as cooling_device1
Aug  6 22:05:32 faramir kernel: e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
Aug  6 22:05:32 faramir kernel: e1000e: Copyright (c) 1999-2008 Intel Corporation.
Aug  6 22:05:32 faramir kernel: e1000e 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Aug  6 22:05:32 faramir kernel: e1000e 0000:01:00.0: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: USB Universal Host Controller Interface driver v3.0
Aug  6 22:05:32 faramir kernel: ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
Aug  6 22:05:32 faramir kernel: No dock devices found.
Aug  6 22:05:32 faramir kernel: Uniform Multi-Platform E-IDE driver
Aug  6 22:05:32 faramir kernel: SCSI subsystem initialized
Aug  6 22:05:32 faramir kernel: Floppy drive(s): fd0 is 1.44M
Aug  6 22:05:32 faramir kernel: libata version 3.00 loaded.
Aug  6 22:05:32 faramir kernel: FDC 0 is a post-1991 82077
Aug  6 22:05:32 faramir kernel: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:76:04:ff:09
Aug  6 22:05:32 faramir kernel: eth0: Intel(R) PRO/1000 Network Connection
Aug  6 22:05:32 faramir kernel: eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.0: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file 'devices'
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file '001'
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.0: detected 2 ports
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.0: Performing full reset
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.0: supports USB remote wakeup
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
Aug  6 22:05:32 faramir kernel: usb usb1: default language 0x0409
Aug  6 22:05:32 faramir kernel: usb usb1: uevent
Aug  6 22:05:32 faramir kernel: usb usb1: usb_probe_device
Aug  6 22:05:32 faramir kernel: usb usb1: configuration #1 chosen from 1 choice
Aug  6 22:05:32 faramir kernel: usb usb1: adding 1-0:1.0 (config #1, interface 0)
Aug  6 22:05:32 faramir kernel: usb 1-0:1.0: uevent
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: usb_probe_interface
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: usb_probe_interface - got id
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: USB hub found
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: 2 ports detected
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: standalone hub
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: no power switching (usb 1.0)
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: individual port over-current protection
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: power on to power good time: 2ms
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: local power source is good
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: trying to enable port power on non-switchable hub
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file '001'
Aug  6 22:05:32 faramir kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Aug  6 22:05:32 faramir kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  6 22:05:32 faramir kernel: usb usb1: Product: UHCI Host Controller
Aug  6 22:05:32 faramir kernel: usb usb1: Manufacturer: Linux 2.6.27-rc2 uhci_hcd
Aug  6 22:05:32 faramir kernel: usb usb1: SerialNumber: 0000:00:1d.0
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.1: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file '002'
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.1: detected 2 ports
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.1: Performing full reset
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.1: supports USB remote wakeup
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
Aug  6 22:05:32 faramir kernel: usb usb2: default language 0x0409
Aug  6 22:05:32 faramir kernel: usb usb2: uevent
Aug  6 22:05:32 faramir kernel: usb usb2: usb_probe_device
Aug  6 22:05:32 faramir kernel: usb usb2: configuration #1 chosen from 1 choice
Aug  6 22:05:32 faramir kernel: usb usb2: adding 2-0:1.0 (config #1, interface 0)
Aug  6 22:05:32 faramir kernel: usb 2-0:1.0: uevent
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: usb_probe_interface
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: usb_probe_interface - got id
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: USB hub found
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: 2 ports detected
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: standalone hub
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: no power switching (usb 1.0)
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: individual port over-current protection
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: power on to power good time: 2ms
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: local power source is good
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: trying to enable port power on non-switchable hub
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file '001'
Aug  6 22:05:32 faramir kernel: usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
Aug  6 22:05:32 faramir kernel: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  6 22:05:32 faramir kernel: usb usb2: Product: UHCI Host Controller
Aug  6 22:05:32 faramir kernel: usb usb2: Manufacturer: Linux 2.6.27-rc2 uhci_hcd
Aug  6 22:05:32 faramir kernel: usb usb2: SerialNumber: 0000:00:1d.1
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file '003'
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: detected 2 ports
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: Performing full reset
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: supports USB remote wakeup
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
Aug  6 22:05:32 faramir kernel: usb usb3: default language 0x0409
Aug  6 22:05:32 faramir kernel: usb usb3: uevent
Aug  6 22:05:32 faramir kernel: usb usb3: usb_probe_device
Aug  6 22:05:32 faramir kernel: usb usb3: configuration #1 chosen from 1 choice
Aug  6 22:05:32 faramir kernel: usb usb3: adding 3-0:1.0 (config #1, interface 0)
Aug  6 22:05:32 faramir kernel: usb 3-0:1.0: uevent
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: usb_probe_interface
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: usb_probe_interface - got id
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: USB hub found
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: 2 ports detected
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: standalone hub
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: no power switching (usb 1.0)
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: individual port over-current protection
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: power on to power good time: 2ms
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: local power source is good
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: trying to enable port power on non-switchable hub
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: port 1 portsc 01ab,00
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: port 1: status 0301 change 0003
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file '001'
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
Aug  6 22:05:32 faramir kernel: usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Aug  6 22:05:32 faramir kernel: usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  6 22:05:32 faramir kernel: usb usb3: Product: UHCI Host Controller
Aug  6 22:05:32 faramir kernel: usb usb3: Manufacturer: Linux 2.6.27-rc2 uhci_hcd
Aug  6 22:05:32 faramir kernel: usb usb3: SerialNumber: 0000:00:1d.2
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.3: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file '004'
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.3: detected 2 ports
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.3: Performing full reset
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.3: supports USB remote wakeup
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002020
Aug  6 22:05:32 faramir kernel: usb usb4: default language 0x0409
Aug  6 22:05:32 faramir kernel: usb usb4: uevent
Aug  6 22:05:32 faramir kernel: usb usb4: usb_probe_device
Aug  6 22:05:32 faramir kernel: usb usb4: configuration #1 chosen from 1 choice
Aug  6 22:05:32 faramir kernel: usb usb4: adding 4-0:1.0 (config #1, interface 0)
Aug  6 22:05:32 faramir kernel: usb 4-0:1.0: uevent
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: usb_probe_interface
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: usb_probe_interface - got id
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: USB hub found
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: 2 ports detected
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: standalone hub
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: no power switching (usb 1.0)
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: individual port over-current protection
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: power on to power good time: 2ms
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: local power source is good
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: trying to enable port power on non-switchable hub
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.3: port 1 portsc 01ab,00
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: port 1: status 0301 change 0003
Aug  6 22:05:32 faramir kernel: usb 3-1: new low speed USB device using uhci_hcd and address 2
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file '001'
Aug  6 22:05:32 faramir kernel: usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Aug  6 22:05:32 faramir kernel: usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  6 22:05:32 faramir kernel: usb usb4: Product: UHCI Host Controller
Aug  6 22:05:32 faramir kernel: usb usb4: Manufacturer: Linux 2.6.27-rc2 uhci_hcd
Aug  6 22:05:32 faramir kernel: usb usb4: SerialNumber: 0000:00:1d.3
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file '005'
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: debug port 1
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: supports USB remote wakeup
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: irq 23, io mem 0x902c4400
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
Aug  6 22:05:32 faramir kernel: usb 3-1: uhci_result_common: failed with status 440000
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Aug  6 22:05:32 faramir kernel: usb usb5: default language 0x0409
Aug  6 22:05:32 faramir kernel: usb usb5: uevent
Aug  6 22:05:32 faramir kernel: usb usb5: usb_probe_device
Aug  6 22:05:32 faramir kernel: usb usb5: configuration #1 chosen from 1 choice
Aug  6 22:05:32 faramir kernel: usb usb5: adding 5-0:1.0 (config #1, interface 0)
Aug  6 22:05:32 faramir kernel: usb 5-0:1.0: uevent
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: usb_probe_interface
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: usb_probe_interface - got id
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: USB hub found
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: 8 ports detected
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: standalone hub
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: no power switching (usb 1.0)
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: individual port over-current protection
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: power on to power good time: 20ms
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: local power source is good
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: trying to enable port power on non-switchable hub
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001403 POWER sig=k CSC CONNECT
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: port 5: status 0501 change 0001
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: GetStatus port 7 status 001403 POWER sig=k CSC CONNECT
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: port 7: status 0501 change 0001
Aug  6 22:05:32 faramir kernel: usb 3-1: uhci_result_common: failed with status 440000
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file '001'
Aug  6 22:05:32 faramir kernel: usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Aug  6 22:05:32 faramir kernel: usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  6 22:05:32 faramir kernel: usb usb5: Product: EHCI Host Controller
Aug  6 22:05:32 faramir kernel: usb usb5: Manufacturer: Linux 2.6.27-rc2 ehci_hcd
Aug  6 22:05:32 faramir kernel: usb usb5: SerialNumber: 0000:00:1d.7
Aug  6 22:05:32 faramir kernel: ahci 0000:00:1f.2: version 3.0
Aug  6 22:05:32 faramir kernel: ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Aug  6 22:05:32 faramir kernel: ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Aug  6 22:05:32 faramir kernel: ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
Aug  6 22:05:32 faramir kernel: ahci 0000:00:1f.2: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: scsi0 : ahci
Aug  6 22:05:32 faramir kernel: scsi1 : ahci
Aug  6 22:05:32 faramir kernel: scsi2 : ahci
Aug  6 22:05:32 faramir kernel: scsi3 : ahci
Aug  6 22:05:32 faramir kernel: ata1: SATA max UDMA/133 abar m1024@0x902c4000 port 0x902c4100 irq 218
Aug  6 22:05:32 faramir kernel: ata2: SATA max UDMA/133 abar m1024@0x902c4000 port 0x902c4180 irq 218
Aug  6 22:05:32 faramir kernel: ata3: SATA max UDMA/133 abar m1024@0x902c4000 port 0x902c4200 irq 218
Aug  6 22:05:32 faramir kernel: ata4: SATA max UDMA/133 abar m1024@0x902c4000 port 0x902c4280 irq 218
Aug  6 22:05:32 faramir kernel: usb 3-1: device not accepting address 2, error -71
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: unable to enumerate USB device on port 1
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: state 7 ports 2 chg 0002 evt 0002
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.3: port 1 portsc 0082,00
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
Aug  6 22:05:32 faramir kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  6 22:05:32 faramir kernel: ata1.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
Aug  6 22:05:32 faramir kernel: ata1.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 31/32)
Aug  6 22:05:32 faramir kernel: ata1.00: configured for UDMA/133
Aug  6 22:05:32 faramir kernel: usb usb1: suspend_rh (auto-stop)
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: state 7 ports 8 chg 00a0 evt 0000
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: port 5 low speed --> companion
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: port 7, status 0501, change 0000, 480 Mb/s
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: port 7 low speed --> companion
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: GetStatus port 7 status 003002 POWER OWNER sig=se0 CSC
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt fe80
Aug  6 22:05:32 faramir kernel: usb usb2: suspend_rh (auto-stop)
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: port 1 portsc 01a3,00
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
Aug  6 22:05:32 faramir kernel: ata2: SATA link down (SStatus 0 SControl 300)
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
Aug  6 22:05:32 faramir kernel: usb 3-1: new low speed USB device using uhci_hcd and address 4
Aug  6 22:05:32 faramir kernel: usb 3-1: skipped 1 descriptor after interface
Aug  6 22:05:32 faramir kernel: usb 3-1: skipped 1 descriptor after interface
Aug  6 22:05:32 faramir kernel: usb 3-1: default language 0x0409
Aug  6 22:05:32 faramir kernel: usb 3-1: uevent
Aug  6 22:05:32 faramir kernel: usb 3-1: usb_probe_device
Aug  6 22:05:32 faramir kernel: usb 3-1: configuration #1 chosen from 1 choice
Aug  6 22:05:32 faramir kernel: usb 3-1: adding 3-1:1.0 (config #1, interface 0)
Aug  6 22:05:32 faramir kernel: usb 3-1:1.0: uevent
Aug  6 22:05:32 faramir kernel: usb 3-1: adding 3-1:1.1 (config #1, interface 1)
Aug  6 22:05:32 faramir kernel: usb 3-1:1.1: uevent
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file '004'
Aug  6 22:05:32 faramir kernel: usb 3-1: New USB device found, idVendor=05a4, idProduct=9841
Aug  6 22:05:32 faramir kernel: usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Aug  6 22:05:32 faramir kernel: usb 3-1: Product: USB Compliant Keyboard
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.3: port 1 portsc 01a3,00
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
Aug  6 22:05:32 faramir kernel: hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
Aug  6 22:05:32 faramir kernel: usb 4-1: new low speed USB device using uhci_hcd and address 2
Aug  6 22:05:32 faramir kernel: ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  6 22:05:32 faramir kernel: ata3.00: ATAPI: Optiarc DVD RW AD-7170S, 1.00, max UDMA/66
Aug  6 22:05:32 faramir kernel: ata3.00: configured for UDMA/66
Aug  6 22:05:32 faramir kernel: usb 4-1: skipped 1 descriptor after interface
Aug  6 22:05:32 faramir kernel: usb 4-1: default language 0x0409
Aug  6 22:05:32 faramir kernel: usb 4-1: uevent
Aug  6 22:05:32 faramir kernel: usb 4-1: usb_probe_device
Aug  6 22:05:32 faramir kernel: usb 4-1: configuration #1 chosen from 1 choice
Aug  6 22:05:32 faramir kernel: usb 4-1: adding 4-1:1.0 (config #1, interface 0)
Aug  6 22:05:32 faramir kernel: usb 4-1:1.0: uevent
Aug  6 22:05:32 faramir kernel: drivers/usb/core/inode.c: creating file '002'
Aug  6 22:05:32 faramir kernel: usb 4-1: New USB device found, idVendor=046d, idProduct=c50d
Aug  6 22:05:32 faramir kernel: usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Aug  6 22:05:32 faramir kernel: usb 4-1: Product: USB Receiver
Aug  6 22:05:32 faramir kernel: usb 4-1: Manufacturer: Logitech
Aug  6 22:05:32 faramir kernel: hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
Aug  6 22:05:32 faramir kernel: usbcore: registered new interface driver hiddev
Aug  6 22:05:32 faramir kernel: usbhid 3-1:1.0: usb_probe_interface
Aug  6 22:05:32 faramir kernel: usbhid 3-1:1.0: usb_probe_interface - got id
Aug  6 22:05:32 faramir kernel: input: USB Compliant Keyboard as /class/input/input0
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: reserve dev 4 ep81-INT, period 8, phase 4, 118 us
Aug  6 22:05:32 faramir kernel: input: USB HID v1.10 Keyboard [USB Compliant Keyboard] on usb-0000:00:1d.2-1
Aug  6 22:05:32 faramir kernel: usbhid 3-1:1.1: usb_probe_interface
Aug  6 22:05:32 faramir kernel: usbhid 3-1:1.1: usb_probe_interface - got id
Aug  6 22:05:32 faramir kernel: input: USB Compliant Keyboard as /class/input/input1
Aug  6 22:05:32 faramir kernel: uhci_hcd 0000:00:1d.2: reserve dev 4 ep82-INT, period 8, phase 4, 99 us
Aug  6 22:05:32 faramir kernel: input: USB HID v1.10 Device [USB Compliant Keyboard] on usb-0000:00:1d.2-1
Aug  6 22:05:32 faramir kernel: usbhid 4-1:1.0: usb_probe_interface
Aug  6 22:05:32 faramir kernel: usbhid 4-1:1.0: usb_probe_interface - got id
Aug  6 22:05:32 faramir kernel: input: Logitech USB Receiver as /class/input/input2
Aug  6 22:05:32 faramir kernel: input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.3-1
Aug  6 22:05:32 faramir kernel: usbcore: registered new interface driver usbhid
Aug  6 22:05:32 faramir kernel: usbhid: v2.6:USB HID core driver
Aug  6 22:05:32 faramir kernel: ata4: SATA link down (SStatus 0 SControl 300)
Aug  6 22:05:32 faramir kernel: scsi 0:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
Aug  6 22:05:32 faramir kernel: scsi 2:0:0:0: CD-ROM            Optiarc  DVD RW AD-7170S  1.00 PQ: 0 ANSI: 5
Aug  6 22:05:32 faramir kernel: piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x01)
Aug  6 22:05:32 faramir kernel: PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Aug  6 22:05:32 faramir kernel: piix 0000:00:1f.1: IDE port disabled
Aug  6 22:05:32 faramir kernel: piix 0000:00:1f.1: not 100% native mode: will probe irqs later
Aug  6 22:05:32 faramir kernel:     ide0: BM-DMA at 0x20b0-0x20b7
Aug  6 22:05:32 faramir kernel: Probing IDE interface ide0...
Aug  6 22:05:32 faramir kernel: Driver 'sd' needs updating - please use bus_type methods
Aug  6 22:05:32 faramir kernel: sd 0:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
Aug  6 22:05:32 faramir kernel: sd 0:0:0:0: [sda] Write Protect is off
Aug  6 22:05:32 faramir kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug  6 22:05:32 faramir kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  6 22:05:32 faramir kernel: sd 0:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
Aug  6 22:05:32 faramir kernel: sd 0:0:0:0: [sda] Write Protect is off
Aug  6 22:05:32 faramir kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug  6 22:05:32 faramir kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug  6 22:05:32 faramir kernel:  sda:<4>Driver 'sr' needs updating - please use bus_type methods
Aug  6 22:05:32 faramir kernel:  sda1 sda2 < sda5 sda6 > sda3 sda4
Aug  6 22:05:32 faramir kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb1: bus auto-suspend
Aug  6 22:05:32 faramir kernel: usb usb1: suspend_rh
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb2: bus auto-suspend
Aug  6 22:05:32 faramir kernel: usb usb2: suspend_rh
Aug  6 22:05:32 faramir kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Aug  6 22:05:32 faramir kernel: Uniform CD-ROM driver Revision: 3.20
Aug  6 22:05:32 faramir kernel: sr 2:0:0:0: Attached scsi CD-ROM sr0
Aug  6 22:05:32 faramir kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Aug  6 22:05:32 faramir kernel: sr 2:0:0:0: Attached scsi generic sg1 type 5
Aug  6 22:05:32 faramir kernel: hda: LITE-ON DVD SOHD-16P9SV, ATAPI CD/DVD-ROM drive
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb5: bus auto-suspend
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: suspend root hub
Aug  6 22:05:32 faramir kernel: hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Aug  6 22:05:32 faramir kernel: hda: UDMA/33 mode selected
Aug  6 22:05:32 faramir kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Aug  6 22:05:32 faramir kernel: hda: ATAPI 48X DVD-ROM drive, 254kB Cache
Aug  6 22:05:32 faramir kernel: device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Aug  6 22:05:32 faramir kernel: kjournald starting.  Commit interval 5 seconds
Aug  6 22:05:32 faramir kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug  6 22:05:32 faramir kernel: udevd version 125 started
Aug  6 22:05:32 faramir kernel: usb usb1: uevent
Aug  6 22:05:32 faramir kernel: usb 1-0:1.0: uevent
Aug  6 22:05:32 faramir kernel: usb usb2: uevent
Aug  6 22:05:32 faramir kernel: usb 2-0:1.0: uevent
Aug  6 22:05:32 faramir kernel: usb usb3: uevent
Aug  6 22:05:32 faramir kernel: usb 3-0:1.0: uevent
Aug  6 22:05:32 faramir kernel: usb 3-1: uevent
Aug  6 22:05:32 faramir kernel: usb 3-1:1.0: uevent
Aug  6 22:05:32 faramir kernel: usb 3-1:1.1: uevent
Aug  6 22:05:32 faramir kernel: usb usb4: uevent
Aug  6 22:05:32 faramir kernel: usb 4-0:1.0: uevent
Aug  6 22:05:32 faramir kernel: usb 4-1: uevent
Aug  6 22:05:32 faramir kernel: usb 4-1:1.0: uevent
Aug  6 22:05:32 faramir kernel: usb usb5: uevent
Aug  6 22:05:32 faramir kernel: usb 5-0:1.0: uevent
Aug  6 22:05:32 faramir kernel: input: PC Speaker as /class/input/input3
Aug  6 22:05:32 faramir kernel: agpgart: Detected an Intel 945G Chipset.
Aug  6 22:05:32 faramir kernel: agpgart: Detected 7932K stolen memory.
Aug  6 22:05:32 faramir kernel: agpgart: AGP aperture is 256M @ 0x80000000
Aug  6 22:05:32 faramir kernel: input: Power Button (FF) as /class/input/input4
Aug  6 22:05:32 faramir kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
Aug  6 22:05:32 faramir kernel: iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0460)
Aug  6 22:05:32 faramir kernel: iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Aug  6 22:05:32 faramir kernel: ACPI: Power Button (FF) [PWRF]
Aug  6 22:05:32 faramir kernel: input: Sleep Button (CM) as /class/input/input5
Aug  6 22:05:32 faramir kernel: pnp: the driver 'rtc_cmos' has been registered
Aug  6 22:05:32 faramir kernel: rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Aug  6 22:05:32 faramir kernel: rtc0: alarms up to one month, hpet irqs
Aug  6 22:05:32 faramir kernel: rtc_cmos 00:03: driver attached
Aug  6 22:05:32 faramir kernel: i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Aug  6 22:05:32 faramir kernel: intel_rng: Firmware space is locked read-only. If you can't or
Aug  6 22:05:32 faramir kernel: intel_rng: don't want to disable this in firmware setup, and if
Aug  6 22:05:32 faramir kernel: intel_rng: you are certain that your system has a functional
Aug  6 22:05:32 faramir kernel: intel_rng: RNG, try using the 'no_fwh_detect' option.
Aug  6 22:05:32 faramir kernel: ACPI: Sleep Button (CM) [SLPB]
Aug  6 22:05:32 faramir kernel: HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Aug  6 22:05:32 faramir kernel: HDA Intel 0000:00:1b.0: setting latency timer to 64
Aug  6 22:05:32 faramir kernel: Adding 979924k swap on /dev/sda6.  Priority:-1 extents:1 across:979924k
Aug  6 22:05:32 faramir kernel: EXT3 FS on dm-0, internal journal
Aug  6 22:05:32 faramir kernel: NET: Registered protocol family 10
Aug  6 22:05:32 faramir kernel: lo: Disabled Privacy Extensions
Aug  6 22:05:32 faramir kernel: i2c-adapter i2c-0: lm85: Detected SMSC chip
Aug  6 22:05:32 faramir kernel: i2c-adapter i2c-0: lm85: Unrecognized version/stepping 0x68 Defaulting to Generic LM85.
Aug  6 22:05:32 faramir kernel: usb usb5: usb auto-resume
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: resume root hub
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: hub_resume
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt fe00
Aug  6 22:05:32 faramir kernel: usb usb2: usb auto-resume
Aug  6 22:05:32 faramir kernel: usb usb2: wakeup_rh
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: hub_resume
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:32 faramir kernel: usb usb1: usb auto-resume
Aug  6 22:05:32 faramir kernel: usb usb1: wakeup_rh
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: hub_resume
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:32 faramir kernel: usb usb2: suspend_rh (auto-stop)
Aug  6 22:05:32 faramir kernel: usb usb1: suspend_rh (auto-stop)
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb5: bus auto-suspend
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: suspend root hub
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb2: bus auto-suspend
Aug  6 22:05:32 faramir kernel: usb usb2: suspend_rh
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb1: bus auto-suspend
Aug  6 22:05:32 faramir kernel: usb usb1: suspend_rh
Aug  6 22:05:32 faramir kernel: fuse init (API version 7.9)
Aug  6 22:05:32 faramir kernel: kjournald starting.  Commit interval 5 seconds
Aug  6 22:05:32 faramir kernel: EXT3 FS on sda1, internal journal
Aug  6 22:05:32 faramir kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug  6 22:05:32 faramir kernel: kjournald starting.  Commit interval 5 seconds
Aug  6 22:05:32 faramir kernel: EXT3 FS on dm-2, internal journal
Aug  6 22:05:32 faramir kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug  6 22:05:32 faramir kernel: kjournald starting.  Commit interval 5 seconds
Aug  6 22:05:32 faramir kernel: EXT3 FS on dm-4, internal journal
Aug  6 22:05:32 faramir kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug  6 22:05:32 faramir kernel: kjournald starting.  Commit interval 5 seconds
Aug  6 22:05:32 faramir kernel: EXT3 FS on dm-1, internal journal
Aug  6 22:05:32 faramir kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug  6 22:05:32 faramir kernel: kjournald starting.  Commit interval 5 seconds
Aug  6 22:05:32 faramir kernel: EXT3 FS on dm-3, internal journal
Aug  6 22:05:32 faramir kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug  6 22:05:32 faramir kernel: kjournald starting.  Commit interval 5 seconds
Aug  6 22:05:32 faramir kernel: EXT3 FS on dm-7, internal journal
Aug  6 22:05:32 faramir kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug  6 22:05:32 faramir kernel: kjournald starting.  Commit interval 5 seconds
Aug  6 22:05:32 faramir kernel: EXT3 FS on dm-6, internal journal
Aug  6 22:05:32 faramir kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug  6 22:05:32 faramir kernel: kjournald starting.  Commit interval 5 seconds
Aug  6 22:05:32 faramir kernel: EXT3 FS on dm-5, internal journal
Aug  6 22:05:32 faramir kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug  6 22:05:32 faramir kernel: Bridge firewalling registered
Aug  6 22:05:32 faramir kernel: br0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
Aug  6 22:05:32 faramir kernel: device eth0 entered promiscuous mode
Aug  6 22:05:32 faramir kernel: ADDRCONF(NETDEV_UP): eth0: link is not ready
Aug  6 22:05:32 faramir kernel: usb usb5: usb auto-resume
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: resume root hub
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: hub_resume
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt fe00
Aug  6 22:05:32 faramir kernel: usb usb2: usb auto-resume
Aug  6 22:05:32 faramir kernel: usb usb2: wakeup_rh
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: hub_resume
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:32 faramir kernel: usb usb1: usb auto-resume
Aug  6 22:05:32 faramir kernel: usb usb1: wakeup_rh
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: hub_resume
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:32 faramir kernel: usb usb2: suspend_rh (auto-stop)
Aug  6 22:05:32 faramir kernel: usb usb1: suspend_rh (auto-stop)
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb5: bus auto-suspend
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: suspend root hub
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb2: bus auto-suspend
Aug  6 22:05:32 faramir kernel: usb usb2: suspend_rh
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb1: bus auto-suspend
Aug  6 22:05:32 faramir kernel: usb usb1: suspend_rh
Aug  6 22:05:32 faramir kernel: eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
Aug  6 22:05:32 faramir kernel: eth0: 10/100 speed: disabling TSO
Aug  6 22:05:32 faramir kernel: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Aug  6 22:05:32 faramir kernel: br0: port 1(eth0) entering learning state
Aug  6 22:05:32 faramir kernel: usb usb5: usb auto-resume
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: resume root hub
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: hub_resume
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt fe00
Aug  6 22:05:32 faramir kernel: usb usb2: usb auto-resume
Aug  6 22:05:32 faramir kernel: usb usb2: wakeup_rh
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: hub_resume
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:32 faramir kernel: usb usb1: usb auto-resume
Aug  6 22:05:32 faramir kernel: usb usb1: wakeup_rh
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: hub_resume
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:32 faramir kernel: br0: topology change detected, propagating
Aug  6 22:05:32 faramir kernel: br0: port 1(eth0) entering forwarding state
Aug  6 22:05:32 faramir kernel: usb usb2: suspend_rh (auto-stop)
Aug  6 22:05:32 faramir kernel: usb usb1: suspend_rh (auto-stop)
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb5: bus auto-suspend
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: suspend root hub
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb2: bus auto-suspend
Aug  6 22:05:32 faramir kernel: usb usb2: suspend_rh
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb1: bus auto-suspend
Aug  6 22:05:32 faramir kernel: usb usb1: suspend_rh
Aug  6 22:05:32 faramir kernel: br0: no IPv6 routers present
Aug  6 22:05:32 faramir kernel: RPC: Registered udp transport module.
Aug  6 22:05:32 faramir kernel: RPC: Registered tcp transport module.
Aug  6 22:05:32 faramir kernel: usb usb5: usb auto-resume
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: resume root hub
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: hub_resume
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt fe00
Aug  6 22:05:32 faramir kernel: usb usb2: usb auto-resume
Aug  6 22:05:32 faramir kernel: usb usb2: wakeup_rh
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: hub_resume
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:32 faramir kernel: usb usb1: usb auto-resume
Aug  6 22:05:32 faramir kernel: usb usb1: wakeup_rh
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: hub_resume
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:32 faramir kernel: usb usb2: suspend_rh (auto-stop)
Aug  6 22:05:32 faramir kernel: usb usb1: suspend_rh (auto-stop)
Aug  6 22:05:32 faramir kernel: hub 5-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb5: bus auto-suspend
Aug  6 22:05:32 faramir kernel: ehci_hcd 0000:00:1d.7: suspend root hub
Aug  6 22:05:32 faramir kernel: hub 2-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb2: bus auto-suspend
Aug  6 22:05:32 faramir kernel: usb usb2: suspend_rh
Aug  6 22:05:32 faramir kernel: hub 1-0:1.0: hub_suspend
Aug  6 22:05:32 faramir kernel: usb usb1: bus auto-suspend
Aug  6 22:05:32 faramir kernel: usb usb1: suspend_rh
Aug  6 22:05:33 faramir kernel: eth0: no IPv6 routers present
Aug  6 22:05:35 faramir kernel: pnp: the driver 'parport_pc' has been registered
Aug  6 22:05:35 faramir kernel: parport_pc 00:0a: reported by Plug and Play ACPI
Aug  6 22:05:35 faramir kernel: parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
Aug  6 22:05:35 faramir kernel: parport0: Printer, HEWLETT-PACKARD PHOTOSMART P1100
Aug  6 22:05:35 faramir kernel: parport_pc 00:0a: driver attached
Aug  6 22:05:35 faramir kernel: lp0: using parport0 (interrupt-driven).
Aug  6 22:05:35 faramir kernel: ppdev: user-space parallel port driver
Aug  6 22:05:35 faramir kernel: usb usb5: usb auto-resume
Aug  6 22:05:35 faramir kernel: ehci_hcd 0000:00:1d.7: resume root hub
Aug  6 22:05:35 faramir kernel: hub 5-0:1.0: hub_resume
Aug  6 22:05:35 faramir kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt fe00
Aug  6 22:05:35 faramir kernel: usb usb2: usb auto-resume
Aug  6 22:05:35 faramir kernel: usb usb2: wakeup_rh
Aug  6 22:05:35 faramir kernel: hub 2-0:1.0: hub_resume
Aug  6 22:05:35 faramir kernel: usb usb1: usb auto-resume
Aug  6 22:05:35 faramir kernel: usb usb1: wakeup_rh
Aug  6 22:05:35 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:35 faramir kernel: hub 1-0:1.0: hub_resume
Aug  6 22:05:35 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:36 faramir kernel: usb usb2: suspend_rh (auto-stop)
Aug  6 22:05:36 faramir kernel: usb usb1: suspend_rh (auto-stop)
Aug  6 22:05:37 faramir kernel: hub 2-0:1.0: hub_suspend
Aug  6 22:05:37 faramir kernel: usb usb2: bus auto-suspend
Aug  6 22:05:37 faramir kernel: usb usb2: suspend_rh
Aug  6 22:05:37 faramir kernel: hub 1-0:1.0: hub_suspend
Aug  6 22:05:37 faramir kernel: usb usb1: bus auto-suspend
Aug  6 22:05:37 faramir kernel: usb usb1: suspend_rh
Aug  6 22:05:37 faramir kernel: hub 5-0:1.0: hub_suspend
Aug  6 22:05:37 faramir kernel: usb usb5: bus auto-suspend
Aug  6 22:05:37 faramir kernel: ehci_hcd 0000:00:1d.7: suspend root hub
Aug  6 22:05:40 faramir kernel: tun: Universal TUN/TAP device driver, 1.6
Aug  6 22:05:40 faramir kernel: tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Aug  6 22:05:40 faramir kernel: device vbox0 entered promiscuous mode
Aug  6 22:05:40 faramir kernel: br0: port 2(vbox0) entering learning state
Aug  6 22:05:40 faramir kernel: usb usb5: usb auto-resume
Aug  6 22:05:40 faramir kernel: ehci_hcd 0000:00:1d.7: resume root hub
Aug  6 22:05:40 faramir kernel: hub 5-0:1.0: hub_resume
Aug  6 22:05:40 faramir kernel: usb usb2: usb auto-resume
Aug  6 22:05:40 faramir kernel: usb usb2: wakeup_rh
Aug  6 22:05:40 faramir kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt fe00
Aug  6 22:05:40 faramir kernel: hub 2-0:1.0: hub_resume
Aug  6 22:05:40 faramir kernel: usb usb1: usb auto-resume
Aug  6 22:05:40 faramir kernel: usb usb1: wakeup_rh
Aug  6 22:05:40 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:40 faramir kernel: hub 1-0:1.0: hub_resume
Aug  6 22:05:40 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:41 faramir kernel: usb usb2: suspend_rh (auto-stop)
Aug  6 22:05:41 faramir kernel: usb usb1: suspend_rh (auto-stop)
Aug  6 22:05:42 faramir kernel: br0: topology change detected, propagating
Aug  6 22:05:42 faramir kernel: br0: port 2(vbox0) entering forwarding state
Aug  6 22:05:42 faramir kernel: hub 5-0:1.0: hub_suspend
Aug  6 22:05:42 faramir kernel: usb usb5: bus auto-suspend
Aug  6 22:05:42 faramir kernel: ehci_hcd 0000:00:1d.7: suspend root hub
Aug  6 22:05:42 faramir kernel: hub 2-0:1.0: hub_suspend
Aug  6 22:05:42 faramir kernel: usb usb2: bus auto-suspend
Aug  6 22:05:42 faramir kernel: usb usb2: suspend_rh
Aug  6 22:05:42 faramir kernel: hub 1-0:1.0: hub_suspend
Aug  6 22:05:42 faramir kernel: usb usb1: bus auto-suspend
Aug  6 22:05:42 faramir kernel: usb usb1: suspend_rh
Aug  6 22:05:46 faramir kernel: usb usb5: usb auto-resume
Aug  6 22:05:46 faramir kernel: ehci_hcd 0000:00:1d.7: resume root hub
Aug  6 22:05:46 faramir kernel: hub 5-0:1.0: hub_resume
Aug  6 22:05:46 faramir kernel: usb usb2: usb auto-resume
Aug  6 22:05:46 faramir kernel: usb usb2: wakeup_rh
Aug  6 22:05:46 faramir kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt fe00
Aug  6 22:05:46 faramir kernel: hub 2-0:1.0: hub_resume
Aug  6 22:05:46 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:46 faramir kernel: usb usb1: usb auto-resume
Aug  6 22:05:46 faramir kernel: usb usb1: wakeup_rh
Aug  6 22:05:46 faramir kernel: hub 1-0:1.0: hub_resume
Aug  6 22:05:46 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:47 faramir kernel: usb usb2: suspend_rh (auto-stop)
Aug  6 22:05:47 faramir kernel: usb usb1: suspend_rh (auto-stop)
Aug  6 22:05:47 faramir kernel: [drm] Initialized drm 1.1.0 20060810
Aug  6 22:05:47 faramir kernel: pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Aug  6 22:05:47 faramir kernel: pci 0000:00:02.0: setting latency timer to 64
Aug  6 22:05:47 faramir kernel: [drm] Initialized i915 1.6.0 20060119 on minor 0
Aug  6 22:05:48 faramir kernel: hub 5-0:1.0: hub_suspend
Aug  6 22:05:48 faramir kernel: usb usb5: bus auto-suspend
Aug  6 22:05:48 faramir kernel: ehci_hcd 0000:00:1d.7: suspend root hub
Aug  6 22:05:48 faramir kernel: hub 2-0:1.0: hub_suspend
Aug  6 22:05:48 faramir kernel: usb usb2: bus auto-suspend
Aug  6 22:05:48 faramir kernel: usb usb2: suspend_rh
Aug  6 22:05:48 faramir kernel: hub 1-0:1.0: hub_suspend
Aug  6 22:05:48 faramir kernel: usb usb1: bus auto-suspend
Aug  6 22:05:48 faramir kernel: usb usb1: suspend_rh
Aug  6 22:05:50 faramir kernel: vbox0: no IPv6 routers present
Aug  6 22:05:50 faramir kernel: uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
Aug  6 22:05:50 faramir kernel: uhci_hcd 0000:00:1d.3: release dev 2 ep81-INT, period 8, phase 4, 118 us
Aug  6 22:05:50 faramir kernel: uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
Aug  6 22:05:51 faramir kernel: usb usb5: usb auto-resume
Aug  6 22:05:51 faramir kernel: ehci_hcd 0000:00:1d.7: resume root hub
Aug  6 22:05:51 faramir kernel: hub 5-0:1.0: hub_resume
Aug  6 22:05:51 faramir kernel: usb usb2: usb auto-resume
Aug  6 22:05:51 faramir kernel: usb usb2: wakeup_rh
Aug  6 22:05:51 faramir kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt fe00
Aug  6 22:05:51 faramir kernel: hub 2-0:1.0: hub_resume
Aug  6 22:05:51 faramir kernel: usb usb1: usb auto-resume
Aug  6 22:05:51 faramir kernel: usb usb1: wakeup_rh
Aug  6 22:05:51 faramir kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
Aug  6 22:05:51 faramir kernel: hub 1-0:1.0: hub_resume
Aug  6 22:05:51 faramir kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000

--Boundary-00=_jNhmInBanxjaRgQ--
