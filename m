Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbZLKP2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbZLKP2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758469AbZLKP2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:28:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:57481 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408AbZLKP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:28:38 -0500
Message-ID: <4B226507.4080407@monstr.eu>
Date: Fri, 11 Dec 2009 16:28:07 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: wuzhangjin@gmail.com, linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>
Subject: Re: dynamic ftrace - graph
References: <4AF848C0.7010807@monstr.eu>	 <1260506225.2146.347.camel@gandalf.stny.rr.com>	 <4B21F4F6.5080600@monstr.eu>	 <1260542255.2146.350.camel@gandalf.stny.rr.com>  <4B2259EB.80605@monstr.eu> <1260543272.2146.355.camel@gandalf.stny.rr.com>
In-Reply-To: <1260543272.2146.355.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 2009-12-11 at 15:40 +0100, Michal Simek wrote:
>> Steven Rostedt wrote:
> 
>>> Hey, if they work and they are only in your arch, then I'm fine with
>>> them ;-)
>> yeah. There is one just small hook to recordmcount.pl. :-)
> 
> I may need to give an acked-by. If I did not yet, could you send me that
> specific patch.

I sent that patches to LKML last month - you were cc'd.
http://lkml.org/lkml/2009/11/23/48

You should get it in your mailbox

That part is pretty easy. :-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 090d300..b30dabd 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -245,6 +245,9 @@ if ($arch eq "x86_64") {
      $ld .= " -m elf64_sparc";
      $cc .= " -m64";
      $objcopy .= " -O elf64-sparc";
+} elsif ($arch eq "microblaze") {
+    # Microblaze calls '_mcount' instead of plain 'mcount'.
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
  } else {
      die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
  }


> 
> 
>> we will see. Currently I have small problem only with irqsoff but I 
>> think this don't have connection with ftrace - only with lockdep I 
>> think. :-)
> 
> You have lockdep working?  If you get lockdep working you should get the
> irqsoff tracer for free.

I have some problems when I turn on lockdep debug (CONFIG_DEBUG_LOCKDEP) 
- kernel freeze for currently unknown reason.
I saw that some arch has some part of code in entry.S but I haven't had 
a time to look at them - maybe needs some changes there too.

As you can see below locking testsuite output looks fine but irqsoff 
tracer freeze the kernel. Function tracer is ok.

There could be a problem with some arch specific functions which 
shouldn't be compiled with -pg.

Any suggestions? :-)

Thanks,
Michal

early_printk_console is enabled at 0x84000000
Ramdisk addr 0x00000003, FDT at 0x92000000
Linux version 2.6.32-05317-g51828dd (monstr@monstr.eu) (gcc version 
4.1.2) #245 Fri Dec 11 16:16:57 CET 2009
setup_cpuinfo: initialising
setup_cpuinfo: Using full CPU PVR support
cache: wt_msr
setup_memory: max_mapnr: 0x10000
setup_memory: min_low_pfn: 0x90000
setup_memory: max_low_pfn: 0xa0000
On node 0 totalpages: 65536
free_area_init_node: node 0, pgdat c051f710, node_mem_map c107e000
   Normal zone: 512 pages used for memmap
   Normal zone: 0 pages reserved
   Normal zone: 65024 pages, LIFO batch:15
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
Kernel command line: console=ttyUL0,115200
PID hash table entries: 1024 (order: 0, 4096 bytes)
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 242560k/262144k available
Hierarchical RCU implementation.
NR_IRQS:32
xlnx,xps-intc-1.00.a #0 at 0xd0000000, num_irq=9, edge=0x100
xlnx,xps-timer-1.00.a #0 at 0xd0004000, irq=3
Heartbeat GPIO at 0xd0008000
microblaze_timer_set_mode: shutdown
microblaze_timer_set_mode: periodic
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
  memory used by lock dependency info: 3823 kB
  per task-struct memory footprint: 1920 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                  | spin |wlock |rlock |mutex | wsem | 
rsem |
 
--------------------------------------------------------------------------
                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  | 
ok  |
 
--------------------------------------------------------------------------
               recursive read-lock:             |  ok  |             | 
ok  |
            recursive read-lock #2:             |  ok  |             | 
ok  |
             mixed read-write-lock:             |  ok  |             | 
ok  |
             mixed write-read-lock:             |  ok  |             | 
ok  |
 
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
Calibrating delay loop... 57.34 BogoMIPS (lpj=286720)
Mount-cache hash table entries: 512
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
Switching to clocksource microblaze_clocksource
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 6, 327680 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
audit: initializing netlink socket (disabled)
type=2000 audit(30.830:1): initialized
Slow work thread pool: Starting up
Slow work thread pool: Ready
msgmni has been set to 474
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
84000000.serial: ttyUL0 at MMIO 0x84000003 (irq = 8) is a uartlite
console [ttyUL0] enabled
brd: module loaded
Device Tree Probing 'ethernet'
xilinx_lltemac 81c00000.ethernet: MAC address is now  0: a:35: 0: 0: 0
xilinx_lltemac 81c00000.ethernet: XLlTemac: using DMA mode.
XLlTemac: Dma base address: phy: 0x84600180, virt: 0xd0014180
XLlTemac: buffer descriptor size: 32768 (0x8000)
XLlTemac: Allocating DMA descriptors with kmalloc
XLlTemac: (buffer_descriptor_init) phy: 0x9f8c0000, virt: 0xcf8c0000, 
size: 0x8000
XTemac: PHY detected at address 7.
eth0: Dropping NETIF_F_SG since no checksum feature.
xilinx_lltemac 81c00000.ethernet: eth0: Xilinx TEMAC at 0x81C00000 
mapped to 0xD0010000, irq=5
TCP cubic registered
NET: Registered protocol family 17
Freeing unused kernel memory: 6232k freed
Mounting proc:
Mounting var:
Populating /var:
Running local start scripts.
Mounting sysfs:
Setting hostname:
Setting up interface lo:
Setting up interface eth0:
eth0: XLlTemac: Options: 0x3fa
eth0: XLlTemac: allocating interrupt 1 for dma mode tx.
eth0: XLlTemac: allocating interrupt 2 for dma mode rx.
eth0: XLlTemac: speed set to 100Mb/s
eth0: XLlTemac: Send Threshold = 24, Receive Threshold = 4
eth0: XLlTemac: Send Wait bound = 254, Receive Wait bound = 254
Starting syslogd:
Starting httpd:
Mounting nfs server

uclinux login: root
Password:
Login incorrect
uclinux login: root
Password:
#
#
# gunzip < /proc/config.gz >/tmp/.config
#
# cat /tmp/.config | grep LOCK | grep -v "^#"
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_BLOCK=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_FILE_LOCKING=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# cat /tmp/.config | grep TRACE | grep -v "^#"
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_TRACEPOINTS=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_GENERIC_TRACER=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_IRQSOFF_TRACER=y
#
#
# cd /
# mkdir debug
# mount -t debugfs none /debug
# cat /debug/tracing/available_tracers
irqsoff function sched_switch nop
# echo irqsoff > /debug/tracing/current_tracer

and kernel freeze. :-(



> 
> -- Steve
> 
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
