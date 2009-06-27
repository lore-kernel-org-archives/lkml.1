Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZF0XI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZF0XI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 19:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZF0XIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 19:08:20 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:60409
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZF0XIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 19:08:19 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org, jk@ozlabs.org, benh@kernel.crashing.org
Subject: Can't boot 2.6.30 powerpc kernel under qemu.
Date: Sat, 27 Jun 2009 18:08:10 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_cZqRKH9ItqrdES6"
Message-Id: <200906271808.12168.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_cZqRKH9ItqrdES6
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The 2.6.29 kernel booted just fine (and 2.6.28, and 2.6.27...), but the 2.6.30 
kernel does this right after openbios hands over control:

  invalid/unsupported opcode: 00 - 12 - 00 (00009024) 0000938c 0

Which is usually qemu's way of saying "code jumped off into la-la land".

I bisected the problem in the linux kernel repository, and wound up here:

60ee031940c1b09c137b617a8829e2f081961fe0 is first bad commit
commit 60ee031940c1b09c137b617a8829e2f081961fe0
Author: Jeremy Kerr <jk@ozlabs.org>
Date:   Tue Feb 17 11:44:14 2009 +1100

    powerpc/spufs: Use correct return value for spu_handle_mm_fault
    
    Currently, spu_handle_mm_fault disregards the 'ret' variable and always
    returns -EFAULT on error.
    
    This change refactos spu_handle_mm_fault a little, to return the
    ret variable as appropriate. This allows us to combine the error and
    sucess paths.
    
    Also, remove the #if-0-ed IS_VALID_EA() check, it has never been
    used.
    
    Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

I'm building the kernel with the attached .config, and booting qemu with:

qemu-system-ppc -M g3beige -nographic -no-reboot -kernel "zImage-powerpc" -hda
  "image-powerpc.sqf" -append "root=/dev/hda rw init=/usr/sbin/init.sh panic=1
  PATH=/usr/bin console=ttyS0"

Here's a simpler qemu invocation so you don't need a root filesystem image to 
test it.  (If you get bootup messages on stdout, it's working, and if you get 
an unsupported opcode message right after openbios hands over control, it's 
not):

qemu-system-ppc -nographic -no-reboot -kernel zImage-powerpc \
  -hda /dev/null -append "panic=1 console=ttyS0"

I'm testing with qemu svn 6657 (which is now qemu git 2d18e637e5ec), which is 
the last version in the repository before some unrelated openbios changes 
started a series of bugs that haven't quite been resolved yet.  You can use 
the v0.10.0 release if you prefer, but you'll have to update the openbios-ppc 
image to the one from svn 6657.

I'm stumped.  Help?

Thanks,

Rob

P.S.  Is there a powerpc list I should have cc:'d this to?  vger.kernel.org 
just has kvm-ppc, no other "ppc" or "power".  Google suggests ozlabs, but 
their mailing lists only see to have cell, which this isn't...
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds

--Boundary-00=_cZqRKH9ItqrdES6
Content-Type: text/plain;
  charset="UTF-8";
  name="config-linux"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="config-linux"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc5
# Sat Jun 27 16:46:39 2009
#
# CONFIG_PPC64 is not set

#
# Processor support
#
CONFIG_6xx=y
# CONFIG_PPC_85xx is not set
# CONFIG_PPC_8xx is not set
# CONFIG_40x is not set
# CONFIG_44x is not set
# CONFIG_E200 is not set
CONFIG_PPC_FPU=y
CONFIG_ALTIVEC=y
CONFIG_PPC_STD_MMU=y
CONFIG_PPC_STD_MMU_32=y
# CONFIG_PPC_MM_SLICES is not set
# CONFIG_SMP is not set
CONFIG_PPC32=y
CONFIG_WORD_SIZE=32
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_MMU=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_HARDIRQS=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
CONFIG_IRQ_PER_CPU=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_ILOG2_U32=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
# CONFIG_ARCH_NO_VIRT_TO_BUS is not set
CONFIG_PPC=y
CONFIG_EARLY_PRINTK=y
CONFIG_GENERIC_NVRAM=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_PPC_OF=y
CONFIG_OF=y
# CONFIG_PPC_UDBG_16550 is not set
# CONFIG_GENERIC_TBSYNC is not set
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_DEFAULT_UIMAGE is not set
CONFIG_HIBERNATE_32=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_PPC_DCR_NATIVE is not set
# CONFIG_PPC_DCR_MMIO is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
# CONFIG_FREEZER is not set

