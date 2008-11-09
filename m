Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYKIFdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYKIFdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 00:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbYKIFdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 00:33:01 -0500
Received: from connectmail.carleton.ca ([134.117.2.12]:39213 "EHLO
	connectmail.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYKIFc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 00:32:56 -0500
Date: Sun, 09 Nov 2008 00:32:50 -0500
From: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: Update: "nobody cared" on Toshiba Satellite A100
In-reply-to: <490F1A10.3010302@suse.de>
To: Stefan Assmann <sassmann@suse.de>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Olaf Dabrunz <odabrunz@suse.de>, linux-kernel@vger.kernel.org
Message-id: <49167602.9050804@superonline.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
References: <48FB3ED5.60904@superonline.com>
 <1224431722.26279.4.camel@sven.thebigcorporation.com>
 <48FB6321.7030501@superonline.com> <48FC38AE.3030007@suse.de>
 <48FD0152.60907@superonline.com> <48FDFB97.1050208@suse.de>
 <490E1207.9050508@superonline.com> <490F1A10.3010302@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Assmann wrote:
> Since I have a strong hunch that this is a USB issue please try the
> following first. Boot your system with one of the mentioned kernels and
> unload all USB modules. Then try to reproduce. If you cannot reproduce
> the problem it's pretty clear where the problem originates.

I have mostly bad news. In summary, the bad news is that the
problem does not seem to be related to USB. The good news is that
when I blacklist the PCMCIA/CardBus drivers (yenta-socket), the
"noapic" boot is carried out without any "nobody cared" messages.

Here's the bad news: It looks like this problem is not caused by the
USB subsystem of the kernel.

I have inserted the following lines to /etc/modprobe.d/nobody-cared,
which is a file I just created:

=== 8< ===
blacklist usbcore
blacklist uhci_hcd
blacklist ehci_hcd
blacklist ohci_hcd
blacklist usbhid
=== >8 ===

I then regenerated the initial ramdisk images for all of the installed
kernels by issuing the following command: "update-initramfs -c -t -k all"

This way, I blocked the USB related modules from loading during and
after the initial ramdisk phase. I then rebooted into 2.6.27.4-spurious99
without any special command line options at 18:30 on the 3rd of November.

I confirmed that nothing related to USB was loaded by using "grep"
on dmesg and the output of "lsmod", in addition to inspecting them
manually.

And at 10:00am on the 4th of November, I got the "nobody cared"
message.

Here's the message from "dmesg":

=== 8< ===
irq 18: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.27.4-spurious99 #1
 [<c016d484>] __report_bad_irq+0x24/0x90
 [<c016d76a>] note_interrupt+0x27a/0x2b0
 [<c016cab0>] handle_IRQ_event+0x30/0x60
 [<c016ded3>] handle_fasteoi_irq+0xb3/0xe0
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c0104993>] common_interrupt+0x23/0x28
 [<f8849348>] acpi_idle_enter_simple+0x1ac/0x224 [processor]
 [<c02c0a55>] menu_select+0x35/0xd0
 [<c02bf7c3>] cpuidle_idle_call+0x73/0xd0
 [<c0102dad>] cpu_idle+0x6d/0x140
 =======================
handlers:
[<f8865940>] (sdhci_irq+0x0/0x610 [sdhci])
[<f8b47640>] (tifm_7xx1_isr+0x0/0x140 [tifm_7xx1])
[<f8b698e0>] (yenta_interrupt+0x0/0xf0 [yenta_socket])
Disabling IRQ #18
=== >8 ===

Here's /proc/interrupts:
=== 8< ===
           CPU0       CPU1       
  0:   68376071     173881   IO-APIC-edge      timer
  1:      20587          0   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc0
  9:      54565        147   IO-APIC-fasteoi   acpi
 12:      49872          0   IO-APIC-edge      i8042
 14:      44790          0   IO-APIC-edge      ata_piix
 15:     847781       2058   IO-APIC-edge      ata_piix
 16:        139          0   IO-APIC-fasteoi   i915@pci:0000:00:02.0
 17:       1427          0   IO-APIC-fasteoi   firewire_ohci
 18:     100000          2   IO-APIC-fasteoi   mmc0, tifm_7xx1, yenta
 20:      40463          0   IO-APIC-fasteoi   eth0
 22:    5447016       9407   IO-APIC-fasteoi   HDA Intel
220:    1641796          0   PCI-MSI-edge      iwl3945
NMI:          0          0   Non-maskable interrupts
LOC:    3880253   34290959   Local timer interrupts
RES:    1099682    1713006   Rescheduling interrupts
CAL:     148975     108163   function call interrupts
TLB:      71879     108785   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0
=== >8 ===

After you suggested to bisect the kernel, my first idea was to use
the "noapic" mode to help me with the bisection, since it made the
"nobody cared" messages appear much more quickly - during boot time
actually.

So, using the same USB blacklist settings, I booted the same kernel
using the "noapic" option. Even though I had disabled USB, I got
three "nobody cared" messages. After wondering what would happen
next, I then loaded the USB modules, and about 8 minutes later,
I got another "nobody cared" message.

I have pasted the dmesg output, contents of /proc/interrupts before
and after loading the USB modules to the end of this e-mail.
(It is titled "noapic experiment".)

I have also tried to boot with "noapic" option using the kernels
from Etch (Debian 4.0), unmodified: one based on 2.6.18 and one
based on 2.6.24. Again, I got similar "nobody cared" messages.

=== Partially Good News ===

Here's the good news: I thought of blacklisting all of the offending
modules (sdhci-pci, yenta-socket and tifm-7xx1 in addition to USB
related modules) and enabling them one by one. After taking a look
at the system logs, I was already suspicious about yenta-socket because
when I booted with "noapic", the first "nobody cared" message was almost
always printed around the time yenta-socket was probing for hardware.
(An example of this can be seen in the dmesg at the end of this e-mail.)

At the end of an enable/disable and reboot process, I found out
that it was actually yenta-socket. I have removed from the blacklist
all modules but yenta-socket, and I can say that the computer boots
with "noapic" without any problems. (I have tried 2.6.27.5-spurious99
and 2.6.25.19-spurious99 multiple times.) I haven't tried to let the
computer run with "noapic" like this for a long time to see whether
a "nobody cared" message pops up.

===

However, even the good news is mixed with bad news: After I disabled
yenta-socket, I enabled USB again. Then I booted *without* "noapic".
And after about 2.5 hours, I unfortunately encountered another
"nobody cared". I am attaching the dmesg output and /proc/interrupts
for this case as well. (They are at the end of this e-mail, and are
titled "mixed news".)

I have started to think that this might be a hardware or maybe
a BIOS/firmware related problem for which the only solution is
booting with "irqpoll". However, I'd rather not use "irqpoll"
as I seem to remember that it results in considerably lower
performance.

Nevertheless, I really wish that maybe something other than using
"irqpoll" could be done.
 
Thank you for your help once again.

Regards,

M. Vefa Bicakci

===
Note: Currently, I am trying Debian's 2.6.24 based kernel patched with
the 99900 to 99 spurious interrupt count modification. I thought that
maybe 2.6.24 does not have the problem.
===

