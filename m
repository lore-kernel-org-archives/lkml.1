Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZDXJvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZDXJvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 05:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZDXJvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 05:51:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33629 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZDXJvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 05:51:20 -0400
Date: Fri, 24 Apr 2009 10:51:16 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, benh@kernel.crashing.org
Subject: [BUG] 2.6.30-rc3: BUG triggered on some hugepage usages
Message-ID: <20090424095116.GB14283@csn.ul.ie>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 08:27:57PM -0700, Linus Torvalds wrote:
> Another week, another -rc.
> 

I'm seeing some tests with sysbench+postgres+large pages fail on ppc64
although a very clear pattern is not forming as to what exactly is
causing it. However, the libhugetlbfs regression tests (make && make
func) are triggering the following oops when calling mlock() and so are
likely related.

------------[ cut here ]------------
kernel BUG at arch/powerpc/mm/pgtable.c:243!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in: dm_snapshot dm_mirror dm_region_hash dm_log qla2xxx
loop nfnetlink iptable_filter iptable_nat nf_nat ip_tables
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_tcpudp xt_limit ipt_LOG xt_pkttype x_tables
NIP: c00000000002becc LR: c00000000002c02c CTR: 0000000000000000
REGS: c0000000ea92b4c0 TRAP: 0700   Not tainted  (2.6.30-rc3-autokern1)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28000484  XER: 20000020
TASK = c00000000395b660[7611] 'mlock' THREAD: c0000000ea928000 CPU: 3
GPR00: 0000000000000001 c0000000ea92b740 c0000000008ea170 c0000000ec7d4980 
GPR04: 000000003f000000 c0000001e2278cf8 0000001900000393 0000000000000001 
GPR08: f000000002bc0000 0000000000000000 0000000000000113 c0000001e2278c81 
GPR12: 0000000044000482 c00000000093b880 0000000028004422 0000000000000000 
GPR16: c0000000ea92bbf0 c0000000009f06f0 0000001900000113 c0000000ec7d4980 
GPR20: 0000000000000000 f000000002bc0000 000000003f000000 c0000001e2278cf8 
GPR24: c0000000eaa90bb0 0000000000000000 c0000000eaa90bb0 c0000000ea928000 
GPR28: f000000002bc0000 0000001900000393 0000000000000001 c0000001e2278cf8 
NIP [c00000000002becc] .assert_pte_locked+0x54/0x8c
LR [c00000000002c02c] .ptep_set_access_flags+0x50/0x8c
Call Trace:
[c0000000ea92b740] [c0000000eaa90bb0] 0xc0000000eaa90bb0 (unreliable)
[c0000000ea92b7d0] [c0000000000ed1b0] .hugetlb_cow+0xd4/0x654
[c0000000ea92b900] [c0000000000edbf0] .hugetlb_fault+0x4c0/0x708
[c0000000ea92b9f0] [c0000000000ee890] .follow_hugetlb_page+0x174/0x364
[c0000000ea92bae0] [c0000000000d8d30] .__get_user_pages+0x288/0x4c0
[c0000000ea92bbb0] [c0000000000da10c] .make_pages_present+0xa0/0xe0
[c0000000ea92bc40] [c0000000000db758] .mlock_fixup+0x90/0x228
[c0000000ea92bd00] [c0000000000dbb38] .do_mlock+0xc4/0x128
[c0000000ea92bda0] [c0000000000dbccc] .SyS_mlock+0xb0/0xec
[c0000000ea92be30] [c00000000000852c] syscall_exit+0x0/0x40
Instruction dump:
0b000000 78892662 79291f24 7d69582a 7d600074 7800d182 0b000000 78895e62 
79291f24 7d29582a 7d200074 7800d182 <0b000000> 3c004000 3960ffff
780007c6 
---[ end trace 36a7faa04fa9452b ]---

This corresponds to

