Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbYDWM3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbYDWM3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYDWM3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:29:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55457
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbYDWM32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:29:28 -0400
Date: Wed, 23 Apr 2008 05:29:28 -0700 (PDT)
Message-Id: <20080423.052928.142823681.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, a.p.zijlstra@chello.nl
Subject: Re: [patch] softlockup: fix false positives on nohz if CPU is 100%
 idle for more than 60 seconds
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080423.035544.110883549.davem@davemloft.net>
References: <20080422.030519.259068348.davem@davemloft.net>
	<20080423085030.GA22309@elte.hu>
	<20080423.035544.110883549.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Wed_Apr_23_05_29_28_2008_136)--"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----Next_Part(Wed_Apr_23_05_29_28_2008_136)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: David Miller <davem@davemloft.net>
Date: Wed, 23 Apr 2008 03:55:44 -0700 (PDT)

> It may take some time, as each test run the verify the existence
> of the problem takes several minutes.

Ok, Ingo, none of your patches fix even the initial buggy
changeset, for reference:

commit 27ec4407790d075c325e1f4da0a19c56953cce23
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Feb 28 21:00:21 2008 +0100

    sched: make cpu_clock() globally synchronous
    
    Alexey Zaytsev reported (and bisected) that the introduction of
    cpu_clock() in printk made the timestamps jump back and forth.
    
    Make cpu_clock() more reliable while still keeping it fast when it's
    called frequently.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

I checked out a tree to the changeset before this one, just
to double check, and there are no problems.

I add that changeset and I get softlockup warnings like crazy
in my logs.

I added your "move touch_softlockup_watchdog() earlier in
tick_nohz_update_jiffies()" patch:

--------------------
Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -133,8 +133,6 @@ void tick_nohz_update_jiffies(void)
 	if (!ts->tick_stopped)
 		return;
 
-	touch_softlockup_watchdog();
-
 	cpu_clear(cpu, nohz_cpu_mask);
 	now = ktime_get();
 	ts->idle_waketime = now;
@@ -142,6 +140,8 @@ void tick_nohz_update_jiffies(void)
 	local_irq_save(flags);
 	tick_do_update_jiffies64(now);
 	local_irq_restore(flags);
+
+	touch_softlockup_watchdog();
 }
 
 void tick_nohz_stop_idle(int cpu)
--------------------

and still I get mountains of softlockup messages, see first
attachment, below.

I then added your patch, just to make sure, which adds the
missing prev_cpu_time assignment, specifically:

--------------------
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1001,6 +1001,8 @@ unsigned long long notrace cpu_clock(int
 	if (unlikely(delta_time > time_sync_thresh))
 		time = __sync_cpu_clock(time, cpu);
 
+	per_cpu(prev_cpu_time, cpu) = time;
+
 	return time;
 }
 EXPORT_SYMBOL_GPL(cpu_clock);

--------------------

Same problem, see second attachment, below.

But, to be honest, this is starting to become an exercise in futility.
None of your patches fix anything.  Something is buggy about how your
new cpu_clock() stuff works.  I'm trying to figure out when you're
going to finally at least go: "I can't figure out the problem, let's
revert until I have a better idea."

FWIW, I have a perfect globally synchronized TICK source on this
system.

And even with this fix there are so many other regressions that cause
similar spurious socklockup reports and even full on cpu hangs, all
seemingly added by the sched tree.

In my opinion this sched tree merge the other day is one of THE WORST
merges in recent memory.  Linus's tree is currently a sizzling pile of
poo, I can't get any of my own merge work done, and I'm stuck here
hunting down regressions you've added because of it.  :-/

We can't even get past one of the regressions added by that tree, and
it's been two days of my working on this non-stop.

