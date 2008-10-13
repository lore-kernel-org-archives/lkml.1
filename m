Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbYJMFUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbYJMFUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 01:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYJMFUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 01:20:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:53735 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbYJMFUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 01:20:00 -0400
Subject: Re: [RFC 1/3] hvc_console: rework setup to replace irq functions
	with callbacks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200806031445.22561.borntraeger@de.ibm.com>
References: <200806031444.21945.borntraeger@de.ibm.com>
	 <200806031445.22561.borntraeger@de.ibm.com>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 16:16:53 +1100
Message-Id: <1223875013.8157.230.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-03 at 14:45 +0200, Christian Borntraeger wrote:
> This patch tries to change hvc_console to not use request_irq/free_irq if
> the backend does not use irqs. This allows virtio_console to use hvc_console
> without having a linker reference to request_irq/free_irq.
> 
> The irq specific code is moved to hvc_irq.c and selected by the drivers that
> use irqs (System p, System i, XEN).
> 
> I replaced "irq" with the opaque name "data". The request_irq and free_irq
> calls are replaced with notifier_add and notifier_del. I have also changed
> the code a bit to call the notifier_add and notifier_del inside the spinlock
> area as the callbacks are found via hp->ops.

That's causing lockdep to scream, though I have a hard time figuring
out what it thinks is wrong...

Ingo, would you mind giving a hand parsing that output ? Thanks !

Cheers,
Ben.

console [udbg0] enabled
pSeries detected, looking for LPAR capability...
 -> fw_feature_init()
 <- fw_feature_init()
Machine is LPAR !
Using pSeries machine description
Page orders: linear mapping = 24, virtual = 12, io = 12, vmemmap = 24
 -> pSeries_init_early()
 -> fw_cmo_feature_init()
CMO not available
 <- fw_cmo_feature_init()
 <- pSeries_init_early()
Partition configured for 32 cpus.
CPU maps initialized for 2 threads per core
 (thread shift is 1)
Starting Linux PPC64 #22 SMP Mon Oct 13 14:18:44 EST 2008
-----------------------------------------------------
ppc64_pft_size                = 0x1b
physicalMemorySize            = 0x80000000
htab_hash_mask                = 0xfffff
-----------------------------------------------------
Linux version 2.6.27-rc5-test (benh@grosgo) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #22 SMP Mon Oct 13 14:18:44 EST 2008
[boot]0012 Setup Arch
Node 0 Memory: 0x0-0x44000000
Node 1 Memory: 0x44000000-0x80000000
 -> smp_init_pSeries()
 <- smp_init_pSeries()
EEH: No capable adapters found
PPC64 nvram contains 7168 bytes
Using shared processor idle loop
Zone PFN ranges:
  DMA      0x00000000 -> 0x00008000
  Normal   0x00008000 -> 0x00008000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x00004400
    1: 0x00004400 -> 0x00008000
On node 0 totalpages: 17408
  DMA zone: 17382 pages, LIFO batch:1
On node 1 totalpages: 15360
  DMA zone: 15337 pages, LIFO batch:1
[boot]0015 Setup Done
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 32719
Policy zone: DMA
Kernel command line: root=/dev/sdb1
[boot]0020 XICS Init
[boot]0021 XICS Done
pic: no ISA interrupt controller
PID hash table entries: 4096 (order: 12, 32768 bytes)
time_init: decrementer frequency = 188.046000 MHz
time_init: processor frequency   = 1502.496000 MHz
clocksource: timebase mult[154579e] shift[22] registered
clockevent: decrementer mult[3023] shift[16] cpu[0]
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [hvc0]
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:           4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 4095 kB
 per task-struct memory footprint: 2688 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Dentry cache hash table entries: 262144 (order: 5, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 4, 1048576 bytes)
freeing bootmem node 0
freeing bootmem node 1
Memory: 1995968k/2097152k available (9280k kernel code, 101184k reserved, 1216k data, 7639k bss, 1984k init)
SLUB: Genslabs=17, HWalign=128, Order=0-3, MinObjects=0, CPUs=32, Nodes=16
Calibrating delay loop... 374.78 BogoMIPS (lpj=749568)
Mount-cache hash table entries: 4096
xics: map virq 16, hwirq 0x2
xics: unmask virq 16
 -> map to hwirq 0x2
clockevent: decrementer mult[3023] shift[16] cpu[1]
Processor 1 found.
clockevent: decrementer mult[3023] shift[16] cpu[2]
Processor 2 found.
clockevent: decrementer mult[3023] shift[16] cpu[3]
Processor 3 found.
clockevent: decrementer mult[3023] shift[16] cpu[4]
Processor 4 found.
clockevent: decrementer mult[3023] shift[16] cpu[5]
Processor 5 found.
clockevent: decrementer mult[3023] shift[16] cpu[6]
Processor 6 found.
clockevent: decrementer mult[3023] shift[16] cpu[7]
Processor 7 found.
Brought up 8 CPUs
Node 0 CPUs: 0-7
Node 1 CPUs:
CPU0 attaching sched-domain:
 domain 0: span 0-1 level SIBLING
  groups: 0 1
  domain 1: span 0-7 level CPU
   groups: 0-1 2-3 4-5 6-7
   domain 2: span 0-7 level NODE
    groups: 0-7
CPU1 attaching sched-domain:
 domain 0: span 0-1 level SIBLING
  groups: 1 0
  domain 1: span 0-7 level CPU
   groups: 0-1 2-3 4-5 6-7
   domain 2: span 0-7 level NODE
    groups: 0-7
CPU2 attaching sched-domain:
 domain 0: span 2-3 level SIBLING
  groups: 2 3
  domain 1: span 0-7 level CPU
   groups: 2-3 4-5 6-7 0-1
   domain 2: span 0-7 level NODE
    groups: 0-7
CPU3 attaching sched-domain:
 domain 0: span 2-3 level SIBLING
  groups: 3 2
  domain 1: span 0-7 level CPU
   groups: 2-3 4-5 6-7 0-1
   domain 2: span 0-7 level NODE
    groups: 0-7
CPU4 attaching sched-domain:
 domain 0: span 4-5 level SIBLING
  groups: 4 5
  domain 1: span 0-7 level CPU
   groups: 4-5 6-7 0-1 2-3
   domain 2: span 0-7 level NODE
    groups: 0-7
CPU5 attaching sched-domain:
 domain 0: span 4-5 level SIBLING
  groups: 5 4
  domain 1: span 0-7 level CPU
   groups: 4-5 6-7 0-1 2-3
   domain 2: span 0-7 level NODE
    groups: 0-7
CPU6 attaching sched-domain:
 domain 0: span 6-7 level SIBLING
  groups: 6 7
  domain 1: span 0-7 level CPU
   groups: 6-7 0-1 2-3 4-5
   domain 2: span 0-7 level NODE
    groups: 0-7
CPU7 attaching sched-domain:
 domain 0: span 6-7 level SIBLING
  groups: 7 6
  domain 1: span 0-7 level CPU
   groups: 6-7 0-1 2-3 4-5
   domain 2: span 0-7 level NODE
    groups: 0-7
