Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbXLTTpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbXLTTpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXLTTpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:45:04 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1940 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbXLTTo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:44:59 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
Date: Thu, 20 Dec 2007 20:47:55 +0100
User-Agent: KMail/1.9.7
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
References: <20071216.202611.226170474.davem@davemloft.net> <20071220.045359.107684960.davem@davemloft.net> <20071220174540.GW19691@waste.org>
In-Reply-To: <20071220174540.GW19691@waste.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_sbsaH9Q8wmpamGu"
Message-Id: <200712202047.56745.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_sbsaH9Q8wmpamGu
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello, 

> > > Actually, you may only need these two:
> > > 
> > > > maps4-add-proc-kpagecount-interface.patch
> > > > maps4-add-proc-kpageflags-interface.patch
> > 
> > Yes these two were enough, and exporting fs/proc/base.c's
> > mem_lseek().
> > 
> > As hard as I try, I can't reproduce this at all.  I tried
> > both on my workstation and my niagara boxes.
> 
> That's good to know, I was having a very hard time imagining how the
> kpagecount code could be going south.
>  
> > It must be other needle in the 30MB+ -mm haystack. :-(

I'm afraid you are wrong. Eariler kernel are affected as well. At reading your mail I was
thinking of applying those two patches to 2.6.24-rc5 and do bisection on the rest of -mm series.
Unfortunately clean 2.6.24-rc5 with these two patches is affected as well (new processes
stuck in D state etc). So I tried vanilla 2.6.23 patched by these two patches (and
mem_lseek export from fs/proc/base.c). Now at least I got a trace produced by 'cat /proc/kpagecount'
which you can find below. Also, in spite of the oops, the box doesn't get locked (as with -mm)
and is still usable.

[  126.060976] TSTATE: 0000009980009603 TPC: 0000000000428a84 TNPC: 0000000000428a88 Y: 00000000    Not tainted
[  126.063486] TPC: <cpu_idle+0x2c/0xe0>
[  126.065986] g0: 0000000000000009 g1: 0000048000004000 g2: 000000000000000f g3: 00000000007204c0
[  126.068636] g4: 00000000007244c0 g5: fffff8007f878000 g6: 00000000007204c0 g7: 0000000000724958
[  126.071232] o0: 0000000000000001 o1: 00000000007204c8 o2: 0000000000000001 o3: 0000000000000000
[  126.073924] o4: 6000000000000000 o5: 000000000078f140 sp: 00000000007239b1 ret_pc: 0000000000428a78
[  126.076569] RPC: <cpu_idle+0x20/0xe0>
[  126.079185] l0: 0000000000720000 l1: 0000000000000002 l2: 0000000000000001 l3: 000000000075d400
[  126.081934] l4: 000000000075d400 l5: fffff80080015b10 l6: fffff80080005b08 l7: 0000000000000001
[  126.084637] i0: 0000000000000001 i1: 0000000000720094 i2: 0000000000000000 i3: 0000000000000000
[  126.087375] i4: 00000000007204c0 i5: 0000000000000002 i6: 0000000000723a71 i7: 0000000000665a24
[  126.090135] I7: <rest_init+0x6c/0x80>
[  145.121228] Unable to handle kernel NULL pointer dereference
[  145.124515] tsk->{mm,active_mm}->context = 0000000000000d41
[  145.127778] tsk->{mm,active_mm}->pgd = fffff800bd8d2000
[  145.127801]               \|/ ____ \|/
[  145.127808]               "@'/ .. \`@"
[  145.127815]               /_| \__/ |_\
[  145.127821]                  \__U_/
[  145.127831] cat(3111): Oops [#1]
[  145.127849] 
[  145.127853] =================================
[  145.127861] [ INFO: inconsistent lock state ]
[  145.127873] 2.6.23 #1
[  145.127880] ---------------------------------
[  145.127891] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
[  145.127906] cat/3111 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  145.127918]  (regdump_lock){+...}, at: [<00000000004281d0>] __show_regs+0x18/0x320
[  145.127951] {in-hardirq-W} state was registered at:
[  145.127960]   [<0000000000669780>] _spin_lock+0x28/0x40
[  145.127983]   [<00000000004281d0>] __show_regs+0x18/0x320
[  145.128000]   [<00000000004284e4>] show_regs+0xc/0x20
[  145.128016]   [<00000000005ac9d8>] sysrq_handle_showregs+0x20/0x40
[  145.128041]   [<00000000005ac7fc>] __handle_sysrq+0x84/0x160
[  145.128060]   [<00000000005ac8f8>] handle_sysrq+0x20/0x40
[  145.128078]   [<00000000005a4f08>] kbd_event+0x670/0xb60
[  145.128110]   [<00000000005ea0c0>] input_event+0x1e8/0x560
[  145.128140]   [<00000000005efa2c>] sunkbd_interrupt+0x114/0x140
[  145.128167]   [<00000000005e6270>] serio_interrupt+0x38/0xa0
[  145.128186]   [<00000000005b2e58>] sunsu_kbd_ms_interrupt+0xa0/0x140
[  145.128212]   [<000000000049f6f8>] handle_IRQ_event+0x20/0x80
[  145.128251]   [<000000000049f808>] __do_IRQ+0xb0/0x140
[  145.128268]   [<000000000042f48c>] handler_irq+0x94/0xc0
[  145.128306]   [<0000000000426f30>] sunos_sys_table+0x560/0x728
[  145.128324]   [<0000000000428a78>] cpu_idle+0x20/0xe0
[  145.128341]   [<0000000000665a24>] rest_init+0x6c/0x80
[  145.128375]   [<000000000076ec24>] start_kernel+0x2ec/0x340
[  145.128405]   [<000000000066599c>] tlb_fixup_done+0xa0/0xbc
[  145.128425]   [<0000000000000000>] 0x8
[  145.128443] irq event stamp: 1209
[  145.128451] hardirqs last  enabled at (1209): [<0000000000404b74>] __handle_softirq_continue+0x20/0x24
[  145.128480] hardirqs last disabled at (1207): [<0000000000474494>] __do_softirq+0xbc/0x140
[  145.128506] softirqs last  enabled at (1208): [<00000000004744dc>] __do_softirq+0x104/0x140
[  145.128526] softirqs last disabled at (1203): [<00000000004745a0>] do_softirq+0x88/0xa0
[  145.128546] 
[  145.128551] other info that might help us debug this:
[  145.128562] no locks held by cat/3111.
[  145.128570] 
[  145.128574] stack backtrace:
[  145.128582] Call Trace:
[  145.128590]  [00000000004907a0] print_usage_bug+0x148/0x160
[  145.128624]  [00000000004917f4] mark_lock+0x6dc/0x780
[  145.128641]  [000000000049286c] __lock_acquire+0x734/0x12a0
[  145.128659]  [0000000000493430] lock_acquire+0x58/0x80
[  145.128676]  [0000000000669780] _spin_lock+0x28/0x40
[  145.128691]  [00000000004281d0] __show_regs+0x18/0x320
[  145.128706]  [0000000000429ba0] die_if_kernel+0x68/0x2c0
[  145.128722]  [0000000000452ab0] unhandled_fault+0x78/0xe0
[  145.128749]  [0000000000452d14] do_sparc64_fault+0x17c/0x620
[  145.128765]  [000000000040798c] sparc64_realfault_common+0x18/0x20
[  145.128787]  [fffff800bdca3e80] 0xfffff800bdca3e88
[  145.128799]  [000000000050affc] proc_reg_read+0x64/0xa0
[  145.128828]  [00000000004ccb4c] vfs_read+0x74/0x120
[  145.128856]  [00000000004ccf4c] sys_read+0x34/0x60
[  145.128872]  [0000000000406314] linux_sparc_syscall+0x3c/0x44
[  145.128898]  [0000000000012ff4] 0x12ffc
[  145.128915] TSTATE: 0000004411009603 TPC: 00000000005119ac TNPC: 00000000005119b0 Y: 00000000    Not tainted
[  145.128940] TPC: <kpagecount_read+0x94/0xe0>
[  145.128951] g0: 0000000000000000 g1: 0000000000000058 g2: 0000000000000000 g3: 0000000000028008
[  145.128966] g4: fffff800bfc3a460 g5: fffff8007f878000 g6: fffff800bdca0000 g7: 0000000000000000
[  145.128982] o0: 0000000000000001 o1: 0000000000000001 o2: 000000000050afe4 o3: 0000000000000000
[  145.128997] o4: 0000000000000002 o5: 0000000000b80320 sp: fffff800bdca3391 ret_pc: fffff800bdca3e80
[  145.129013] RPC: <0xfffff800bdca3e88>
[  145.129023] l0: fffff800bfc3a460 l1: 0000000000669d3c l2: 0000000000000001 l3: 000000000075d400
[  145.129039] l4: 000000000075d400 l5: fffff80080015b10 l6: fffff80080005b08 l7: 0000000000000001
[  145.129054] i0: 0000000000028010 i1: 0000000000028000 i2: 0000000000001ff8 i3: 0000000000000002
[  145.129070] i4: 0000000000000058 i5: 0000000000000000 i6: fffff800bdca3451 i7: 000000000050affc
[  145.129088] I7: <proc_reg_read+0x64/0xa0>
[  145.129119] Caller[000000000050affc]: proc_reg_read+0x64/0xa0
[  145.129139] Caller[00000000004ccb4c]: vfs_read+0x74/0x120
[  145.129156] Caller[00000000004ccf4c]: sys_read+0x34/0x60
[  145.129173] Caller[0000000000406314]: linux_sparc_syscall+0x3c/0x44
[  145.129193] Caller[0000000000012ff4]: 0x12ffc
[  145.129205] Instruction DUMP: 82070002  02c04003  86063ff8 <ce406008> cef0e000  82100000  8610001b  b406bff8  80a06000 

> Have we seen a config for the broken machine? Perhaps that'll help us
> make a guess..

Please find it attached (version 2.6.23).

The box is sun ultra 60 with 2 cpus.

# lspci 
0000:00:00.0 Host bridge: Sun Microsystems Computer Corp. Psycho PCI Bus Module
0000:00:01.0 Bridge: Sun Microsystems Computer Corp. EBUS (rev 01)
0000:00:01.1 Ethernet controller: Sun Microsystems Computer Corp. Happy Meal (rev 01)
0000:00:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 14)
0000:00:03.1 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 14)
0001:00:00.0 Host bridge: Sun Microsystems Computer Corp. Psycho PCI Bus Module