----Next_Part(Wed_Apr_23_05_29_28_2008_136)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="bug1.log"

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.27.1 2007/09/14 15:17'
[    0.000000] PROMLIB: Root node compatible: sun4v
[    0.000000] Linux version 2.6.25-schedbugs (davem@huronp11) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #2 SMP Wed Apr 23 04:30:43 PDT 2008
[    0.000000] console [earlyprom0] enabled
[    0.000000] ARCH: SUN4V
[    0.000000] Ethernet address: 00:14:4f:3e:cb:f4
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] [0000000200000000-fffff80009000000] page_structs=262144 node=0 entry=0/0
[    0.000000] [0000000200000000-fffff80009400000] page_structs=262144 node=0 entry=1/0
[    0.000000] [0000000200000000-fffff80009800000] page_structs=262144 node=0 entry=2/0
[    0.000000] [0000000200000000-fffff80009c00000] page_structs=262144 node=0 entry=3/0
[    0.000000] [0000000200e00000-fffff8000a000000] page_structs=262144 node=0 entry=4/0
[    0.000000] [0000000200e00000-fffff8000a400000] page_structs=262144 node=0 entry=5/0
[    0.000000] [0000000200e00000-fffff8000a800000] page_structs=262144 node=0 entry=6/0
[    0.000000] [0000000201c00000-fffff8000ac00000] page_structs=262144 node=0 entry=7/0
[    0.000000] [0000000201c00000-fffff8000b000000] page_structs=262144 node=0 entry=8/0
[    0.000000] [0000000201c00000-fffff8000b400000] page_structs=262144 node=0 entry=9/0
[    0.000000] [0000000201c00000-fffff8000b800000] page_structs=262144 node=0 entry=10/0
[    0.000000] [0000000202a00000-fffff8000bc00000] page_structs=262144 node=0 entry=11/0
[    0.000000] [0000000202a00000-fffff8000c000000] page_structs=262144 node=0 entry=12/0
[    0.000000] [0000000202a00000-fffff8000c400000] page_structs=262144 node=0 entry=13/0
[    0.000000] [0000000203800000-fffff8000c800000] page_structs=262144 node=0 entry=14/0
[    0.000000] [0000000203800000-fffff8000cc00000] page_structs=262144 node=0 entry=15/0
[    0.000000] [0000000203800000-fffff8000d000000] page_structs=262144 node=0 entry=16/0
[    0.000000] [0000000203800000-fffff8000d400000] page_structs=262144 node=0 entry=17/0
[    0.000000] [0000000204600000-fffff8000d800000] page_structs=262144 node=0 entry=18/0
[    0.000000] [0000000204600000-fffff8000dc00000] page_structs=262144 node=0 entry=19/0
[    0.000000] [0000000204600000-fffff8000e000000] page_structs=262144 node=0 entry=20/0
[    0.000000] [0000000205400000-fffff8000e400000] page_structs=262144 node=0 entry=21/0
[    0.000000] [0000000205400000-fffff8000e800000] page_structs=262144 node=0 entry=22/0
[    0.000000] [0000000205400000-fffff8000ec00000] page_structs=262144 node=0 entry=23/0
[    0.000000] [0000000205400000-fffff8000f000000] page_structs=262144 node=0 entry=24/0
[    0.000000] [0000000206200000-fffff8000f400000] page_structs=262144 node=0 entry=25/0
[    0.000000] [0000000206200000-fffff8000f800000] page_structs=262144 node=0 entry=26/0
[    0.000000] [0000000206200000-fffff8000fc00000] page_structs=262144 node=0 entry=27/0
[    0.000000] OF stdout device is: /virtual-devices@100/console@1
[    0.000000] PROM: Built device tree with 124732 bytes of memory.
[    0.000000] MDESC: Size is 59392 bytes.
[    0.000000] PLATFORM: banner-name [SPARC Enterprise T5220]
[    0.000000] PLATFORM: name [SUNW,SPARC-Enterprise-T5220]
[    0.000000] PLATFORM: hostid [803ecbf4]
[    0.000000] PLATFORM: serial# [00ab4130]
[    0.000000] PLATFORM: stick-frequency [546e74c8]
[    0.000000] PLATFORM: mac-address [144f3ecbf4]
[    0.000000] PLATFORM: watchdog-resolution [1000 ms]
[    0.000000] PLATFORM: watchdog-max-timeout [31536000000 ms]
[    0.000000] PLATFORM: max-cpus [64]
[    0.000000] On node 0 totalpages: 2079047
[    0.000000]   Normal zone: 14331 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 2064716 pages, LIFO batch:15
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Booting Linux...
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2064716
[    0.000000] Kernel command line: root=/dev/sda2 ro
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.010000] clocksource: mult[b4b9] shift[16]
[    0.010000] clockevent: mult[b550b0f2] shift[31]
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console handover: boot [earlyprom0] -> real [tty0]
[    0.010595] Dentry cache hash table entries: 2097152 (order: 11, 16777216 bytes)
[    0.064599] Inode-cache hash table entries: 1048576 (order: 10, 8388608 bytes)
[    0.617362] Memory: 16390776k available (2768k kernel code, 1056k data, 168k init) [fffff80000000000,00000003ffb22000]
[    0.617501] SLUB: Genslabs=13, HWalign=32, Order=0-2, MinObjects=8, CPUs=64, Nodes=1
[    0.760005] Calibrating delay using timer specific routine.. 2835.98 BogoMIPS (lpj=14179942)
[    0.760226] Mount-cache hash table entries: 512
[    0.784422] Brought up 64 CPUs
[    0.793827] net_namespace: 584 bytes
[    0.793856] ldc.c:v1.0 (June 25, 2007)
[    0.794541] NET: Registered protocol family 16
[    0.816820] VIO: Adding device channel-devices
[    0.817008] VIO: Adding device vldc-port-3-0
[    0.817174] VIO: Adding device vldc-port-3-1
[    0.817343] VIO: Adding device vldc-port-3-2
[    0.817512] VIO: Adding device vldc-port-3-3
[    0.817679] VIO: Adding device vldc-port-3-4
[    0.817848] VIO: Adding device vldc-port-3-5
[    0.818015] VIO: Adding device vldc-port-3-8
[    0.818184] VIO: Adding device vldc-port-2-0
[    0.818353] VIO: Adding device vldc-port-0-0
[    0.818534] VIO: Adding device vldc-port-0-1
[    0.818711] VIO: Adding device vldc-port-0-2
[    0.818888] VIO: Adding device vldc-port-1-0
[    0.819080] VIO: Adding device ds-1
[    0.819251] VIO: Adding device ds-0
[    0.829423] PCI: Probing for controllers.
[    0.829473] SUN4V_PCI: Registered hvapi major[1] minor[0]
[    0.829745] /pci@0: SUN4V PCI Bus Module
[    0.829767] /pci@0: PCI IO[c810000000] MEM[ca00000000]
[    0.873836] /pci@0: Imported 3 TSB entries from OBP
[    0.874666] /pci@0: MSI Queue first[0] num[36] count[128] devino[0x18]
[    0.874694] /pci@0: MSI first[0] num[256] mask[0xff] width[32]
[    0.874718] /pci@0: MSI addr32[0x7fff0000:0x10000] addr64[0x3ffff0000:0x10000]
[    0.874747] /pci@0: MSI queues at RA [00000003fe600000]
[    0.874863] PCI: Scanning PBM /pci@0
[    0.884581] ebus: No EBus's found.
[    0.885408] ds.c:v1.0 (Jul 11, 2007)
[    0.898797] SCSI subsystem initialized
[    0.899277] usbcore: registered new interface driver usbfs
[    0.899458] usbcore: registered new interface driver hub
[    0.899788] usbcore: registered new device driver usb
[    0.936946] ds-1: Registered pri service.
[    0.952417] NET: Registered protocol family 2
[    0.960015] Switched to high resolution mode on CPU 0
[    0.960026] Switched to high resolution mode on CPU 24
[    0.960037] Switched to high resolution mode on CPU 52
[    0.960054] Switched to high resolution mode on CPU 36
[    0.962612] ds-1: Registered var-config-backup service.
[    0.970010] Switched to high resolution mode on CPU 25
[    0.970021] Switched to high resolution mode on CPU 53
[    0.970031] Switched to high resolution mode on CPU 26
[    0.970042] Switched to high resolution mode on CPU 54
[    0.970052] Switched to high resolution mode on CPU 27
[    0.970062] Switched to high resolution mode on CPU 55
[    0.970072] Switched to high resolution mode on CPU 28
[    0.970083] Switched to high resolution mode on CPU 56
[    0.970093] Switched to high resolution mode on CPU 1
[    0.971444] Switched to high resolution mode on CPU 29
[    0.971455] Switched to high resolution mode on CPU 57
[    0.971465] Switched to high resolution mode on CPU 2
[    0.971736] Switched to high resolution mode on CPU 30
[    0.971746] Switched to high resolution mode on CPU 58
[    0.971756] Switched to high resolution mode on CPU 3
[    0.971766] Switched to high resolution mode on CPU 31
[    0.971776] Switched to high resolution mode on CPU 59
[    0.971787] Switched to high resolution mode on CPU 4
[    0.971798] Switched to high resolution mode on CPU 32
[    0.971808] Switched to high resolution mode on CPU 60
[    0.971819] Switched to high resolution mode on CPU 5
[    0.971829] Switched to high resolution mode on CPU 33
[    0.971839] Switched to high resolution mode on CPU 61
[    0.971850] Switched to high resolution mode on CPU 6
[    0.971860] Switched to high resolution mode on CPU 34
[    0.971870] Switched to high resolution mode on CPU 62
[    0.971880] Switched to high resolution mode on CPU 7
[    0.973491] Switched to high resolution mode on CPU 35
[    0.973500] Switched to high resolution mode on CPU 63
[    0.973511] Switched to high resolution mode on CPU 8
[    0.973775] Switched to high resolution mode on CPU 9
[    0.973784] Switched to high resolution mode on CPU 37
[    0.974116] Switched to high resolution mode on CPU 10
[    0.974127] Switched to high resolution mode on CPU 38
[    0.974138] Switched to high resolution mode on CPU 11
[    0.974148] Switched to high resolution mode on CPU 39
[    0.974158] Switched to high resolution mode on CPU 12
[    0.974169] Switched to high resolution mode on CPU 40
[    0.974179] Switched to high resolution mode on CPU 13
[    0.974190] Switched to high resolution mode on CPU 41
[    0.974200] Switched to high resolution mode on CPU 14
[    0.974210] Switched to high resolution mode on CPU 42
[    0.974221] Switched to high resolution mode on CPU 15
[    0.974231] Switched to high resolution mode on CPU 43
[    0.974242] Switched to high resolution mode on CPU 16
[    0.974252] Switched to high resolution mode on CPU 44
[    0.974263] Switched to high resolution mode on CPU 17
[    0.974273] Switched to high resolution mode on CPU 45
[    0.974283] Switched to high resolution mode on CPU 18
[    0.974294] Switched to high resolution mode on CPU 46
[    0.974304] Switched to high resolution mode on CPU 19
[    0.974314] Switched to high resolution mode on CPU 47
[    0.974324] Switched to high resolution mode on CPU 20
[    0.974334] Switched to high resolution mode on CPU 48
[    0.974344] Switched to high resolution mode on CPU 21
[    0.974354] Switched to high resolution mode on CPU 49
[    0.974365] Switched to high resolution mode on CPU 22
[    0.974375] Switched to high resolution mode on CPU 50
[    0.974385] Switched to high resolution mode on CPU 23
[    0.974395] Switched to high resolution mode on CPU 51
[    1.073741] IP route cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    1.077974] TCP established hash table entries: 524288 (order: 10, 8388608 bytes)
[    1.103848] TCP bind hash table entries: 65536 (order: 7, 1048576 bytes)
[    1.109002] TCP: Hash tables configured (established 524288 bind 65536)
[    1.109029] TCP reno registered
[    1.137221] Mini RTC Driver
[    1.140807] Total HugeTLB memory allocated, 0
[    1.166184] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.166221] io scheduler noop registered
[    1.166240] io scheduler anticipatory registered (default)
[    1.166262] io scheduler deadline registered
[    1.166581] io scheduler cfq registered
[    1.166718] proc_dir_entry '00.0' already registered
[    1.166739] Call Trace:
[    1.166755]  [00000000004f05e8] create_proc_entry+0x7c/0x98
[    1.166792]  [000000000056f2e0] pci_proc_attach_device+0xa4/0xd4
[    1.166824]  [00000000007dc798] pci_proc_init+0x64/0x88
[    1.166851]  [00000000007ca294] kernel_init+0x188/0x328
[    1.166884]  [0000000000426cf8] kernel_thread+0x38/0x48
[    1.166912]  [00000000006a1d68] rest_init+0x18/0x5c
[    1.180849] f0279bbc: ttyS0 at I/O 0x0 (irq = 17) is a SUN4V HCONS
[    1.180879] console [ttyHV0] enabled
[    1.248478] proc_dir_entry 'serial' already registered
[    1.248524] Call Trace:
[    1.258028]  [00000000004f05e8] create_proc_entry+0x7c/0x98
[    1.278531]  [00000000004f1b0c] proc_tty_register_driver+0x40/0x70
[    1.278587]  [0000000000591ee0] tty_register_driver+0x1fc/0x208
[    1.298579]  [00000000005a82e8] uart_register_driver+0x134/0x16c
[    1.300282]  [00000000005a9a48] sunserial_register_minors+0x34/0x68
[    1.300336]  [00000000007de128] sunsu_init+0xf8/0x150
[    1.302034]  [00000000007ca294] kernel_init+0x188/0x328
[    1.308531]  [0000000000426cf8] kernel_thread+0x38/0x48
[    1.308581]  [00000000006a1d68] rest_init+0x18/0x5c
[    1.315734] f0288ed4: ttyS0 at MMIO 0xfff0ca0000 (irq = 24) is a 16550A
[    1.349651] Uniform Multi-Platform E-IDE driver
[    1.349690] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    1.352933] Driver 'sd' needs updating - please use bus_type methods
[    1.353217] Fusion MPT base driver 3.04.06
[    1.353250] Copyright (c) 1999-2007 LSI Corporation
[    1.358602] Fusion MPT SPI Host driver 3.04.06
[    1.358850] Fusion MPT FC Host driver 3.04.06
[    1.359118] Fusion MPT SAS Host driver 3.04.06
[    1.409847] mptbase: ioc0: Initiating bringup
[    2.219734] ioc0: LSISAS1068E B1: Capabilities={Initiator}
[    2.230075] mptbase: ioc0: PCI-MSI enabled
[    8.329710] scsi0 : ioc0: LSISAS1068E B1, FwRev=011400dbh, Ports=1, MaxQ=511, IRQ=89
[    8.359710] scsi 0:0:0:0: Direct-Access     SEAGATE  ST973401LSUN72G  0556 PQ: 0 ANSI: 3
[    8.363250] sd 0:0:0:0: [sda] 143374738 512-byte hardware sectors (73408 MB)
[    8.364632] sd 0:0:0:0: [sda] Write Protect is off
[    8.364748] sd 0:0:0:0: [sda] Mode Sense: e3 00 10 08
[    8.366143] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[    8.366987] sd 0:0:0:0: [sda] 143374738 512-byte hardware sectors (73408 MB)
[    8.368234] sd 0:0:0:0: [sda] Write Protect is off
[    8.368537] sd 0:0:0:0: [sda] Mode Sense: e3 00 10 08
[    8.369929] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[    8.370148]  sda: sda1 sda2 sda3 sda4
[    8.381220] sd 0:0:0:0: [sda] Attached SCSI disk
[    8.384734] scsi 0:0:1:0: Direct-Access     FUJITSU  MAY2073RCSUN72G  0501 PQ: 0 ANSI: 4
[    8.387792] sd 0:0:1:0: [sdb] 143374738 512-byte hardware sectors (73408 MB)
[    8.389984] sd 0:0:1:0: [sdb] Write Protect is off
[    8.390100] sd 0:0:1:0: [sdb] Mode Sense: d3 00 00 08
[    8.391411] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    8.392399] sd 0:0:1:0: [sdb] 143374738 512-byte hardware sectors (73408 MB)
[    8.394436] sd 0:0:1:0: [sdb] Write Protect is off
[    8.394474] sd 0:0:1:0: [sdb] Mode Sense: d3 00 00 08
[    8.395783] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    8.395844]  sdb: sdb1 sdb2 sdb3
[    8.411877] sd 0:0:1:0: [sdb] Attached SCSI disk
[    8.415750] Fusion MPT misc device (ioctl) driver 3.04.06
[    8.416120] mptctl: Registered with Fusion MPT base driver
[    8.416246] mptctl: /dev/mptctl @ (major,minor=10,220)
[    8.416507] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    8.416521] ohci_hcd: block sizes: ed 80 td 96
[    8.416639] ohci_hcd 0000:07:00.0: OHCI Host Controller
[    8.416890] drivers/usb/core/inode.c: creating file 'devices'
[    8.416910] drivers/usb/core/inode.c: creating file '001'
[    8.416927] ohci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 1
[    8.416990] ohci_hcd 0000:07:00.0: enabled NEC chipset lost interrupt quirk
[    8.417054] ohci_hcd 0000:07:00.0: created debug files
[    8.417087] ohci_hcd 0000:07:00.0: irq 22, io mem 0xca00300000
[    8.459342] ohci_hcd 0000:07:00.0: OHCI controller state
[    8.459358] ohci_hcd 0000:07:00.0: OHCI 1.0, NO legacy support registers
[    8.459376] ohci_hcd 0000:07:00.0: control 0x083 HCFS=operational CBSR=3
[    8.459391] ohci_hcd 0000:07:00.0: cmdstatus 0x00000 SOC=0
[    8.459406] ohci_hcd 0000:07:00.0: intrstatus 0x00000004 SF
[    8.459421] ohci_hcd 0000:07:00.0: intrenable 0x8000005a MIE RHSC UE RD WDH
[    8.459447] ohci_hcd 0000:07:00.0: hcca frame #0003
[    8.459463] ohci_hcd 0000:07:00.0: roothub.a 01000203 POTPGT=1 NPS NDP=3(3)
[    8.459478] ohci_hcd 0000:07:00.0: roothub.b 00000000 PPCM=0000 DR=0000
[    8.459494] ohci_hcd 0000:07:00.0: roothub.status 00008000 DRWE
[    8.459511] ohci_hcd 0000:07:00.0: roothub.portstatus [0] 0x00000100 PPS
[    8.459528] ohci_hcd 0000:07:00.0: roothub.portstatus [1] 0x00000100 PPS
[    8.459544] ohci_hcd 0000:07:00.0: roothub.portstatus [2] 0x00000100 PPS
[    8.459607] usb usb1: default language 0x0409
[    8.459672] usb usb1: uevent
[    8.459849] usb usb1: usb_probe_device
[    8.460339] usb usb1: configuration #1 chosen from 1 choice
[    8.460560] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    8.460602] usb 1-0:1.0: uevent
[    8.460774] hub 1-0:1.0: usb_probe_interface
[    8.460785] hub 1-0:1.0: usb_probe_interface - got id
[    8.460796] hub 1-0:1.0: USB hub found
[    8.460935] hub 1-0:1.0: 3 ports detected
[    8.460967] hub 1-0:1.0: standalone hub
[    8.460976] hub 1-0:1.0: no power switching (usb 1.0)
[    8.460986] hub 1-0:1.0: global over-current protection
[    8.460998] hub 1-0:1.0: power on to power good time: 2ms
[    8.461021] hub 1-0:1.0: local power source is good
[    8.461031] hub 1-0:1.0: no over-current condition exists
[    8.461044] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    8.517308] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[    8.517588] drivers/usb/core/inode.c: creating file '001'
[    8.517617] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    8.517828] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.517960] usb usb1: Product: OHCI Host Controller
[    8.517992] usb usb1: Manufacturer: Linux 2.6.25-schedbugs ohci_hcd
[    8.518038] usb usb1: SerialNumber: 0000:07:00.0
[    8.518149] ohci_hcd 0000:07:00.1: OHCI Host Controller
[    8.518388] drivers/usb/core/inode.c: creating file '002'
[    8.518406] ohci_hcd 0000:07:00.1: new USB bus registered, assigned bus number 2
[    8.518466] ohci_hcd 0000:07:00.1: enabled NEC chipset lost interrupt quirk
[    8.518511] ohci_hcd 0000:07:00.1: created debug files
[    8.518541] ohci_hcd 0000:07:00.1: irq 23, io mem 0xca00302000
[    8.559340] ohci_hcd 0000:07:00.1: OHCI controller state
[    8.559355] ohci_hcd 0000:07:00.1: OHCI 1.0, NO legacy support registers
[    8.559372] ohci_hcd 0000:07:00.1: control 0x083 HCFS=operational CBSR=3
[    8.559387] ohci_hcd 0000:07:00.1: cmdstatus 0x00000 SOC=0
[    8.559401] ohci_hcd 0000:07:00.1: intrstatus 0x00000004 SF
[    8.559416] ohci_hcd 0000:07:00.1: intrenable 0x8000005a MIE RHSC UE RD WDH
[    8.559441] ohci_hcd 0000:07:00.1: hcca frame #0003
[    8.559455] ohci_hcd 0000:07:00.1: roothub.a 01000202 POTPGT=1 NPS NDP=2(2)
[    8.559470] ohci_hcd 0000:07:00.1: roothub.b 00000000 PPCM=0000 DR=0000
[    8.559485] ohci_hcd 0000:07:00.1: roothub.status 00008000 DRWE
[    8.559501] ohci_hcd 0000:07:00.1: roothub.portstatus [0] 0x00000100 PPS
[    8.559517] ohci_hcd 0000:07:00.1: roothub.portstatus [1] 0x00000100 PPS
[    8.559558] usb usb2: default language 0x0409
[    8.559621] usb usb2: uevent
[    8.559786] usb usb2: usb_probe_device
[    8.560078] usb usb2: configuration #1 chosen from 1 choice
[    8.560295] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    8.560337] usb 2-0:1.0: uevent
[    8.560504] hub 2-0:1.0: usb_probe_interface
[    8.560515] hub 2-0:1.0: usb_probe_interface - got id
[    8.560525] hub 2-0:1.0: USB hub found
[    8.560667] hub 2-0:1.0: 2 ports detected
[    8.560698] hub 2-0:1.0: standalone hub
[    8.560707] hub 2-0:1.0: no power switching (usb 1.0)
[    8.560717] hub 2-0:1.0: global over-current protection
[    8.560727] hub 2-0:1.0: power on to power good time: 2ms
[    8.560748] hub 2-0:1.0: local power source is good
[    8.560759] hub 2-0:1.0: no over-current condition exists
[    8.560770] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    8.617308] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.617584] drivers/usb/core/inode.c: creating file '001'
[    8.617611] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    8.617822] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.617953] usb usb2: Product: OHCI Host Controller
[    8.617986] usb usb2: Manufacturer: Linux 2.6.25-schedbugs ohci_hcd
[    8.618032] usb usb2: SerialNumber: 0000:07:00.1
[    8.618952] mice: PS/2 mouse device common for all mice
[    8.620419] usbcore: registered new interface driver hiddev
[    8.620796] usbcore: registered new interface driver usbhid
[    8.620849] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    8.622596] TCP cubic registered
[    8.623152] NET: Registered protocol family 1
[    8.623227] NET: Registered protocol family 17
[    8.644980] kjournald starting.  Commit interval 5 seconds
[    8.645299] EXT3-fs: mounted filesystem with ordered data mode.
[    8.645329] VFS: Mounted root (ext3 filesystem) readonly.
[   13.046256] usb usb1: uevent
[   13.046432] usb 1-0:1.0: uevent
[   13.046709] usb usb2: uevent
[   13.046881] usb 2-0:1.0: uevent
[   13.562231] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   13.562603] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   13.602237] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[   13.602237] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   13.602237] PCI: Enabling device: (0000:08:00.0), cmd 147
[   13.622237] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[   13.758514] eth0: (PCI Express:2.5GB/s:Width x4) 00:14:4f:3e:cb:f4
[   13.758734] eth0: Intel(R) PRO/1000 Network Connection
[   13.758937] eth0: MAC: 0, PHY: 4, PBA No: ffffff-0ff
[   13.758937] PCI: Enabling device: (0000:07:00.2), cmd 2
[   13.758937] ehci_hcd 0000:07:00.2: EHCI Host Controller
[   13.759159] PCI: Enabling device: (0000:08:00.1), cmd 147
[   13.759159] drivers/usb/core/inode.c: creating file '003'
[   13.759159] ehci_hcd 0000:07:00.2: new USB bus registered, assigned bus number 3
[   13.759159] ehci_hcd 0000:07:00.2: reset hcs_params 0x2395 dbg=0 cc=2 pcc=3 ports=5
[   13.759159] ehci_hcd 0000:07:00.2: reset portroute 1 0 1 0 0 
[   13.759159] ehci_hcd 0000:07:00.2: reset hcc_params e806 thresh 0 uframes 256/512/1024 park
[   13.759159] ehci_hcd 0000:07:00.2: park 0
[   13.759159] ehci_hcd 0000:07:00.2: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   13.759159] ehci_hcd 0000:07:00.2: MWI active
[   13.759159] ehci_hcd 0000:07:00.2: supports USB remote wakeup
[   13.759159] ehci_hcd 0000:07:00.2: irq 20, io mem 0xca00304000
[   13.759159] ehci_hcd 0000:07:00.2: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   13.759159] ehci_hcd 0000:07:00.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
[   13.769183] ehci_hcd 0000:07:00.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   13.769476] usb usb3: default language 0x0409
[   13.769548] usb usb3: uevent
[   13.769658] usb usb3: usb_probe_device
[   13.769908] usb usb3: configuration #1 chosen from 1 choice
[   13.770047] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   13.770090] usb 3-0:1.0: uevent
[   13.770198] hub 3-0:1.0: usb_probe_interface
[   13.770210] hub 3-0:1.0: usb_probe_interface - got id
[   13.770220] hub 3-0:1.0: USB hub found
[   13.770275] hub 3-0:1.0: 5 ports detected
[   13.770307] hub 3-0:1.0: standalone hub
[   13.770317] hub 3-0:1.0: individual port power switching
[   13.770327] hub 3-0:1.0: individual port over-current protection
[   13.770338] hub 3-0:1.0: Single TT
[   13.770348] hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
[   13.770359] hub 3-0:1.0: power on to power good time: 20ms
[   13.770381] hub 3-0:1.0: local power source is good
[   13.770393] hub 3-0:1.0: enabling power on all ports
[   13.869162] hub 3-0:1.0: state 7 ports 5 chg 0000 evt 0000
[   13.869381] drivers/usb/core/inode.c: creating file '001'
[   13.869414] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[   13.869414] ehci_hcd 0000:07:00.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[   13.869414] hub 3-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
[   13.869628] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.869760] usb usb3: Product: EHCI Host Controller
[   13.869793] usb usb3: Manufacturer: Linux 2.6.25-schedbugs ehci_hcd
[   13.869839] usb usb3: SerialNumber: 0000:07:00.2
[   13.882455] eth1: (PCI Express:2.5GB/s:Width x4) 00:14:4f:3e:cb:f5
[   13.882665] eth1: Intel(R) PRO/1000 Network Connection
[   13.882789] eth1: MAC: 0, PHY: 4, PBA No: ffffff-0ff
[   13.882921] PCI: Enabling device: (0000:09:00.0), cmd 147
[   14.016520] eth1: (PCI Express:2.5GB/s:Width x4) 00:14:4f:3e:cb:f6
[   14.016736] eth1: Intel(R) PRO/1000 Network Connection
[   14.016940] eth1: MAC: 0, PHY: 4, PBA No: ffffff-0ff
[   14.017096] PCI: Enabling device: (0000:09:00.1), cmd 147
[   14.017128] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
[   14.068904] ehci_hcd 0000:07:00.2: port 2 high speed
[   14.068921] ehci_hcd 0000:07:00.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[   14.107357] usb 3-2: new high speed USB device using ehci_hcd and address 2
[   14.130809] eth2: (PCI Express:2.5GB/s:Width x4) 00:14:4f:3e:cb:f7
[   14.131021] eth2: Intel(R) PRO/1000 Network Connection
[   14.131225] eth2: MAC: 0, PHY: 4, PBA No: ffffff-0ff
[   14.161422] ehci_hcd 0000:07:00.2: port 2 high speed
[   14.161443] ehci_hcd 0000:07:00.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[   14.278268] usb 3-2: default language 0x0409
[   14.280862] usb 3-2: uevent
[   14.280928] usb 3-2: usb_probe_device
[   14.281118] usb 3-2: configuration #1 chosen from 1 choice
[   14.281118] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[   14.281118] usb 3-2:1.0: uevent
[   14.281118] drivers/usb/core/inode.c: creating file '002'
[   14.281118] usb 3-2: New USB device found, idVendor=0451, idProduct=625f
[   14.281118] usb 3-2: New USB device strings: Mfr=5, Product=2, SerialNumber=1
[   14.281118] usb 3-2: Product: 6250 FW: 00.00.02.22.562AD423
[   14.281118] usb 3-2: Manufacturer: Texas Instruments Incorporated
[   14.281118] usb 3-2: SerialNumber: ACCC32781924
[   14.281118] ehci_hcd 0000:07:00.2: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
[   14.281118] hub 3-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
[   14.395450] Initializing USB Mass Storage driver...
[   14.443573] hub 3-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
[   14.466661] warning: `dhclient3' uses 32-bit capabilities (legacy support in use)
[   14.503750] ehci_hcd 0000:07:00.2: port 4 high speed
[   14.503771] ehci_hcd 0000:07:00.2: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
[   14.563598] usb 3-4: new high speed USB device using ehci_hcd and address 3
[   14.623751] ehci_hcd 0000:07:00.2: port 4 high speed
[   14.623773] ehci_hcd 0000:07:00.2: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
[   14.653549] loop: module loaded
[   14.716600] usb 3-4: uevent
[   14.716669] usb 3-4: usb_probe_device
[   14.716850] usb 3-4: configuration #1 chosen from 1 choice
[   14.717412] usb 3-4: adding 3-4:1.0 (config #1, interface 0)
[   14.717464] usb 3-4:1.0: uevent
[   14.717519] hub 3-4:1.0: usb_probe_interface
[   14.717531] hub 3-4:1.0: usb_probe_interface - got id
[   14.717542] hub 3-4:1.0: USB hub found
[   14.718137] hub 3-4:1.0: 4 ports detected
[   14.725094] hub 3-4:1.0: standalone hub
[   14.725105] hub 3-4:1.0: individual port power switching
[   14.725117] hub 3-4:1.0: individual port over-current protection
[   14.725555] hub 3-4:1.0: TT per port
[   14.725568] hub 3-4:1.0: TT requires at most 8 FS bit times (666 ns)
[   14.725580] hub 3-4:1.0: Port indicators are supported
[   14.725593] hub 3-4:1.0: power on to power good time: 100ms
[   14.726555] hub 3-4:1.0: local power source is good
[   14.726570] hub 3-4:1.0: enabling power on all ports
[   14.831855] usb 3-4: link qh256-0001/fffff803fa2861e0 start 255 [1/0 us]
[   14.831896] drivers/usb/core/inode.c: creating file '003'
[   14.831928] usb 3-4: New USB device found, idVendor=04b4, idProduct=6560
[   14.831941] usb 3-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   14.831990] hub 3-4:1.0: state 7 ports 4 chg 0000 evt 0000
[   14.832056] usb-storage 3-2:1.0: usb_probe_interface
[   14.832083] usb-storage 3-2:1.0: usb_probe_interface - got id
[   14.835037] scsi1 : SCSI emulation for USB Mass Storage devices
[   14.835037] usb-storage: device found at 2
[   14.835037] usb-storage: waiting for device to settle before scanning
[   14.835038] usbcore: registered new interface driver usb-storage
[   14.835038] USB Mass Storage support registered.
[   14.894222] Adding 3084464k swap on /dev/sda4.  Priority:-1 extents:1 across:3084464k
[   15.135037] EXT3 FS on sda2, internal journal
[   15.480159] kjournald starting.  Commit interval 5 seconds
[   15.484539] EXT3 FS on sda1, internal journal
[   15.484558] EXT3-fs: mounted filesystem with ordered data mode.
[   16.485116] eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   17.457272] NET: Registered protocol family 10
[   17.466513] lo: Disabled Privacy Extensions
[   19.515305] scsi 1:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-T632A SR02 PQ: 0 ANSI: 0
[   19.515305] scsi 1:0:0:0: Attached scsi generic sg2 type 5
[   19.517299] usb-storage: device scan complete
[   19.545388] Driver 'sr' needs updating - please use bus_type methods
[   19.556449] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   19.556470] Uniform CD-ROM driver Revision: 3.20
[   19.557729] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   22.387301] eth0: no IPv6 routers present
[   95.451701] BUG: soft lockup - CPU#29 stuck for 62s! [sh:3887]
[   95.451701] TSTATE: 0000004411001607 TPC: 000000000045e1c8 TNPC: 0000000000559dc0 Y: 00000000    Not tainted
[   95.451701] TPC: <copy_process+0x7cc/0xfc0>
[   95.451701] g0: 0000000000000000 g1: fffff803fe81dee0 g2: fffff803f703ced8 g3: fffff803f703ca40
[   95.451701] g4: fffff803fc9b8000 g5: fffff80007d4c000 g6: fffff803f4b6c000 g7: fffff803f703ce70
[   95.451701] o0: 0000000000000001 o1: fffff803f49a1168 o2: 0000000000000000 o3: 0000000000000498
[   95.451701] o4: 0000000000000000 o5: 0000000000000000 sp: fffff803f4b6f4e1 ret_pc: 000000000045e1c4
[   95.451701] RPC: <copy_process+0x7c8/0xfc0>
[   95.451701] l0: fffff803f703ce70 l1: fffff803f7151800 l2: fffff803fc86c700 l3: fffff803f49a1140
[   95.451701] l4: fffff803f703c9d8 l5: fffff803fe87ec68 l6: fffff803fc86dc00 l7: fffff803fc86c700
[   95.451701] i0: fffff803f7151800 i1: 0000000070001d68 i2: 0000000000000000 i3: fffff803f703d7d8
[   95.451701] i4: fffff803f703d7b8 i5: 0000000000000000 i6: fffff803f4b6f5c1 i7: 000000000045eaa8
[   95.451701] I7: <do_fork+0xec/0x234>
[   95.465482] BUG: soft lockup - CPU#37 stuck for 62s! [swapper:0]
[   95.465482] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000400    Not tainted
[   95.465482] TPC: <cpu_idle+0xb0/0x134>
[   95.465482] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff418000 g3: 0000000000000000
[   95.465482] g4: fffff803ff40cc00 g5: fffff80007d8c000 g6: fffff803ff418000 g7: 0000021100004000
[   95.465482] o0: 0000000000000000 o1: fffff803ff418008 o2: 0000000000004000 o3: 0000000000000001
[   95.465482] o4: 0000009853259180 o5: 0000000000000012 sp: fffff803ff41b681 ret_pc: 0000000000427818
[   95.465482] RPC: <cpu_idle+0x9c/0x134>
[   95.465482] l0: 0000000000000025 l1: 00000000007b95c8 l2: 0000000000000025 l3: 00000000000000c8
[   95.465482] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   95.465482] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   95.465482] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff41b741 i7: 00000000006b0110
[   95.465482] I7: <after_lock_tlb+0x1a4/0x1b4>
[   95.465482] BUG: soft lockup - CPU#45 stuck for 62s! [swapper:0]
[   95.465482] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   95.465482] TPC: <cpu_idle+0xb0/0x134>
[   95.465482] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff4f8000 g3: 0000000000000000
[   95.465482] g4: fffff803ff4bd800 g5: fffff80007dcc000 g6: fffff803ff4f8000 g7: 0000021100004000
[   95.465482] o0: 0000000000000000 o1: fffff803ff4f8008 o2: 0000000000004000 o3: 0000000000000001
[   95.465482] o4: 0000009853259180 o5: 0000000000000012 sp: fffff803ff4fb681 ret_pc: 0000000000427818
[   95.465482] RPC: <cpu_idle+0x9c/0x134>
[   95.465482] l0: 000000000000002d l1: 00000000007b95c8 l2: 000000000000002d l3: 00000000000000c8
[   95.465482] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   95.465482] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   95.465482] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff4fb741 i7: 00000000006b0110
[   95.465482] I7: <after_lock_tlb+0x1a4/0x1b4>
[   95.465482] BUG: soft lockup - CPU#53 stuck for 62s! [swapper:0]
[   95.465482] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   95.465482] TPC: <cpu_idle+0xb0/0x134>
[   95.465482] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff5b4000 g3: 0000000000000000
[   95.465482] g4: fffff803ff596400 g5: fffff80007e0c000 g6: fffff803ff5b4000 g7: 0000021100004000
[   95.465482] o0: 0000000000000000 o1: fffff803ff5b4008 o2: 0000000000004000 o3: 0000000000000001
[   95.465482] o4: 0000009853be2800 o5: 0000000000000012 sp: fffff803ff5b7681 ret_pc: 0000000000427818
[   95.465482] RPC: <cpu_idle+0x9c/0x134>
[   95.465482] l0: 0000000000000035 l1: 00000000007b95c8 l2: 0000000000000035 l3: 00000000000000c8
[   95.465482] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   95.465482] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   95.465482] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff5b7741 i7: 00000000006b0110
[   95.465482] I7: <after_lock_tlb+0x1a4/0x1b4>
[   95.791706] BUG: soft lockup - CPU#44 stuck for 63s! [swapper:0]
[   95.791706] TSTATE: 0000000011001602 TPC: 000000000047c2dc TNPC: 000000000047c2e0 Y: 00000000    Not tainted
[   95.791706] TPC: <get_cpu_idle_time_us+0x0/0xd0>
[   95.791706] g0: 0000000000009000 g1: 0000000000000000 g2: 0000000000000001 g3: 0000000000000001
[   95.791706] g4: fffff803ff4bc000 g5: fffff80007dc4000 g6: fffff803ff4c0000 g7: fffff80007c64000
[   95.791706] o0: 0000000000000001 o1: 0000000000000000 o2: 0000000000000001 o3: 00000000007b9400
[   95.791706] o4: 0000000000843400 o5: 00000000007ae800 sp: fffff803ff4c35c1 ret_pc: 000000000047c138
[   95.791706] RPC: <tick_nohz_stop_sched_tick+0x1b4/0x358>
[   95.791706] l0: 000000000000002c l1: fffff800085b4c30 l2: 0000000000000001 l3: 000000000000002c
[   95.791706] l4: 0000000100008a81 l5: 000000000000002c l6: 00000098679d74d4 l7: 0000000000000000
[   95.791706] i0: 0000000000000000 i1: fffff803ff5b4008 i2: 0000000013f00000 i3: fffff800085b22d0
[   95.791706] i4: 0000009867698e80 i5: 000000013fff9adb i6: fffff803ff4c3681 i7: 00000000004277b0
[   95.791706] I7: <cpu_idle+0x34/0x134>
[   95.871704] BUG: soft lockup - CPU#4 stuck for 68s! [swapper:0]
[   95.871704] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   95.871704] TPC: <cpu_idle+0xb0/0x134>
[   95.871704] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff0d8000 g3: 0000000000000000
[   95.871704] g4: fffff803ff0d4000 g5: fffff80007c84000 g6: fffff803ff0d8000 g7: 0000021100004000
[   95.871704] o0: 0000000000000000 o1: fffff803ff0d8008 o2: 0000000000004000 o3: 0000000000000001
[   95.871704] o4: 000000986b95ac00 o5: 0000000000000012 sp: fffff803ff0db681 ret_pc: 0000000000427818
[   95.871704] RPC: <cpu_idle+0x9c/0x134>
[   95.871704] l0: 0000000000000004 l1: 00000000007b95c8 l2: 0000000000000004 l3: 00000000000000c8
[   95.871704] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   95.871704] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   95.871704] i4: 00000000fee82118 i5: 00000000fee811f8 i6: fffff803ff0db741 i7: 00000000006b0110
[   95.871704] I7: <after_lock_tlb+0x1a4/0x1b4>
[   95.871706] BUG: soft lockup - CPU#36 stuck for 68s! [swapper:0]
[   95.871706] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   95.871706] TPC: <cpu_idle+0xb0/0x134>
[   95.871706] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff400000 g3: 0000000000000000
[   95.871706] g4: fffff803ff3cf000 g5: fffff80007d84000 g6: fffff803ff400000 g7: 0000021100004000
[   95.871706] o0: 0000000000000000 o1: fffff803ff400008 o2: 0000000000004000 o3: 0000000000000001
[   95.871706] o4: 000000986b95ac00 o5: 0000000000000012 sp: fffff803ff403681 ret_pc: 0000000000427818
[   95.871706] RPC: <cpu_idle+0x9c/0x134>
[   95.871706] l0: 0000000000000024 l1: 00000000007b95c8 l2: 0000000000000024 l3: 00000000000000c8
[   95.871706] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   95.871706] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   95.871706] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff403741 i7: 00000000006b0110
[   95.871706] I7: <after_lock_tlb+0x1a4/0x1b4>
[   95.952442] BUG: soft lockup - CPU#20 stuck for 63s! [swapper:0]
[   95.952442] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   95.952442] TPC: <cpu_idle+0xb0/0x134>
[   95.952442] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff278000 g3: 0000000000000000
[   95.952442] g4: fffff803ff261800 g5: fffff80007d04000 g6: fffff803ff278000 g7: 0000021100004000
[   95.952442] o0: 0000000000000000 o1: fffff803ff278008 o2: 0000000000004000 o3: 0000000000000001
[   95.952442] o4: 00000098705a6000 o5: 0000000000000012 sp: fffff803ff27b681 ret_pc: 0000000000427818
[   95.952442] RPC: <cpu_idle+0x9c/0x134>
[   95.952442] l0: 0000000000000014 l1: 00000000007b95c8 l2: 0000000000000014 l3: 00000000000000c8
[   95.952442] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   95.952442] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   95.952442] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff27b741 i7: 00000000006b0110
[   95.952442] I7: <after_lock_tlb+0x1a4/0x1b4>
[   95.952442] BUG: soft lockup - CPU#28 stuck for 64s! [swapper:0]
[   95.952442] TSTATE: 0000004411001603 TPC: 000000000045a4b4 TNPC: 000000000045a4b8 Y: 00000000    Not tainted
[   95.952442] TPC: <finish_task_switch+0x2c/0xa0>
[   95.952442] g0: 0000000000000000 g1: 0000000000000000 g2: 0000000000001c00 g3: fffff803ff33c000
[   95.952442] g4: fffff803ff31e400 g5: fffff80007d44000 g6: fffff803ff33c000 g7: fffff803f8874000
[   95.952442] o0: fffff80008536200 o1: 0000000000000000 o2: 0000000000000001 o3: 0000000000000000
[   95.952442] o4: 0000000000000000 o5: 0000000000000001 sp: fffff803ff33f4c1 ret_pc: 000000000045536c
[   95.952442] RPC: <__load_balance_iterator+0x1c/0x28>
[   95.952442] l0: 0000000000000002 l1: 000000000078b7c8 l2: 0000000000000002 l3: 0000000000000000
[   95.952442] l4: 0000000000000001 l5: 0000000000000028 l6: 0000000000000029 l7: 00000000f7f37000
[   95.952442] i0: 0000000000000000 i1: fffff803f8874000 i2: 0000000000000018 i3: fffff800085345a0
[   95.952442] i4: 0000000000000002 i5: 0000000000000000 i6: fffff803ff33f581 i7: 00000000006b2bd4
[   95.952442] I7: <schedule+0x8a4/0x914>
[   98.251719] BUG: soft lockup - CPU#60 stuck for 65s! [swapper:0]
[   98.251748] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.251748] TPC: <cpu_idle+0xb0/0x134>
[   98.251748] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff664000 g3: 0000000000000000
[   98.251748] g4: fffff803ff645800 g5: fffff80007e44000 g6: fffff803ff664000 g7: 0000021100004000
[   98.251748] o0: 0000000000000000 o1: fffff803ff664008 o2: 0000000000004000 o3: 0000000000000001
[   98.251748] o4: 00000098fa0a2d80 o5: 0000000000000012 sp: fffff803ff667681 ret_pc: 0000000000427818
[   98.251748] RPC: <cpu_idle+0x9c/0x134>
[   98.251748] l0: 000000000000003c l1: 00000000007b95c8 l2: 000000000000003c l3: 00000000000000c8
[   98.251748] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.251748] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.251748] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff667741 i7: 00000000006b0110
[   98.251748] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.271750] BUG: soft lockup - CPU#17 stuck for 73s! [cc1:4031]
[   98.271750] TSTATE: 0000000082001a04 TPC: 0000000000011f84 TNPC: 00000000002794c4 Y: 00000000    Not tainted
[   98.271750] TPC: <0x11f8c>
[   98.271750] g0: 0000000000000000 g1: 0000000000000054 g2: 0000000000000150 g3: 00000000003a59f8
[   98.271750] g4: 8080808080808080 g5: 616c696173000000 g6: 00000000000000ff g7: 0000000070001d00
[   98.271750] o0: 00000000003a18a8 o1: 0000000000000005 o2: 0000000000458a49 o3: 0000000000000010
[   98.271750] o4: 00000000ffd4f2ff o5: 0000000000419c00 sp: 00000000ffd4f298 ret_pc: 0000000000011f80
[   98.271750] RPC: <0x11f88>
[   98.271750] l0: 00000015 l1: 00000000 l2: 00000000 l3: 00000000 l4: 702676e0 l5: 00419c64 l6: 702856c8 l7: 00000000
[   98.271750] i0: 00000000 i1: 000001a4 i2: 00000010 i3: 00000001 i4: 00399b94 i5: ffd4f374 i6: ffd4f310 i7: 0001c2e8
[   98.371751] BUG: soft lockup - CPU#18 stuck for 73s! [swapper:0]
[   98.373386] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.373386] TPC: <cpu_idle+0xb0/0x134>
[   98.373386] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff24c000 g3: 0000000000000000
[   98.373386] g4: fffff803ff226400 g5: fffff80007cf4000 g6: fffff803ff24c000 g7: 0000021100004000
[   98.373386] o0: 0000000000000000 o1: fffff803ff24c008 o2: 0000000000004000 o3: 0000000000000001
[   98.373386] o4: 0000009901313b80 o5: 0000000000000012 sp: fffff803ff24f681 ret_pc: 0000000000427818
[   98.373386] RPC: <cpu_idle+0x9c/0x134>
[   98.373386] l0: 0000000000000012 l1: 00000000007b95c8 l2: 0000000000000012 l3: 00000000000000c8
[   98.373386] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.373386] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.373386] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff24f741 i7: 00000000006b0110
[   98.373386] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.373386] BUG: soft lockup - CPU#23 stuck for 73s! [swapper:0]
[   98.373386] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.373386] TPC: <cpu_idle+0xb0/0x134>
[   98.373386] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff2c0000 g3: 0000000000000000
[   98.373386] g4: fffff803ff2a2400 g5: fffff80007d1c000 g6: fffff803ff2c0000 g7: 0000021100004000
[   98.373386] o0: 0000000000000000 o1: fffff803ff2c0008 o2: 0000000000004000 o3: 0000000000000001
[   98.373386] o4: 0000009901c9d200 o5: 0000000000000012 sp: fffff803ff2c3681 ret_pc: 0000000000427818
[   98.373386] RPC: <cpu_idle+0x9c/0x134>
[   98.373386] l0: 0000000000000017 l1: 00000000007b95c8 l2: 0000000000000017 l3: 00000000000000c8
[   98.373386] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.373386] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.373386] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff2c3741 i7: 00000000006b0110
[   98.381202] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.381202] BUG: soft lockup - CPU#22 stuck for 73s! [swapper:0]
[   98.381202] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.381202] TPC: <cpu_idle+0xb0/0x134>
[   98.381202] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff2ac000 g3: 0000000000000000
[   98.381202] g4: fffff803ff2a0c00 g5: fffff80007d14000 g6: fffff803ff2ac000 g7: 0000021100004000
[   98.381202] o0: 0000000000000000 o1: fffff803ff2ac008 o2: 0000000000004000 o3: 0000000000000001
[   98.381202] o4: 0000009901313b80 o5: 0000000000000012 sp: fffff803ff2af681 ret_pc: 0000000000427818
[   98.381202] RPC: <cpu_idle+0x9c/0x134>
[   98.381202] l0: 0000000000000016 l1: 00000000007b95c8 l2: 0000000000000016 l3: 00000000000000c8
[   98.381202] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.381202] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.381202] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff2af741 i7: 00000000006b0110
[   98.381202] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.381202] BUG: soft lockup - CPU#19 stuck for 73s! [swapper:0]
[   98.381202] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.381202] TPC: <cpu_idle+0xb0/0x134>
[   98.381202] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff264000 g3: 0000000000000000
[   98.381202] g4: fffff803ff260000 g5: fffff80007cfc000 g6: fffff803ff264000 g7: 0000021100004000
[   98.381202] o0: 0000000000000000 o1: fffff803ff264008 o2: 0000000000004000 o3: 0000000000000001
[   98.381202] o4: 0000009901313b80 o5: 0000000000000012 sp: fffff803ff267681 ret_pc: 0000000000427818
[   98.381202] RPC: <cpu_idle+0x9c/0x134>
[   98.381202] l0: 0000000000000013 l1: 00000000007b95c8 l2: 0000000000000013 l3: 00000000000000c8
[   98.381202] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.381202] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.381202] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff267741 i7: 00000000006b0110
[   98.381202] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.381202] BUG: soft lockup - CPU#30 stuck for 73s! [swapper:0]
[   98.381202] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.381202] TPC: <cpu_idle+0xb0/0x134>
[   98.381202] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff370000 g3: 0000000000000000
[   98.381202] g4: fffff803ff351800 g5: fffff80007d54000 g6: fffff803ff370000 g7: 0000021100004000
[   98.381202] o0: 0000000000000000 o1: fffff803ff370008 o2: 0000000000004000 o3: 0000000000000001
[   98.381202] o4: 0000009901c9d200 o5: 0000000000000012 sp: fffff803ff373681 ret_pc: 0000000000427818
[   98.381202] RPC: <cpu_idle+0x9c/0x134>
[   98.381202] l0: 000000000000001e l1: 00000000007b95c8 l2: 000000000000001e l3: 00000000000000c8
[   98.381202] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.381202] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.381202] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff373741 i7: 00000000006b0110
[   98.381202] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.381202] BUG: soft lockup - CPU#25 stuck for 73s! [swapper:0]
[   98.381202] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.381202] TPC: <cpu_idle+0xb0/0x134>
[   98.381202] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff2f4000 g3: 0000000000000000
[   98.381202] g4: fffff803ff2dd800 g5: fffff80007d2c000 g6: fffff803ff2f4000 g7: 0000021100004000
[   98.381202] o0: 0000000000000000 o1: fffff803ff2f4008 o2: 0000000000004000 o3: 0000000000000001
[   98.381202] o4: 0000009901c9d200 o5: 0000000000000012 sp: fffff803ff2f7681 ret_pc: 0000000000427818
[   98.381202] RPC: <cpu_idle+0x9c/0x134>
[   98.381202] l0: 0000000000000019 l1: 00000000007b95c8 l2: 0000000000000019 l3: 00000000000000c8
[   98.381202] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.381202] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.381202] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff2f7741 i7: 00000000006b0110
[   98.381202] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.381202] BUG: soft lockup - CPU#26 stuck for 73s! [sh:4063]
[   98.381202] TSTATE: 0000004411001600 TPC: 00000000006b4864 TNPC: 00000000006b4868 Y: 00000000    Not tainted
[   98.381202] TPC: <_spin_unlock_irq+0x0/0x14>
[   98.381202] g0: fffff803f7477000 g1: 0000000000000000 g2: 00000000000001ff g3: 0000000000000000
[   98.381202] g4: fffff803f7477000 g5: fffff80007d34000 g6: fffff803f4bb0000 g7: 9800000000000690
[   98.381202] o0: fffff803fbb1a5e0 o1: 0000000000000000 o2: 0000000000000001 o3: 0000000000000044
[   98.381202] o4: 0000000000000000 o5: 0000000000000000 sp: fffff803f4bb3381 ret_pc: 000000000044a9e0
[   98.381202] RPC: <flush_tlb_pending+0x28/0x64>
[   98.381202] l0: fffff80008522460 l1: 0000000206ff6bb0 l2: fffff803f7477000 l3: fffff803fbb1e348
[   98.381202] l4: 0000000206f8a880 l5: fffff803fbb2ea28 l6: 0000000000000010 l7: 00000000001200d2
[   98.381202] i0: fffff803fbb1a380 i1: 000000007003c001 i2: fffff803fba4e0f0 i3: 98000003ffab4690
[   98.381202] i4: 0000000006ff6bb0 i5: 0000000000000000 i6: fffff803f4bb3441 i7: 00000000004997dc
[   98.381202] I7: <do_wp_page+0x52c/0x660>
[   98.381202] BUG: soft lockup - CPU#31 stuck for 73s! [swapper:0]
[   98.381203] TSTATE: 0000000011001602 TPC: 000000000047c2dc TNPC: 000000000047c2e0 Y: 0002b572    Not tainted
[   98.381203] TPC: <get_cpu_idle_time_us+0x0/0xd0>
[   98.381203] g0: 0000000000009000 g1: 0000000000000000 g2: 0000000000000001 g3: 0000000000000001
[   98.381203] g4: fffff803ff353000 g5: fffff80007d5c000 g6: fffff803ff384000 g7: fffff80007c64000
[   98.381203] o0: 0000000000000001 o1: 0000000000000000 o2: fffff803fa6905e8 o3: 00000000d4aa2000
[   98.381203] o4: 0000000000843400 o5: 00000000007ae800 sp: fffff803ff3875c1 ret_pc: 000000000047c138
[   98.381203] RPC: <tick_nohz_stop_sched_tick+0x1b4/0x358>
[   98.381203] l0: 000000000000001f l1: fffff8000854cc30 l2: 0000000000000001 l3: 000000000000001f
[   98.381203] l4: 0000000100008b84 l5: 000000000000001f l6: 0000009901ee5a15 l7: 0000000000000000
[   98.381203] i0: 0000000000000001 i1: 0000000000000400 i2: fffff803f72bc600 i3: fffff8000854a2d0
[   98.381203] i4: 0000009901c9d200 i5: 000000013fff9618 i6: fffff803ff387681 i7: 00000000004277b0
[   98.381203] I7: <cpu_idle+0x34/0x134>
[   98.381203] BUG: soft lockup - CPU#57 stuck for 73s! [swapper:0]
[   98.381203] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.381203] TPC: <cpu_idle+0xb0/0x134>
[   98.381203] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff61c000 g3: 0000000000000000
[   98.381203] g4: fffff803ff610c00 g5: fffff80007e2c000 g6: fffff803ff61c000 g7: 0000021100004000
[   98.381203] o0: 0000000000000000 o1: fffff803ff61c008 o2: 0000000000004000 o3: 0000000000000001
[   98.381203] o4: 0000009901c9d200 o5: 0000000000000012 sp: fffff803ff61f681 ret_pc: 0000000000427818
[   98.381203] RPC: <cpu_idle+0x9c/0x134>
[   98.381203] l0: 0000000000000039 l1: 00000000007b95c8 l2: 0000000000000039 l3: 00000000000000c8
[   98.381203] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.381203] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.381203] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff61f741 i7: 00000000006b0110
[   98.381203] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.381203] BUG: soft lockup - CPU#62 stuck for 73s! [swapper:0]
[   98.381203] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.381203] TPC: <cpu_idle+0xb0/0x134>
[   98.381203] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff690000 g3: 0000000000000000
[   98.381203] g4: fffff803ff684c00 g5: fffff80007e54000 g6: fffff803ff690000 g7: 0000021100004000
[   98.381203] o0: 0000000000000000 o1: fffff803ff690008 o2: 0000000000004000 o3: 0000000000000001
[   98.381203] o4: 0000009901313b80 o5: 0000000000000012 sp: fffff803ff693681 ret_pc: 0000000000427818
[   98.381203] RPC: <cpu_idle+0x9c/0x134>
[   98.381203] l0: 000000000000003e l1: 00000000007b95c8 l2: 000000000000003e l3: 00000000000000c8
[   98.381203] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.381203] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.381203] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff693741 i7: 00000000006b0110
[   98.381203] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.381203] BUG: soft lockup - CPU#58 stuck for 73s! [swapper:0]
[   98.381203] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.381203] TPC: <cpu_idle+0xb0/0x134>
[   98.381203] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff630000 g3: 0000000000000000
[   98.381203] g4: fffff803ff612400 g5: fffff80007e34000 g6: fffff803ff630000 g7: 0000021100004000
[   98.381203] o0: 0000000000000000 o1: fffff803ff630008 o2: 0000000000004000 o3: 0000000000000001
[   98.381203] o4: 0000009901313b80 o5: 0000000000000012 sp: fffff803ff633681 ret_pc: 0000000000427818
[   98.381203] RPC: <cpu_idle+0x9c/0x134>
[   98.381203] l0: 000000000000003a l1: 00000000007b95c8 l2: 000000000000003a l3: 00000000000000c8
[   98.381203] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.381203] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.381203] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff633741 i7: 00000000006b0110
[   98.381203] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.388125] BUG: soft lockup - CPU#2 stuck for 62s! [swapper:0]
[   98.388125] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000400    Not tainted
[   98.388125] TPC: <cpu_idle+0xb0/0x134>
[   98.388125] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff0a4000 g3: 0000000000000000
[   98.388125] g4: fffff803ff098c00 g5: fffff80007c74000 g6: fffff803ff0a4000 g7: 0000021100004000
[   98.388125] o0: 0000000000000000 o1: fffff803ff0a4008 o2: 0000000000004000 o3: 0000000000000001
[   98.388125] o4: 0000009902626880 o5: 0000000000000012 sp: fffff803ff0a7681 ret_pc: 0000000000427818
[   98.388125] RPC: <cpu_idle+0x9c/0x134>
[   98.388125] l0: 0000000000000002 l1: 00000000007b95c8 l2: 0000000000000002 l3: 00000000000000c8
[   98.388125] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.388125] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.388125] i4: 00000000fee82518 i5: 00000000fee815f8 i6: fffff803ff0a7741 i7: 00000000006b0110
[   98.388125] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.388125] BUG: soft lockup - CPU#6 stuck for 73s! [cc1:4068]
[   98.388125] TSTATE: 0000004482000a01 TPC: 0000000070101748 TNPC: 000000007010174c Y: 00000000    Not tainted
[   98.388125] TPC: <0x70101750>
[   98.388125] g0: 0000000000000000 g1: 0000000000000001 g2: 000000000000a2f9 g3: 00000000701fd630
[   98.388125] g4: 0000000000000000 g5: 0000000000000030 g6: 00feffffffffffff g7: 0000000070001d00
[   98.388125] o0: 000000000046dce8 o1: 0000000000000020 o2: 0000000000000005 o3: 0000000000000038
[   98.388125] o4: 0000000000000038 o5: 0000000000000005 sp: 00000000ff82a3c8 ret_pc: 0000000070101734
[   98.388125] RPC: <0x7010173c>
[   98.388125] l0: 00000000 l1: 00000000 l2: 0046dce0 l3: 0000a321 l4: 00000000 l5: 00000000 l6: 00000000 l7: 701fb000
[   98.388125] i0: 00000000 i1: 701fd630 i2: 00000020 i3: 00000000 i4: 00000000 i5: 00000000 i6: ff82a438 i7: 00398128
[   98.388125] BUG: soft lockup - CPU#7 stuck for 73s! [as:4069]
[   98.388125] TSTATE: 00000099f0000a07 TPC: 00000000700457e8 TNPC: 00000000700457ec Y: 00000000    Not tainted
[   98.388125] TPC: <0x700457f0>
[   98.388125] g0: 0000000000000000 g1: 000000000000000c g2: 00000000700a71b8 g3: 0000000000000000
[   98.388125] g4: 0000000000000000 g5: 0000000000000010 g6: 0000000000feffff g7: 0000000070002340
[   98.388125] o0: 00000000700a71b8 o1: 000000007006a890 o2: 00000000ffe6e404 o3: 0000000070001810
[   98.388125] o4: 0000000000000001 o5: 0000000000000000 sp: 00000000ffe6e358 ret_pc: 000000007004556c
[   98.388125] RPC: <0x70045574>
[   98.388125] l0: 00000003 l1: 7015a208 l2: 700b8968 l3: 700a71b8 l4: 700a4000 l5: 700bd09c l6: 700ae5fa l7: 7006a000
[   98.388125] i0: 700011c8 i1: ffe6e404 i2: 700c82ac i3: 700011c8 i4: 700a6b88 i5: ffe6e3e0 i6: ffe6e418 i7: 7003d720
[   98.388125] BUG: soft lockup - CPU#10 stuck for 73s! [swapper:0]
[   98.388125] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000980    Not tainted
[   98.388125] TPC: <cpu_idle+0xb0/0x134>
[   98.388125] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff168000 g3: 0000000000000000
[   98.388125] g4: fffff803ff151800 g5: fffff80007cb4000 g6: fffff803ff168000 g7: 0000021100004000
[   98.388125] o0: 0000000000000000 o1: fffff803ff168008 o2: 0000000000004000 o3: 0000000000000001
[   98.388125] o4: 0000009901c9d200 o5: 0000000000000012 sp: fffff803ff16b681 ret_pc: 0000000000427818
[   98.388125] RPC: <cpu_idle+0x9c/0x134>
[   98.388125] l0: 000000000000000a l1: 00000000007b95c8 l2: 000000000000000a l3: 00000000000000c8
[   98.388125] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.388125] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.388125] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff16b741 i7: 00000000006b0110
[   98.388125] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.389925] BUG: soft lockup - CPU#9 stuck for 73s! [swapper:0]
[   98.389925] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.389925] TPC: <cpu_idle+0xb0/0x134>
[   98.389925] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff154000 g3: 0000000000000000
[   98.389925] g4: fffff803ff150000 g5: fffff80007cac000 g6: fffff803ff154000 g7: 0000021100004000
[   98.389925] o0: 0000000000000000 o1: fffff803ff154008 o2: 0000000000004000 o3: 0000000000000001
[   98.389925] o4: 0000009901c9d200 o5: 0000000000000012 sp: fffff803ff157681 ret_pc: 0000000000427818
[   98.389925] RPC: <cpu_idle+0x9c/0x134>
[   98.389925] l0: 0000000000000009 l1: 00000000007b95c8 l2: 0000000000000009 l3: 00000000000000c8
[   98.389925] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.389925] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.389925] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff157741 i7: 00000000006b0110
[   98.390459] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.391202] BUG: soft lockup - CPU#49 stuck for 73s! [swapper:0]
[   98.391202] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000320    Not tainted
[   98.391202] TPC: <cpu_idle+0xb0/0x134>
[   98.391202] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff558000 g3: 0000000000000000
[   98.391202] g4: fffff803ff554000 g5: fffff80007dec000 g6: fffff803ff558000 g7: 0000021100004000
[   98.391202] o0: 0000000000000000 o1: fffff803ff558008 o2: 0000000000004000 o3: 0000000000000001
[   98.391202] o4: 0000009901c9d200 o5: 0000000000000012 sp: fffff803ff55b681 ret_pc: 0000000000427818
[   98.391202] RPC: <cpu_idle+0x9c/0x134>
[   98.391202] l0: 0000000000000031 l1: 00000000007b95c8 l2: 0000000000000031 l3: 00000000000000c8
[   98.391202] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.391202] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.391202] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff55b741 i7: 00000000006b0110
[   98.391202] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.398125] BUG: soft lockup - CPU#3 stuck for 68s! [swapper:0]
[   98.398125] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.398125] TPC: <cpu_idle+0xb0/0x134>
[   98.398125] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff0c0000 g3: 0000000000000000
[   98.398125] g4: fffff803ff09a400 g5: fffff80007c7c000 g6: fffff803ff0c0000 g7: 0000021100004000
[   98.398125] o0: 0000000000000000 o1: fffff803ff0c0008 o2: 0000000000004000 o3: 0000000000000001
[   98.398125] o4: 0000009902626880 o5: 0000000000000012 sp: fffff803ff0c3681 ret_pc: 0000000000427818
[   98.398125] RPC: <cpu_idle+0x9c/0x134>
[   98.398125] l0: 0000000000000003 l1: 00000000007b95c8 l2: 0000000000000003 l3: 00000000000000c8
[   98.398125] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.398125] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.398125] i4: 00000000fee82318 i5: 00000000fee813f8 i6: fffff803ff0c3741 i7: 00000000006b0110
[   98.398125] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.398125] BUG: soft lockup - CPU#8 stuck for 73s! [swapper:0]
[   98.398125] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.399422] TPC: <cpu_idle+0xb0/0x134>
[   98.399422] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff134000 g3: 0000000000000000
[   98.399422] g4: fffff803ff116400 g5: fffff80007ca4000 g6: fffff803ff134000 g7: 0000021100004000
[   98.399422] o0: 0000000000000000 o1: fffff803ff134008 o2: 0000000000004000 o3: 0000000000000001
[   98.399422] o4: 0000009902626880 o5: 0000000000000012 sp: fffff803ff137681 ret_pc: 0000000000427818
[   98.399422] RPC: <cpu_idle+0x9c/0x134>
[   98.399422] l0: 0000000000000008 l1: 00000000007b95c8 l2: 0000000000000008 l3: 00000000000000c8
[   98.399422] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.399422] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.399422] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff137741 i7: 00000000006b0110
[   98.399422] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.399422] BUG: soft lockup - CPU#11 stuck for 73s! [swapper:0]
[   98.399422] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.399422] TPC: <cpu_idle+0xb0/0x134>
[   98.399422] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff17c000 g3: 0000000000000000
[   98.399422] g4: fffff803ff153000 g5: fffff80007cbc000 g6: fffff803ff17c000 g7: 0000021100004000
[   98.399422] o0: 0000000000000000 o1: fffff803ff17c008 o2: 0000000000004000 o3: 0000000000000001
[   98.399422] o4: 0000009902626880 o5: 0000000000000012 sp: fffff803ff17f681 ret_pc: 0000000000427818
[   98.399422] RPC: <cpu_idle+0x9c/0x134>
[   98.399422] l0: 000000000000000b l1: 00000000007b95c8 l2: 000000000000000b l3: 00000000000000c8
[   98.399422] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.399422] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.399422] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff17f741 i7: 00000000006b0110
[   98.399422] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.603198] BUG: soft lockup - CPU#48 stuck for 73s! [syslogd:2393]
[   98.603198] TSTATE: 0000004411001602 TPC: 00000000004ae8e4 TNPC: 00000000004ae8e8 Y: 00000000    Not tainted
[   98.603198] TPC: <kmem_cache_alloc+0x78/0x9c>
[   98.603198] g0: fffff803f80a6cb1 g1: 0000000000000000 g2: fffff803fc808000 g3: fffff803f2820000
[   98.603198] g4: fffff803fe3f0000 g5: fffff80007de4000 g6: fffff803f80a4000 g7: 00e0000000000818
[   98.603198] o0: fffff803fd848800 o1: 0000000000000050 o2: ffffffffffffffff o3: 000000000050fd30
[   98.603198] o4: fffff800085d5878 o5: 0000000206f17390 sp: fffff803f80a6cf1 ret_pc: 000000000048aeec
[   98.603198] RPC: <find_lock_page+0x58/0xe0>
[   98.609061] l0: fffff800085d5878 l1: 0000000000000000 l2: 0000000000000000 l3: 0000000000000000
[   98.609061] l4: 0000000000000000 l5: 0000000000000000 l6: 0000000000000000 l7: 00000000f7ed7000
[   98.609061] i0: fffff803fd848800 i1: 0000000000000050 i2: 0000000000729f58 i3: 0000000000000006
[   98.609061] i4: fffff803fe366ab8 i5: fffff803fe366aa8 i6: fffff803f80a6db1 i7: 000000000050fd30
[   98.609061] I7: <journal_start+0x68/0xbc>
[   98.739065] BUG: soft lockup - CPU#56 stuck for 73s! [cc1:4067]
[   98.739065] TSTATE: 0000009982000a04 TPC: 0000000000092a6c TNPC: 0000000000092a70 Y: 00000000    Not tainted
[   98.739065] TPC: <0x92a74>
[   98.739065] g0: 0000000000000000 g1: 000000000000001f g2: 0000000070392bd0 g3: 0000000000093c30
[   98.739065] g4: 0000000000000004 g5: 000000000048b630 g6: 00000000000000ff g7: 0000000070001d00
[   98.739065] o0: 000000000046cb98 o1: 0000000070417b90 o2: 00000000003b2000 o3: 00000000007f0000
[   98.739065] o4: 0000000070295d20 o5: 000000000000001f sp: 00000000ffd75ed0 ret_pc: 0000000000092adc
[   98.739065] RPC: <0x92ae4>
[   98.739065] l0: 0041a000 l1: 704537a0 l2: 00000001 l3: 00000001 l4: 00399800 l5: 00000000 l6: 00002710 l7: 7027b000
[   98.739065] i0: 703fd7e0 i1: 70417bc8 i2: 00000000 i3: 00000000 i4: 00000040 i5: 00485518 i6: ffd75f40 i7: 00094058
[   98.865062] BUG: soft lockup - CPU#32 stuck for 74s! [cc1:4093]
[   98.865062] TSTATE: 0000000082001a06 TPC: 000000007016c944 TNPC: 000000007016c948 Y: 00000011    Not tainted
[   98.865062] TPC: <0x7016c94c>
[   98.865062] g0: 0000000000000000 g1: 0000000000000007 g2: 0000000000004000 g3: 00000000004ab36d
[   98.865062] g4: 0000000000478eb8 g5: 74726963745f5f00 g6: 0000000000000038 g7: 0000000070001d00
[   98.865062] o0: 00000000004a2d2f o1: 00000000004ab36b o2: 0000000000000002 o3: 0000000000000074
[   98.865062] o4: 0000000000000070 o5: 000000005f6e7074 sp: 00000000ff8d0660 ret_pc: 0000000000386f10
[   98.865062] RPC: <0x386f18>
[   98.865062] l0: 00478eb8 l1: 00003db8 l2: 00000f6e l3: 00003fff l4: 00478eb8 l5: 004595c0 l6: 00458580 l7: 00403400
[   98.865062] i0: 7033a910 i1: 004ab367 i2: 00000006 i3: 41cc8f6e i4: 00000001 i5: 000697da i6: ff8d06d0 i7: 00380690
[   98.955478] BUG: soft lockup - CPU#41 stuck for 74s! [swapper:0]
[   98.955478] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.955478] TPC: <cpu_idle+0xb0/0x134>
[   98.955478] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff474000 g3: 0000000000000000
[   98.955478] g4: fffff803ff44b000 g5: fffff80007dac000 g6: fffff803ff474000 g7: 0000021100004000
[   98.955478] o0: 0000000000000000 o1: fffff803ff474008 o2: 0000000000004000 o3: 0000000000000001
[   98.955478] o4: 00000099232abe00 o5: 0000000000000012 sp: fffff803ff477681 ret_pc: 0000000000427818
[   98.955478] RPC: <cpu_idle+0x9c/0x134>
[   98.955478] l0: 0000000000000029 l1: 00000000007b95c8 l2: 0000000000000029 l3: 00000000000000c8
[   98.955478] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.955478] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.955478] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff477741 i7: 00000000006b0110
[   98.955478] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.955478] BUG: soft lockup - CPU#42 stuck for 74s! [as:4095]
[   98.961318] TSTATE: 00000099f0001a04 TPC: 0000000070284ee4 TNPC: 0000000070284ee8 Y: 00000000    Not tainted
[   98.961319] TPC: <0x70284eec>
[   98.961319] g0: 0000000000000000 g1: 000000003dc11314 g2: 000000007014b700 g3: 0000000070153578
[   98.961319] g4: 0000000070269940 g5: 6761730000000000 g6: 00feffffffffffff g7: 0000000070002340
[   98.961319] o0: 0000000000000000 o1: 000000007014be68 o2: 0000000000000333 o3: 0000000000121940
[   98.961319] o4: 0000000070001468 o5: 000000000000000a sp: 00000000ffb4a980 ret_pc: 00000000000003f3
[   98.961319] RPC: <0x3fb>
[   98.961319] l0: 701489a4 l1: 00005877 l2: 7004e890 l3: 70155318 l4: 00000000 l5: 00000000 l6: 00000000 l7: 702c7000
[   98.961319] i0: 701c9680 i1: ffb4aa64 i2: ffb4aa74 i3: 00000000 i4: 00000000 i5: 00000000 i6: ffb4a9f0 i7: 701c99fc
[   98.991378] BUG: soft lockup - CPU#46 stuck for 74s! [swapper:0]
[   98.991378] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.991378] TPC: <cpu_idle+0xb0/0x134>
[   98.991378] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff50c000 g3: 0000000000000000
[   98.991378] g4: fffff803ff4bf000 g5: fffff80007dd4000 g6: fffff803ff50c000 g7: 0000021100004000
[   98.991378] o0: 0000000000000000 o1: fffff803ff50c008 o2: 0000000000004000 o3: 0000000000000001
[   98.991378] o4: 0000009924f48180 o5: 0000000000000012 sp: fffff803ff50f681 ret_pc: 0000000000427818
[   98.991378] RPC: <cpu_idle+0x9c/0x134>
[   98.991378] l0: 000000000000002e l1: 00000000007b95c8 l2: 000000000000002e l3: 00000000000000c8
[   98.991378] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.991378] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.991378] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff50f741 i7: 00000000006b0110
[   98.991378] I7: <after_lock_tlb+0x1a4/0x1b4>
[   98.991378] BUG: soft lockup - CPU#47 stuck for 74s! [swapper:0]
[   98.991378] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   98.991378] TPC: <cpu_idle+0xb0/0x134>
[   98.991378] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff524000 g3: 0000000000000000
[   98.991378] g4: fffff803ff518c00 g5: fffff80007ddc000 g6: fffff803ff524000 g7: 0000021100004000
[   98.991378] o0: 0000000000000000 o1: fffff803ff524008 o2: 0000000000004000 o3: 0000000000000001
[   98.991378] o4: 0000009924f48180 o5: 0000000000000012 sp: fffff803ff527681 ret_pc: 0000000000427818
[   98.991378] RPC: <cpu_idle+0x9c/0x134>
[   98.991378] l0: 000000000000002f l1: 00000000007b95c8 l2: 000000000000002f l3: 00000000000000c8
[   98.991378] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   98.991378] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   98.991378] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff527741 i7: 00000000006b0110
[   98.991378] I7: <after_lock_tlb+0x1a4/0x1b4>
[   99.098067] BUG: soft lockup - CPU#40 stuck for 74s! [swapper:0]
[   99.098067] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 0000077e    Not tainted
[   99.098067] TPC: <cpu_idle+0xb0/0x134>
[   99.098067] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff460000 g3: 0000000000000000
[   99.098067] g4: fffff803ff449800 g5: fffff80007da4000 g6: fffff803ff460000 g7: 0000021100004000
[   99.101325] o0: 0000000000000000 o1: fffff803ff460008 o2: 0000000000004000 o3: 0000000000000001
[   99.101325] o4: 000000992b82f900 o5: 0000000000000012 sp: fffff803ff463681 ret_pc: 0000000000427818
[   99.101325] RPC: <cpu_idle+0x9c/0x134>
[   99.101325] l0: 0000000000000028 l1: 00000000007b95c8 l2: 0000000000000028 l3: 00000000000000c8
[   99.101325] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   99.101325] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   99.101325] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff463741 i7: 00000000006b0110
[   99.101325] I7: <after_lock_tlb+0x1a4/0x1b4>
[   99.228066] BUG: soft lockup - CPU#24 stuck for 74s! [mv:4104]
[   99.228068] TSTATE: 0000000011001601 TPC: 00000000006b561c TNPC: 00000000006b5620 Y: 00000000    Not tainted
[   99.228068] TPC: <do_sparc64_fault+0xc/0x5b0>
[   99.228068] g0: 0000000000000b48 g1: 0000000001010101 g2: 0000000000000007 g3: fffff80007c64000
[   99.228068] g4: fffff803f3080c00 g5: fffff80007d24000 g6: fffff803f3224000 g7: 0000000070002de0
[   99.228068] o0: fffff803fe3f43e0 o1: fffff803fe2b4b28 o2: 0000000000000035 o3: fffff803f993c410
[   99.228068] o4: fffff803f99c8380 o5: 0000000000000000 sp: fffff803f32275e1 ret_pc: 00000000006b59b8
[   99.228068] RPC: <do_sparc64_fault+0x3a8/0x5b0>
[   99.228068] l0: 0000000070104000 l1: 0000000000000000 l2: fffff803fe2b4b28 l3: 0000000070102000
[   99.228068] l4: fffff803f99c8000 l5: 0000000000000380 l6: 0000000000000408 l7: fffff803fe3f4380
[   99.228068] i0: fffff803f3227f60 i1: fffff803f3227f60 i2: 00000000700d7768 i3: 0000000000000000
[   99.228068] i4: 0000000000000002 i5: 0000000000000000 i6: fffff803f32276a1 i7: 0000000000407a2c
[   99.228068] I7: <sparc64_realfault_common+0x18/0x20>
[   99.228068] BUG: soft lockup - CPU#27 stuck for 74s! [swapper:0]
[   99.228068] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[   99.228068] TPC: <cpu_idle+0xb0/0x134>
[   99.228068] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff328000 g3: 0000000000000000
[   99.228068] g4: fffff803ff31cc00 g5: fffff80007d3c000 g6: fffff803ff328000 g7: 0000021100004000
[   99.228068] o0: 0000000000000000 o1: fffff803ff328008 o2: 0000000000004000 o3: 0000000000000001
[   99.228068] o4: 0000009933db3400 o5: 0000000000000012 sp: fffff803ff32b681 ret_pc: 0000000000427818
[   99.228068] RPC: <cpu_idle+0x9c/0x134>
[   99.228068] l0: 000000000000001b l1: 00000000007b95c8 l2: 000000000000001b l3: 00000000000000c8
[   99.228068] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[   99.228068] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[   99.228068] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff32b741 i7: 00000000006b0110
[   99.228068] I7: <after_lock_tlb+0x1a4/0x1b4>
[   99.477344] BUG: soft lockup - CPU#33 stuck for 74s! [ld:4107]
[   99.477344] TSTATE: 0000000011001601 TPC: 0000000000559ec4 TNPC: 0000000000559ec8 Y: 00000000    Not tainted
[   99.477344] TPC: <atomic_sub_ret+0x1c/0x58>
[   99.477344] g0: 00000000700ff438 g1: 0000000000000004 g2: 0000000000004000 g3: 0000000000000000
[   99.477904] g4: fffff803fab5c600 g5: fffff80007d6c000 g6: fffff803f4b58000 g7: 0000000000000004
[   99.477904] o0: 0000000000000001 o1: fffff803fb823768 o2: 0000000000000001 o3: 0000000000000000
[   99.477904] o4: 00000000000e72d8 o5: 0000000000000000 sp: fffff803f4b5b461 ret_pc: 00000000004b2c6c
[   99.477904] RPC: <fput+0x10/0x2c>
[   99.477904] l0: fffff803f4b5bc58 l1: fffff803fe878698 l2: fffff803f9a50a40 l3: 00000002000e72d8
[   99.477904] l4: 0000000000000000 l5: 0000000000000000 l6: 980000000841a690 l7: 0000000000000000
[   99.477904] i0: fffff803fb823740 i1: fffff803fb6dedc0 i2: 0000000070290000 i3: 0000000206f8f120
[   99.477904] i4: 0000000206f4e0d0 i5: 0000000206f4e0d0 i6: fffff803f4b5b521 i7: 00000000004b0464
[   99.477904] I7: <filp_close+0x74/0x80>

----Next_Part(Wed_Apr_23_05_29_28_2008_136)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="bug2.log"

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.27.1 2007/09/14 15:17'
[    0.000000] PROMLIB: Root node compatible: sun4v
[    0.000000] Linux version 2.6.25-schedbugs (davem@huronp11) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #6 SMP Wed Apr 23 05:09:41 PDT 2008
[    0.000000] console [earlyprom0] enabled
[    0.000000] ARCH: SUN4V
[    0.000000] Ethernet address: 00:14:4f:3e:cb:f4
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] [0000000200000000-fffff80009000000] page_structs=262144 node=0 entry=0/0
[    0.000000] [0000000200000000-fffff80009400000] page_structs=262144 node=0 entry=1/0
[    0.000000] [0000000200000000-fffff80009800000] page_structs=262144 node=0 entry=2/0
[    0.000000] [0000000200000000-fffff80009c00000] page_structs=262144 node=0 entry=3/0
[    0.000000] [0000000200e00000-fffff8000a000000] page_structs=262144 node=0 entry=4/0
[    0.000000] [0000000200e00000-fffff8000a400000] page_structs=262144 node=0 entry=5/0
[    0.000000] [0000000200e00000-fffff8000a800000] page_structs=262144 node=0 entry=6/0
[    0.000000] [0000000201c00000-fffff8000ac00000] page_structs=262144 node=0 entry=7/0
[    0.000000] [0000000201c00000-fffff8000b000000] page_structs=262144 node=0 entry=8/0
[    0.000000] [0000000201c00000-fffff8000b400000] page_structs=262144 node=0 entry=9/0
[    0.000000] [0000000201c00000-fffff8000b800000] page_structs=262144 node=0 entry=10/0
[    0.000000] [0000000202a00000-fffff8000bc00000] page_structs=262144 node=0 entry=11/0
[    0.000000] [0000000202a00000-fffff8000c000000] page_structs=262144 node=0 entry=12/0
[    0.000000] [0000000202a00000-fffff8000c400000] page_structs=262144 node=0 entry=13/0
[    0.000000] [0000000203800000-fffff8000c800000] page_structs=262144 node=0 entry=14/0
[    0.000000] [0000000203800000-fffff8000cc00000] page_structs=262144 node=0 entry=15/0
[    0.000000] [0000000203800000-fffff8000d000000] page_structs=262144 node=0 entry=16/0
[    0.000000] [0000000203800000-fffff8000d400000] page_structs=262144 node=0 entry=17/0
[    0.000000] [0000000204600000-fffff8000d800000] page_structs=262144 node=0 entry=18/0
[    0.000000] [0000000204600000-fffff8000dc00000] page_structs=262144 node=0 entry=19/0
[    0.000000] [0000000204600000-fffff8000e000000] page_structs=262144 node=0 entry=20/0
[    0.000000] [0000000205400000-fffff8000e400000] page_structs=262144 node=0 entry=21/0
[    0.000000] [0000000205400000-fffff8000e800000] page_structs=262144 node=0 entry=22/0
[    0.000000] [0000000205400000-fffff8000ec00000] page_structs=262144 node=0 entry=23/0
[    0.000000] [0000000205400000-fffff8000f000000] page_structs=262144 node=0 entry=24/0
[    0.000000] [0000000206200000-fffff8000f400000] page_structs=262144 node=0 entry=25/0
[    0.000000] [0000000206200000-fffff8000f800000] page_structs=262144 node=0 entry=26/0
[    0.000000] [0000000206200000-fffff8000fc00000] page_structs=262144 node=0 entry=27/0
[    0.000000] OF stdout device is: /virtual-devices@100/console@1
[    0.000000] PROM: Built device tree with 124732 bytes of memory.
[    0.000000] MDESC: Size is 59392 bytes.
[    0.000000] PLATFORM: banner-name [SPARC Enterprise T5220]
[    0.000000] PLATFORM: name [SUNW,SPARC-Enterprise-T5220]
[    0.000000] PLATFORM: hostid [803ecbf4]
[    0.000000] PLATFORM: serial# [00ab4130]
[    0.000000] PLATFORM: stick-frequency [546e74c8]
[    0.000000] PLATFORM: mac-address [144f3ecbf4]
[    0.000000] PLATFORM: watchdog-resolution [1000 ms]
[    0.000000] PLATFORM: watchdog-max-timeout [31536000000 ms]
[    0.000000] PLATFORM: max-cpus [64]
[    0.000000] On node 0 totalpages: 2079047
[    0.000000]   Normal zone: 14331 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 2064716 pages, LIFO batch:15
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Booting Linux...
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2064716
[    0.000000] Kernel command line: root=/dev/sda2 ro
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.010000] clocksource: mult[b4b9] shift[16]
[    0.010000] clockevent: mult[b550b0f2] shift[31]
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console handover: boot [earlyprom0] -> real [tty0]
[    0.010337] Dentry cache hash table entries: 2097152 (order: 11, 16777216 bytes)
[    0.064342] Inode-cache hash table entries: 1048576 (order: 10, 8388608 bytes)
[    0.617044] Memory: 16390776k available (2768k kernel code, 1056k data, 168k init) [fffff80000000000,00000003ffb22000]
[    0.617184] SLUB: Genslabs=13, HWalign=32, Order=0-2, MinObjects=8, CPUs=64, Nodes=1
[    0.760006] Calibrating delay using timer specific routine.. 2835.88 BogoMIPS (lpj=14179404)
[    0.760227] Mount-cache hash table entries: 512
[    0.784425] Brought up 64 CPUs
[    0.793810] net_namespace: 584 bytes
[    0.793839] ldc.c:v1.0 (June 25, 2007)
[    0.794528] NET: Registered protocol family 16
[    0.816896] VIO: Adding device channel-devices
[    0.817083] VIO: Adding device vldc-port-3-0
[    0.817250] VIO: Adding device vldc-port-3-1
[    0.817416] VIO: Adding device vldc-port-3-2
[    0.817586] VIO: Adding device vldc-port-3-3
[    0.817752] VIO: Adding device vldc-port-3-4
[    0.817923] VIO: Adding device vldc-port-3-5
[    0.818090] VIO: Adding device vldc-port-3-8
[    0.818258] VIO: Adding device vldc-port-2-0
[    0.818430] VIO: Adding device vldc-port-0-0
[    0.818605] VIO: Adding device vldc-port-0-1
[    0.818778] VIO: Adding device vldc-port-0-2
[    0.818955] VIO: Adding device vldc-port-1-0
[    0.819199] VIO: Adding device ds-1
[    0.819369] VIO: Adding device ds-0
[    0.829479] PCI: Probing for controllers.
[    0.829529] SUN4V_PCI: Registered hvapi major[1] minor[0]
[    0.829800] /pci@0: SUN4V PCI Bus Module
[    0.829823] /pci@0: PCI IO[c810000000] MEM[ca00000000]
[    0.873893] /pci@0: Imported 3 TSB entries from OBP
[    0.874721] /pci@0: MSI Queue first[0] num[36] count[128] devino[0x18]
[    0.874748] /pci@0: MSI first[0] num[256] mask[0xff] width[32]
[    0.874772] /pci@0: MSI addr32[0x7fff0000:0x10000] addr64[0x3ffff0000:0x10000]
[    0.874802] /pci@0: MSI queues at RA [00000003fe600000]
[    0.874921] PCI: Scanning PBM /pci@0
[    0.884568] ebus: No EBus's found.
[    0.885123] ds.c:v1.0 (Jul 11, 2007)
[    0.898405] SCSI subsystem initialized
[    0.898873] usbcore: registered new interface driver usbfs
[    0.899053] usbcore: registered new interface driver hub
[    0.899341] usbcore: registered new device driver usb
[    0.952366] NET: Registered protocol family 2
[    0.955123] ds-1: Registered pri service.
[    0.960014] Switched to high resolution mode on CPU 0
[    0.960010] Switched to high resolution mode on CPU 24
[    0.960010] Switched to high resolution mode on CPU 52
[    0.965123] ds-1: Registered var-config-backup service.
[    0.970010] Switched to high resolution mode on CPU 25
[    0.970010] Switched to high resolution mode on CPU 53
[    0.970010] Switched to high resolution mode on CPU 26
[    0.970010] Switched to high resolution mode on CPU 54
[    0.970010] Switched to high resolution mode on CPU 27
[    0.970010] Switched to high resolution mode on CPU 55
[    0.970010] Switched to high resolution mode on CPU 28
[    0.970010] Switched to high resolution mode on CPU 56
[    0.970010] Switched to high resolution mode on CPU 1
[    0.971446] Switched to high resolution mode on CPU 29
[    0.971447] Switched to high resolution mode on CPU 57
[    0.971447] Switched to high resolution mode on CPU 2
[    0.971742] Switched to high resolution mode on CPU 30
[    0.971742] Switched to high resolution mode on CPU 58
[    0.971742] Switched to high resolution mode on CPU 3
[    0.971742] Switched to high resolution mode on CPU 31
[    0.971742] Switched to high resolution mode on CPU 59
[    0.971742] Switched to high resolution mode on CPU 4
[    0.971743] Switched to high resolution mode on CPU 32
[    0.971742] Switched to high resolution mode on CPU 60
[    0.971742] Switched to high resolution mode on CPU 5
[    0.971742] Switched to high resolution mode on CPU 33
[    0.971742] Switched to high resolution mode on CPU 61
[    0.971742] Switched to high resolution mode on CPU 6
[    0.971742] Switched to high resolution mode on CPU 34
[    0.971742] Switched to high resolution mode on CPU 62
[    0.971742] Switched to high resolution mode on CPU 7
[    0.973480] Switched to high resolution mode on CPU 35
[    0.973480] Switched to high resolution mode on CPU 63
[    0.973480] Switched to high resolution mode on CPU 8
[    0.973779] Switched to high resolution mode on CPU 9
[    0.973778] Switched to high resolution mode on CPU 37
[    0.974093] Switched to high resolution mode on CPU 10
[    0.974092] Switched to high resolution mode on CPU 38
[    0.974093] Switched to high resolution mode on CPU 11
[    0.974093] Switched to high resolution mode on CPU 39
[    0.974093] Switched to high resolution mode on CPU 12
[    0.974093] Switched to high resolution mode on CPU 40
[    0.974093] Switched to high resolution mode on CPU 13
[    0.974093] Switched to high resolution mode on CPU 41
[    0.974092] Switched to high resolution mode on CPU 14
[    0.974093] Switched to high resolution mode on CPU 42
[    0.965132] Switched to high resolution mode on CPU 36
[    0.974093] Switched to high resolution mode on CPU 15
[    0.974093] Switched to high resolution mode on CPU 43
[    0.974093] Switched to high resolution mode on CPU 16
[    0.974093] Switched to high resolution mode on CPU 44
[    0.974093] Switched to high resolution mode on CPU 17
[    0.974092] Switched to high resolution mode on CPU 45
[    0.974093] Switched to high resolution mode on CPU 18
[    0.974092] Switched to high resolution mode on CPU 46
[    0.974093] Switched to high resolution mode on CPU 19
[    0.974092] Switched to high resolution mode on CPU 47
[    0.974093] Switched to high resolution mode on CPU 20
[    0.974093] Switched to high resolution mode on CPU 48
[    0.974092] Switched to high resolution mode on CPU 21
[    0.974092] Switched to high resolution mode on CPU 49
[    0.974093] Switched to high resolution mode on CPU 22
[    0.974093] Switched to high resolution mode on CPU 50
[    0.974093] Switched to high resolution mode on CPU 23
[    0.974093] Switched to high resolution mode on CPU 51
[    1.077953] IP route cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    1.080220] TCP established hash table entries: 524288 (order: 10, 8388608 bytes)
[    1.106084] TCP bind hash table entries: 65536 (order: 7, 1048576 bytes)
[    1.111247] TCP: Hash tables configured (established 524288 bind 65536)
[    1.111274] TCP reno registered
[    1.139461] Mini RTC Driver
[    1.143026] Total HugeTLB memory allocated, 0
[    1.168413] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.168450] io scheduler noop registered
[    1.168469] io scheduler anticipatory registered (default)
[    1.168491] io scheduler deadline registered
[    1.168823] io scheduler cfq registered
[    1.168960] proc_dir_entry '00.0' already registered
[    1.168981] Call Trace:
[    1.168996]  [00000000004f0610] create_proc_entry+0x7c/0x98
[    1.169034]  [000000000056f320] pci_proc_attach_device+0xa4/0xd4
[    1.169065]  [00000000007dc798] pci_proc_init+0x64/0x88
[    1.169092]  [00000000007ca294] kernel_init+0x188/0x328
[    1.169126]  [0000000000426cf8] kernel_thread+0x38/0x48
[    1.169153]  [00000000006a1da0] rest_init+0x18/0x5c
[    1.183262] f0279bbc: ttyS0 at I/O 0x0 (irq = 17) is a SUN4V HCONS
[    1.183290] console [ttyHV0] enabled
[    1.240425] proc_dir_entry 'serial' already registered
[    1.240990] Call Trace:
[    1.242526]  [00000000004f0610] create_proc_entry+0x7c/0x98
[    1.242580]  [00000000004f1b34] proc_tty_register_driver+0x40/0x70
[    1.246943]  [0000000000591f18] tty_register_driver+0x1fc/0x208
[    1.249714]  [00000000005a8320] uart_register_driver+0x134/0x16c
[    1.249770]  [00000000005a9a80] sunserial_register_minors+0x34/0x68
[    1.251501]  [00000000007de128] sunsu_init+0xf8/0x150
[    1.253239]  [00000000007ca294] kernel_init+0x188/0x328
[    1.253291]  [0000000000426cf8] kernel_thread+0x38/0x48
[    1.255034]  [00000000006a1da0] rest_init+0x18/0x5c
[    1.261455] f0288ed4: ttyS0 at MMIO 0xfff0ca0000 (irq = 24) is a 16550A
[    1.263287] Uniform Multi-Platform E-IDE driver
[    1.299736] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    1.312446] Driver 'sd' needs updating - please use bus_type methods
[    1.312651] Fusion MPT base driver 3.04.06
[    1.312763] Copyright (c) 1999-2007 LSI Corporation
[    1.312886] Fusion MPT SPI Host driver 3.04.06
[    1.313138] Fusion MPT FC Host driver 3.04.06
[    1.313975] Fusion MPT SAS Host driver 3.04.06
[    1.314134] mptbase: ioc0: Initiating bringup
[    2.122473] ioc0: LSISAS1068E B1: Capabilities={Initiator}
[    2.132813] mptbase: ioc0: PCI-MSI enabled
[    8.232448] scsi0 : ioc0: LSISAS1068E B1, FwRev=011400dbh, Ports=1, MaxQ=511, IRQ=89
[    8.256649] scsi 0:0:0:0: Direct-Access     SEAGATE  ST973401LSUN72G  0556 PQ: 0 ANSI: 3
[    8.258607] sd 0:0:0:0: [sda] 143374738 512-byte hardware sectors (73408 MB)
[    8.259909] sd 0:0:0:0: [sda] Write Protect is off
[    8.260025] sd 0:0:0:0: [sda] Mode Sense: e3 00 10 08
[    8.261516] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[    8.262375] sd 0:0:0:0: [sda] 143374738 512-byte hardware sectors (73408 MB)
[    8.263915] sd 0:0:0:0: [sda] Write Protect is off
[    8.263952] sd 0:0:0:0: [sda] Mode Sense: e3 00 10 08
[    8.265630] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[    8.265691]  sda: sda1 sda2 sda3 sda4
[    8.270871] sd 0:0:0:0: [sda] Attached SCSI disk
[    8.274006] scsi 0:0:1:0: Direct-Access     FUJITSU  MAY2073RCSUN72G  0501 PQ: 0 ANSI: 4
[    8.276615] sd 0:0:1:0: [sdb] 143374738 512-byte hardware sectors (73408 MB)
[    8.278732] sd 0:0:1:0: [sdb] Write Protect is off
[    8.278925] sd 0:0:1:0: [sdb] Mode Sense: d3 00 00 08
[    8.280246] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    8.281233] sd 0:0:1:0: [sdb] 143374738 512-byte hardware sectors (73408 MB)
[    8.283359] sd 0:0:1:0: [sdb] Write Protect is off
[    8.283552] sd 0:0:1:0: [sdb] Mode Sense: d3 00 00 08
[    8.284858] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    8.285076]  sdb: sdb1 sdb2 sdb3
[    8.295835] sd 0:0:1:0: [sdb] Attached SCSI disk
[    8.299414] Fusion MPT misc device (ioctl) driver 3.04.06
[    8.299601] mptctl: Registered with Fusion MPT base driver
[    8.299649] mptctl: /dev/mptctl @ (major,minor=10,220)
[    8.299885] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    8.299899] ohci_hcd: block sizes: ed 80 td 96
[    8.300018] ohci_hcd 0000:07:00.0: OHCI Host Controller
[    8.300246] drivers/usb/core/inode.c: creating file 'devices'
[    8.300266] drivers/usb/core/inode.c: creating file '001'
[    8.300283] ohci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 1
[    8.300345] ohci_hcd 0000:07:00.0: enabled NEC chipset lost interrupt quirk
[    8.300409] ohci_hcd 0000:07:00.0: created debug files
[    8.300442] ohci_hcd 0000:07:00.0: irq 22, io mem 0xca00300000
[    8.354744] ohci_hcd 0000:07:00.0: OHCI controller state
[    8.354760] ohci_hcd 0000:07:00.0: OHCI 1.0, NO legacy support registers
[    8.354778] ohci_hcd 0000:07:00.0: control 0x083 HCFS=operational CBSR=3
[    8.354793] ohci_hcd 0000:07:00.0: cmdstatus 0x00000 SOC=0
[    8.354808] ohci_hcd 0000:07:00.0: intrstatus 0x00000004 SF
[    8.354823] ohci_hcd 0000:07:00.0: intrenable 0x8000005a MIE RHSC UE RD WDH
[    8.354848] ohci_hcd 0000:07:00.0: hcca frame #0003
[    8.354864] ohci_hcd 0000:07:00.0: roothub.a 01000203 POTPGT=1 NPS NDP=3(3)
[    8.354879] ohci_hcd 0000:07:00.0: roothub.b 00000000 PPCM=0000 DR=0000
[    8.354895] ohci_hcd 0000:07:00.0: roothub.status 00008000 DRWE
[    8.354912] ohci_hcd 0000:07:00.0: roothub.portstatus [0] 0x00000100 PPS
[    8.354928] ohci_hcd 0000:07:00.0: roothub.portstatus [1] 0x00000100 PPS
[    8.354944] ohci_hcd 0000:07:00.0: roothub.portstatus [2] 0x00000100 PPS
[    8.355006] usb usb1: default language 0x0409
[    8.355072] usb usb1: uevent
[    8.355220] usb usb1: usb_probe_device
[    8.355661] usb usb1: configuration #1 chosen from 1 choice
[    8.355722] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    8.355764] usb 1-0:1.0: uevent
[    8.355913] hub 1-0:1.0: usb_probe_interface
[    8.355924] hub 1-0:1.0: usb_probe_interface - got id
[    8.355934] hub 1-0:1.0: USB hub found
[    8.355995] hub 1-0:1.0: 3 ports detected
[    8.356026] hub 1-0:1.0: standalone hub
[    8.356035] hub 1-0:1.0: no power switching (usb 1.0)
[    8.356045] hub 1-0:1.0: global over-current protection
[    8.356056] hub 1-0:1.0: power on to power good time: 2ms
[    8.356080] hub 1-0:1.0: local power source is good
[    8.356090] hub 1-0:1.0: no over-current condition exists
[    8.356103] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    8.402448] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[    8.402692] drivers/usb/core/inode.c: creating file '001'
[    8.402720] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    8.402931] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.403063] usb usb1: Product: OHCI Host Controller
[    8.403096] usb usb1: Manufacturer: Linux 2.6.25-schedbugs ohci_hcd
[    8.403142] usb usb1: SerialNumber: 0000:07:00.0
[    8.403253] ohci_hcd 0000:07:00.1: OHCI Host Controller
[    8.403465] drivers/usb/core/inode.c: creating file '002'
[    8.403483] ohci_hcd 0000:07:00.1: new USB bus registered, assigned bus number 2
[    8.403542] ohci_hcd 0000:07:00.1: enabled NEC chipset lost interrupt quirk
[    8.403587] ohci_hcd 0000:07:00.1: created debug files
[    8.403616] ohci_hcd 0000:07:00.1: irq 23, io mem 0xca00302000
[    8.434482] ohci_hcd 0000:07:00.1: OHCI controller state
[    8.434499] ohci_hcd 0000:07:00.1: OHCI 1.0, NO legacy support registers
[    8.434518] ohci_hcd 0000:07:00.1: control 0x083 HCFS=operational CBSR=3
[    8.434534] ohci_hcd 0000:07:00.1: cmdstatus 0x00000 SOC=0
[    8.434549] ohci_hcd 0000:07:00.1: intrstatus 0x00000004 SF
[    8.434565] ohci_hcd 0000:07:00.1: intrenable 0x8000005a MIE RHSC UE RD WDH
[    8.434591] ohci_hcd 0000:07:00.1: hcca frame #0003
[    8.434607] ohci_hcd 0000:07:00.1: roothub.a 01000202 POTPGT=1 NPS NDP=2(2)
[    8.434622] ohci_hcd 0000:07:00.1: roothub.b 00000000 PPCM=0000 DR=0000
[    8.434636] ohci_hcd 0000:07:00.1: roothub.status 00008000 DRWE
[    8.434652] ohci_hcd 0000:07:00.1: roothub.portstatus [0] 0x00000100 PPS
[    8.434669] ohci_hcd 0000:07:00.1: roothub.portstatus [1] 0x00000100 PPS
[    8.434709] usb usb2: default language 0x0409
[    8.434772] usb usb2: uevent
[    8.434916] usb usb2: usb_probe_device
[    8.435186] usb usb2: configuration #1 chosen from 1 choice
[    8.435403] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    8.435445] usb 2-0:1.0: uevent
[    8.435590] hub 2-0:1.0: usb_probe_interface
[    8.435601] hub 2-0:1.0: usb_probe_interface - got id
[    8.435610] hub 2-0:1.0: USB hub found
[    8.435744] hub 2-0:1.0: 2 ports detected
[    8.435775] hub 2-0:1.0: standalone hub
[    8.435783] hub 2-0:1.0: no power switching (usb 1.0)
[    8.435793] hub 2-0:1.0: global over-current protection
[    8.435803] hub 2-0:1.0: power on to power good time: 2ms
[    8.435825] hub 2-0:1.0: local power source is good
[    8.435835] hub 2-0:1.0: no over-current condition exists
[    8.435846] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    8.482448] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.482448] drivers/usb/core/inode.c: creating file '001'
[    8.482476] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    8.482686] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.482818] usb usb2: Product: OHCI Host Controller
[    8.482851] usb usb2: Manufacturer: Linux 2.6.25-schedbugs ohci_hcd
[    8.482896] usb usb2: SerialNumber: 0000:07:00.1
[    8.483693] mice: PS/2 mouse device common for all mice
[    8.485018] usbcore: registered new interface driver hiddev
[    8.485215] usbcore: registered new interface driver usbhid
[    8.485268] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    8.487032] TCP cubic registered
[    8.487331] NET: Registered protocol family 1
[    8.487407] NET: Registered protocol family 17
[    8.508130] kjournald starting.  Commit interval 5 seconds
[    8.508928] EXT3-fs: mounted filesystem with ordered data mode.
[    8.508958] VFS: Mounted root (ext3 filesystem) readonly.
[   12.604506] usb usb1: uevent
[   12.604620] usb 1-0:1.0: uevent
[   12.604831] usb usb2: uevent
[   12.604948] usb 2-0:1.0: uevent
[   13.084953] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[   13.084953] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   13.084953] PCI: Enabling device: (0000:08:00.0), cmd 147
[   13.134778] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   13.135224] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   13.150271] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[   13.267744] eth0: (PCI Express:2.5GB/s:Width x4) 00:14:4f:3e:cb:f4
[   13.267962] eth0: Intel(R) PRO/1000 Network Connection
[   13.268158] eth0: MAC: 0, PHY: 4, PBA No: ffffff-0ff
[   13.268158] PCI: Enabling device: (0000:07:00.2), cmd 2
[   13.268158] ehci_hcd 0000:07:00.2: EHCI Host Controller
[   13.268158] drivers/usb/core/inode.c: creating file '003'
[   13.268158] ehci_hcd 0000:07:00.2: new USB bus registered, assigned bus number 3
[   13.268158] ehci_hcd 0000:07:00.2: reset hcs_params 0x2395 dbg=0 cc=2 pcc=3 ports=5
[   13.268158] ehci_hcd 0000:07:00.2: reset portroute 1 0 1 0 0 
[   13.268158] ehci_hcd 0000:07:00.2: reset hcc_params e806 thresh 0 uframes 256/512/1024 park
[   13.268158] ehci_hcd 0000:07:00.2: park 0
[   13.268158] ehci_hcd 0000:07:00.2: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   13.268158] ehci_hcd 0000:07:00.2: MWI active
[   13.268158] ehci_hcd 0000:07:00.2: supports USB remote wakeup
[   13.268158] ehci_hcd 0000:07:00.2: irq 20, io mem 0xca00304000
[   13.268158] ehci_hcd 0000:07:00.2: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   13.268158] ehci_hcd 0000:07:00.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
[   13.268158] PCI: Enabling device: (0000:08:00.1), cmd 147
[   13.278188] ehci_hcd 0000:07:00.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   13.278489] usb usb3: default language 0x0409
[   13.278571] usb usb3: uevent
[   13.278702] usb usb3: usb_probe_device
[   13.278993] usb usb3: configuration #1 chosen from 1 choice
[   13.284526] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   13.284579] usb 3-0:1.0: uevent
[   13.284689] hub 3-0:1.0: usb_probe_interface
[   13.284700] hub 3-0:1.0: usb_probe_interface - got id
[   13.284710] hub 3-0:1.0: USB hub found
[   13.284844] hub 3-0:1.0: 5 ports detected
[   13.284876] hub 3-0:1.0: standalone hub
[   13.284885] hub 3-0:1.0: individual port power switching
[   13.284896] hub 3-0:1.0: individual port over-current protection
[   13.284906] hub 3-0:1.0: Single TT
[   13.284916] hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
[   13.284928] hub 3-0:1.0: power on to power good time: 20ms
[   13.284949] hub 3-0:1.0: local power source is good
[   13.284961] hub 3-0:1.0: enabling power on all ports
[   13.384527] hub 3-0:1.0: state 7 ports 5 chg 0000 evt 0000
[   13.384527] drivers/usb/core/inode.c: creating file '001'
[   13.384562] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[   13.384527] ehci_hcd 0000:07:00.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[   13.384527] hub 3-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
[   13.394527] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.394661] usb usb3: Product: EHCI Host Controller
[   13.394695] usb usb3: Manufacturer: Linux 2.6.25-schedbugs ehci_hcd
[   13.394743] usb usb3: SerialNumber: 0000:07:00.2
[   13.418085] eth1: (PCI Express:2.5GB/s:Width x4) 00:14:4f:3e:cb:f5
[   13.418301] eth1: Intel(R) PRO/1000 Network Connection
[   13.418498] eth1: MAC: 0, PHY: 4, PBA No: ffffff-0ff
[   13.418640] PCI: Enabling device: (0000:09:00.0), cmd 147
[   13.547954] eth2: (PCI Express:2.5GB/s:Width x4) 00:14:4f:3e:cb:f6
[   13.548165] eth2: Intel(R) PRO/1000 Network Connection
[   13.548360] eth2: MAC: 0, PHY: 4, PBA No: ffffff-0ff
[   13.548360] PCI: Enabling device: (0000:09:00.1), cmd 147
[   13.548390] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
[   13.556759] warning: `dhclient3' uses 32-bit capabilities (legacy support in use)
[   13.614114] ehci_hcd 0000:07:00.2: port 2 high speed
[   13.614134] ehci_hcd 0000:07:00.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[   13.677227] usb 3-2: new high speed USB device using ehci_hcd and address 2
[   13.709977] eth2: (PCI Express:2.5GB/s:Width x4) 00:14:4f:3e:cb:f7
[   13.710185] eth2: Intel(R) PRO/1000 Network Connection
[   13.710383] eth2: MAC: 0, PHY: 4, PBA No: ffffff-0ff
[   13.740384] ehci_hcd 0000:07:00.2: port 2 high speed
[   13.740406] ehci_hcd 0000:07:00.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[   13.845801] usb 3-2: default language 0x0409
[   13.854775] usb 3-2: uevent
[   13.854835] usb 3-2: usb_probe_device
[   13.855026] usb 3-2: configuration #1 chosen from 1 choice
[   13.855026] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[   13.855026] usb 3-2:1.0: uevent
[   13.855026] drivers/usb/core/inode.c: creating file '002'
[   13.855026] usb 3-2: New USB device found, idVendor=0451, idProduct=625f
[   13.855026] usb 3-2: New USB device strings: Mfr=5, Product=2, SerialNumber=1
[   13.855026] usb 3-2: Product: 6250 FW: 00.00.02.22.562AD423
[   13.855026] usb 3-2: Manufacturer: Texas Instruments Incorporated
[   13.855026] usb 3-2: SerialNumber: ACCC32781924
[   13.855026] ehci_hcd 0000:07:00.2: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
[   13.855026] hub 3-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
[   13.894103] Initializing USB Mass Storage driver...
[   14.003183] hub 3-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
[   14.065026] ehci_hcd 0000:07:00.2: port 4 high speed
[   14.065048] ehci_hcd 0000:07:00.2: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
[   14.123206] usb 3-4: new high speed USB device using ehci_hcd and address 3
[   14.183154] loop: module loaded
[   14.193153] ehci_hcd 0000:07:00.2: port 4 high speed
[   14.193173] ehci_hcd 0000:07:00.2: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
[   14.286610] usb 3-4: uevent
[   14.286680] usb 3-4: usb_probe_device
[   14.286862] usb 3-4: configuration #1 chosen from 1 choice
[   14.286862] usb 3-4: adding 3-4:1.0 (config #1, interface 0)
[   14.286862] usb 3-4:1.0: uevent
[   14.286862] hub 3-4:1.0: usb_probe_interface
[   14.286862] hub 3-4:1.0: usb_probe_interface - got id
[   14.286862] hub 3-4:1.0: USB hub found
[   14.286862] hub 3-4:1.0: 4 ports detected
[   14.286862] hub 3-4:1.0: standalone hub
[   14.286862] hub 3-4:1.0: individual port power switching
[   14.286862] hub 3-4:1.0: individual port over-current protection
[   14.286862] hub 3-4:1.0: TT per port
[   14.286862] hub 3-4:1.0: TT requires at most 8 FS bit times (666 ns)
[   14.286862] hub 3-4:1.0: Port indicators are supported
[   14.286862] hub 3-4:1.0: power on to power good time: 100ms
[   14.286862] hub 3-4:1.0: local power source is good
[   14.286862] hub 3-4:1.0: enabling power on all ports
[   14.386905] usb 3-4: link qh256-0001/fffff803fb8c61e0 start 255 [1/0 us]
[   14.386944] drivers/usb/core/inode.c: creating file '003'
[   14.386976] usb 3-4: New USB device found, idVendor=04b4, idProduct=6560
[   14.386989] usb 3-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   14.387031] hub 3-4:1.0: state 7 ports 4 chg 0000 evt 0000
[   14.387099] usb-storage 3-2:1.0: usb_probe_interface
[   14.387131] usb-storage 3-2:1.0: usb_probe_interface - got id
[   14.387456] scsi1 : SCSI emulation for USB Mass Storage devices
[   14.387456] usb-storage: device found at 2
[   14.387466] usb-storage: waiting for device to settle before scanning
[   14.396862] usbcore: registered new interface driver usb-storage
[   14.396862] USB Mass Storage support registered.
[   14.398064] Adding 3084464k swap on /dev/sda4.  Priority:-1 extents:1 across:3084464k
[   14.631741] EXT3 FS on sda2, internal journal
[   14.974753] kjournald starting.  Commit interval 5 seconds
[   14.980243] EXT3 FS on sda1, internal journal
[   14.980261] EXT3-fs: mounted filesystem with ordered data mode.
[   16.217017] eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   16.878971] NET: Registered protocol family 10
[   16.882225] lo: Disabled Privacy Extensions
[   18.297197] scsi 1:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-T632A SR02 PQ: 0 ANSI: 0
[   18.297197] scsi 1:0:0:0: Attached scsi generic sg2 type 5
[   18.297997] usb-storage: device scan complete
[   18.318356] Driver 'sr' needs updating - please use bus_type methods
[   18.327228] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   18.327248] Uniform CD-ROM driver Revision: 3.20
[   18.327416] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   19.526882] eth0: no IPv6 routers present
[  110.499133] BUG: soft lockup - CPU#61 stuck for 61s! [swapper:0]
[  110.499133] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  110.499133] TPC: <cpu_idle+0xb0/0x134>
[  110.499133] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff678000 g3: 0000000000000000
[  110.499133] g4: fffff803ff647000 g5: fffff80007e4c000 g6: fffff803ff678000 g7: 0000021100004000
[  110.499133] o0: 0000000000000000 o1: fffff803ff678008 o2: 0000000000004000 o3: 0000000000000001
[  110.499133] o4: 000000bcce00a380 o5: 0000000000000012 sp: fffff803ff67b681 ret_pc: 0000000000427818
[  110.499133] RPC: <cpu_idle+0x9c/0x134>
[  110.499133] l0: 000000000000003d l1: 00000000007b95c8 l2: 000000000000003d l3: 00000000000000c8
[  110.499133] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  110.499133] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  110.499133] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff67b741 i7: 00000000006b0148
[  110.499133] I7: <after_lock_tlb+0x1a4/0x1b4>
[  110.504884] BUG: soft lockup - CPU#29 stuck for 61s! [swapper:0]
[  110.504884] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  110.504884] TPC: <cpu_idle+0xb0/0x134>
[  110.504884] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff354000 g3: 0000000000000000
[  110.504884] g4: fffff803ff350000 g5: fffff80007d4c000 g6: fffff803ff354000 g7: 0000021100004000
[  110.504884] o0: 0000000000000000 o1: fffff803ff354008 o2: 0000000000004000 o3: 0000000000000001
[  110.504884] o4: 000000bcce00a380 o5: 0000000000000012 sp: fffff803ff357681 ret_pc: 0000000000427818
[  110.504884] RPC: <cpu_idle+0x9c/0x134>
[  110.504884] l0: 000000000000001d l1: 00000000007b95c8 l2: 000000000000001d l3: 00000000000000c8
[  110.504884] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  110.504884] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  110.504884] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff357741 i7: 00000000006b0148
[  110.504884] I7: <after_lock_tlb+0x1a4/0x1b4>
[  110.504884] BUG: soft lockup - CPU#37 stuck for 62s! [dd:2413]
[  110.504884] TSTATE: 0000004411001603 TPC: 000000000045a4d8 TNPC: 000000000045a4dc Y: 00000003    Not tainted
[  110.504884] TPC: <finish_task_switch+0x2c/0xa0>
[  110.504884] g0: 0000000000000000 g1: 0000000000000000 g2: 0000000000002500 g3: fffff803f9710000
[  110.504884] g4: fffff803fcb38600 g5: fffff80007d8c000 g6: fffff803f9710000 g7: fffff803f9471200
[  110.504884] o0: fffff8000857e200 o1: 0000000000000400 o2: fffff803f96afc00 o3: 0000000000000000
[  110.504884] o4: 0000000000000fff o5: 00000000006c0c40 sp: fffff803f97134e1 ret_pc: 00000000004b1d08
[  110.504884] RPC: <do_sync_read+0x88/0xd0>
[  110.504884] l0: 0000000000000001 l1: 0000000248202c5d l2: fffff803fe8c1860 l3: 0000000000000000
[  110.504884] l4: fffff803f9169100 l5: fffff803f91690f0 l6: 0000000000000000 l7: 0000000000400000
[  110.504884] i0: 0000000000000000 i1: fffff803f9471200 i2: fffff803f9757c00 i3: fffff803f9757e80
[  110.504884] i4: 0000000000000000 i5: 0000000000000010 i6: fffff803f97135a1 i7: 00000000006b2c14
[  110.504884] I7: <schedule+0x8a4/0x914>
[  110.504884] BUG: soft lockup - CPU#45 stuck for 62s! [swapper:0]
[  110.504884] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  110.504884] TPC: <cpu_idle+0xb0/0x134>
[  110.504884] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff4f8000 g3: 0000000000000000
[  110.504884] g4: fffff803ff4bd800 g5: fffff80007dcc000 g6: fffff803ff4f8000 g7: 0000021100004000
[  110.504884] o0: 0000000000000000 o1: fffff803ff4f8008 o2: 0000000000004000 o3: 0000000000000001
[  110.504884] o4: 000000bcce00a380 o5: 0000000000000012 sp: fffff803ff4fb681 ret_pc: 0000000000427818
[  110.504884] RPC: <cpu_idle+0x9c/0x134>
[  110.504884] l0: 000000000000002d l1: 00000000007b95c8 l2: 000000000000002d l3: 00000000000000c8
[  110.504884] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  110.504884] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  110.504884] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff4fb741 i7: 00000000006b0148
[  110.504884] I7: <after_lock_tlb+0x1a4/0x1b4>
[  110.564884] BUG: soft lockup - CPU#36 stuck for 62s! [dd:2413]
[  110.564884] TSTATE: 0000000082000a00 TPC: 0000000000011cb4 TNPC: 0000000000011cb8 Y: 00000000    Not tainted
[  110.564884] TPC: <0x11cbc>
[  110.564884] g0: 0000000000000000 g1: 000000000002a400 g2: 0000000000000000 g3: 0000000000008382
[  110.564884] g4: 000000000002a234 g5: 0000000000000030 g6: 00feffffffffffff g7: 00000000f7fd17c0
[  110.564884] o0: 0000000000000001 o1: 000000000002e000 o2: 0000000000000001 o3: 0000000000000000
[  110.564884] o4: 0000000000000000 o5: 0000000000000000 sp: 00000000ffec3b68 ret_pc: 0000000000011df0
[  110.564884] RPC: <0x11df8>
[  110.564884] l0: 00000001 l1: 00000000 l2: 00000000 l3: 00000000 l4: 00000000 l5: 00000000 l6: 00000000 l7: 00000000
[  110.564884] i0: 00000000 i1: 0002e000 i2: 00000001 i3: 00000000 i4: 00000000 i5: 00008381 i6: ffec3bd8 i7: 00013fdc
[  110.700646] BUG: soft lockup - CPU#28 stuck for 64s! [make:3885]
[  110.700646] TSTATE: 0000004411001602 TPC: 00000000004fb314 TNPC: 00000000004faf6c Y: 00000000    Not tainted
[  110.700646] TPC: <ext3_readdir+0x1d8/0x5ec>
[  110.700646] g0: fffff803f57fb3c1 g1: 00000000512ef3a7 g2: 0000000083d22744 g3: 78617474722e6800
[  110.700646] g4: fffff803fcb51e00 g5: fffff80007d44000 g6: fffff803f57f8000 g7: 0000000000077903
[  110.700646] o0: fffff803fcbd6b40 o1: fffff803f57fbe78 o2: 00000000004be1a0 o3: fffff803fcb04240
[  110.700646] o4: 0000000000000000 o5: 75746f636f6e662e sp: fffff803f57fb3c1 ret_pc: 00000000004fb310
[  110.700646] RPC: <ext3_readdir+0x1d4/0x5ec>
[  110.700646] l0: fffff803f7041380 l1: 0000000206faa6d8 l2: fffff803fb0882a0 l3: fffff803fcbd6b40
[  110.700646] l4: fffff803fa09c1e0 l5: 0000000000000000 l6: fffff803f8a07af0 l7: fffff803fc86cc00
[  110.700646] i0: 0000000000000000 i1: fffff803f57fbe78 i2: 00000000004be1a0 i3: fffff803fa09c1e0
[  110.700646] i4: fffff803fa09c000 i5: bc000003fcf1a6d0 i6: fffff803f57fb501 i7: 00000000004be330
[  110.700646] I7: <vfs_readdir+0x64/0x98>
[  110.830121] BUG: soft lockup - CPU#20 stuck for 63s! [swapper:0]
[  110.830121] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  110.830121] TPC: <cpu_idle+0xb0/0x134>
[  110.830121] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff278000 g3: 0000000000000000
[  110.830121] g4: fffff803ff261800 g5: fffff80007d04000 g6: fffff803ff278000 g7: 0000021100004000
[  110.830121] o0: 0000000000000000 o1: fffff803ff278008 o2: 0000000000004000 o3: 0000000000000001
[  110.830121] o4: 000000bce244a080 o5: 0000000000000012 sp: fffff803ff27b681 ret_pc: 0000000000427818
[  110.830121] RPC: <cpu_idle+0x9c/0x134>
[  110.830121] l0: 0000000000000014 l1: 00000000007b95c8 l2: 0000000000000014 l3: 00000000000000c8
[  110.830121] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  110.830121] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  110.830121] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff27b741 i7: 00000000006b0148
[  110.830121] I7: <after_lock_tlb+0x1a4/0x1b4>
[  110.914885] BUG: soft lockup - CPU#52 stuck for 63s! [swapper:0]
[  110.914885] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  110.914885] TPC: <cpu_idle+0xb0/0x134>
[  110.914885] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff5a0000 g3: 0000000000000000
[  110.914885] g4: fffff803ff594c00 g5: fffff80007e04000 g6: fffff803ff5a0000 g7: 0000021100004000
[  110.914885] o0: 0000000000000000 o1: fffff803ff5a0008 o2: 0000000000004000 o3: 0000000000000001
[  110.914885] o4: 000000bce670be00 o5: 0000000000000012 sp: fffff803ff5a3681 ret_pc: 0000000000427818
[  110.914885] RPC: <cpu_idle+0x9c/0x134>
[  110.914885] l0: 0000000000000034 l1: 00000000007b95c8 l2: 0000000000000034 l3: 00000000000000c8
[  110.914885] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  110.914885] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  110.914885] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff5a3741 i7: 00000000006b0148
[  110.914885] I7: <after_lock_tlb+0x1a4/0x1b4>
[  110.914886] BUG: soft lockup - CPU#60 stuck for 63s! [swapper:0]
[  110.914886] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  110.914886] TPC: <cpu_idle+0xb0/0x134>
[  110.914886] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff664000 g3: 0000000000000000
[  110.914886] g4: fffff803ff645800 g5: fffff80007e44000 g6: fffff803ff664000 g7: 0000021100004000
[  110.914886] o0: 0000000000000000 o1: fffff803ff664008 o2: 0000000000004000 o3: 0000000000000001
[  110.914886] o4: 000000bce7095480 o5: 0000000000000012 sp: fffff803ff667681 ret_pc: 0000000000427818
[  110.914886] RPC: <cpu_idle+0x9c/0x134>
[  110.914886] l0: 000000000000003c l1: 00000000007b95c8 l2: 000000000000003c l3: 00000000000000c8
[  110.914886] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  110.914886] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  110.914886] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff667741 i7: 00000000006b0148
[  110.914886] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.419988] BUG: soft lockup - CPU#41 stuck for 88s! [swapper:0]
[  113.419988] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.419988] TPC: <cpu_idle+0xb0/0x134>
[  113.419988] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff474000 g3: 0000000000000000
[  113.419988] g4: fffff803ff44b000 g5: fffff80007dac000 g6: fffff803ff474000 g7: 0000021100004000
[  113.419988] o0: 0000000000000000 o1: fffff803ff474008 o2: 0000000000004000 o3: 0000000000000001
[  113.419988] o4: 000000bd7ca4e400 o5: 0000000000000012 sp: fffff803ff477681 ret_pc: 0000000000427818
[  113.419988] RPC: <cpu_idle+0x9c/0x134>
[  113.419988] l0: 0000000000000029 l1: 00000000007b95c8 l2: 0000000000000029 l3: 00000000000000c8
[  113.419988] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.419988] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.419988] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff477741 i7: 00000000006b0148
[  113.419988] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.429976] BUG: soft lockup - CPU#4 stuck for 65s! [swapper:0]
[  113.429976] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000200    Not tainted
[  113.429976] TPC: <cpu_idle+0xb0/0x134>
[  113.429976] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff0d8000 g3: 0000000000000000
[  113.429976] g4: fffff803ff0d4000 g5: fffff80007c84000 g6: fffff803ff0d8000 g7: 0000021100004000
[  113.429976] o0: 0000000000000000 o1: fffff803ff0d8008 o2: 0000000000004000 o3: 0000000000000001
[  113.429976] o4: 000000bd7d3d7a80 o5: 0000000000000012 sp: fffff803ff0db681 ret_pc: 0000000000427818
[  113.429976] RPC: <cpu_idle+0x9c/0x134>
[  113.429976] l0: 0000000000000004 l1: 00000000007b95c8 l2: 0000000000000004 l3: 00000000000000c8
[  113.429976] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.429976] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.429976] i4: 00000000fee82118 i5: 00000000fee811f8 i6: fffff803ff0db741 i7: 00000000006b0148
[  113.429976] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.429976] BUG: soft lockup - CPU#16 stuck for 88s! [swapper:0]
[  113.429976] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.429976] TPC: <cpu_idle+0xb0/0x134>
[  113.429976] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff218000 g3: 0000000000000000
[  113.429976] g4: fffff803ff1c7000 g5: fffff80007ce4000 g6: fffff803ff218000 g7: 0000021100004000
[  113.429976] o0: 0000000000000000 o1: fffff803ff218008 o2: 0000000000004000 o3: 0000000000000001
[  113.429976] o4: 000000bd7ca4e400 o5: 0000000000000012 sp: fffff803ff21b681 ret_pc: 0000000000427818
[  113.429976] RPC: <cpu_idle+0x9c/0x134>
[  113.429976] l0: 0000000000000010 l1: 00000000007b95c8 l2: 0000000000000010 l3: 00000000000000c8
[  113.429976] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.429976] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.429976] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff21b741 i7: 00000000006b0148
[  113.429976] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.429976] BUG: soft lockup - CPU#19 stuck for 88s! [swapper:0]
[  113.429976] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.429976] TPC: <cpu_idle+0xb0/0x134>
[  113.429976] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff264000 g3: 0000000000000000
[  113.429976] g4: fffff803ff260000 g5: fffff80007cfc000 g6: fffff803ff264000 g7: 0000021100004000
[  113.429976] o0: 0000000000000000 o1: fffff803ff264008 o2: 0000000000004000 o3: 0000000000000001
[  113.429976] o4: 000000bd7ca4e400 o5: 0000000000000012 sp: fffff803ff267681 ret_pc: 0000000000427818
[  113.429976] RPC: <cpu_idle+0x9c/0x134>
[  113.429976] l0: 0000000000000013 l1: 00000000007b95c8 l2: 0000000000000013 l3: 00000000000000c8
[  113.429976] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.429976] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.429976] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff267741 i7: 00000000006b0148
[  113.429976] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.429977] BUG: soft lockup - CPU#22 stuck for 88s! [swapper:0]
[  113.429977] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000508    Not tainted
[  113.429977] TPC: <cpu_idle+0xb0/0x134>
[  113.429977] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff2ac000 g3: 0000000000000000
[  113.429977] g4: fffff803ff2a0c00 g5: fffff80007d14000 g6: fffff803ff2ac000 g7: 0000021100004000
[  113.429977] o0: 0000000000000000 o1: fffff803ff2ac008 o2: 0000000000004000 o3: 0000000000000001
[  113.429977] o4: 000000bd7d3d7a80 o5: 0000000000000012 sp: fffff803ff2af681 ret_pc: 0000000000427818
[  113.429977] RPC: <cpu_idle+0x9c/0x134>
[  113.429977] l0: 0000000000000016 l1: 00000000007b95c8 l2: 0000000000000016 l3: 00000000000000c8
[  113.429977] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.429977] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.429977] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff2af741 i7: 00000000006b0148
[  113.429977] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.429977] BUG: soft lockup - CPU#23 stuck for 88s! [swapper:0]
[  113.429977] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.429977] TPC: <cpu_idle+0xb0/0x134>
[  113.429977] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff2c0000 g3: 0000000000000000
[  113.429977] g4: fffff803ff2a2400 g5: fffff80007d1c000 g6: fffff803ff2c0000 g7: 0000021100004000
[  113.429977] o0: 0000000000000000 o1: fffff803ff2c0008 o2: 0000000000004000 o3: 0000000000000001
[  113.429977] o4: 000000bd7ca4e400 o5: 0000000000000012 sp: fffff803ff2c3681 ret_pc: 0000000000427818
[  113.429977] RPC: <cpu_idle+0x9c/0x134>
[  113.429977] l0: 0000000000000017 l1: 00000000007b95c8 l2: 0000000000000017 l3: 00000000000000c8
[  113.429977] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.429977] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.429977] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff2c3741 i7: 00000000006b0148
[  113.429977] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.429976] BUG: soft lockup - CPU#17 stuck for 88s! [swapper:0]
[  113.429976] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.429976] TPC: <cpu_idle+0xb0/0x134>
[  113.429976] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff230000 g3: 0000000000000000
[  113.429976] g4: fffff803ff224c00 g5: fffff80007cec000 g6: fffff803ff230000 g7: 0000021100004000
[  113.429976] o0: 0000000000000000 o1: fffff803ff230008 o2: 0000000000004000 o3: 0000000000000001
[  113.429976] o4: 000000bd7d3d7a80 o5: 0000000000000012 sp: fffff803ff233681 ret_pc: 0000000000427818
[  113.429976] RPC: <cpu_idle+0x9c/0x134>
[  113.429976] l0: 0000000000000011 l1: 00000000007b95c8 l2: 0000000000000011 l3: 00000000000000c8
[  113.429976] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.429976] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.429976] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff233741 i7: 00000000006b0148
[  113.429976] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.429976] BUG: soft lockup - CPU#18 stuck for 88s! [gcc-4.1:4057]
[  113.429976] TSTATE: 0000000011001603 TPC: 0000000000407a24 TNPC: 0000000000407a28 Y: 00000038    Not tainted
[  113.429976] TPC: <sparc64_realfault_common+0x10/0x20>
[  113.429976] g0: fffff803fb098000 g1: 0000000070105569 g2: 0000000000000005 g3: fffff80007c64000
[  113.429976] g4: fffff803f39b4000 g5: fffff80007cf4000 g6: fffff803f39b8000 g7: 0000000000000000
[  113.429976] o0: 0000000070000000 o1: 0000000000002000 o2: 0000000000000003 o3: 0000000000000022
[  113.429976] o4: ffffffffffffffff o5: 0000000000000000 sp: fffff803f39bb6a1 ret_pc: 00000000700ffdb0
[  113.429976] RPC: <0x700ffdb8>
[  113.429976] l0: 0000000000009000 l1: 0000000000090000 l2: 0000000000407a24 l3: 00000000fff285e8
[  113.429976] l4: 0000000000000002 l5: 0000000070000000 l6: fffff803f39b8000 l7: 0000000011009003
[  113.429976] i0: 000000000000003c i1: 0000000070107210 i2: 00000000701055a8 i3: ffffffffffffffc4
[  113.429976] i4: 0000000070105568 i5: 0000000000000000 i6: 00000000fff28618 i7: 00000000700f1d20
[  113.429976] I7: <0x700f1d28>
[  113.429977] BUG: soft lockup - CPU#26 stuck for 88s! [make:4060]
[  113.429977] TSTATE: 0000004480001605 TPC: 00000000004ae90c TNPC: 00000000004ae910 Y: 00000000    Not tainted
[  113.429977] TPC: <kmem_cache_alloc+0x78/0x9c>
[  113.429977] g0: 0000000000000000 g1: 0000000000000000 g2: 0000000206f616f0 g3: fffff803fa564000
[  113.429977] g4: fffff803f70dd800 g5: fffff80007d34000 g6: fffff803f39f4000 g7: 00e0000000000080
[  113.429977] o0: fffff803fa564000 o1: 00000000000000d0 o2: ffffffffffffffff o3: 00000000004a1af8
[  113.429977] o4: fffff800085252d8 o5: 00000000700641a4 sp: fffff803f39f6f91 ret_pc: 00000000004ae8d4
[  113.429977] RPC: <kmem_cache_alloc+0x40/0x9c>
[  113.429977] l0: fffff800085252d8 l1: 0000000000000000 l2: 0000000000843400 l3: fffff803ff30bb70
[  113.429977] l4: 0000000000015dfd l5: 0000000000004101 l6: 0000000000000000 l7: 00000000000015ab
[  113.429977] i0: fffff803ff008000 i1: 00000000000000d0 i2: 000000003b9aca00 i3: fffffffffd1dc000
[  113.429977] i4: 0000000000000000 i5: 00000000007ae800 i6: fffff803f39f7051 i7: 00000000004a1af8
[  113.429977] I7: <anon_vma_prepare+0x50/0xd4>
[  113.429977] BUG: soft lockup - CPU#25 stuck for 88s! [swapper:0]
[  113.429977] TSTATE: 0000004411001603 TPC: 000000000045a4d8 TNPC: 000000000045a4dc Y: 00000000    Not tainted
[  113.429977] TPC: <finish_task_switch+0x2c/0xa0>
[  113.429977] g0: 0000000000000000 g1: 0000000000000000 g2: 0000000000001900 g3: fffff803ff2f4000
[  113.429977] g4: fffff803ff2dd800 g5: fffff80007d2c000 g6: fffff803ff2f4000 g7: fffff803ff2dc600
[  113.429977] o0: fffff8000851e200 o1: 0000000000000000 o2: 0000000000000001 o3: 00000000007b9400
[  113.429977] o4: fffff803f70dd800 o5: 0000000000000003 sp: fffff803ff2f74c1 ret_pc: 000000000045770c
[  113.429977] RPC: <dequeue_task_rt+0x18/0x50>
[  113.429977] l0: 0000000000000001 l1: 0000000000000000 l2: fffff803ff2dc600 l3: fffff803fe8ba8b8
[  113.429977] l4: fffff803fe218e00 l5: 0000000000000000 l6: 0000000000000019 l7: 0000000000000000
[  113.429977] i0: fffff803fe218e00 i1: fffff803ff2dc600 i2: 0000000000000019 i3: fffff803fb9e8540
[  113.429977] i4: 000000004ce3d84e i5: 0000000000000000 i6: fffff803ff2f7581 i7: 00000000006b2c14
[  113.429977] I7: <schedule+0x8a4/0x914>
[  113.439976] BUG: soft lockup - CPU#6 stuck for 88s! [swapper:0]
[  113.439976] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.439976] TPC: <cpu_idle+0xb0/0x134>
[  113.439976] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff108000 g3: 0000000000000000
[  113.439976] g4: fffff803ff0d7000 g5: fffff80007c94000 g6: fffff803ff108000 g7: 0000021100004000
[  113.439976] o0: 0000000000000000 o1: fffff803ff108008 o2: 0000000000004000 o3: 0000000000000001
[  113.439976] o4: 000000bd7d3d7a80 o5: 0000000000000012 sp: fffff803ff10b681 ret_pc: 0000000000427818
[  113.439976] RPC: <cpu_idle+0x9c/0x134>
[  113.439976] l0: 0000000000000006 l1: 00000000007b95c8 l2: 0000000000000006 l3: 00000000000000c8
[  113.439976] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.439976] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.439976] i4: 00000000fee81d18 i5: 00000000fee80df8 i6: fffff803ff10b741 i7: 00000000006b0148
[  113.439976] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.439976] BUG: soft lockup - CPU#7 stuck for 88s! [swapper:0]
[  113.439976] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.439976] TPC: <cpu_idle+0xb0/0x134>
[  113.439976] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff120000 g3: 0000000000000000
[  113.439976] g4: fffff803ff114c00 g5: fffff80007c9c000 g6: fffff803ff120000 g7: 0000021100004000
[  113.439976] o0: 0000000000000000 o1: fffff803ff120008 o2: 0000000000004000 o3: 0000000000000001
[  113.439976] o4: 000000bd7d3d7a80 o5: 0000000000000012 sp: fffff803ff123681 ret_pc: 0000000000427818
[  113.439976] RPC: <cpu_idle+0x9c/0x134>
[  113.439976] l0: 0000000000000007 l1: 00000000007b95c8 l2: 0000000000000007 l3: 00000000000000c8
[  113.439976] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.439976] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.439976] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff123741 i7: 00000000006b0148
[  113.439976] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.439976] BUG: soft lockup - CPU#10 stuck for 88s! [swapper:0]
[  113.439976] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00001862    Not tainted
[  113.439976] TPC: <cpu_idle+0xb0/0x134>
[  113.439976] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff168000 g3: 0000000000000000
[  113.439976] g4: fffff803ff151800 g5: fffff80007cb4000 g6: fffff803ff168000 g7: 0000021100004000
[  113.439976] o0: 0000000000000000 o1: fffff803ff168008 o2: 0000000000004000 o3: 0000000000000001
[  113.439976] o4: 000000bd7d3d7a80 o5: 0000000000000012 sp: fffff803ff16b681 ret_pc: 0000000000427818
[  113.439976] RPC: <cpu_idle+0x9c/0x134>
[  113.439976] l0: 000000000000000a l1: 00000000007b95c8 l2: 000000000000000a l3: 00000000000000c8
[  113.439976] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.439976] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.439976] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff16b741 i7: 00000000006b0148
[  113.439976] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.439976] BUG: soft lockup - CPU#15 stuck for 88s! [swapper:0]
[  113.439976] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.439976] TPC: <cpu_idle+0xb0/0x134>
[  113.439976] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff204000 g3: 0000000000000000
[  113.439976] g4: fffff803ff1c5800 g5: fffff80007cdc000 g6: fffff803ff204000 g7: 0000021100004000
[  113.439976] o0: 0000000000000000 o1: fffff803ff204008 o2: 0000000000004000 o3: 0000000000000001
[  113.439976] o4: 000000bd7d3d7a80 o5: 0000000000000012 sp: fffff803ff207681 ret_pc: 0000000000427818
[  113.439976] RPC: <cpu_idle+0x9c/0x134>
[  113.439976] l0: 000000000000000f l1: 00000000007b95c8 l2: 000000000000000f l3: 00000000000000c8
[  113.439976] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.439976] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.439976] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff207741 i7: 00000000006b0148
[  113.439976] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.439976] BUG: soft lockup - CPU#9 stuck for 88s! [swapper:0]
[  113.439976] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.439976] TPC: <cpu_idle+0xb0/0x134>
[  113.439976] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff154000 g3: 0000000000000000
[  113.439976] g4: fffff803ff150000 g5: fffff80007cac000 g6: fffff803ff154000 g7: 0000021100004000
[  113.439976] o0: 0000000000000000 o1: fffff803ff154008 o2: 0000000000004000 o3: 0000000000000001
[  113.439976] o4: 000000bd7d3d7a80 o5: 0000000000000012 sp: fffff803ff157681 ret_pc: 0000000000427818
[  113.439976] RPC: <cpu_idle+0x9c/0x134>
[  113.439976] l0: 0000000000000009 l1: 00000000007b95c8 l2: 0000000000000009 l3: 00000000000000c8
[  113.439976] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.439976] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.439976] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff157741 i7: 00000000006b0148
[  113.439976] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.439976] BUG: soft lockup - CPU#14 stuck for 88s! [swapper:0]
[  113.439976] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.439976] TPC: <cpu_idle+0xb0/0x134>
[  113.439976] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff1c8000 g3: 0000000000000000
[  113.439976] g4: fffff803ff1c4000 g5: fffff80007cd4000 g6: fffff803ff1c8000 g7: 0000021100004000
[  113.439976] o0: 0000000000000000 o1: fffff803ff1c8008 o2: 0000000000004000 o3: 0000000000000001
[  113.439976] o4: 000000bd7d3d7a80 o5: 0000000000000012 sp: fffff803ff1cb681 ret_pc: 0000000000427818
[  113.439976] RPC: <cpu_idle+0x9c/0x134>
[  113.439976] l0: 000000000000000e l1: 00000000007b95c8 l2: 000000000000000e l3: 00000000000000c8
[  113.439976] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.439976] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.439976] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff1cb741 i7: 00000000006b0148
[  113.439976] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.452512] BUG: soft lockup - CPU#42 stuck for 88s! [as:4070]
[  113.452512] TSTATE: 0000004411001603 TPC: 0000000000493f14 TNPC: 0000000000493f18 Y: 00000000    Not tainted
[  113.452512] TPC: <lru_cache_add_active+0xc/0x70>
[  113.452512] g0: fffff803ff0149a0 g1: 000000000000001d g2: 0000000000fce9b0 g3: 0000000206ea63d0
[  113.452512] g4: fffff803fc9f2a00 g5: fffff80007db4000 g6: fffff803f3ad0000 g7: 000000000000001d
[  113.452512] o0: 0000000206f52848 o1: 0000000000000000 o2: 000000000078d228 o3: 0000000000000044
[  113.452512] o4: 0000000000000000 o5: 0000000000000000 sp: fffff803f3ad3441 ret_pc: 000000000049089c
[  113.452512] RPC: <__alloc_pages+0x54/0x33c>
[  113.452512] l0: fffff803fb4d61c0 l1: 0000000000000070 l2: fffff803fc9f2a00 l3: fffff803fb825ed8
[  113.452512] l4: 0000000206f52848 l5: fffff803fb4d4000 l6: 0000000000000010 l7: 00000000001200d2
[  113.452512] i0: 0000000206f52848 i1: fffff803fb4d4098 i2: 0000000000000001 i3: 0000000000000000
[  113.452512] i4: 6573000000000000 i5: 000000ffffffffff i6: fffff803f3ad3501 i7: 000000000049ac50
[  113.452512] I7: <handle_mm_fault+0x2cc/0x7c0>
[  113.452512] BUG: soft lockup - CPU#48 stuck for 88s! [swapper:0]
[  113.452512] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.452512] TPC: <cpu_idle+0xb0/0x134>
[  113.452512] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff540000 g3: 0000000000000000
[  113.452512] g4: fffff803ff51a400 g5: fffff80007de4000 g6: fffff803ff540000 g7: 0000021100004000
[  113.452512] o0: 0000000000000000 o1: fffff803ff540008 o2: 0000000000004000 o3: 0000000000000001
[  113.452512] o4: 000000bd7dd61100 o5: 0000000000000012 sp: fffff803ff543681 ret_pc: 0000000000427818
[  113.452512] RPC: <cpu_idle+0x9c/0x134>
[  113.452512] l0: 0000000000000030 l1: 00000000007b95c8 l2: 0000000000000030 l3: 00000000000000c8
[  113.452512] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.452512] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.452512] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff543741 i7: 00000000006b0148
[  113.452512] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.452512] BUG: soft lockup - CPU#50 stuck for 88s! [swapper:0]
[  113.452512] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.452512] TPC: <cpu_idle+0xb0/0x134>
[  113.452512] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff56c000 g3: 0000000000000000
[  113.452512] g4: fffff803ff555800 g5: fffff80007df4000 g6: fffff803ff56c000 g7: 0000021100004000
[  113.452512] o0: 0000000000000000 o1: fffff803ff56c008 o2: 0000000000004000 o3: 0000000000000001
[  113.452512] o4: 000000bd7dd61100 o5: 0000000000000012 sp: fffff803ff56f681 ret_pc: 0000000000427818
[  113.452512] RPC: <cpu_idle+0x9c/0x134>
[  113.452512] l0: 0000000000000032 l1: 00000000007b95c8 l2: 0000000000000032 l3: 00000000000000c8
[  113.452512] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.452512] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.452512] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff56f741 i7: 00000000006b0148
[  113.452512] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.452512] BUG: soft lockup - CPU#49 stuck for 88s! [swapper:0]
[  113.452512] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00001a58    Not tainted
[  113.452512] TPC: <cpu_idle+0xb0/0x134>
[  113.452512] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff558000 g3: 0000000000000000
[  113.452512] g4: fffff803ff554000 g5: fffff80007dec000 g6: fffff803ff558000 g7: 0000021100004000
[  113.452512] o0: 0000000000000000 o1: fffff803ff558008 o2: 0000000000004000 o3: 0000000000000001
[  113.452512] o4: 000000bd7e6ea780 o5: 0000000000000012 sp: fffff803ff55b681 ret_pc: 0000000000427818
[  113.452512] RPC: <cpu_idle+0x9c/0x134>
[  113.452512] l0: 0000000000000031 l1: 00000000007b95c8 l2: 0000000000000031 l3: 00000000000000c8
[  113.452512] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.452512] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.452512] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff55b741 i7: 00000000006b0148
[  113.452512] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.452512] BUG: soft lockup - CPU#51 stuck for 88s! [swapper:0]
[  113.452512] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.452512] TPC: <cpu_idle+0xb0/0x134>
[  113.452512] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff588000 g3: 0000000000000000
[  113.452512] g4: fffff803ff557000 g5: fffff80007dfc000 g6: fffff803ff588000 g7: 0000021100004000
[  113.452512] o0: 0000000000000000 o1: fffff803ff588008 o2: 0000000000004000 o3: 0000000000000001
[  113.452512] o4: 000000bd7e6ea780 o5: 0000000000000012 sp: fffff803ff58b681 ret_pc: 0000000000427818
[  113.452512] RPC: <cpu_idle+0x9c/0x134>
[  113.452512] l0: 0000000000000033 l1: 00000000007b95c8 l2: 0000000000000033 l3: 00000000000000c8
[  113.452512] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.452512] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.452512] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff58b741 i7: 00000000006b0148
[  113.452512] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.463144] BUG: soft lockup - CPU#40 stuck for 88s! [swapper:0]
[  113.463144] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.463144] TPC: <cpu_idle+0xb0/0x134>
[  113.463144] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff460000 g3: 0000000000000000
[  113.463144] g4: fffff803ff449800 g5: fffff80007da4000 g6: fffff803ff460000 g7: 0000021100004000
[  113.463144] o0: 0000000000000000 o1: fffff803ff460008 o2: 0000000000004000 o3: 0000000000000001
[  113.463144] o4: 000000bd7f073e00 o5: 0000000000000012 sp: fffff803ff463681 ret_pc: 0000000000427818
[  113.463144] RPC: <cpu_idle+0x9c/0x134>
[  113.463144] l0: 0000000000000028 l1: 00000000007b95c8 l2: 0000000000000028 l3: 00000000000000c8
[  113.463144] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.463144] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.463144] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff463741 i7: 00000000006b0148
[  113.463144] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.509977] BUG: soft lockup - CPU#8 stuck for 73s! [klogd:2416]
[  113.509977] TSTATE: 0000004482000a07 TPC: 00000000f7e6ea0c TNPC: 00000000f7e6ea10 Y: 00000024    Not tainted
[  113.509977] TPC: <0xf7e6ea14>
[  113.509977] g0: 0000000000000000 g1: 0000000000000008 g2: 0000000000000020 g3: 0000000000000004
[  113.509977] g4: 00000000f7f77a48 g5: 5044540050535400 g6: 00000000feffffff g7: 00000000f7fdc6b0
[  113.509977] o0: 00000000f7fa1c20 o1: 00000000f7f78549 o2: 0000000000000001 o3: 0000000000000000
[  113.509977] o4: 0000000000000000 o5: 0000000000000000 sp: 00000000ff8cc600 ret_pc: 00000000f7e6e8ec
[  113.509977] RPC: <0xf7e6e8f4>
[  113.509977] l0: 00000001 l1: ff8ccd08 l2: 00000000 l3: 00000000 l4: 00000000 l5: 00000000 l6: 00000000 l7: f7f9f000
[  113.509977] i0: 0000002e i1: ff8ccba4 i2: 0000000a i3: cccccccd i4: 00000000 i5: 00000002 i6: ff8cc670 i7: f7e730f8
[  113.763153] BUG: soft lockup - CPU#38 stuck for 88s! [dd:2413]
[  113.763153] TSTATE: 0000004411001606 TPC: 0000000000460a70 TNPC: 0000000000460a74 Y: 00000000    Not tainted
[  113.763153] TPC: <do_syslog+0x1d8/0x40c>
[  113.763153] g0: 0000000000000001 g1: 0000000000800758 g2: 0000000000000001 g3: 000000000000f8b6
[  113.763153] g4: fffff803fcb38600 g5: fffff80007d94000 g6: fffff803f9710000 g7: 000000000000f8b6
[  113.763153] o0: 0000000000000000 o1: 0000000000000001 o2: 0000000000000000 o3: 0000000000000000
[  113.763153] o4: 000000000002c038 o5: 0000000000800800 sp: fffff803f97132a1 ret_pc: 0000000000460a10
[  113.763153] RPC: <do_syslog+0x178/0x40c>
[  113.763153] l0: 0000000000800758 l1: 0000000000000000 l2: 0000000000000001 l3: 0000000000000026
[  113.763153] l4: 000000000000000f l5: 00000000007b9400 l6: 0000000000000001 l7: fffff803fa343a9c
[  113.763153] i0: 0000000000000001 i1: 000000000002e001 i2: 0000000000000001 i3: 0000000000000001
[  113.763153] i4: 0000000000000001 i5: 000000000002e000 i6: fffff803f9713391 i7: 00000000004f400c
[  113.763153] I7: <kmsg_read+0x44/0x50>
[  113.850652] BUG: soft lockup - CPU#46 stuck for 89s! [swapper:0]
[  113.850652] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  113.850652] TPC: <cpu_idle+0xb0/0x134>
[  113.850652] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff50c000 g3: 0000000000000000
[  113.850652] g4: fffff803ff4bf000 g5: fffff80007dd4000 g6: fffff803ff50c000 g7: 0000021100004000
[  113.850652] o0: 0000000000000000 o1: fffff803ff50c008 o2: 0000000000004000 o3: 0000000000000001
[  113.850652] o4: 000000bd9514fe80 o5: 0000000000000012 sp: fffff803ff50f681 ret_pc: 0000000000427818
[  113.850652] RPC: <cpu_idle+0x9c/0x134>
[  113.850652] l0: 000000000000002e l1: 00000000007b95c8 l2: 000000000000002e l3: 00000000000000c8
[  113.850652] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.850652] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.850652] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff50f741 i7: 00000000006b0148
[  113.850652] I7: <after_lock_tlb+0x1a4/0x1b4>
[  113.850652] BUG: soft lockup - CPU#47 stuck for 89s! [swapper:0]
[  113.850652] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000400    Not tainted
[  113.850652] TPC: <cpu_idle+0xb0/0x134>
[  113.850652] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff524000 g3: 0000000000000000
[  113.850652] g4: fffff803ff518c00 g5: fffff80007ddc000 g6: fffff803ff524000 g7: 0000021100004000
[  113.850652] o0: 0000000000000000 o1: fffff803ff524008 o2: 0000000000004000 o3: 0000000000000001
[  113.850652] o4: 000000bd95ad9500 o5: 0000000000000012 sp: fffff803ff527681 ret_pc: 0000000000427818
[  113.850652] RPC: <cpu_idle+0x9c/0x134>
[  113.850652] l0: 000000000000002f l1: 00000000007b95c8 l2: 000000000000002f l3: 00000000000000c8
[  113.850652] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  113.850652] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  113.850652] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff527741 i7: 00000000006b0148
[  113.850652] I7: <after_lock_tlb+0x1a4/0x1b4>
[  114.041358] BUG: soft lockup - CPU#57 stuck for 89s! [collect2:4095]
[  114.041358] TSTATE: 0000000011001604 TPC: 000000000048a20c TNPC: 000000000048a210 Y: 00000038    Not tainted
[  114.041358] TPC: <page_waitqueue+0xc/0x88>
[  114.041358] g0: fffff803f3c48000 g1: 000000000001006d g2: 0000000000000001 g3: 000000000001006c
[  114.041358] g4: fffff803f3aac000 g5: fffff80007e2c000 g6: fffff803f3c3c000 g7: 000000000001006d
[  114.041358] o0: 00000002000e72d8 o1: 00000002000e72d8 o2: 0000000000000001 o3: 0000000000000001
[  114.041358] o4: 0000000000000000 o5: 0000000000000016 sp: fffff803f3c3f351 ret_pc: 000000000048adb0
[  114.041358] RPC: <unlock_page+0x4c/0x58>
[  114.041358] l0: fffff8000861ce98 l1: 00000002000e72d8 l2: 000000007010cc40 l3: fffff803fb9d6b40
[  114.041358] l4: fffff803fe819918 l5: fffff803fb9d6ba8 l6: 0000000000000010 l7: 0000000000000000
[  114.041358] i0: 00000002000e72d8 i1: 00000002000e72d8 i2: 0000000000000000 i3: 0000000000000000
[  114.041358] i4: 0000000000000000 i5: fffff803fe819808 i6: fffff803f3c3f411 i7: 000000000049927c
[  114.041358] I7: <__do_fault+0x434/0x488>
[  114.061812] BUG: soft lockup - CPU#62 stuck for 89s! [ld:4096]
[  114.061812] TSTATE: 0000004482000a05 TPC: 000000007003b75c TNPC: 000000007003b760 Y: 00000000    Not tainted
[  114.061812] TPC: <0x7003b764>
[  114.061812] g0: 0000000000000000 g1: 0101010101010101 g2: 8080808080808080 g3: 0000000041425e31
[  114.061812] g4: 000000000009c228 g5: 00000000000e10d3 g6: 00000000000000fe g7: 0000000070002040
[  114.061812] o0: 00000000000e0fd8 o1: 00000000000e0fb0 o2: 0000000000000001 o3: 0000000000000000
[  114.061812] o4: 0000000000000000 o5: 0000000000000fd3 sp: 00000000ffb7c148 ret_pc: 000000007003b754
[  114.061812] RPC: <0x7003b75c>
[  114.061812] l0: 20a0face l1: 00000026 l2: 0008d7b0 l3: 0009af98 l4: 00000000 l5: 00000000 l6: 00000000 l7: 700c9878
[  114.061812] i0: 0009af98 i1: 000e0fb0 i2: 00000001 i3: 00000000 i4: 00000000 i5: 00000000 i6: ffb7c1b8 i7: 7003d754
[  114.102196] BUG: soft lockup - CPU#24 stuck for 89s! [cc1:4062]
[  114.102196] TSTATE: 0000009982001a00 TPC: 000000000010ab1c TNPC: 000000000010ab20 Y: 00000000    Not tainted
[  114.102196] TPC: <0x10ab24>
[  114.102196] g0: 0000000000000000 g1: 0000000000000000 g2: 000000000010abe8 g3: 000000000000006c
[  114.102196] g4: 000000000000001b g5: 00000000ffa82310 g6: 00000000ffa825d3 g7: 0000000070001d00
[  114.102196] o0: 0000000000000000 o1: 000000000047d7e8 o2: 0000000070602190 o3: 0000000000000001
[  114.102196] o4: 00000000002d0000 o5: 00000000706020e0 sp: 00000000ffa825f0 ret_pc: 000000000010ab8c
[  114.102196] RPC: <0x10ab94>
[  114.102196] l0: 00050000 l1: 00000014 l2: 00000050 l3: ffffffff l4: 003ed4ff l5: fffffffc l6: 70602ae4 l7: 00432800
[  114.102196] i0: 705ff0b0 i1: 0047d7e8 i2: 00000000 i3: 00000001 i4: 00000001 i5: 00000e40 i6: ffa82660 i7: 0010aee0
[  114.161358] BUG: soft lockup - CPU#58 stuck for 89s! [fixdep:4097]
[  114.161358] TSTATE: 00000000f0000a07 TPC: 0000000000010cb0 TNPC: 0000000000010cb4 Y: 00000000    Not tainted
[  114.161358] TPC: <0x10cb8>
[  114.161358] g0: 0000000000000000 g1: 0000000066756e63 g2: 0000000046494400 g3: 0000000000000000
[  114.161358] g4: 00000000005e50e2 g5: 00672e680065732e g6: 00feffffffffffff g7: 0000000070001cf0
[  114.161358] o0: 0000000000000000 o1: 0000000000000000 o2: 0000000000000000 o3: 0000000000000000
[  114.161358] o4: 0000000000000000 o5: 0000000000000000 sp: 00000000ffd939d0 ret_pc: 0000000000000000
[  114.161358] RPC: <0x8>
[  114.161358] l0: 00000000 l1: 700364fa l2: 00000000 l3: 00000000 l4: 434f4e46 l5: 4f4e4649 l6: 4e464947 l7: 4649475f
[  114.161358] i0: 70036500 i1: 700376c3 i2: 00000001 i3: 00000002 i4: 00000004 i5: 00000000 i6: ffd93a40 i7: 00010e14
[  114.187311] BUG: soft lockup - CPU#63 stuck for 89s! [swapper:0]
[  114.187311] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  114.187311] TPC: <cpu_idle+0xb0/0x134>
[  114.187311] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff6ac000 g3: 0000000000000000
[  114.187311] g4: fffff803ff686400 g5: fffff80007e5c000 g6: fffff803ff6ac000 g7: 0000021100004000
[  114.187311] o0: 0000000000000000 o1: fffff803ff6ac008 o2: 0000000000004000 o3: 0000000000000001
[  114.187311] o4: 000000bda8c06500 o5: 0000000000000012 sp: fffff803ff6af681 ret_pc: 0000000000427818
[  114.187311] RPC: <cpu_idle+0x9c/0x134>
[  114.187311] l0: 000000000000003f l1: 00000000007b95c8 l2: 000000000000003f l3: 00000000000000c8
[  114.187311] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  114.187311] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  114.187311] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff6af741 i7: 00000000006b0148
[  114.187311] I7: <after_lock_tlb+0x1a4/0x1b4>
[  114.556919] BUG: soft lockup - CPU#33 stuck for 89s! [swapper:0]
[  114.556919] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  114.556919] TPC: <cpu_idle+0xb0/0x134>
[  114.556919] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff3b8000 g3: 0000000000000000
[  114.556919] g4: fffff803ff392400 g5: fffff80007d6c000 g6: fffff803ff3b8000 g7: 0000021100004000
[  114.556919] o0: 0000000000000000 o1: fffff803ff3b8008 o2: 0000000000004000 o3: 0000000000000001
[  114.556919] o4: 000000bdbece2580 o5: 0000000000000012 sp: fffff803ff3bb681 ret_pc: 0000000000427818
[  114.556919] RPC: <cpu_idle+0x9c/0x134>
[  114.556919] l0: 0000000000000021 l1: 00000000007b95c8 l2: 0000000000000021 l3: 00000000000000c8
[  114.556919] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  114.556919] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  114.556919] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff3bb741 i7: 00000000006b0148
[  114.556919] I7: <after_lock_tlb+0x1a4/0x1b4>
[  114.556919] BUG: soft lockup - CPU#34 stuck for 89s! [as:4105]
[  114.556919] TSTATE: 0000000082000a02 TPC: 0000000000012e88 TNPC: 0000000000012e8c Y: 00000000    Not tainted
[  114.556919] TPC: <0x12e90>
[  114.556919] g0: 0000000000000000 g1: 0000000000000063 g2: 0000000000000002 g3: 0000000000073442
[  114.556919] g4: 000000000006d548 g5: 000000000007ab41 g6: 00feffffffffffff g7: 0000000070002340
[  114.556919] o0: 000000000007ab41 o1: 000000000006de58 o2: 0000000000000000 o3: 000000000000ccec
[  114.556919] o4: 0223232323232323 o5: 1ffefefefefefeff sp: 00000000ff9e6a78 ret_pc: 0000000000012e70
[  114.556919] RPC: <0x12e78>
[  114.556919] l0: 00000073 l1: 0007ab41 l2: 00073442 l3: 000823e1 l4: 0006d400 l5: 000206b8 l6: 0006d400 l7: 0006d400
[  114.556919] i0: 0007ab44 i1: 0007a3e1 i2: 0006de58 i3: 000963f0 i4: 0006de55 i5: 00000003 i6: ff9e6ae8 i7: 00020794
[  114.677640] BUG: soft lockup - CPU#56 stuck for 89s! [mv:4114]
[  114.677640] TSTATE: 0000000011001604 TPC: 00000000004c6fa4 TNPC: 00000000004c6fa8 Y: 00000000    Not tainted
[  114.677640] TPC: <get_filesystem_list+0x30/0xb0>
[  114.677640] g0: 00000000700011b0 g1: 0000000000000000 g2: 0000000000000001 g3: 0000000000000001
[  114.677640] g4: fffff803f3d38c00 g5: fffff80007e24000 g6: fffff803f38f8000 g7: ffffffffffffffff
[  114.677640] o0: fffff803fe8e6019 o1: 0000000000726fb0 o2: 0000000000748718 o3: 00000000007270a0
[  114.677640] o4: 0000000000000000 o5: 0000000000000000 sp: fffff803f38fb201 ret_pc: 00000000004c6fb4
[  114.677640] RPC: <get_filesystem_list+0x40/0xb0>
[  114.677640] l0: 000000000078e228 l1: fffff803fe8e6000 l2: fffff803f3d38c00 l3: 0000000000000000
[  114.677640] l4: 0000000206fd7928 l5: 0000000000000000 l6: 0000000000000010 l7: 00000000000a00d0
[  114.677640] i0: 0000000000000019 i1: 0000000000000000 i2: 000000000078d200 i3: 0000000000000001
[  114.677640] i4: 0000000000100073 i5: 0000000000000000 i6: fffff803f38fb2c1 i7: 00000000004f22d4
[  114.677640] I7: <filesystems_read_proc+0x10/0x20>
[  114.677640] BUG: soft lockup - CPU#59 stuck for 89s! [swapper:0]
[  114.677640] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  114.677640] TPC: <cpu_idle+0xb0/0x134>
[  114.677640] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff648000 g3: 0000000000000000
[  114.677640] g4: fffff803ff644000 g5: fffff80007e3c000 g6: fffff803ff648000 g7: 0000021100004000
[  114.677640] o0: 0000000000000000 o1: fffff803ff648008 o2: 0000000000004000 o3: 0000000000000001
[  114.677640] o4: 000000bdc68dca00 o5: 0000000000000012 sp: fffff803ff64b681 ret_pc: 0000000000427818
[  114.677640] RPC: <cpu_idle+0x9c/0x134>
[  114.677640] l0: 000000000000003b l1: 00000000007b95c8 l2: 000000000000003b l3: 00000000000000c8
[  114.677640] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  114.677640] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  114.677640] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff64b741 i7: 00000000006b0148
[  114.677640] I7: <after_lock_tlb+0x1a4/0x1b4>
[  114.685243] BUG: soft lockup - CPU#32 stuck for 89s! [swapper:0]
[  114.685243] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  114.685243] TPC: <cpu_idle+0xb0/0x134>
[  114.685243] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff39c000 g3: 0000000000000000
[  114.685243] g4: fffff803ff390c00 g5: fffff80007d64000 g6: fffff803ff39c000 g7: 0000021100004000
[  114.685243] o0: 0000000000000000 o1: fffff803ff39c008 o2: 0000000000004000 o3: 0000000000000001
[  114.685243] o4: 000000bdc7266080 o5: 0000000000000012 sp: fffff803ff39f681 ret_pc: 0000000000427818
[  114.685243] RPC: <cpu_idle+0x9c/0x134>
[  114.685243] l0: 0000000000000020 l1: 00000000007b95c8 l2: 0000000000000020 l3: 00000000000000c8
[  114.685243] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  114.685243] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  114.685243] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff39f741 i7: 00000000006b0148
[  114.685243] I7: <after_lock_tlb+0x1a4/0x1b4>
[  114.685243] BUG: soft lockup - CPU#35 stuck for 89s! [swapper:0]
[  114.685243] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  114.685243] TPC: <cpu_idle+0xb0/0x134>
[  114.685243] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff3e4000 g3: 0000000000000000
[  114.685243] g4: fffff803ff3cd800 g5: fffff80007d7c000 g6: fffff803ff3e4000 g7: 0000021100004000
[  114.685243] o0: 0000000000000000 o1: fffff803ff3e4008 o2: 0000000000004000 o3: 0000000000000001
[  114.685243] o4: 000000bdc68dca00 o5: 0000000000000012 sp: fffff803ff3e7681 ret_pc: 0000000000427818
[  114.685243] RPC: <cpu_idle+0x9c/0x134>
[  114.685243] l0: 0000000000000023 l1: 00000000007b95c8 l2: 0000000000000023 l3: 00000000000000c8
[  114.685243] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  114.685243] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  114.685243] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff3e7741 i7: 00000000006b0148
[  114.685243] I7: <after_lock_tlb+0x1a4/0x1b4>
[  117.093721] BUG: soft lockup - CPU#30 stuck for 92s! [swapper:0]
[  117.093721] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  117.093721] TPC: <cpu_idle+0xb0/0x134>
[  117.093721] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff370000 g3: 0000000000000000
[  117.093721] g4: fffff803ff351800 g5: fffff80007d54000 g6: fffff803ff370000 g7: 0000021100004000
[  117.093721] o0: 0000000000000000 o1: fffff803ff370008 o2: 0000000000004000 o3: 0000000000000001
[  117.093721] o4: 000000be559ae200 o5: 0000000000000012 sp: fffff803ff373681 ret_pc: 0000000000427818
[  117.093721] RPC: <cpu_idle+0x9c/0x134>
[  117.093721] l0: 000000000000001e l1: 00000000007b95c8 l2: 000000000000001e l3: 00000000000000c8
[  117.093721] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  117.093721] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  117.093721] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff373741 i7: 00000000006b0148
[  117.093721] I7: <after_lock_tlb+0x1a4/0x1b4>
[  117.093721] BUG: soft lockup - CPU#31 stuck for 92s! [swapper:0]
[  117.093721] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  117.093721] TPC: <cpu_idle+0xb0/0x134>
[  117.093721] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff384000 g3: 0000000000000000
[  117.093721] g4: fffff803ff353000 g5: fffff80007d5c000 g6: fffff803ff384000 g7: 0000021100004000
[  117.093721] o0: 0000000000000000 o1: fffff803ff384008 o2: 0000000000004000 o3: 0000000000000001
[  117.093721] o4: 000000be559ae200 o5: 0000000000000012 sp: fffff803ff387681 ret_pc: 0000000000427818
[  117.093721] RPC: <cpu_idle+0x9c/0x134>
[  117.093721] l0: 000000000000001f l1: 00000000007b95c8 l2: 000000000000001f l3: 00000000000000c8
[  117.093721] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  117.093721] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  117.093721] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff387741 i7: 00000000006b0148
[  117.093721] I7: <after_lock_tlb+0x1a4/0x1b4>
[  117.097927] BUG: soft lockup - CPU#54 stuck for 92s! [swapper:0]
[  117.097927] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  117.097927] TPC: <cpu_idle+0xb0/0x134>
[  117.097927] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff5d4000 g3: 0000000000000000
[  117.097927] g4: fffff803ff5d0000 g5: fffff80007e14000 g6: fffff803ff5d4000 g7: 0000021100004000
[  117.097927] o0: 0000000000000000 o1: fffff803ff5d4008 o2: 0000000000004000 o3: 0000000000000001
[  117.097927] o4: 000000be56337880 o5: 0000000000000012 sp: fffff803ff5d7681 ret_pc: 0000000000427818
[  117.097927] RPC: <cpu_idle+0x9c/0x134>
[  117.097927] l0: 0000000000000036 l1: 00000000007b95c8 l2: 0000000000000036 l3: 00000000000000c8
[  117.097927] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  117.097927] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  117.097927] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff5d7741 i7: 00000000006b0148
[  117.097927] I7: <after_lock_tlb+0x1a4/0x1b4>
[  117.097927] BUG: soft lockup - CPU#55 stuck for 92s! [swapper:0]
[  117.097927] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  117.097927] TPC: <cpu_idle+0xb0/0x134>
[  117.097927] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff5e8000 g3: 0000000000000000
[  117.097927] g4: fffff803ff5d1800 g5: fffff80007e1c000 g6: fffff803ff5e8000 g7: 0000021100004000
[  117.097927] o0: 0000000000000000 o1: fffff803ff5e8008 o2: 0000000000004000 o3: 0000000000000001
[  117.097927] o4: 000000be56337880 o5: 0000000000000012 sp: fffff803ff5eb681 ret_pc: 0000000000427818
[  117.097927] RPC: <cpu_idle+0x9c/0x134>
[  117.097927] l0: 0000000000000037 l1: 00000000007b95c8 l2: 0000000000000037 l3: 00000000000000c8
[  117.097927] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  117.097927] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  117.097927] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff5eb741 i7: 00000000006b0148
[  117.097927] I7: <after_lock_tlb+0x1a4/0x1b4>
[  117.283723] BUG: soft lockup - CPU#11 stuck for 92s! [swapper:0]
[  117.283723] TSTATE: 0000000011001602 TPC: 000000000047c2fc TNPC: 000000000047c300 Y: 00000000    Not tainted
[  117.283723] TPC: <get_cpu_idle_time_us+0x0/0xd0>
[  117.283723] g0: 0000000000009000 g1: 0000000000000000 g2: 0000000000000001 g3: 0000000000000001
[  117.283723] g4: fffff803ff153000 g5: fffff80007cbc000 g6: fffff803ff17c000 g7: fffff80007c64000
[  117.283723] o0: 0000000000000001 o1: 0000000000000000 o2: 000000000000000b o3: 0000000000000001
[  117.283723] o4: 0000000000843400 o5: 00000000007ae800 sp: fffff803ff17f5c1 ret_pc: 000000000047c158
[  117.283723] RPC: <tick_nohz_stop_sched_tick+0x1b4/0x358>
[  117.283723] l0: 000000000000000b l1: fffff800084acc30 l2: 0000000000000001 l3: 000000000000000b
[  117.283723] l4: 000000010000ca38 l5: 000000000000000b l6: 000000be61935bbc l7: 0000000000000000
[  117.283723] i0: fffff800084aa460 i1: 0000000000000000 i2: 0000000000000001 i3: fffff800084aa2d0
[  117.283723] i4: 000000be6186a400 i5: 000000013fff9538 i6: fffff803ff17f681 i7: 00000000004277b0
[  117.283723] I7: <cpu_idle+0x34/0x134>
[  117.414247] BUG: soft lockup - CPU#39 stuck for 92s! [cc1:4345]
[  117.414247] TSTATE: 0000000011001602 TPC: 000000000049d34c TNPC: 000000000049d350 Y: 00000000    Not tainted
[  117.414247] TPC: <find_vma+0x10/0x94>
[  117.414247] g0: 0000000000000870 g1: 0000000000000000 g2: 0000000000000000 g3: 0000000000000000
[  117.414247] g4: fffff803f8579200 g5: fffff80007d9c000 g6: fffff803f0be0000 g7: 0000000000000000
[  117.414247] o0: fffff803fab52000 o1: 00000000003f2000 o2: 000000000000007e o3: fffff803fa884fc0
[  117.414247] o4: fffff803fb270000 o5: fffff803fab52000 sp: fffff803f0be35e1 ret_pc: 00000000006b57f0
[  117.414247] RPC: <do_sparc64_fault+0x1a0/0x5b0>
[  117.414247] l0: 00000000003f2000 l1: 0000000000000618 l2: 0000000000000000 l3: 0000000000000000
[  117.414247] l4: 0000000000000000 l5: 0000000000000000 l6: 0000000000000000 l7: 000000007021b000
[  117.414247] i0: fffff803fab52000 i1: fffff803f0be3f60 i2: 00000000701297cc i3: 0000000000000000
[  117.414247] i4: 0000000000000002 i5: 0000000000000000 i6: fffff803f0be36a1 i7: 0000000000407a2c
[  117.414247] I7: <sparc64_realfault_common+0x18/0x20>
[  117.489419] BUG: soft lockup - CPU#27 stuck for 92s! [swapper:0]
[  117.489419] TSTATE: 0000000011001601 TPC: 000000000042782c TNPC: 0000000000427830 Y: 00000000    Not tainted
[  117.489419] TPC: <cpu_idle+0xb0/0x134>
[  117.489419] g0: 0000000000000000 g1: 0000000000000016 g2: fffff803ff328000 g3: 0000000000000000
[  117.489419] g4: fffff803ff31cc00 g5: fffff80007d3c000 g6: fffff803ff328000 g7: 0000021100004000
[  117.489419] o0: 0000000000000000 o1: fffff803ff328008 o2: 0000000000004000 o3: 0000000000000001
[  117.489419] o4: 000000be6d726600 o5: 0000000000000012 sp: fffff803ff32b681 ret_pc: 0000000000427818
[  117.489419] RPC: <cpu_idle+0x9c/0x134>
[  117.489419] l0: 000000000000001b l1: 00000000007b95c8 l2: 000000000000001b l3: 00000000000000c8
[  117.489419] l4: 00000000feb51cc7 l5: 00000000feb51c7f l6: 0000000000000001 l7: 0000000000000000
[  117.489419] i0: 0000000000000000 i1: 0000000000000016 i2: 0000000000001000 i3: 00000000f025bdfc
[  117.489419] i4: 00000000fee81b18 i5: 00000000fee80bf8 i6: fffff803ff32b741 i7: 00000000006b0148
[  117.489419] I7: <after_lock_tlb+0x1a4/0x1b4>

----Next_Part(Wed_Apr_23_05_29_28_2008_136)----