#
# Platform support
#
CONFIG_PPC_MULTIPLATFORM=y
CONFIG_CLASSIC32=y
# CONFIG_PPC_CHRP is not set
# CONFIG_MPC5121_ADS is not set
# CONFIG_MPC5121_GENERIC is not set
# CONFIG_PPC_MPC52xx is not set
CONFIG_PPC_PMAC=y
# CONFIG_PPC_CELL is not set
# CONFIG_PPC_CELL_NATIVE is not set
# CONFIG_PPC_82xx is not set
# CONFIG_PQ2ADS is not set
# CONFIG_PPC_83xx is not set
# CONFIG_PPC_86xx is not set
# CONFIG_EMBEDDED6xx is not set
# CONFIG_AMIGAONE is not set
CONFIG_PPC_NATIVE=y
# CONFIG_IPIC is not set
CONFIG_MPIC=y
# CONFIG_MPIC_WEIRD is not set
# CONFIG_PPC_I8259 is not set
# CONFIG_PPC_RTAS is not set
# CONFIG_MMIO_NVRAM is not set
CONFIG_PPC_MPC106=y
# CONFIG_PPC_970_NAP is not set
# CONFIG_PPC_INDIRECT_IO is not set
# CONFIG_GENERIC_IOMAP is not set
# CONFIG_CPU_FREQ is not set
CONFIG_PPC601_SYNC_FIX=y
# CONFIG_TAU is not set
# CONFIG_FSL_ULI1575 is not set
# CONFIG_SIMPLE_GPIO is not set

#
# Kernel options
#
CONFIG_HIGHMEM=y
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_IOMMU_HELPER is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_HAS_WALK_MEMORY=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_MIGRATION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_PPC_4K_PAGES=y
# CONFIG_PPC_16K_PAGES is not set
# CONFIG_PPC_64K_PAGES is not set
CONFIG_FORCE_MAX_ZONEORDER=11
CONFIG_PROC_DEVICETREE=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_EXTRA_TARGETS=""
CONFIG_ARCH_WANTS_FREEZER_CONTROL=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_SECCOMP=y
CONFIG_ISA_DMA_API=y

#
# Bus options
#
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_PPC_INDIRECT_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_SYSCALL=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_STUB is not set
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_HAS_RAPIDIO is not set

#
# Advanced setup
#
CONFIG_ADVANCED_OPTIONS=y
# CONFIG_LOWMEM_SIZE_BOOL is not set
CONFIG_LOWMEM_SIZE=0x30000000
CONFIG_LOWMEM_CAM_NUM=3
# CONFIG_PAGE_OFFSET_BOOL is not set
CONFIG_PAGE_OFFSET=0xc0000000
# CONFIG_KERNEL_START_BOOL is not set
CONFIG_KERNEL_START=0xc0000000
CONFIG_PHYSICAL_START=0x00000000
# CONFIG_TASK_SIZE_BOOL is not set
CONFIG_TASK_SIZE=0xc0000000
CONFIG_NET=y

#
# Networking options
#
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
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
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=y
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_MAC_FLOPPY is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_TIMINGS=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SL82C105 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDE_PMAC=y
# CONFIG_BLK_DEV_IDE_PMAC_ATA100FIRST is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
# CONFIG_IEEE1394_PCILYNX is not set

#
# SBP-2 support (for storage devices) requires SCSI
#
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
CONFIG_IEEE1394_RAWIO=y
CONFIG_IEEE1394_VIDEO1394=y
CONFIG_IEEE1394_DV1394=y
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_ADB=y
CONFIG_ADB_CUDA=y
CONFIG_ADB_PMU=y
# CONFIG_ADB_PMU_LED is not set
# CONFIG_PMAC_APM_EMU is not set
# CONFIG_PMAC_MEDIABAY is not set
# CONFIG_INPUT_ADBHID is not set
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_THERM_WINDTUNNEL is not set
# CONFIG_THERM_ADT746X is not set
# CONFIG_WINDFARM is not set
# CONFIG_ANSLCD is not set
# CONFIG_PMAC_RACKMETER is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_MACE=y
# CONFIG_MACE_AAUI_PORT is not set
CONFIG_BMAC=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
CONFIG_ATL2=y
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_IWLWIFI_LEDS is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
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
CONFIG_SERIO=y
# CONFIG_SERIO_I8042 is not set
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_PCIPS2 is not set
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_XILINX_XPS_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_PMACZILOG=y
CONFIG_SERIAL_PMACZILOG_TTYS=y
CONFIG_SERIAL_PMACZILOG_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=8
# CONFIG_HVC_UDBG is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_NVRAM is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_TCG_TPM is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
# CONFIG_I2C_ALGOBIT is not set
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# Mac SMBus host controller drivers
#
CONFIG_I2C_POWERMAC=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_MPC is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
# CONFIG_THERMAL_HWMON is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_PCF50633 is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
# CONFIG_VGA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
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
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
# CONFIG_NLS is not set
# CONFIG_DLM is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_LAST_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_HAVE_LMB=y

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y

#
# Tracers
#
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_PRINT_STACK_DEPTH=64
# CONFIG_IRQSTACKS is not set
CONFIG_BOOTX_TEXT=y
# CONFIG_PPC_EARLY_DEBUG is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
# CONFIG_CRYPTO_MANAGER is not set
# CONFIG_CRYPTO_MANAGER2 is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
# CONFIG_PPC_CLOCK is not set
# CONFIG_VIRTUALIZATION is not set

--Boundary-00=_cZqRKH9ItqrdES6--