# cat /proc/cpuinfo 
cpu             : TI UltraSparc II  (BlackBird)
fpu             : UltraSparc II integrated FPU
prom            : OBP 3.17.0 1998/10/23 11:26
type            : sun4u
ncpus probed    : 2
ncpus active    : 2
D$ parity tl1   : 0
I$ parity tl1   : 0
Cpu0ClkTck      : 000000001ad1c43b
Cpu2ClkTck      : 000000001ad1c43b
MMU Type        : Spitfire
State:
CPU0:           online
CPU2:           online

# cat /proc/meminfo 
MemTotal:      1015648 kB
MemFree:        961840 kB
Buffers:          5680 kB
Cached:          18096 kB
SwapCached:          0 kB
Active:          22440 kB
Inactive:        10288 kB
SwapTotal:      497992 kB
SwapFree:       497992 kB
Dirty:              32 kB
Writeback:           0 kB
AnonPages:        9168 kB
Mapped:           4288 kB
Slab:            10368 kB
SReclaimable:     4008 kB
SUnreclaim:       6360 kB
PageTables:        424 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   1005816 kB
Committed_AS:    27272 kB
VmallocTotal:  4194304 kB
VmallocUsed:       136 kB
VmallocChunk:  4194168 kB

# cat /proc/interrupts 
           CPU0       CPU2       
  0:      24567      16248     <NULL>  timer
  1:          0          0      sun4u  PSYCHO_PCIERR
  2:          0          0      sun4u  PSYCHO_UE
  3:          0          0      sun4u  PSYCHO_CE
  8:        291          0      sun4u  su(kbd)
  9:          0          0      sun4u  su(mouse)
 14:       1061          0      sun4u  eth0
 15:       2034          0      sun4u  sym53c8xx
 16:          0         30      sun4u  sym53c8xx
 17:          0          0      sun4u  PSYCHO_PCIERR

