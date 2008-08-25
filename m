Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYHYMXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYHYMXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYHYMXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:23:30 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:58276 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbYHYMX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:23:27 -0400
Date: Mon, 25 Aug 2008 14:27:13 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080825122712.GA6963@boogie.lpds.sztaki.hu>
References: <20080430133824.GC18711@boogie.lpds.sztaki.hu> <20080430165131.7426d5d3@strauss.suse.de> <20080507114343.GB5583@boogie.lpds.sztaki.hu> <20080507144520.17e9902a@strauss.suse.de> <20080507134223.GB4278@boogie.lpds.sztaki.hu> <20080512142146.2a32793c@kopernikus.site> <20080513143917.GC17309@boogie.lpds.sztaki.hu> <20080615171140.GG22313@boogie.lpds.sztaki.hu> <20080725085206.GA6669@boogie.lpds.sztaki.hu> <20080725110438.463d0f04@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725110438.463d0f04@halley.suse.de>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 11:04:38AM +0200, Bernhard Walle wrote:

> Did you try that patch?
> 
> -------------- 8< ---------------------------------------------------
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Resolve http://bugzilla.kernel.org/show_bug.cgi?id=11051 and other bugs
> related to the way the HPET glue code in rtc-cmos was incomplete and
> inconsistent:
> 
>  * Switch the approach so that the basic driver code flow isn't
>    changed by having HPET ... instead, just have HPET shadow the
>    RTC_CONTROL irq enables and RTC_FREQ_SELECT data.  It's only
>    coping with IRQ thievery, after all.
> 
>  * Do that consistently (!!) to avoid problems when the HPET code
>    is out of sync with the real RTC intent.  Examples include:
> 
>    - cmos_procfs(), which now reports correct data
> 
>    - cmos_irq_set_state() ... also removing the previous PIE_{ON,OFF}
>      ioctl support so only one code path manages "periodic" IRQs
> 
>    - cmos_do_shutdown() ... currently a "just in case" change.
> 
>    - cmos_suspend() and cmos_resume() ... also handling a bug that
>      was specific to HPET's IRQ thievery, where the alarm wasn't
>      disabled after waking the system
> 
>  * Always call that HPET code under the RTC spinlock (it doesn't do
>    its own locking)
> -------------- >8 ---------------------------------------------------

Sorry for the delay. I thought I had this patch applied but I've now
verified: 2.6.26.3 + the above patch still hangs. dmesg below.

