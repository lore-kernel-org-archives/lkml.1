Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYJBPLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYJBPLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYJBPKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:10:55 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:56189 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635AbYJBPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:10:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAGKB5EhMQWq+/2dsb2JhbACBZ7RiEAGGdWsBfg
Date: Thu, 2 Oct 2008 11:10:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, laijs@cn.fujitsu.com,
       manfred@colorfullife.com, dipankar@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, josht@linux.vnet.ibm.com
Subject: Re: [PATCH,RFC] RCU-based detection of stalled CPUs for Classic RCU
Message-ID: <20081002151046.GB2473@Krystal>
References: <20081002003628.GA7877@linux.vnet.ibm.com> <20081002080726.GB17695@elte.hu> <20081002140507.GB6729@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081002140507.GB6729@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:05:54 up 119 days, 19:46,  8 users,  load average: 0.08, 0.26,
	0.36
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Thu, Oct 02, 2008 at 10:07:26AM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Hello!
> > > 
> > > This patch adds stalled-CPU detection to Classic RCU.  This capability 
> > > is enabled by a new config variable CONFIG_RCU_CPU_STALL_DETECTOR, 
> > > which defaults disabled.  This is a debugging feature, not something 
> > > that non-kernel-hackers would be expected to care about.  This feature 
> > > can detect looping CPUs in !PREEMPT builds and looping CPUs with 
> > > preemption disabled in PREEMPT builds.  This is essentially a port of 
> > > this functionality from the treercu patch.
> > > 
> > > One current shortcoming: on some systems, stalls are detected during 
> > > early boot, when we normally would not care about them.  My thought is 
> > > to add a call from late initialization to suppress stall detection 
> > > until the system is well along its way to being booted, but thought I 
> > > should check to see if there might already be something for this 
> > > purpose.
> > 
> > could you be a bit more specific, why do those warnings show up and why 
> > dont we care about them? There are things like networking that 
> > occasionally do an rcu_sync() and a stall could mean a bootup hang.
> 
> Hmmm...
> 
> Good point, I was just falling back on my old "we don't care about RCU
> stalls in boot-time code" rule from long ago.  It is entirely possible
> (in fact reasonably likely) that this rule no longer applies to Linux as
> it exists today.  So please see below for the console output.  Not all
> systems report this stall.  I have recently been running only on Power
> systems, will fire off on some x86s.  My kneejerk reaction was that the
> "stall" was really due to the clock-setting operation -- RCU stalls are
> based on get_seconds().
> 
> So maybe I need to change the stall-detection code to use jiffies
> instead.
> 
> Thoughts?
> 

You could possibly use get monotonic time, which should hopefully be a
bit better than its NTP-corrected alternatives.

Also, do you have all the tools you need to poinpoint the precise source
of RCU stalls ? I haven't looked at RCU trace, but I should say adding a
new tracepoint to instrument RCU callback execution at boot time and to
trace it with LTTng is close to trivial. (actually, very early kernel
boot is not so trivial as we would have to create a small kernel module
to activate lttng tracing, but tracing the early phases of userspace
bootup is trivial given we can use the userspace API).

Mathieu