Here's the dmesg from the "noapic experiment" with 2.6.27.4-spurious99:

=== 8< ===
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.27.4-spurious99 (root@debian) (gcc version 4.3.2 (Debian 4.3.2-1) ) #1 SMP PREEMPT Wed Oct 29 20:13:40 EDT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005f670000 (usable)
 BIOS-e820: 000000005f670000 - 000000005f700000 (ACPI NVS)
 BIOS-e820: 000000005f700000 - 0000000060000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
last_pfn = 0x5f670 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 38000000 @ 7000-c000
RAMDISK: 37806000 - 37fefa01
DMI present.
ACPI: RSDP 000F6510, 0014 (r0 TOSINV)
ACPI: RSDT 5F67E201, 0048 (r1 TOSINV Capell00  6040000  LTP        0)
ACPI: FACP 5F685DEE, 0074 (r1 TOSINV CALISTGA  6040000 LOHR       5A)
ACPI: DSDT 5F67F8B6, 6538 (r1 TOSINV CALISTGA  6040000 INTL 20050624)
ACPI: FACS 5F686FC0, 0040
ACPI: APIC 5F685E62, 0068 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: HPET 5F685ECA, 0038 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: MCFG 5F685F02, 003C (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: BOOT 5F685FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: APIC 5F685F70, 0068 (r1 TOSINV   APIC    6040000  LTP        0)
ACPI: SSDT 5F67F263, 064F (r1 SataRe  SataPri     1000 INTL 20050624)
ACPI: SSDT 5F67EBD1, 0692 (r1 SataRe  SataSec     1000 INTL 20050624)
ACPI: SSDT 5F67E249, 04F6 (r1  PmRef    CpuPm     3000 INTL 20050624)
ACPI: BIOS bug: multiple APIC/MADT found, using 0
ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
ACPI: DMI detected: Toshiba
630MB HIGHMEM available.
896MB LOWMEM available.
  mapped low ram: 0 - 38000000
  low ram: 00000000 - 38000000
  bootmap 00008000 - 0000f000
(9 early reservations) ==> bootmem [0000000000 - 0038000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 0000509420]    TEXT DATA BSS ==> [0000100000 - 0000509420]
  #4 [0037806000 - 0037fefa01]          RAMDISK ==> [0037806000 - 0037fefa01]
  #5 [000050a000 - 000050d000]    INIT_PG_TABLE ==> [000050a000 - 000050d000]
  #6 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #7 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
found SMP MP-table at [c00f65c0] 000f65c0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00038000
  HighMem  0x00038000 -> 0x0005f670
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0005f670
On node 0 totalpages: 390671
free_area_init_node: node 0, pgdat c042db80, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 160131 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: Skipping IOAPIC probe due to 'noapic' option.
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
MPTABLE: OEM ID: INTEL   
MPTABLE: Product ID: Napa ERB    
MPTABLE: APIC at: 0xFEE00000
I/O APIC #2 Version 32 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 68000000 (gap: 60000000:80000000)
PERCPU: Allocating 41220 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 387618
Kernel command line: root=/dev/mapper/root ro noapic
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 1828.737 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1536480k/1563072k available (2406k kernel code, 25412k reserved, 933k data, 320k init, 645568k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe18000 - 0xfffff000   (1948 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0449000 - 0xc0499000   ( 320 kB)
      .data : 0xc0359b18 - 0xc0443200   ( 933 kB)
      .text : 0xc0100000 - 0xc0359b18   (2406 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.47 BogoMIPS (lpj=1828737)
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080609
ACPI: setting ELCR to 0200 (from 0c00)
CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.34 BogoMIPS (lpj=1828673)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (7314.82 BogoMIPS).
net_namespace: 792 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:02.0 reg 10 32bit mmio: [dc100000, dc17ffff]
PCI: 0000:00:02.0 reg 14 io port: [1800, 1807]
PCI: 0000:00:02.0 reg 18 32bit mmio: [c0000000, cfffffff]
PCI: 0000:00:02.0 reg 1c 32bit mmio: [dc200000, dc23ffff]
PCI: 0000:00:02.1 reg 10 32bit mmio: [dc180000, dc1fffff]
PCI: 0000:00:1b.0 reg 10 64bit mmio: [dc240000, dc243fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [1820, 183f]
PCI: 0000:00:1d.1 reg 20 io port: [1840, 185f]
PCI: 0000:00:1d.2 reg 20 io port: [1860, 187f]
PCI: 0000:00:1d.3 reg 20 io port: [1880, 189f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [dc444000, dc4443ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: 0000:00:1f.2 reg 10 io port: [0, 7]
PCI: 0000:00:1f.2 reg 14 io port: [0, 3]
PCI: 0000:00:1f.2 reg 18 io port: [0, 7]
PCI: 0000:00:1f.2 reg 1c io port: [0, 3]
PCI: 0000:00:1f.2 reg 20 io port: [18b0, 18bf]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
PCI: 0000:00:1f.3 reg 20 io port: [18c0, 18df]
PCI: bridge 0000:00:1c.1 io port: [2000, 2fff]
PCI: bridge 0000:00:1c.1 32bit mmio: [d8000000, d9ffffff]
PCI: bridge 0000:00:1c.1 64bit mmio pref: [d2000000, d3ffffff]
PCI: 0000:05:00.0 reg 10 32bit mmio: [da000000, da000fff]
pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
pci 0000:05:00.0: PME# disabled
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.2. It can be enabled forcedly with 'pcie_aspm=force'
PCI: bridge 0000:00:1c.2 io port: [3000, 3fff]
PCI: bridge 0000:00:1c.2 32bit mmio: [da000000, dbffffff]
PCI: bridge 0000:00:1c.2 64bit mmio pref: [d4000000, d5ffffff]
PCI: 0000:07:06.0 reg 10 32bit mmio: [0, fff]
pci 0000:07:06.0: supports D1
pci 0000:07:06.0: supports D2
pci 0000:07:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:07:06.0: PME# disabled
PCI: 0000:07:06.1 reg 10 32bit mmio: [dc006000, dc0067ff]
PCI: 0000:07:06.1 reg 14 32bit mmio: [dc000000, dc003fff]
pci 0000:07:06.1: supports D1
pci 0000:07:06.1: supports D2
pci 0000:07:06.1: PME# supported from D0 D1 D2 D3hot
pci 0000:07:06.1: PME# disabled
PCI: 0000:07:06.2 reg 10 32bit mmio: [dc004000, dc004fff]
pci 0000:07:06.2: supports D1
pci 0000:07:06.2: supports D2
pci 0000:07:06.2: PME# supported from D0 D1 D2 D3hot
pci 0000:07:06.2: PME# disabled
PCI: 0000:07:06.3 reg 10 32bit mmio: [dc006800, dc0068ff]
pci 0000:07:06.3: supports D1
pci 0000:07:06.3: supports D2
pci 0000:07:06.3: PME# supported from D0 D1 D2 D3hot
pci 0000:07:06.3: PME# disabled
PCI: 0000:07:08.0 reg 10 32bit mmio: [dc005000, dc005fff]
PCI: 0000:07:08.0 reg 14 io port: [4000, 403f]
pci 0000:07:08.0: supports D1
pci 0000:07:08.0: supports D2
pci 0000:07:08.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:07:08.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [4000, 4fff]
PCI: bridge 0000:00:1e.0 32bit mmio: [dc000000, dc0fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: Power Resource [FN00] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
tracer: 772 pages allocated for 65536 entries of 48 bytes
   actual entries 65620
ACPI: RTC can wake from S4
system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:04: iomem range 0xfed00000-0xfed003ff could not be reserved
system 00:06: ioport range 0x400-0x401 has been reserved
system 00:06: ioport range 0x680-0x69f has been reserved
system 00:06: ioport range 0x800-0x80f has been reserved
system 00:06: ioport range 0x1000-0x107f has been reserved
system 00:06: ioport range 0x1180-0x11bf has been reserved
system 00:06: ioport range 0x1640-0x164f has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.1:   IO window: 0x2000-0x2fff
pci 0000:00:1c.1:   MEM window: 0xd8000000-0xd9ffffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000d2000000-0x000000d3ffffff
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:05
pci 0000:00:1c.2:   IO window: 0x3000-0x3fff
pci 0000:00:1c.2:   MEM window: 0xda000000-0xdbffffff
pci 0000:00:1c.2:   PREFETCH window: 0x000000d4000000-0x000000d5ffffff
pci 0000:07:06.0: CardBus bridge, secondary bus 0000:08
pci 0000:07:06.0:   IO window: 0x004400-0x0044ff
pci 0000:07:06.0:   IO window: 0x004800-0x0048ff
pci 0000:07:06.0:   PREFETCH window: 0x68000000-0x6bffffff
pci 0000:07:06.0:   MEM window: 0x6c000000-0x6fffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
pci 0000:00:1e.0:   IO window: 0x4000-0x4fff
pci 0000:00:1e.0:   MEM window: 0xdc000000-0xdc0fffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000068000000-0x0000006bffffff
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
pci 0000:00:1c.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
pci 0000:00:1c.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
pci 0000:00:1c.1: PCI INT B -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
pci 0000:00:1c.1: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
pci 0000:00:1c.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:07:06.0: enabling device (0000 -> 0003)
pci 0000:07:06.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 02 index 0 mmio: [0, 0]
bus: 02 index 1 mmio: [0, 0]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 io port: [2000, 2fff]
bus: 03 index 1 mmio: [d8000000, d9ffffff]
bus: 03 index 2 mmio: [d2000000, d3ffffff]
bus: 03 index 3 mmio: [0, 0]
bus: 05 index 0 io port: [3000, 3fff]
bus: 05 index 1 mmio: [da000000, dbffffff]
bus: 05 index 2 mmio: [d4000000, d5ffffff]
bus: 05 index 3 mmio: [0, 0]
bus: 07 index 0 io port: [4000, 4fff]
bus: 07 index 1 mmio: [dc000000, dc0fffff]
bus: 07 index 2 mmio: [68000000, 6bffffff]
bus: 07 index 3 io port: [0, ffff]
bus: 07 index 4 mmio: [0, ffffffffffffffff]
bus: 08 index 0 io port: [4400, 44ff]
bus: 08 index 1 io port: [4800, 48ff]
bus: 08 index 2 mmio: [68000000, 6bffffff]
bus: 08 index 3 mmio: [6c000000, 6fffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs...<7>Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
 done
Freeing initrd memory: 8102k freed
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1225735724.849:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1757
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pci 0000:07:08.0: Firmware left e100 interrupts enabled; disabling
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pci_express 0000:00:1c.2:pcie03: allocate port service
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
input: Macintosh mouse button emulation as /devices/virtual/input/input0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
Using IPI No-Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 320k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
ACPI: Transitioning device [FAN0] to D3
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN0] (off)
ACPI: SSDT 5F67E9A0, 01A8 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 5F67E73F, 01DC (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI0007:00: registered as cooling_device1
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 5F67EB48, 0089 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT 5F67E91B, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
Marking TSC unstable due to TSC halts in idle
ACPI: CPU1 (power states: C1[C1] C2[C2])
processor ACPI0007:01: registered as cooling_device2
ACPI: Processor [CPU1] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (54 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Thermal Zone [TZ01] (58 C)
ACPI: ACPI Dock Station Driver
SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
pata_acpi 0000:00:1f.2: PCI INT B -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
pata_acpi 0000:00:1f.2: setting latency timer to 64
pata_acpi 0000:00:1f.2: PCI INT B disabled
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT B -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x18b0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x18b8 irq 15
ata1.00: ATA-6: TOSHIBA MK8032GSX, AS112M, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
ata2.00: ATAPI: MATSHITADVD-RAM UJ-841S, 1.60, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK8032GS AS11 PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-841S  1.60 PQ: 0 ANSI: 5
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 10
e100 0000:07:08.0: PCI INT A -> Link[LNKE] -> GSI 10 (level, low) -> IRQ 10
e100 0000:07:08.0: PME# disabled
e100: eth0: e100_probe: addr 0xdc005000, irq 10, MAC addr xx:xx:xx:xx:xx:xx
firewire_ohci 0000:07:06.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
firewire_ohci: Added fw-ohci device 0000:07:06.1, OHCI version 1.10
sdhci-pci 0000:07:06.3: SDHCI controller found [104c:803c] (rev 0)
sdhci-pci 0000:07:06.3: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
mmc0: SDHCI controller on PCI [0000:07:06.3] using DMA
 sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
padlock: VIA PadLock not detected.
firewire_core: created device fw0: GUID xxxxxxxxxxxxxxxx, S400
padlock: VIA PadLock Hash Engine not detected.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
PM: Starting manual resume from disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
udevd version 125 started
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: AC Adapter [ADP0] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input3
ACPI: Lid Switch [LID]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
ACPI: Power Button (CM) [PWRB]
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/device:02/input/input5
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
acpi device:0a: registered as cooling_device3
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:07/input/input6
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
i801_smbus 0000:00:1f.3: PCI INT B -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
ACPI: I/O resource 0000:00:1f.3 [0x18c0-0x18df] conflicts with ACPI region SMBI [0x18c0-0x18cf]
ACPI: Device needs an ACPI driver
tifm_7xx1 0000:07:06.2: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
Yenta: CardBus bridge found at 0000:07:06.0 [1179:ff10]
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:07:06.0, mfunc 0x01a01b22, devctl 0x66
irq 11: nobody cared (try booting with the "irqpoll" option)
Pid: 1440, comm: modprobe Not tainted 2.6.27.4-spurious99 #1
 [<c016d484>] __report_bad_irq+0x24/0x90
 [<c016d76a>] note_interrupt+0x27a/0x2b0
 [<c016cab0>] handle_IRQ_event+0x30/0x60
 [<c016dfd3>] handle_level_irq+0xd3/0x100
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c013278d>] irq_exit+0x5d/0x90
 [<c01149b5>] smp_apic_timer_interrupt+0x55/0x80
 [<c0104993>] common_interrupt+0x23/0x28
 [<c03500d8>] cpuid4_cache_lookup+0x248/0x342
 [<c016ca90>] handle_IRQ_event+0x10/0x60
 [<c016df7d>] handle_level_irq+0x7d/0x100
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c016d211>] setup_irq+0x121/0x250
 [<c0104993>] common_interrupt+0x23/0x28
 [<c016007b>] cpuset_write_s64+0xb/0xa0
 [<f8b5e8cc>] yenta_probe_cb_irq+0x9c/0x110 [yenta_socket]
 [<f8b5ec58>] ti12xx_override+0x238/0x6a0 [yenta_socket]
 [<f8b6004a>] yenta_probe+0x62a/0x67b [yenta_socket]
 [<c01f0532>] sysfs_add_one+0x12/0x50
 [<c01f05dd>] sysfs_addrm_start+0x6d/0xc0
 [<c0358aa5>] _spin_unlock+0x5/0x20
 [<c0245a70>] pci_match_device+0xa0/0xc0
 [<c0246246>] pci_device_probe+0x56/0x80
 [<c02ac5a6>] driver_probe_device+0x86/0x1a0
 [<c0358694>] _spin_lock_irqsave+0x34/0x50
 [<c02ac731>] __driver_attach+0x71/0x80
 [<c0246190>] pci_device_remove+0x0/0x40
 [<c02abed4>] bus_for_each_dev+0x44/0x70
 [<c0246190>] pci_device_remove+0x0/0x40
 [<c02ac436>] driver_attach+0x16/0x20
 [<c02ac6c0>] __driver_attach+0x0/0x80
 [<c02ab897>] bus_add_driver+0x1a7/0x220
 [<c0246190>] pci_device_remove+0x0/0x40
 [<c02ac8cc>] driver_register+0x5c/0x130
 [<f89a3000>] yenta_socket_init+0x0/0x14 [yenta_socket]
 [<c0246487>] __pci_register_driver+0x47/0x90
 [<f89a3000>] yenta_socket_init+0x0/0x14 [yenta_socket]
 [<c010111a>] do_one_initcall+0x2a/0x160
 [<c0127b9f>] try_to_wake_up+0xbf/0x190
 [<c0154afb>] sys_init_module+0x8b/0x1b0
 [<c0103eef>] sysenter_do_call+0x12/0x2f
 [<c0350000>] cpuid4_cache_lookup+0x170/0x342
 =======================
handlers:
[<f88b4b60>] (irq_handler+0x0/0x490 [firewire_ohci])
Disabling IRQ #11
input: PC Speaker as /devices/platform/pcspkr/input/input7
Yenta: ISA IRQ mask 0x00f8, PCI irq 10
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#07) from #07 to #0b
pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
cs: IO port probe 0x4000-0x4fff: clean.
pcmcia: parent PCI bridge Memory window: 0xdc000000 - 0xdc0fffff
pcmcia: parent PCI bridge Memory window: 0x68000000 - 0x6bffffff
intel_rng: FWH not detected
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
iwl3945: Copyright(c) 2003-2008 Intel Corporation
iwl3945 0000:05:00.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
iwl3945 0000:05:00.0: setting latency timer to 64
iwl3945: Detected Intel Wireless WiFi Link 3945ABG
iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
phy0: Selected rate control algorithm 'iwl-3945-rs'
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, hpet irqs
iwl3945 0000:05:00.0: PCI INT A disabled
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04713/0x0
synaptics: Toshiba Satellite A100 detected, limiting rate to 40pps.
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input8
ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 10
HDA Intel 0000:00:1b.0: PCI INT A -> Link[LNKG] -> GSI 10 (level, low) -> IRQ 10
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: Unknown model for ALC861, trying auto-probe from BIOS...
cs: IO port probe 0x100-0x3af: clean.
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
EXT3 FS on dm-1, internal journal
fuse init (API version 7.9)
irq 10: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.27.4-spurious99 #1
 [<c016d484>] __report_bad_irq+0x24/0x90
 [<c016d76a>] note_interrupt+0x27a/0x2b0
 [<c016cab0>] handle_IRQ_event+0x30/0x60
 [<c016dfd3>] handle_level_irq+0xd3/0x100
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c0104993>] common_interrupt+0x23/0x28
 [<c03500d8>] cpuid4_cache_lookup+0x248/0x342
 [<c016ca90>] handle_IRQ_event+0x10/0x60
 [<c016df7d>] handle_level_irq+0x7d/0x100
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c0104993>] common_interrupt+0x23/0x28
 [<f8849348>] acpi_idle_enter_simple+0x1ac/0x224 [processor]
 [<c02c0a55>] menu_select+0x35/0xd0
 [<c02bf7c3>] cpuidle_idle_call+0x73/0xd0
 [<c0102dad>] cpu_idle+0x6d/0x140
 =======================
handlers:
[<f88d8940>] (sdhci_irq+0x0/0x610 [sdhci])
[<f8a6f640>] (tifm_7xx1_isr+0x0/0x140 [tifm_7xx1])
[<f8b5f8e0>] (yenta_interrupt+0x0/0xf0 [yenta_socket])
[<f8c497a0>] (azx_interrupt+0x0/0x130 [snd_hda_intel])
Disabling IRQ #10
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1999024k swap on /dev/mapper/suspend.  Priority:-1 extents:1 across:1999024k
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x10a90000
lp: driver loaded but no devices found
ppdev: user-space parallel port driver
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
irq 10: nobody cared (try booting with the "irqpoll" option)
Pid: 4187, comm: NetworkManager Not tainted 2.6.27.4-spurious99 #1
 [<c016d484>] __report_bad_irq+0x24/0x90
 [<c016d76a>] note_interrupt+0x27a/0x2b0
 [<c016cab0>] handle_IRQ_event+0x30/0x60
 [<c016dfd3>] handle_level_irq+0xd3/0x100
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c013278d>] irq_exit+0x5d/0x90
 [<c01149b5>] smp_apic_timer_interrupt+0x55/0x80
 [<c0104993>] common_interrupt+0x23/0x28
 [<c013249e>] __do_softirq+0x4e/0xe0
 [<c0132585>] do_softirq+0x55/0x60
 [<c01327a5>] irq_exit+0x75/0x90
 [<c0107180>] do_IRQ+0x40/0x70
 [<c0104993>] common_interrupt+0x23/0x28
 [<c016007b>] cpuset_write_s64+0xb/0xa0
 [<c0358a1a>] _spin_unlock_irqrestore+0x1a/0x60
 [<c016d1f7>] setup_irq+0x107/0x250
 [<c0137387>] lock_timer_base+0x27/0x60
 [<f88ff1a0>] e100_intr+0x0/0xe0 [e100]
 [<c016d3e5>] request_irq+0xa5/0xc0
 [<f88ff063>] e100_up+0xb3/0x130 [e100]
 [<f88ff103>] e100_open+0x23/0x70 [e100]
 [<f894c859>] dm_request+0x109/0x170 [dm_mod]
 [<c02d5c2e>] dev_open+0x7e/0xe0
 [<c035886a>] _spin_lock_bh+0x1a/0x20
 [<c02d3bd0>] dev_set_rx_mode+0x20/0x40
 [<c02d5525>] dev_change_flags+0x85/0x1c0
 [<c02dd4b0>] do_setlink+0x200/0x3b0
 [<c02dd75a>] rtnl_setlink+0xfa/0x140
 [<c02edeca>] netlink_dump_start+0x12a/0x150
 [<c02dd660>] rtnl_setlink+0x0/0x140
 [<c02de6cd>] rtnetlink_rcv_msg+0x16d/0x210
 [<c02ca6cb>] sock_rmalloc+0x2b/0x70
 [<c02de560>] rtnetlink_rcv_msg+0x0/0x210
 [<c02ef596>] netlink_rcv_skb+0x66/0x90
 [<c02de559>] rtnetlink_rcv+0x19/0x20
 [<c02eefc9>] netlink_unicast+0x289/0x2b0
 [<c02ef1d5>] netlink_sendmsg+0x1e5/0x2f0
 [<c02c7771>] sock_sendmsg+0x111/0x130
 [<c0141980>] autoremove_wake_function+0x0/0x50
 [<c0141980>] autoremove_wake_function+0x0/0x50
 [<c0358aa5>] _spin_unlock+0x5/0x20
 [<c02c7904>] sys_sendmsg+0x174/0x280
 [<c02c8910>] sys_recvmsg+0x1a0/0x240
 [<c02ed768>] netlink_table_ungrab+0x28/0x30
 [<c02c875f>] move_addr_to_user+0x7f/0x90
 [<c02c8cfe>] sys_getsockname+0xce/0xe0
 [<c035886a>] _spin_lock_bh+0x1a/0x20
 [<c02ca144>] lock_sock_nested+0x94/0xb0
 [<c0145778>] ktime_get+0x18/0x40
 [<c0358aa5>] _spin_unlock+0x5/0x20
 [<c02c904e>] sys_socketcall+0xee/0x2e0
 [<c0103eef>] sysenter_do_call+0x12/0x2f
 [<c0350000>] cpuid4_cache_lookup+0x170/0x342
 =======================
handlers:
[<f88d8940>] (sdhci_irq+0x0/0x610 [sdhci])
[<f8a6f640>] (tifm_7xx1_isr+0x0/0x140 [tifm_7xx1])
[<f8b5f8e0>] (yenta_interrupt+0x0/0xf0 [yenta_socket])
[<f8c497a0>] (azx_interrupt+0x0/0x130 [snd_hda_intel])
[<f88ff1a0>] (e100_intr+0x0/0xe0 [e100])
Disabling IRQ #10
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ADDRCONF(NETDEV_UP): eth0: link is not ready
iwl3945 0000:05:00.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
iwl3945 0000:05:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
firmware: requesting iwlwifi-3945-1.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (47 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Thermal Zone [TZ01] (49 C)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ehci_hcd 0000:00:1d.7: PCI INT A -> Link[LNKH] -> GSI 11 (level, low) -> IRQ 11
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xdc444000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27.4-spurious99 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKH] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001820
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27.4-spurious99 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27.4-spurious99 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 10, io base 0x00001860
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27.4-spurious99 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
uhci_hcd 0000:00:1d.3: PCI INT D -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 10, io base 0x00001880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 4-1: new low speed USB device using uhci_hcd and address 2
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27.4-spurious99 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
usb 4-1: configuration #1 chosen from 1 choice
usb 4-1: New USB device found, idVendor=0d62, idProduct=0004
usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-1: Product: USB Keyboard
usb 4-1: Manufacturer: Darfon
usbcore: registered new interface driver hiddev
input: Darfon USB Keyboard as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input9
input,hidraw0: USB HID v1.10 Keyboard [Darfon USB Keyboard] on usb-0000:00:1d.2-1
input: Darfon USB Keyboard as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.1/input/input10
input,hiddev96,hidraw1: USB HID v1.10 Device [Darfon USB Keyboard] on usb-0000:00:1d.2-1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
spurious 8259A interrupt: IRQ7.
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
NET: Registered protocol family 17
wlan0: authenticate with AP xx:xx:xx:xx:xx:xx
wlan0: authenticated
wlan0: associate with AP xx:xx:xx:xx:xx:xx
wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x431 status=0 aid=3)
wlan0: associated
wlan0 (WE) : Wireless Event too big (320)
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
CE: hpet increasing min_delta_ns to 15000 nsec
irq 10: nobody cared (try booting with the "irqpoll" option)
Pid: 4027, comm: arecord Not tainted 2.6.27.4-spurious99 #1
 [<c016d484>] __report_bad_irq+0x24/0x90
 [<c016d76a>] note_interrupt+0x27a/0x2b0
 [<c016cab0>] handle_IRQ_event+0x30/0x60
 [<c016dfd3>] handle_level_irq+0xd3/0x100
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c013278d>] irq_exit+0x5d/0x90
 [<c01149b5>] smp_apic_timer_interrupt+0x55/0x80
 [<c0104993>] common_interrupt+0x23/0x28
 [<c03500d8>] cpuid4_cache_lookup+0x248/0x342
 [<c016ca90>] handle_IRQ_event+0x10/0x60
 [<c016df7d>] handle_level_irq+0x7d/0x100
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c0104993>] common_interrupt+0x23/0x28
 [<c01b264f>] do_sys_poll+0x1cf/0x350
 [<c01b37e0>] __pollwait+0x0/0xf0
 [<c0127c70>] default_wake_function+0x0/0x10
 [<c0148451>] getnstimeofday+0x41/0xf0
 [<c0235b11>] rb_insert_color+0xc1/0xf0
 [<c0144ad4>] enqueue_hrtimer+0x74/0x120
 [<c01454ad>] hrtimer_start+0xad/0x180
 [<c01227b8>] hrtick_start_fair+0x178/0x190
 [<c010254e>] __switch_to+0xae/0x180
 [<c03589d5>] _spin_unlock_irq+0x5/0x30
 [<c012902f>] finish_task_switch+0x1f/0xb0
 [<c0356a07>] schedule+0x437/0xa30
 [<c0125d81>] check_preempt_wakeup+0x131/0x160
 [<c0121dfe>] __wake_up+0x3e/0x60
 [<f8bbd6f4>] snd_pcm_update_hw_ptr+0x184/0x220 [snd_pcm]
 [<c0358aa5>] _spin_unlock+0x5/0x20
 [<f8bb757b>] snd_pcm_hwsync+0x4b/0xa0 [snd_pcm]
 [<f8bb9d77>] snd_pcm_common_ioctl1+0x2f7/0x13d0 [snd_pcm]
 [<c03401a0>] unix_stream_sendmsg+0x2e0/0x380
 [<c02c6d84>] sock_aio_write+0x134/0x150
 [<c01a4c15>] do_sync_write+0xd5/0x120
 [<f8bbae8d>] snd_pcm_capture_ioctl1+0x3d/0x390 [snd_pcm]
 [<c03589d5>] _spin_unlock_irq+0x5/0x30
 [<f89dba1f>] snd_timer_user_read+0x8f/0x1d0 [snd_timer]
 [<c020288c>] security_file_permission+0xc/0x10
 [<c01a4dca>] rw_verify_area+0x4a/0xc0
 [<c01b1acb>] vfs_ioctl+0x2b/0x90
 [<f89db990>] snd_timer_user_read+0x0/0x1d0 [snd_timer]
 [<c01a591d>] vfs_read+0x9d/0x160
 [<c01b2a8d>] sys_poll+0x2d/0x80
 [<c0103eef>] sysenter_do_call+0x12/0x2f
 =======================
handlers:
[<f88d8940>] (sdhci_irq+0x0/0x610 [sdhci])
[<f8a6f640>] (tifm_7xx1_isr+0x0/0x140 [tifm_7xx1])
[<f8b5f8e0>] (yenta_interrupt+0x0/0xf0 [yenta_socket])
[<f8c497a0>] (azx_interrupt+0x0/0x130 [snd_hda_intel])
[<f88ff1a0>] (e100_intr+0x0/0xe0 [e100])
[<f8eb0820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8eb0820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8ef8a90>] (i915_driver_irq_handler+0x0/0x230 [i915])
Disabling IRQ #10
uhci_hcd 0000:00:1d.3: remove, state 4
usb usb5: USB disconnect, address 1
uhci_hcd 0000:00:1d.3: USB bus 5 deregistered
uhci_hcd 0000:00:1d.3: PCI INT D disabled
uhci_hcd 0000:00:1d.2: remove, state 1
usb usb4: USB disconnect, address 1
usb 4-1: USB disconnect, address 2
drivers/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
drivers/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
uhci_hcd 0000:00:1d.2: USB bus 4 deregistered
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: remove, state 4
usb usb3: USB disconnect, address 1
uhci_hcd 0000:00:1d.1: USB bus 3 deregistered
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: remove, state 4
usb usb2: USB disconnect, address 1
uhci_hcd 0000:00:1d.0: USB bus 2 deregistered
uhci_hcd 0000:00:1d.0: PCI INT A disabled
wlan0: deauthenticating by local choice (reason=3)
iwl3945 0000:05:00.0: PCI INT A disabled
=== >8 ===

Here's /proc/interrupts before loading the USB modules:

=== 8< ===
           CPU0       CPU1
  0:      27826          0    XT-PIC-XT        timer
  1:       1085          0    XT-PIC-XT        i8042
  2:          0          0    XT-PIC-XT        cascade
  3:          1          0    XT-PIC-XT
  4:          1          0    XT-PIC-XT
  5:          1          0    XT-PIC-XT
  6:          1          0    XT-PIC-XT
  7:          1          0    XT-PIC-XT
  8:          1          0    XT-PIC-XT        rtc0
  9:         92          0    XT-PIC-XT        acpi
 10:     200001          0    XT-PIC-XT        mmc0, tifm_7xx1, yenta, HDA Intel, eth0
 11:     100000          0    XT-PIC-XT        firewire_ohci
 12:        132          0    XT-PIC-XT        i8042
 14:       4918          0    XT-PIC-XT        ata_piix
 15:        200          0    XT-PIC-XT        ata_piix
220:         26          0   PCI-MSI-edge      iwl3945
NMI:          0          0   Non-maskable interrupts
LOC:      16741      26167   Local timer interrupts
RES:       2950       6460   Rescheduling interrupts
CAL:       1225       1621   function call interrupts
TLB:        408        402   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0
=== >8 ===

Here's /proc/interrupts after loading the USB modules:

=== 8< ===
           CPU0       CPU1       
  0:     657332          0    XT-PIC-XT        timer
  1:       5133          0    XT-PIC-XT        i8042
  2:          0          0    XT-PIC-XT        cascade
  3:          1          0    XT-PIC-XT      
  4:          1          0    XT-PIC-XT      
  5:          1          0    XT-PIC-XT      
  6:          1          0    XT-PIC-XT      
  7:          3          0    XT-PIC-XT      
  8:          1          0    XT-PIC-XT        rtc0
  9:        792          0    XT-PIC-XT        acpi
 10:     305114          0    XT-PIC-XT        mmc0, tifm_7xx1, yenta, HDA Intel, eth0, uhci_hcd:usb4, i915@pci:0000:00:02.0
 11:     100017          0    XT-PIC-XT        firewire_ohci, ehci_hcd:usb1, uhci_hcd:usb2, uhci_hcd:usb3
 12:       5562          0    XT-PIC-XT        i8042
 14:      22948          0    XT-PIC-XT        ata_piix
 15:      11265          0    XT-PIC-XT        ata_piix
220:      20356          0   PCI-MSI-edge      iwl3945
NMI:          0          0   Non-maskable interrupts
LOC:     131159     500662   Local timer interrupts
RES:      24481      51102   Rescheduling interrupts
CAL:      34996      57882   function call interrupts
TLB:       1228       1250   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          2
MIS:          0
=== >8 ===

Here's the "mixed news" dmesg:

APIC enabled; USB enabled; yenta-socket, tifm_7xx1 and sdhci disabled.

=== 8< ===
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.27.5-spurious99 (root@debian) (gcc version 4.3.2 (Debian 4.3.2-1) ) #1 SMP PREEMPT Fri Nov 7 18:56:10 EST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005f670000 (usable)
 BIOS-e820: 000000005f670000 - 000000005f700000 (ACPI NVS)
 BIOS-e820: 000000005f700000 - 0000000060000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
last_pfn = 0x5f670 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 38000000 @ 7000-c000
RAMDISK: 37805000 - 37fef021
DMI present.
ACPI: RSDP 000F6510, 0014 (r0 TOSINV)
ACPI: RSDT 5F67E201, 0048 (r1 TOSINV Capell00  6040000  LTP        0)
ACPI: FACP 5F685DEE, 0074 (r1 TOSINV CALISTGA  6040000 LOHR       5A)
ACPI: DSDT 5F67F8B6, 6538 (r1 TOSINV CALISTGA  6040000 INTL 20050624)
ACPI: FACS 5F686FC0, 0040
ACPI: APIC 5F685E62, 0068 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: HPET 5F685ECA, 0038 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: MCFG 5F685F02, 003C (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: BOOT 5F685FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: APIC 5F685F70, 0068 (r1 TOSINV   APIC    6040000  LTP        0)
ACPI: SSDT 5F67F263, 064F (r1 SataRe  SataPri     1000 INTL 20050624)
ACPI: SSDT 5F67EBD1, 0692 (r1 SataRe  SataSec     1000 INTL 20050624)
ACPI: SSDT 5F67E249, 04F6 (r1  PmRef    CpuPm     3000 INTL 20050624)
ACPI: BIOS bug: multiple APIC/MADT found, using 0
ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
ACPI: DMI detected: Toshiba
630MB HIGHMEM available.
896MB LOWMEM available.
  mapped low ram: 0 - 38000000
  low ram: 00000000 - 38000000
  bootmap 00008000 - 0000f000
(9 early reservations) ==> bootmem [0000000000 - 0038000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00005f9420]    TEXT DATA BSS ==> [0000100000 - 00005f9420]
  #4 [0037805000 - 0037fef021]          RAMDISK ==> [0037805000 - 0037fef021]
  #5 [00005fa000 - 00005fd000]    INIT_PG_TABLE ==> [00005fa000 - 00005fd000]
  #6 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #7 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
found SMP MP-table at [c00f65c0] 000f65c0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00038000
  HighMem  0x00038000 -> 0x0005f670
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0005f670
On node 0 totalpages: 390671
free_area_init_node: node 0, pgdat c042db80, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 160131 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 68000000 (gap: 60000000:80000000)
PERCPU: Allocating 41220 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 387618
Kernel command line: root=/dev/mapper/root ro 
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 1828.745 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1535520k/1563072k available (2406k kernel code, 26376k reserved, 933k data, 320k init, 645568k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe18000 - 0xfffff000   (1948 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0449000 - 0xc0499000   ( 320 kB)
      .data : 0xc0359aa8 - 0xc0443200   ( 933 kB)
      .text : 0xc0100000 - 0xc0359aa8   (2406 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.49 BogoMIPS (lpj=1828745)
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080609
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.34 BogoMIPS (lpj=1828671)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (7314.83 BogoMIPS).
net_namespace: 792 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:02.0 reg 10 32bit mmio: [dc100000, dc17ffff]
PCI: 0000:00:02.0 reg 14 io port: [1800, 1807]
PCI: 0000:00:02.0 reg 18 32bit mmio: [c0000000, cfffffff]
PCI: 0000:00:02.0 reg 1c 32bit mmio: [dc200000, dc23ffff]
PCI: 0000:00:02.1 reg 10 32bit mmio: [dc180000, dc1fffff]
PCI: 0000:00:1b.0 reg 10 64bit mmio: [dc240000, dc243fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [1820, 183f]
PCI: 0000:00:1d.1 reg 20 io port: [1840, 185f]
PCI: 0000:00:1d.2 reg 20 io port: [1860, 187f]
PCI: 0000:00:1d.3 reg 20 io port: [1880, 189f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [dc444000, dc4443ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: 0000:00:1f.2 reg 10 io port: [0, 7]
PCI: 0000:00:1f.2 reg 14 io port: [0, 3]
PCI: 0000:00:1f.2 reg 18 io port: [0, 7]
PCI: 0000:00:1f.2 reg 1c io port: [0, 3]
PCI: 0000:00:1f.2 reg 20 io port: [18b0, 18bf]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
PCI: 0000:00:1f.3 reg 20 io port: [18c0, 18df]
PCI: bridge 0000:00:1c.1 io port: [2000, 2fff]
PCI: bridge 0000:00:1c.1 32bit mmio: [d8000000, d9ffffff]
PCI: bridge 0000:00:1c.1 64bit mmio pref: [d2000000, d3ffffff]
PCI: 0000:05:00.0 reg 10 32bit mmio: [da000000, da000fff]
pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
pci 0000:05:00.0: PME# disabled
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.2. It can be enabled forcedly with 'pcie_aspm=force'
PCI: bridge 0000:00:1c.2 io port: [3000, 3fff]
PCI: bridge 0000:00:1c.2 32bit mmio: [da000000, dbffffff]
PCI: bridge 0000:00:1c.2 64bit mmio pref: [d4000000, d5ffffff]
PCI: 0000:07:06.0 reg 10 32bit mmio: [0, fff]
pci 0000:07:06.0: supports D1
pci 0000:07:06.0: supports D2
pci 0000:07:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:07:06.0: PME# disabled
PCI: 0000:07:06.1 reg 10 32bit mmio: [dc006000, dc0067ff]
PCI: 0000:07:06.1 reg 14 32bit mmio: [dc000000, dc003fff]
pci 0000:07:06.1: supports D1
pci 0000:07:06.1: supports D2
pci 0000:07:06.1: PME# supported from D0 D1 D2 D3hot
pci 0000:07:06.1: PME# disabled
PCI: 0000:07:06.2 reg 10 32bit mmio: [dc004000, dc004fff]
pci 0000:07:06.2: supports D1
pci 0000:07:06.2: supports D2
pci 0000:07:06.2: PME# supported from D0 D1 D2 D3hot
pci 0000:07:06.2: PME# disabled
PCI: 0000:07:06.3 reg 10 32bit mmio: [dc006800, dc0068ff]
pci 0000:07:06.3: supports D1
pci 0000:07:06.3: supports D2
pci 0000:07:06.3: PME# supported from D0 D1 D2 D3hot
pci 0000:07:06.3: PME# disabled
PCI: 0000:07:08.0 reg 10 32bit mmio: [dc005000, dc005fff]
PCI: 0000:07:08.0 reg 14 io port: [4000, 403f]
pci 0000:07:08.0: supports D1
pci 0000:07:08.0: supports D2
pci 0000:07:08.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:07:08.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [4000, 4fff]
PCI: bridge 0000:00:1e.0 32bit mmio: [dc000000, dc0fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: Power Resource [FN00] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
tracer: 772 pages allocated for 65536 entries of 48 bytes
   actual entries 65620
ACPI: RTC can wake from S4
system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:04: iomem range 0xfed00000-0xfed003ff could not be reserved
system 00:06: ioport range 0x400-0x401 has been reserved
system 00:06: ioport range 0x680-0x69f has been reserved
system 00:06: ioport range 0x800-0x80f has been reserved
system 00:06: ioport range 0x1000-0x107f has been reserved
system 00:06: ioport range 0x1180-0x11bf has been reserved
system 00:06: ioport range 0x1640-0x164f has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.1:   IO window: 0x2000-0x2fff
pci 0000:00:1c.1:   MEM window: 0xd8000000-0xd9ffffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000d2000000-0x000000d3ffffff
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:05
pci 0000:00:1c.2:   IO window: 0x3000-0x3fff
pci 0000:00:1c.2:   MEM window: 0xda000000-0xdbffffff
pci 0000:00:1c.2:   PREFETCH window: 0x000000d4000000-0x000000d5ffffff
pci 0000:07:06.0: CardBus bridge, secondary bus 0000:08
pci 0000:07:06.0:   IO window: 0x004400-0x0044ff
pci 0000:07:06.0:   IO window: 0x004800-0x0048ff
pci 0000:07:06.0:   PREFETCH window: 0x68000000-0x6bffffff
pci 0000:07:06.0:   MEM window: 0x6c000000-0x6fffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
pci 0000:00:1e.0:   IO window: 0x4000-0x4fff
pci 0000:00:1e.0:   MEM window: 0xdc000000-0xdc0fffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000068000000-0x0000006bffffff
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:07:06.0: enabling device (0000 -> 0003)
pci 0000:07:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 02 index 0 mmio: [0, 0]
bus: 02 index 1 mmio: [0, 0]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 io port: [2000, 2fff]
bus: 03 index 1 mmio: [d8000000, d9ffffff]
bus: 03 index 2 mmio: [d2000000, d3ffffff]
bus: 03 index 3 mmio: [0, 0]
bus: 05 index 0 io port: [3000, 3fff]
bus: 05 index 1 mmio: [da000000, dbffffff]
bus: 05 index 2 mmio: [d4000000, d5ffffff]
bus: 05 index 3 mmio: [0, 0]
bus: 07 index 0 io port: [4000, 4fff]
bus: 07 index 1 mmio: [dc000000, dc0fffff]
bus: 07 index 2 mmio: [68000000, 6bffffff]
bus: 07 index 3 io port: [0, ffff]
bus: 07 index 4 mmio: [0, ffffffffffffffff]
bus: 08 index 0 io port: [4400, 44ff]
bus: 08 index 1 io port: [4800, 48ff]
bus: 08 index 2 mmio: [68000000, 6bffffff]
bus: 08 index 3 mmio: [6c000000, 6fffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs...<7>Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
 done
Freeing initrd memory: 8104k freed
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1226138708.863:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1755
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pci 0000:07:08.0: Firmware left e100 interrupts enabled; disabling
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pci_express 0000:00:1c.2:pcie03: allocate port service
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
input: Macintosh mouse button emulation as /devices/virtual/input/input0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
Using IPI No-Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 320k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
ACPI: Transitioning device [FAN0] to D3
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN0] (off)
ACPI: SSDT 5F67E9A0, 01A8 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 5F67E73F, 01DC (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI0007:00: registered as cooling_device1
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 5F67EB48, 0089 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT 5F67E91B, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2])
processor ACPI0007:01: registered as cooling_device2
ACPI: Processor [CPU1] (supports 8 throttling states)
Marking TSC unstable due to TSC halts in idle
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (54 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Thermal Zone [TZ01] (58 C)
ACPI: ACPI Dock Station Driver
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001820
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
SCSI subsystem initialized
libata version 3.00 loaded.
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27.5-spurious99 uhci_hcd
usb usb1: SerialNumber: 0000:00:1d.0
firewire_ohci 0000:07:06.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xdc444000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
firewire_ohci: Added fw-ohci device 0000:07:06.1, OHCI version 1.10
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27.5-spurious99 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27.5-spurious99 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27.5-spurious99 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27.5-spurious99 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
e100 0000:07:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e100 0000:07:08.0: PME# disabled
e100: eth0: e100_probe: addr 0xdc005000, irq 20, MAC addr xx:xx:xx:xx:xx:xx
pata_acpi 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
pata_acpi 0000:00:1f.2: setting latency timer to 64
pata_acpi 0000:00:1f.2: PCI INT B disabled
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
firewire_core: created device fw0: GUID xxxxxxxxxxxxxxxx, S400
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x18b0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x18b8 irq 15
ata1.00: ATA-6: TOSHIBA MK8032GSX, AS112M, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
ata2.00: ATAPI: MATSHITADVD-RAM UJ-841S, 1.60, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK8032GS AS11 PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-841S  1.60 PQ: 0 ANSI: 5
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<4>Driver 'sr' needs updating - please use bus_type methods
 sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
padlock: VIA PadLock not detected.
padlock: VIA PadLock Hash Engine not detected.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
PM: Starting manual resume from disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
udevd version 125 started
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: AC Adapter [ADP0] (on-line)
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input3
ACPI: Lid Switch [LID]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
ACPI: Power Button (CM) [PWRB]
ACPI: Battery Slot [BAT0] (battery present)
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/device:02/input/input5
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
acpi device:0a: registered as cooling_device3
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:07/input/input6
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
iwl3945: Copyright(c) 2003-2008 Intel Corporation
iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwl3945 0000:05:00.0: setting latency timer to 64
iwl3945: Detected Intel Wireless WiFi Link 3945ABG
iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
phy0: Selected rate control algorithm 'iwl-3945-rs'
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
input: PC Speaker as /devices/platform/pcspkr/input/input7
iwl3945 0000:05:00.0: PCI INT A disabled
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ACPI: I/O resource 0000:00:1f.3 [0x18c0-0x18df] conflicts with ACPI region SMBI [0x18c0-0x18cf]
ACPI: Device needs an ACPI driver
intel_rng: FWH not detected
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: Unknown model for ALC861, trying auto-probe from BIOS...
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, hpet irqs
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04713/0x0
synaptics: Toshiba Satellite A100 detected, limiting rate to 40pps.
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input8
EXT3 FS on dm-1, internal journal
fuse init (API version 7.9)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1999024k swap on /dev/mapper/suspend.  Priority:-1 extents:1 across:1999024k
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
lp: driver loaded but no devices found
ppdev: user-space parallel port driver
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwl3945 0000:05:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
firmware: requesting iwlwifi-3945-1.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
NET: Registered protocol family 17
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (50 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
ACPI: Thermal Zone [TZ01] (52 C)
eth0: no IPv6 routers present
hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
ADDRCONF(NETDEV_UP): eth0: link is not ready
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
wlan0: authenticate with AP xx:xx:xx:xx:xx:xx
wlan0: authenticated
wlan0: associate with AP xx:xx:xx:xx:xx:xx
wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x401 status=0 aid=1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: deauthenticating by local choice (reason=3)
iwl3945 0000:05:00.0: PCI INT A disabled
iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwl3945 0000:05:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
eth0: no IPv6 routers present
CE: hpet increasing min_delta_ns to 15000 nsec
ACPI: Transitioning device [FAN0] to D0
ACPI: Unable to turn cooling device [f7413468] 'on'
irq 18: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.27.5-spurious99 #1
 [<c016d394>] __report_bad_irq+0x24/0x90
 [<c016d682>] note_interrupt+0x282/0x2c0
 [<c016c9c0>] handle_IRQ_event+0x30/0x60
 [<c016ddf3>] handle_fasteoi_irq+0xb3/0xe0
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c0104993>] common_interrupt+0x23/0x28
 [<f8849348>] acpi_idle_enter_simple+0x1ac/0x224 [processor]
 [<c02c0985>] menu_select+0x35/0xd0
 [<c02bf6f3>] cpuidle_idle_call+0x73/0xd0
 [<c0102dad>] cpu_idle+0x6d/0x140
 =======================
handlers:
[<f8890850>] (usb_hcd_irq+0x0/0x80 [usbcore])
Disabling IRQ #18
CE: hpet increasing min_delta_ns to 22500 nsec
=== >8 ===

Here's /proc/interrupts corresponding to the "mixed news" dmesg above:

=== 8< ===
           CPU0       CPU1
  0:   31893689          0   IO-APIC-edge      timer
  1:      17250          0   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc0
  9:      28326          0   IO-APIC-fasteoi   acpi
 12:     182580          0   IO-APIC-edge      i8042
 14:      51147          0   IO-APIC-edge      ata_piix
 15:     413249          0   IO-APIC-edge      ata_piix
 16:        601          0   IO-APIC-fasteoi   uhci_hcd:usb5, i915@pci:0000:00:02.0
 17:       1313          0   IO-APIC-fasteoi   firewire_ohci
 18:     100001          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 20:      98780          0   IO-APIC-fasteoi   eth0
 22:    3286956          0   IO-APIC-fasteoi   HDA Intel
 23:          0          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb2
220:    3480731          0   PCI-MSI-edge      iwl3945
NMI:          0          0   Non-maskable interrupts
LOC:    3055496   18246827   Local timer interrupts
RES:     594921    1047075   Rescheduling interrupts
CAL:       2117      30346   function call interrupts
TLB:      33213      50892   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0
=== >8 ===
