Return-Path: <linux-kernel-owner+w=401wt.eu-S1763584AbXHCQFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763584AbXHCQFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761079AbXHCQFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:05:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:37219 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760023AbXHCQE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:04:59 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX18oHosh3Foo8n6FmlZ6H+KW7F9KGtbWpI2GWvnXIe
	UpjWLpppIT2t7d
FCC: imap://jimis@mango.hep.ntua.gr/gmx/sent
X-Identity-Key: id1
Message-Id: <200708031903.10063.jimis@gmx.net>
Date: Fri, 3 Aug 2007 18:03:09 +0200
From: Dimitrios Apostolou <jimis@gmx.net>
X-Mozilla-Draft-Info: internal/draft; vcard=0; receipt=0; uuencode=0
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SeaMonkey/1.0.8
MIME-Version: 1.0
Subject: high system cpu load during intense disk i/o
X-Length: 2955
To: linux-kernel@vger.kernel.org
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_+G1sG5l86eCKvV5"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_+G1sG5l86eCKvV5
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello list,

I have a P3, 256MB RAM system with 3 IDE disks attached, 2 identical 
ones as hda and hdc (primary and secondary master), and the disc with 
the OS partitions as primary slave hdb. For more info please refer to 
the attached dmesg.txt. I attach several oprofile outputs that describe 
various circumstances referenced later. The script I used to get them is 
the attached script.sh. 

The problem was encountered when I started two processes doing heavy I/O 
on hda and hdc, "badblocks -v -w /dev/hda" and "badblocks -v -w 
/dev/hdc". At the beginning (two_discs.txt) everything was fine and 
vmstat reported more than 90% iowait CPU load. However, after a while 
(two_discs_bad.txt) that some cron jobs kicked in, the image changed 
completely: the cpu load was now about 60% system, and the rest was user 
cpu load possibly going to the simple cron jobs.

Even though under normal circumstances (for example when running 
badblocks on only one disc (one_disc.txt)) the cron jobs finish almost 
instantaneously, this time they were simply never ending and every 10 
minutes or so more and more jobs were being added to the process table. 
One day later, the vmstat still reports about 60/40 system/user cpu load, all 
processes still run (hundreds of them), and the load average is huge!

Another day later the OOM killer kicks in and kills various processes, 
however never touches any badblocks process. Indeed, manually suspending 
one badblocks process remedies the situation: within some seconds the 
process table is cleared from cron jobs, cpu usage is back to 2-3% user 
and ~90% iowait and the system is normally responsive again. This 
happens no matter which badblocks process I suspend, being hda or hdc.

Any ideas about what could be wrong? I should note that the kernel is my 
distro's default. As the problem seems to be scheduler specific I didn't 
bother to compile a vanilla kernel, since the applied patches seem 
irrelevant: 

http://archlinux.org/packages/4197/
http://cvs.archlinux.org/cgi-bin/viewcvs.cgi/kernels/kernel26/?cvsroot=Current&only_with_tag=CURRENT


Thank in advance,
Dimitris


P.S.1: Please CC me directly as I'm not subscribed

P.S.2: Keep in mind that the problematic oprofile outputs probably refer 
to much longer time than 5 sec, since due to high load the script was 
taking long to complete.

P.S.3: I couldn't find anywhere in kernel documentation that setting 
nmi_watchdog=0 is neccessary for oprofile to work correctly. However, 
Documentation/nmi_watchdog.txt mentions that oprofile should disable the 
nmi_watchdog automatically, which doesn't happen with the latest kernel.

--Boundary-00=_+G1sG5l86eCKvV5
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.txt"

Linux version 2.6.22-ARCH (root@Wohnung) (gcc version 4.2.1 20070704 (prerelease)) #1 SMP PREEMPT Thu Aug 2 18:27:37 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000fff3000 (ACPI NVS)
 BIOS-e820: 000000000fff3000 - 0000000010000000 (ACPI data)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
255MB LOWMEM available.
Entering add_active_range(0, 0, 65520) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    65520
  HighMem     65520 ->    65520
early_node_map[1] active PFN ranges
    0:        0 ->    65520
On node 0 totalpages: 65520
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 479 pages used for memmap
  Normal zone: 60945 pages, LIFO batch:15
  HighMem zone: 0 pages used for memmap
