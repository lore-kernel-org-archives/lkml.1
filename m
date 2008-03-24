Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbYCXT7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbYCXT7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbYCXT7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:59:20 -0400
Received: from www17.your-server.de ([213.133.104.17]:39983 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbYCXT7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:59:11 -0400
Message-ID: <47E807EE.2030902@m3y3r.de>
Date: Mon, 24 Mar 2008 20:58:38 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080310)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------000609030408010808070402"
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000609030408010808070402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds schrieb:
> On Sat, 22 Mar 2008, Linus Torvalds wrote:
>   
>> AND no, I don't think our x86-32 ioremap() actually works for this case, 
>> because while the resource data may have the full 64 bits, when the 
>> ioremap() happens it gets truncated to 32 bits.
>>     
>
> Does this patch make any difference?
>
> (ENTIRELY untested, I checked that it compiles on x86-64, but didn't even 
> test a 32-bit build, I'm hoping whoever sees this issue can also fix up 
> the inevitable small missed pieces)
>
> 		Linus
>
> ---
>  arch/x86/mm/ioremap.c   |    6 +++---
>  include/asm-x86/io_32.h |    6 +++---
>  include/asm-x86/io_64.h |    6 +++---
>  lib/iomap.c             |    2 +-
>  4 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 8fe576b..4afaba0 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -106,7 +106,7 @@ static int ioremap_change_attr(unsigned long vaddr, unsigned long size,
>   * have to convert them into an offset in a page-aligned mapping, but the
>   * caller shouldn't need to know that small detail.
>   */
> -static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
> +static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
>  			       enum ioremap_mode mode)
>  {
>  	unsigned long pfn, offset, last_addr, vaddr;
> @@ -193,13 +193,13 @@ static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
>   *
>   * Must be freed with iounmap.
>   */
> -void __iomem *ioremap_nocache(unsigned long phys_addr, unsigned long size)
> +void __iomem *ioremap_nocache(resource_size_t phys_addr, unsigned long size)
>  {
>  	return __ioremap(phys_addr, size, IOR_MODE_UNCACHED);
>  }
>  EXPORT_SYMBOL(ioremap_nocache);
>  
> -void __iomem *ioremap_cache(unsigned long phys_addr, unsigned long size)
> +void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
>  {
>  	return __ioremap(phys_addr, size, IOR_MODE_CACHED);
>  }
> diff --git a/include/asm-x86/io_32.h b/include/asm-x86/io_32.h
> index 58d2c45..d4d8fbd 100644
> --- a/include/asm-x86/io_32.h
> +++ b/include/asm-x86/io_32.h
> @@ -114,13 +114,13 @@ static inline void * phys_to_virt(unsigned long address)
>   * If the area you are trying to map is a PCI BAR you should have a
>   * look at pci_iomap().
>   */
> -extern void __iomem *ioremap_nocache(unsigned long offset, unsigned long size);
> -extern void __iomem *ioremap_cache(unsigned long offset, unsigned long size);
> +extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
> +extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
>  
>  /*
>   * The default ioremap() behavior is non-cached:
>   */
> -static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
> +static inline void __iomem *ioremap(resource_size_t offset, unsigned long size)
>  {
>  	return ioremap_nocache(offset, size);
>  }
> diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
> index f64a59c..db0be20 100644
> --- a/include/asm-x86/io_64.h
> +++ b/include/asm-x86/io_64.h
> @@ -158,13 +158,13 @@ extern void early_iounmap(void *addr, unsigned long size);
>   * it's useful if some control registers are in such an area and write combining
>   * or read caching is not desirable:
>   */
> -extern void __iomem *ioremap_nocache(unsigned long offset, unsigned long size);
> -extern void __iomem *ioremap_cache(unsigned long offset, unsigned long size);
> +extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
> +extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
>  
>  /*
>   * The default ioremap() behavior is non-cached:
>   */
> -static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
> +static inline void __iomem *ioremap(resource_size_t offset, unsigned long size)
>  {
>  	return ioremap_nocache(offset, size);
>  }
> diff --git a/lib/iomap.c b/lib/iomap.c
> index db004a9..dd6ca48 100644
> --- a/lib/iomap.c
> +++ b/lib/iomap.c
> @@ -256,7 +256,7 @@ EXPORT_SYMBOL(ioport_unmap);
>   * */
>  void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
>  {
> -	unsigned long start = pci_resource_start(dev, bar);
> +	resource_size_t start = pci_resource_start(dev, bar);
>  	unsigned long len = pci_resource_len(dev, bar);
>  	unsigned long flags = pci_resource_flags(dev, bar);
>  
>
>   
Yes. With this patch applied the error messages doesn't appear anymore.
$ git describe
v2.6.25-rc6-268-gd2532dd

$ git status
# On branch master
# Changed but not updated:
#   (use "git add <file>..." to update what will be committed)
#
#       modified:   arch/x86/mm/ioremap.c
#       modified:   include/asm-x86/io_32.h
#       modified:   include/asm-x86/io_64.h
#       modified:   lib/iomap.c
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       arch/x86/boot/offsets.h
no changes added to commit (use "git add" and/or "git commit -a")

See also attached dmesg.


--------------000609030408010808070402
Content-Type: text/plain;
 name="d1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="d1.txt"

[    0.000000] Linux version 2.6.25-rc6 (thomas@hotzenplotz) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #4 SMP Mon Mar 24 20:48:18 CET 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ede00 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f0c8000 (usable)
[    0.000000]  BIOS-e820: 000000007f0c8000 - 000000007f2c9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f2c9000 - 000000007feb9000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007feb9000 - 000000007feef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007feef000 - 000000007ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] 1136MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Entering add_active_range(0, 0, 520392) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   520392
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   520392
[    0.000000] On node 0 totalpages: 520392
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2273 pages used for memmap
[    0.000000]   HighMem zone: 288743 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT 7FEFD120, 0074 (r1 APPLE   Apple00       55       1000013)
[    0.000000] ACPI: FACP 7FEFB000, 00F4 (r3 APPLE   Apple00       55 Loki       5F)
[    0.000000] ACPI: DSDT 7FEF0000, 48C0 (r1 APPLE  MacBookP    10001 INTL 20050309)
[    0.000000] ACPI: FACS 7FEBB000, 0040
[    0.000000] ACPI: HPET 7FEFA000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: APIC 7FEF9000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: MCFG 7FEF8000, 003C (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ASF! 7FEF7000, 009C (r32 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SBST 7FEF6000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ECDT 7FEF5000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SSDT 7FEB6000, 064F (r1 APPLE   SataPri     1000 INTL 20050309)
[    0.000000] ACPI: SSDT 7FEB5000, 069C (r1 APPLE   SataSec     1000 INTL 20050309)
[    0.000000] ACPI: SSDT 7FEEF000, 04DC (r1 APPLE     CpuPm     3000 INTL 20050309)
[    0.000000] ACPI: DMI detected: Apple
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:14 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:14 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000ee000
[    0.000000] PM: Registered nosave memory: 00000000000ee000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 516327
[    0.000000] Kernel command line: root=/dev/sda3 lapic_timer_c2_ok BOOT_IMAGE=bzImage 
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c042f000 soft=c042d000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1830.956 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Memory: 2059440k/2081568k available (2192k kernel code, 20956k reserved, 775k data, 252k init, 1164064k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[    0.003333]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.003333]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.003333]       .init : 0xc03eb000 - 0xc042a000   ( 252 kB)
[    0.003333]       .data : 0xc0324042 - 0xc03e5dc0   ( 775 kB)
[    0.003333]       .text : 0xc0100000 - 0xc0324042   (2192 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.083331] Calibrating delay using timer specific routine.. 3666.76 BogoMIPS (lpj=6108417)
[    0.083437] Mount-cache hash table entries: 512
[    0.083601] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.083673] CPU: L2 cache: 2048K
[    0.083714] CPU: Physical Processor ID: 0
[    0.083754] CPU: Processor Core ID: 0
[    0.083796] Intel machine check architecture supported.
[    0.083840] Intel machine check reporting enabled on CPU#0.
[    0.083882] using mwait in idle threads.
[    0.083925] Compat vDSO mapped to ffffe000.
[    0.083969] Checking 'hlt' instruction... OK.
[    0.096993] ACPI: Core revision 20070126
[    0.113365] CPU0: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.113520] Booting processor 1/1 ip 4000
[    0.113561] CPU 1 irqstacks, hard=c0430000 soft=c042e000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 3663.40 BogoMIPS (lpj=6103041)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#1.
[    0.207079] CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.207533] Total of 2 processors activated (7329.16 BogoMIPS).
[    0.207766] ENABLING IO-APIC IRQs
[    0.207981] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.243317] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.243322] Brought up 2 CPUs
[    0.243379] CPU0 attaching sched-domain:
[    0.243381]  domain 0: span 3
[    0.243383]   groups: 1 2
[    0.243386] CPU1 attaching sched-domain:
[    0.243388]  domain 0: span 3
[    0.243390]   groups: 2 1
[    0.243619] net_namespace: 448 bytes
[    0.243819] NET: Registered protocol family 16
[    0.244032] No dock devices found.
[    0.244147] ACPI: bus type pci registered
[    0.244266] PCI: Using MMCONFIG for extended config space
[    0.244308] PCI: Fatal: No config space access function found
[    0.244350] Setting up standard PCI resources
[    0.246122] ACPI: EC: EC description table is found, configuring boot EC
[    0.246365] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.248798] ACPI: BIOS _OSI(Linux) query ignored via DMI
[    0.250087] ACPI: Interpreter enabled
[    0.250128] ACPI: (supports S0 S3 S4 S5)
[    0.250293] ACPI: Using IOAPIC for interrupt routing
[    0.264919] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.264963] ACPI: EC: driver started in poll mode
[    0.266236] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.266892] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.266946] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.267719] PCI: Transparent bridge - 0000:00:1e.0
[    0.267794] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.268148] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.268284] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.268416] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.268547] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.268688] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.275623] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.276130] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.276599] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.277092] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.277558] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.278090] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.278622] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.279124] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.279826] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.279895] pnp: PnP ACPI init
[    0.279940] ACPI: bus type pnp registered
[    0.282785] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.288829] pnp: PnP ACPI: found 10 devices
[    0.288870] ACPI: ACPI bus type pnp unregistered
[    0.289233] SCSI subsystem initialized
[    0.289321] libata version 3.00 loaded.
[    0.289502] PCI: Using ACPI for IRQ routing
[    0.289542] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.289594] PCI: System does not support PCI
[    0.289635] PCI: System does not support PCI
[    0.293333] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
[    0.293491] hpet0: 3 64-bit timers, 14318180 Hz
[    0.296646] Time: tsc clocksource has been installed.
[    0.299993] system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.300046] system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
[    0.300097] system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
[    0.300149] system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
[    0.301493] system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
[    0.301544] system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.301593] system 00:06: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.301641] system 00:08: ioport range 0x680-0x6ef has been reserved
[    0.301684] system 00:08: ioport range 0x800-0x80f has been reserved
[    0.301727] system 00:08: ioport range 0x810-0x817 has been reserved
[    0.301770] system 00:08: ioport range 0x400-0x47f has been reserved
[    0.301813] system 00:08: ioport range 0x500-0x53f has been reserved
[    0.301856] system 00:08: ioport range 0x1640-0x164f has been reserved
[    0.332422] PCI: Bridge: 0000:00:01.0
[    0.332463]   IO window: 2000-2fff
[    0.332504]   MEM window: 0x94000000-0x940fffff
[    0.332545]   PREFETCH window: 0x0000000088000000-0x0000000093ffffff
[    0.332600] PCI: Bridge: 0000:00:1c.0
[    0.332641]   IO window: 3000-3fff
[    0.332684]   MEM window: 0x94100000-0x941fffff
[    0.332726]   PREFETCH window: 0x0000000094200000-0x00000000942fffff
[    0.332780] PCI: Bridge: 0000:00:1c.1
[    0.332820]   IO window: disabled.
[    0.332863]   MEM window: 0x94300000-0x943fffff
[    0.332906]   PREFETCH window: disabled.
[    0.332950] PCI: Bridge: 0000:00:1c.2
[    0.332989]   IO window: disabled.
[    0.333033]   MEM window: disabled.
[    0.333074]   PREFETCH window: disabled.
[    0.333120] PCI: Bridge: 0000:00:1e.0
[    0.333160]   IO window: disabled.
[    0.333204]   MEM window: 0x00000000-0x000fffff
[    0.333246]   PREFETCH window: disabled.
[    0.333297] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.333359] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.333378] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.333461] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.333479] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
[    0.333562] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.333581] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[    0.333663] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.333674] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.333684] NET: Registered protocol family 2
[    0.346684] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.346923] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.347635] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.348007] TCP: Hash tables configured (established 131072 bind 65536)
[    0.348051] TCP reno registered
[    0.110357] Machine check exception polling timer started.
[    0.110842] highmem bounce pool size: 64 pages
[    0.110886] Total HugeTLB memory allocated, 0
[    0.112927] VFS: Disk quotas dquot_6.5.1
[    0.112991] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.113590] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.113642] io scheduler noop registered
[    0.113683] io scheduler anticipatory registered
[    0.113725] io scheduler deadline registered
[    0.113815] io scheduler cfq registered (default)
[    0.114052] pci 0000:01:00.0: Boot video device
[    0.114123] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.114139] assign_interrupt_mode Found MSI capability
[    0.114196] Allocate Port Service[0000:00:01.0:pcie00]
[    0.114233] Allocate Port Service[0000:00:01.0:pcie03]
[    0.114294] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.114330] assign_interrupt_mode Found MSI capability
[    0.114405] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.114439] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.114472] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.114557] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.114593] assign_interrupt_mode Found MSI capability
[    0.114668] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.114701] Allocate Port Service[0000:00:1c.1:pcie02]
[    0.114734] Allocate Port Service[0000:00:1c.1:pcie03]
[    0.114819] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.114855] assign_interrupt_mode Found MSI capability
[    0.114929] Allocate Port Service[0000:00:1c.2:pcie00]
[    0.114967] Allocate Port Service[0000:00:1c.2:pcie02]
[    0.115000] Allocate Port Service[0000:00:1c.2:pcie03]
[    0.136134] hpet_resources: 0xfed00000 is busy
[    0.136181] Linux agpgart interface v0.103
[    0.136264] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.136353] PCI: Setting latency timer of device 0000:02:00.0 to 64
[    0.136377] sky2 0000:02:00.0: v1.21 addr 0x94100000 irq 16 Yukon-EC (0xb6) rev 2
[    0.380284] sky2 eth0: addr 00:16:cb:8c:b2:65
[    0.380377] console [netcon0] enabled
[    0.383310] netconsole: network logging started
[    0.383406] input: Macintosh mouse button emulation as /class/input/input0
[    0.383493] Driver 'sd' needs updating - please use bus_type methods
[    0.383613] ata_piix 0000:00:1f.1: version 2.12
[    0.383620] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    0.383726] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    0.383803] scsi0 : ata_piix
[    0.383907] scsi1 : ata_piix
[    0.384473] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x10a0 irq 14
[    0.384518] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x10a8 irq 15
[    0.263323] Switched to high resolution mode on CPU 1
[    0.503303] Switched to high resolution mode on CPU 0
[    0.280560] ata1.00: ATAPI: MATSHITADVD-R   UJ-857, HAEA, max UDMA/66
[    0.290510] ata1.00: configured for UDMA/66
[    0.506633] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857   HAEA PQ: 0 ANSI: 5
[    0.506633] PCI: Enabling device 0000:00:1f.2 (0005 -> 0007)
[    0.506633] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    0.506633] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    0.513308] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    0.513349] scsi2 : ata_piix
[    0.513460] scsi3 : ata_piix
[    0.514462] ata3: SATA max UDMA/133 cmd 0x10c0 ctl 0x10d0 bmdma 0x10b0 irq 19
[    0.514507] ata4: SATA max UDMA/133 cmd 0x10c8 ctl 0x10d4 bmdma 0x10b8 irq 19
[    0.533298] ata3.01: ATA-7: WDC WD1600BEVS-00RST0, 04.01G04, max UDMA/133
[    0.533298] ata3.01: 312581808 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    0.537577] ata3.01: configured for UDMA/133
[    0.543298] scsi 2:0:1:0: Direct-Access     ATA      WDC WD1600BEVS-0 04.0 PQ: 0 ANSI: 5
[    0.543298] sd 2:0:1:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    0.543298] sd 2:0:1:0: [sda] Write Protect is off
[    0.543298] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    0.543298] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.543298] sd 2:0:1:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    0.543298] sd 2:0:1:0: [sda] Write Protect is off
[    0.543298] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    0.543298] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.543298]  sda: sda1 sda2 sda3 sda4 sda6
[    0.554221] sd 2:0:1:0: [sda] Attached SCSI disk
[    0.554501] PNP: No PS/2 controller found. Probing ports directly.
[    0.555415] i8042.c: No controller found.
[    0.556670] mice: PS/2 mouse device common for all mice
[    0.556817] device-mapper: uevent: version 1.0.3
[    0.556914] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    0.556975] cpuidle: using governor ladder
[    0.557015] cpuidle: using governor menu
[    0.557444] TCP cubic registered
[    0.557491] NET: Registered protocol family 1
[    0.557542] NET: Registered protocol family 17
[    0.557588] Using IPI No-Shortcut mode
[    0.356644] kjournald starting.  Commit interval 5 seconds
[    0.566629] EXT3-fs: mounted filesystem with ordered data mode.
[    0.566629] VFS: Mounted root (ext3 filesystem) readonly.
[    0.566629] Freeing unused kernel memory: 252k freed
[    0.972485] Driver 'sr' needs updating - please use bus_type methods
[    0.974182] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    0.974186] Uniform CD-ROM driver Revision: 3.20
[    0.974235] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.314021] input: Power Button (FF) as /class/input/input1
[    1.356631] ACPI: Power Button (FF) [PWRF]
[    1.356692] input: Lid Switch as /class/input/input2
[    1.368042] ACPI: Lid Switch [LID0]
[    1.368169] input: Power Button (CM) as /class/input/input3
[    1.377974] ACPI: SSDT 7FEB3C90, 022A (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
[    1.378273] ACPI: SSDT 7FEB2C10, 02C3 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
[    1.378598] Monitor-Mwait will be used to enter C-1 state
[    1.378602] Monitor-Mwait will be used to enter C-2 state
[    1.378604] Monitor-Mwait will be used to enter C-3 state
[    1.379562] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.379590] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.379594] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.379954] ACPI: SSDT 7FEB3F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
[    1.380192] ACPI: SSDT 7FEB2F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
[    1.113147] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.113166] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.113171] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.114648] Marking TSC unstable due to: TSC halts in idle.
[    1.383244] Time: hpet clocksource has been installed.
[    1.389202] ACPI: Power Button (CM) [PWRB]
[    1.389263] input: Sleep Button (CM) as /class/input/input4
[    1.400291] ACPI: Sleep Button (CM) [SLPB]
[    1.148322] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.148441] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    1.510068] ACPI: Battery Slot [BAT0] (battery present)
[    1.510068] ACPI: AC Adapter [ADP1] (on-line)
[    1.393411] tpm_inf_pnp 00:03: Found TPM with ID IFX0101
[    1.393466] tpm_inf_pnp 00:03: TPM found: config base 0x4e, data base 0x4700, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[    1.660083] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[    1.660148] iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x0460)
[    1.660189] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.710431] intel_rng: FWH not detected
[    1.943615] usbcore: registered new interface driver usbfs
[    1.943639] usbcore: registered new interface driver hub
[    1.943684] usbcore: registered new device driver usb
[    1.975483] USB Universal Host Controller Interface driver v3.0
[    1.975483] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    1.975483] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    1.975483] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.975483] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    1.975483] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001000
[    1.975483] usb usb1: configuration #1 chosen from 1 choice
[    1.975483] hub 1-0:1.0: USB hub found
[    1.975483] hub 1-0:1.0: 2 ports detected
[    1.850174] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    1.850192] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    1.850198] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.850250] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    1.850286] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001020
[    1.850436] usb usb2: configuration #1 chosen from 1 choice
[    1.850460] hub 2-0:1.0: USB hub found
[    1.850467] hub 2-0:1.0: 2 ports detected
[    1.952720] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    1.952737] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    1.952744] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.952786] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    1.952829] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001040
[    1.952992] usb usb3: configuration #1 chosen from 1 choice
[    1.953016] hub 3-0:1.0: USB hub found
[    1.953022] hub 3-0:1.0: 2 ports detected
[    2.058355] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[    2.058371] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    2.058377] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.058423] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[    2.058466] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001060
[    2.058614] usb usb4: configuration #1 chosen from 1 choice
[    2.058637] hub 4-0:1.0: USB hub found
[    2.058642] hub 4-0:1.0: 2 ports detected
[    2.288414] usb 1-2: new full speed USB device using uhci_hcd and address 2
[    2.371440] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[    2.371440] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    2.400812] hda_codec: STAC922x, Apple subsys_id=106b0200
[    2.232822] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, low) -> IRQ 19
[    2.232822] ohci1394: Failed to remap registers - card not accessible
[    2.436352] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
[    2.436649] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    2.436661] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    2.436664] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.436696] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[    2.440634] ehci_hcd 0000:00:1d.7: debug port 1
[    2.440640] PCI: cache line size of 128 is not supported by device 0000:00:1d.7
[    2.440647] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x94405000
[    2.452053] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.452224] usb usb5: configuration #1 chosen from 1 choice
[    2.452267] hub 5-0:1.0: USB hub found
[    2.452278] hub 5-0:1.0: 8 ports detected
[    2.457232] usb 1-2: configuration #1 chosen from 1 choice
[    2.461446] usb 1-2: can't set config #1, error -71
[    2.551959] firewire_ohci: Failed to remap registers
[    2.661381] Clocksource tsc unstable (delta = -212541750 ns)
[    2.921334] usb 1-2: USB disconnect, address 2
[    3.494613] usb 5-3: new high speed USB device using ehci_hcd and address 3
[    3.620586] usb 5-3: configuration #1 chosen from 1 choice
[    3.677302] Initializing USB Mass Storage driver...
[    3.699393] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[    3.699685] EXT3 FS on sda3, internal journal
[    3.842640] usb 5-4: new high speed USB device using ehci_hcd and address 4
[    3.962246] usb 5-4: configuration #1 chosen from 1 choice
[    3.861321] loop: module loaded
[    4.115697] tun: Universal TUN/TAP device driver, 1.6
[    4.115703] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.206649] applesmc: Apple MacBook Pro detected:
[    4.206655] applesmc:  - Model with accelerometer
[    4.206658] applesmc:  - Model with light sensors and backlight
[    4.206662] applesmc:  - Model with 12 temperature sensors
[    4.260417] applesmc: device successfully initialized (0xe0, 0x00).
[    4.260423] applesmc: device successfully initialized.
[    4.260891] applesmc: 2 fans found.
[    4.261550] input: applesmc as /class/input/input5
[    4.269374] Registered led device: smc::kbd_backlight
[    4.269408] applesmc: driver successfully loaded.
[    4.409594] usbcore: registered new interface driver appletouch
[    4.218830] scsi4 : SCSI emulation for USB Mass Storage devices
[    4.218957] usbcore: registered new interface driver usb-storage
[    4.218963] USB Mass Storage support registered.
[    4.219351] usb-storage: device found at 3
[    4.219356] usb-storage: waiting for device to settle before scanning
[    4.616357] usb 1-2: new full speed USB device using uhci_hcd and address 3
[    4.792958] usb 1-2: configuration #1 chosen from 1 choice
[    4.809575] appletouch: Geyser mode initialized.
[    4.809667] input: appletouch as /class/input/input6
[    5.058459] usb 3-2: new full speed USB device using uhci_hcd and address 2
[    5.230001] usb 3-2: configuration #1 chosen from 1 choice
[    5.455857] usb 4-1: new full speed USB device using uhci_hcd and address 2
[    5.624419] usb 4-1: configuration #1 chosen from 1 choice
[    5.631405] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input7
[    5.653358] input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[    5.656857] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input8
[    5.658215] input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[    5.663272] HID device claimed by neither input, hiddev nor hidraw
[    5.679820] input: HID 05ac:1000 as /class/input/input9
[    5.679820] input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
[    5.696340] input: HID 05ac:1000 as /class/input/input10
[    5.697840] input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
[    5.697874] usbcore: registered new interface driver usbhid
[    5.697880] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    9.360002] usb-storage: device scan complete
[    9.360751] scsi 4:0:0:0: Direct-Access     Corsair  Flash Voyager    1100 PQ: 0 ANSI: 0 CCS
[    9.361624] sd 4:0:0:0: [sdb] 7929856 512-byte hardware sectors (4060 MB)
[    9.362449] sd 4:0:0:0: [sdb] Write Protect is off
[    9.362455] sd 4:0:0:0: [sdb] Mode Sense: 43 00 00 00
[    9.362459] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    9.365473] sd 4:0:0:0: [sdb] 7929856 512-byte hardware sectors (4060 MB)
[    9.366310] sd 4:0:0:0: [sdb] Write Protect is off
[    9.366315] sd 4:0:0:0: [sdb] Mode Sense: 43 00 00 00
[    9.366319] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    9.366325]  sdb: sdb1 sdb2
[    9.368068] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    9.368136] sd 4:0:0:0: Attached scsi generic sg2 type 0
[   21.214234] kjournald starting.  Commit interval 90 seconds
[   21.214234] EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
[   21.214367] EXT3 FS on dm-1, internal journal
[   21.214367] EXT3-fs: mounted filesystem with ordered data mode.
[   21.673765] Adding 1214416k swap on /dev/mapper/crypt-swap.  Priority:-1 extents:1 across:1214416k
[   23.078844] sky2 eth0: enabling interface
[   24.747111] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
[   36.611868] fuse init (API version 7.9)
[   37.558693] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   38.155411] pktcdvd: writer pktcdvd0 mapped to sr0
[   37.648651] appletouch: incomplete data package (first byte: 2, length: 4).
[   40.117257] CPU0 attaching NULL sched-domain.
[   40.117268] CPU1 attaching NULL sched-domain.
[   40.125459] CPU0 attaching sched-domain:
[   40.125467]  domain 0: span 3
[   40.125470]   groups: 1 2
[   40.125476]   domain 1: span 3
[   40.125479]    groups: 3
[   40.125483] CPU1 attaching sched-domain:
[   40.125487]  domain 0: span 3
[   40.125490]   groups: 2 1
[   40.125494]   domain 1: span 3
[   40.125498]    groups: 3

