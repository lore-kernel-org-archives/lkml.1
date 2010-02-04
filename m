Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab0BDKWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 05:22:33 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:54148 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab0BDKW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 05:22:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lMlecbQxDSNEAikob1hD40Y2qpztFs/1Pzcv4ubwKUtJeYVjZJhbnG9LZBz+SkEn2m
         AzoZorUpGifKOHPIKxx8XJoyjWvfqvBVGrTOWfKgdk6WlUU1BYuSCTOhn24U+7TV/1N6
         /UQLeAGayggLjyLUv99+fJ4lGMWoN64QJNN1w=
Message-ID: <4B6A9FD7.5040207@tuffmail.co.uk>
Date: Thu, 04 Feb 2010 10:22:15 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: serio - re-add thaw (and add freeze)
References: <4B69C7AA.7000904@tuffmail.co.uk> <20100203191112.GC30600@core.coreip.homeip.net>
In-Reply-To: <20100203191112.GC30600@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Wed, Feb 03, 2010 at 06:59:54PM +0000, Alan Jenkins wrote:
>   
>> 633aae2 "Input: i8042 - switch to using dev_pm_ops"
>> removed handling for PMSG_THAW, causing obscure breakage.
>>
>> It can break if you press keys during hibernation,
>> which causes subsequent keypresses to be lost -
>> so you can't cancel s2disk by pressing backspace -
>> and then just before system poweroff you get
>> "psmouse.c: Failed to deactivate mouse".
>>
>> So let's add the thaw handler back.
>>
>> Also set the freeze handler.  It looks like PMSG_FREEZE
>> didn't do anything in the past, but I think that must
>> have been an oversight.
>>     
>
> We do not need to do anything special at freeze time that is why there
> wasn't freeze handler. And so thaw should be pretty much noop as well.
>   

I don't understand the driver; I'm just mindlessly reverting the change 
that caused the regression on my specific machine.  My guess is the 
problem happens when input events occur while interrupts are disabled to 
make the atomic snapshot.

I could be wrong about whether a freeze is appropriate.  I added it 
since I didn't know whether it would be safe to add the thaw without the 
freeze.  If you can patch the problem then I'm happy to leave that 
question up to you :).

> What supports canceling s2disk by backspace?

If you want to test this yourself, you might find it easier to use 
pm_test (as in Documentation/power/basic_pm_debugging.txt) to run a 
freeze-thaw cycle without powering off.

In order to reproduce this reliably, I have to press keys quite quickly 
while the kernel is hibernating.  E.g. hammering the Enter key does it.


I'm actually using s2disk(8) from the "uswsusp" package, but that 
requires a bit of setup.

You may need to create /etc/suspend.conf in order to test with it.  (The 
debian package provides semi-automatic configuration, and renames the 
config file to "uswsusp.conf").  It is installed by default in debian 
unstable.  If you use pm-hibernate, note that it will probably switch to 
using s2disk, assuming you install it in the standard location (and not 
/usr/local).

In general I wouldn't recommend installing it from source, because you 
need to add a "resume" program to the initramfs.  That said, you don't 
need to resume in order to test this specific problem, so long as you 
don't mind an unclean shutdown.

>  I need more data to figure
> out what is going on. At the moment input should be fully-functional
> until poweroff.
>   

Sure.  I can reproduce this very easily on my machine; just let me know 
what data would help.

I've hacked s2disk to abort automatically before image writeout 
(effectively doing pm_test in userspace).  Here is a full dmesg, showing 
a freeze-thaw cycle after enabling i8042.debug using sysfs.  I'm 
pressing Enter throughout the test, and the keyboard dies as a result.  
When I shut down (using acpid and the power button), I get the same 
message "psmouse.c: Failed to deactivate mouse".

Note that I continued to press the Enter key after the free-thaw cycle, 
but no further i8042 debug messages appeared.

