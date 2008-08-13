Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYHMBMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYHMBMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbYHMBMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:12:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbYHMBMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:12:09 -0400
Date: Tue, 12 Aug 2008 21:11:53 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: console handover badness [was: stack overflow on Sparc64]
In-Reply-To: <20080811.233013.49328708.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0808122053280.31704@hs20-bc2-1.build.redhat.com>
References: <20080620.144128.32005196.davem@davemloft.net>
 <20080620.215139.218732028.davem@davemloft.net>
 <Pine.LNX.4.64.0806211542050.21474@engineering.redhat.com>
 <20080811.233013.49328708.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Aug 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Sat, 21 Jun 2008 15:42:56 -0400 (EDT)
> 
> > On Fri, 20 Jun 2008, David Miller wrote:
> > 
> > > giving a try.
> > >
> > > sparc64: Implement support for IRQ stacks.
> > 
> > For me it doesn't work. Locked up after "console: colour dummy device 
> > 80x25".
> 
> Are you sure you didn't see a "Stack overflow" message on the
> screen? :-)
> 
> That's what I get when I try to boot with your provided
> kernel config.

I think no, it just locked-up solid. There is a problem with console 
handover. See this dmesg that I get on boot.

Notice the lines:
(1) console handover: boot [earlyprom0] -> real [tty0]
and
(2) Console: switching to colour frame buffer device 128x48

At line (1), the kernel disables the PROM console. At line (2) it enables 
framebuffer. Between these lines, the kernel runs with no console at all. 
Everything that is printk'ed between these lines doesn't go to the screen.

If the kernel hits oops at some point between (1) and (2), you don't see 
anything, it just appears as a lockup.

I hit already three crashes that happened between these lines and didn't 
generate any output: this one with interrupt stacks that you have just 
fixed, CONFIG_LOCKDEP+CONFIG_DEBUG_PAGEALLOC crash that I will send you 
patch for, and then boot failure of 2.6.27-rc[12] because of bad memory 
migratetype. Is this migratetype crash a known problem? --- the problem is 
that starting with 2.6.27rc1, I'm getting crash with this backtrace:
__list_add
__free_pages_ok
__free_pages
__free_pages_bootmem
__free_all_bootmem
mem_init
start_kernel_tlb_fixup_code
--- the crash is due to migratetype == 5 in __free_one_page (inlined into 
__free_pages_ok) and because there are only 5 migratettypes, it attempts 
to add to a non-existent list.

The trace can be obtained if I disable console handover in kernel/printk. 
But it should really be somehow rewritten so that the kernel can write 
crashes during boot on console without extra patching --- the PROM console 
is disabled just before the framebuffer is registered and not too early.

Mikulas


PROMLIB: Sun IEEE Boot Prom 'OBP 3.31.0 2001/07/25 20:36'
PROMLIB: Root node compatible: 
Linux version 2.6.26-devel (root@slunicko) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #24 Wed Aug 13 01:25:13 CEST 2008
console [earlyprom0] enabled
ARCH: SUN4U
Ethernet address: 08:00:20:f5:03:81
Kernel: Using 3 locked TLB entries for main kernel image.
Remapping the kernel... done.
OF stdout device is: /pci@1f,0/pci@1,1/SUNW,m64B@2:r1024x768x75
PROM: Built device tree with 44212 bytes of memory.
Top of RAM: 0x27f42000, Total RAM: 0x1ff40000
Memory hole size: 128MB
Entering add_active_range(0, 0, 16384) 0 entries of 256 used
Entering add_active_range(0, 32768, 81791) 1 entries of 256 used
Entering add_active_range(0, 81792, 81825) 2 entries of 256 used
[0000000200000000-fffff80000400000] page_structs=131072 node=0 entry=0/0
[0000000200000000-fffff80000800000] page_structs=131072 node=0 entry=1/0
Allocated 532480 bytes for kernel page tables.
Zone PFN ranges:
  Normal          0 ->    81825
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->    16384
    0:    32768 ->    81791
    0:    81792 ->    81825
On node 0 totalpages: 65440
  Normal zone: 560 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 64880 pages, LIFO batch:15
  Movable zone: 0 pages used for memmap
Booting Linux...
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64880
Kernel command line: root=/dev/hda1 ro
PID hash table entries: 2048 (order: 11, 16384 bytes)
clocksource: mult[2c71c] shift[16]
clockevent: mult[5c28f5c2] shift[32]
Console: colour dummy device 80x25
console handover: boot [earlyprom0] -> real [tty0]
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1648 kB
 per task-struct memory footprint: 2688 bytes
