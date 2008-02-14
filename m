Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbYBNJrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbYBNJrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 04:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYBNJqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 04:46:49 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:44258 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbYBNJqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 04:46:42 -0500
Message-ID: <47B40DF2.10009@linux.vnet.ibm.com>
Date: Thu, 14 Feb 2008 15:16:26 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Nish Aravamudan <nish.aravamudan@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       ananth@in.ibm.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.26-git0: IDE oops during boot
References: <20080206105334.GA3664@elf.ucw.cz> <200802112035.39462.bzolnier@gmail.com> <47B16113.1060807@linux.vnet.ibm.com> <200802140000.10639.bzolnier@gmail.com>
In-Reply-To: <200802140000.10639.bzolnier@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060404020400080901080502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060404020400080901080502
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Tuesday 12 February 2008, Kamalesh Babulal wrote:
>> Bartlomiej Zolnierkiewicz wrote:
>>> Hi,
>>>
>>> On Monday 11 February 2008, Kamalesh Babulal wrote:
>>>> Nish Aravamudan wrote:
>>>>> On 2/7/08, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>>>>>> On Thursday 07 February 2008, Kamalesh Babulal wrote:
>>>>>>> Bartlomiej Zolnierkiewicz wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On Wednesday 06 February 2008, Pavel Machek wrote:
>>>>>>>>> On Wed 2008-02-06 11:53:34, Pavel Machek wrote:
>>>>>>>>>> Hi!
>>>>>>>>>>
>>>>>>>>>> Trying to boot 2.6.25-git0 (few days old), I get
>>>>>>>>>>
>>>>>>>>>> BUG: unable to handle kernel paging request at ffff..ffb0
>>>>>>>>>> IP at init_irq+0x42e
>>>>>>>> init_irq? hmm...
>>>>>>>>
>>>>>>>>>> Call trace:
>>>>>>>>>> ide_device_add_all
>>>>>>>> this comes from ide-generic
>>>>>>>> (Generic IDE host driver)
>>>>>>>>
>>>>>>>>>> ide_generic_init
>>>>>>>>>> kernel_init
>>>>>>>>>> child_rip
>>>>>>>>>> vgacon_cursor
>>>>>>>>>> kernel_init
>>>>>>>>>> child_rip
>>>>>>>>>>
>>>>>>>>>> Excerpt from config:
>>>>>>>>>>
>>>>>>>>>> CONFIG_IDE=y
>>>>>>>>>> CONFIG_BLK_DEV_IDE=y
>>>>>>>>> Disabling CONFIG_IDE made my machine boot, as it was using libata
>>>>>>>>> anyway.
>>>>>>>> Kamalesh/Pavel:
>>>>>>>>
>>>>>>>> Could you try latest git and see if the OOPS is still there?
>>>>>>>>
>>>>>>>> [ Yeah, I'm unable to reproduce it. :( ]
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Bart
>>>>>>> Hi Bart,
>>>>>>>
>>>>>>> The panic is reproducible with the 2.6.24-git16 kernel, the call trace is
>>>>>>> similar to the previous one
>>>>>> Thanks, I again reviewed ide-probe.c changes but nothing seems wrong...
>>>>>>
>>>>>> Could you please bisect it down to the guilty commit?
>>>>> Kamalesh, were you able to bisect this down? I just got hit by the
>>>>> same panic on a 4-way x86_64, with 2.6.24-git22.
>>>>>
>>>>> Thanks,
>>>>> Nish
>>>> Hi Nish,
>>>>
>>>> I tried bisecting and the guilty patch seems to be 
>>>>
>>>> 36501650ec45b1db308c3b51886044863be2d762 is first bad commit
>>>> commit 36501650ec45b1db308c3b51886044863be2d762
>>>> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>> Date:   Fri Feb 1 23:09:31 2008 +0100
>>>>
>>>>     ide: keep pointer to struct device instead of struct pci_dev in ide_hwif_t
>>>>
>>>>
>>>> the gdb output, also points to the changes made by the guilty patch
>>>>
>>>> (gdb) p ide_device_add_all
>>>> $1 = {int (u8 *, const struct ide_port_info *)} 0xffffffff804176ac <ide_device_add_all>
>>>> (gdb) p/x 0xffffffff804176ac+0xb60
>>>> $2 = 0xffffffff8041820c
>>>> (gdb) l *0xffffffff8041820c
>>>> 0xffffffff8041820c is in ide_device_add_all (drivers/ide/ide-probe.c:1249).
>>>> 1244                    goto out;
>>>> 1245            }
>>>> 1246
>>>> 1247            sg_init_table(hwif->sg_table, hwif->sg_max_nents);
>>>> 1248
>>>> 1249            if (init_irq(hwif) == 0)
>>>> 1250                    goto done;
>>>> 1251
>>>> 1252            old_irq = hwif->irq;
>>>> 1253            /*
>>>> (gdb) 
>>>>
>>>>
>>>> (gdb) p init_irq
>>>> $1 = {int (ide_hwif_t *)} 0xffffffff8041721f <init_irq>
>>>> (gdb) p/x 0xffffffff8041721f+0x1a4
>>>> $2 = 0xffffffff804173c3
>>>> (gdb) l *0xffffffff804173c3
>>>> 0xffffffff804173c3 is in init_irq (include/asm/pci.h:101).
>>>> 96      /* Returns the node based on pci bus */
>>>> 97      static inline int __pcibus_to_node(struct pci_bus *bus)
>>>> 98      {
>>>> 99              struct pci_sysdata *sd = bus->sysdata;
>>>> 100
>>>> 101             return sd->node;
>>>> 102     }
>>>> 103
>>>> 104     static inline cpumask_t __pcibus_to_cpumask(struct pci_bus *bus)
>>>> 105     {
>>>> (gdb) 
>>> Thanks for the detailed analysis and sorry for the bug.
>>>
>>> I think that this may has been just fixed by Andi's recent hwif_to_node()
>>> fix (patch below, it is in Linus' tree already), could please verify this?
>>>
>>> commit 1f07e988290fc45932f5028c9e2a862c37a57336
>>> Author: Andi Kleen <andi@firstfloor.org>
>>> Date:   Mon Feb 11 01:35:20 2008 +0100
>>>
>>>     Prevent IDE boot ops on NUMA system
>>>     
>>>     Without this patch a Opteron test system here oopses at boot with
>>>     current git.
>>>     
>>>     Calling to_pci_dev() on a NULL pointer gives a negative value so the
>>>     following NULL pointer check never triggers and then an illegal address
>>>     is referenced.  Check the unadjusted original device pointer for NULL
>>>     instead.
>>>     
>>>     Signed-off-by: Andi Kleen <ak@suse.de>
>>>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>>>
>>> diff --git a/include/linux/ide.h b/include/linux/ide.h
>>> index 23fad89..a3b69c1 100644
>>> --- a/include/linux/ide.h
>>> +++ b/include/linux/ide.h
>>> @@ -1295,7 +1295,7 @@ static inline void ide_dump_identify(u8 *id)
>>>  static inline int hwif_to_node(ide_hwif_t *hwif)
>>>  {
>>>  	struct pci_dev *dev = to_pci_dev(hwif->dev);
>>> -	return dev ? pcibus_to_node(dev->bus) : -1;
>>> +	return hwif->dev ? pcibus_to_node(dev->bus) : -1;
>>>  }
>>>
>>>  static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
>> Hi Bart,
>> Thanks !! the patch solves the kernel panic but when after applying the patch,kernel is not
>> able to mount the filesystem and panics, am i not sure what is likely causing the panic.
> 
> Is
> 
> - the commit 36501650ec45b1db308c3b51886044863be2d762 with Andi's fix applied
> 
> or
> 
> - the commit f6fb786d6dcdd7d730e4fba620b071796f487e1b
>   (the one before commit 36501650ec45b1db308c3b51886044863be2d762)
> 
> working for you?

No, the commit before the commit 36501650ec45b1db308c3b51886044863be2d762 did not either work, i
get the same kernel panic.

> 
>> Creating root device.
>> Mounting root filesystem.
>> mount: could not  find filesystem
>> Kernel panic - not syncing: Attempted to kill init!
> 
> Is IDE actually used for the boot device?
> 
> [ Please send a dmesg output from the working system. ]
> 


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

--------------060404020400080901080502
Content-Type: text/plain;
 name="dmesg_feb_14"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg_feb_14"

Linux version 2.6.23.9-srikar (srikar@llm37.in.ibm.com) (gcc version 4.1.1 20060817 (Red Hat 4.1.1-18)) #4 SMP Fri Jan 25 12:01:10 IST 2008
Command line: ro root=LABEL=/ rhgb console=tty0 console=ttyS0,38400 iommu=calgary crashkernel=128M@16M 
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000099c00 (usable)
 BIOS-e820: 0000000000099c00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cff8dc80 (usable)
 BIOS-e820: 00000000cff8dc80 - 00000000cff98880 (ACPI data)
 BIOS-e820: 00000000cff98880 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
Entering add_active_range(0, 0, 153) 0 entries of 3200 used
Entering add_active_range(0, 256, 851853) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2293760) 2 entries of 3200 used
end_pfn_map = 2293760
DMI 2.3 present.
ACPI: RSDP 000FDCF0, 0014 (r0 IBM   )
ACPI: RSDT CFF98800, 0034 (r1 IBM    EXA01ZEU     1000 IBM  45444F43)
ACPI: FACP CFF98780, 0074 (r1 IBM    EXA01ZEU     1000 IBM  45444F43)
ACPI: DSDT CFF8DC80, 2D9A (r1 IBM    SER01ZEU     1000 INTL 20030122)
ACPI: FACS CFF98540, 0040
ACPI: APIC CFF98680, 00D2 (r1 IBM    EXA01ZEU     1000 IBM  45444F43)
ACPI: SRAT CFF98580, 0100 (r1 IBM    EXA01ZEU     1000 IBM  45444F43)
ACPI: SSDT CFF90A40, 7A56 (r1 IBM    VIGSSDT0     1000 INTL 20030122)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 0 -> APIC 6 -> Node 0
SRAT: PXM 0 -> APIC 7 -> Node 0
SRAT: PXM 0 -> APIC 16 -> Node 0
SRAT: PXM 0 -> APIC 17 -> Node 0
SRAT: PXM 0 -> APIC 22 -> Node 0
SRAT: PXM 0 -> APIC 23 -> Node 0
SRAT: Node 0 PXM 0 0-d0000000
Entering add_active_range(0, 0, 153) 0 entries of 3200 used
Entering add_active_range(0, 256, 851853) 1 entries of 3200 used
SRAT: Node 0 PXM 0 0-230000000
Entering add_active_range(0, 0, 153) 2 entries of 3200 used
Entering add_active_range(0, 256, 851853) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 2293760) 2 entries of 3200 used
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000230000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2293760
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      153
    0:      256 ->   851853
    0:  1048576 ->  2293760
