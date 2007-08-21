Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227AbXHUEC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbXHUEC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 00:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXHUECs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 00:02:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:54938 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbXHUECp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 00:02:45 -0400
Message-ID: <46CB0BE8.8010903@windriver.com>
Date: Tue, 21 Aug 2007 11:59:36 -0400
From: taoyue <yue.tao@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, oleg@tv-sign.ru
CC: Mark Zhan <rongkai.zhan@windriver.com>,
       Bruce Ashfield <bruce.ashfield@windriver.com>
Subject: [BUG]: posix timer: slab error 'double free'
Content-Type: multipart/mixed;
 boundary="------------000701080008020605090008"
X-OriginalArrivalTime: 21 Aug 2007 04:02:25.0281 (UTC) FILETIME=[152FBF10:01C7E3A8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000701080008020605090008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi everyone:

A posix timer race condition is found in current kernel source tree. 
Jeremy has actually
reported the same problem.

I write a simple stress test program for posix timer subsystem, to 
reproduce the problem in the lastest mainline kernel.
My test program creates 200 threads, and each thread does the following job:

while (1) {
    timer_create()

    timer_settime()

    sleep a while

    timer_delete()
}

Please see my test program in the attachemnt "posix_timer_test.c". You 
can compile my test program via the following command line:

    gcc -static -o posix_timer_test.c  posix_timer_test.c -lrt -lpthread

For my testing environment, you can refer to the three attachment files: 
"dmesg.txt", "cpuinfo.txt", "config.txt"

In the pristine Linux-2.6.23-rc3, we get the following oops message:

slab error in cache_alloc_debugcheck_after(): cache `sigqueue': double 
free, or memory outside object was overwritten
 [<c0103941>] show_trace_log_lvl+0x1a/0x30
 [<c0104593>] show_trace+0x12/0x14
 [<c01045ab>] dump_stack+0x16/0x18
 [<c015637b>] __slab_error+0x26/0x28
 [<c0156852>] cache_alloc_debugcheck_after+0x134/0x204
 [<c0157e12>] kmem_cache_alloc+0x5a/0xac
 [<c0123394>] __sigqueue_alloc+0x25/0x62
 [<c0124ad5>] sigqueue_alloc+0x15/0x1f
 [<c012aca4>] sys_timer_create+0x3d/0x2d8
 [<c01029e6>] syscall_call+0x7/0xb
 =======================
dcdcd000: redzone 1:0xd84156c5635688c0, redzone 2:0xd84156c5635688c0
slab error in verify_redzone_free(): cache `sigqueue': double free detected
 [<c0103941>] show_trace_log_lvl+0x1a/0x30
 [<c0104593>] show_trace+0x12/0x14
 [<c01045ab>] dump_stack+0x16/0x18
 [<c015637b>] __slab_error+0x26/0x28
 [<c0156bbf>] cache_free_debugcheck+0x1d9/0x298
 [<c0156eaa>] kmem_cache_free+0x66/0xb5
 [<c0122f4d>] __sigqueue_free+0x2f/0x32
 [<c0123147>] __dequeue_signal+0xdc/0x174
 [<c0124960>] dequeue_signal+0xbb/0x149
 [<c012569e>] sys_rt_sigtimedwait+0x7f/0x240
 [<c01029e6>] syscall_call+0x7/0xb
 =======================
dd7f7000: redzone 1:0x9f911029d74e35b, redzone 2:0x9f911029d74e35b.
BUG: unable to handle kernel paging request at virtual address dd7f7f6c
 printing eip:
c012abdb
*pde = 00075067
*pte = 1d7f7000
Oops: 0002 [#1]
PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    1
EIP:    0060:[<c012abdb>]    Not tainted VLI
EFLAGS: 00010086   (2.6.23-rc3-g2a677896 #1)
EIP is at posix_timer_event+0x14/0xa0
eax: 00000000   ebx: dcc1e900   ecx: 00000020   edx: 00000003
esi: dcc1e938   edi: dd7f7f6c   ebp: dff5fe50   esp: dff5fe48
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=dff5e000 task=dff4eac0 task.ti=dff5e000)
Stack: c012b1a7 dcc1e900 dff5fe7c c012b1e0 00000001 c140ef50 dcc1e938 
00000002
       00000217 dcc1e908 c012b1a7 dcc1e938 c140ef50 dff5febc c012e3a5 
00000000
       dcc1e95c 00000000 e32a8edd ef84ee03 2e028890 000000f1 c140ef20 
00000001
Call Trace:
 [<c0103941>] show_trace_log_lvl+0x1a/0x30
 [<c01039fc>] show_stack_log_lvl+0xa5/0xca
 [<c0103c3c>] show_registers+0x21b/0x391
 [<c0103ed3>] die+0x121/0x25e
 [<c011114d>] do_page_fault+0x354/0x627
 [<c02ec4ea>] error_code+0x72/0x78
 [<c012b1e0>] posix_timer_fn+0x39/0x94
 [<c012e3a5>] hrtimer_run_queues+0x150/0x181
 [<c012225c>] run_timer_softirq+0x1d/0x1a9
 [<c011f132>] __do_softirq+0x71/0xe0
 [<c011f1e0>] do_softirq+0x3f/0x41
 [<c011f335>] irq_exit+0x48/0x4a
 [<c010d259>] smp_apic_timer_interrupt+0x5d/0x89
 [<c010344c>] apic_timer_interrupt+0x28/0x30
 [<c0100c0e>] cpu_idle+0x67/0x90
 [<c03a5778>] start_secondary+0x157/0x15e
 [<00000000>] _stext+0x3fefff50/0x19
 =======================
Code: 89 44 24 04 c7 04 24 bc 53 33 c0 e8 85 05 ff ff 83 c4 08 5e 5f 5d 
c3 55 89 e5 57 53 89 c3 31 c0 b9 20 00 00 00 8b 7b 34 83 c7 0c <f3> ab 
8b 43 34 89 50 24 8b 53 34 8b 43 28 89 42 0c 8b 43 34 c7
EIP: [<c012abdb>] posix_timer_event+0x14/0xa0 SS:ESP 0068:dff5fe48
Kernel panic - not syncing: Fatal exception in interrupt

And I also apply the four patches from Oleg Nesterov from lkml:

http://lkm.org/lkml/2007/8/12/193
http://lkm.org/lkml/2007/8/12/194
http://lkm.org/lkml/2007/8/12/195
http://lkm.org/lkml/2007/8/12/196

After about ten hours, the kernel still panic. Here is its oops message:

slab error in verify_redzone_free(): cache `sigqueue': double free detected
 [<c0103941>] show_trace_log_lvl+0x1a/0x30
 [<c0104593>] show_trace+0x12/0x14
 [<c01045ab>] dump_stack+0x16/0x18
 [<c015638b>] __slab_error+0x26/0x28
 [<c0156bcf>] cache_free_debugcheck+0x1d9/0x298
 [<c0156eba>] kmem_cache_free+0x66/0xb5
 [<c0122f4d>] __sigqueue_free+0x2f/0x32
 [<c0123147>] __dequeue_signal+0xdc/0x174
 [<c01248ca>] dequeue_signal+0x25/0x156
 [<c01256a4>] sys_rt_sigtimedwait+0x7f/0x240
 [<c01029e6>] syscall_call+0x7/0xb
 =======================
df839000: redzone 1:0x9f911029d74e35b, redzone 2:0x9f911029d74e35b.
BUG: unable to handle kernel paging request at virtual address df839f68
 printing eip:
c0124af3
*pde = 0007e067
*pte = 1f839000
Oops: 0000 [#1]
PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in:
CPU:    1
EIP:    0060:[<c0124af3>]    Not tainted VLI
EFLAGS: 00010246   (2.6.23-rc3-g2a677896-dirty #2)
EIP is at sigqueue_free+0x7/0x6f
eax: df839f60   ebx: df839f60   ecx: df3b0000   edx: 00000000
esi: dd3c7120   edi: 00000213   ebp: df3b1e24   esp: df3b1e1c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process posix_timer_tes (pid: 1110, ti=df3b0000 task=dd77dac0 
task.ti=df3b0000)
Stack: 00000213 dd3c7120 df3b1e34 c012a8c2 dd3c7120 dd3c7128 df3b1e50 
c012a9ce
       df755e48 df755e88 dd77df9c dd77dac0 00000000 df3b1e9c c011dab0 
00000000
       00000000 00000000 dd77df5c df3b1e8c c012307d 00000008 00000002 
dd77df44
Call Trace:
 [<c0103941>] show_trace_log_lvl+0x1a/0x30
 [<c01039fc>] show_stack_log_lvl+0xa5/0xca
 [<c0103c3c>] show_registers+0x21b/0x391
 [<c0103ed3>] die+0x121/0x25e
 [<c011114d>] do_page_fault+0x354/0x627
 [<c02ec52a>] error_code+0x72/0x78
 [<c012a8c2>] release_posix_timer+0x13/0x6c
 [<c012a9ce>] exit_itimers+0xb3/0xe7
 [<c011dab0>] do_exit+0x579/0x7d4
 [<c011dd34>] do_group_exit+0x29/0x70
 [<c0124e7c>] get_signal_to_deliver+0x282/0x43e
 [<c0101fd2>] do_notify_resume+0x8b/0x767
 [<c0102a82>] work_notifysig+0x13/0x19
 =======================
Code: 1c 00 5b 5d c3 55 89 e5 64 a1 00 a0 3c c0 31 c9 ba d0 00 00 00 e8 
8d e8 ff ff 85 c0 74 04 83 48 08 01 5d c3 55 89 e5 56 53 89 c3 <f6> 40 
08 01 74 13 3b 00 75 13 83 63 08 fe 89 d8 e8 16 e4 ff ff
EIP: [<c0124af3>] sigqueue_free+0x7/0x6f SS:ESP 0068:df3b1e1c
Fixing recursive fault but reboot is needed!

Any help are appreciated.

Best regards

yue.tao


--------------000701080008020605090008
Content-Type: text/plain;
 name="config.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="config.txt"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23-rc3
# Fri Aug 17 11:30:21 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_CPUSETS is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
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
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
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
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

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

#
# Processor type and features
#
# CONFIG_TICK_ONESHOT is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
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
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
CONFIG_MPENTIUM4=y
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
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
# CONFIG_HPET_TIMER is not set
CONFIG_NR_CPUS=4
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_IRQBALANCE=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
# CONFIG_PM is not set
CONFIG_SUSPEND_SMP_POSSIBLE=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
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
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_DIAG is not set
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
CONFIG_FIB_RULES=y

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
CONFIG_PREVENT_FIRMWARE_BUILD=y
# CONFIG_FW_LOADER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_IDE=y
CONFIG_IDE_MAX_HWIFS=4
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPCI is not set
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_IDE_ARM is not set
# CONFIG_BLK_DEV_IDEDMA is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
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
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set

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
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_DGRS is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
# CONFIG_E1000_NAPI is not set
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=m
# CONFIG_PPPOL2TP is not set
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=y
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
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
# CONFIG_INPUT_KEYBOARD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
# CONFIG_SERIO is not set
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
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=1
CONFIG_SERIAL_8250_RUNTIME_UARTS=1
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
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
# CONFIG_ITCO_WDT is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
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
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
CONFIG_DAB=y

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
# CONFIG_FB is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
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
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_MINIX_FS=m
CONFIG_ROMFS_FS=m
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

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
CONFIG_CONFIGFS_FS=m

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
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
CONFIG_NFS_DIRECTIO=y
# CONFIG_NFSD is not set
CONFIG_ROOT_NFS=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
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

#
# Native Language Support
#
# CONFIG_NLS is not set

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set
# CONFIG_INSTRUMENTATION is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
CONFIG_DEBUG_PREEMPT=y
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
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_LIST is not set
CONFIG_FRAME_POINTER=y
CONFIG_FORCED_INLINING=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_RODATA=y
# CONFIG_4KSTACKS is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

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
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_586 is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_AES_586 is not set
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_TEST=m
# CONFIG_CRYPTO_HW is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y

--------------000701080008020605090008
Content-Type: text/plain;
 name="cpuinfo.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cpuinfo.txt"

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 2.00GHz
stepping        : 9
cpu MHz         : 2000.199
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips        : 4007.90

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 2.00GHz
stepping        : 9
cpu MHz         : 2000.199
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips        : 4007.90

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 2.00GHz
stepping        : 9
cpu MHz         : 2000.199
cache size      : 512 KB
physical id     : 3
siblings        : 2
core id         : 3
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips        : 3999.76

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 2.00GHz
stepping        : 9
cpu MHz         : 2000.199
cache size      : 512 KB
physical id     : 3
siblings        : 2
core id         : 3
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips        : 3999.91


--------------000701080008020605090008
Content-Type: text/x-csrc;
 name="posix_timer_test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="posix_timer_test.c"

/*
 * This posix timer test program is GPL Licensed
 * copyright (C) 2007 Wind River System Inc.
 *
 * Compile: gcc -o posix_timer_test posix_timer_test.c -lrt -lpthread -static
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <pthread.h>
#include <sys/stat.h>
#include <sys/shm.h>
#include <sys/resource.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/time.h>
#include <time.h>
#include <netinet/in.h>
#include <signal.h>
#include <sys/ipc.h>

void ocm_hrtm_handler(sigval_t arg)
{
	return;	
}

void tp_sleep()
{
    struct timespec treq;
    struct timespec rem;
    treq.tv_sec = 2;
    treq.tv_nsec =0;
    memset(&rem,0x00,sizeof(rem));

    
    while(1){
	nanosleep(&treq, &rem);
		break;
    }
}

void tp_timer(void *para)
{
	unsigned ret;
	timer_t                 timerId, timerId2;
	struct itimerspec       itval;
	struct sigevent         evp;
	unsigned int time = 1000, i;

	memset(&evp, 0, sizeof(evp));
	evp.sigev_notify = (int)SIGEV_THREAD;
	evp.sigev_notify_function = (void *)ocm_hrtm_handler;
	evp.sigev_signo = SIGRTMIN;/* D.C */
	evp.sigev_notify_attributes = NULL;
	evp.sigev_value.sival_int = 0; 

	while(1) {
		ret = timer_create(CLOCK_REALTIME,&evp,&timerId);
		if(ret == -1){
	        	perror("timer_create");
			printf("create error %d\n ", timerId);
		}
		else
    			printf("create ok %d\n ", timerId);
		
		time = 1000;
	    	memset(&itval,0,sizeof(itval));
    		itval.it_value.tv_sec  = time / 1000;           
    		itval.it_value.tv_nsec = (time % 1000)*1000000; 
        	itval.it_interval.tv_sec  = itval.it_value.tv_sec;
        	itval.it_interval.tv_nsec = itval.it_value.tv_nsec;

		ret = timer_settime(timerId,0,&itval,NULL);
		if (ret == -1) 
			perror("timer_settime");

		tp_sleep();
		ret = timer_delete( timerId );
	
		if(ret == -1){
	        	perror("timer_delete");
			printf("delete error %d\n ", timerId);
		}
		else
    			printf("delete ok %d\n ", timerId);
	}
}

int main()
{

	unsigned int i, thnum, para, ret;
	pthread_attr_t      thread_attr;
	pthread_t           thread_id;
	struct sched_param  sched_param;

	printf("enter Create Threads num (Dec)---->");
	scanf("%d",&thnum);


	for(i = 0; i<thnum; i++){
			ret = pthread_attr_init( &thread_attr );
			if(ret !=0){ perror("pthread_attr_init");}

			ret = pthread_attr_setdetachstate( &thread_attr,PTHREAD_CREATE_DETACHED );
			if(ret !=0){ perror("pthread_attr_setdetachstate");}

			ret = pthread_attr_setstacksize( &thread_attr,0x300000);
			if(ret !=0){ perror("pthread_attr_setstacksize");}
			
			ret = pthread_attr_setinheritsched( &thread_attr,PTHREAD_EXPLICIT_SCHED );
			if(ret !=0){ perror("pthread_attr_getinheritsched");}

			ret = pthread_attr_setschedpolicy( &thread_attr,SCHED_FIFO);
			if(ret !=0){ perror("pthread_attr_setschedpolicy");}

			sched_param.__sched_priority = 80;
			ret = pthread_attr_setschedparam( &thread_attr,&sched_param);
			if(ret !=0){ perror("pthread_attr_setschedparam");}

			para = i;
			ret = pthread_create( &thread_id, &thread_attr, (void *)tp_timer, (void*)para );
			if( ret != 0 ){
				printf("pthread_create  NG!! [%d]\n",i);
			}
	}
	while(1) {
		sleep(100);
	}
	return ret;

}

--------------000701080008020605090008
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

Linux version 2.6.23-rc3-g2a677896-dirty (ytao@ytao-desktop) (gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #2 SMP PREEMPT Mon Aug 20 15:18:42 EDT 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
 BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 000000001ffff000 (ACPI data)
 BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131056
  HighMem    131056 ->   131056
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   131056
On node 0 totalpages: 131056
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125969 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: INTEL    Product ID: KC861I3B.86E APIC at: 0xFEE00000
Processor #0 15:2 APIC version 20
Processor #6 15:2 APIC version 20
I/O APIC #8 Version 32 at 0xFEC00000.
I/O APIC #9 Version 32 at 0xFEC81000.
I/O APIC #10 Version 32 at 0xFEC81400.
Enabling APIC mode:  Flat.  Using 3 I/O APICs
Processors: 2
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists in Zone order.  Total pages: 130033
Kernel command line: ksdevice=eth1 console=ttyS0,9600n8 root=/dev/nfs rw ip=dhcp BOOT_IMAGE=vlm-boards/8151/kernel ip=192.168.29.97:192.168.29.11:192.168.29.1:255.255.255.0 
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
mapped IOAPIC to ffff9000 (fec81000)
mapped IOAPIC to ffff8000 (fec81400)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1999.886 MHz processor.
Console: colour dummy device 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 515440k/524224k available (1972k kernel code, 8300k reserved, 659k data, 228k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4e000 - 0xfffff000   ( 708 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc0398000 - 0xc03d1000   ( 228 kB)
      .data : 0xc02ed294 - 0xc0391ffc   ( 659 kB)
      .text : 0xc0100000 - 0xc02ed294   (1972 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4003.61 BogoMIPS (lpj=8007232)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbf7 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 12k freed
CPU0: Intel(R) Xeon(TM) CPU 2.00GHz stepping 09
Booting processor 1/6 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3999.90 BogoMIPS (lpj=7999806)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbf7 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
CPU1: Intel(R) Xeon(TM) CPU 2.00GHz stepping 09
Total of 2 processors activated (8003.51 BogoMIPS).
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=4
PCI: Using configuration type 1
Setting up standard PCI resources
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
PCI: Using IRQ router PIIX/ICH [8086/2480] at 0000:00:1f.0
PCI->APIC IRQ transform: 0000:00:1d.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:1f.1[A] -> IRQ 18
PCI->APIC IRQ transform: 0000:00:1f.3[B] -> IRQ 17
PCI->APIC IRQ transform: 0000:04:01.0[A] -> IRQ 48
PCI->APIC IRQ transform: 0000:04:01.1[B] -> IRQ 49
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:02:1d.0
  IO window: e000-efff
  MEM window: ff800000-ff8fffff
  PREFETCH window: ff300000-ff3fffff
PCI: Bridge: 0000:02:1f.0
  IO window: disabled.
  MEM window: ff700000-ff7fffff
  PREFETCH window: ff200000-ff2fffff
PCI: Bridge: 0000:00:03.0
  IO window: e000-efff
  MEM window: ff700000-ff9fffff
  PREFETCH window: ff200000-ff4fffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: ff600000-ff6fffff
  PREFETCH window: ff100000-ff1fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 6, 262144 bytes)
TCP bind hash table entries: 16384 (order: 5, 196608 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 1 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
Clocksource tsc unstable (delta = 322848815 ns)
e1000: 0000:04:01.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:02:b3:f1:88:c4
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
Time: jiffies clocksource has been installed.
e1000: 0000:04:01.1: e1000_probe: (PCI-X:133MHz:64-bit) 00:02:b3:f1:88:c5
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hda: FUJITSU MHT2020AT, ATA DISK drive
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
hda: 39070080 sectors (20003 MB) w/2048KiB Cache, CHS=38760/16/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: multipath personality registered for level -4
md: faulty personality registered for level -5
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI Shortcut mode
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
Sending DHCP requests . OK
IP-Config: Got DHCP answer from 192.168.29.11, my address is 192.168.29.97
IP-Config: Complete:
      device=eth0, addr=192.168.29.97, mask=255.255.255.0, gw=192.168.29.1,
     host=kennicott-node4, domain=tuxlab.wrs.com, nis-domain=swamp,
     bootserver=192.168.29.11, rootserver=192.168.29.11, rootpath=/export/pxeboot/vlm-boards/8151/rootfs
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
Looking up port of RPC 100003/2 on 192.168.29.11
Looking up port of RPC 100005/1 on 192.168.29.11
VFS: Mounted root (nfs filesystem).
Freeing unused kernel memory: 228k freed
Write protecting the kernel text: 1976k
Write protecting the kernel read-only data: 496k


--------------000701080008020605090008--