> > > (Currently against 2.6.27-rc8, FYI.)
> > > 
> > > Thoughts?
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > i think this is a very good idea in general - often the question comes 
> > up whether a hang seen in the RCU code is indeed caused by RCU or other 
> > factors. Could you perhaps rebase it against tip/core/rcu ? [or 
> > tip/master for convenience]
> 
> Will do!
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> Console output: search for "RCU detected CPU 5 stall" near the end.
> ------------------------------------------------------------------------
> 
> Elapsed time since release of system processors: 7742 mins 58 secs
> 
> Config file read, 2048 bytes
> Welcome
> Welcome to yaboot version 1.3.13-cas (Red Hat 1.3.13.cas-5)
> Enter "help" to get some basic usage information
> boot: autobench
> Please wait, loading kernel...
>    Elf64 kernel loaded...
> Loading ramdisk...
> ramdisk loaded at 02b00000, size: 2331 Kbytes
> OF stdout device is: /vdevice/vty@30000000
> Hypertas detected, assuming LPAR !
>     -\|/-\|/-\|/-\|
> Elapsed time since release of system processors: 7743 mins 29 secs
> 
> Config file read, 2048 bytes
> Welcome
> Welcome to yaboot version 1.3.13-cas (Red Hat 1.3.13.cas-5)
> Enter "help" to get some basic usage information
> boot: autobench 
> Please wait, loading kernel...
>    Elf64 kernel loaded...
> Loading ramdisk...
> ramdisk loaded at 02b00000, size: 2331 Kbytes
> OF stdout device is: /vdevice/vty@30000000
> Hypertas detected, assuming LPAR !
> command line: ro console=hvc0 autobench_args: root=/dev/sda6
> ABAT:1222922465 
> memory layout at init:
>   alloc_bottom : 0000000002d47000
>   alloc_top    : 0000000008000000
>   alloc_top_hi : 0000000008000000
>   rmo_top      : 0000000008000000
>   ram_top      : 0000000008000000
> Looking for displays
> instantiating rtas at 0x000000000757a000 ... done
> boot cpu hw idx 0000000000000000
> starting cpu hw idx 0000000000000002... done
> starting cpu hw idx 0000000000000004... done
> starting cpu hw idx 0000000000000006... done
> copying OF device tree ...
> Building dt strings...
> Building dt structure...
> Device tree strings 0x0000000002f48000 -> 0x0000000002f49537
> Device tree struct  0x0000000002f4a000 -> 0x0000000002f58000
> Calling quiesce ...
> returning from prom_init
> Using pSeries machine description
> Using 1TB segments
> Found initrd at 0xc000000002b00000:0xc000000002d46c00
> console [udbg0] enabled
> Partition configured for 8 cpus.
> CPU maps initialized for 2 threads per core
> Starting Linux PPC64 #1 SMP PREEMPT Thu Oct 2 00:39:54 EDT 2008
> -----------------------------------------------------
> ppc64_pft_size                = 0x19
> physicalMemorySize            = 0x80000000
> htab_hash_mask                = 0x3ffff
> -----------------------------------------------------
> Initializing cgroup subsys cpuset
> Linux version 2.6.27-rc7-autokern1 (root@tundro2.rchland.ibm.com) (gcc
> version 4.1.2 20071124 (Red Hat 4.1.2-42)) #1 SMP PREEMPT Thu Oct 2
> 00:39:54 EDT 2008
> [boot]0012 Setup Arch
> EEH: No capable adapters found
> PPC64 nvram contains 15360 bytes
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00080000
>   Normal   0x00080000 -> 0x00080000
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000000 -> 0x00044000
>     1: 0x00044000 -> 0x00080000
> [boot]0015 Setup Done
> Built 2 zonelists in Node order, mobility grouping on.  Total pages:
> 517120
> Policy zone: DMA
> Kernel command line: ro console=hvc0 autobench_args: root=/dev/sda6
> ABAT:1222922465 
> Experimental hierarchical RCU implementation.
> RCU-based detection of stalled CPUs is enabled.
> Experimental hierarchical RCU init done.
> [boot]0020 XICS Init
> [boot]0021 XICS Done
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> clocksource: timebase mult[7d0000] shift[22] registered
> Console: colour dummy device 80x25
> console handover: boot [udbg0] -> real [hvc0]
> Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> freeing bootmem node 0
> freeing bootmem node 1
> Memory: 2038156k/2097152k available (7200k kernel code, 58996k reserved,
> 1052k data, 513k bss, 292k init)
> SLUB: Genslabs=13, HWalign=128, Order=0-3, MinObjects=0, CPUs=8,
> Nodes=16
> Calibrating delay loop... 915.45 BogoMIPS (lpj=1830912)
> Mount-cache hash table entries: 256
> Initializing cgroup subsys ns
> Initializing cgroup subsys cpuacct
> Processor 1 found.
> Processor 2 found.
> Processor 3 found.
> Processor 4 found.
> Processor 5 found.
> Processor 6 found.
> Processor 7 found.
> Brought up 8 CPUs
> net_namespace: 1152 bytes
> NET: Registered protocol family 16
> IBM eBus Device Driver
> PCI: Probing PCI hardware
> SCSI subsystem initialized
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> NET: Registered protocol family 2
> IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
> TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> TCP: Hash tables configured (established 262144 bind 65536)
> TCP reno registered
> NET: Registered protocol family 1
> checking if image is initramfs... it is
> Freeing initrd memory: 2331k freed
> IOMMU table initialized, virtual merging enabled
> audit: initializing netlink socket (disabled)
> type=2000 audit(1222908206.468:1): initialized
> HugeTLB registered 16 MB page size, pre-allocated 0 pages
> HugeTLB registered 16 GB page size, pre-allocated 0 pages
> HugeTLB registered 64 KB page size, pre-allocated 0 pages
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> msgmni has been set to 3985
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
> io scheduler noop registered
> io scheduler anticipatory registered (default)
> io scheduler deadline registered
> io scheduler cfq registered
> Generic RTC Driver v1.07
> Serial: 8250/16550 driver4 ports, IRQ sharing disabled
> brd: module loaded
> loop: module loaded
> Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
> Copyright (c) 1999-2006 Intel Corporation.
> pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
> e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
> e100: Copyright(c) 1999-2006 Intel Corporation
> console [netcon0] enabled
> netconsole: network logging started
> Uniform Multi-Platform E-IDE driver
> ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
> ibmvscsi 30000003: SRP_VERSION: 16.a
> scsi0 : IBM POWER Virtual SCSI Adapter 1.5.8
> ibmvscsi 30000003: partner initialization complete
> ibmvscsi 30000003: sent SRP login
> ibmvscsi 30000003: SRP_LOGIN succeeded
> ibmvscsi 30000003: host srp version: 16.a, host partition tundro1 (1),
> OS 2, max io 262144
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi 0:0:1:0: Direct-Access     IBM      VDASD blkdev     0001 PQ: 0
> ANSI: 4
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> scsi scan: INQUIRY result too short (5), using 36
> st: Version 20080504, fixed bufsize 32768, s/g segs 256
> Driver 'st' needs updating - please use bus_type methods
> Driver 'sd' needs updating - please use bus_type methods
> sd 0:0:1:0: [sda] 73400922 512-byte hardware sectors (37581 MB)
> sd 0:0:1:0: [sda] Write Protect is off
> sd 0:0:1:0: [sda] Write cache: disabled, read cache: disabled, doesn't
> support DPO or FUA
> sd 0:0:1:0: [sda] 73400922 512-byte hardware sectors (37581 MB)
> sd 0:0:1:0: [sda] Write Protect is off
> sd 0:0:1:0: [sda] Write cache: disabled, read cache: disabled, doesn't
> support DPO or FUA
>  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
> sd 0:0:1:0: [sda] Attached SCSI disk
> Driver 'sr' needs updating - please use bus_type methods
> sd 0:0:1:0: Attached scsi generic sg0 type 0
> Initializing USB Mass Storage driver...
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> mice: PS/2 mouse device common for all mice
> md: linear personality registered for level -1
> md: raid0 personality registered for level 0
> md: raid1 personality registered for level 1
> device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:
> dm-devel@redhat.com
> usbcore: registered new interface driver hiddev
> usbcore: registered new interface driver usbhid
> usbhid: v2.6:USB HID core driver
> IPv4 over IPv4 tunneling driver
> TCP cubic registered
> NET: Registered protocol family 17
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> registered taskstats version 1
> Freeing unused kernel memory: 292k freed
> Red Hat nash version 5.1.19.6 starting
> Mounting proc filesystem
> Mounting sysfs filesystem
> Creating /dev
> Creating initial device nodes
> Setting up hotplug.
> Creating block device nodes.
> Loading ehea.ko module
> IBM eHEA ethernet device driver (Release EHEA_0092)
> Scanning and configuring dmraid supported devices
> Creating root device.
> Mounting root filesystem.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> Setting up other filesystems.
> Setting up new root fs
> no fstab.sys, mounting internal defaults
> Switching to new root and running init.
> unmounting old /dev
> unmounting old /proc
> unmounting old /sys
> INIT: version 2.86 booting
>                 Welcome to Red Hat Enterprise Linux Server
>                 Press 'I' to enter interactive startup.
> RCU detected CPU 5 stall (t=1222922609/2)
> Call Trace:
> [c000000042d03920] [c00000000000fdec] .show_stack+0x70/0x184
> (unreliable)
> [c000000042d039d0] [c0000000000a1de0] .__rcu_pending+0x98/0x2ec
> [c000000042d03a70] [c0000000000a206c] .rcu_pending+0x38/0x88
> [c000000042d03af0] [c00000000006363c] .update_process_times+0x48/0x94
> [c000000042d03b80] [c00000000007bae4] .tick_sched_timer+0xbc/0x118
> [c000000042d03c20] [c000000000073a88] .__run_hrtimer+0x78/0x118
> [c000000042d03cc0] [c000000000074b3c] .hrtimer_interrupt+0x128/0x1e4
> [c000000042d03d90] [c00000000002304c] .timer_interrupt+0xe0/0x15c
> [c000000042d03e30] [c000000000003700] decrementer_common+0x100/0x180
> Setting clock  (localtime): Thu Oct  2 00:43:30 EDT 2008 [  OK  ]
> Starting udev: [  OK  ]
> Setting hostname tundro2.rchland.ibm.com:  [  OK  ]
> No devices found
> Setting up Logical Volume Management:   No volume groups found
> [  OK  ]
> Checking filesystems
> Checking all file systems.
> [/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda6 
> /dev/sda6: Superblock last mount time is in the future.  FIXED.
> /dev/sda6: clean, 134758/1281696 files, 853722/2560336 blocks
> [  OK  ]
> Remounting root filesystem in read-write mode:  [  OK  ]
> Mounting local filesystems:  [  OK  ]
> Enabling local filesystem quotas:  quotaon: Warning: No quota format
> detected in the kernel.
> [  OK  ]
> Enabling /etc/fstab swaps:  swapon: /dev/sda5: Invalid argument
> [FAILED]
> INIT: Entering runlevel: 3
> Entering non-interactive startup
> Starting boot.loadmodules:  [  OK  ]
> Starting background readahead: [  OK  ]
> Bringing up loopback interface:  [  OK  ]
> Bringing up interface eth0:  [  OK  ]
> Starting auditd: [  OK  ]
> Starting system logger: [  OK  ]
> Starting kernel logger: [  OK  ]
> Starting irqbalance: [  OK  ]
> Starting RPC idmapd: FATAL: Module sunrpc not found.
> FATAL: Error running install command for sunrpc
> Error: RPC MTAB does not exist.
> Starting system message bus: [  OK  ]
> Starting Bluetooth services:[  OK  ][  OK  ]Can't open RFCOMM control
> socket: Address family not supported by protocol
> 
> Mounting other filesystems:  [  OK  ]
> Starting PC/SC smart card daemon (pcscd): [  OK  ]
> Starting hidd: Can't open HIDP control socket: Address family not
> supported by protocol
> [FAILED]
> Starting autofs:  Loading autofs4: [  OK  ]
> Starting automount: [  OK  ]
> [  OK  ]
> Starting iprinit:  Starting ipr initialization daemon[  OK  ]
> [  OK  ]
> Starting iprupdate:  Checking ipr microcode levels
> Completed ipr microcode updates[  OK  ]
> [  OK  ]
> Starting iprdump:  Starting ipr dump daemon[  OK  ]
> [  OK  ]
> Starting sshd: [  OK  ]
> Starting cups: [  OK  ]
> Starting xinetd: [  OK  ]
> Starting vpdupdate: [  OK  ]
> Starting console mouse services: [  OK  ]
> Starting crond: [  OK  ]
> Starting xfs: [  OK  ]
> Starting anacron: [  OK  ]
> Starting atd: [  OK  ]
> Starting yum-updatesd: [  OK  ]
> Starting Avahi daemon... [  OK  ]
> Starting HAL daemon: [  OK  ]
> Starting smartd: [  OK  ]
> 
> Red Hat Enterprise Linux Server release 5.2 (Tikanga)
> Kernel 2.6.27-rc7-autokern1 on an ppc64
> 
> tundro2.rchland.ibm.com login:-- 0:conmux-control -- time-stamp --
> Oct/01/08 21:45:47 --
> -- 0:conmux-control -- time-stamp -- Oct/01/08 22:01:03 --
> (bot:conmon-payload) disconnected

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