On node 0 totalpages: 2096934
  DMA zone: 56 pages used for memmap
  DMA zone: 1544 pages reserved
  DMA zone: 2393 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 833477 pages, LIFO batch:31
  Normal zone: 17024 pages used for memmap
  Normal zone: 1228160 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x9c
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
Processor #6
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
Processor #16
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x11] enabled)
Processor #17
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x16] enabled)
Processor #22
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x17] enabled)
Processor #23
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 15, address 0xfec00000, GSI 0-35
ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[36])
IOAPIC[1]: apic_id 14, address 0xfec01000, GSI 36-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 8 global_irq 8 low edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 low edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ8 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 0000000000099000 - 000000000009a000
swsusp: Registered nosave memory region: 000000000009a000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
swsusp: Registered nosave memory region: 00000000cff8d000 - 00000000cff8e000
swsusp: Registered nosave memory region: 00000000cff8e000 - 00000000cff98000
swsusp: Registered nosave memory region: 00000000cff98000 - 00000000cff99000
swsusp: Registered nosave memory region: 00000000cff99000 - 00000000d0000000
swsusp: Registered nosave memory region: 00000000d0000000 - 00000000fec00000
swsusp: Registered nosave memory region: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at d4000000 (gap: d0000000:2ec00000)
SMP: Allowing 8 CPUs, 0 hotplug CPUs
PERCPU: Allocating 34792 bytes of per cpu data
Built 1 zonelists in Zone order.  Total pages: 2064030
Policy zone: Normal
Kernel command line: ro root=LABEL=/ rhgb console=tty0 console=ttyS0,38400 iommu=calgary crashkernel=128M@16M 
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 3669.795 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: finished detection, Calgary found
PCI-DMA: Calgary IOMMU detected.
PCI-DMA: Calgary TCE table spec is 7, CONFIG_IOMMU_DEBUG is disabled.
Memory: 8106728k/9175040k available (3016k kernel code, 281008k reserved, 1741k data, 336k init)
Calibrating delay using timer specific routine.. 7346.75 BogoMIPS (lpj=14693515)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM1)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
..MP-BIOS bug: 8254 timer not connected to IO-APIC
Using local APIC timer interrupts.
result 10425395
Detected 10.425 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/8 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 7339.87 BogoMIPS (lpj=14679744)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM1)
               Intel(R) Xeon(TM) MP CPU 3.66GHz stepping 01
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
SMP alternatives: switching to SMP code
Booting processor 2/8 APIC 0x6
Initializing CPU#2
Calibrating delay using timer specific routine.. 7340.06 BogoMIPS (lpj=14680132)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 2/6 -> Node 0
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
CPU2: Thermal monitoring enabled (TM1)
               Intel(R) Xeon(TM) MP CPU 3.66GHz stepping 09
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
SMP alternatives: switching to SMP code
Booting processor 3/8 APIC 0x7
Initializing CPU#3
Calibrating delay using timer specific routine.. 7340.12 BogoMIPS (lpj=14680247)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 3/7 -> Node 0
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
CPU3: Thermal monitoring enabled (TM1)
               Intel(R) Xeon(TM) MP CPU 3.66GHz stepping 09
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
SMP alternatives: switching to SMP code
Booting processor 4/8 APIC 0x10
Initializing CPU#4
Calibrating delay using timer specific routine.. 7340.14 BogoMIPS (lpj=14680282)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 4/10 -> Node 0
CPU: Physical Processor ID: 8
CPU: Processor Core ID: 0
CPU4: Thermal monitoring enabled (TM1)
               Intel(R) Xeon(TM) MP CPU 3.66GHz stepping 09