I'll try earilier kernels and see what happens.

Regards,

	Mariusz

--Boundary-00=_sbsaH9Q8wmpamGu
Content-Type: text/plain;
  charset="iso-8859-1";
  name="config-sparc64-2.6.23"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="config-sparc64-2.6.23"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23
# Thu Dec 20 19:53:57 2007
#
CONFIG_SPARC=y
CONFIG_SPARC64=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_64BIT=y
CONFIG_MMU=y
CONFIG_QUICKLIST=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_NO_VIRT_TO_BUS=y
CONFIG_OF=y
CONFIG_SPARC64_PAGE_SIZE_8KB=y
# CONFIG_SPARC64_PAGE_SIZE_64KB is not set
# CONFIG_SPARC64_PAGE_SIZE_512KB is not set
# CONFIG_SPARC64_PAGE_SIZE_4MB is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_HOTPLUG_CPU is not set
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
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
# CONFIG_CPUSETS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_RELAY=y
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_SYSVIPC_COMPAT=y
CONFIG_GENERIC_HARDIRQS=y

#
# General machine setup
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_SMP=y
CONFIG_NR_CPUS=4
# CONFIG_CPU_FREQ is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_NR_QUICK=1
CONFIG_SBUS=y
CONFIG_SBUSCHAR=y
CONFIG_SUN_AUXIO=y
CONFIG_SUN_IO=y
# CONFIG_SUN_LDOMS is not set
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_SYSCALL=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_SUN_OPENPROMFS=m
CONFIG_SPARC32_COMPAT=y
CONFIG_COMPAT=y
CONFIG_BINFMT_ELF32=y
# CONFIG_BINFMT_AOUT32 is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_MISC=m
CONFIG_SOLARIS_EMUL=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
# CONFIG_CMDLINE_BOOL is not set

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
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
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

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_OF_DEVICE=y
# CONFIG_PARPORT is not set
# CONFIG_BLK_DEV is not set
# CONFIG_MISC_DEVICES is not set
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
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
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
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
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLOGICPTI is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SUNESP is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_SUNLANCE is not set
CONFIG_HAPPYMEAL=y
# CONFIG_SUNBMAC is not set
# CONFIG_SUNQE is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_NET_PCI is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#