#ifdef CONFIG_DEBUG_VM
void assert_pte_locked(struct mm_struct *mm, unsigned long addr)
{
        pgd_t *pgd;
        pud_t *pud;
        pmd_t *pmd;

        if (mm == &init_mm)
                return;
        pgd = mm->pgd + pgd_index(addr);
        BUG_ON(pgd_none(*pgd));
        pud = pud_offset(pgd, addr);
        BUG_ON(pud_none(*pud));
        pmd = pmd_offset(pud, addr);
        BUG_ON(!pmd_present(*pmd));			<----- THIS LINE
        BUG_ON(!spin_is_locked(pte_lockptr(mm, pmd)));
}
#endif /* CONFIG_DEBUG_VM */

This area was last changed by commit 8d30c14cab30d405a05f2aaceda1e9ad57800f36
in the 2.6.30-rc1 timeframe. I think there was another hugepage-related
problem with this patch but I can't remember what it was. Full dmesg is


==== dmesg ====
Using pSeries machine description
Page orders: linear mapping = 24, virtual = 12, io = 12, vmemmap = 24
Found initrd at 0xc000000003300000:0xc000000004b67000
console [udbg0] enabled
Partition configured for 8 cpus.
CPU maps initialized for 2 threads per core
 (thread shift is 1)
Starting Linux PPC64 #1 SMP Fri Apr 24 09:08:10 UTC 2009
-----------------------------------------------------
ppc64_pft_size                = 0x1b
physicalMemorySize            = 0x1e8000000
htab_hash_mask                = 0xfffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Linux version 2.6.30-rc3-autokern1 (root@elm3a121) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Fri Apr 24 09:08:10 UTC 2009
[boot]0012 Setup Arch
Node 0 Memory: 0x0-0xee000000
Node 1 Memory: 0xee000000-0x1e8000000
PCI host bridge /pci@800000020000001  ranges:
  IO 0x000003fe00100000..0x000003fe001fffff -> 0x0000000000000000
 MEM 0x0000040080000000..0x00000400bfffffff -> 0x00000000c0000000 
PCI host bridge /pci@800000020000002  ranges:
  IO 0x000003fe00600000..0x000003fe006fffff -> 0x0000000000000000
 MEM 0x0000040100000000..0x000004017fffffff -> 0x0000000080000000 
PCI host bridge /pci@800000020000003  ranges:
  IO 0x000003fe00300000..0x000003fe003fffff -> 0x0000000000000000
 MEM 0x00000400c0000000..0x00000400ffffffff -> 0x00000000c0000000 
EEH: PCI Enhanced I/O Error Handling Enabled
PPC64 nvram contains 7168 bytes
Using dedicated idle loop
Zone PFN ranges:
  DMA      0x00000000 -> 0x001e8000
  Normal   0x001e8000 -> 0x001e8000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x000ee000
    1: 0x000ee000 -> 0x001e8000
On node 0 totalpages: 974848
  DMA zone: 13328 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 961520 pages, LIFO batch:31
On node 1 totalpages: 1024000
  DMA zone: 14000 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 1010000 pages, LIFO batch:31