--------------000609030408010808070402
Content-Type: text/plain;
 name="config1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="config1.txt"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc6
# Mon Mar 24 20:36:48 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
# CONFIG_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_LSF=y
CONFIG_BLK_DEV_BSG=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_EFI=y
# CONFIG_IRQBALANCE is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_BAY=m
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
CONFIG_PCI_GOMMCONFIG=y
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=m
# CONFIG_NF_CT_ACCT is not set
# CONFIG_NF_CONNTRACK_MARK is not set
# CONFIG_NF_CONNTRACK_SECMARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=m
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
# CONFIG_IP_NF_MATCH_RECENT is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
# CONFIG_NF_NAT is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
# CONFIG_BT_HCIUSB_SCO is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
# CONFIG_BT_HCIVHCI is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
CONFIG_CFG80211=m
# CONFIG_NL80211 is not set
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_SIMPLE is not set
# CONFIG_MAC80211_RC_DEFAULT_NONE is not set

#
# Selecting 'y' for an algorithm will
#

#
# build the algorithm into mac80211.
#
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_SIMPLE is not set
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
# CONFIG_MAC80211_DEBUG is not set
# CONFIG_IEEE80211 is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_IEEE1394=m

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set

#
# Controllers
#
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_OHCI1394=m

#
# Protocols
#
# CONFIG_IEEE1394_VIDEO1394 is not set
# CONFIG_IEEE1394_SBP2 is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_RAWIO is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_E1000E_ENABLED is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=m
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_UCB1400 is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_RTC_IRQ=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_TPS65010 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_SENSORS_APPLESMC=m
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_ITCO_WDT=m
# CONFIG_ITCO_VENDOR_SUPPORT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_V4L1 is not set
# CONFIG_VIDEO_V4L1_COMPAT is not set
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_CORE=m
# CONFIG_DVB_CORE_ATTACH is not set
# CONFIG_DVB_CAPTURE_DRIVERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=m
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_CFB_FILLRECT is not set
# CONFIG_FB_CFB_COPYAREA is not set
# CONFIG_FB_CFB_IMAGEBLIT is not set
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_IMAC is not set
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDA_HWDEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=3
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# ALSA SoC audio for Freescale SOCs
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_USB_HIDINPUT_POWERBOOK=y
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_CLEVO_MAIL is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set

#
# Userspace I/O
#
CONFIG_UIO=m
CONFIG_UIO_CIF=m

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_SECURITY is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
# CONFIG_CRYPTO_SEQIV is not set
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_XTS is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_CRC32C is not set
CONFIG_CRYPTO_CAMELLIA=m
# CONFIG_CRYPTO_TEST is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_LGUEST is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--------------000609030408010808070402--