Regards
Alan


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.33-rc6eeepc (alan@alan-desktop) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #42 SMP Tue Feb 2 16:31:19 GMT 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001f780000 (usable)
[    0.000000]  BIOS-e820: 000000001f780000 - 000000001f790000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001f790000 - 000000001f7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001f7d0000 - 000000001f7de000 (reserved)
[    0.000000]  BIOS-e820: 000000001f7e0000 - 000000001f800000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x1f780 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FE0000000 write-back
[    0.000000]   1 base 01F800000 mask FFF800000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-000000001f780000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 001f400000 page 2M
[    0.000000]  001f400000 - 001f780000 page 4k
[    0.000000] kernel direct mapping tables up to 1f780000 @ 15000-1b000
[    0.000000] RAMDISK: 17710000 - 179df4ed
[    0.000000] ACPI: RSDP 000fbe50 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 1f780000 00034 (v01 A M I  OEMRSDT  03000911 MSFT 00000097)
[    0.000000] ACPI: FACP 1f780200 00081 (v01 A M I  OEMFACP  03000911 MSFT 00000097)
[    0.000000] ACPI: DSDT 1f780400 06069 (v01  A0797 A0797000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 1f790000 00040
[    0.000000] ACPI: APIC 1f780390 00068 (v01 A M I  OEMAPIC  03000911 MSFT 00000097)
[    0.000000] ACPI: OEMB 1f790040 00046 (v01 A M I  AMI_OEM  03000911 MSFT 00000097)
[    0.000000] ACPI: MCFG 1f786470 0003C (v01 A M I  OEMMCFG  03000911 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 503MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1f780000
[    0.000000]   low ram: 0 - 1f780000
[    0.000000]   node 0 low ram: 00000000 - 1f780000
[    0.000000]   node 0 bootmap 00017000 - 0001aef0
[    0.000000] (14 early reservations) ==> bootmem [0000000000 - 001f780000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0001000000 - 00014aa244]    TEXT DATA BSS ==> [0001000000 - 00014aa244]
[    0.000000]   #3 [0017710000 - 00179df4ed]          RAMDISK ==> [0017710000 - 00179df4ed]
[    0.000000]   #4 [00014ab000 - 00014b11f4]              BRK ==> [00014ab000 - 00014b11f4]
[    0.000000]   #5 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
[    0.000000]   #6 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
[    0.000000]   #7 [000009fc00 - 00000f0ee0]    BIOS reserved ==> [000009fc00 - 00000f0ee0]
[    0.000000]   #8 [00000f1028 - 00000ff780]    BIOS reserved ==> [00000f1028 - 00000ff780]
[    0.000000]   #9 [00000f0ee0 - 00000f1028]     MP-table mpc ==> [00000f0ee0 - 00000f1028]
[    0.000000]   #10 [0000010000 - 0000011000]       TRAMPOLINE ==> [0000010000 - 0000011000]
[    0.000000]   #11 [0000011000 - 0000015000]      ACPI WAKEUP ==> [0000011000 - 0000015000]
[    0.000000]   #12 [0000015000 - 0000017000]          PGTABLE ==> [0000015000 - 0000017000]
[    0.000000]   #13 [0000017000 - 000001b000]          BOOTMAP ==> [0000017000 - 000001b000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001f780
[    0.000000]   HighMem  0x0001f780 -> 0x0001f780
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001f780
[    0.000000] On node 0 totalpages: 128783
[    0.000000] free_area_init_node: node 0, pgdat c139d3c0, node_mem_map c14b3200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 975 pages used for memmap
[    0.000000]   Normal zone: 123825 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 1f800000 (gap: 1f800000:df600000)
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @c1c00000 s31000 r0 d22248 u4194304
[    0.000000] pcpu-alloc: s31000 r0 d22248 u4194304 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 127776
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.33-rc6eeepc root=/dev/sda2 ro rootfstype=ext4 no_console_suspend i915.modeset=1 resume=/dev/sda2 resume_offset=188416
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 502560k/515584k available (2389k kernel code, 12216k reserved, 1352k data, 344k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd57000 - 0xfffff000   (2720 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xdff80000 - 0xff3fe000   ( 500 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xdf780000   ( 503 MB)
[    0.000000]       .init : 0xc13a8000 - 0xc13fe000   ( 344 kB)
[    0.000000]       .data : 0xc1255553 - 0xc13a776c   (1352 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1255553   (2389 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:1280
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 630.168 MHz processor.
[    0.008013] Calibrating delay loop (skipped), value calculated using timer frequency.. 1260.33 BogoMIPS (lpj=2520672)
[    0.008306] Security Framework initialized
[    0.008411] SELinux:  Disabled at boot.
[    0.008536] Mount-cache hash table entries: 512
[    0.008973] Initializing cgroup subsys ns
[    0.009071] Initializing cgroup subsys cpuacct
[    0.009171] Initializing cgroup subsys devices
[    0.009267] Initializing cgroup subsys freezer
[    0.009362] Initializing cgroup subsys net_cls
[    0.009529] mce: CPU supports 5 MCE banks
[    0.009638] CPU0: Thermal monitoring enabled (TM1)
[    0.009756] Performance Events: p6 PMU driver.
[    0.009919] ... version:                0
[    0.010011] ... bit width:              32
[    0.010105] ... generic registers:      2
[    0.010197] ... value mask:             00000000ffffffff
[    0.010294] ... max period:             000000007fffffff
[    0.010392] ... fixed-purpose events:   0
[    0.010483] ... event mask:             0000000000000003
[    0.010587] Checking 'hlt' instruction... OK.
[    0.024820] SMP alternatives: switching to UP code
[    0.030731] Freeing SMP alternatives: 11k freed
[    0.030836] ACPI: Core revision 20091214
[    0.056698] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.097199] CPU0: Intel(R) Celeron(R) M processor          900MHz stepping 08
[    0.100000] Brought up 1 CPUs
[    0.100000] Total of 1 processors activated (1260.33 BogoMIPS).
[    0.100000] NET: Registered protocol family 16
[    0.100000] ACPI: bus type pci registered
[    0.100000] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.100000] PCI: not using MMCONFIG
[    0.100000] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.100000] PCI: Using configuration type 1 for base access
[    0.101033] bio: create slab <bio-0> at 0
[    0.105589] ACPI: EC: Look up EC in DSDT
[    0.110741] ACPI: Executed 1 blocks of module-level executable AML code
[    0.133255] ACPI: Interpreter enabled
[    0.133383] ACPI: (supports S0 S3 S4 S5)
[    0.133722] ACPI: Using IOAPIC for interrupt routing
[    0.133980] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.141725] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.141871] PCI: Using MMCONFIG for extended config space
[    0.160521] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.161347] ACPI: No dock devices found.
[    0.161945] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.162132] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.163160] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.163170] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.163180] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.163190] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.163199] pci_root PNP0A08:00: host bridge window [mem 0x1f810000-0xffffffff] (ignored)
[    0.163337] pci 0000:00:02.0: reg 10: [mem 0xf7f00000-0xf7f7ffff]
[    0.163351] pci 0000:00:02.0: reg 14: [io  0xec00-0xec07]
[    0.163364] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
[    0.163378] pci 0000:00:02.0: reg 1c: [mem 0xf7ec0000-0xf7efffff]
[    0.163446] pci 0000:00:02.1: reg 10: [mem 0xf7f80000-0xf7ffffff]
[    0.163586] pci 0000:00:1b.0: reg 10: [mem 0xf7eb8000-0xf7ebbfff 64bit]
[    0.163657] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.163667] pci 0000:00:1b.0: PME# disabled
[    0.163779] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.163788] pci 0000:00:1c.0: PME# disabled
[    0.163901] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.163911] pci 0000:00:1c.1: PME# disabled
[    0.164044] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.164054] pci 0000:00:1c.2: PME# disabled
[    0.164135] pci 0000:00:1d.0: reg 20: [io  0xe400-0xe41f]
[    0.164219] pci 0000:00:1d.1: reg 20: [io  0xe480-0xe49f]
[    0.164299] pci 0000:00:1d.2: reg 20: [io  0xe800-0xe81f]
[    0.164380] pci 0000:00:1d.3: reg 20: [io  0xe880-0xe89f]
[    0.164458] pci 0000:00:1d.7: reg 10: [mem 0xf7eb7c00-0xf7eb7fff]
[    0.164536] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.164547] pci 0000:00:1d.7: PME# disabled
[    0.164723] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.164740] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.164884] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
[    0.164993] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 0380-03ff
[    0.165142] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
[    0.165156] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
[    0.165170] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
[    0.165184] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
[    0.165197] pci 0000:00:1f.2: reg 20: [io  0xffa0-0xffaf]
[    0.165239] pci 0000:00:1f.2: PME# supported from D3hot
[    0.165249] pci 0000:00:1f.2: PME# disabled
[    0.165318] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.165420] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.165596] pci 0000:03:00.0: reg 10: [mem 0xfbfc0000-0xfbffffff 64bit]
[    0.165646] pci 0000:03:00.0: reg 30: [mem 0xfbfa0000-0xfbfbffff pref]
[    0.165701] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.165712] pci 0000:03:00.0: PME# disabled
[    0.165786] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.165891] pci 0000:00:1c.1:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.165968] pci 0000:01:00.0: reg 10: [mem 0xfbef0000-0xfbefffff 64bit]
[    0.166136] pci 0000:00:1c.2: PCI bridge to [bus 01-02]
[    0.166241] pci 0000:00:1c.2:   bridge window [mem 0xf8000000-0xfbefffff]
[    0.166256] pci 0000:00:1c.2:   bridge window [mem 0xf0000000-0xf6ffffff 64bit pref]
[    0.166334] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.166479] pci_bus 0000:00: on NUMA node 0
[    0.166500] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.167023] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.167204] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.167364] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.187118] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.188164] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.189166] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.190161] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.191155] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.192294] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.196362] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.197477] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.200639] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.200797] vgaarb: loaded
[    0.201202] SCSI subsystem initialized
[    0.201448] libata version 3.00 loaded.
[    0.201618] PCI: Using ACPI for IRQ routing
[    0.201778] PCI: pci_cache_line_size set to 64 bytes
[    0.202504] hpet clockevent registered
[    0.202518] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.202631] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.202911] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.208023] Switching to clocksource tsc
[    0.212121] pnp: PnP ACPI init
[    0.212262] ACPI: bus type pnp registered
[    0.218630] pnp: PnP ACPI: found 13 devices
[    0.218727] ACPI: ACPI bus type pnp unregistered
[    0.218827] PnPBIOS: Disabled by ACPI PNP
[    0.218953] system 00:01: [mem 0xfed13000-0xfed19fff] has been reserved
[    0.219076] system 00:08: [io  0x0380-0x0383] has been reserved
[    0.219179] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.219283] system 00:08: [io  0x0800-0x087f] has been reserved
[    0.219386] system 00:08: [io  0x0480-0x04bf] has been reserved
[    0.219490] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.219607] system 00:08: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.219714] system 00:08: [mem 0xfff00000-0xffffffff] could not be reserved
[    0.219855] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.219964] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.220078] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.220190] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    0.220305] system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.220413] system 00:0c: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.220521] system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.220630] system 00:0c: [mem 0x00100000-0x1f7fffff] could not be reserved
[    0.255715] pci 0000:00:1c.0: BAR 14: assigned [mem 0x20000000-0x201fffff]
[    0.255857] pci 0000:00:1c.0: BAR 15: assigned [mem 0x20200000-0x203fffff 64bit pref]
[    0.255999] pci 0000:00:1c.1: BAR 15: assigned [mem 0x20400000-0x205fffff 64bit pref]
[    0.256140] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.256245] pci 0000:00:1c.1: BAR 13: assigned [io  0x2000-0x2fff]
[    0.256350] pci 0000:00:1c.2: BAR 13: assigned [io  0x3000-0x3fff]
[    0.256453] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.256554] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.256661] pci 0000:00:1c.0:   bridge window [mem 0x20000000-0x201fffff]
[    0.256770] pci 0000:00:1c.0:   bridge window [mem 0x20200000-0x203fffff 64bit pref]
[    0.256914] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.257014] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.257122] pci 0000:00:1c.1:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.257231] pci 0000:00:1c.1:   bridge window [mem 0x20400000-0x205fffff 64bit pref]
[    0.257374] pci 0000:00:1c.2: PCI bridge to [bus 01-02]
[    0.257475] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.257582] pci 0000:00:1c.2:   bridge window [mem 0xf8000000-0xfbefffff]
[    0.257691] pci 0000:00:1c.2:   bridge window [mem 0xf0000000-0xf6ffffff 64bit pref]
[    0.257836] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    0.257934] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.258037] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.258139] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.258261] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    0.258380] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.258489] pci 0000:00:1c.0: setting latency timer to 64
[    0.258507] pci 0000:00:1c.1: enabling device (0106 -> 0107)
[    0.258613] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.258722] pci 0000:00:1c.1: setting latency timer to 64
[    0.258738] pci 0000:00:1c.2: enabling device (0106 -> 0107)
[    0.258844] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.258950] pci 0000:00:1c.2: setting latency timer to 64
[    0.258964] pci 0000:00:1e.0: setting latency timer to 64
[    0.258976] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.258985] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.258994] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.259003] pci_bus 0000:04: resource 1 [mem 0x20000000-0x201fffff]
[    0.259012] pci_bus 0000:04: resource 2 [mem 0x20200000-0x203fffff 64bit pref]
[    0.259022] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    0.259030] pci_bus 0000:03: resource 1 [mem 0xfbf00000-0xfbffffff]
[    0.259040] pci_bus 0000:03: resource 2 [mem 0x20400000-0x205fffff 64bit pref]
[    0.259049] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.259058] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfbefffff]
[    0.259067] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf6ffffff 64bit pref]
[    0.259077] pci_bus 0000:05: resource 3 [io  0x0000-0xffff]
[    0.259085] pci_bus 0000:05: resource 4 [mem 0x00000000-0xffffffff]
[    0.259201] NET: Registered protocol family 2
[    0.259459] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.260180] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.260578] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[    0.260938] TCP: Hash tables configured (established 16384 bind 16384)
[    0.261042] TCP reno registered
[    0.261135] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.261255] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.261610] NET: Registered protocol family 1
[    0.261747] pci 0000:00:02.0: Boot video device
[    0.261932] PCI: CLS 16 bytes, default 64
[    0.262069] Unpacking initramfs...
[    0.554656] Freeing initrd memory: 2877k freed
[    0.560516] audit: initializing netlink socket (disabled)
[    0.560658] type=2000 audit(1265277401.559:1): initialized
[    0.561221] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.561574] VFS: Disk quotas dquot_6.5.2
[    0.561738] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.562014] msgmni has been set to 987
[    0.562587] alg: No test for stdrng (krng)
[    0.562781] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.562919] io scheduler noop registered
[    0.563010] io scheduler deadline registered
[    0.563131] io scheduler cfq registered (default)
[    0.563443] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.563520] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.563710] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.563810] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.563990] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.564049] pcieport 0000:00:1c.2: irq 26 for MSI/MSI-X
[    0.564511] isapnp: Scanning for PnP cards...
[    0.918315] isapnp: No Plug & Play device found
[    0.921679] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.922897] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.942854] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.942964] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.943308] mice: PS/2 mouse device common for all mice
[    0.944191] rtc_cmos 00:03: RTC can wake from S4
[    0.944390] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.944527] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    0.944665] cpuidle: using governor ladder
[    0.944759] cpuidle: using governor menu
[    0.944854] No iBFT detected.
[    0.945605] TCP cubic registered
[    0.945790] NET: Registered protocol family 10
[    0.946894] lo: Disabled Privacy Extensions
[    0.947621] Mobile IPv6
[    0.947732] NET: Registered protocol family 17
[    0.947870] Using IPI No-Shortcut mode
[    0.963532] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.974883] registered taskstats version 1
[    0.975492] rtc_cmos 00:03: setting system clock to 2010-02-04 09:56:42 UTC (1265277402)
[    0.975782] Freeing unused kernel memory: 344k freed
[    0.976328] Write protecting the kernel text: 2392k
[    0.976470] Write protecting the kernel read-only data: 956k
[    1.059793] ata_piix 0000:00:1f.2: version 2.13
[    1.059852] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.060000] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    1.060365] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.060564] scsi0 : ata_piix
[    1.060922] scsi1 : ata_piix
[    1.067004] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.067116] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.236379] ata2.00: CFA: SILICONMOTION SM223AC, , max UDMA/66
[    1.236487] ata2.00: 7815024 sectors, multi 0: LBA 
[    1.252317] ata2.00: configured for UDMA/66
[    1.252706] scsi 1:0:0:0: Direct-Access     ATA      SILICONMOTION SM n/a  PQ: 0 ANSI: 5
[    1.313204] thermal LNXTHERM:01: registered as thermal_zone0
[    1.313362] ACPI: Thermal Zone [TZ00] (51 C)
[    1.776616] sd 1:0:0:0: [sda] 7815024 512-byte logical blocks: (4.00 GB/3.72 GiB)
[    1.776924] sd 1:0:0:0: [sda] Write Protect is off
[    1.777024] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.777096] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.777627]  sda: sda1 sda2
[    1.779826] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.890832] PM: Starting manual resume from disk
[    2.013577] EXT4-fs (sda2): mounted filesystem without journal
[    2.597542] udev: starting version 150
[    3.004774] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    3.004922] Copyright (c) 2007 Atheros Corporation.
[    3.005106] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.005230] atl2 0000:03:00.0: setting latency timer to 64
[    3.242859] Linux agpgart interface v0.103
[    3.388182] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    3.395608] usbcore: registered new interface driver usbfs
[    3.396333] usbcore: registered new interface driver hub
[    3.406535] ACPI: Lid Switch [LID]
[    3.407090] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    3.407246] ACPI: Sleep Button [SLPB]
[    3.407646] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[    3.407792] ACPI: Power Button [PWRB]
[    3.408230] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    3.408372] ACPI: Power Button [PWRF]
[    3.409103] usbcore: registered new device driver usb
[    3.428361] Marking TSC unstable due to TSC halts in idle
[    3.448957] Switching to clocksource hpet
[    3.474058] ACPI: AC Adapter [AC0] (on-line)
[    3.487976] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.493058] ACPI: Battery Slot [BAT0] (battery absent)
[    3.531023] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.531235] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.531396] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.531407] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.531575] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    3.531771] ehci_hcd 0000:00:1d.7: debug port 1
[    3.535750] ehci_hcd 0000:00:1d.7: cache line size of 16 is not supported
[    3.578482] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
[    3.632075] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.632282] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.632389] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.632526] usb usb1: Product: EHCI Host Controller
[    3.632624] usb usb1: Manufacturer: Linux 2.6.33-rc6eeepc ehci_hcd
[    3.632727] usb usb1: SerialNumber: 0000:00:1d.7
[    3.633467] hub 1-0:1.0: USB hub found
[    3.633573] hub 1-0:1.0: 8 ports detected
[    3.633845] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    3.634385] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    3.654955] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    3.689856] uhci_hcd: USB Universal Host Controller Interface driver
[    3.690103] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.692108] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.692118] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.692249] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.692433] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
[    3.692637] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.692745] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.692880] usb usb2: Product: UHCI Host Controller
[    3.692977] usb usb2: Manufacturer: Linux 2.6.33-rc6eeepc uhci_hcd
[    3.693079] usb usb2: SerialNumber: 0000:00:1d.0
[    3.700772] hub 2-0:1.0: USB hub found
[    3.700885] hub 2-0:1.0: 2 ports detected
[    3.701148] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.701274] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.701283] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.701401] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    3.701604] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
[    3.701788] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.701895] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.702030] usb usb3: Product: UHCI Host Controller
[    3.702150] usb usb3: Manufacturer: Linux 2.6.33-rc6eeepc uhci_hcd
[    3.702252] usb usb3: SerialNumber: 0000:00:1d.1
[    3.713389] hub 3-0:1.0: USB hub found
[    3.713501] hub 3-0:1.0: 2 ports detected
[    3.713763] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.713888] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.713898] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.714017] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    3.714225] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[    3.714416] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.714522] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.714657] usb usb4: Product: UHCI Host Controller
[    3.714754] usb usb4: Manufacturer: Linux 2.6.33-rc6eeepc uhci_hcd
[    3.714856] usb usb4: SerialNumber: 0000:00:1d.2
[    3.763506] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    3.767898] hub 4-0:1.0: USB hub found
[    3.768067] hub 4-0:1.0: 2 ports detected
[    3.768328] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    3.768453] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    3.768463] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.768580] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    3.768785] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
[    3.768981] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.769087] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.769222] usb usb5: Product: UHCI Host Controller
[    3.769319] usb usb5: Manufacturer: Linux 2.6.33-rc6eeepc uhci_hcd
[    3.769421] usb usb5: SerialNumber: 0000:00:1d.3
[    3.769895] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    3.780794] hub 5-0:1.0: USB hub found
[    3.780916] hub 5-0:1.0: 2 ports detected
[    3.833265] cfg80211: Using static regulatory domain info
[    3.833375] cfg80211: Regulatory domain: 00
[    3.833468]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    3.833608]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    3.833715]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[    3.833822]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[    3.833929]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    3.834059]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    3.836103] cfg80211: Calling CRDA to update world regulatory domain
[    3.968572] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    4.024742] eeepc_laptop: Eee PC Hotkey Driver
[    4.024852] eeepc_laptop: model 701 does not officially support setting cpu speed
[    4.024988] eeepc_laptop: cpufv disabled to avoid instability
[    4.025121] eeepc_laptop: Hotkey init flags 0x41
[    4.026759] eeepc_laptop: TYPE (2000000) not reported by BIOS, enabling anyway
[    4.026910] eeepc_laptop: Get control methods supported: 0x2101711
[    4.058491] input: Asus EeePC extra buttons as /devices/platform/eeepc/input/input6
[    4.077962] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.078089] ath5k 0000:01:00.0: setting latency timer to 64
[    4.078180] ath5k 0000:01:00.0: registered as 'phy0'
[    4.553269] usb 1-5: New USB device found, idVendor=0951, idProduct=1606
[    4.553390] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=4
[    4.553500] usb 1-5: Product: UB6225
[    4.553592] usb 1-5: Manufacturer: ENE
[    4.553686] usb 1-5: SerialNumber: 146030377350
[    4.628170] Initializing USB Mass Storage driver...
[    4.635038] scsi2 : usb-storage 1-5:1.0
[    4.637879] usbcore: registered new interface driver usb-storage
[    4.637988] USB Mass Storage support registered.
[    4.708050] usb 1-8: new high speed USB device using ehci_hcd and address 3
[    4.725039] ath: EEPROM regdomain: 0x60
[    4.725049] ath: EEPROM indicates we should expect a direct regpair map
[    4.725060] ath: Country alpha2 being used: 00
[    4.725066] ath: Regpair used: 0x60
[    4.876552] usb 1-8: New USB device found, idVendor=eb1a, idProduct=2761
[    4.876673] usb 1-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.878963] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.879234] HDA Intel 0000:00:1b.0: irq 27 for MSI/MSI-X
[    4.879296] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    4.939598] Linux video capture interface: v2.00
[    4.965095] uvcvideo: Found UVC 1.00 device <unnamed> (eb1a:2761)
[    5.004366] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
[    5.095154] Synaptics Touchpad, model: 1, fw: 6.5, id: 0x1c0b1, caps: 0xa04751/0xa00000
[    5.171161] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8
[    5.286177] phy0: Selected rate control algorithm 'minstrel'
[    5.287901] Registered led device: ath5k-phy0::rx
[    5.288535] Registered led device: ath5k-phy0::tx
[    5.288645] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[    5.437452] input: UVC Camera (eb1a:2761) as /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/input/input9
[    5.437743] usbcore: registered new interface driver uvcvideo
[    5.437848] USB Video Class driver (v0.1.0)
[    6.210502] loop: module loaded
[    6.750735] Adding 358392k swap on /swapfile.  Priority:-1 extents:48 across:1567744k 
[    9.015498] fuse init (API version 7.13)
[    9.636937] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
[   10.007642] sd 2:0:0:0: [sdb] 15660032 512-byte logical blocks: (8.01 GB/7.46 GiB)
[   10.008667] sd 2:0:0:0: [sdb] Write Protect is off
[   10.008777] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   10.008785] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   10.012626] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   10.012745]  sdb: sdb1
[   10.018642] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   10.018757] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   14.930822] atl2 0000:03:00.0: irq 28 for MSI/MSI-X
[   14.931078] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.948483] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   15.136084] atl2: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   15.136310] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   16.173086] [drm] Initialized drm 1.1.0 20060810
[   16.261255] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   16.261272] i915 0000:00:02.0: setting latency timer to 64
[   16.275763] [drm] set up 7M of stolen space
[   16.320114] [drm] initialized overlay support
[   17.159863] Console: switching to colour frame buffer device 100x30
[   17.159893] fb0: inteldrmfb frame buffer device
[   17.159899] registered panic notifier
[   17.159923] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   17.276147] render error detected, EIR: 0x00000010
[   17.276159] page table error
[   17.276164]   PGTBL_ER: 0x00000010
[   17.276173] [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
[   17.276194] render error detected, EIR: 0x00000010
[   17.276200] page table error
[   17.276204]   PGTBL_ER: 0x00000010
[   25.960076] eth0: no IPv6 routers present
[  214.780419] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [53465]
[  214.877684] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [53489]
[  214.924652] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [53501]
[  215.016566] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [53524]
[  215.072941] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [53538]
[  215.164278] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [53561]
[  215.215868] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [53573]
[  215.311110] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [53597]
[  215.358798] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [53609]
[  215.457605] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [53634]
[  215.505370] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [53646]
[  215.602090] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [53670]
[  215.668450] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [53687]
[  215.699130] Syncing filesystems ... 
[  215.750069] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [53707]
[  215.802573] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [53720]
[  215.897293] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [53744]
[  215.962873] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [53760]
[  216.055074] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [53783]
[  216.066586] done.
[  216.066595] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  216.084210] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  216.110824] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [53797]
[  216.120031] PM: Preallocating image memory... done (allocated 34186 pages)
[  216.186449] PM: Allocated 136744 kbytes in 0.06 seconds (2279.06 MB/s)
[  216.203087] /home/alan/pkg/eee/linux-2.6/drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [53820]
[  216.220177] ACPI handle has no context!
[  216.224171] atl2 0000:03:00.0: PCI INT A disabled
[  216.228186] ACPI handle has no context!
[  216.248274] ata_piix 0000:00:1f.2: PCI INT B disabled
[  216.252181] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  216.260136] PM: freeze of devices complete after 65.952 msecs
[  216.264805] PM: late freeze of devices complete after 0.863 msecs
[  216.268694] Disabling non-boot CPUs ...
[  216.272707] PM: Creating hibernation image: 
[  216.276474] PM: Need to copy 34114 pages
[  216.276474] PM: Hibernation image created (34114 pages copied)
[  216.276474] Force enabled HPET at resume
[  216.276474] PM: early thaw of devices complete after 0.108 msecs
[  216.297772] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  216.301284] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  216.304738] HDA Intel 0000:00:1b.0: irq 27 for MSI/MSI-X
[  216.308027] pci 0000:00:1e.0: setting latency timer to 64
[  216.311199] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00001, writing 0x2b00005)
[  216.317822] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  216.321286] ata_piix 0000:00:1f.2: setting latency timer to 64
[  216.348091] atl2 0000:03:00.0: BAR 0: set to [mem 0xfbfc0000-0xfbffffff 64bit] (PCI address [0xfbfc0000-0xfbffffff]
[  216.354979] atl2 0000:03:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100406)
[  216.361816] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  216.365316] atl2 0000:03:00.0: setting latency timer to 64
[  216.368787] atl2 0000:03:00.0: irq 28 for MSI/MSI-X
[  216.396339] sd 1:0:0:0: [sda] Starting disk
[  216.496433] ata2.00: ACPI cmd ef/03:44:00:00:00:a0 (SET FEATURES) filtered out
[  216.499871] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[  216.516377] ata2.00: configured for UDMA/66
[  217.675777] PM: thaw of devices complete after 1399.366 msecs
[  217.710396] Restarting tasks ... done.