[boot]0015 Setup Done
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 1971520
Policy zone: DMA
Kernel command line: loglevel=8 autobench_args: root=/dev/sda3 ABAT:1240564260 loglevel=8 
NR_IRQS:512
[boot]0020 XICS Init
[boot]0021 XICS Done
pic: no ISA interrupt controller
PID hash table entries: 4096 (order: 12, 32768 bytes)
time_init: decrementer frequency = 238.060000 MHz
time_init: processor frequency   = 1904.480000 MHz
clocksource: timebase mult[10cd6fc] shift[22] registered
clockevent: decrementer mult[3cf1] shift[16] cpu[0]
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [hvc0]
freeing bootmem node 0
freeing bootmem node 1
Memory: 7834904k/7995392k available (7808k kernel code, 160488k reserved, 1312k data, 1010k bss, 324k init)
SLUB: Genslabs=14, HWalign=128, Order=0-3, MinObjects=0, CPUs=8, Nodes=16
Calibrating delay loop... 475.13 BogoMIPS (lpj=950272)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
irq: irq 2 on host null mapped to virtual irq 16
clockevent: decrementer mult[3cf1] shift[16] cpu[1]
Processor 1 found.
clockevent: decrementer mult[3cf1] shift[16] cpu[2]
Processor 2 found.
clockevent: decrementer mult[3cf1] shift[16] cpu[3]
Processor 3 found.
clockevent: decrementer mult[3cf1] shift[16] cpu[4]
Processor 4 found.
clockevent: decrementer mult[3cf1] shift[16] cpu[5]
Processor 5 found.
clockevent: decrementer mult[3cf1] shift[16] cpu[6]
Processor 6 found.
clockevent: decrementer mult[3cf1] shift[16] cpu[7]
Processor 7 found.
Brought up 8 CPUs
Node 0 CPUs: 0-3
Node 1 CPUs: 4-7
CPU0 attaching sched-domain:
 domain 0: span 0-1 level SIBLING
  groups: 0 1
  domain 1: span 0-3 level CPU
   groups: 0-1 2-3
   domain 2: span 0-7 level NODE
    groups: 0-3 (__cpu_power = 2048) 4-7 (__cpu_power = 2048)
CPU1 attaching sched-domain:
 domain 0: span 0-1 level SIBLING
  groups: 1 0
  domain 1: span 0-3 level CPU
   groups: 0-1 2-3
   domain 2: span 0-7 level NODE
    groups: 0-3 (__cpu_power = 2048) 4-7 (__cpu_power = 2048)
CPU2 attaching sched-domain:
 domain 0: span 2-3 level SIBLING
  groups: 2 3
  domain 1: span 0-3 level CPU
   groups: 2-3 0-1
   domain 2: span 0-7 level NODE
    groups: 0-3 (__cpu_power = 2048) 4-7 (__cpu_power = 2048)
CPU3 attaching sched-domain:
 domain 0: span 2-3 level SIBLING
  groups: 3 2
  domain 1: span 0-3 level CPU
   groups: 2-3 0-1
   domain 2: span 0-7 level NODE
    groups: 0-3 (__cpu_power = 2048) 4-7 (__cpu_power = 2048)
CPU4 attaching sched-domain:
 domain 0: span 4-5 level SIBLING
  groups: 4 5
  domain 1: span 4-7 level CPU
   groups: 4-5 6-7
   domain 2: span 0-7 level NODE
    groups: 4-7 (__cpu_power = 2048) 0-3 (__cpu_power = 2048)
CPU5 attaching sched-domain:
 domain 0: span 4-5 level SIBLING
  groups: 5 4
  domain 1: span 4-7 level CPU
   groups: 4-5 6-7
   domain 2: span 0-7 level NODE
    groups: 4-7 (__cpu_power = 2048) 0-3 (__cpu_power = 2048)
CPU6 attaching sched-domain:
 domain 0: span 6-7 level SIBLING
  groups: 6 7
  domain 1: span 4-7 level CPU
   groups: 6-7 4-5
   domain 2: span 0-7 level NODE
    groups: 4-7 (__cpu_power = 2048) 0-3 (__cpu_power = 2048)
CPU7 attaching sched-domain:
 domain 0: span 6-7 level SIBLING
  groups: 7 6
  domain 1: span 4-7 level CPU
   groups: 6-7 4-5
   domain 2: span 0-7 level NODE
    groups: 4-7 (__cpu_power = 2048) 0-3 (__cpu_power = 2048)
