Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbXLKN4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbXLKN4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXLKN4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:56:12 -0500
Received: from ispmxmta05-srv.windstream.net ([166.102.165.166]:45970 "EHLO
	ispmxmta05-srv.windstream.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbXLKN4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:56:10 -0500
X-Greylist: delayed 991 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 08:56:10 EST
Date: Tue, 11 Dec 2007 08:39:13 -0500 (EST)
From: Burton Windle <bwindle@fint.org>
X-X-Sender: bwindle@postal
To: linux-kernel@vger.kernel.org
Subject: odd slab memory usage in latest git
Message-ID: <Pine.LNX.4.64.0712110815330.4289@postal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure what to make of this... since moving from 2.6.24-rc3-git5 to 
2.6.24-rc4-git3, my network monitoring server is seeing what looks like a 
memory leak in the slab (currently running 2.6.24-rc4-git6). It looks like 
the slab is growing at a linear rate of about 10 megabytes/hour (I graph 
memory usage on Cacti, and I first saw this on 2.6.24-rc4-git3; when I 
came to work on Monday it was using 600 megabytes in slab).  VM pressure 
does seem to cause it to shrink again, so it doesn't seem to be a real 
leak.

Was this a design change, or something else? Usually the box's memory is 
used in disk cache, not slab.

bwindle@RTIX-NM-003:~$ cat /proc/version
Linux version 2.6.24-rc4-git6 (bwindle@RTIX-NM-003) (gcc version 4.2.3 20071014 (prerelease) (Debian 4.2.2-3)) #27 SMP Mon Dec 10 08:43:52 EST 2007
bwindle@RTIX-NM-003:~$ cat /proc/meminfo
MemTotal:      1035416 kB
MemFree:        430116 kB
Buffers:         96692 kB
Cached:          98432 kB
SwapCached:          0 kB
Active:         195364 kB
Inactive:        66816 kB
HighTotal:      131064 kB
HighFree:         1240 kB
LowTotal:       904352 kB
LowFree:        428876 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:            2580 kB
Writeback:           0 kB
AnonPages:       66976 kB
Mapped:          11864 kB
Slab:           308636 kB
SReclaimable:   303412 kB
SUnreclaim:       5224 kB
PageTables:        908 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:    517708 kB
Committed_AS:   236264 kB
VmallocTotal:   114680 kB
VmallocUsed:       100 kB
VmallocChunk:   114564 kB

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
UNIX                  25     42    576    7    1 : tunables   54   27    8 : slabdata      6      6      0
flow_cache             0      0     96   40    1 : tunables  120   60    8 : slabdata      0      0      0
scsi_cmd_cache        23     65    288   13    1 : tunables   54   27    8 : slabdata      5      5      6
cfq_io_context         0      0     80   48    1 : tunables  120   60    8 : slabdata      0      0      0
cfq_queue              0      0     84   46    1 : tunables  120   60    8 : slabdata      0      0      0
udf_inode_cache        0      0    436    9    1 : tunables   54   27    8 : slabdata      0      0      0
cifs_small_rq         30     36    448    9    1 : tunables   54   27    8 : slabdata      4      4      0
cifs_request           4      4  16480    1    8 : tunables    8    4    0 : slabdata      4      4      0
cifs_oplock_structs      0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
cifs_mpx_ids           3     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
cifs_inode_cache       0      0    416    9    1 : tunables   54   27    8 : slabdata      0      0      0
smb_request            0      0    288   13    1 : tunables   54   27    8 : slabdata      0      0      0
smb_inode_cache        0      0    404    9    1 : tunables   54   27    8 : slabdata      0      0      0
isofs_inode_cache      0      0    408    9    1 : tunables   54   27    8 : slabdata      0      0      0
ext2_inode_cache       0      0    576    7    1 : tunables   54   27    8 : slabdata      0      0      0
ext2_xattr             0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
journal_handle        20    169     20  169    1 : tunables  120   60    8 : slabdata      1      1      0
journal_head         212    432     52   72    1 : tunables  120   60    8 : slabdata      6      6     30
revoke_table           2    254     12  254    1 : tunables  120   60    8 : slabdata      1      1      0
revoke_record          0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
ext3_inode_cache  163980 163989    568    7    1 : tunables   54   27    8 : slabdata  23427  23427      0
ext3_xattr             0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
dnotify_cache          0      0     20  169    1 : tunables  120   60    8 : slabdata      0      0      0
kioctx                 0      0    224   17    1 : tunables  120   60    8 : slabdata      0      0      0
kiocb                  0      0    160   24    1 : tunables  120   60    8 : slabdata      0      0      0
fasync_cache           0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
shmem_inode_cache      7     16    488    8    1 : tunables   54   27    8 : slabdata      2      2      0
nsproxy                0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
posix_timers_cache      0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
uid_cache              5     24    160   24    1 : tunables  120   60    8 : slabdata      1      1      0
UDP-Lite               0      0    608    6    1 : tunables   54   27    8 : slabdata      0      0      0
tcp_bind_bucket       15    203     16  203    1 : tunables  120   60    8 : slabdata      1      1      0
inet_peer_cache        1     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
secpath_cache          0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm_dst_cache         0      0    288   13    1 : tunables   54   27    8 : slabdata      0      0      0
ip_fib_alias           9    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
ip_fib_hash            9    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
ip_dst_cache         855    855    256   15    1 : tunables  120   60    8 : slabdata     57     57      0
arp_cache            115    144    160   24    1 : tunables  120   60    8 : slabdata      6      6      0
RAW                    3      7    576    7    1 : tunables   54   27    8 : slabdata      1      1      0
UDP                    0      0    608    6    1 : tunables   54   27    8 : slabdata      0      0      0
tw_sock_TCP           27     60    128   30    1 : tunables  120   60    8 : slabdata      2      2      0
request_sock_TCP      15     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
TCP                   12     12   1248    3    1 : tunables   24   12    8 : slabdata      4      4      0
eventpoll_pwq          9    101     36  101    1 : tunables  120   60    8 : slabdata      1      1      0
eventpoll_epi          9     40     96   40    1 : tunables  120   60    8 : slabdata      1      1      0
sgpool-128             2      2   2048    2    1 : tunables   24   12    8 : slabdata      1      1      0
sgpool-64              2      4   1024    4    1 : tunables   54   27    8 : slabdata      1      1      0
sgpool-32              2      8    512    8    1 : tunables   54   27    8 : slabdata      1      1      0
sgpool-16              7     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
sgpool-8              42     90    128   30    1 : tunables  120   60    8 : slabdata      3      3      0
scsi_io_context        0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_ioc            39    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
blkdev_queue          43     49   1060    7    2 : tunables   24   12    8 : slabdata      7      7      0
blkdev_requests      121    198    180   22    1 : tunables  120   60    8 : slabdata      9      9      0
biovec-256             2      2   3072    2    2 : tunables   24   12    8 : slabdata      1      1      0
biovec-128             2      5   1536    5    2 : tunables   24   12    8 : slabdata      1      1      0
biovec-64              2      5    768    5    1 : tunables   54   27    8 : slabdata      1      1      0
biovec-16              2     20    192   20    1 : tunables  120   60    8 : slabdata      1      1      0
biovec-4               2     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
biovec-1              60    203     16  203    1 : tunables  120   60    8 : slabdata      1      1      0
bio                   63    177     64   59    1 : tunables  120   60    8 : slabdata      3      3     15
sock_inode_cache      81     81    448    9    1 : tunables   54   27    8 : slabdata      9      9      0
skbuff_fclone_cache     36     36    320   12    1 : tunables   54   27    8 : slabdata      3      3      0
skbuff_head_cache    144    288    160   24    1 : tunables  120   60    8 : slabdata     12     12      0
file_lock_cache        5     36    108   36    1 : tunables  120   60    8 : slabdata      1      1      0
Acpi-Operand         549    644     40   92    1 : tunables  120   60    8 : slabdata      7      7      0
Acpi-ParseExt          0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Parse             0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-State             0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Namespace       231    338     20  169    1 : tunables  120   60    8 : slabdata      2      2      0
proc_inode_cache  270096 270120    396   10    1 : tunables   54   27    8 : slabdata  27012  27012      0
sigqueue               5     27    144   27    1 : tunables  120   60    8 : slabdata      1      1      0
radix_tree_node     5053   5070    288   13    1 : tunables   54   27    8 : slabdata    390    390      0
bdev_cache             4      7    544    7    1 : tunables   54   27    8 : slabdata      1      1      0
sysfs_dir_cache     3403   3444     44   84    1 : tunables  120   60    8 : slabdata     41     41      0
mnt_cache             16     30    128   30    1 : tunables  120   60    8 : slabdata      1      1      0
inode_cache         3047   3060    380   10    1 : tunables   54   27    8 : slabdata    306    306      0
dentry            693774 693784    140   28    1 : tunables  120   60    8 : slabdata  24778  24778      0
filp                 504   1176    160   24    1 : tunables  120   60    8 : slabdata     49     49      0
names_cache            6      6   4096    1    1 : tunables   24   12    8 : slabdata      6      6      0
idr_layer_cache       80     87    136   29    1 : tunables  120   60    8 : slabdata      3      3      0
buffer_head        38402  38520     52   72    1 : tunables  120   60    8 : slabdata    535    535      0
mm_struct             71     96    480    8    1 : tunables   54   27    8 : slabdata     12     12      0
vm_area_struct      2629   3910     84   46    1 : tunables  120   60    8 : slabdata     85     85      0
fs_cache              49    177     64   59    1 : tunables  120   60    8 : slabdata      3      3      0
files_cache           71    100    384   10    1 : tunables   54   27    8 : slabdata     10     10      0
signal_cache          70    117    416    9    1 : tunables   54   27    8 : slabdata     13     13      0
sighand_cache         71     81   1344    3    1 : tunables   24   12    8 : slabdata     27     27      0
task_struct          104    125   1392    5    2 : tunables   24   12    8 : slabdata     25     25      0
anon_vma             501    725     24  145    1 : tunables  120   60    8 : slabdata      5      5      0
pid_namespace          0      0     36  101    1 : tunables  120   60    8 : slabdata      0      0      0
pid_1                159    236     64   59    1 : tunables  120   60    8 : slabdata      4      4      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             1      1  32768    1    8 : tunables    8    4    0 : slabdata      1      1      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384             0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192              2      2   8192    1    2 : tunables    8    4    0 : slabdata      2      2      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
size-4096             11     11   4096    1    1 : tunables   24   12    8 : slabdata     11     11      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
size-2048            204    212   2048    2    1 : tunables   24   12    8 : slabdata    106    106      6
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
size-1024            154    160   1024    4    1 : tunables   54   27    8 : slabdata     40     40      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
size-512             400    440    512    8    1 : tunables   54   27    8 : slabdata     55     55      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
size-256             324    390    256   15    1 : tunables  120   60    8 : slabdata     26     26      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
size-32             3315   3503     32  113    1 : tunables  120   60    8 : slabdata     31     31      0
size-128             607    720    128   30    1 : tunables  120   60    8 : slabdata     24     24      0
size-64             2445   2537     64   59    1 : tunables  120   60    8 : slabdata     43     43      0
kmem_cache           129    200     96   40    1 : tunables  120   60    8 : slabdata      5      5      0

CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_SUPPORTS_OPROFILE=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_LOG_BUF_SHIFT=15
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_USER_SCHED=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
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
CONFIG_SLAB=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_BLOCK=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_MPENTIUMIII=y
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
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_NR_CPUS=2
CONFIG_PREEMPT_NONE=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_VM86=y
CONFIG_X86_CPUID=y
CONFIG_HIGHMEM4G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
CONFIG_IRQBALANCE=y
CONFIG_SECCOMP=y
CONFIG_HZ_250=y
CONFIG_HZ=250
CONFIG_PHYSICAL_START=0x100000
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_PM=y
CONFIG_SUSPEND_SMP_POSSIBLE=y
CONFIG_HIBERNATION_SMP_POSSIBLE=y
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_PCI=y
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_NET_KEY=y
CONFIG_INET=y
CONFIG_IP_FIB_HASH=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_PNP=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=8192
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_MISC_DEVICES=y
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDEFLOPPY=y
CONFIG_IDE_PROC_FS=y
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_IDE_ARCH_OBSOLETE_INIT=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
CONFIG_INPUT=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_UINPUT=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_RTC=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_PIIX4=y
CONFIG_POWER_SUPPLY=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_W83781D=y
CONFIG_SSB_POSSIBLE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_HID_SUPPORT=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_VIRTUALIZATION=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
CONFIG_FS_POSIX_ACL=y
CONFIG_DNOTIFY=y
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_SMB_FS=y
CONFIG_CIFS=y
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="cp437"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_INSTRUMENTATION=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_FORCED_INLINING=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_HW=y
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC32=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

-- 
Burton Windle                           bwindle@fint.org

