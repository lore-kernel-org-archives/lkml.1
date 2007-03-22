Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbXCVXA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbXCVXA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 19:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXCVXA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 19:00:56 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:48136 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbXCVXAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 19:00:54 -0400
Date: Fri, 23 Mar 2007 00:01:00 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reject taskset for kernel threads
Message-ID: <20070322230100.GA13963@aepfle.de>
References: <20070321205353.GA32529@aepfle.de> <20070321145027.c76121dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070321145027.c76121dc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, Andrew Morton wrote:

> Why does the kernel oops?

Attached is a .config and helper scripts for a minimal pseries netboot
zImage. Crashes in the second iteration.

Does it work on other archs?



        init.sh referenced in initramfs.txt below

#!/bin/bash
mount -nv -t proc proc /proc
numcpus=`grep -Ec '^cpu[0-9]' /proc/stat || echo 1`
while true
do
	forked=
	john=
	for i in `seq 1 $numcpus`
	do
		echo $i
		bash -c 'declare -i x=1 ; while test $x != 0 ; do : $(( x++ )) ; done' &
		forked="$forked $!"
	done
	echo "forked $forked"
	nice -n -19 bash -c 'declare -i x=1 ; while test $x != 0 ; do : $(( x++ )) ; done' &
	john=$!
	sleep 3
	ls -A /proc/*/task | grep -v ^/ | xargs echo | xargs -n1 taskset -pc 2-$numcpus
	taskset -pc 1 $$
	taskset -pc 0 $john
	sleep 2
	kill $forked $john
	ls -A /proc/*/task | grep -v ^/ | xargs echo | xargs -n1 taskset -pc 0-$numcpus
done


        initramfs.txt referenced in .config below

# A simple initramfs
dir /dev 0755 0 0
nod /dev/console 0600 0 0 c 5 1
nod /dev/kmsg 0600 0 0 c 1 11
nod /dev/null 0600 0 0 c 1 3
dir /proc 0755 0 0
dir /bin 0755 0 0
dir /lib 0755 0 0
dir /lib64 0755 0 0
file /init /somewhere/init.sh 0755 0 0
#optional:
file /bin/bash /bin/bash 0755 0 0
file /bin/echo /bin/echo 0755 0 0
file /bin/taskset /usr/bin/taskset 0755 0 0
file /bin/grep /bin/grep 0755 0 0
file /bin/mount /bin/mount 0755 0 0
file /bin/seq /usr/bin/seq 0755 0 0
file /bin/nice /usr/bin/nice 0755 0 0
file /bin/ls /bin/ls 0755 0 0
file /bin/xargs /usr/bin/xargs 0755 0 0
file /bin/sleep /bin/sleep 0755 0 0
file /bin/kill /bin/kill 0755 0 0
file /bin/ln /bin/ln 0755 0 0

file /lib/ld.so.1 /lib/ld.so.1 0755 0 0
file /lib/libacl.so.1 /lib/libacl.so.1 0755 0 0
file /lib/libattr.so.1 /lib/libattr.so.1 0755 0 0
file /lib/libc.so.6 /lib/libc.so.6 0755 0 0
file /lib/libm.so.6 /lib/libm.so.6 0755 0 0
file /lib/libpthread.so.0 /lib/libpthread.so.0 0755 0 0
file /lib/librt.so.1 /lib/librt.so.1 0755 0 0
file /lib64/ld64.so.1 /lib64/ld64.so.1 0755 0 0
file /lib64/libc.so.6 /lib64/libc.so.6 0755 0 0
file /lib64/libdl.so.2 /lib64/libdl.so.2 0755 0 0
file /lib64/libhistory.so.5 /lib64/libhistory.so.5 0755 0 0
file /lib64/libncurses.so.5 /lib64/libncurses.so.5 0755 0 0
file /lib64/libreadline.so.5 /lib64/libreadline.so.5 0755 0 0


#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.21-rc4-git5
# Thu Mar 22 23:48:43 2007
#
CONFIG_PPC64=y
CONFIG_64BIT=y
CONFIG_PPC_MERGE=y
CONFIG_MMU=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_IRQ_PER_CPU=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_ILOG2_U32=y
CONFIG_ARCH_HAS_ILOG2_U64=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_PPC=y
CONFIG_EARLY_PRINTK=y
CONFIG_COMPAT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_PPC_OF=y
CONFIG_PPC_UDBG_16550=y
# CONFIG_GENERIC_TBSYNC is not set
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_DEFAULT_UIMAGE is not set

#
# Processor support
#
CONFIG_POWER4_ONLY=y
CONFIG_POWER4=y
CONFIG_PPC_FPU=y
# CONFIG_PPC_DCR_NATIVE is not set
# CONFIG_PPC_DCR_MMIO is not set
# CONFIG_PPC_OF_PLATFORM_PCI is not set
# CONFIG_ALTIVEC is not set
CONFIG_PPC_STD_MMU=y
# CONFIG_VIRT_CPU_ACCOUNTING is not set
CONFIG_SMP=y
CONFIG_NR_CPUS=128
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION="-ppc64-taskset"
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_UTS_NS is not set
# CONFIG_IKCONFIG is not set
# CONFIG_CPUSETS is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE="/somewhere/initramfs.txt"
CONFIG_INITRAMFS_ROOT_UID=0
CONFIG_INITRAMFS_ROOT_GID=0
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
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
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_SLOB is not set