checking TSC synchronization [CPU#0 -> CPU#4]: passed.
SMP alternatives: switching to SMP code
Booting processor 5/8 APIC 0x11
Initializing CPU#5
Calibrating delay using timer specific routine.. 7340.09 BogoMIPS (lpj=14680185)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 5/11 -> Node 0
CPU: Physical Processor ID: 8
CPU: Processor Core ID: 0
CPU5: Thermal monitoring enabled (TM1)
               Intel(R) Xeon(TM) MP CPU 3.66GHz stepping 09
checking TSC synchronization [CPU#0 -> CPU#5]: passed.
SMP alternatives: switching to SMP code
Booting processor 6/8 APIC 0x16
Initializing CPU#6
Calibrating delay using timer specific routine.. 7340.09 BogoMIPS (lpj=14680190)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 6/16 -> Node 0
CPU: Physical Processor ID: 11
CPU: Processor Core ID: 0
CPU6: Thermal monitoring enabled (TM1)
               Intel(R) Xeon(TM) MP CPU 3.66GHz stepping 09
checking TSC synchronization [CPU#0 -> CPU#6]: passed.
SMP alternatives: switching to SMP code
Booting processor 7/8 APIC 0x17
Initializing CPU#7
Calibrating delay using timer specific routine.. 7340.06 BogoMIPS (lpj=14680129)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 7/17 -> Node 0
CPU: Physical Processor ID: 11
CPU: Processor Core ID: 0
CPU7: Thermal monitoring enabled (TM1)
               Intel(R) Xeon(TM) MP CPU 3.66GHz stepping 09
checking TSC synchronization [CPU#0 -> CPU#7]: passed.
Brought up 8 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [VP00] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.VP00._PRT]
ACPI: PCI Root Bridge [VP01] (0000:01)
ACPI: PCI Interrupt Routing Table [\_SB_.VP01._PRT]
ACPI: PCI Root Bridge [VP02] (0000:02)
ACPI: PCI Interrupt Routing Table [\_SB_.VP02._PRT]
ACPI: PCI Root Bridge [VP03] (0000:04)
ACPI: PCI Interrupt Routing Table [\_SB_.VP03._PRT]
ACPI: PCI Root Bridge [VP04] (0000:06)
ACPI: PCI Interrupt Routing Table [\_SB_.VP04._PRT]
ACPI: PCI Root Bridge [VP05] (0000:08)
ACPI: PCI Interrupt Routing Table [\_SB_.VP05._PRT]
ACPI: PCI Root Bridge [VP06] (0000:0a)
ACPI: PCI Interrupt Routing Table [\_SB_.VP06._PRT]
ACPI: PCI Root Bridge [VP07] (0000:0c)
ACPI: PCI Interrupt Routing Table [\_SB_.VP07._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 20 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-DMA: Using Calgary IOMMU
Calgary: enabling translation on Calgary PHB 0x0
Calgary: errant DMAs will now be prevented on this bus.
Calgary: enabling translation on Calgary PHB 0x1
Calgary: errant DMAs will now be prevented on this bus.
PCI-GART: No AMD northbridge found.
Time: tsc clocksource has been installed.
pnp: 00:0a: ioport range 0x400-0x47f has been reserved
pnp: 00:0a: ioport range 0x480-0x4ff has been reserved
pnp: 00:0b: iomem range 0x400-0x4ff could not be reserved
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 1048576 (order: 12, 25165824 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 1048576 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 1152k freed
Calgary: fixing up tce spaces
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:01.0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:03: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:04: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
tg3.c:v3.81.1 (October 18, 2007)
ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 24 (level, low) -> IRQ 24
eth0: Tigon3 [partno(BCM95704A6) rev 2100 PHY(5704)] (PCIX:66MHz:64-bit) 10/100/1000Base-T Ethernet 00:14:5e:1c:86:fc
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] WireSpeed[1] TSOcap[0]
eth0: dma_rwctrl[769f0000] dma_mask[64-bit]
ACPI: PCI Interrupt 0000:01:01.1[B] -> GSI 28 (level, low) -> IRQ 28
eth1: Tigon3 [partno(BCM95704A6) rev 2100 PHY(5704)] (PCIX:66MHz:64-bit) 10/100/1000Base-T Ethernet 00:14:5e:1c:86:fd
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[769f0000] dma_mask[64-bit]
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hda: HL-DT-STCD-RW/DVD DRIVE GCC-4244N, ATAPI CD/DVD-ROM drive
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Adaptec aacraid driver 1.1-5[2449]-ms
ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 25 (level, low) -> IRQ 25
AAC0: kernel 5.2-0[11835] Jan  9 2007
AAC0: monitor 5.2-0[11835]
AAC0: bios 5.2-0[11835]
AAC0: serial 1625D1
AAC0: 64bit support enabled.
AAC0: 64 Bit DAC enabled
scsi0 : ServeRAID
scsi 0:0:0:0: Direct-Access     IBM      x366             V1.0 PQ: 0 ANSI: 2
scsi 0:1:0:0: Direct-Access     IBM-ESXS ST973401SS       B519 PQ: 0 ANSI: 5
scsi 0:1:1:0: Direct-Access     IBM-ESXS ST973401SS       B519 PQ: 0 ANSI: 5
scsi 0:1:2:0: Direct-Access     IBM-ESXS ST973401SS       B519 PQ: 0 ANSI: 5
scsi 0:3:0:0: Enclosure         IBM      SAS SES-2 DEVICE 0.09 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 429459456 512-byte hardware sectors (219883 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 06 00 10 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:0: [sda] 429459456 512-byte hardware sectors (219883 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 06 00 10 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI removable disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:1:0:0: Attached scsi generic sg1 type 0
scsi 0:1:1:0: Attached scsi generic sg2 type 0
scsi 0:1:2:0: Attached scsi generic sg3 type 0
scsi 0:3:0:0: Attached scsi generic sg4 type 13
Fusion MPT base driver 3.04.05
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.05
ieee1394: raw1394: /dev/raw1394 device initialized
ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:03.2: EHCI Host Controller
ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:03.2: irq 20, io mem 0xeb512000
ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.0: irq 20, io mem 0xeb510000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb 1-3: new high speed USB device using ehci_hcd and address 2
ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.1: irq 20, io mem 0xeb511000
usb 1-3: configuration #1 chosen from 1 choice
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
USB Universal Host Controller Interface driver v3.0
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
scsi1 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
input: Avocent Virtual Media KVM Module as /class/input/input1
input: USB HID v1.10 Keyboard [Avocent Virtual Media KVM Module] on usb-0000:00:03.2-3
input: Avocent Virtual Media KVM Module as /class/input/input2
input: USB HID v1.10 Mouse [Avocent Virtual Media KVM Module] on usb-0000:00:03.2-3
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Freeing unused kernel memory: 336k freed
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
scsi 1:0:0:0: CD-ROM            KVM      vmDisk-CD        0.01 PQ: 0 ANSI: 0
sr0: scsi3-mmc drive: 0x/0x caddy
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg5 type 5
usb-storage: device scan complete
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 4192956k swap on /dev/sda3.  Priority:-1 extents:1 across:4192956k
kudzu[2779]: segfault at 0000000000000000 rip 0000003fc9e78c9b rsp 00007fff8d8abfb8 error 4
process `sysctl' is using deprecated sysctl (syscall) net.ipv6.neigh.default.retrans_time; Use net.ipv6.neigh.default.retrans_time_ms instead.
ADDRCONF(NETDEV_UP): eth0: link is not ready
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present

--------------060404020400080901080502--