#
# Non-8250 serial port support
#
CONFIG_SERIAL_SUNCORE=y
# CONFIG_SERIAL_SUNZILOG is not set
CONFIG_SERIAL_SUNSU=y
CONFIG_SERIAL_SUNSU_CONSOLE=y
CONFIG_SERIAL_SUNSAB=m
CONFIG_SERIAL_SUNHV=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_WATCHDOG is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_DRM is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_TCG_TPM is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_CFB_FILLRECT is not set
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_SBUS=y
# CONFIG_FB_BW2 is not set
# CONFIG_FB_CG3 is not set
# CONFIG_FB_CG6 is not set
CONFIG_FB_FFB=y
# CONFIG_FB_TCX is not set
# CONFIG_FB_CG14 is not set
# CONFIG_FB_P9100 is not set
# CONFIG_FB_LEO is not set
# CONFIG_FB_XVR500 is not set
# CONFIG_FB_XVR2500 is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
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
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
# CONFIG_PROM_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
# CONFIG_FONT_8x16 is not set
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
CONFIG_FONT_SUN8x16=y
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_LOGO_SUN_CLUT224=y

#
# Sound
#
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#

#
# DMA Devices
#

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Misc Linux/SPARC drivers
#
CONFIG_SUN_OPENPROMIO=y
# CONFIG_OBP_FLASH is not set
# CONFIG_SUN_BPP is not set
# CONFIG_BBC_I2C is not set
# CONFIG_ENVCTRL is not set
# CONFIG_DISPLAY7SEG is not set

#
# Fibre Channel support
#
# CONFIG_FC4 is not set

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
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_SUN_PARTITION=y

#
# Native Language Support
#
# CONFIG_NLS is not set

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set

#
# Instrumentation Support
#
# CONFIG_PROFILING is not set
# CONFIG_KPROBES is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_FRAME_POINTER=y
CONFIG_FORCED_INLINING=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_DCFLUSH is not set
# CONFIG_STACK_DEBUG is not set
# CONFIG_DEBUG_BOOTMEM is not set
# CONFIG_DEBUG_PAGEALLOC is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_MANAGER=y
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=m
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_HW=y

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-00=_sbsaH9Q8wmpamGu--