Dentry cache hash table entries: 65536 (order: 6, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 5, 262144 bytes)
Memory: 504888k available (1960k kernel code, 1032k data, 120k init) [fffff80000000000,0000000027f42000]
SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 728.70 BogoMIPS (lpj=1213930)
Mount-cache hash table entries: 512
khelper used greatest stack depth: 11152 bytes left
net_namespace: 456 bytes
NET: Registered protocol family 16
khelper used greatest stack depth: 10544 bytes left
PCI: Probing for controllers.
/pci@1f,0: SABRE PCI Bus Module
/pci@1f,0: PCI IO[1fe02000000] MEM[1ff00000000]
PCI: Scanning PBM /pci@1f,0
khelper used greatest stack depth: 9712 bytes left
ebus0: [auxio] [power] [SUNW,pll] [se] [su] [su] [ecpp] [fdthree] [eeprom] [flashprom] [SUNW,CS4231]
power: Control reg at 1fff1724000
AUXIO: Found device at /pci@1f,0/pci@1,1/ebus@1/auxio@14,726000
/pci@1f,0/pci@1,1/ebus@1/eeprom@14,0: Clock regs at 000001fff1000000
Switched to NOHz mode on CPU #0
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 32768 bytes)
TCP established hash table entries: 16384 (order: 5, 262144 bytes)
TCP bind hash table entries: 16384 (order: 6, 917504 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
Mini RTC Driver
khelper used greatest stack depth: 9696 bytes left
msgmni has been set to 987
io scheduler noop registered
io scheduler cfq registered (default)
atyfb: 3D RAGE PRO (Mach64 GP, PQFP, PCI) [0x4750 rev 0x7c]
atyfb: 4M SGRAM (1:1), 14.31818 MHz XTAL, 230 MHz PLL, 100 Mhz MCLK, 100 MHz XCLK
Console: switching to colour frame buffer device 128x48
atyfb: fb0: ATY Mach64 frame buffer device on PCI
khelper used greatest stack depth: 9520 bytes left
khelper used greatest stack depth: 9504 bytes left
/pci@1f,0/pci@1,1/ebus@1/su@14,3083f8: Keyboard port at 1fff13083f8, irq 6
/pci@1f,0/pci@1,1/ebus@1/su@14,3062f8: Mouse port at 1fff13062f8, irq 7
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
CMD646: IDE controller (0x1095:0x0646 rev 0x03) at  PCI slot 0000:01:03.0
CMD646: MultiWord DMA force limited
CMD646: 100% native mode on irq 14
    ide0: BM-DMA at 0x1fe02c00020-0x1fe02c00027
    ide1: BM-DMA at 0x1fe02c00028-0x1fe02c0002f
Probing IDE interface ide0...
hda: ST38410A, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: MWDMA2 mode selected
Probing IDE interface ide1...
ide0 at 0x1fe02c00000-0x1fe02c00007,0x1fe02c0000a on irq 14
ide1 at 0x1fe02c00010-0x1fe02c00017,0x1fe02c0001a on irq 14 (shared with ide0)
hda: max request size: 128KiB
hda: 16841664 sectors (8622 MB) w/512KiB Cache, CHS=16708/16/63
hda: cache flushes not supported
 hda: hda1 hda3
mice: PS/2 mouse device common for all mice
TCP cubic registered
input: Sun Type 5 keyboard as /devices/root/f005f9c0/f00601b4/f0061504/f0063594/serio0/input/input0
VFS: Mounted root (ext2 filesystem) readonly.
khelper used greatest stack depth: 6592 bytes left
NET: Registered protocol family 1
modprobe used greatest stack depth: 256 bytes left
tail used greatest stack depth: 32 bytes left
gunzip used greatest stack depth: 0 bytes left
input: Sun Mouse as /devices/root/f005f9c0/f00601b4/f0061504/f0064df4/serio1/input/input1
Adding 524272k swap on /swap.  Priority:-1 extents:36 across:529920k
PCI: Enabling device: (0000:01:01.1), cmd 2
sunhme.c:v3.00 June 23, 2006 David S. Miller (davem@davemloft.net)
eth0: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet 08:00:20:f5:03:81
eth0: Link is up using internal transceiver at 100Mb/s, Full Duplex.