DMI 2.2 present.
ACPI: RSDP 000F6B30, 0014 (r0 GBT   )
ACPI: RSDT 0FFF3000, 0028 (r1 GBT    AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 0FFF3040, 0074 (r1 GBT    AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 0FFF30C0, 224C (r1 GBT    AWRDACPI     1000 MSFT  100000C)
ACPI: FACS 0FFF0000, 0040
ACPI: PM-Timer IO Port: 0x4008
Allocating PCI resources starting at 20000000 (gap: 10000000:efff0000)
Built 1 zonelists.  Total pages: 65009
Kernel command line: auto BOOT_IMAGE=arch ro root=341 lapic nmi_watchdog=0
Local APIC disabled by BIOS -- reenabling.
Found and enabled local APIC!
mapped APIC to ffffd000 (fee00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 798.025 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 254924k/262080k available (2392k kernel code, 6704k reserved, 787k data, 304k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff82000 - 0xfffff000   ( 500 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xd0800000 - 0xff7fe000   ( 751 MB)
    lowmem  : 0xc0000000 - 0xcfff0000   ( 255 MB)
      .init : 0xc0421000 - 0xc046d000   ( 304 kB)
      .data : 0xc03561df - 0xc041b1bc   ( 787 kB)
      .text : 0xc0100000 - 0xc03561df   (2392 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1597.75 BogoMIPS (lpj=2662004)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0387fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU serial number disabled.
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 11k freed
Early unpacking initramfs... done
ACPI: Core revision 20070126
ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
ACPI: setting ELCR to 0200 (from 1e00)
CPU0: Intel Pentium III (Coppermine) stepping 06
SMP motherboard not detected.
Brought up 1 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb370, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
ACPI: RTC can wake from S4
pnp: 00:00: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:00: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: d8000000-dfffffff
  PREFETCH window: 20000000-200fffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 5, 131072 bytes)
TCP bind hash table entries: 8192 (order: 4, 98304 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 600k freed
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: overridden by ACPI.
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: VIA PCI bridge detected. Disabling DAC.
Activating ISA DMA hang workarounds.
Boot video device is 0000:01:00.0
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
loop: module loaded
input: Macintosh mouse button emulation as /class/input/input0
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
Freeing unused kernel memory: 304k freed
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:07.1
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c596b (rev 12) IDE UDMA66 controller on pci0000:00:07.1
    ide0: BM-DMA at 0xe000-0xe007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xe008-0xe00f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: WDC WD2500JB-55REA0, ATA DISK drive
hdb: MAXTOR 6L020J1, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: WDC WD2500JB-55REA0, ATA DISK drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 512KiB
hda: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63, UDMA(66)
hda: cache flushes supported
 hda: unknown partition table
hdb: max request size: 128KiB
hdb: 40132503 sectors (20547 MB) w/1819KiB Cache, CHS=39813/16/63, UDMA(66)
hdb: cache flushes supported
 hdb: hdb1 hdb2
hdc: max request size: 512KiB
hdc: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63, UDMA(66)
hdc: cache flushes supported
 hdc: unknown partition table
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input3
ACPI: Sleep Button (CM) [SLPB]
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 2 throttling states)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Linux agpgart interface v0.102 (c) Dave Jones
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x0000e400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
agpgart: Detected VIA Apollo Pro 133 chipset
agpgart: AGP aperture is 64M @ 0xe0000000
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 12
PCI: setting IRQ 12 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 12 (level, low) -> IRQ 12
skge 1.11 addr 0xe4000000 irq 12 chip Yukon rev 1
skge eth0: addr 00:0f:38:6a:9c:fe
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
sk98lin: driver has been replaced by the skge driver and is scheduled for removal
AC'97 0 analog subsections not ready
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
PPP generic driver version 2.4.2
input: PC Speaker as /class/input/input4
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.
md: md0 stopped.
EXT3 FS on hdb1, internal journal
ReiserFS: hdb2: found reiserfs format "3.6" with standard journal
ReiserFS: hdb2: using ordered data mode
ReiserFS: hdb2: journal params: device hdb2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hdb2: checking transaction log (hdb2)
ReiserFS: hdb2: Using r5 hash to sort names
skge eth0: enabling interface
skge eth0: Link is up at 1000 Mbps, full duplex, flow control both

--Boundary-00=_+G1sG5l86eCKvV5
Content-Type: application/x-shellscript;
  name="script.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="script.sh"

#!/bin/sh

date
rm -rf /var/lib/oprofile/
set -x
opcontrol --vmlinux=/usr/src/linux-2.6.22-ARCH/vmlinux
opcontrol --start
sleep 5
opcontrol --shutdown
echo; echo; echo;
opreport
echo; echo; echo;
opreport -l /usr/src/linux-2.6.22-ARCH/vmlinux

--Boundary-00=_+G1sG5l86eCKvV5
Content-Type: text/plain;
  charset="iso-8859-1";
  name="two_discs.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="two_discs.txt"

Thu Aug  2 18:36:39 EEST 2007
+ opcontrol --vmlinux=/usr/src/linux-2.6.22-ARCH/vmlinux
+ opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
+ sleep 5
+ opcontrol --shutdown
Stopping profiling.
Killing daemon.
+ echo

+ echo

+ echo

+ opreport
CPU: PIII, speed 798.017 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
     2970 61.0734 vmlinux
      577 11.8651 libc-2.6.so
      450  9.2535 ide_core
      399  8.2048 ld-2.6.so
      244  5.0175 bash
       46  0.9459 ISO8859-1.so
       28  0.5758 ext3
       21  0.4318 jbd
       20  0.4113 grep
       11  0.2262 processor
       11  0.2262 imap-login
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	       10 90.9091 imap-login
	        1  9.0909 anon (tgid:3941 range:0xb7fd9000-0xb7fda000)
       10  0.2056 oprofile
        9  0.1851 ide_disk
        8  0.1645 badblocks
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        5 62.5000 badblocks
	        3 37.5000 anon (tgid:5590 range:0xb7ef6000-0xb7ef7000)
        6  0.1234 gawk
        5  0.1028 skge
        5  0.1028 ophelp
        5  0.1028 libcrypto.so.0.9.8
        5  0.1028 libpopt.so.0.0.0
        5  0.1028 dovecot
        4  0.0823 libext2fs.so.2.4
        4  0.0823 reiserfs
        3  0.0617 libpcre.so.0.0.1
        3  0.0617 dovecot-auth
        2  0.0411 libncurses.so.5.6
        2  0.0411 screen-4.0.3
        2  0.0411 libnetsnmp.so.15.0.0
        2  0.0411 locale-archive
        1  0.0206 tr
        1  0.0206 libreadline.so.5.2
        1  0.0206 librt-2.6.so
        1  0.0206 libssl.so.0.9.8
        1  0.0206 imap
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        1 100.000 anon (tgid:4125 range:0xb7f99000-0xb7f9a000)
        1  0.0206 sshd
+ echo

+ echo

+ echo

+ opreport -l /usr/src/linux-2.6.22-ARCH/vmlinux
CPU: PIII, speed 798.017 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
471      15.8586  acpi_pm_read
416      14.0067  schedule
192       6.4646  __switch_to
111       3.7374  do_wp_page
77        2.5926  find_next_bit
71        2.3906  __handle_mm_fault
65        2.1886  __blockdev_direct_IO
64        2.1549  dequeue_task
49        1.6498  delay_tsc
43        1.4478  unmap_vmas
40        1.3468  do_page_fault
39        1.3131  get_page_from_freelist
30        1.0101  follow_page
30        1.0101  page_fault
29        0.9764  mask_and_ack_8259A
28        0.9428  filemap_nopage
27        0.9091  native_load_tls
24        0.8081  blk_rq_map_sg
24        0.8081  find_get_page
23        0.7744  __link_path_walk
23        0.7744  page_address
20        0.6734  find_vma
19        0.6397  kmem_cache_free
19        0.6397  put_page
18        0.6061  enable_8259A_irq
18        0.6061  radix_tree_lookup
17        0.5724  dio_bio_submit
17        0.5724  strnlen_user
16        0.5387  kmem_cache_alloc
15        0.5051  sysenter_past_esp
14        0.4714  copy_process
13        0.4377  __generic_file_aio_write_nolock
13        0.4377  permission
12        0.4040  __alloc_pages
12        0.4040  __mutex_lock_slowpath
12        0.4040  current_fs_time
12        0.4040  do_mmap_pgoff
12        0.4040  get_user_pages
11        0.3704  generic_make_request
10        0.3367  __d_lookup
10        0.3367  copy_page_range
10        0.3367  find_busiest_group
10        0.3367  kmem_cache_zalloc
9         0.3030  do_lookup
9         0.3030  generic_file_direct_IO
9         0.3030  load_elf_binary
9         0.3030  memcpy
9         0.3030  restore_nocheck
8         0.2694  file_update_time
8         0.2694  inotify_inode_queue_event
7         0.2357  __copy_to_user_ll
7         0.2357  _spin_lock_irqsave
7         0.2357  block_llseek
7         0.2357  deactivate_task
7         0.2357  do_exit
7         0.2357  flush_tlb_page
7         0.2357  generic_unplug_device
7         0.2357  irq_entries_start
7         0.2357  up_read
6         0.2020  __fput
6         0.2020  __make_request
6         0.2020  acpi_os_read_port
6         0.2020  bio_alloc_bioset
6         0.2020  cache_reap
6         0.2020  do_generic_mapping_read
6         0.2020  native_flush_tlb_single
6         0.2020  sys_mprotect
5         0.1684  __add_entropy_words
5         0.1684  __bio_add_page
5         0.1684  copy_strings
5         0.1684  do_path_lookup
5         0.1684  generic_permission
5         0.1684  lru_cache_add_active
5         0.1684  number
5         0.1684  proc_sys_lookup_table_one
5         0.1684  vfs_write
5         0.1684  vm_normal_page
5         0.1684  vm_stat_account
4         0.1347  __kmalloc
4         0.1347  __mutex_unlock_slowpath
4         0.1347  bio_add_page
4         0.1347  blk_backing_dev_unplug
4         0.1347  cpu_idle
4         0.1347  dio_bio_add_page
4         0.1347  dio_bio_complete
4         0.1347  dio_get_page
4         0.1347  do_munmap
4         0.1347  do_sys_poll
4         0.1347  fget_light
4         0.1347  file_read_actor
4         0.1347  filemap_write_and_wait
4         0.1347  find_vma_prepare
4         0.1347  getname
4         0.1347  kernel_read
4         0.1347  notifier_call_chain
4         0.1347  percpu_counter_mod
4         0.1347  preempt_schedule
4         0.1347  rb_first
4         0.1347  secure_ip_id
4         0.1347  strncpy_from_user
4         0.1347  sys_mmap2
3         0.1010  __blocking_notifier_call_chain
3         0.1010  __dentry_open
3         0.1010  __find_get_block
3         0.1010  __find_get_block_slow
3         0.1010  __get_user_4
3         0.1010  __mark_inode_dirty
3         0.1010  __mod_timer
3         0.1010  __pte_alloc
3         0.1010  __vm_enough_memory
3         0.1010  __wake_up_bit
3         0.1010  _atomic_dec_and_lock
3         0.1010  anon_vma_prepare
3         0.1010  blk_remove_plug
3         0.1010  cfq_dispatch_requests
3         0.1010  clear_user
3         0.1010  cond_resched
3         0.1010  copy_from_user
3         0.1010  copy_to_user
3         0.1010  debug_mutex_add_waiter
3         0.1010  dio_cleanup
3         0.1010  dnotify_parent
3         0.1010  do_fork
3         0.1010  do_wait
3         0.1010  dummy_vm_enough_memory
3         0.1010  elv_dispatch_sort
3         0.1010  flush_tlb_mm
3         0.1010  generic_file_direct_write
3         0.1010  getnstimeofday
3         0.1010  lock_timer_base
3         0.1010  may_expand_vm
3         0.1010  mod_timer
3         0.1010  need_resched
3         0.1010  page_cache_readahead
3         0.1010  page_remove_rmap
3         0.1010  path_walk
3         0.1010  pit_next_event
3         0.1010  preempt_schedule_irq
3         0.1010  rb_erase
3         0.1010  restore_all
3         0.1010  should_remove_suid
3         0.1010  submit_page_section
3         0.1010  sys_close
3         0.1010  unmap_region
3         0.1010  vma_link
3         0.1010  vma_prio_tree_add
3         0.1010  vsnprintf
3         0.1010  wake_up_new_task
2         0.0673  __atomic_notifier_call_chain
2         0.0673  __copy_user_intel
2         0.0673  __dec_zone_state
2         0.0673  __do_softirq
2         0.0673  __first_cpu
2         0.0673  __generic_unplug_device
2         0.0673  __inc_zone_page_state
2         0.0673  __inc_zone_state
2         0.0673  add_timer_randomness
2         0.0673  alloc_inode
2         0.0673  blk_do_ordered
2         0.0673  blk_queue_bounce
2         0.0673  blk_recount_segments
2         0.0673  blkdev_direct_IO
2         0.0673  cache_alloc_refill
2         0.0673  cfq_add_rq_rb
2         0.0673  cfq_insert_request
2         0.0673  cfq_remove_request
2         0.0673  debug_mutex_lock_common
2         0.0673  del_timer
2         0.0673  detach_pid
2         0.0673  do_IRQ
2         0.0673  do_select
2         0.0673  do_sync_read
2         0.0673  do_sync_write
2         0.0673  drain_array
2         0.0673  dummy_file_mmap
2         0.0673  elf_map
2         0.0673  elv_completed_request
2         0.0673  elv_insert
2         0.0673  error_code
2         0.0673  file_ra_state_init
2         0.0673  find_extend_vma
2         0.0673  find_mergeable_anon_vma
2         0.0673  free_hot_cold_page
2         0.0673  free_pgtables
2         0.0673  generic_segment_checks
2         0.0673  get_next_timer_interrupt
2         0.0673  get_nr_files
2         0.0673  get_unmapped_area
2         0.0673  hrtimer_interrupt
2         0.0673  idle_cpu
2         0.0673  internal_add_timer
2         0.0673  io_schedule
2         0.0673  ip_append_data
2         0.0673  kmap_atomic
2         0.0673  kmap_atomic_prot
2         0.0673  ktime_get_ts
2         0.0673  link_path_walk
2         0.0673  locks_remove_flock
2         0.0673  max_block
2         0.0673  mempool_alloc
2         0.0673  mempool_free
2         0.0673  mutex_remove_waiter
2         0.0673  nameidata_to_filp
2         0.0673  new_inode
2         0.0673  open_namei
2         0.0673  pipe_read
2         0.0673  prio_tree_insert
2         0.0673  rb_insert_color
2         0.0673  rcu_pending
2         0.0673  remove_suid
2         0.0673  resume_userspace
2         0.0673  rw_verify_area
2         0.0673  sched_clock
2         0.0673  scheduler_tick
2         0.0673  special_mapping_nopage
2         0.0673  split_vma
2         0.0673  submit_bio
2         0.0673  sys_llseek
2         0.0673  sys_rt_sigaction
2         0.0673  sys_write
2         0.0673  syscall_exit
2         0.0673  sysctl_head_next
2         0.0673  system_call
2         0.0673  timespec_trunc
2         0.0673  touch_atime
2         0.0673  vfs_fstat
2         0.0673  vfs_read
2         0.0673  vma_merge
2         0.0673  vma_prio_tree_insert
2         0.0673  xrlim_allow
1         0.0337  I_BDEV
1         0.0337  __brelse
1         0.0337  __do_page_cache_readahead
1         0.0337  __end_that_request_first
1         0.0337  __free_pages
1         0.0337  __getblk
1         0.0337  __init_rwsem
1         0.0337  __ip_route_output_key
1         0.0337  __kfree_skb
1         0.0337  __lru_add_drain
1         0.0337  __page_set_anon_rmap
1         0.0337  __pagevec_lru_add_active
1         0.0337  __pollwait
1         0.0337  __rcu_process_callbacks
1         0.0337  __udp4_lib_rcv
1         0.0337  __vma_link
1         0.0337  __vma_link_rb
1         0.0337  __writeback_single_inode
1         0.0337  acpi_hw_register_read
1         0.0337  acpi_os_write_port
1         0.0337  add_wait_queue
1         0.0337  anon_pipe_buf_release
1         0.0337  anon_vma_unlink
1         0.0337  arch_get_unmapped_area_topdown
1         0.0337  arch_pick_mmap_layout
1         0.0337  arch_setup_additional_pages
1         0.0337  bio_get_nr_vecs
1         0.0337  blkdev_get_blocks
1         0.0337  blockable_page_cache_readahead
1         0.0337  can_share_swap_page
1         0.0337  cfq_choose_req
1         0.0337  cfq_cic_rb_lookup
1         0.0337  cfq_completed_request
1         0.0337  cfq_init_prio_data
1         0.0337  cfq_queue_empty
1         0.0337  cfq_service_tree_add
1         0.0337  cfq_set_request
1         0.0337  check_userspace
1         0.0337  clear_inode
1         0.0337  clockevents_program_event
1         0.0337  copy_thread_group_keys
1         0.0337  count
1         0.0337  cp_new_stat64
1         0.0337  d_alloc
1         0.0337  d_callback
1         0.0337  d_hash_and_lookup
1         0.0337  debug_mutex_free_waiter
1         0.0337  debug_mutex_unlock
1         0.0337  dev_queue_xmit
1         0.0337  disk_round_stats
1         0.0337  do_notify_parent
1         0.0337  do_notify_resume
1         0.0337  do_softirq
1         0.0337  do_sys_open
1         0.0337  down_read_trylock
1         0.0337  dummy_bprm_set_security
1         0.0337  dummy_capable
1         0.0337  dummy_inode_getattr
1         0.0337  dummy_task_wait
1         0.0337  dup_fd
1         0.0337  end_that_request_last
1         0.0337  enqueue_hrtimer
1         0.0337  exit_aio
1         0.0337  exit_sem
1         0.0337  fd_install
1         0.0337  flock64_to_posix_lock
1         0.0337  flush_old_exec
1         0.0337  fn_hash_lookup
1         0.0337  fput
1         0.0337  free_block
1         0.0337  free_pgd_range
1         0.0337  generic_drop_inode
1         0.0337  generic_file_aio_read
1         0.0337  generic_file_llseek
1         0.0337  generic_fillattr
1         0.0337  get_dcookie
1         0.0337  get_empty_filp
1         0.0337  get_request
1         0.0337  get_unused_fd
1         0.0337  handle_level_irq
1         0.0337  hrtimer_try_to_cancel
1         0.0337  icmp_send
1         0.0337  inode_has_buffers
1         0.0337  install_special_mapping
1         0.0337  ip_push_pending_frames
1         0.0337  iput
1         0.0337  key_put
1         0.0337  kfree
1         0.0337  kfree_skb
1         0.0337  kfree_skbmem
1         0.0337  ksoftirqd
1         0.0337  kthread_should_stop
1         0.0337  local_bh_enable_ip
1         0.0337  lock_hrtimer_base
1         0.0337  lock_sock_nested
1         0.0337  lookup_mnt
1         0.0337  mark_page_accessed
1         0.0337  may_open
1         0.0337  mempool_alloc_slab
1         0.0337  mm_release
1         0.0337  msecs_to_jiffies
1         0.0337  native_flush_tlb
1         0.0337  native_io_delay
1         0.0337  native_load_esp0
1         0.0337  native_set_pte_at
1         0.0337  netif_receive_skb
1         0.0337  padzero
1         0.0337  page_add_file_rmap
1         0.0337  pfifo_fast_enqueue
1         0.0337  pipe_poll
1         0.0337  pipe_release
1         0.0337  pipe_write
1         0.0337  prepare_binprm
1         0.0337  proc_flush_task
1         0.0337  profile_pc
1         0.0337  profile_tick
1         0.0337  pty_close
1         0.0337  put_files_struct
1         0.0337  put_pid
1         0.0337  quicklist_trim
1         0.0337  raise_softirq
1         0.0337  rb_next
1         0.0337  rb_prev
1         0.0337  rcu_needs_cpu
1         0.0337  rcu_start_batch
1         0.0337  recalc_sigpending_tsk
1         0.0337  recalc_task_prio
1         0.0337  release_pages
1         0.0337  release_vm86_irqs
1         0.0337  remove_vma
1         0.0337  restore_sigcontext
1         0.0337  ret_from_exception
1         0.0337  run_local_timers
1         0.0337  schedule_delayed_work
1         0.0337  set_binfmt
1         0.0337  setup_arg_pages
1         0.0337  show_stat
1         0.0337  sig_ignored
1         0.0337  sigprocmask
1         0.0337  skb_clone
1         0.0337  sys_fstat64
1         0.0337  sys_lseek
1         0.0337  sys_read
1         0.0337  sys_rt_sigprocmask
1         0.0337  sys_select
1         0.0337  task_rq_lock
1         0.0337  tasklet_action
1         0.0337  tcp_ack
1         0.0337  tick_do_update_jiffies64
1         0.0337  tick_nohz_stop_sched_tick
1         0.0337  try_to_del_timer_sync
1         0.0337  try_to_wake_up
1         0.0337  unix_create1
1         0.0337  unix_poll
1         0.0337  vfs_getattr
1         0.0337  vfs_llseek
1         0.0337  vm_acct_memory
1         0.0337  vma_adjust
1         0.0337  vma_prio_tree_remove
1         0.0337  work_resched

--Boundary-00=_+G1sG5l86eCKvV5
Content-Type: text/plain;
  charset="iso-8859-1";
  name="two_discs_bad.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="two_discs_bad.txt"

Thu Aug  2 18:43:32 EEST 2007
+ opcontrol --vmlinux=/usr/src/linux-2.6.22-ARCH/vmlinux
+ opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
+ sleep 5
+ opcontrol --shutdown
Stopping profiling.
Killing daemon.
+ echo

+ echo

+ echo

+ opreport
CPU: PIII, speed 798.017 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
    16319 45.7794 vmlinux
     6421 18.0127 perl
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	     6420 99.9844 perl
	        1  0.0156 anon (tgid:5897 range:0xb7fdb000-0xb7fdc000)
     4770 13.3812 libpython2.5.so.1.0
     3497  9.8101 libc-2.6.so
     1830  5.1337 ide_core
     1018  2.8558 ld-2.6.so
      290  0.8135 bash
      249  0.6985 oprofiled
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	      246 98.7952 oprofiled
	        3  1.2048 anon (tgid:5878 range:0xb7f71000-0xb7f72000)
      202  0.5667 ext3
      178  0.4993 jbd
      159  0.4460 badblocks
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	      115 72.3270 badblocks
	       27 16.9811 anon (tgid:5590 range:0xb7ef6000-0xb7ef7000)
	       17 10.6918 anon (tgid:5430 range:0xb7f1a000-0xb7f1b000)
      154  0.4320 libpthread-2.6.so
       72  0.2020 imap-login
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	       66 91.6667 imap-login
	        6  8.3333 anon (tgid:3940 range:0xb7f94000-0xb7f95000)
       64  0.1795 oprofile
       56  0.1571 ISO8859-1.so
       51  0.1431 libcrypto.so.0.9.8
       50  0.1403 libext2fs.so.2.4
       48  0.1347 skge
       33  0.0926 ide_disk
       32  0.0898 gawk
       27  0.0757 grep
       17  0.0477 libresolv-2.6.so
       14  0.0393 dovecot-auth
       13  0.0365 libnetsnmp.so.15.0.0
       11  0.0309 libnetsnmpmibs.so.15.0.0
       11  0.0309 libtasn1.so.3.0.10
       10  0.0281 reiserfs
        8  0.0224 dovecot
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        7 87.5000 dovecot
	        1 12.5000 anon (tgid:3919 range:0xb7f01000-0xb7f02000)
        6  0.0168 libncurses.so.5.6
        6  0.0168 locale-archive
        4  0.0112 libdl-2.6.so
        3  0.0084 libm-2.6.so
        2  0.0056 mpop
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        1 50.0000 mpop
	        1 50.0000 anon (tgid:5900 range:0xb7f9d000-0xb7f9e000)
        2  0.0056 libreadline.so.5.2
        2  0.0056 sshd
        1  0.0028 cat
        1  0.0028 ls
        1  0.0028 tr
        1  0.0028 ipv6
        1  0.0028 libnss_dns-2.6.so
        1  0.0028 libnss_files-2.6.so
        1  0.0028 libpcre.so.0.0.1
        1  0.0028 mktemp
        1  0.0028 ophelp
        1  0.0028 screen-4.0.3
        1  0.0028 which
        1  0.0028 libgcrypt.so.11.2.3
        1  0.0028 libidn.so.11.5.28
        1  0.0028 libpopt.so.0.0.0
        1  0.0028 _random.so
        1  0.0028 imap
        1  0.0028 crond
        1  0.0028 snmpd
+ echo

+ echo

+ echo

+ opreport -l /usr/src/linux-2.6.22-ARCH/vmlinux
CPU: PIII, speed 798.017 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
3832     23.4818  __switch_to
3380     20.7121  schedule
653       4.0015  mask_and_ack_8259A
452       2.7698  __blockdev_direct_IO
327       2.0038  dequeue_task
319       1.9548  follow_page
243       1.4891  get_page_from_freelist
219       1.3420  delay_tsc
187       1.1459  enable_8259A_irq
184       1.1275  put_page
173       1.0601  __handle_mm_fault
159       0.9743  native_load_tls
155       0.9498  do_page_fault
131       0.8027  __copy_to_user_ll
128       0.7844  do_wp_page
104       0.6373  irq_entries_start
103       0.6312  kmem_cache_free
101       0.6189  unmap_vmas
91        0.5576  sysenter_past_esp
89        0.5454  get_user_pages
87        0.5331  __link_path_walk
86        0.5270  math_state_restore
85        0.5209  blk_rq_map_sg
83        0.5086  __generic_file_aio_write_nolock
82        0.5025  __bio_add_page
77        0.4718  find_vma
75        0.4596  page_address
67        0.4106  page_fault
66        0.4044  generic_file_direct_write
65        0.3983  dio_bio_complete
62        0.3799  kmem_cache_alloc
62        0.3799  vfs_write
59        0.3615  filemap_nopage
53        0.3248  __d_lookup
51        0.3125  __mutex_lock_slowpath
51        0.3125  submit_page_section
48        0.2941  _spin_lock_irqsave
48        0.2941  dio_bio_submit
46        0.2819  bio_alloc_bioset
46        0.2819  block_llseek
45        0.2758  __make_request
44        0.2696  do_generic_mapping_read
42        0.2574  __add_entropy_words
42        0.2574  mempool_free
42        0.2574  restore_all
41        0.2512  current_fs_time
41        0.2512  handle_level_irq
41        0.2512  vm_normal_page
39        0.2390  find_get_page
38        0.2329  radix_tree_lookup
37        0.2267  dio_get_page
36        0.2206  blk_backing_dev_unplug
35        0.2145  dio_bio_add_page
34        0.2083  device_not_available
34        0.2083  dio_send_cur_page
34        0.2083  mark_page_accessed
33        0.2022  __mutex_unlock_slowpath
33        0.2022  acpi_pm_read
33        0.2022  do_sync_write
33        0.2022  fget_light
33        0.2022  generic_unplug_device
32        0.1961  cfq_completed_request
32        0.1961  permission
31        0.1900  generic_file_aio_write_nolock
31        0.1900  generic_make_request
31        0.1900  restore_nocheck
30        0.1838  __alloc_pages
30        0.1838  cache_reap
30        0.1838  generic_file_direct_IO
29        0.1777  __find_get_block
29        0.1777  do_mmap_pgoff
28        0.1716  try_to_wake_up
27        0.1655  blk_recount_segments
27        0.1655  cond_resched
26        0.1593  add_timer_randomness
26        0.1593  bio_add_page
25        0.1532  __mod_timer
25        0.1532  io_schedule
25        0.1532  load_elf_binary
25        0.1532  sched_clock
24        0.1471  elv_insert
24        0.1471  file_update_time
24        0.1471  generic_permission
24        0.1471  strnlen_user
23        0.1409  __end_that_request_first
22        0.1348  kfree
21        0.1287  dio_cleanup
21        0.1287  do_path_lookup
21        0.1287  strncpy_from_user
21        0.1287  sys_llseek
20        0.1226  do_sys_poll
20        0.1226  max_block
19        0.1164  copy_process
19        0.1164  proc_sys_lookup_table_one
19        0.1164  rw_verify_area
18        0.1103  kmap_atomic_prot
18        0.1103  preempt_schedule_irq
17        0.1042  blkdev_direct_IO
17        0.1042  dio_complete
17        0.1042  dnotify_parent
17        0.1042  do_lookup
17        0.1042  number
17        0.1042  vsnprintf
16        0.0980  bio_fs_destructor
16        0.0980  cfq_remove_request
16        0.0980  memcpy
16        0.0980  note_interrupt
15        0.0919  dio_bio_end_io
15        0.0919  generic_segment_checks
15        0.0919  hrtimer_interrupt
15        0.0919  inotify_inode_queue_event
15        0.0919  preempt_schedule
14        0.0858  _atomic_dec_and_lock
14        0.0858  drain_array
14        0.0858  internal_add_timer
14        0.0858  mempool_alloc
14        0.0858  vm_stat_account
13        0.0797  __copy_user_intel
13        0.0797  __inc_zone_state
13        0.0797  __mark_inode_dirty
13        0.0797  blk_remove_plug
13        0.0797  copy_page_range
13        0.0797  deactivate_task
13        0.0797  del_timer
13        0.0797  kmem_cache_zalloc
13        0.0797  open_namei
12        0.0735  __freed_request
12        0.0735  cache_alloc_refill
12        0.0735  do_IRQ
12        0.0735  find_extend_vma
12        0.0735  mutex_remove_waiter
12        0.0735  rb_erase
12        0.0735  task_rq_lock
11        0.0674  __copy_from_user_ll
11        0.0674  blkdev_get_blocks
11        0.0674  cfq_dispatch_requests
11        0.0674  cfq_insert_request
11        0.0674  clear_bdi_congested
11        0.0674  common_interrupt
11        0.0674  debug_mutex_add_waiter
11        0.0674  dio_new_bio
11        0.0674  disk_round_stats
11        0.0674  native_flush_tlb_single
11        0.0674  timespec_trunc
11        0.0674  unix_poll
11        0.0674  up_read
11        0.0674  vfs_read
10        0.0613  __follow_mount
10        0.0613  __fput
10        0.0613  __generic_unplug_device
10        0.0613  anon_vma_prepare
10        0.0613  arch_get_unmapped_area_topdown
10        0.0613  bio_get_nr_vecs
10        0.0613  bio_init
10        0.0613  cfq_set_request
10        0.0613  debug_mutex_lock_common
10        0.0613  generic_file_aio_read
10        0.0613  generic_fillattr
10        0.0613  irq_exit
10        0.0613  rb_insert_color
10        0.0613  sys_write
9         0.0552  __do_page_cache_readahead
9         0.0552  cfq_may_queue
9         0.0552  cfq_service_tree_add
9         0.0552  debug_mutex_unlock
9         0.0552  error_code
9         0.0552  find_mergeable_anon_vma
9         0.0552  get_empty_filp
9         0.0552  getname
9         0.0552  idle_cpu
9         0.0552  path_walk
9         0.0552  work_resched
8         0.0490  __dentry_open
8         0.0490  __wake_up_bit
8         0.0490  bdev_read_only
8         0.0490  bio_put
8         0.0490  cfq_queue_empty
8         0.0490  cp_new_stat64
8         0.0490  debug_mutex_free_waiter
8         0.0490  elv_completed_request
8         0.0490  elv_next_request
8         0.0490  file_read_actor
8         0.0490  find_vma_prepare
8         0.0490  inotify_dentry_parent_queue_event
8         0.0490  ip_append_data
8         0.0490  lock_timer_base
8         0.0490  lru_cache_add_active
8         0.0490  mempool_free_slab
8         0.0490  percpu_counter_mod
8         0.0490  rq_init
8         0.0490  submit_bio
8         0.0490  touch_atime
8         0.0490  update_wall_time
8         0.0490  vfs_llseek
8         0.0490  vma_merge
7         0.0429  __do_softirq
7         0.0429  __find_get_block_slow
7         0.0429  __rmqueue
7         0.0429  bio_free
7         0.0429  block_read_full_page
7         0.0429  call_rcu
7         0.0429  copy_strings
7         0.0429  do_sync_read
7         0.0429  do_sys_open
7         0.0429  dput
7         0.0429  dummy_inode_permission
7         0.0429  end_that_request_last
7         0.0429  fget
7         0.0429  filp_close
7         0.0429  find_vma_prev
7         0.0429  flush_signal_handlers
7         0.0429  kmap_atomic
7         0.0429  native_load_esp0
7         0.0429  recalc_task_prio
7         0.0429  remove_vma
7         0.0429  sys_mmap2
7         0.0429  system_call
7         0.0429  vma_adjust
7         0.0429  zone_watermark_ok
6         0.0368  __atomic_notifier_call_chain
6         0.0368  __blk_put_request
6         0.0368  __getblk
6         0.0368  __pagevec_lru_add_active
6         0.0368  __path_lookup_intent_open
6         0.0368  __pte_alloc
6         0.0368  alloc_buffer_head
6         0.0368  copy_to_user
6         0.0368  down_read_trylock
6         0.0368  flush_tlb_mm
6         0.0368  get_request
6         0.0368  get_unused_fd
6         0.0368  handle_IRQ_event
6         0.0368  link_path_walk
6         0.0368  mempool_alloc_slab
6         0.0368  ret_from_exception
6         0.0368  sys_mprotect
6         0.0368  sys_rt_sigaction
6         0.0368  vm_acct_memory
5         0.0306  __const_udelay
5         0.0306  __ip_route_output_key
5         0.0306  __page_set_anon_rmap
5         0.0306  account_user_time
5         0.0306  bit_waitqueue
5         0.0306  block_write_full_page
5         0.0306  cfq_add_rq_rb
5         0.0306  cfq_cic_rb_lookup
5         0.0306  copy_from_user
5         0.0306  do_softirq
5         0.0306  dummy_file_permission
5         0.0306  elv_dequeue_request
5         0.0306  file_ra_state_init
5         0.0306  free_block
5         0.0306  free_poll_entry
5         0.0306  freed_request
5         0.0306  generic_file_open
5         0.0306  get_unmapped_area
5         0.0306  hrtimer_forward
5         0.0306  inode_init_once
5         0.0306  ktime_get_ts
5         0.0306  lru_add_drain
5         0.0306  may_open
5         0.0306  native_set_pte_at
5         0.0306  net_rx_action
5         0.0306  notifier_call_chain
5         0.0306  page_cache_readahead
5         0.0306  put_io_context
5         0.0306  radix_tree_gang_lookup_tag
5         0.0306  rcu_pending
5         0.0306  sync_sb_inodes
5         0.0306  sys_faccessat
5         0.0306  unmap_region
4         0.0245  __anon_vma_link
4         0.0245  __block_write_full_page
4         0.0245  __get_user_4
4         0.0245  __kmalloc
4         0.0245  __rcu_process_callbacks
4         0.0245  __wake_up
4         0.0245  __wake_up_common
4         0.0245  _spin_lock
4         0.0245  add_disk_randomness
4         0.0245  blk_plug_device
4         0.0245  blk_queue_bounce
4         0.0245  cfq_dispatch_insert
4         0.0245  cfq_put_request
4         0.0245  clockevents_program_event
4         0.0245  d_alloc
4         0.0245  do_fcntl
4         0.0245  do_munmap
4         0.0245  down_read
4         0.0245  dummy_vm_enough_memory
4         0.0245  dup_fd
4         0.0245  effective_prio
4         0.0245  elv_queue_empty
4         0.0245  enqueue_hrtimer
4         0.0245  enqueue_task
4         0.0245  flush_old_exec
4         0.0245  generic_file_mmap
4         0.0245  getnstimeofday
4         0.0245  groups_search
4         0.0245  ip_options_build
4         0.0245  ip_push_pending_frames
4         0.0245  irq_enter
4         0.0245  kunmap_atomic
4         0.0245  locks_remove_flock
4         0.0245  need_resched
4         0.0245  page_waitqueue
4         0.0245  path_lookup_open
4         0.0245  raise_softirq
4         0.0245  release_pages
4         0.0245  ret_from_intr
4         0.0245  run_posix_cpu_timers
4         0.0245  sha_transform
4         0.0245  skb_copy_and_csum_bits
4         0.0245  skb_release_data
4         0.0245  softlockup_tick
4         0.0245  sys_close
4         0.0245  sys_rt_sigprocmask
4         0.0245  sys_socketcall
4         0.0245  sysctl_head_next
4         0.0245  task_running_tick
4         0.0245  wake_up_process
3         0.0184  __activate_task
3         0.0184  __bread
3         0.0184  __dec_zone_state
3         0.0184  __iget
3         0.0184  __lru_add_drain
3         0.0184  __pollwait
3         0.0184  __rb_rotate_right
3         0.0184  __tasklet_schedule
3         0.0184  __vm_enough_memory
3         0.0184  __vma_link
3         0.0184  _local_bh_enable
3         0.0184  alloc_inode
3         0.0184  bio_endio
3         0.0184  blk_start_queueing
3         0.0184  blockable_page_cache_readahead
3         0.0184  cfq_put_queue
3         0.0184  clear_user
3         0.0184  clocksource_get_next
3         0.0184  credit_entropy_store
3         0.0184  debug_mutex_set_owner
3         0.0184  do_mpage_readpage
3         0.0184  do_notify_parent
3         0.0184  dummy_inode_getattr
3         0.0184  elv_dispatch_sort
3         0.0184  elv_put_request
3         0.0184  file_move
3         0.0184  find_next_bit
3         0.0184  find_next_zero_bit
3         0.0184  flush_tlb_page
3         0.0184  fput
3         0.0184  free_hot_cold_page
3         0.0184  free_pgtables
3         0.0184  get_nr_files
3         0.0184  install_special_mapping
3         0.0184  ip_rcv
3         0.0184  local_bh_enable_ip
3         0.0184  locks_remove_posix
3         0.0184  may_expand_vm
3         0.0184  neigh_lookup
3         0.0184  new_inode
3         0.0184  page_add_new_anon_rmap
3         0.0184  poll_initwait
3         0.0184  proc_lookup
3         0.0184  put_files_struct
3         0.0184  radix_tree_insert
3         0.0184  rb_first
3         0.0184  rb_next
3         0.0184  set_normalized_timespec
3         0.0184  setup_arg_pages
3         0.0184  should_remove_suid
3         0.0184  sock_alloc_send_skb
3         0.0184  submit_bh
3         0.0184  sys_poll
3         0.0184  sys_read
3         0.0184  tick_do_update_jiffies64
3         0.0184  tick_sched_timer
3         0.0184  unlink_file_vma
3         0.0184  vfs_getattr
3         0.0184  vma_link
2         0.0123  I_BDEV
2         0.0123  __block_prepare_write
2         0.0123  __blocking_notifier_call_chain
2         0.0123  __brelse
2         0.0123  __dev_get_by_name
2         0.0123  __elv_add_request
2         0.0123  __inc_zone_page_state
2         0.0123  __lookup_mnt
2         0.0123  __mutex_init
2         0.0123  __rcu_pending
2         0.0123  __set_page_dirty_buffers
2         0.0123  __set_page_dirty_nobuffers
2         0.0123  __vma_link_rb
2         0.0123  __xfrm_lookup
2         0.0123  account_system_time
2         0.0123  add_to_page_cache
2         0.0123  add_wait_queue
2         0.0123  apic_timer_interrupt
2         0.0123  bio_alloc
2         0.0123  bio_hw_segments
2         0.0123  blk_do_ordered
2         0.0123  cfq_choose_req
2         0.0123  cfq_init_prio_data
2         0.0123  cfq_rb_erase
2         0.0123  cfq_resort_rr_list
2         0.0123  check_pgt_cache
2         0.0123  check_userspace
2         0.0123  copy_strings_kernel
2         0.0123  copy_thread
2         0.0123  csum_partial_copy_generic
2         0.0123  d_rehash
2         0.0123  datagram_poll
2         0.0123  dentry_iput
2         0.0123  dnotify_flush
2         0.0123  do_filp_open
2         0.0123  do_gettimeofday
2         0.0123  do_ioctl
2         0.0123  do_notify_resume
2         0.0123  do_wait
2         0.0123  dummy_capable
2         0.0123  dummy_file_alloc_security
2         0.0123  dummy_inode_alloc_security
2         0.0123  elv_rb_add
2         0.0123  elv_rqhash_add
2         0.0123  elv_set_request
2         0.0123  exit_aio
2         0.0123  exit_sem
2         0.0123  fd_install
2         0.0123  fib_semantic_match
2         0.0123  filemap_write_and_wait
2         0.0123  get_dcookie
2         0.0123  get_index
2         0.0123  half_md4_transform
2         0.0123  hweight32
2         0.0123  icmp_push_reply
2         0.0123  icmp_send
2         0.0123  init_new_context
2         0.0123  init_page_buffers
2         0.0123  init_request_from_bio
2         0.0123  inode_has_buffers
2         0.0123  insert_vm_struct
2         0.0123  iput
2         0.0123  kfree_skbmem
2         0.0123  ll_rw_block
2         0.0123  mmput
2         0.0123  mod_zone_page_state
2         0.0123  nameidata_to_filp
2         0.0123  native_apic_write
2         0.0123  page_add_file_rmap
2         0.0123  page_remove_rmap
2         0.0123  pipe_poll
2         0.0123  pipe_read
2         0.0123  pipe_write
2         0.0123  prepare_binprm
2         0.0123  proc_flush_task
2         0.0123  proc_sys_lookup_table
2         0.0123  profile_tick
2         0.0123  quicklist_trim
2         0.0123  radix_tree_tag_clear
2         0.0123  rcu_check_callbacks
2         0.0123  recalc_sigpending_tsk
2         0.0123  resched_task
2         0.0123  resume_userspace
2         0.0123  rt_intern_hash
2         0.0123  sched_balance_self
2         0.0123  schedule_tail
2         0.0123  seq_printf
2         0.0123  set_page_dirty
2         0.0123  show_stat
2         0.0123  sigprocmask
2         0.0123  sk_free
2         0.0123  smp_apic_timer_interrupt
2         0.0123  sock_def_write_space
2         0.0123  sock_recvmsg
2         0.0123  special_mapping_nopage
2         0.0123  sys_dup2
2         0.0123  sys_ioctl
2         0.0123  sys_mkdirat
2         0.0123  syscall_exit
2         0.0123  tcp_poll
2         0.0123  tcp_sendmsg
2         0.0123  tcp_v4_rcv
2         0.0123  unshare_files
2         0.0123  vma_prio_tree_remove
2         0.0123  wake_up_bit
2         0.0123  wake_up_new_task
1         0.0061  __alloc_skb
1         0.0061  __cfq_slice_expired
1         0.0061  __dec_zone_page_state
1         0.0061  __delay
1         0.0061  __dequeue_signal
1         0.0061  __free_pages_ok
1         0.0061  __free_pipe_info
1         0.0061  __get_free_pages
1         0.0061  __group_complete_signal
1         0.0061  __init_rwsem
1         0.0061  __kfree_skb
1         0.0061  __next_cpu
1         0.0061  __pagevec_lru_add
1         0.0061  __put_unused_fd
1         0.0061  __put_user_4
1         0.0061  __rb_rotate_left
1         0.0061  __remove_hrtimer
1         0.0061  __udp4_lib_lookup
1         0.0061  __udp4_lib_rcv
1         0.0061  __user_walk_fd
1         0.0061  _d_rehash
1         0.0061  _read_lock
1         0.0061  add_to_page_cache_lru
1         0.0061  all_vm_events
1         0.0061  anon_pipe_buf_release
1         0.0061  anon_vma_link
1         0.0061  anon_vma_unlink
1         0.0061  arch_align_stack
1         0.0061  arch_pick_mmap_layout
1         0.0061  arch_setup_additional_pages
1         0.0061  attach_pid
1         0.0061  bio_phys_segments
1         0.0061  can_share_swap_page
1         0.0061  can_vma_merge_after
1         0.0061  can_vma_merge_before
1         0.0061  cfq_merged_request
1         0.0061  cleanup_timers
1         0.0061  compute_creds
1         0.0061  copy_vma
1         0.0061  d_instantiate
1         0.0061  d_path
1         0.0061  dec_zone_page_state
1         0.0061  default_llseek
1         0.0061  del_timer_sync
1         0.0061  delayed_put_pid
1         0.0061  dev_seq_open
1         0.0061  dio_zero_block
1         0.0061  diskstats_show
1         0.0061  do_brk
1         0.0061  do_fork
1         0.0061  do_futex
1         0.0061  do_mremap
1         0.0061  do_proc_sys_lookup
1         0.0061  do_select
1         0.0061  do_sigaction
1         0.0061  do_timer
1         0.0061  do_writepages
1         0.0061  dst_destroy
1         0.0061  dummy_bprm_check_security
1         0.0061  dummy_d_instantiate
1         0.0061  dummy_file_free_security
1         0.0061  dummy_file_mmap
1         0.0061  elf_map
1         0.0061  eligible_child
1         0.0061  elv_may_queue
1         0.0061  elv_merge
1         0.0061  elv_rqhash_del
1         0.0061  end_buffer_async_write
1         0.0061  exit_itimers
1         0.0061  extract_buf
1         0.0061  fasync_helper
1         0.0061  file_permission
1         0.0061  find_get_pages_tag
1         0.0061  find_or_create_page
1         0.0061  finish_wait
1         0.0061  free_pages_bulk
1         0.0061  get_locked_pte
1         0.0061  get_random_int
1         0.0061  get_request_wait
1         0.0061  get_task_mm
1         0.0061  get_vmalloc_info
1         0.0061  inc_zone_page_state
1         0.0061  inet_create
1         0.0061  inet_getpeer
1         0.0061  inet_select_addr
1         0.0061  init_fpu
1         0.0061  inotify_d_instantiate
1         0.0061  iov_fault_in_pages_read
1         0.0061  ip4_datagram_connect
1         0.0061  ip_dev_find
1         0.0061  ip_local_deliver
1         0.0061  ip_output
1         0.0061  kill_fasync
1         0.0061  lookup_create
1         0.0061  lookup_hash
1         0.0061  lookup_mnt
1         0.0061  lru_cache_add
1         0.0061  mark_buffer_dirty
1         0.0061  memset
1         0.0061  mm_release
1         0.0061  mntput_no_expire
1         0.0061  mod_timer
1         0.0061  mutex_trylock
1         0.0061  native_read_cr0
1         0.0061  native_write_cr0
1         0.0061  neigh_update
1         0.0061  netif_receive_skb
1         0.0061  notify_change
1         0.0061  open_exec
1         0.0061  ordered_bio_endio
1         0.0061  page_mkclean
1         0.0061  pdflush
1         0.0061  pgd_alloc
1         0.0061  pipe_iov_copy_from_user
1         0.0061  pipe_write_fasync
1         0.0061  pipe_write_release
1         0.0061  poll_freewait
1         0.0061  posix_cpu_timers_exit_group
1         0.0061  prepare_to_wait_exclusive
1         0.0061  prio_tree_insert
1         0.0061  prio_tree_remove
1         0.0061  prio_tree_replace
1         0.0061  proc_alloc_inode
1         0.0061  proc_sys_permission
1         0.0061  put_pid
1         0.0061  radix_tree_tag_set
1         0.0061  rb_prev
1         0.0061  rcu_process_callbacks
1         0.0061  recalc_bh_state
1         0.0061  release_open_intent
1         0.0061  release_task
1         0.0061  release_thread
1         0.0061  remove_suid
1         0.0061  resume_kernel
1         0.0061  run_timer_softirq
1         0.0061  rwsem_down_failed_common
1         0.0061  rwsem_wake
1         0.0061  schedule_timeout
1         0.0061  scheduler_tick
1         0.0061  search_binary_handler
1         0.0061  secure_ip_id
1         0.0061  set_bh_page
1         0.0061  set_brk
1         0.0061  sk_alloc
1         0.0061  sk_stream_mem_schedule
1         0.0061  skip_atoi
1         0.0061  sock_aio_read
1         0.0061  sock_fasync
1         0.0061  sock_from_file
1         0.0061  sock_ioctl
1         0.0061  split_vma
1         0.0061  sprintf
1         0.0061  sync_buffer
1         0.0061  sys_brk
1         0.0061  sys_fstat64
1         0.0061  sys_getcwd
1         0.0061  sys_gettimeofday
1         0.0061  sys_munmap
1         0.0061  sys_recvfrom
1         0.0061  sys_send
1         0.0061  sys_sendto
1         0.0061  tcp_ack
1         0.0061  tcp_urg
1         0.0061  try_to_del_timer_sync
1         0.0061  tty_poll
1         0.0061  uart_read_proc
1         0.0061  udp_flush_pending_frames
1         0.0061  udp_v4_get_port
1         0.0061  unlock_page
1         0.0061  vfs_fstat
1         0.0061  vfs_permission
1         0.0061  vfs_stat_fd
1         0.0061  vma_stop
1         0.0061  wake_up_inode
1         0.0061  wb_kupdate
1         0.0061  work_pending
1         0.0061  worker_thread
1         0.0061  writeback_inodes

--Boundary-00=_+G1sG5l86eCKvV5
Content-Type: text/plain;
  charset="iso-8859-1";
  name="one_disc.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="one_disc.txt"

Thu Aug  2 18:33:52 EEST 2007
+ opcontrol --vmlinux=/usr/src/linux-2.6.22-ARCH/vmlinux
+ opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
+ sleep 5
+ opcontrol --shutdown
Stopping profiling.
Killing daemon.
+ echo

+ echo

+ echo

+ opreport
CPU: PIII, speed 798.017 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
     1829 48.3734 processor
     1029 27.2150 vmlinux
      356  9.4155 libc-2.6.so
      200  5.2896 bash
      157  4.1523 ld-2.6.so
       52  1.3753 ISO8859-1.so
       31  0.8199 ext3
       29  0.7670 oprofiled
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	       28 96.5517 oprofiled
	        1  3.4483 anon (tgid:5517 range:0xb7f71000-0xb7f72000)
       26  0.6876 jbd
       19  0.5025 ide_core
        8  0.2116 grep
        7  0.1851 oprofile
        5  0.1322 gawk
        5  0.1322 locale-archive
        4  0.1058 badblocks
        3  0.0793 screen-4.0.3
        3  0.0793 sshd
        2  0.0529 libext2fs.so.2.4
        2  0.0529 expr
        2  0.0529 libcrypto.so.0.9.8
        1  0.0264 ls
        1  0.0264 rm
        1  0.0264 tr
        1  0.0264 libhistory.so.5.2
        1  0.0264 libm-2.6.so
        1  0.0264 libncurses.so.5.6
        1  0.0264 libpthread-2.6.so
        1  0.0264 libreadline.so.5.2
        1  0.0264 skge
        1  0.0264 id
        1  0.0264 libnetsnmpmibs.so.15.0.0
        1  0.0264 snmpd
+ echo

+ echo

+ echo

+ opreport -l /usr/src/linux-2.6.22-ARCH/vmlinux
CPU: PIII, speed 798.017 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
160      15.5491  do_wp_page
123      11.9534  native_safe_halt
49        4.7619  __handle_mm_fault
34        3.3042  unmap_vmas
27        2.6239  get_page_from_freelist
23        2.2352  page_fault
15        1.4577  __d_lookup
14        1.3605  put_page
13        1.2634  copy_process
12        1.1662  __link_path_walk
12        1.1662  do_page_fault
11        1.0690  page_address
9         0.8746  __copy_to_user_ll
9         0.8746  memcpy
8         0.7775  acpi_pm_read
8         0.7775  find_vma
8         0.7775  radix_tree_lookup
7         0.6803  __wake_up_bit
7         0.6803  copy_page_range
7         0.6803  find_get_page
7         0.6803  kmem_cache_free
6         0.5831  __blockdev_direct_IO
6         0.5831  copy_strings
6         0.5831  do_mmap_pgoff
6         0.5831  filemap_nopage
6         0.5831  mask_and_ack_8259A
6         0.5831  sysenter_past_esp
5         0.4859  __find_get_block
5         0.4859  error_code
5         0.4859  flush_tlb_page
5         0.4859  free_pgtables
5         0.4859  permission
5         0.4859  strnlen_user
4         0.3887  __pagevec_lru_add_active
4         0.3887  blk_backing_dev_unplug
4         0.3887  do_generic_mapping_read
4         0.3887  do_path_lookup
4         0.3887  follow_page
4         0.3887  rb_insert_color
3         0.2915  __atomic_notifier_call_chain
3         0.2915  __do_page_cache_readahead
3         0.2915  __find_get_block_slow
3         0.2915  __fput
3         0.2915  _atomic_dec_and_lock
3         0.2915  acpi_os_read_port
3         0.2915  add_timer_randomness
3         0.2915  bit_waitqueue
3         0.2915  copy_to_user
3         0.2915  delay_tsc
3         0.2915  do_exit
3         0.2915  find_next_zero_bit
3         0.2915  flush_tlb_mm
3         0.2915  generic_fillattr
3         0.2915  generic_permission
3         0.2915  generic_segment_checks
3         0.2915  getnstimeofday
3         0.2915  ktime_get_ts
3         0.2915  kunmap_atomic
3         0.2915  load_elf_binary
3         0.2915  page_remove_rmap
3         0.2915  path_walk
3         0.2915  put_files_struct
3         0.2915  rb_erase
3         0.2915  release_pages
3         0.2915  ret_from_exception
3         0.2915  schedule
2         0.1944  __blocking_notifier_call_chain
2         0.1944  __dec_zone_state
2         0.1944  __pte_alloc
2         0.1944  __vm_enough_memory
2         0.1944  _spin_lock_irqsave
2         0.1944  account_system_time
2         0.1944  anon_vma_unlink
2         0.1944  atomic_notifier_call_chain
2         0.1944  cache_reap
2         0.1944  cfq_queue_empty
2         0.1944  clockevents_program_event
2         0.1944  current_fs_time
2         0.1944  d_alloc
2         0.1944  debug_mutex_add_waiter
2         0.1944  debug_mutex_unlock
2         0.1944  disk_round_stats
2         0.1944  dnotify_flush
2         0.1944  do_notify_resume
2         0.1944  do_softirq
2         0.1944  down_read_trylock
2         0.1944  dup_fd
2         0.1944  end_that_request_last
2         0.1944  fd_install
2         0.1944  file_read_actor
2         0.1944  flush_old_exec
2         0.1944  free_block
2         0.1944  free_hot_cold_page
2         0.1944  generic_make_request
2         0.1944  get_empty_filp
2         0.1944  get_index
2         0.1944  get_next_timer_interrupt
2         0.1944  get_signal_to_deliver
2         0.1944  irq_entries_start
2         0.1944  kmap_atomic_prot
2         0.1944  kmem_cache_alloc
2         0.1944  mutex_remove_waiter
2         0.1944  page_add_file_rmap
2         0.1944  page_waitqueue
2         0.1944  percpu_counter_mod
2         0.1944  pit_next_event
2         0.1944  prepare_to_copy
2         0.1944  prio_tree_insert
2         0.1944  rcu_start_batch
2         0.1944  recalc_sigpending_tsk
2         0.1944  remove_vma
2         0.1944  resume_userspace
2         0.1944  rm_from_queue_full
2         0.1944  sched_balance_self
2         0.1944  scheduler_tick
2         0.1944  secure_ip_id
2         0.1944  sys_close
2         0.1944  sys_rt_sigprocmask
2         0.1944  task_running_tick
2         0.1944  try_to_wake_up
2         0.1944  up_read
2         0.1944  update_wall_time
2         0.1944  vfs_permission
2         0.1944  vm_normal_page
2         0.1944  vma_link
2         0.1944  vma_merge
1         0.0972  I_BDEV
1         0.0972  __add_entropy_words
1         0.0972  __brelse
1         0.0972  __copy_from_user_ll
1         0.0972  __d_path
1         0.0972  __do_softirq
1         0.0972  __elv_add_request
1         0.0972  __end_that_request_first
1         0.0972  __free_pipe_info
1         0.0972  __freed_request
1         0.0972  __inc_zone_page_state
1         0.0972  __inc_zone_state
1         0.0972  __init_rwsem
1         0.0972  __insert_inode_hash
1         0.0972  __lru_add_drain
1         0.0972  __make_request
1         0.0972  __mutex_lock_interruptible_slowpath
1         0.0972  __mutex_unlock_slowpath
1         0.0972  __pollwait
1         0.0972  __rcu_pending
1         0.0972  __sigqueue_alloc
1         0.0972  __sock_create
1         0.0972  __switch_to
1         0.0972  __tasklet_schedule
1         0.0972  __tcp_push_pending_frames
1         0.0972  __wake_up_common
1         0.0972  acpi_get_register
1         0.0972  acpi_hw_register_read
1         0.0972  acpi_os_write_port
1         0.0972  add_disk_randomness
1         0.0972  alloc_inode
1         0.0972  alloc_pid
1         0.0972  anon_vma_link
1         0.0972  anon_vma_prepare
1         0.0972  arch_setup_additional_pages
1         0.0972  bio_alloc_bioset
1         0.0972  bio_fs_destructor
1         0.0972  blk_plug_device
1         0.0972  blk_queue_bounce
1         0.0972  blk_recount_segments
1         0.0972  cache_alloc_refill
1         0.0972  call_rcu
1         0.0972  can_share_swap_page
1         0.0972  cfq_choose_req
1         0.0972  cfq_completed_request
1         0.0972  cfq_dispatch_requests
1         0.0972  cfq_init_prio_data
1         0.0972  cfq_may_queue
1         0.0972  cfq_remove_request
1         0.0972  cfq_service_tree_add
1         0.0972  cfq_set_request
1         0.0972  check_pgt_cache
1         0.0972  check_userspace
1         0.0972  cleanup_timers
1         0.0972  clear_user
1         0.0972  common_interrupt
1         0.0972  copy_from_user
1         0.0972  copy_thread_group_keys
1         0.0972  d_instantiate
1         0.0972  deactivate_task
1         0.0972  debug_mutex_free_waiter
1         0.0972  debug_mutex_lock_common
1         0.0972  del_timer
1         0.0972  dequeue_task
1         0.0972  dio_bio_add_page
1         0.0972  do_fork
1         0.0972  do_lookup
1         0.0972  do_munmap
1         0.0972  do_pipe
1         0.0972  do_sigaction
1         0.0972  do_sync_read
1         0.0972  do_timer
1         0.0972  do_wait
1         0.0972  dummy_capable
1         0.0972  dummy_file_alloc_security
1         0.0972  elf_map
1         0.0972  elv_dequeue_request
1         0.0972  elv_insert
1         0.0972  elv_merge
1         0.0972  elv_next_request
1         0.0972  exit_itimers
1         0.0972  expand_files
1         0.0972  fasync_helper
1         0.0972  fget_light
1         0.0972  filp_close
1         0.0972  find_mergeable_anon_vma
1         0.0972  find_vma_prev
1         0.0972  finish_wait
1         0.0972  fput
1         0.0972  free_page_and_swap_cache
1         0.0972  generic_file_aio_read
1         0.0972  generic_file_open
1         0.0972  generic_pipe_buf_pin
1         0.0972  generic_unplug_device
1         0.0972  get_nr_files
1         0.0972  get_user_pages
1         0.0972  getname
1         0.0972  half_md4_transform
1         0.0972  hrtimer_get_next_event
1         0.0972  hrtimer_interrupt
1         0.0972  hrtimer_start
1         0.0972  hrtimer_try_to_cancel
1         0.0972  idle_cpu
1         0.0972  init_new_context
1         0.0972  inotify_d_instantiate
1         0.0972  inotify_dentry_parent_queue_event
1         0.0972  inotify_inode_queue_event
1         0.0972  internal_add_timer
1         0.0972  ip_push_pending_frames
1         0.0972  ip_route_output_flow
1         0.0972  kernel_read
1         0.0972  kmem_cache_zalloc
1         0.0972  kref_put
1         0.0972  load_script
1         0.0972  lru_add_drain
1         0.0972  mark_page_accessed
1         0.0972  may_expand_vm
1         0.0972  may_open
1         0.0972  mempool_alloc
1         0.0972  mm_release
1         0.0972  mmput
1         0.0972  native_flush_tlb_single
1         0.0972  native_set_pte_at
1         0.0972  next_signal
1         0.0972  normal_poll
1         0.0972  nr_iowait
1         0.0972  open_exec
1         0.0972  page_add_new_anon_rmap
1         0.0972  pid_revalidate
1         0.0972  pipe_read
1         0.0972  posix_cpu_timers_exit
1         0.0972  prio_tree_replace
1         0.0972  proc_flush_task
1         0.0972  proc_sys_lookup_table_one
1         0.0972  quicklist_trim
1         0.0972  raise_softirq
1         0.0972  rb_first
1         0.0972  rb_next
1         0.0972  recalc_task_prio
1         0.0972  release_open_intent
1         0.0972  release_vm86_irqs
1         0.0972  resched_task
1         0.0972  restore_all
1         0.0972  rq_init
1         0.0972  run_posix_cpu_timers
1         0.0972  run_timer_softirq
1         0.0972  save_i387
1         0.0972  send_signal
1         0.0972  simple_read_from_buffer
1         0.0972  split_vma
1         0.0972  sys_brk
1         0.0972  sys_clone
1         0.0972  sys_dup2
1         0.0972  sys_lseek
1         0.0972  sys_mkdir
1         0.0972  sys_rt_sigaction
1         0.0972  sys_select
1         0.0972  syscall_exit_work
1         0.0972  system_call
1         0.0972  tick_do_broadcast
1         0.0972  tick_nohz_stop_sched_tick
1         0.0972  tick_sched_timer
1         0.0972  tty_ldisc_try
1         0.0972  tty_poll
1         0.0972  unlock_buffer
1         0.0972  update_process_times
1         0.0972  vfs_getattr
1         0.0972  vfs_mkdir
1         0.0972  vfs_read
1         0.0972  vfs_write
1         0.0972  vma_adjust
1         0.0972  vma_prio_tree_add
1         0.0972  vma_prio_tree_insert
1         0.0972  vsnprintf
1         0.0972  wake_up_bit

--Boundary-00=_+G1sG5l86eCKvV5
Content-Type: text/plain;
  charset="iso-8859-1";
  name="idle.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="idle.txt"

Thu Aug  2 18:31:43 EEST 2007
+ opcontrol --vmlinux=/usr/src/linux-2.6.22-ARCH/vmlinux
+ opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
+ sleep 5
+ opcontrol --shutdown
Stopping profiling.
Killing daemon.
+ echo

+ echo

+ echo

+ opreport
CPU: PIII, speed 798.017 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
      692 46.9153 vmlinux
      315 21.3559 libc-2.6.so
      163 11.0508 bash
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	      162 99.3865 bash
	        1  0.6135 anon (tgid:5385 range:0xb7fb9000-0xb7fba000)
      126  8.5424 ld-2.6.so
       51  3.4576 ISO8859-1.so
       41  2.7797 ext3
       21  1.4237 jbd
       16  1.0847 oprofiled
        8  0.5424 skge
        7  0.4746 processor
        5  0.3390 grep
        4  0.2712 oprofile
        3  0.2034 gawk
        3  0.2034 libcrypto.so.0.9.8
        3  0.2034 libnetsnmpmibs.so.15.0.0
        3  0.2034 imap-login
        2  0.1356 ide_core
        2  0.1356 libncurses.so.5.6
        2  0.1356 libnetsnmp.so.15.0.0
        2  0.1356 locale-archive
        1  0.0678 tr
        1  0.0678 ide_disk
        1  0.0678 libpthread-2.6.so
        1  0.0678 screen-4.0.3
        1  0.0678 dovecot-auth
        1  0.0678 dovecot
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        1 100.000 anon (tgid:3919 range:0xb7f01000-0xb7f02000)
+ echo

+ echo

+ echo

+ opreport -l /usr/src/linux-2.6.22-ARCH/vmlinux
CPU: PIII, speed 798.017 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
114      16.4740  do_wp_page
36        5.2023  __handle_mm_fault
26        3.7572  get_page_from_freelist
20        2.8902  page_fault
15        2.1676  unmap_vmas
13        1.8786  __link_path_walk
11        1.5896  copy_process
11        1.5896  filemap_nopage
10        1.4451  delay_tsc
9         1.3006  __d_lookup
9         1.3006  find_get_page
8         1.1561  __mutex_lock_slowpath
8         1.1561  do_page_fault
7         1.0116  mask_and_ack_8259A
7         1.0116  page_address
6         0.8671  acpi_pm_read
6         0.8671  error_code
6         0.8671  find_vma
6         0.8671  kmem_cache_alloc
6         0.8671  kmem_cache_free
6         0.8671  pit_next_event
6         0.8671  strnlen_user
5         0.7225  __copy_to_user_ll
5         0.7225  __wake_up_bit
5         0.7225  native_flush_tlb_single
5         0.7225  put_page
4         0.5780  __find_get_block
4         0.5780  copy_page_range
4         0.5780  inode_init_once
4         0.5780  kunmap_atomic
4         0.5780  memcpy
4         0.5780  permission
4         0.5780  radix_tree_lookup
4         0.5780  restore_nocheck
4         0.5780  resume_userspace
4         0.5780  sysenter_past_esp
4         0.5780  vma_adjust
3         0.4335  __atomic_notifier_call_chain
3         0.4335  __do_page_cache_readahead
3         0.4335  add_to_page_cache
3         0.4335  clockevents_program_event
3         0.4335  current_fs_time
3         0.4335  do_mmap_pgoff
3         0.4335  do_sigaction
3         0.4335  enable_8259A_irq
3         0.4335  free_hot_cold_page
3         0.4335  get_unused_fd
3         0.4335  getnstimeofday
3         0.4335  ktime_get_ts
3         0.4335  notifier_call_chain
3         0.4335  prio_tree_remove
3         0.4335  proc_lookup
3         0.4335  ret_from_exception
3         0.4335  schedule
3         0.4335  scheduler_tick
2         0.2890  __alloc_pages
2         0.2890  __copy_user_intel
2         0.2890  __inc_zone_state
2         0.2890  __mutex_unlock_slowpath
2         0.2890  __pagevec_lru_add_active
2         0.2890  acpi_os_read_port
2         0.2890  arch_setup_additional_pages
2         0.2890  atomic_notifier_call_chain
2         0.2890  cache_reap
2         0.2890  clear_user
2         0.2890  copy_thread
2         0.2890  cp_new_stat64
2         0.2890  debug_mutex_unlock
2         0.2890  destroy_context
2         0.2890  do_generic_mapping_read
2         0.2890  do_notify_parent
2         0.2890  do_notify_resume
2         0.2890  dup_fd
2         0.2890  find_next_zero_bit
2         0.2890  fput
2         0.2890  free_pgd_range
2         0.2890  generic_permission
2         0.2890  get_index
2         0.2890  get_next_timer_interrupt
2         0.2890  getname
2         0.2890  hrtimer_get_next_event
2         0.2890  kmap_atomic_prot
2         0.2890  mark_page_accessed
2         0.2890  mm_release
2         0.2890  proc_sys_lookup_table_one
2         0.2890  quicklist_trim
2         0.2890  rb_insert_color
2         0.2890  remove_vma
2         0.2890  rw_verify_area
2         0.2890  sys_mmap2
2         0.2890  sys_rt_sigprocmask
2         0.2890  update_wall_time
2         0.2890  vm_acct_memory
2         0.2890  vm_normal_page
2         0.2890  vm_stat_account
1         0.1445  __blocking_notifier_call_chain
1         0.1445  __const_udelay
1         0.1445  __dec_zone_page_state
1         0.1445  __fput
1         0.1445  __free_pages_ok
1         0.1445  __get_free_pages
1         0.1445  __get_user_4
1         0.1445  __kmalloc
1         0.1445  __mod_timer
1         0.1445  __put_user_4
1         0.1445  __qdisc_run
1         0.1445  __rcu_process_callbacks
1         0.1445  __remove_shared_vm_struct
1         0.1445  __sigqueue_alloc
1         0.1445  __switch_to
1         0.1445  _atomic_dec_and_lock
1         0.1445  _spin_lock_irqsave
1         0.1445  account_user_time
1         0.1445  acpi_hw_register_read
1         0.1445  anon_vma_prepare
1         0.1445  balance_dirty_pages_ratelimited_nr
1         0.1445  block_read_full_page
1         0.1445  blockable_page_cache_readahead
1         0.1445  can_share_swap_page
1         0.1445  cfq_remove_request
1         0.1445  cfq_service_tree_add
1         0.1445  check_tty_count
1         0.1445  clear_inode
1         0.1445  clocksource_watchdog
1         0.1445  compute_creds
1         0.1445  copy_from_user
1         0.1445  copy_thread_group_keys
1         0.1445  copy_to_user
1         0.1445  cpu_idle
1         0.1445  create_read_pipe
1         0.1445  d_alloc
1         0.1445  d_lookup
1         0.1445  debug_mutex_lock_common
1         0.1445  debug_mutex_set_owner
1         0.1445  default_llseek
1         0.1445  dequeue_task
1         0.1445  dev_hard_start_xmit
1         0.1445  dnotify_flush
1         0.1445  do_brk
1         0.1445  do_lookup
1         0.1445  do_path_lookup
1         0.1445  do_wait
1         0.1445  down_read
1         0.1445  dput
1         0.1445  dummy_file_permission
1         0.1445  dummy_inode_permission
1         0.1445  dummy_task_create
1         0.1445  enqueue_hrtimer
1         0.1445  enqueue_task
1         0.1445  exit_aio
1         0.1445  exit_itimers
1         0.1445  exit_mm
1         0.1445  expand_files
1         0.1445  filp_close
1         0.1445  find_busiest_group
1         0.1445  find_mergeable_anon_vma
1         0.1445  find_next_bit
1         0.1445  find_vma_prev
1         0.1445  flush_old_exec
1         0.1445  flush_tlb_mm
1         0.1445  free_page_and_swap_cache
1         0.1445  free_pgtables
1         0.1445  generic_file_mmap
1         0.1445  generic_file_open
1         0.1445  generic_make_request
1         0.1445  get_nr_files
1         0.1445  get_pid_task
1         0.1445  get_unmapped_area
1         0.1445  get_write_access
1         0.1445  half_md4_transform
1         0.1445  hrtimer_reprogram
1         0.1445  hweight32
1         0.1445  in_lock_functions
1         0.1445  init_new_context
1         0.1445  ip_push_pending_frames
1         0.1445  irq_entries_start
1         0.1445  kmem_cache_zalloc
1         0.1445  ktime_divns
1         0.1445  link_path_walk
1         0.1445  load_elf_binary
1         0.1445  lock_hrtimer_base
1         0.1445  locks_remove_flock
1         0.1445  lru_cache_add_active
1         0.1445  math_state_restore
1         0.1445  may_open
1         0.1445  memory_open
1         0.1445  mm_alloc
1         0.1445  mutex_remove_waiter
1         0.1445  name_to_int
1         0.1445  native_io_delay
1         0.1445  neigh_periodic_timer
1         0.1445  net_rx_action
1         0.1445  normal_poll
1         0.1445  open_namei
1         0.1445  page_add_file_rmap
1         0.1445  page_remove_rmap
1         0.1445  page_waitqueue
1         0.1445  path_release
1         0.1445  pgd_alloc
1         0.1445  pipe_write
1         0.1445  poll_freewait
1         0.1445  proc_flush_task
1         0.1445  process_timeout
1         0.1445  profile_tick
1         0.1445  radix_tree_insert
1         0.1445  raise_softirq
1         0.1445  rb_erase
1         0.1445  release_task
1         0.1445  restore_all
1         0.1445  run_timer_softirq
1         0.1445  send_signal
1         0.1445  seq_printf
1         0.1445  set_task_comm
1         0.1445  sha_transform
1         0.1445  show_map_internal
1         0.1445  sig_ignored
1         0.1445  sk_common_release
1         0.1445  sock_wfree
1         0.1445  sys_brk
1         0.1445  sys_close
1         0.1445  sys_mkdirat
1         0.1445  sys_read
1         0.1445  sys_set_thread_area
1         0.1445  sys_sigreturn
1         0.1445  tcp_poll
1         0.1445  tcp_sendmsg
1         0.1445  tcp_v4_rcv
1         0.1445  tick_do_update_jiffies64
1         0.1445  tick_nohz_update_jiffies
1         0.1445  tick_sched_timer
1         0.1445  try_to_wake_up
1         0.1445  tty_paranoia_check
1         0.1445  tty_write
1         0.1445  unlink_file_vma
1         0.1445  unmap_region
1         0.1445  vfs_fstat
1         0.1445  vfs_llseek
1         0.1445  vfs_mkdir
1         0.1445  vfs_write
1         0.1445  vma_link
1         0.1445  vsnprintf
1         0.1445  wake_up_bit
1         0.1445  write_chan

--Boundary-00=_+G1sG5l86eCKvV5--