#
# Loadable module support
#
# CONFIG_MODULES is not set

#
# Block layer
#
# CONFIG_BLOCK is not set

#
# Platform support
#
CONFIG_PPC_MULTIPLATFORM=y
# CONFIG_EMBEDDED6xx is not set
# CONFIG_APUS is not set
CONFIG_PPC_PSERIES=y
# CONFIG_PPC_ISERIES is not set
# CONFIG_PPC_MPC52xx is not set
# CONFIG_PPC_MPC5200 is not set
# CONFIG_PPC_PMAC is not set
# CONFIG_PPC_MAPLE is not set
# CONFIG_PPC_PASEMI is not set
# CONFIG_PPC_CELL is not set
# CONFIG_PPC_CELL_NATIVE is not set
# CONFIG_PPC_IBM_CELL_BLADE is not set
# CONFIG_PPC_PS3 is not set
# CONFIG_PPC_CELLEB is not set
CONFIG_PPC_NATIVE=y
# CONFIG_UDBG_RTAS_CONSOLE is not set
CONFIG_XICS=y
# CONFIG_U3_DART is not set
CONFIG_PPC_RTAS=y
CONFIG_RTAS_ERROR_LOGGING=y
# CONFIG_RTAS_PROC is not set
# CONFIG_MMIO_NVRAM is not set
CONFIG_IBMVIO=y
# CONFIG_IBMEBUS is not set
# CONFIG_PPC_MPC106 is not set
# CONFIG_PPC_970_NAP is not set
# CONFIG_PPC_INDIRECT_IO is not set
# CONFIG_GENERIC_IOMAP is not set
# CONFIG_CPU_FREQ is not set
# CONFIG_WANT_EARLY_SERIAL is not set
CONFIG_MPIC=y

#
# Kernel options
#
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
CONFIG_FORCE_MAX_ZONEORDER=13
CONFIG_IOMMU_VMERGE=y
# CONFIG_HOTPLUG_CPU is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_IRQ_ALL_CPUS=y
CONFIG_PPC_SPLPAR=y
# CONFIG_EEH is not set
# CONFIG_LPARCFG is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_PPC_64K_PAGES is not set
CONFIG_SCHED_SMT=y
CONFIG_PROC_DEVICETREE=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE="quiet panic=2"
# CONFIG_PM is not set
# CONFIG_SECCOMP is not set
CONFIG_ISA_DMA_API=y

#
# Bus options
#
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
# CONFIG_MPIC_WEIRD is not set
CONFIG_PPC_I8259=y
# CONFIG_PPC_INDIRECT_PCI is not set
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_DEBUG is not set

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set

#
# PCI Hotplug Support
#
# CONFIG_HOTPLUG_PCI is not set
CONFIG_KERNEL_START=0xc000000000000000

#
# Networking
#
# CONFIG_NET is not set

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

#
# Connector - unified userspace <-> kernelspace linker
#

#
# Memory Technology Devices (MTD)
#
# CONFIG_MTD is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play support
#
# CONFIG_PNPACPI is not set

#
# Misc devices
#
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set

#
# SCSI device support
#
# CONFIG_SCSI_NETLINK is not set

#
# Serial ATA (prod) and Parallel ATA (experimental) drivers
#

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set

#
# Macintosh device drivers
#
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_WINDFARM is not set

#
# ISDN subsystem
#

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set

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
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_ICOM is not set
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_CONSOLE=y
# CONFIG_HVC_RTAS is not set
# CONFIG_HVCS is not set

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set

#
# Watchdog Cards
#
# CONFIG_WATCHDOG is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_GEN_RTC is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_HANGCHECK_TIMER is not set

#
# TPM devices
#
# CONFIG_TCG_TPM is not set

#
# I2C support
#
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set

#
# Hardware Monitoring support
#
# CONFIG_HWMON is not set
# CONFIG_HWMON_VID is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set

#
# Digital Video Broadcasting Devices
#

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_FB is not set
# CONFIG_FB_IBM_GXT4500 is not set

#
# Console display driver support
#
# CONFIG_VGA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set

#
# HID Devices
#
# CONFIG_HID is not set

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
# CONFIG_USB is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set

#
# MMC/SD Card support
#
# CONFIG_MMC is not set

#
# LED devices
#
# CONFIG_NEW_LEDS is not set

#
# LED drivers
#

#
# LED Triggers
#

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#

#
# Real Time Clock
#
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
# Auxiliary Display support
#

#
# Virtualization
#

#
# File systems
#
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_DNOTIFY is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_SYSCTL is not set
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

#
# Native Language Support
#
# CONFIG_NLS is not set

#
# Library routines
#
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC32 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y

#
# Instrumentation Support
#
# CONFIG_PROFILING is not set

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOG_BUF_SHIFT=21
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_DEBUG_KOBJECT=y
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_LIST=y
CONFIG_FORCED_INLINING=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUGGER=y
CONFIG_XMON=y
CONFIG_XMON_DEFAULT=y
CONFIG_XMON_DISASSEMBLY=y
CONFIG_IRQSTACKS=y
# CONFIG_BOOTX_TEXT is not set
# CONFIG_PPC_EARLY_DEBUG is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set

#
# Cryptographic options
#
# CONFIG_CRYPTO is not set
