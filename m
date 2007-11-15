Return-Path: <linux-kernel-owner+w=401wt.eu-S933163AbXKOU5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbXKOU5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932800AbXKOU52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:57:28 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36299
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbXKOU50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:57:26 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg KH <greg@kroah.com>
Subject: Re: User Mode Linux still broken in 2.6.23.1
Date: Thu, 15 Nov 2007 14:57:21 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       akpm@linux-foundation.org, Chris Wright <chrisw@sous-sol.org>
References: <200711032351.52977.rob@landley.net> <200711142358.16072.rob@landley.net> <20071115060255.GA4837@kroah.com>
In-Reply-To: <20071115060255.GA4837@kroah.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_yKLPHrLCqfyToQZ"
Message-Id: <200711151457.22395.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_yKLPHrLCqfyToQZ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Thursday 15 November 2007 00:02:55 Greg KH wrote:
> On Wed, Nov 14, 2007 at 11:58:15PM -0600, Rob Landley wrote:
> > On Wednesday 14 November 2007 12:54:44 Greg KH wrote:
> > > On Sat, Nov 03, 2007 at 11:51:50PM -0500, Rob Landley wrote:
> > > > Building with the attached .config on x86-64, it does this:
> > > >
> > > >   CC      arch/um/kernel/smp.o
> > > > In file included from include/asm/arch/tlb.h:11,
> > > >                  from include/asm/tlb.h:4,
> > > >                  from arch/um/kernel/smp.c:8:
> > > > include/asm-generic/tlb.h: In function ???tlb_flush_mmu???:
> > > > include/asm-generic/tlb.h:76: error: implicit declaration of function
> > > > ???release_pages??? include/asm-generic/tlb.h: In function
> > > > ???tlb_remove_page???:
> > > > include/asm-generic/tlb.h:105: error: implicit declaration of
> > > > function ???page_cache_release??? make[1]: *** [arch/um/kernel/smp.o]
> > > > Error 1 make: *** [arch/um/kernel] Error 2
> > > >
> > > > I've been doing the following to fix it.  I know it's not the right
> > > > fix, (see the earlier thread about it at
> > > > http://lkml.org/lkml/2007/8/24/441 ) but could the one line fix go
> > > > into the -stable queue 2.6.23 while a proper fix goes into 2.6.24?
> > >
> > > I think the patches that I have just added to the stable queue for
> > > 2.6.23.2 will fix this.  If not, please let me know after testing.
> >
> > Where do I find these patches to test?  I know where to find the stable
> > releases, but not the "stable queue".
> >
> > Documentation/stable_kernel_rules.txt just says there _is_ a stable
> > queue, not where to access it.  Google's first hit for "linux stable
> > queue" was
> > http://git.kernel.org/?p=linux/kernel/git/chrisw/stable-queue.git;a=short
> >log which apparently stopped updating in march...
> >
> > Happy to test the patch you mentioned, if I can figure out where to find
> > it...
>
> It's at:
> 	http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=summar
>y
>
> Chris and I used to have separate queues, but that got messy, I suppose
> we should just delete those old copies...

In a freshly extracted 2.6.23 tarball, I applied the 4 uml-*.patch files from 
stable-queue/review-2.6.23-2 in sequence (all applied cleanly), and then did 
the following:

cat > mini.conf << EOF &&
CONFIG_BINFMT_ELF=y
CONFIG_HOSTFS=y
CONFIG_LBD=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_STDERR_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_EXT2_FS=y
EOF
make ARCH=um allnoconfig KCONFIG_ALLCONFIG=mini.conf 

Then I did:

make -j 2 ARCH=um

And it still breaks:

  CC      arch/um/kernel/smp.o
In file included from include/asm/arch/tlb.h:11,
                 from include/asm/tlb.h:4,
                 from arch/um/kernel/smp.c:8:
include/asm-generic/tlb.h: In function ‘tlb_flush_mmu’:
include/asm-generic/tlb.h:76: error: implicit declaration of 
function ‘release_pages’
include/asm-generic/tlb.h: In function ‘tlb_remove_page’:
include/asm-generic/tlb.h:105: error: implicit declaration of 
function ‘page_cache_release’
make[1]: *** [arch/um/kernel/smp.o] Error 1
make: *** [arch/um/kernel] Error 2
make: *** Waiting for unfinished jobs....

My .config is attached.

> thanks,
>
> greg k-h

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

--Boundary-00=_yKLPHrLCqfyToQZ
Content-Type: text/plain;
  charset="utf-8";
  name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23
# Thu Nov 15 14:53:40 2007
#
CONFIG_DEFCONFIG_LIST="arch/$ARCH/defconfig"
CONFIG_GENERIC_HARDIRQS=y
CONFIG_UML=y
CONFIG_MMU=y
CONFIG_NO_IOMEM=y
# CONFIG_TRACE_IRQFLAGS_SUPPORT is not set
CONFIG_LOCKDEP_SUPPORT=y
# CONFIG_STACKTRACE_SUPPORT is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_BUG=y
CONFIG_IRQ_RELEASE_METHOD=y

#
# UML-specific options
#
# CONFIG_STATIC_LINK is not set
CONFIG_MODE_SKAS=y
CONFIG_UML_X86=y
CONFIG_64BIT=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_TOP_ADDR=0x80000000
CONFIG_3_LEVEL_PGTABLES=y
CONFIG_STUB_CODE=0x7fbfffe000
CONFIG_STUB_DATA=0x7fbffff000
CONFIG_STUB_START=0x7fbfffe000
# CONFIG_ARCH_HAS_SC_SIGNALS is not set
# CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA is not set
CONFIG_SMP_BROKEN=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_LD_SCRIPT_DYN=y
# CONFIG_NET is not set
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
CONFIG_HOSTFS=y
# CONFIG_MCONSOLE is not set
CONFIG_NEST_LEVEL=0
CONFIG_KERNEL_STACK_ORDER=1
# CONFIG_UML_REAL_TIME_CLOCK is not set

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=128
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
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
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set

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
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_UBD is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_MMAPPER is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_RAM is not set

#
# Character Devices
#
CONFIG_STDERR_CONSOLE=y
CONFIG_STDIO_CONSOLE=y
# CONFIG_SSL is not set
# CONFIG_NULL_CHAN is not set
# CONFIG_PORT_CHAN is not set
# CONFIG_PTY_CHAN is not set
# CONFIG_TTY_CHAN is not set
# CONFIG_XTERM_CHAN is not set
CONFIG_NOCONFIG_CHAN=y
CONFIG_CON_ZERO_CHAN="fd:0,fd:1"
CONFIG_CON_CHAN="xterm"
CONFIG_SSL_CHAN="pty"
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_WATCHDOG is not set
# CONFIG_UML_SOUND is not set
# CONFIG_SOUND is not set
# CONFIG_HOSTAUDIO is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_UML_RANDOM is not set

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
# CONFIG_FW_LOADER is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Networking
#

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
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
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y

#
# Miscellaneous filesystems
#
# CONFIG_HFSPLUS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

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
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_CRYPTO is not set

#
# Library routines
#
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
# CONFIG_CRC32 is not set
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_DMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_MD is not set
# CONFIG_INPUT is not set

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_STACK_USAGE is not set

--Boundary-00=_yKLPHrLCqfyToQZ--