Gabor

Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] Initializing cgroup subsys cpuset 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] Linux version 2.6.26.3 (gombasg@boogie) (gcc version 4.3.1 (Debian 4.3.1-9) ) #18 SMP Mon Aug 25 11:17:25 CEST 2008 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] Command line: BOOT_IMAGE=l26263 ro root=900 video=intelfb:1280x1024-16@60 resume=/dev/sda2 selinux=1 audit=1 nmi_watchdog=2 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] BIOS-provided physical RAM map: 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf2ac000 (usable) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000cf2ac000 - 00000000cf2ef000 (ACPI NVS) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000cf2ef000 - 00000000cf3c7000 (reserved) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000cf3c7000 - 00000000cf3d7000 (ACPI NVS) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000cf3d7000 - 00000000cf453000 (reserved) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000cf453000 - 00000000cf459000 (ACPI data) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000cf459000 - 00000000cf45a000 (ACPI NVS) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000cf45a000 - 00000000cf45c000 (ACPI data) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000cf45c000 - 00000000cf45d000 (ACPI NVS) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000cf45d000 - 00000000cf45e000 (reserved) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000cf45e000 - 00000000cf463000 (ACPI NVS) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000cf463000 - 00000000cf472000 (reserved) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000cf472000 - 00000000cf600000 (usable) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000ffa00000 - 00000000ffc00000 (reserved) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] max_pfn_mapped = 1245184 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] init_memory_mapping 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] DMI 2.4 present. 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: RSDP 000F03C0, 0024 (r2  INTEL) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: XSDT CF45AF10, 0044 (r1  INTEL   DG31PR  6222004 MSFT    10013) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: FACP CF458D90, 00F4 (r4  INTEL   DG31PR  6222004 MSFT    10013) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: DSDT CF453010, 4D33 (r1  INTEL   DG31PR        0 INTL 20051117) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: FACS CF459F40, 0040 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: APIC CF458F10, 006C (r2  INTEL   DG31PR  6222004 MSFT    10013) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: HPET CF461D10, 0038 (r1  INTEL ICH7HPET  6222004 AMI.        1) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: MCFG CF461C10, 003C (r1 INTEL  DG31PR    6222004 MSFT       97) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]   early res: 0 [0-fff] BIOS data page 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]   early res: 2 [200000-7582fb] TEXT DATA BSS 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]   early res: 3 [9fc00-fffff] BIOS reserved 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]   early res: 4 [8000-dfff] PGTABLE 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] Zone PFN ranges: 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]   DMA             0 ->     4096 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]   DMA32        4096 ->  1048576 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]   Normal    1048576 ->  1245184 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] Movable zone start PFN for each node 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] early_node_map[4] active PFN ranges 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]     0:        0 ->      159 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]     0:      256 ->   848556 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]     0:   849010 ->   849408 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000]     0:  1048576 ->  1245184 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: PM-Timer IO Port: 0x408 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0]) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] IOAPIC[0]: apic_id 0, version 0, address 0xfec00000, GSI 0-23 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] Setting APIC routing to flat 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] Using ACPI (MADT) for SMP configuration information 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f71c000) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] PERCPU: Allocating 35632 bytes of per cpu data 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1026966 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] Kernel command line: BOOT_IMAGE=l26263 ro root=900 video=intelfb:1280x1024-16@60 resume=/dev/sda2 selinux=1 audit=1 nmi_watchdog=2 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] audit: enabled (after initialization) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] Initializing CPU#0 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] Extended CMOS year: 2000 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] TSC calibrated against PM_TIMER 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.000000] time.c: Detected 2199.952 MHz processor. 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.004000] Console: colour VGA+ 80x50 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.004000] console [tty0] enabled 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.004000] Checking aperture... 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.004000] Placing software IO TLB between 0x1640000 - 0x5640000 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.004000] Memory: 4033484k/4980736k available (2899k kernel code, 147652k reserved, 1629k data, 304k init) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.083913] Calibrating delay using timer specific routine.. 4403.44 BogoMIPS (lpj=8806888) 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.084005] Security Framework initialized 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.084005] SELinux:  Initializing. 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.084005] selinux_register_security:  Registering secondary module capability 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.084005] Capability LSM initialized as secondary 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.084005] Mount-cache hash table entries: 256 
Aug 25 12:39:00 boogie.lpds.sztaki.hu [    0.084005] Initializing cgroup subsys ns 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.084005] Initializing cgroup subsys cpuacct 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.084005] Initializing cgroup subsys devices 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.084005] CPU: L1 I cache: 32K, L1 D cache: 32K 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.084005] CPU: L2 cache: 1024K 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.084005] CPU: Physical Processor ID: 0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.084005] CPU: Processor Core ID: 0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.084005] CPU0: Thermal monitoring enabled (TM2) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.084005] using mwait in idle threads. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.084005] ACPI: Core revision 20080321 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.131246] CPU0: Intel(R) Pentium(R) Dual  CPU  E2200  @ 2.20GHz stepping 0d 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.131391] Using local APIC timer interrupts. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.136008] Detected 12.499 MHz APIC timer. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.136008] Booting processor 1/1 ip 6000 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.144009] Initializing CPU#1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.144009] Calibrating delay using timer specific routine.. 4399.89 BogoMIPS (lpj=8799795) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.144009] CPU: L1 I cache: 32K, L1 D cache: 32K 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.144009] CPU: L2 cache: 1024K 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.144009] CPU: Physical Processor ID: 0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.144009] CPU: Processor Core ID: 1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.144009] CPU1: Thermal monitoring enabled (TM2) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.144009] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.224014] CPU1: Intel(R) Pentium(R) Dual  CPU  E2200  @ 2.20GHz stepping 0d 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.224014] checking TSC synchronization [CPU#0 -> CPU#1]: passed. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.228014] Brought up 2 CPUs 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.228014] Total of 2 processors activated (8803.34 BogoMIPS). 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.228014] Testing NMI watchdog ... OK. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.308019] net_namespace: 1224 bytes 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.308019] Booting paravirtualized kernel on bare hardware 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.308019] xor: automatically using best checksumming function: generic_sse 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.324907]    generic_sse:  8048.000 MB/sec 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.325004] xor: using function: generic_sse (8048.000 MB/sec) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.325134] NET: Registered protocol family 16 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.328126] No dock devices found. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.328126] ACPI: bus type pci registered 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.328126] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 64 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.328126] PCI: Not using MMCONFIG. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.328126] PCI: Using configuration type 1 for base access 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.334292] ACPI: Interpreter enabled 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.334391] ACPI: (supports S0 S5) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.334528] ACPI: Using IOAPIC for interrupt routing 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.334676] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 64 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.336127] PCI: BIOS Bug: MCFG area at e0000000 is not reserved in ACPI motherboard resources 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.336127] PCI: Not using MMCONFIG. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.340127] ACPI: BIOS _OSI(Linux) query ignored 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.340127] ACPI: DMI System Vendor:          
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.340127] ACPI: DMI Product Name:          
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.340127] ACPI: DMI Product Version:          
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.340127] ACPI: DMI Board Name: DG31PR 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.340127] ACPI: DMI BIOS Vendor: Intel Corp. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.340127] ACPI: DMI BIOS Date: 02/27/2008 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.340127] ACPI: Please send DMI info above to linux-acpi@vger.kernel.org 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.340127] ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.344127] ACPI: PCI Root Bridge [PCI0] (0000:00) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.344687] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.344858] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.345411] PCI: Transparent bridge - 0000:00:1e.0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.352128] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.352128] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.352128] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.352128] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.352128] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.352128] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.352128] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.352660] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.356128] Linux Plug and Play Support v0.97 (c) Adam Belay 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.356128] pnp: PnP ACPI init 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.356128] ACPI: bus type pnp registered 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.360128] pnp: PnP ACPI: found 13 devices 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.360128] ACPI: ACPI bus type pnp unregistered 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.364129] SCSI subsystem initialized 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.364129] usbcore: registered new interface driver usbfs 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.364129] usbcore: registered new interface driver hub 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.364129] usbcore: registered new device driver usb 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.364129] PCI: Using ACPI for IRQ routing 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.378259] NetLabel: Initializing 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.378364] NetLabel:  domain hash size = 128 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.378470] NetLabel:  protocols = UNLABELED CIPSOv4 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.378578] NetLabel:  unlabeled traffic allowed by default 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.378691] PCI-GART: No AMD northbridge found. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.378790] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.378969] hpet0: 3 64-bit timers, 14318180 Hz 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.380101] ACPI: RTC can wake from S4 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.394417] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.394532] system 00:01: iomem range 0xe0000000-0xe3ffffff has been reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.394647] system 00:02: ioport range 0x400-0x47f has been reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.394749] system 00:02: ioport range 0x1180-0x119f has been reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.394852] system 00:02: ioport range 0x500-0x53f has been reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.394954] system 00:02: iomem range 0xfec00000-0xfecfffff has been reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.395057] system 00:02: iomem range 0xfee00000-0xfee0ffff has been reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.395161] system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.395331] system 00:02: iomem range 0xffb00000-0xffcfffff could not be reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.395501] system 00:02: iomem range 0xfc800000-0xfc800fff has been reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.395605] system 00:02: iomem range 0xfed20000-0xfed7ffff has been reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.395710] system 00:02: iomem range 0xffe00000-0xffffffff could not be reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.395883] system 00:03: ioport range 0x290-0x29f has been reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.395993] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339] PCI: Bridge: 0000:00:01.0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339]   IO window: disabled. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339]   MEM window: disabled. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339]   PREFETCH window: disabled. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339] PCI: Bridge: 0000:00:1c.0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339]   IO window: disabled. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339]   MEM window: disabled. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339]   PREFETCH window: disabled. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339] PCI: Bridge: 0000:00:1c.1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339]   IO window: e000-efff 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339]   MEM window: 0xff800000-0xff8fffff 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339]   PREFETCH window: disabled. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339] PCI: Bridge: 0000:00:1e.0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339]   IO window: d000-dfff 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339]   MEM window: 0xff700000-0xff7fffff 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339]   PREFETCH window: disabled. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.396339] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.398416] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.398629] NET: Registered protocol family 2 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.438674] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.439338] TCP established hash table entries: 262144 (order: 10, 4194304 bytes) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.442617] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.443231] TCP: Hash tables configured (established 262144 bind 65536) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.443335] TCP reno registered 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.451847] NET: Registered protocol family 1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.454659] audit: initializing netlink socket (enabled) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.454659] type=2000 audit(1219660733.448:1): initialized 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458677] VFS: Disk quotas dquot_6.5.1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458677] Dquot-cache hash table entries: 512 (order 0, 4096 bytes) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458685] msgmni has been set to 7879 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458685] async_tx: api initialized (sync-only) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458685] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458685] io scheduler noop registered 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458685] io scheduler anticipatory registered 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458685] io scheduler deadline registered 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458685] io scheduler cfq registered (default) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458685] assign_interrupt_mode Found MSI capability 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458685] assign_interrupt_mode Found MSI capability 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458685] assign_interrupt_mode Found MSI capability 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458740] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.458913] ACPI: Power Button (FF) [PWRF] 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.459099] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.459275] ACPI: Sleep Button (CM) [SLPB] 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.459429] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.459604] ACPI: Power Button (CM) [PWRB] 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.459998] ACPI: SSDT CF45EC10, 02CC (r1    AMI      IST        1 MSFT  3000001) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.466682] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3]) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.466682] ACPI: ACPI0007:00 is registered as cooling_device0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.466682] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3]) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.466682] ACPI: ACPI0007:01 is registered as cooling_device1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.524676] Linux agpgart interface v0.103 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.524788] agpgart: Detected an Intel G33 Chipset. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.525234] agpgart: Detected 7164K stolen memory. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.538296] agpgart: AGP aperture is 256M @ 0xd0000000 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.538328] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds). 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.538328] Hangcheck: Using get_cycles(). 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.538328] Driver 'sd' needs updating - please use bus_type methods 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.538328] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.538328] scsi0 : ata_piix 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.538328] scsi1 : ata_piix 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.539840] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf0f0 irq 14 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.539840] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf0f8 irq 15 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.696395] ata1.00: ATAPI: ASUS    DRW-1814BL, 1.13, max UDMA/66 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.712136] ata1.00: configured for UDMA/66 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.716236] scsi 0:0:0:0: CD-ROM            ASUS     DRW-1814BL       1.13 PQ: 0 ANSI: 5 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.718824] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.718824] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ] 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.718824] scsi2 : ata_piix 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.718824] scsi3 : ata_piix 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.718824] ata3: SATA max UDMA/133 cmd 0xf0e0 ctl 0xf0d0 bmdma 0xf0a0 irq 17 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.718824] ata4: SATA max UDMA/133 cmd 0xf0c0 ctl 0xf0b0 bmdma 0xf0a8 irq 17 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.879778] ata3.00: ATA-7: Maxtor 7L250S0, BACE1G10, max UDMA/133 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.879893] ata3.00: 488281250 sectors, multi 16: LBA48 NCQ (depth 0/32) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    0.897186] ata3.00: configured for UDMA/133 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.062433] ata4.00: ATA-7: Maxtor 7L250S0, BACE1G10, max UDMA/133 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.062547] ata4.00: 488281250 sectors, multi 16: LBA48 NCQ (depth 0/32) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.080914] ata4.00: configured for UDMA/133 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.080914] scsi 2:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   BACE PQ: 0 ANSI: 5 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.080914] sd 2:0:0:0: [sda] 488281250 512-byte hardware sectors (250000 MB) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.080914] sd 2:0:0:0: [sda] Write Protect is off 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.080914] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.080914] sd 2:0:0:0: [sda] 488281250 512-byte hardware sectors (250000 MB) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.080914] sd 2:0:0:0: [sda] Write Protect is off 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.080914] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.080914]  sda: sda1 sda2 sda3 < sda5 > 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.105310] sd 2:0:0:0: [sda] Attached SCSI disk 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.105310] scsi 3:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   BACE PQ: 0 ANSI: 5 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.105310] sd 3:0:0:0: [sdb] 488281250 512-byte hardware sectors (250000 MB) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.105310] sd 3:0:0:0: [sdb] Write Protect is off 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.105310] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.105310] sd 3:0:0:0: [sdb] 488281250 512-byte hardware sectors (250000 MB) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.105310] sd 3:0:0:0: [sdb] Write Protect is off 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.105310] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.105310]  sdb: sdb1 sdb2 sdb3 < sdb5 > 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.155832] sd 3:0:0:0: [sdb] Attached SCSI disk 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.155832] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.155832] ehci_hcd 0000:00:1d.7: EHCI Host Controller 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.155832] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.159828] ehci_hcd 0000:00:1d.7: debug port 1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.159828] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff984000 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.175838] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.181123] usb usb1: configuration #1 chosen from 1 choice 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.181123] hub 1-0:1.0: USB hub found 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.181123] hub 1-0:1.0: 8 ports detected 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.284327] USB Universal Host Controller Interface driver v3.0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.284327] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.284338] uhci_hcd 0000:00:1d.0: UHCI Host Controller 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.284880] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.284880] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.284880] usb usb2: configuration #1 chosen from 1 choice 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.284880] hub 2-0:1.0: USB hub found 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.284880] hub 2-0:1.0: 2 ports detected 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.389275] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.389275] uhci_hcd 0000:00:1d.1: UHCI Host Controller 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.389769] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.389769] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.389769] usb usb3: configuration #1 chosen from 1 choice 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.389769] hub 3-0:1.0: USB hub found 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.389769] hub 3-0:1.0: 2 ports detected 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.493275] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.493275] uhci_hcd 0000:00:1d.2: UHCI Host Controller 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.493768] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.493768] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.493768] usb usb4: configuration #1 chosen from 1 choice 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.493769] hub 4-0:1.0: USB hub found 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.493769] hub 4-0:1.0: 2 ports detected 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.601664] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.601664] uhci_hcd 0000:00:1d.3: UHCI Host Controller 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.602158] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.602158] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000f020 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.602158] usb usb5: configuration #1 chosen from 1 choice 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.602158] hub 5-0:1.0: USB hub found 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.602158] hub 5-0:1.0: 2 ports detected 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.706416] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.706416] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.706961] serio: i8042 KBD port at 0x60,0x64 irq 1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.706961] mice: PS/2 mouse device common for all mice 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.714176] usb 1-2: new high speed USB device using ehci_hcd and address 3 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.766932] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.766932] rtc0: alarms up to one year, y3k, hpet irqs 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.766932] i2c /dev entries driver 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.766932] md: raid0 personality registered for level 0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.766932] md: raid1 personality registered for level 1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.766932] md: raid10 personality registered for level 10 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.802813] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.838524] raid6: int64x1   2157 MB/s 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.854130] usb 1-2: configuration #1 chosen from 1 choice 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.854496] hub 1-2:1.0: USB hub found 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.854496] hub 1-2:1.0: 4 ports detected 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.906460] raid6: int64x2   2757 MB/s 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    1.974380] raid6: int64x4   2041 MB/s 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.042301] raid6: int64x8   1834 MB/s 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.110239] raid6: sse2x1    3480 MB/s 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.178166] raid6: sse2x2    3853 MB/s 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.198394] usb 2-1: new low speed USB device using uhci_hcd and address 2 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.246081] raid6: sse2x4    6664 MB/s 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.246177] raid6: using algorithm sse2x4 (6664 MB/s) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.246276] md: raid6 personality registered for level 6 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.246375] md: raid5 personality registered for level 5 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.246474] md: raid4 personality registered for level 4 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.246547] EDAC MC: Ver: 2.1.0 Aug 25 2008 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.246547] cpuidle: using governor ladder 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.246547] cpuidle: using governor menu 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.262475] Marking TSC unstable due to TSC halts in idle 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.350502] usb 2-1: configuration #1 chosen from 1 choice 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.525308] input: Logitech USB RECEIVER as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input4 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.552197] input: USB HID v1.11 Mouse [Logitech USB RECEIVER] on usb-0000:00:1d.0-1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.552199] usbcore: registered new interface driver usbhid 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.552199] usbhid: v2.6:USB HID core driver 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.552202] TCP cubic registered 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.552208] NET: Registered protocol family 10 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.552208] lo: Disabled Privacy Extensions 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.552208] NET: Registered protocol family 17 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.552233] registered taskstats version 1 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.552233] rtc_cmos 00:08: setting system clock to 2008-08-25 10:38:56 UTC (1219660736) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.552241] md: Autodetecting RAID arrays. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.593526] md: invalid raid superblock magic on sda5 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.593526] md: sda5 does not have a valid v0.90 superblock, not importing! 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642254] md: invalid raid superblock magic on sdb5 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642254] md: sdb5 does not have a valid v0.90 superblock, not importing! 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642254] md: Scanned 4 and added 2 devices. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642254] md: autorun ... 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642254] md: considering sdb1 ... 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642254] md:  adding sdb1 ... 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642254] md:  adding sda1 ... 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642254] md: created md0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642254] md: bind<sda1> 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642254] md: bind<sdb1> 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642254] md: running: <sdb1><sda1> 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642271] raid1: raid set md0 active with 2 out of 2 mirrors 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.642279] md: ... autorun DONE. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.663742] kjournald starting.  Commit interval 5 seconds 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.663742] EXT3-fs: mounted filesystem with ordered data mode. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.663742] VFS: Mounted root (ext3 filesystem) readonly. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    2.663742] Freeing unused kernel memory: 304k freed 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    3.320125] SELinux: policy loaded with handle_unknown=deny 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    3.320238] type=1403 audit(1219660737.190:2): policy loaded auid=4294967295 ses=4294967295 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    3.691438] type=1400 audit(1219660737.541:3): avc:  denied  { read write } for  pid=554 comm="hostname" name="console" dev=md0 ino=51240 scontext=system_u:system_r:hostname_t:s0 tcontext=user_u:object_r:device_t:s0 tclass=chr_file 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    3.691757] type=1300 audit(1219660737.541:3): arch=40000003 syscall=11 success=yes exit=0 a0=94be374 a1=94be328 a2=94be334 a3=2 items=0 ppid=552 pid=554 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 ses=4294967295 comm="hostname" exe="/bin/hostname" subj=system_u:system_r:hostname_t:s0 key=(null) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    3.728000] type=1400 audit(1219660737.581:4): avc:  denied  { read write } for  pid=557 comm="mountpoint" name="console" dev=md0 ino=51240 scontext=system_u:system_r:mount_t:s0 tcontext=user_u:object_r:device_t:s0 tclass=chr_file 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    3.728343] type=1300 audit(1219660737.581:4): arch=40000003 syscall=11 success=yes exit=0 a0=9e207a4 a1=9e20750 a2=9e20764 a3=2 items=0 ppid=555 pid=557 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 ses=4294967295 comm="mountpoint" exe="/bin/mountpoint" subj=system_u:system_r:mount_t:s0 key=(null) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    3.800311] type=1400 audit(1219660737.637:5): avc:  denied  { read write } for  pid=559 comm="restorecon" name="console" dev=md0 ino=51240 scontext=system_u:system_r:setfiles_t:s0 tcontext=user_u:object_r:device_t:s0 tclass=chr_file 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    3.800668] type=1300 audit(1219660737.637:5): arch=40000003 syscall=11 success=yes exit=0 a0=9e20704 a1=9e20740 a2=9e2074c a3=9e1a17d items=0 ppid=555 pid=559 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 ses=4294967295 comm="restorecon" exe="/sbin/setfiles" subj=system_u:system_r:setfiles_t:s0 key=(null) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.249189] type=1400 audit(1219660739.082:6): avc:  denied  { getattr } for  pid=868 comm="hdparm" path="/proc/mdstat" dev=proc ino=4026531950 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:proc_mdstat_t:s0 tclass=file 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.249189] type=1300 audit(1219660739.082:6): arch=40000003 syscall=195 success=yes exit=0 a0=86f96dc a1=ff80a78c a2=460d3ff4 a3=805b285 items=0 ppid=732 pid=868 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="hdparm" exe="/bin/dash" subj=system_u:system_r:udev_t:s0-s0:c0.c1023 key=(null) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.341381] FDC 0 is a post-1991 82077 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.358265] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.386231] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.386571] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.405485] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.414076] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.414233] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0460) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.414233] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.538234] 8139too Fast Ethernet driver 0.9.28 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.538234] ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 21 (level, low) -> IRQ 21 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.542232] eth0: RealTek RTL8139 at 0xffffc2000002e000, XX:XX:XX:XX:XX:XX, IRQ 21 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.542400] r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.542400] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.546076] eth1: RTL8168b/8111b at 0xffffc20000020000, XX:XX:XX:XX:XX:XX, XID 38500000 IRQ 380 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.560023] ACPI Exception (video-1600): AE_NOT_FOUND, Evaluating _DOD [20080321] 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.560023] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:17/input/input5 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.584021] Driver 'sr' needs updating - please use bus_type methods 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.592022] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.592022] Uniform CD-ROM driver Revision: 3.20 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.610877] __ratelimit: 6 messages suppressed 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.610877] type=1400 audit(1219660739.434:8): avc:  denied  { search } for  pid=1123 comm="mdadm" name="var" dev=md0 ino=26006 scontext=system_u:system_r:mdadm_t:s0-s0:c0.c1023 tcontext=system_u:object_r:file_t:s0 tclass=dir 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.618969] ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no) 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.626877] udev: renamed network interface eth0 to rtl 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.629906] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.631235] udev: renamed network interface eth1 to mobo 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.650877] sr 0:0:0:0: Attached scsi generic sg0 type 5 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.650877] sd 2:0:0:0: Attached scsi generic sg1 type 0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.650877] sd 3:0:0:0: Attached scsi generic sg2 type 0 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    5.661226] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS... 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.095630] Adding 2008116k swap on /dev/sda2.  Priority:-1 extents:1 across:2008116k 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.122192] Adding 2008116k swap on /dev/sdb2.  Priority:-2 extents:1 across:2008116k 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.380803] EXT3 FS on md0, internal journal 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.566565] w83627ehf: Found W83627DHG chip at 0x290 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.584647] coretemp coretemp.0: Using relative temperature scale! 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.584787] coretemp coretemp.1: Using relative temperature scale! 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.638497] netconsole: local port 4444 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.638497] netconsole: local IP 193.224.70.237 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.638497] netconsole: interface mobo 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.638497] netconsole: remote port 3333 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.638497] netconsole: remote IP XXX.XXX.XX.XXX 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.638497] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.638497] netconsole: device mobo not up yet, forcing it 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.638497] r8169: mobo: link down 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.638497] r8169: mobo: link down 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    6.638497] ADDRCONF(NETDEV_UP): mobo: link is not ready 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    7.231127] r8169: mobo: link up 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    7.231340] ADDRCONF(NETDEV_CHANGE): mobo: link becomes ready 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    7.251227] console [netcon0] enabled 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    7.381449] netconsole: network logging started 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    7.410873] md: md3 stopped. 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    7.469057] md: bind<sda5> 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    7.469068] md: bind<sdb5> 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    7.477047] raid1: raid set md3 active with 2 out of 2 mirrors 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    7.687420] device-mapper: uevent: version 1.0.3 
Aug 25 12:39:01 boogie.lpds.sztaki.hu [    7.687420] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [    9.958270] fuse init (API version 7.9) 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [   10.121198] kjournald starting.  Commit interval 5 seconds 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [   10.161215] EXT3 FS on dm-0, 
Aug 25 12:39:03 boogie.lpds.sztaki.hu internal journal 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [   10.161215] EXT3-fs: mounted filesystem with ordered data mode. 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [   10.221562] kjournald starting.  Commit interval 5 seconds 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [   10.229255] EXT3 FS on dm-1, 
Aug 25 12:39:03 boogie.lpds.sztaki.hu internal journal 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [   10.229255] EXT3-fs: mounted filesystem with ordered data mode. 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [   10.291432] kjournald starting.  Commit interval 5 seconds 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [   10.291461] EXT3 FS on dm-2, 
Aug 25 12:39:03 boogie.lpds.sztaki.hu internal journal 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [   10.291461] EXT3-fs: mounted filesystem with ordered data mode. 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [   10.357719] kjournald starting.  Commit interval 5 seconds 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [   10.357818] EXT3 FS on dm-3, 
Aug 25 12:39:03 boogie.lpds.sztaki.hu internal journal 
Aug 25 12:39:03 boogie.lpds.sztaki.hu [   10.357942] EXT3-fs: mounted filesystem with ordered data mode. 
Aug 25 12:39:04 boogie.lpds.sztaki.hu [   11.306340] __ratelimit: 99 messages suppressed 
Aug 25 12:39:04 boogie.lpds.sztaki.hu [   11.306340] type=1400 audit(1219660744.483:25): avc:  denied  { getattr } for  pid=1238 comm="alsa-utils" path="/var/lib/alsa/asound.state" dev=dm-1 ino=655366 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:var_lib_t:s0 tclass=file 
Aug 25 12:39:06 boogie.lpds.sztaki.hu [   13.236194] ip_tables: (C) 2000-2006 Netfilter Core Team 
Aug 25 12:39:06 boogie.lpds.sztaki.hu [   13.394169] nf_conntrack version 0.5.0 (16384 buckets, 65536 max) 
Aug 25 12:39:07 boogie.lpds.sztaki.hu [   14.265765] rtl: link down 
Aug 25 12:39:07 boogie.lpds.sztaki.hu [   14.266033] ADDRCONF(NETDEV_UP): rtl: link is not ready 
Aug 25 12:39:08 boogie.lpds.sztaki.hu [   15.061174] ttyS1: LSR safety check engaged! 
Aug 25 12:39:08 boogie.lpds.sztaki.hu [   15.061203] ttyS1: LSR safety check engaged! 
Aug 25 12:39:10 boogie.lpds.sztaki.hu [   17.917167] firmware: requesting intel-ucode/06-0f-0d 
Aug 25 12:39:10 boogie.lpds.sztaki.hu [   17.973386] firmware: requesting intel-ucode/06-0f-0d 
Aug 25 12:39:10 boogie.lpds.sztaki.hu [   17.997024] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk> 
Aug 25 12:39:11 boogie.lpds.sztaki.hu [   18.065575] microcode: CPU0 updated from revision 0xa1 to 0xa3, date = 08132007  
Aug 25 12:39:11 boogie.lpds.sztaki.hu [   18.069486] microcode: CPU1 updated from revision 0xa1 to 0xa3, date = 08132007  
Aug 25 12:39:31 boogie.lpds.sztaki.hu [   39.100880] RPC: Registered udp transport module. 
Aug 25 12:39:31 boogie.lpds.sztaki.hu [   39.101017] RPC: Registered tcp transport module. 
Aug 25 12:39:31 boogie.lpds.sztaki.hu [   39.403834] Installing knfsd (copyright (C) 1996 okir@monad.swb.de). 
Aug 25 12:39:31 boogie.lpds.sztaki.hu [   39.533517] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory 
Aug 25 12:39:31 boogie.lpds.sztaki.hu [   39.537707] NFSD: starting 90-second grace period 
Aug 25 12:39:38 boogie.lpds.sztaki.hu [   47.400120] device mobo entered promiscuous mode 
Aug 25 12:39:38 boogie.lpds.sztaki.hu [   47.412247] device mobo left promiscuous mode 
Aug 25 12:39:38 boogie.lpds.sztaki.hu [   47.424122] device mobo entered promiscuous mode 
Aug 25 12:39:47 boogie.lpds.sztaki.hu [   55.759765] ttyS1: LSR safety check engaged! 
Aug 25 12:39:47 boogie.lpds.sztaki.hu [   56.355965] Bluetooth: Core ver 2.11 
Aug 25 12:39:47 boogie.lpds.sztaki.hu [   56.355965] NET: Registered protocol family 31 
Aug 25 12:39:47 boogie.lpds.sztaki.hu [   56.355965] Bluetooth: HCI device and connection manager initialized 
Aug 25 12:39:47 boogie.lpds.sztaki.hu [   56.355965] Bluetooth: HCI socket layer initialized 
Aug 25 12:39:47 boogie.lpds.sztaki.hu [   56.460880] Bluetooth: L2CAP ver 2.9 
Aug 25 12:39:47 boogie.lpds.sztaki.hu [   56.460880] Bluetooth: L2CAP socket layer initialized 
Aug 25 12:39:47 boogie.lpds.sztaki.hu [   56.484836] Bluetooth: RFCOMM socket layer initialized 
Aug 25 12:39:47 boogie.lpds.sztaki.hu [   56.484854] Bluetooth: RFCOMM TTY layer initialized 
Aug 25 12:39:47 boogie.lpds.sztaki.hu [   56.484963] Bluetooth: RFCOMM ver 1.8 
Aug 25 12:39:52 boogie.lpds.sztaki.hu [   61.290703] [drm] Initialized drm 1.1.0 20060810 
Aug 25 12:39:52 boogie.lpds.sztaki.hu [   61.335183] ACPI: PCI Interrupt 0000:00:02.0[A] -> 
Aug 25 12:39:52 boogie.lpds.sztaki.hu GSI 16 (level, low) -> IRQ 16 
Aug 25 12:39:52 boogie.lpds.sztaki.hu [   61.335183] [drm] Initialized i915 1.6.0 20060119 on minor 0 
Aug 25 12:39:53 boogie.lpds.sztaki.hu [   61.762045] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining 
Aug 25 12:51:20 boogie.lpds.sztaki.hu [  766.839697] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining 
Aug 25 13:05:33 boogie.lpds.sztaki.hu [ 1620.458335] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining 
Aug 25 13:09:00 boogie.lpds.sztaki.hu [ 1830.763249] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] NMI Watchdog detected LOCKUP on CPU 0 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] CPU 0 
Aug 25 13:33:56 boogie.lpds.sztaki.hu  
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] Modules linked in:
Aug 25 13:33:56 boogie.lpds.sztaki.hu i915
Aug 25 13:33:56 boogie.lpds.sztaki.hu drm
Aug 25 13:33:56 boogie.lpds.sztaki.hu rfcomm
Aug 25 13:33:56 boogie.lpds.sztaki.hu l2cap
Aug 25 13:33:56 boogie.lpds.sztaki.hu bluetooth
Aug 25 13:33:56 boogie.lpds.sztaki.hu nfsd
Aug 25 13:33:56 boogie.lpds.sztaki.hu lockd
Aug 25 13:33:56 boogie.lpds.sztaki.hu nfs_acl
Aug 25 13:33:56 boogie.lpds.sztaki.hu auth_rpcgss
Aug 25 13:33:56 boogie.lpds.sztaki.hu sunrpc
Aug 25 13:33:56 boogie.lpds.sztaki.hu exportfs
Aug 25 13:33:56 boogie.lpds.sztaki.hu microcode
Aug 25 13:33:56 boogie.lpds.sztaki.hu ipt_REJECT
Aug 25 13:33:56 boogie.lpds.sztaki.hu nf_conntrack_ipv4
Aug 25 13:33:56 boogie.lpds.sztaki.hu xt_state
Aug 25 13:33:56 boogie.lpds.sztaki.hu nf_conntrack
Aug 25 13:33:56 boogie.lpds.sztaki.hu xt_tcpudp
Aug 25 13:33:56 boogie.lpds.sztaki.hu ipt_LOG
Aug 25 13:33:56 boogie.lpds.sztaki.hu xt_limit
Aug 25 13:33:56 boogie.lpds.sztaki.hu iptable_filter
Aug 25 13:33:56 boogie.lpds.sztaki.hu ip_tables
Aug 25 13:33:56 boogie.lpds.sztaki.hu x_tables
Aug 25 13:33:56 boogie.lpds.sztaki.hu fuse
Aug 25 13:33:56 boogie.lpds.sztaki.hu dm_crypt
Aug 25 13:33:56 boogie.lpds.sztaki.hu crypto_blkcipher
Aug 25 13:33:56 boogie.lpds.sztaki.hu dm_mod
Aug 25 13:33:56 boogie.lpds.sztaki.hu netconsole
Aug 25 13:33:56 boogie.lpds.sztaki.hu configfs
Aug 25 13:33:56 boogie.lpds.sztaki.hu coretemp
Aug 25 13:33:56 boogie.lpds.sztaki.hu w83627ehf
Aug 25 13:33:56 boogie.lpds.sztaki.hu hwmon_vid
Aug 25 13:33:56 boogie.lpds.sztaki.hu sg
Aug 25 13:33:56 boogie.lpds.sztaki.hu snd_hda_intel
Aug 25 13:33:56 boogie.lpds.sztaki.hu snd_pcm
Aug 25 13:33:56 boogie.lpds.sztaki.hu sr_mod
Aug 25 13:33:56 boogie.lpds.sztaki.hu video
Aug 25 13:33:56 boogie.lpds.sztaki.hu snd_timer
Aug 25 13:33:56 boogie.lpds.sztaki.hu r8169
Aug 25 13:33:56 boogie.lpds.sztaki.hu 8139too
Aug 25 13:33:56 boogie.lpds.sztaki.hu cdrom
Aug 25 13:33:56 boogie.lpds.sztaki.hu iTCO_wdt
Aug 25 13:33:56 boogie.lpds.sztaki.hu 8250_pnp
Aug 25 13:33:56 boogie.lpds.sztaki.hu 8250
Aug 25 13:33:56 boogie.lpds.sztaki.hu serial_core
Aug 25 13:33:56 boogie.lpds.sztaki.hu i2c_i801
Aug 25 13:33:56 boogie.lpds.sztaki.hu snd
Aug 25 13:33:56 boogie.lpds.sztaki.hu floppy
Aug 25 13:33:56 boogie.lpds.sztaki.hu snd_page_alloc
Aug 25 13:33:56 boogie.lpds.sztaki.hu  
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] Pid: 0, comm: swapper Not tainted 2.6.26.3 #18 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] RIP: 0010:[<ffffffff804d1fd5>] 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [<ffffffff804d1fd5>] _spin_lock+0xe/0x1a 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] RSP: 0018:ffffffff80685e08  EFLAGS: 00000297 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] RAX: 0000000000004b4a RBX: ffff81012fceb00c RCX: ffff81012fceb000 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] RDX: 0000000000000000 RSI: ffff81012fceb00c RDI: ffffffff807154e0 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] RBP: ffffffff80685e08 R08: 0000000000000000 R09: 000000000002149c 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] R10: ffff81012ca7ba40 R11: ffff81012ca7bbe8 R12: 0000000000000005 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] R13: 0000000000c86e1d R14: ffff81012fceb530 R15: ffff81012fceb000 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] FS:  0000000000000000(0000) GS:ffffffff8066d000(0000) knlGS:0000000000000000 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b 
Aug 25 13:33:56 boogie.lpds.sztaki.hu [ 3380.740565] CR2: 00000000f7f2a000 CR3: 0000000000201000 CR4: 00000000000006e0 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] NMI Watchdog detected LOCKUP on CPU 1 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] CPU 1 
Aug 25 13:34:01 boogie.lpds.sztaki.hu  
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] Modules linked in:
Aug 25 13:34:01 boogie.lpds.sztaki.hu i915
Aug 25 13:34:01 boogie.lpds.sztaki.hu drm
Aug 25 13:34:01 boogie.lpds.sztaki.hu rfcomm
Aug 25 13:34:01 boogie.lpds.sztaki.hu l2cap
Aug 25 13:34:01 boogie.lpds.sztaki.hu bluetooth
Aug 25 13:34:01 boogie.lpds.sztaki.hu nfsd
Aug 25 13:34:01 boogie.lpds.sztaki.hu lockd
Aug 25 13:34:01 boogie.lpds.sztaki.hu nfs_acl
Aug 25 13:34:01 boogie.lpds.sztaki.hu auth_rpcgss
Aug 25 13:34:01 boogie.lpds.sztaki.hu sunrpc
Aug 25 13:34:01 boogie.lpds.sztaki.hu exportfs
Aug 25 13:34:01 boogie.lpds.sztaki.hu microcode
Aug 25 13:34:01 boogie.lpds.sztaki.hu ipt_REJECT
Aug 25 13:34:01 boogie.lpds.sztaki.hu nf_conntrack_ipv4
Aug 25 13:34:01 boogie.lpds.sztaki.hu xt_state
Aug 25 13:34:01 boogie.lpds.sztaki.hu nf_conntrack
Aug 25 13:34:01 boogie.lpds.sztaki.hu xt_tcpudp
Aug 25 13:34:01 boogie.lpds.sztaki.hu ipt_LOG
Aug 25 13:34:01 boogie.lpds.sztaki.hu xt_limit
Aug 25 13:34:01 boogie.lpds.sztaki.hu iptable_filter
Aug 25 13:34:01 boogie.lpds.sztaki.hu ip_tables
Aug 25 13:34:01 boogie.lpds.sztaki.hu x_tables
Aug 25 13:34:01 boogie.lpds.sztaki.hu fuse
Aug 25 13:34:01 boogie.lpds.sztaki.hu dm_crypt
Aug 25 13:34:01 boogie.lpds.sztaki.hu crypto_blkcipher
Aug 25 13:34:01 boogie.lpds.sztaki.hu dm_mod
Aug 25 13:34:01 boogie.lpds.sztaki.hu netconsole
Aug 25 13:34:01 boogie.lpds.sztaki.hu configfs
Aug 25 13:34:01 boogie.lpds.sztaki.hu coretemp
Aug 25 13:34:01 boogie.lpds.sztaki.hu w83627ehf
Aug 25 13:34:01 boogie.lpds.sztaki.hu hwmon_vid
Aug 25 13:34:01 boogie.lpds.sztaki.hu sg
Aug 25 13:34:01 boogie.lpds.sztaki.hu snd_hda_intel
Aug 25 13:34:01 boogie.lpds.sztaki.hu snd_pcm
Aug 25 13:34:01 boogie.lpds.sztaki.hu sr_mod
Aug 25 13:34:01 boogie.lpds.sztaki.hu video
Aug 25 13:34:01 boogie.lpds.sztaki.hu snd_timer
Aug 25 13:34:01 boogie.lpds.sztaki.hu r8169
Aug 25 13:34:01 boogie.lpds.sztaki.hu 8139too
Aug 25 13:34:01 boogie.lpds.sztaki.hu cdrom
Aug 25 13:34:01 boogie.lpds.sztaki.hu iTCO_wdt
Aug 25 13:34:01 boogie.lpds.sztaki.hu 8250_pnp
Aug 25 13:34:01 boogie.lpds.sztaki.hu 8250
Aug 25 13:34:01 boogie.lpds.sztaki.hu serial_core
Aug 25 13:34:01 boogie.lpds.sztaki.hu i2c_i801
Aug 25 13:34:01 boogie.lpds.sztaki.hu snd
Aug 25 13:34:01 boogie.lpds.sztaki.hu floppy
Aug 25 13:34:01 boogie.lpds.sztaki.hu snd_page_alloc
Aug 25 13:34:01 boogie.lpds.sztaki.hu  
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] Pid: 0, comm: swapper Not tainted 2.6.26.3 #18 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] RIP: 0010:[<ffffffff8021cc9f>] 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [<ffffffff8021cc9f>] hpet_rtc_interrupt+0x120/0x2f3 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] RSP: 0018:ffff81012fc97eb8  EFLAGS: 00000097 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] RDX: 00000000fde664e5 RSI: 0000000000000002 RDI: 0000000000000002 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] RBP: ffff81012fc97f18 R08: ffffffffff5fc128 R09: 0000000000000000 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] R10: ffff81000100bbd0 R11: 0100000000000292 R12: 00000000000000a6 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] R13: 00000001000b6f07 R14: ffff81012f140c00 R15: 0000000000000005 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] FS:  0000000000000000(0000) GS:ffff81012fc06580(0000) knlGS:0000000000000000 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] CR2: 00000000f7f58000 CR3: 0000000000201000 CR4: 00000000000006e0 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087]  [<ffffffff8020e6d0>] do_IRQ+0xf7/0x169 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087]  [<ffffffff8036e46f>] ? acpi_hw_low_level_read+0x36/0x60 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087]  [<ffffffff80248f7b>] ? notifier_call_chain+0x33/0x5b 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087]  [<ffffffff80249037>] ? raw_notifier_call_chain+0xf/0x11 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087]  [<ffffffff8024cdb4>] ? clockevents_notify+0x2b/0x74 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087]  [<ffffffff804222b2>] ? menu_select+0x6f/0x8f 
Aug 25 13:34:01 boogie.lpds.sztaki.hu [ 3380.743087]  [<ffffffff8042123d>] ? cpuidle_idle_call+0x8d/0xc1 

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