net_namespace: 1352 bytes
NET: Registered protocol family 16
IBM eBus Device Driver
PCI: Probing PCI hardware
IOMMU table initialized, virtual merging enabled
irq: irq 83 on host null mapped to virtual irq 83
pci 0000:c8:01.0: supports D1 D2
pci 0000:c8:01.0: PME# supported from D0 D1 D2 D3hot
pci 0000:c8:01.0: PME# disabled
pci 0000:c8:01.1: supports D1 D2
pci 0000:c8:01.1: PME# supported from D0 D1 D2 D3hot
pci 0000:c8:01.1: PME# disabled
pci 0000:c8:01.2: supports D1 D2
pci 0000:c8:01.2: PME# supported from D0 D1 D2 D3hot
pci 0000:c8:01.2: PME# disabled
irq: irq 85 on host null mapped to virtual irq 85
pci 0000:d0:01.0: PME# supported from D0 D3hot D3cold
pci 0000:d0:01.0: PME# disabled
pci 0000:d0:01.1: PME# supported from D0 D3hot D3cold
pci 0000:d0:01.1: PME# disabled
irq: irq 87 on host null mapped to virtual irq 87
irq: irq 88 on host null mapped to virtual irq 88
pci 0001:c8:01.0: supports D1 D2
pci 0001:c8:01.0: PME# supported from D0 D1 D2 D3hot
pci 0001:c8:01.0: PME# disabled
irq: irq 165 on host null mapped to virtual irq 165
irq: irq 167 on host null mapped to virtual irq 167
irq: irq 117 on host null mapped to virtual irq 117
pci 0002:d0:01.0: supports D1
irq: irq 119 on host null mapped to virtual irq 119
irq: irq 115 on host null mapped to virtual irq 115
PCI: Probing PCI hardware done
bio: create slab <bio-0> at 0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 2
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 4
Switched to high resolution mode on CPU 5
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 7
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...
rootfs image is not initramfs (junk in compressed archive); looks like an initrd
Freeing initrd memory: 24988k freed
irq: irq 655360 on host null mapped to virtual irq 17
irq: irq 589825 on host null mapped to virtual irq 18
RTAS daemon started
audit: initializing netlink socket (disabled)
type=2000 audit(1240564423.424:1): initialized
HugeTLB registered 16 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 15351
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
matroxfb: Matrox G450 detected
PInS data found at offset 31168
PInS memtype = 5
matroxfb: 640x480x8bpp (virtual: 640x26214)
matroxfb: framebuffer at 0x40170000000, mapped to 0xd000080080080000, size 33554432
Console: switching to colour frame buffer device 80x30
fb0: MATROX frame buffer device
matroxfb_crtc2: secondary head of fb0 was registered as fb1
vio_register_driver: driver hvc_console registering
HVSI: registered 0 devices
Generic RTC Driver v1.07
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
brd: module loaded
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
ide-cd driver 5.00
ipr: IBM Power RAID SCSI Device Driver version: 2.4.2 (January 21, 2009)
ipr 0000:c0:01.0: enabling device (0140 -> 0142)
ipr 0000:c0:01.0: Found IOA with IRQ: 83
ipr 0000:c0:01.0: Initializing IOA.
ipr 0000:c0:01.0: Starting IOA initialization sequence.
ipr 0000:c0:01.0: Adapter firmware version: 020A004E
ipr 0000:c0:01.0: IOA initialized.
scsi0 : IBM 570B Storage Adapter
scsi 0:0:15:0: Enclosure         IBM      VSBPD3E   U4SCSI 4812 PQ: 0 ANSI: 2
scsi: unknown device type 31
scsi 0:255:255:255: No Device         IBM      570B001          0150 PQ: 0 ANSI: 0
ipr 0002:c8:01.0: Found IOA with IRQ: 117
ipr 0002:c8:01.0: Starting IOA initialization sequence.
ipr 0002:c8:01.0: Adapter firmware version: 020A004E
ipr 0002:c8:01.0: IOA initialized.
scsi1 : IBM 570B Storage Adapter
scsi 1:0:4:0: Direct-Access     IBM   H0 HUS103014FL3800  RPQF PQ: 0 ANSI: 4
scsi 1:0:5:0: Direct-Access     IBM      ST373453LC       C51A PQ: 0 ANSI: 3
scsi 1:0:15:0: Enclosure         IBM      VSBPD3E   U4SCSI 4812 PQ: 0 ANSI: 2
scsi: unknown device type 31
scsi 1:255:255:255: No Device         IBM      570B001          0150 PQ: 0 ANSI: 0
vio_register_driver: driver ibmvscsi registering
st: Version 20081215, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
scsi 0:0:15:0: Attached scsi generic sg0 type 13
scsi 0:255:255:255: Attached scsi generic sg1 type 31
sd 1:0:4:0: Attached scsi generic sg2 type 0
sd 1:0:5:0: Attached scsi generic sg3 type 0
scsi 1:0:15:0: Attached scsi generic sg4 type 13
scsi 1:255:255:255: Attached scsi generic sg5 type 31
Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000 0000:d0:01.0: enabling device (0140 -> 0143)
sd 1:0:4:0: [sda] 286748000 512-byte hardware sectors: (146 GB/136 GiB)
sd 1:0:5:0: [sdb] 143374000 512-byte hardware sectors: (73.4 GB/68.3 GiB)
sd 1:0:5:0: [sdb] Write Protect is off
sd 1:0:5:0: [sdb] Mode Sense: cb 00 10 08
sd 1:0:5:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1 sdb2 sdb3
sd 1:0:5:0: [sdb] Attached SCSI disk
sd 1:0:4:0: [sda] Write Protect is off
sd 1:0:4:0: [sda] Mode Sense: d3 00 10 08
sd 1:0:4:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
e1000: 0000:d0:01.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:09:6b:dd:0d:9c
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000 0000:d0:01.1: enabling device (0140 -> 0143)
sd 1:0:4:0: [sda] Attached SCSI disk
e1000: 0000:d0:01.1: e1000_probe: (PCI-X:133MHz:64-bit) 00:09:6b:dd:0d:9d
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
drivers/net/ibmveth.c: ibmveth: IBM i/pSeries Virtual Ethernet Driver 1.03
vio_register_driver: driver ibmveth registering
console [netcon0] enabled
netconsole: network logging started
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:c8:01.2: enabling device (0140 -> 0142)
ehci_hcd 0000:c8:01.2: EHCI Host Controller
ehci_hcd 0000:c8:01.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:c8:01.2: Enabling legacy PCI PM
ehci_hcd 0000:c8:01.2: irq 85, io mem 0x400a0002000
ehci_hcd 0000:c8:01.2: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:c8:01.0: OHCI Host Controller
ohci_hcd 0000:c8:01.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:c8:01.0: irq 85, io mem 0x400a0001000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ohci_hcd 0000:c8:01.1: OHCI Host Controller
ohci_hcd 0000:c8:01.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:c8:01.1: irq 85, io mem 0x400a0000000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
oprofile: using ppc64/power5 performance monitoring.
IPv4 over IPv4 tunneling driver
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
registered taskstats version 1
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
RAMDISK: cramfs filesystem found at block 0
RAMDISK: Loading 24988KiB [1 disk] into ram disk... done.
VFS: Mounted root (cramfs filesystem) readonly on device 1:0.
Freeing unused kernel memory: 324k freed
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
loop: module loaded
QLogic Fibre Channel HBA Driver: 8.03.01-k1
qla2xxx 0001:d0:01.0: enabling device (0140 -> 0143)
qla2xxx 0001:d0:01.0: Found an ISP2300, irq 167, iobase 0xd00008008001a000
qla2xxx 0001:d0:01.0: Configuring PCI space...
qla2xxx 0001:d0:01.0: Configure NVRAM parameters...
qla2xxx 0001:d0:01.0: Verifying loaded RISC code...
qla2xxx 0001:d0:01.0: firmware: requesting ql2300_fw.bin
qla2xxx 0001:d0:01.0: Firmware image unavailable.
qla2xxx 0001:d0:01.0: Firmware images can be retrieved from: ftp://ftp.qlogic.com/outgoing/linux/firmware/.
qla2xxx 0001:d0:01.0: Failed to initialize adapter
qla2xxx 0002:c0:01.0: enabling device (0140 -> 0143)
qla2xxx 0002:c0:01.0: Found an ISP2300, irq 115, iobase 0xd00008008001e000
qla2xxx 0002:c0:01.0: Configuring PCI space...
qla2xxx 0002:c0:01.0: Configure NVRAM parameters...
qla2xxx 0002:c0:01.0: Verifying loaded RISC code...
qla2xxx 0002:c0:01.0: firmware: requesting ql2300_fw.bin
qla2xxx 0002:c0:01.0: Firmware image unavailable.
qla2xxx 0002:c0:01.0: Firmware images can be retrieved from: ftp://ftp.qlogic.com/outgoing/linux/firmware/.
qla2xxx 0002:c0:01.0: Failed to initialize adapter
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
EXT3 FS on sda3, internal journal
e1000: lan0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
------------[ cut here ]------------
kernel BUG at arch/powerpc/mm/pgtable.c:243!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in: dm_snapshot dm_mirror dm_region_hash dm_log qla2xxx loop nfnetlink iptable_filter iptable_nat nf_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp xt_limit ipt_LOG xt_pkttype x_tables
NIP: c00000000002becc LR: c00000000002c02c CTR: 0000000000000000
REGS: c0000000ea92b4c0 TRAP: 0700   Not tainted  (2.6.30-rc3-autokern1)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28000484  XER: 20000020
TASK = c00000000395b660[7611] 'mlock' THREAD: c0000000ea928000 CPU: 3
GPR00: 0000000000000001 c0000000ea92b740 c0000000008ea170 c0000000ec7d4980 
GPR04: 000000003f000000 c0000001e2278cf8 0000001900000393 0000000000000001 
GPR08: f000000002bc0000 0000000000000000 0000000000000113 c0000001e2278c81 
GPR12: 0000000044000482 c00000000093b880 0000000028004422 0000000000000000 
GPR16: c0000000ea92bbf0 c0000000009f06f0 0000001900000113 c0000000ec7d4980 
GPR20: 0000000000000000 f000000002bc0000 000000003f000000 c0000001e2278cf8 
GPR24: c0000000eaa90bb0 0000000000000000 c0000000eaa90bb0 c0000000ea928000 
GPR28: f000000002bc0000 0000001900000393 0000000000000001 c0000001e2278cf8 
NIP [c00000000002becc] .assert_pte_locked+0x54/0x8c
LR [c00000000002c02c] .ptep_set_access_flags+0x50/0x8c
Call Trace:
[c0000000ea92b740] [c0000000eaa90bb0] 0xc0000000eaa90bb0 (unreliable)
[c0000000ea92b7d0] [c0000000000ed1b0] .hugetlb_cow+0xd4/0x654
[c0000000ea92b900] [c0000000000edbf0] .hugetlb_fault+0x4c0/0x708
[c0000000ea92b9f0] [c0000000000ee890] .follow_hugetlb_page+0x174/0x364
[c0000000ea92bae0] [c0000000000d8d30] .__get_user_pages+0x288/0x4c0
[c0000000ea92bbb0] [c0000000000da10c] .make_pages_present+0xa0/0xe0
[c0000000ea92bc40] [c0000000000db758] .mlock_fixup+0x90/0x228
[c0000000ea92bd00] [c0000000000dbb38] .do_mlock+0xc4/0x128
[c0000000ea92bda0] [c0000000000dbccc] .SyS_mlock+0xb0/0xec
[c0000000ea92be30] [c00000000000852c] syscall_exit+0x0/0x40
Instruction dump:
0b000000 78892662 79291f24 7d69582a 7d600074 7800d182 0b000000 78895e62 
79291f24 7d29582a 7d200074 7800d182 <0b000000> 3c004000 3960ffff 780007c6 
---[ end trace 36a7faa04fa9452b ]---

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