khelper used greatest stack depth: 10464 bytes left
net_namespace: 1280 bytes
NET: Registered protocol family 16
IBM eBus Device Driver
PCI: Probing PCI hardware
PCI: Probing PCI hardware done
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 2
IP route cache hash table entries: 16384 (order: 1, 131072 bytes)
TCP established hash table entries: 65536 (order: 4, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 4194304 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
NET: Registered protocol family 1
xics: map virq 17, hwirq 0xa0000
xics: map virq 18, hwirq 0xa0002
IOMMU table initialized, virtual merging enabled
xics: map virq 20, hwirq 0xa0014
xics: map virq 19, hwirq 0x90001
xics: unmask virq 19
 -> map to hwirq 0x90001
RTAS daemon started
rtasd: will sleep for 7500 milliseconds
rtasd: logging event
RTAS: event: 14, Type: Platform Error, Severity: 2
audit: initializing netlink socket (disabled)
type=2000 audit(1223873798.428:1): initialized
HugeTLB registered 16 MB page size, pre-allocated 0 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 3896
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
vio_register_driver: driver hvc_console registering
HVSI: registered 0 devices
Generic RTC Driver v1.07
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
brd: module loaded
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
IBM eHEA ethernet device driver (Release EHEA_0092)
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
/home/benh/kernels/linux-test-powerpc/drivers/net/ibmveth.c: ibmveth: IBM i/pSeries Virtual Ethernet Driver 1.03
vio_register_driver: driver ibmveth registering
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver
vio_register_driver: driver ibmvscsi registering
ibmvscsi 30000014: SRP_VERSION: 16.a
xics: unmask virq 20
 -> map to hwirq 0xa0014
scsi0 : IBM POWER Virtual SCSI Adapter 1.5.8
ibmvscsi 30000014: partner initialization complete
ibmvscsi 30000014: sent SRP login
ibmvscsi 30000014: SRP_LOGIN succeeded
ibmvscsi 30000014: host srp version: 16.a, host partition 1-Diego-VIOS (1), OS 3, max io 262144
scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
scsi 0:0:2:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
scsi 0:0:3:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
st: Version 20080504, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:1:0: [sda] 20971520 512-byte hardware sectors (10737 MB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: 17 00 00 08
sd 0:0:1:0: [sda] Cache data unavailable
sd 0:0:1:0: [sda] Assuming drive cache: write through
sd 0:0:1:0: [sda] 20971520 512-byte hardware sectors (10737 MB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: 17 00 00 08
sd 0:0:1:0: [sda] Cache data unavailable
sd 0:0:1:0: [sda] Assuming drive cache: write through
 sda: sda1 sda2 sda3
sd 0:0:1:0: [sda] Attached SCSI disk
sd 0:0:2:0: [sdb] 20971520 512-byte hardware sectors (10737 MB)
sd 0:0:2:0: [sdb] Write Protect is off
sd 0:0:2:0: [sdb] Mode Sense: 17 00 00 08
sd 0:0:2:0: [sdb] Cache data unavailable
sd 0:0:2:0: [sdb] Assuming drive cache: write through
sd 0:0:2:0: [sdb] 20971520 512-byte hardware sectors (10737 MB)
sd 0:0:2:0: [sdb] Write Protect is off
sd 0:0:2:0: [sdb] Mode Sense: 17 00 00 08
sd 0:0:2:0: [sdb] Cache data unavailable
sd 0:0:2:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 0:0:2:0: [sdb] Attached SCSI disk
sd 0:0:3:0: [sdc] 20971520 512-byte hardware sectors (10737 MB)
sd 0:0:3:0: [sdc] Write Protect is off
sd 0:0:3:0: [sdc] Mode Sense: 17 00 00 08
sd 0:0:3:0: [sdc] Cache data unavailable
sd 0:0:3:0: [sdc] Assuming drive cache: write through
sd 0:0:3:0: [sdc] 20971520 512-byte hardware sectors (10737 MB)
sd 0:0:3:0: [sdc] Write Protect is off
sd 0:0:3:0: [sdc] Mode Sense: 17 00 00 08
sd 0:0:3:0: [sdc] Cache data unavailable
sd 0:0:3:0: [sdc] Assuming drive cache: write through
 sdc: sdc1 sdc2
sd 0:0:3:0: [sdc] Attached SCSI disk
Driver 'sr' needs updating - please use bus_type methods
sd 0:0:1:0: Attached scsi generic sg0 type 0
sd 0:0:2:0: Attached scsi generic sg1 type 0
sd 0:0:3:0: Attached scsi generic sg2 type 0
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
oprofile: using ppc64/power5 performance monitoring.
IPv4 over IPv4 tunneling driver
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
registered taskstats version 1
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 1984k freed
xics: unmask virq 17
 -> map to hwirq 0xa0000
xics: mask virq 17
xics: unmask virq 17
 -> map to hwirq 0xa0000
runlevel used greatest stack depth: 8816 bytes left
grep used greatest stack depth: 8160 bytes left
mount used greatest stack depth: 7344 bytes left
ckbcomp used greatest stack depth: 5920 bytes left
EXT3 FS on sdb1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1015680k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:1015680k
xics: unmask virq 18
 -> map to hwirq 0xa0002
warning: `dhclient3' uses 32-bit capabilities (legacy support in use)

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.27-rc5-test #22
---------------------------------------------------------
swapper/0 just changed the state of lock:
 (&hp->lock){+...}, at: [<c0000000002e61e0>] .hvc_poll+0x50/0x2f0
but this lock took another, hard-irq-unsafe lock in the past:
 (proc_subdir_lock){--..}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
no locks held by swapper/0.

the first lock's dependencies:
-> (&hp->lock){+...} ops: 1563368095744 {
   initial-use  at:
                        [<c000000000083464>] .lock_acquire+0xa4/0xec
                        [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
                        [<c0000000002e5ea0>] .hvc_get_by_index+0x54/0x110
                        [<c0000000002e5f90>] .hvc_open+0x34/0x14c
                        [<c0000000002cca74>] .tty_open+0x250/0x3b4
                        [<c0000000000e7b9c>] .chrdev_open+0x1c4/0x204
                        [<c0000000000e1f98>] .__dentry_open+0x190/0x308
                        [<c0000000000f2504>] .do_filp_open+0x400/0x84c
                        [<c0000000000e1d18>] .do_sys_open+0x80/0x140
                        [<c00000000000920c>] .init_post+0x4c/0x108
                        [<c000000000720d28>] .kernel_init+0x2a8/0x2cc
                        [<c000000000025f98>] .kernel_thread+0x54/0x70
   in-hardirq-W at:
                        [<c000000000083464>] .lock_acquire+0xa4/0xec
                        [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
                        [<c0000000002e61e0>] .hvc_poll+0x50/0x2f0
                        [<c0000000002e66d8>] .hvc_handle_interrupt+0x14/0x3c
                        [<c00000000009f140>] .handle_IRQ_event+0x50/0xc8
                        [<c0000000000a15e4>] .handle_fasteoi_irq+0x120/0x1bc
                        [<c000000000025e00>] .call_handle_irq+0x1c/0x2c
                        [<c00000000000d118>] .do_IRQ+0x128/0x1fc
                        [<c000000000004804>] hardware_interrupt_entry+0x1c/0x98
                        [<c000000000011ffc>] .cpu_idle+0x124/0x1f8
                        [<c0000000004e7c6c>] .rest_init+0x7c/0x94
                        [<c000000000720a58>] .start_kernel+0x48c/0x4b4
                        [<c000000000008368>] .start_here_common+0x1c/0x34
 }
 ... key      at: [<c000000001209a88>] __key.17726+0x0/0x8
 -> (&tty->buf.lock){....} ops: 146028888064 {
    initial-use  at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
                          [<c0000000002c987c>] .tty_buffer_request_room+0x40/0x198
                          [<c0000000002e6260>] .hvc_poll+0xd0/0x2f0
                          [<c0000000002e6504>] .khvcd+0x84/0x18c
                          [<c000000000071d20>] .kthread+0x78/0xc4
                          [<c000000000025f98>] .kernel_thread+0x54/0x70
  }
  ... key      at: [<c0000000011f7150>] __key.20956+0x0/0x8
  -> (&zone->lock){.+..} ops: 167834437025792 {
     initial-use  at:
                            [<c000000000083464>] .lock_acquire+0xa4/0xec
                            [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                            [<c0000000000ac73c>] .free_pages_bulk+0x60/0x318
                            [<c0000000000ad924>] .free_hot_cold_page+0x20c/0x278
                            [<c00000000073b684>] .free_all_bootmem_core+0x12c/0x240
                            [<c000000000731fe4>] .mem_init+0x9c/0x218
                            [<c000000000720968>] .start_kernel+0x39c/0x4b4
                            [<c000000000008368>] .start_here_common+0x1c/0x34
     in-softirq-W at:
                            [<c000000000083464>] .lock_acquire+0xa4/0xec
                            [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                            [<c0000000000adbc0>] .__free_pages_ok+0x1a4/0x414
                            [<c0000000000d9fbc>] .__free_slab+0x140/0x16c
                            [<c0000000000dbefc>] .kmem_cache_free+0xec/0x148
                            [<c00000000000f918>] .free_thread_info+0x24/0x3c
                            [<c000000000054e6c>] .free_task+0x30/0x60
                            [<c00000000005949c>] .delayed_put_task_struct+0x38/0x4c
                            [<c0000000000a2a30>] .__rcu_process_callbacks+0x1e4/0x2bc
                            [<c0000000000a2b44>] .rcu_process_callbacks+0x3c/0x64
                            [<c00000000005d9c4>] .__do_softirq+0xc8/0x198
                            [<c000000000025dd4>] .call_do_softirq+0x14/0x24
                            [<c00000000000caac>] .do_softirq+0x94/0x114
                            [<c00000000005db58>] .irq_exit+0x70/0x88
                            [<c000000000022b68>] .timer_interrupt+0xd4/0x100
                            [<c000000000003704>] decrementer_common+0x104/0x180
                            [<c000000000011ffc>] .cpu_idle+0x124/0x1f8
                            [<c0000000004ed9cc>] .start_secondary+0x350/0x388
                            [<c000000000008264>] .start_secondary_prolog+0x10/0x14
   }
   ... key      at: [<c00000000114c200>] __key.26488+0x0/0x8
  ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e713c>] ._spin_lock+0x44/0xa0
   [<c0000000000ac498>] .rmqueue_bulk+0x50/0xe0
   [<c0000000000ae2c0>] .get_page_from_freelist+0x2d4/0x758
   [<c0000000000aef30>] .__alloc_pages_internal+0x158/0x4dc
   [<c0000000000d2a00>] .alloc_pages_current+0xcc/0xf4
   [<c0000000000dafe4>] .new_slab+0x88/0x32c
   [<c0000000000db5dc>] .__slab_alloc+0x29c/0x51c
   [<c0000000000ddcec>] .__kmalloc+0xc4/0x160
   [<c0000000002c9924>] .tty_buffer_request_room+0xe8/0x198
   [<c0000000002e6260>] .hvc_poll+0xd0/0x2f0
   [<c0000000002e6504>] .khvcd+0x84/0x18c
   [<c000000000071d20>] .kthread+0x78/0xc4
   [<c000000000025f98>] .kernel_thread+0x54/0x70

 ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
   [<c0000000002c987c>] .tty_buffer_request_room+0x40/0x198
   [<c0000000002e6260>] .hvc_poll+0xd0/0x2f0
   [<c0000000002e6504>] .khvcd+0x84/0x18c
   [<c000000000071d20>] .kthread+0x78/0xc4
   [<c000000000025f98>] .kernel_thread+0x54/0x70

 -> (&irq_desc_lock_class){++..} ops: 18859201396736 {
    initial-use  at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
                          [<c0000000000a109c>] .set_irq_chip+0x60/0xac
                          [<c0000000000a115c>] .set_irq_chip_and_handler+0x20/0x48
                          [<c00000000003be54>] .xics_host_map+0x6c/0x90
                          [<c00000000000bf1c>] .irq_setup_virq+0x6c/0xa8
                          [<c00000000000c610>] .irq_create_mapping+0x108/0x13c
                          [<c000000000736410>] .smp_xics_probe+0x24/0xb4
                          [<c00000000073055c>] .smp_prepare_cpus+0x98/0x188
                          [<c000000000720ae4>] .kernel_init+0x64/0x2cc
                          [<c000000000025f98>] .kernel_thread+0x54/0x70
    in-hardirq-W at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                          [<c0000000000a1500>] .handle_fasteoi_irq+0x3c/0x1bc
                          [<c000000000025e00>] .call_handle_irq+0x1c/0x2c
                          [<c00000000000d118>] .do_IRQ+0x128/0x1fc
                          [<c000000000004804>] hardware_interrupt_entry+0x1c/0x98
                          [<c000000000011ffc>] .cpu_idle+0x124/0x1f8
                          [<c0000000004e7c6c>] .rest_init+0x7c/0x94
                          [<c000000000720a58>] .start_kernel+0x48c/0x4b4
                          [<c000000000008368>] .start_here_common+0x1c/0x34
    in-softirq-W at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                          [<c0000000000a1500>] .handle_fasteoi_irq+0x3c/0x1bc
                          [<c000000000025e00>] .call_handle_irq+0x1c/0x2c
                          [<c00000000000d118>] .do_IRQ+0x128/0x1fc
                          [<c000000000004804>] hardware_interrupt_entry+0x1c/0x98
                          [<c00000000005d988>] .__do_softirq+0x8c/0x198
                          [<c000000000025dd4>] .call_do_softirq+0x14/0x24
                          [<c00000000000caac>] .do_softirq+0x94/0x114
                          [<c00000000005db58>] .irq_exit+0x70/0x88
                          [<c000000000022b68>] .timer_interrupt+0xd4/0x100
                          [<c000000000003704>] decrementer_common+0x104/0x180
                          [<c000000000011ffc>] .cpu_idle+0x124/0x1f8
                          [<c0000000004e7c6c>] .rest_init+0x7c/0x94
                          [<c000000000720a58>] .start_kernel+0x48c/0x4b4
                          [<c000000000008368>] .start_here_common+0x1c/0x34
  }
  ... key      at: [<c0000000011480a8>] irq_desc_lock_class+0x0/0x8
  -> (old_style_spin_init){....} ops: 63750199574528 {
     initial-use  at:
                            [<c000000000083464>] .lock_acquire+0xa4/0xec
                            [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
                            [<c00000000001ccf8>] .rtas_call+0x80/0x288
                            [<c000000000038fc8>] .pSeries_cmo_feature_init+0x84/0x290
                            [<c00000000073599c>] .pSeries_init_early+0x64/0x8c
                            [<c000000000729754>] .setup_system+0x20c/0x3b0
                            [<c000000000008358>] .start_here_common+0xc/0x34
   }
   ... key      at: [<c000000000932160>] rtas+0x30/0xb0
  ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
   [<c00000000001ccf8>] .rtas_call+0x80/0x288
   [<c00000000003c064>] .xics_unmask_irq+0x90/0x114
   [<c00000000003c0f8>] .xics_startup+0x10/0x24
   [<c0000000000a0098>] .setup_irq+0x228/0x35c
   [<c0000000000a0290>] .request_irq+0xc4/0x114
   [<c00000000003a5ec>] .request_ras_irqs+0x184/0x1fc
   [<c000000000735be4>] .init_ras_IRQ+0x94/0xb8
   [<c000000000009044>] .do_one_initcall+0x8c/0x1c8
   [<c000000000720cd4>] .kernel_init+0x254/0x2cc
   [<c000000000025f98>] .kernel_thread+0x54/0x70

 ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
   [<c00000000009fba0>] .free_irq+0x6c/0x18c
   [<c0000000002e6634>] .notifier_del_irq+0x28/0x48
   [<c0000000002e5ddc>] .hvc_close+0xa0/0x110
   [<c0000000002cc328>] .release_dev+0x244/0x580
   [<c0000000002cc688>] .tty_release+0x24/0x44
   [<c0000000000e5384>] .__fput+0xf8/0x1dc
   [<c0000000000e1bec>] .filp_close+0xb4/0xdc
   [<c0000000000e33a4>] .sys_close+0xac/0x100
   [<c0000000000084d4>] syscall_exit+0x0/0x40

 -> (proc_subdir_lock){--..} ops: 15307263442944 {
    initial-use  at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                          [<c000000000139144>] .xlate_proc_name+0x50/0xf8
                          [<c0000000001395b4>] .__proc_create+0x6c/0x15c
                          [<c000000000139a54>] .create_proc_entry+0x6c/0xb0
                          [<c00000000073f9d0>] .proc_misc_init+0x3c/0x2f0
                          [<c00000000073f858>] .proc_root_init+0x78/0x104
                          [<c000000000720a40>] .start_kernel+0x474/0x4b4
                          [<c000000000008368>] .start_here_common+0x1c/0x34
    softirq-on-W at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                          [<c000000000139144>] .xlate_proc_name+0x50/0xf8
                          [<c0000000001395b4>] .__proc_create+0x6c/0x15c
                          [<c000000000139a54>] .create_proc_entry+0x6c/0xb0
                          [<c00000000073f9d0>] .proc_misc_init+0x3c/0x2f0
                          [<c00000000073f858>] .proc_root_init+0x78/0x104
                          [<c000000000720a40>] .start_kernel+0x474/0x4b4
                          [<c000000000008368>] .start_here_common+0x1c/0x34
    hardirq-on-W at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                          [<c000000000139144>] .xlate_proc_name+0x50/0xf8
                          [<c0000000001395b4>] .__proc_create+0x6c/0x15c
                          [<c000000000139a54>] .create_proc_entry+0x6c/0xb0
                          [<c00000000073f9d0>] .proc_misc_init+0x3c/0x2f0
                          [<c00000000073f858>] .proc_root_init+0x78/0x104
                          [<c000000000720a40>] .start_kernel+0x474/0x4b4
                          [<c000000000008368>] .start_here_common+0x1c/0x34
  }
  ... key      at: [<c000000000939018>] proc_subdir_lock+0x18/0x38
 ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e713c>] ._spin_lock+0x44/0xa0
   [<c000000000139144>] .xlate_proc_name+0x50/0xf8
   [<c0000000001392f4>] .remove_proc_entry+0x44/0x298
   [<c0000000000a1e74>] .unregister_handler_proc+0x40/0x58
   [<c00000000009fc58>] .free_irq+0x124/0x18c
   [<c0000000002e6634>] .notifier_del_irq+0x28/0x48
   [<c0000000002e5ddc>] .hvc_close+0xa0/0x110
   [<c0000000002cc328>] .release_dev+0x244/0x580
   [<c0000000002cc688>] .tty_release+0x24/0x44
   [<c0000000000e5384>] .__fput+0xf8/0x1dc
   [<c0000000000e1bec>] .filp_close+0xb4/0xdc
   [<c0000000000e33a4>] .sys_close+0xac/0x100
   [<c0000000000084d4>] syscall_exit+0x0/0x40

 -> (&ent->pde_unload_lock){--..} ops: 178743653957632 {
    initial-use  at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                          [<c000000000139384>] .remove_proc_entry+0xd4/0x298
                          [<c0000000000a1e74>] .unregister_handler_proc+0x40/0x58
                          [<c00000000009fc58>] .free_irq+0x124/0x18c
                          [<c0000000002e6634>] .notifier_del_irq+0x28/0x48
                          [<c0000000002e5ddc>] .hvc_close+0xa0/0x110
                          [<c0000000002cc328>] .release_dev+0x244/0x580
                          [<c0000000002cc688>] .tty_release+0x24/0x44
                          [<c0000000000e5384>] .__fput+0xf8/0x1dc
                          [<c0000000000e1bec>] .filp_close+0xb4/0xdc
                          [<c0000000000e33a4>] .sys_close+0xac/0x100
                          [<c0000000000084d4>] syscall_exit+0x0/0x40
    softirq-on-W at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                          [<c000000000133994>] .proc_reg_open+0x68/0x1a4
                          [<c0000000000e1f98>] .__dentry_open+0x190/0x308
                          [<c0000000000f2504>] .do_filp_open+0x400/0x84c
                          [<c0000000000e1d18>] .do_sys_open+0x80/0x140
                          [<c000000000122b80>] .compat_sys_open+0x24/0x38
                          [<c0000000000084d4>] syscall_exit+0x0/0x40
    hardirq-on-W at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                          [<c000000000133994>] .proc_reg_open+0x68/0x1a4
                          [<c0000000000e1f98>] .__dentry_open+0x190/0x308
                          [<c0000000000f2504>] .do_filp_open+0x400/0x84c
                          [<c0000000000e1d18>] .do_sys_open+0x80/0x140
                          [<c000000000122b80>] .compat_sys_open+0x24/0x38
                          [<c0000000000084d4>] syscall_exit+0x0/0x40
  }
  ... key      at: [<c00000000114f99c>] __key.16461+0x0/0xc
 ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e713c>] ._spin_lock+0x44/0xa0
   [<c000000000139384>] .remove_proc_entry+0xd4/0x298
   [<c0000000000a1e74>] .unregister_handler_proc+0x40/0x58
   [<c00000000009fc58>] .free_irq+0x124/0x18c
   [<c0000000002e6634>] .notifier_del_irq+0x28/0x48
   [<c0000000002e5ddc>] .hvc_close+0xa0/0x110
   [<c0000000002cc328>] .release_dev+0x244/0x580
   [<c0000000002cc688>] .tty_release+0x24/0x44
   [<c0000000000e5384>] .__fput+0xf8/0x1dc
   [<c0000000000e1bec>] .filp_close+0xb4/0xdc
   [<c0000000000e33a4>] .sys_close+0xac/0x100
   [<c0000000000084d4>] syscall_exit+0x0/0x40

 -> (proc_inum_lock){--..} ops: 3435973836800 {
    initial-use  at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                          [<c000000000139754>] .proc_register+0x64/0x224
                          [<c000000000139a68>] .create_proc_entry+0x80/0xb0
                          [<c00000000073f9d0>] .proc_misc_init+0x3c/0x2f0
                          [<c00000000073f858>] .proc_root_init+0x78/0x104
                          [<c000000000720a40>] .start_kernel+0x474/0x4b4
                          [<c000000000008368>] .start_here_common+0x1c/0x34
    softirq-on-W at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                          [<c000000000139754>] .proc_register+0x64/0x224
                          [<c000000000139a68>] .create_proc_entry+0x80/0xb0
                          [<c00000000073f9d0>] .proc_misc_init+0x3c/0x2f0
                          [<c00000000073f858>] .proc_root_init+0x78/0x104
                          [<c000000000720a40>] .start_kernel+0x474/0x4b4
                          [<c000000000008368>] .start_here_common+0x1c/0x34
    hardirq-on-W at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                          [<c000000000139754>] .proc_register+0x64/0x224
                          [<c000000000139a68>] .create_proc_entry+0x80/0xb0
                          [<c00000000073f9d0>] .proc_misc_init+0x3c/0x2f0
                          [<c00000000073f858>] .proc_root_init+0x78/0x104
                          [<c000000000720a40>] .start_kernel+0x474/0x4b4
                          [<c000000000008368>] .start_here_common+0x1c/0x34
  }
  ... key      at: [<c000000000939050>] proc_inum_lock+0x18/0x38
  -> (proc_inum_ida.lock){....} ops: 6932077215744 {
     initial-use  at:
                            [<c000000000083464>] .lock_acquire+0xa4/0xec
                            [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
                            [<c000000000252fd0>] .idr_pre_get+0x5c/0xc0
                            [<c00000000025305c>] .ida_pre_get+0x28/0xa8
                            [<c000000000139740>] .proc_register+0x50/0x224
                            [<c000000000139a68>] .create_proc_entry+0x80/0xb0
                            [<c00000000073f9d0>] .proc_misc_init+0x3c/0x2f0
                            [<c00000000073f858>] .proc_root_init+0x78/0x104
                            [<c000000000720a40>] .start_kernel+0x474/0x4b4
                            [<c000000000008368>] .start_here_common+0x1c/0x34
   }
   ... key      at: [<c0000000009390a0>] proc_inum_ida+0x30/0x58
  ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
   [<c000000000252768>] .get_from_free_list+0x28/0x84
   [<c0000000002528f4>] .idr_get_empty_slot+0x5c/0x2ec
   [<c000000000252c04>] .ida_get_new_above+0x80/0x28c
   [<c000000000139764>] .proc_register+0x74/0x224
   [<c000000000139a68>] .create_proc_entry+0x80/0xb0
   [<c00000000073f9d0>] .proc_misc_init+0x3c/0x2f0
   [<c00000000073f858>] .proc_root_init+0x78/0x104
   [<c000000000720a40>] .start_kernel+0x474/0x4b4
   [<c000000000008368>] .start_here_common+0x1c/0x34

 ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e713c>] ._spin_lock+0x44/0xa0
   [<c000000000139238>] .free_proc_entry+0x4c/0xc4
   [<c000000000139518>] .remove_proc_entry+0x268/0x298
   [<c0000000000a1e74>] .unregister_handler_proc+0x40/0x58
   [<c00000000009fc58>] .free_irq+0x124/0x18c
   [<c0000000002e6634>] .notifier_del_irq+0x28/0x48
   [<c0000000002e5ddc>] .hvc_close+0xa0/0x110
   [<c0000000002cc328>] .release_dev+0x244/0x580
   [<c0000000002cc688>] .tty_release+0x24/0x44
   [<c0000000000e5384>] .__fput+0xf8/0x1dc
   [<c0000000000e1bec>] .filp_close+0xb4/0xdc
   [<c0000000000e33a4>] .sys_close+0xac/0x100
   [<c0000000000084d4>] syscall_exit+0x0/0x40

 -> (&q->lock){.+..} ops: 265274360070144 {
    initial-use  at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e76d0>] ._spin_lock_irq+0x58/0xb4
                          [<c0000000004e32f4>] .wait_for_common+0x48/0x1d4
                          [<c000000000071c50>] .kthread_create+0xb8/0x110
                          [<c0000000004eb0b0>] .migration_call+0xc8/0x660
                          [<c000000000736d8c>] .migration_init+0x34/0x90
                          [<c000000000009044>] .do_one_initcall+0x8c/0x1c8
                          [<c000000000720b00>] .kernel_init+0x80/0x2cc
                          [<c000000000025f98>] .kernel_thread+0x54/0x70
    in-softirq-W at:
                          [<c000000000083464>] .lock_acquire+0xa4/0xec
                          [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
                          [<c00000000004862c>] .complete+0x28/0x80
                          [<c00000000006ec0c>] .wakeme_after_rcu+0x14/0x28
                          [<c0000000000a2a30>] .__rcu_process_callbacks+0x1e4/0x2bc
                          [<c0000000000a2b44>] .rcu_process_callbacks+0x3c/0x64
                          [<c00000000005d9c4>] .__do_softirq+0xc8/0x198
                          [<c000000000025dd4>] .call_do_softirq+0x14/0x24
                          [<c00000000000caac>] .do_softirq+0x94/0x114
                          [<c00000000005db58>] .irq_exit+0x70/0x88
                          [<c000000000022b68>] .timer_interrupt+0xd4/0x100
                          [<c000000000003704>] decrementer_common+0x104/0x180
                          [<c000000000011ffc>] .cpu_idle+0x124/0x1f8
                          [<c0000000004e7c6c>] .rest_init+0x7c/0x94
                          [<c000000000720a58>] .start_kernel+0x48c/0x4b4
                          [<c000000000008368>] .start_here_common+0x1c/0x34
  }
  ... key      at: [<c000000000b17968>] __key.14384+0x0/0x8
  -> (&rq->lock){++..} ops: 19113192877719552 {
     initial-use  at:
                            [<c000000000083464>] .lock_acquire+0xa4/0xec
                            [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
                            [<c000000000048404>] .rq_attach_root+0x30/0x1a8
                            [<c0000000007371e8>] .sched_init+0x334/0x408
                            [<c0000000007207a8>] .start_kernel+0x1dc/0x4b4
                            [<c000000000008368>] .start_here_common+0x1c/0x34
     in-hardirq-W at:
                            [<c000000000083464>] .lock_acquire+0xa4/0xec
                            [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                            [<c000000000053fac>] .scheduler_tick+0x48/0x154
                            [<c0000000000643f0>] .update_process_times+0x60/0x8c
                            [<c00000000007c7c4>] .tick_periodic+0x9c/0xc4
                            [<c00000000007c824>] .tick_handle_periodic+0x38/0xbc
                            [<c000000000022b40>] .timer_interrupt+0xac/0x100
                            [<c000000000003704>] decrementer_common+0x104/0x180
                            [<c00000000025eb00>] .dotest+0x4dc/0x544
                            [<c00000000026c8f4>] .locking_selftest+0x124/0x17ec
                            [<c0000000007208f8>] .start_kernel+0x32c/0x4b4
                            [<c000000000008368>] .start_here_common+0x1c/0x34
     in-softirq-W at:
                            [<c000000000083464>] .lock_acquire+0xa4/0xec
                            [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
                            [<c000000000053854>] .tg_shares_up+0x108/0x20c
                            [<c000000000048384>] .walk_tg_tree+0xf0/0x140
                            [<c00000000004dda0>] .run_rebalance_domains+0x1ac/0x5fc
                            [<c00000000005d9c4>] .__do_softirq+0xc8/0x198
                            [<c000000000025dd4>] .call_do_softirq+0x14/0x24
                            [<c00000000000caac>] .do_softirq+0x94/0x114
                            [<c00000000005db58>] .irq_exit+0x70/0x88
                            [<c000000000022b68>] .timer_interrupt+0xd4/0x100
                            [<c000000000003704>] decrementer_common+0x104/0x180
                            [<c000000000011ffc>] .cpu_idle+0x124/0x1f8
                            [<c0000000004e7c6c>] .rest_init+0x7c/0x94
                            [<c000000000720a58>] .start_kernel+0x48c/0x4b4
                            [<c000000000008368>] .start_here_common+0x1c/0x34
   }
   ... key      at: [<c000000000af04e8>] __key.39338+0x0/0x8
   -> (&vec->lock){++..} ops: 11192684773376 {
      initial-use  at:
                              [<c000000000083464>] .lock_acquire+0xa4/0xec
                              [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
                              [<c0000000000a4c18>] .cpupri_set+0x12c/0x1f0
                              [<c00000000004b3d4>] .rq_online_rt+0xac/0xc4
                              [<c000000000046c38>] .set_rq_online+0xa8/0xd4
                              [<c000000000048548>] .rq_attach_root+0x174/0x1a8
                              [<c0000000007371e8>] .sched_init+0x334/0x408
                              [<c0000000007207a8>] .start_kernel+0x1dc/0x4b4
                              [<c000000000008368>] .start_here_common+0x1c/0x34
      in-hardirq-W at:
                              [<c000000000083464>] .lock_acquire+0xa4/0xec
                              [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
                              [<c0000000000a4b64>] .cpupri_set+0x78/0x1f0
                              [<c00000000004c0f8>] .__enqueue_rt_entity+0x114/0x1d0
                              [<c00000000004c25c>] .enqueue_task_rt+0x4c/0x84
                              [<c0000000000472d0>] .enqueue_task+0x84/0xac
                              [<c000000000047328>] .activate_task+0x30/0x50
                              [<c00000000004dafc>] .try_to_wake_up+0x1a0/0x27c
                              [<c00000000009eabc>] .softlockup_tick+0x130/0x214
                              [<c000000000064064>] .run_local_timers+0x24/0x38
                              [<c0000000000643c8>] .update_process_times+0x38/0x8c
                              [<c00000000007c7c4>] .tick_periodic+0x9c/0xc4
                              [<c00000000007c824>] .tick_handle_periodic+0x38/0xbc
                              [<c000000000022b40>] .timer_interrupt+0xac/0x100
                              [<c000000000003704>] decrementer_common+0x104/0x180
                              [<c000000000011ffc>] .cpu_idle+0x124/0x1f8
                              [<c0000000004ed9cc>] .start_secondary+0x350/0x388
                              [<c000000000008264>] .start_secondary_prolog+0x10/0x14
      in-softirq-W at:
                              [<c000000000083464>] .lock_acquire+0xa4/0xec
                              [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
                              [<c0000000000a4b64>] .cpupri_set+0x78/0x1f0
                              [<c00000000004c0f8>] .__enqueue_rt_entity+0x114/0x1d0
                              [<c00000000004c25c>] .enqueue_task_rt+0x4c/0x84
                              [<c0000000000472d0>] .enqueue_task+0x84/0xac
                              [<c000000000047328>] .activate_task+0x30/0x50
                              [<c00000000004dafc>] .try_to_wake_up+0x1a0/0x27c
                              [<c00000000004e018>] .run_rebalance_domains+0x424/0x5fc
                              [<c00000000005d9c4>] .__do_softirq+0xc8/0x198
                              [<c000000000025dd4>] .call_do_softirq+0x14/0x24
                              [<c00000000000caac>] .do_softirq+0x94/0x114
                              [<c00000000005db58>] .irq_exit+0x70/0x88
                              [<c000000000022b68>] .timer_interrupt+0xd4/0x100
                              [<c000000000003704>] decrementer_common+0x104/0x180
                              [<c000000000011ffc>] .cpu_idle+0x124/0x1f8
                              [<c0000000004ed9cc>] .start_secondary+0x350/0x388
                              [<c000000000008264>] .start_secondary_prolog+0x10/0x14
    }
    ... key      at: [<c0000000011480f0>] __key.11749+0x0/0x10
   ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
   [<c0000000000a4c18>] .cpupri_set+0x12c/0x1f0
   [<c00000000004b3d4>] .rq_online_rt+0xac/0xc4
   [<c000000000046c38>] .set_rq_online+0xa8/0xd4
   [<c000000000048548>] .rq_attach_root+0x174/0x1a8
   [<c0000000007371e8>] .sched_init+0x334/0x408
   [<c0000000007207a8>] .start_kernel+0x1dc/0x4b4
   [<c000000000008368>] .start_here_common+0x1c/0x34

   -> (&rt_b->rt_runtime_lock){++..} ops: 210453397504 {
      initial-use  at:
                              [<c000000000083464>] .lock_acquire+0xa4/0xec
                              [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                              [<c00000000004c148>] .__enqueue_rt_entity+0x164/0x1d0
                              [<c00000000004c25c>] .enqueue_task_rt+0x4c/0x84
                              [<c0000000000472d0>] .enqueue_task+0x84/0xac
                              [<c000000000047328>] .activate_task+0x30/0x50
                              [<c00000000004dafc>] .try_to_wake_up+0x1a0/0x27c
                              [<c0000000004eb14c>] .migration_call+0x164/0x660
                              [<c000000000736db8>] .migration_init+0x60/0x90
                              [<c000000000009044>] .do_one_initcall+0x8c/0x1c8
                              [<c000000000720b00>] .kernel_init+0x80/0x2cc
                              [<c000000000025f98>] .kernel_thread+0x54/0x70
      in-hardirq-W at:
                              [<c000000000083464>] .lock_acquire+0xa4/0xec
                              [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                              [<c00000000004c148>] .__enqueue_rt_entity+0x164/0x1d0
                              [<c00000000004c25c>] .enqueue_task_rt+0x4c/0x84
                              [<c0000000000472d0>] .enqueue_task+0x84/0xac
                              [<c000000000047328>] .activate_task+0x30/0x50
                              [<c00000000004dafc>] .try_to_wake_up+0x1a0/0x27c
                              [<c00000000009eabc>] .softlockup_tick+0x130/0x214
                              [<c000000000064064>] .run_local_timers+0x24/0x38
                              [<c0000000000643c8>] .update_process_times+0x38/0x8c
                              [<c00000000007c7c4>] .tick_periodic+0x9c/0xc4
                              [<c00000000007c824>] .tick_handle_periodic+0x38/0xbc
                              [<c000000000022b40>] .timer_interrupt+0xac/0x100
                              [<c000000000003704>] decrementer_common+0x104/0x180
                              [<c000000000011ffc>] .cpu_idle+0x124/0x1f8
                              [<c0000000004ed9cc>] .start_secondary+0x350/0x388
                              [<c000000000008264>] .start_secondary_prolog+0x10/0x14
      in-softirq-W at:
                              [<c000000000083464>] .lock_acquire+0xa4/0xec
                              [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                              [<c00000000004c148>] .__enqueue_rt_entity+0x164/0x1d0
                              [<c00000000004c25c>] .enqueue_task_rt+0x4c/0x84
                              [<c0000000000472d0>] .enqueue_task+0x84/0xac
                              [<c000000000047328>] .activate_task+0x30/0x50
                              [<c00000000004dafc>] .try_to_wake_up+0x1a0/0x27c
                              [<c00000000004e018>] .run_rebalance_domains+0x424/0x5fc
                              [<c00000000005d9c4>] .__do_softirq+0xc8/0x198
                              [<c000000000025dd4>] .call_do_softirq+0x14/0x24
                              [<c00000000000caac>] .do_softirq+0x94/0x114
                              [<c00000000005db58>] .irq_exit+0x70/0x88
                              [<c000000000022b68>] .timer_interrupt+0xd4/0x100
                              [<c000000000003704>] decrementer_common+0x104/0x180
                              [<c000000000011ffc>] .cpu_idle+0x124/0x1f8
                              [<c0000000004ed9cc>] .start_secondary+0x350/0x388
                              [<c000000000008264>] .start_secondary_prolog+0x10/0x14
    }
    ... key      at: [<c000000000af04e0>] __key.31617+0x0/0x8
    -> (&cpu_base->lock){++..} ops: 700504871010304 {
       initial-use  at:
                                [<c000000000083464>] .lock_acquire+0xa4/0xec
                                [<c0000000004e76d0>] ._spin_lock_irq+0x58/0xb4
                                [<c000000000075928>] .hrtimer_run_pending+0x3c/0x10c
                                [<c000000000063a34>] .run_timer_softirq+0x54/0x268
                                [<c00000000005d9c4>] .__do_softirq+0xc8/0x198
                                [<c000000000025dd4>] .call_do_softirq+0x14/0x24
                                [<c00000000000caac>] .do_softirq+0x94/0x114
                                [<c00000000005db58>] .irq_exit+0x70/0x88
                                [<c000000000022b68>] .timer_interrupt+0xd4/0x100
                                [<c000000000003704>] decrementer_common+0x104/0x180
                                [<c00000000025eb00>] .dotest+0x4dc/0x544
                                [<c00000000026c8f4>] .locking_selftest+0x124/0x17ec
                                [<c0000000007208f8>] .start_kernel+0x32c/0x4b4
                                [<c000000000008368>] .start_here_common+0x1c/0x34
       in-hardirq-W at:
                                [<c000000000083464>] .lock_acquire+0xa4/0xec
                                [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                                [<c00000000007502c>] .hrtimer_run_queues+0x178/0x318
                                [<c000000000064050>] .run_local_timers+0x10/0x38
                                [<c0000000000643c8>] .update_process_times+0x38/0x8c
                                [<c00000000007c7c4>] .tick_periodic+0x9c/0xc4
                                [<c00000000007c824>] .tick_handle_periodic+0x38/0xbc
                                [<c000000000022b40>] .timer_interrupt+0xac/0x100
                                [<c000000000003704>] decrementer_common+0x104/0x180
                                [<c0000000004e6e7c>] ._spin_unlock_irqrestore+0x60/0x88
                                [<c00000000001ce64>] .rtas_call+0x1ec/0x288
                                [<c0000000004ef0f4>] .smp_pSeries_kick_cpu+0xc0/0x10c
                                [<c0000000004ea98c>] .__cpu_up+0x114/0x254
                                [<c0000000004eb950>] .cpu_up+0x11c/0x1f0
                                [<c000000000720bdc>] .kernel_init+0x15c/0x2cc
                                [<c000000000025f98>] .kernel_thread+0x54/0x70
       in-softirq-W at:
                                [<c000000000083464>] .lock_acquire+0xa4/0xec
                                [<c0000000004e76d0>] ._spin_lock_irq+0x58/0xb4
                                [<c000000000075928>] .hrtimer_run_pending+0x3c/0x10c
                                [<c000000000063a34>] .run_timer_softirq+0x54/0x268
                                [<c00000000005d9c4>] .__do_softirq+0xc8/0x198
                                [<c000000000025dd4>] .call_do_softirq+0x14/0x24
                                [<c00000000000caac>] .do_softirq+0x94/0x114
                                [<c00000000005db58>] .irq_exit+0x70/0x88
                                [<c000000000022b68>] .timer_interrupt+0xd4/0x100
                                [<c000000000003704>] decrementer_common+0x104/0x180
                                [<c00000000025eb00>] .dotest+0x4dc/0x544
                                [<c00000000026c8f4>] .locking_selftest+0x124/0x17ec
                                [<c0000000007208f8>] .start_kernel+0x32c/0x4b4
                                [<c000000000008368>] .start_here_common+0x1c/0x34
     }
     ... key      at: [<c000000000b179a0>] __key.18246+0x0/0x8
    ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
   [<c0000000000752ac>] .lock_hrtimer_base+0x34/0x8c
   [<c0000000000754d0>] .hrtimer_start+0x4c/0x1b0
   [<c00000000004c180>] .__enqueue_rt_entity+0x19c/0x1d0
   [<c00000000004c25c>] .enqueue_task_rt+0x4c/0x84
   [<c0000000000472d0>] .enqueue_task+0x84/0xac
   [<c000000000047328>] .activate_task+0x30/0x50
   [<c00000000004dafc>] .try_to_wake_up+0x1a0/0x27c
   [<c0000000004eb14c>] .migration_call+0x164/0x660
   [<c000000000736db8>] .migration_init+0x60/0x90
   [<c000000000009044>] .do_one_initcall+0x8c/0x1c8
   [<c000000000720b00>] .kernel_init+0x80/0x2cc
   [<c000000000025f98>] .kernel_thread+0x54/0x70

    -> (&rt_rq->rt_runtime_lock){+...} ops: 6090263625728 {
       initial-use  at:
                                [<c000000000083464>] .lock_acquire+0xa4/0xec
                                [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                                [<c00000000004bc28>] .update_curr_rt+0xac/0x144
                                [<c00000000004c1d4>] .dequeue_task_rt+0x20/0x5c
                                [<c0000000000471d0>] .dequeue_task+0xdc/0x108
                                [<c00000000004722c>] .deactivate_task+0x30/0x50
                                [<c0000000004e36f0>] .schedule+0x1b8/0x804
                                [<c000000000051d68>] .migration_thread+0x230/0x324
                                [<c000000000071d20>] .kthread+0x78/0xc4
                                [<c000000000025f98>] .kernel_thread+0x54/0x70
       in-hardirq-W at:
                                [<c000000000083464>] .lock_acquire+0xa4/0xec
                                [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                                [<c00000000004bec0>] .sched_rt_period_timer+0xd4/0x1f8
                                [<c0000000000750d0>] .hrtimer_run_queues+0x21c/0x318
                                [<c000000000064050>] .run_local_timers+0x10/0x38
                                [<c0000000000643c8>] .update_process_times+0x38/0x8c
                                [<c00000000007c7c4>] .tick_periodic+0x9c/0xc4
                                [<c00000000007c824>] .tick_handle_periodic+0x38/0xbc
                                [<c000000000022b40>] .timer_interrupt+0xac/0x100
                                [<c000000000003704>] decrementer_common+0x104/0x180
                                [<c000000000011ffc>] .cpu_idle+0x124/0x1f8
                                [<c0000000004e7c6c>] .rest_init+0x7c/0x94
                                [<c000000000720a58>] .start_kernel+0x48c/0x4b4
                                [<c000000000008368>] .start_here_common+0x1c/0x34
     }
     ... key      at: [<c000000000af04f0>] __key.39293+0x0/0x8
    ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e713c>] ._spin_lock+0x44/0xa0
   [<c000000000049fc4>] .__enable_runtime+0x60/0xb0
   [<c00000000004b3c0>] .rq_online_rt+0x98/0xc4
   [<c000000000046c38>] .set_rq_online+0xa8/0xd4
   [<c0000000004eb1b0>] .migration_call+0x1c8/0x660
   [<c000000000076a14>] .notifier_call_chain+0x68/0xdc
   [<c0000000004eb9bc>] .cpu_up+0x188/0x1f0
   [<c000000000720bdc>] .kernel_init+0x15c/0x2cc
   [<c000000000025f98>] .kernel_thread+0x54/0x70

   ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e713c>] ._spin_lock+0x44/0xa0
   [<c00000000004c148>] .__enqueue_rt_entity+0x164/0x1d0
   [<c00000000004c25c>] .enqueue_task_rt+0x4c/0x84
   [<c0000000000472d0>] .enqueue_task+0x84/0xac
   [<c000000000047328>] .activate_task+0x30/0x50
   [<c00000000004dafc>] .try_to_wake_up+0x1a0/0x27c
   [<c0000000004eb14c>] .migration_call+0x164/0x660
   [<c000000000736db8>] .migration_init+0x60/0x90
   [<c000000000009044>] .do_one_initcall+0x8c/0x1c8
   [<c000000000720b00>] .kernel_init+0x80/0x2cc
   [<c000000000025f98>] .kernel_thread+0x54/0x70

   ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e713c>] ._spin_lock+0x44/0xa0
   [<c00000000004bc28>] .update_curr_rt+0xac/0x144
   [<c00000000004c1d4>] .dequeue_task_rt+0x20/0x5c
   [<c0000000000471d0>] .dequeue_task+0xdc/0x108
   [<c00000000004722c>] .deactivate_task+0x30/0x50
   [<c0000000004e36f0>] .schedule+0x1b8/0x804
   [<c000000000051d68>] .migration_thread+0x230/0x324
   [<c000000000071d20>] .kthread+0x78/0xc4
   [<c000000000025f98>] .kernel_thread+0x54/0x70

   -> (&rq->lock/1){.+..} ops: 5330054414336 {
      initial-use  at:
                              [<c000000000083464>] .lock_acquire+0xa4/0xec
                              [<c0000000004e709c>] ._spin_lock_nested+0x44/0xa0
                              [<c00000000004c450>] .double_rq_lock+0x78/0xc8
                              [<c00000000004c548>] .__migrate_task+0xa8/0x194
                              [<c000000000051db0>] .migration_thread+0x278/0x324
                              [<c000000000071d20>] .kthread+0x78/0xc4
                              [<c000000000025f98>] .kernel_thread+0x54/0x70
      in-softirq-W at:
                              [<c000000000083464>] .lock_acquire+0xa4/0xec
                              [<c0000000004e709c>] ._spin_lock_nested+0x44/0xa0
                              [<c00000000004c450>] .double_rq_lock+0x78/0xc8
                              [<c00000000004de30>] .run_rebalance_domains+0x23c/0x5fc
                              [<c00000000005d9c4>] .__do_softirq+0xc8/0x198
                              [<c000000000025dd4>] .call_do_softirq+0x14/0x24
                              [<c00000000000caac>] .do_softirq+0x94/0x114
                              [<c00000000005db58>] .irq_exit+0x70/0x88
                              [<c000000000022b68>] .timer_interrupt+0xd4/0x100
                              [<c000000000003704>] decrementer_common+0x104/0x180
                              [<c000000000011ffc>] .cpu_idle+0x124/0x1f8
                              [<c0000000004ed9cc>] .start_secondary+0x350/0x388
                              [<c000000000008264>] .start_secondary_prolog+0x10/0x14
    }
    ... key      at: [<c000000000af04e9>] __key.39338+0x1/0x8
   ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e709c>] ._spin_lock_nested+0x44/0xa0
   [<c00000000004c450>] .double_rq_lock+0x78/0xc8
   [<c00000000004c548>] .__migrate_task+0xa8/0x194
   [<c000000000051db0>] .migration_thread+0x278/0x324
   [<c000000000071d20>] .kthread+0x78/0xc4
   [<c000000000025f98>] .kernel_thread+0x54/0x70

  ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e713c>] ._spin_lock+0x44/0xa0
   [<c000000000048a00>] .task_rq_lock+0x70/0xd4
   [<c00000000004da30>] .try_to_wake_up+0xd4/0x27c
   [<c000000000046a04>] .__wake_up_common+0x6c/0xe0
   [<c000000000048658>] .complete+0x54/0x80
   [<c000000000071ce0>] .kthread+0x38/0xc4
   [<c000000000025f98>] .kernel_thread+0x54/0x70

 ... acquired at:
   [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
   [<c000000000083464>] .lock_acquire+0xa4/0xec
   [<c0000000004e7614>] ._spin_lock_irqsave+0x5c/0xc0
   [<c000000000048744>] .__wake_up+0x34/0x88
   [<c0000000002c9168>] .tty_wakeup+0x88/0xa4
   [<c0000000002e6400>] .hvc_poll+0x270/0x2f0
   [<c0000000002e6504>] .khvcd+0x84/0x18c
   [<c000000000071d20>] .kthread+0x78/0xc4
   [<c000000000025f98>] .kernel_thread+0x54/0x70


the second lock's dependencies:
-> (proc_subdir_lock){--..} ops: 15307263442944 {
   initial-use  at:
                        [<c000000000083464>] .lock_acquire+0xa4/0xec
                        [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                        [<c000000000139144>] .xlate_proc_name+0x50/0xf8
                        [<c0000000001395b4>] .__proc_create+0x6c/0x15c
                        [<c000000000139a54>] .create_proc_entry+0x6c/0xb0
                        [<c00000000073f9d0>] .proc_misc_init+0x3c/0x2f0
                        [<c00000000073f858>] .proc_root_init+0x78/0x104
                        [<c000000000720a40>] .start_kernel+0x474/0x4b4
                        [<c000000000008368>] .start_here_common+0x1c/0x34
   softirq-on-W at:
                        [<c000000000083464>] .lock_acquire+0xa4/0xec
                        [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                        [<c000000000139144>] .xlate_proc_name+0x50/0xf8
                        [<c0000000001395b4>] .__proc_create+0x6c/0x15c
                        [<c000000000139a54>] .create_proc_entry+0x6c/0xb0
                        [<c00000000073f9d0>] .proc_misc_init+0x3c/0x2f0
                        [<c00000000073f858>] .proc_root_init+0x78/0x104
                        [<c000000000720a40>] .start_kernel+0x474/0x4b4
                        [<c000000000008368>] .start_here_common+0x1c/0x34
   hardirq-on-W at:
                        [<c000000000083464>] .lock_acquire+0xa4/0xec
                        [<c0000000004e713c>] ._spin_lock+0x44/0xa0
                        [<c000000000139144>] .xlate_proc_name+0x50/0xf8
                        [<c0000000001395b4>] .__proc_create+0x6c/0x15c
                        [<c000000000139a54>] .create_proc_entry+0x6c/0xb0
                        [<c00000000073f9d0>] .proc_misc_init+0x3c/0x2f0
                        [<c00000000073f858>] .proc_root_init+0x78/0x104
                        [<c000000000720a40>] .start_kernel+0x474/0x4b4
                        [<c000000000008368>] .start_here_common+0x1c/0x34
 }
 ... key      at: [<c000000000939018>] proc_subdir_lock+0x18/0x38

stack backtrace:
Call Trace:
[c00000000fffb890] [c00000000000fa14] .show_stack+0x78/0x17c (unreliable)
[c00000000fffb940] [c00000000007ee54] .print_irq_inversion_bug+0x1a4/0x1d4
[c00000000fffb9e0] [c000000000080a80] .mark_lock+0x320/0xa1c
[c00000000fffba80] [c00000000008310c] .__lock_acquire+0x638/0x8ec
[c00000000fffbb70] [c000000000083464] .lock_acquire+0xa4/0xec
[c00000000fffbc30] [c0000000004e7614] ._spin_lock_irqsave+0x5c/0xc0
[c00000000fffbcd0] [c0000000002e61e0] .hvc_poll+0x50/0x2f0
[c00000000fffbdd0] [c0000000002e66d8] .hvc_handle_interrupt+0x14/0x3c
[c00000000fffbe50] [c00000000009f140] .handle_IRQ_event+0x50/0xc8
[c00000000fffbef0] [c0000000000a15e4] .handle_fasteoi_irq+0x120/0x1bc
[c00000000fffbf90] [c000000000025e00] .call_handle_irq+0x1c/0x2c
[c000000000a43a40] [c00000000000d118] .do_IRQ+0x128/0x1fc
[c000000000a43ae0] [c000000000004804] hardware_interrupt_entry+0x1c/0x98
--- Exception: 501 at .raw_local_irq_restore+0x3c/0x40
    LR = .cpu_idle+0x130/0x1f8
[c000000000a43dd0] [c000000000011ffc] .cpu_idle+0x124/0x1f8 (unreliable)
[c000000000a43e60] [c0000000004e7c6c] .rest_init+0x7c/0x94
[c000000000a43ee0] [c000000000720a58] .start_kernel+0x48c/0x4b4
[c000000000a43f90] [c000000000008368] .start_here_common+0x1c/0x34


