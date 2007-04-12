Return-Path: <linux-kernel-owner+w=401wt.eu-S1030611AbXDLRua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030611AbXDLRua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030621AbXDLRu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:50:29 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:30292 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030611AbXDLRu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:50:26 -0400
Date: Thu, 12 Apr 2007 12:46:23 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@localhost.localdomain
To: Linus Torvalds <torvalds@osdl.org>
cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Vitaly Bordug <vbordug@ru.mvista.com>
Subject: Please pull from 'for_linus' branch
Message-ID: <Pine.LNX.4.64.0704121243550.1982@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for_linus' branch at

	master.kernel.org:/pub/scm/linux/kernel/git/galak/powerpc.git for_linus

These are some compile fixes for 2.6.21 related to arch/ppc.

(Hopefully this pull request is formatted to 'your anal and grumpy kernel
maintainer' desire :)

to receive the following updates:

 arch/ppc/8xx_io/commproc.c            |   26 +
 arch/ppc/configs/ads8272_defconfig    |  592 ++++++++++++++++++++++++++--------
 arch/ppc/platforms/mpc8272ads_setup.c |   17
 arch/ppc/platforms/mpc866ads_setup.c  |   17
 arch/ppc/platforms/mpc885ads_setup.c  |   20 -
 5 files changed, 524 insertions(+), 148 deletions(-)

Vitaly Bordug (3):
      [PPC] MPC8272 ADS compile fixed, defconfig refreshed.
      [PPC] Fix compilation and linking errors of mpc885ads build.
      [PPC] Fix compilation and linking errors of mpc86xads build.

diff --git a/arch/ppc/8xx_io/commproc.c b/arch/ppc/8xx_io/commproc.c
index 3b23bcb..7a8722b 100644
--- a/arch/ppc/8xx_io/commproc.c
+++ b/arch/ppc/8xx_io/commproc.c
@@ -39,6 +39,21 @@
 #include <asm/tlbflush.h>
 #include <asm/rheap.h>

+#define immr_map(member)						\
+({									\
+	u32 offset = offsetof(immap_t, member);				\
+	void *addr = ioremap (IMAP_ADDR + offset,			\
+			      sizeof( ((immap_t*)0)->member));		\
+	addr;								\
+})
+
+#define immr_map_size(member, size)					\
+({									\
+	u32 offset = offsetof(immap_t, member);				\
+	void *addr = ioremap (IMAP_ADDR + offset, size);		\
+	addr;								\
+})
+
 static void m8xx_cpm_dpinit(void);
 static	uint	host_buffer;	/* One page of host buffer */
 static	uint	host_end;	/* end + 1 */
@@ -364,11 +379,16 @@ static rh_block_t cpm_boot_dpmem_rh_block[16];
 static rh_info_t cpm_dpmem_info;

 #define CPM_DPMEM_ALIGNMENT	8
+static u8* dpram_vbase;
+static uint dpram_pbase;

 void m8xx_cpm_dpinit(void)
 {
 	spin_lock_init(&cpm_dpmem_lock);

+	dpram_vbase = immr_map_size(im_cpm.cp_dpmem, CPM_DATAONLY_BASE + CPM_DATAONLY_SIZE);
+	dpram_pbase = (uint)&((immap_t *)IMAP_ADDR)->im_cpm.cp_dpmem;
+
 	/* Initialize the info header */
 	rh_init(&cpm_dpmem_info, CPM_DPMEM_ALIGNMENT,
 			sizeof(cpm_boot_dpmem_rh_block) /
@@ -442,3 +462,9 @@ void *cpm_dpram_addr(uint offset)
 	return ((immap_t *)IMAP_ADDR)->im_cpm.cp_dpmem + offset;
 }
 EXPORT_SYMBOL(cpm_dpram_addr);
+
+uint cpm_dpram_phys(u8* addr)
+{
+	return (dpram_pbase + (uint)(addr - dpram_vbase));
+}
+EXPORT_SYMBOL(cpm_dpram_phys);
diff --git a/arch/ppc/configs/ads8272_defconfig b/arch/ppc/configs/ads8272_defconfig
index d1db7d1..6619f91 100644
--- a/arch/ppc/configs/ads8272_defconfig
+++ b/arch/ppc/configs/ads8272_defconfig
@@ -1,42 +1,69 @@
 #
 # Automatically generated make config: don't edit
+# Linux kernel version: 2.6.21-rc5
+# Wed Apr  4 20:55:16 2007
 #
 CONFIG_MMU=y
+CONFIG_GENERIC_HARDIRQS=y
 CONFIG_RWSEM_XCHGADD_ALGORITHM=y
-CONFIG_HAVE_DEC_LOCK=y
+CONFIG_ARCH_HAS_ILOG2_U32=y
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_PPC=y
 CONFIG_PPC32=y
 CONFIG_GENERIC_NVRAM=y
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
+CONFIG_ARCH_MAY_HAVE_PC_FDC=y
+CONFIG_GENERIC_BUG=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

 #
 # Code maturity level options
 #
 CONFIG_EXPERIMENTAL=y
-CONFIG_CLEAN_COMPILE=y
-CONFIG_STANDALONE=y
 CONFIG_BROKEN_ON_SMP=y
+CONFIG_INIT_ENV_ARG_LIMIT=32

 #
 # General setup
 #
+CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
+# CONFIG_IPC_NS is not set
+CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_LOG_BUF_SHIFT=14
-# CONFIG_HOTPLUG is not set
 # CONFIG_IKCONFIG is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+# CONFIG_HOTPLUG is not set
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 # CONFIG_EPOLL is not set
-CONFIG_IOSCHED_NOOP=y
-CONFIG_IOSCHED_AS=y
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SHMEM=y
+CONFIG_SLAB=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_RT_MUTEXES=y
+# CONFIG_TINY_SHMEM is not set
+CONFIG_BASE_SMALL=0
+# CONFIG_SLOB is not set

 #
 # Loadable module support
@@ -44,66 +71,124 @@ CONFIG_IOSCHED_CFQ=y
 # CONFIG_MODULES is not set

 #
+# Block layer
+#
+CONFIG_BLOCK=y
+# CONFIG_LBD is not set
+# CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+CONFIG_IOSCHED_AS=y
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
 # Processor
 #
 CONFIG_6xx=y
 # CONFIG_40x is not set
 # CONFIG_44x is not set
-# CONFIG_POWER3 is not set
-# CONFIG_POWER4 is not set
 # CONFIG_8xx is not set
+# CONFIG_E200 is not set
+# CONFIG_E500 is not set
+CONFIG_PPC_FPU=y
+# CONFIG_PPC_DCR_NATIVE is not set
+# CONFIG_KEXEC is not set
 # CONFIG_CPU_FREQ is not set
+# CONFIG_WANT_EARLY_SERIAL is not set
 CONFIG_EMBEDDEDBOOT=y
 CONFIG_PPC_STD_MMU=y

 #
 # Platform options
 #
-# CONFIG_PPC_MULTIPLATFORM is not set
+
+#
+# Freescale Ethernet driver platform-specific options
+#
+# CONFIG_PPC_PREP is not set
 # CONFIG_APUS is not set
+# CONFIG_KATANA is not set
 # CONFIG_WILLOW is not set
-# CONFIG_PCORE is not set
+# CONFIG_CPCI690 is not set
 # CONFIG_POWERPMC250 is not set
-# CONFIG_EV64260 is not set
+# CONFIG_CHESTNUT is not set
 # CONFIG_SPRUCE is not set
+# CONFIG_HDPU is not set
+# CONFIG_EV64260 is not set
 # CONFIG_LOPEC is not set
-# CONFIG_MCPN765 is not set
 # CONFIG_MVME5100 is not set
 # CONFIG_PPLUS is not set
 # CONFIG_PRPMC750 is not set
 # CONFIG_PRPMC800 is not set
 # CONFIG_SANDPOINT is not set
-# CONFIG_ADIR is not set
-# CONFIG_K2 is not set
+# CONFIG_RADSTONE_PPC7D is not set
 # CONFIG_PAL4 is not set
-# CONFIG_GEMINI is not set
 # CONFIG_EST8260 is not set
 # CONFIG_SBC82xx is not set
 # CONFIG_SBS8260 is not set
-# CONFIG_RPX6 is not set
+# CONFIG_RPX8260 is not set
 # CONFIG_TQM8260 is not set
 CONFIG_ADS8272=y
+# CONFIG_PQ2FADS is not set
+# CONFIG_LITE5200 is not set
+# CONFIG_MPC834x_SYS is not set
+# CONFIG_EV64360 is not set
 CONFIG_PQ2ADS=y
 CONFIG_8260=y
 CONFIG_8272=y
 CONFIG_CPM2=y
 # CONFIG_PC_KEYBOARD is not set
-CONFIG_SERIAL_CONSOLE=y
 # CONFIG_SMP is not set
-# CONFIG_PREEMPT is not set
 # CONFIG_HIGHMEM is not set
-CONFIG_KERNEL_ELF=y
+CONFIG_ARCH_POPULATES_NODE_MAP=y
+# CONFIG_HZ_100 is not set
+CONFIG_HZ_250=y
+# CONFIG_HZ_300 is not set
+# CONFIG_HZ_1000 is not set
+CONFIG_HZ=250
+CONFIG_PREEMPT_NONE=y
+# CONFIG_PREEMPT_VOLUNTARY is not set
+# CONFIG_PREEMPT is not set
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
 CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 # CONFIG_CMDLINE_BOOL is not set
+# CONFIG_PM is not set
+CONFIG_SECCOMP=y
+CONFIG_ISA_DMA_API=y

 #
 # Bus options
 #
+CONFIG_ZONE_DMA=y
+# CONFIG_PPC_I8259 is not set
+CONFIG_PPC_INDIRECT_PCI=y
 CONFIG_PCI=y
 CONFIG_PCI_DOMAINS=y
-# CONFIG_PCI_LEGACY_PROC is not set
-# CONFIG_PCI_NAMES is not set
+CONFIG_PCI_8260=y
+
+#
+# PCCARD (PCMCIA/CardBus) support
+#

 #
 # Advanced setup
@@ -120,12 +205,110 @@ CONFIG_TASK_SIZE=0x80000000
 CONFIG_BOOT_LOAD=0x00400000

 #
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_NETDEBUG is not set
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+CONFIG_IP_PNP_BOOTP=y
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_IP_MROUTE is not set
+# CONFIG_ARPD is not set
+CONFIG_SYN_COOKIES=y
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+
+#
+# DCCP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_DCCP is not set
+
+#
+# SCTP Configuration (EXPERIMENTAL)
+#
+# CONFIG_IP_SCTP is not set
+
+#
+# TIPC Configuration (EXPERIMENTAL)
+#
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_IEEE80211 is not set
+
+#
 # Device Drivers
 #

 #
 # Generic Driver Options
 #
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+# CONFIG_SYS_HYPERVISOR is not set
+
+#
+# Connector - unified userspace <-> kernelspace linker
+#
+# CONFIG_CONNECTOR is not set

 #
 # Memory Technology Devices (MTD)
@@ -140,6 +323,7 @@ CONFIG_BOOT_LOAD=0x00400000
 #
 # Plug and Play support
 #
+# CONFIG_PNPACPI is not set

 #
 # Block devices
@@ -149,14 +333,23 @@ CONFIG_BOOT_LOAD=0x00400000
 # CONFIG_BLK_CPQ_CISS_DA is not set
 # CONFIG_BLK_DEV_DAC960 is not set
 # CONFIG_BLK_DEV_UMEM is not set
+# CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
 # CONFIG_BLK_DEV_NBD is not set
-# CONFIG_BLK_DEV_CARMEL is not set
+# CONFIG_BLK_DEV_SX8 is not set
 CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=32768
-CONFIG_BLK_DEV_INITRD=y
-# CONFIG_LBD is not set
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
+
+#
+# Misc devices
+#
+# CONFIG_SGI_IOC4 is not set
+# CONFIG_TIFM_CORE is not set

 #
 # ATA/ATAPI/MFM/RLL support
@@ -166,7 +359,14 @@ CONFIG_BLK_DEV_INITRD=y
 #
 # SCSI device support
 #
+# CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
+# CONFIG_SCSI_NETLINK is not set
+
+#
+# Serial ATA (prod) and Parallel ATA (experimental) drivers
+#
+# CONFIG_ATA is not set

 #
 # Multi-device support (RAID and LVM)
@@ -176,6 +376,7 @@ CONFIG_BLK_DEV_INITRD=y
 #
 # Fusion MPT device support
 #
+# CONFIG_FUSION is not set

 #
 # IEEE 1394 (FireWire) support
@@ -190,70 +391,12 @@ CONFIG_BLK_DEV_INITRD=y
 #
 # Macintosh device drivers
 #
+# CONFIG_MAC_EMUMOUSEBTN is not set
+# CONFIG_WINDFARM is not set

 #
-# Networking support
-#
-CONFIG_NET=y
-
-#
-# Networking options
+# Network device support
 #
-CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
-# CONFIG_NETLINK_DEV is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-CONFIG_IP_MULTICAST=y
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-CONFIG_IP_PNP_BOOTP=y
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_IP_MROUTE is not set
-# CONFIG_ARPD is not set
-CONFIG_SYN_COOKIES=y
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_IPV6 is not set
-# CONFIG_NETFILTER is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-# CONFIG_NET_HW_FLOWCONTROL is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -266,13 +409,31 @@ CONFIG_NETDEVICES=y
 # CONFIG_ARCNET is not set

 #
+# PHY device support
+#
+CONFIG_PHYLIB=y
+
+#
+# MII PHY device drivers
+#
+# CONFIG_MARVELL_PHY is not set
+CONFIG_DAVICOM_PHY=y
+# CONFIG_QSEMI_PHY is not set
+# CONFIG_LXT_PHY is not set
+# CONFIG_CICADA_PHY is not set
+# CONFIG_VITESSE_PHY is not set
+# CONFIG_SMSC_PHY is not set
+# CONFIG_BROADCOM_PHY is not set
+# CONFIG_FIXED_PHY is not set
+
+#
 # Ethernet (10 or 100Mbit)
 #
 CONFIG_NET_ETHERNET=y
-# CONFIG_MII is not set
-# CONFIG_OAKNET is not set
+CONFIG_MII=y
 # CONFIG_HAPPYMEAL is not set
 # CONFIG_SUNGEM is not set
+# CONFIG_CASSINI is not set
 # CONFIG_NET_VENDOR_3COM is not set

 #
@@ -281,6 +442,9 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_NET_TULIP is not set
 # CONFIG_HP100 is not set
 # CONFIG_NET_PCI is not set
+CONFIG_FS_ENET=y
+# CONFIG_FS_ENET_HAS_SCC is not set
+CONFIG_FS_ENET_HAS_FCC=y

 #
 # Ethernet (1000 Mbit)
@@ -292,14 +456,24 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_HAMACHI is not set
 # CONFIG_YELLOWFIN is not set
 # CONFIG_R8169 is not set
+# CONFIG_SIS190 is not set
+# CONFIG_SKGE is not set
+# CONFIG_SKY2 is not set
 # CONFIG_SK98LIN is not set
 # CONFIG_TIGON3 is not set
+# CONFIG_BNX2 is not set
+# CONFIG_QLA3XXX is not set
+# CONFIG_ATL1 is not set

 #
 # Ethernet (10000 Mbit)
 #
+# CONFIG_CHELSIO_T1 is not set
+# CONFIG_CHELSIO_T3 is not set
 # CONFIG_IXGB is not set
 # CONFIG_S2IO is not set
+# CONFIG_MYRI10GE is not set
+# CONFIG_NETXEN_NIC is not set

 #
 # Token Ring devices
@@ -321,6 +495,8 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set

 #
 # ISDN subsystem
@@ -336,6 +512,7 @@ CONFIG_NET_ETHERNET=y
 # Input device support
 #
 CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set

 #
 # Userland interfaces
@@ -347,14 +524,6 @@ CONFIG_INPUT=y
 # CONFIG_INPUT_EVBUG is not set

 #
-# Input I/O drivers
-#
-# CONFIG_GAMEPORT is not set
-CONFIG_SOUND_GAMEPORT=y
-# CONFIG_SERIO is not set
-# CONFIG_SERIO_I8042 is not set
-
-#
 # Input Device Drivers
 #
 # CONFIG_INPUT_KEYBOARD is not set
@@ -364,6 +533,12 @@ CONFIG_SOUND_GAMEPORT=y
 # CONFIG_INPUT_MISC is not set

 #
+# Hardware I/O ports
+#
+# CONFIG_SERIO is not set
+# CONFIG_GAMEPORT is not set
+
+#
 # Character devices
 #
 # CONFIG_VT is not set
@@ -377,10 +552,21 @@ CONFIG_SOUND_GAMEPORT=y
 #
 # Non-8250 serial port support
 #
+# CONFIG_SERIAL_UARTLITE is not set
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+CONFIG_SERIAL_CPM=y
+CONFIG_SERIAL_CPM_CONSOLE=y
+CONFIG_SERIAL_CPM_SCC1=y
+# CONFIG_SERIAL_CPM_SCC2 is not set
+# CONFIG_SERIAL_CPM_SCC3 is not set
+CONFIG_SERIAL_CPM_SCC4=y
+# CONFIG_SERIAL_CPM_SMC1 is not set
+# CONFIG_SERIAL_CPM_SMC2 is not set
+# CONFIG_SERIAL_JSM is not set
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
-# CONFIG_QIC02_TAPE is not set

 #
 # IPMI
@@ -391,29 +577,53 @@ CONFIG_LEGACY_PTY_COUNT=256
 # Watchdog Cards
 #
 # CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
 # CONFIG_NVRAM is not set
 CONFIG_GEN_RTC=y
 # CONFIG_GEN_RTC_X is not set
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
 # CONFIG_APPLICOM is not set
-
-#
-# Ftape, the floppy tape device driver
-#
-# CONFIG_FTAPE is not set
 # CONFIG_AGP is not set
 # CONFIG_DRM is not set
 # CONFIG_RAW_DRIVER is not set

 #
+# TPM devices
+#
+# CONFIG_TCG_TPM is not set
+
+#
 # I2C support
 #
 # CONFIG_I2C is not set

 #
-# Misc devices
+# SPI support
+#
+# CONFIG_SPI is not set
+# CONFIG_SPI_MASTER is not set
+
 #
+# Dallas's 1-wire bus
+#
+# CONFIG_W1 is not set
+
+#
+# Hardware Monitoring support
+#
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set

 #
 # Multimedia devices
@@ -428,7 +638,9 @@ CONFIG_GEN_RTC=y
 #
 # Graphics support
 #
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 # CONFIG_FB is not set
+# CONFIG_FB_IBM_GXT4500 is not set

 #
 # Sound
@@ -436,35 +648,110 @@ CONFIG_GEN_RTC=y
 # CONFIG_SOUND is not set

 #
+# HID Devices
+#
+CONFIG_HID=y
+# CONFIG_HID_DEBUG is not set
+
+#
 # USB support
 #
+CONFIG_USB_ARCH_HAS_HCD=y
+CONFIG_USB_ARCH_HAS_OHCI=y
+CONFIG_USB_ARCH_HAS_EHCI=y
 # CONFIG_USB is not set

 #
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
+
+#
 # USB Gadget Support
 #
 # CONFIG_USB_GADGET is not set

 #
+# MMC/SD Card support
+#
+# CONFIG_MMC is not set
+
+#
+# LED devices
+#
+# CONFIG_NEW_LEDS is not set
+
+#
+# LED drivers
+#
+
+#
+# LED Triggers
+#
+
+#
+# InfiniBand support
+#
+# CONFIG_INFINIBAND is not set
+
+#
+# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+#
+
+#
+# Real Time Clock
+#
+# CONFIG_RTC_CLASS is not set
+
+#
+# DMA Engine support
+#
+# CONFIG_DMA_ENGINE is not set
+
+#
+# DMA Clients
+#
+
+#
+# DMA Devices
+#
+
+#
+# Auxiliary Display support
+#
+
+#
+# Virtualization
+#
+
+#
 # File systems
 #
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
+# CONFIG_EXT2_FS_XIP is not set
 CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_XATTR=y
 # CONFIG_EXT3_FS_POSIX_ACL is not set
 # CONFIG_EXT3_FS_SECURITY is not set
+# CONFIG_EXT4DEV_FS is not set
 CONFIG_JBD=y
 # CONFIG_JBD_DEBUG is not set
 CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
+CONFIG_FS_POSIX_ACL=y
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
+CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set

 #
 # CD-ROM/DVD Filesystems
@@ -475,7 +762,8 @@ CONFIG_FS_MBCACHE=y
 #
 # DOS/FAT/NT Filesystems
 #
-# CONFIG_FAT_FS is not set
+# CONFIG_MSDOS_FS is not set
+# CONFIG_VFAT_FS is not set
 # CONFIG_NTFS_FS is not set

 #
@@ -483,12 +771,13 @@ CONFIG_FS_MBCACHE=y
 #
 CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
-# CONFIG_DEVFS_FS is not set
-# CONFIG_DEVPTS_FS_XATTR is not set
 CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
 CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set

 #
 # Miscellaneous filesystems
@@ -511,20 +800,26 @@ CONFIG_RAMFS=y
 # Network File Systems
 #
 CONFIG_NFS_FS=y
-# CONFIG_NFS_V3 is not set
-# CONFIG_NFS_V4 is not set
+CONFIG_NFS_V3=y
+CONFIG_NFS_V3_ACL=y
+CONFIG_NFS_V4=y
 # CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
-# CONFIG_EXPORTFS is not set
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_ACL_SUPPORT=y
+CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
-# CONFIG_RPCSEC_GSS_KRB5 is not set
+CONFIG_SUNRPC_GSS=y
+CONFIG_RPCSEC_GSS_KRB5=y
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
 # CONFIG_CIFS is not set
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
+# CONFIG_9P_FS is not set

 #
 # Partition Types
@@ -537,46 +832,99 @@ CONFIG_PARTITION_ADVANCED=y
 # CONFIG_MAC_PARTITION is not set
 # CONFIG_MSDOS_PARTITION is not set
 # CONFIG_LDM_PARTITION is not set
-# CONFIG_NEC98_PARTITION is not set
 # CONFIG_SGI_PARTITION is not set
 # CONFIG_ULTRIX_PARTITION is not set
 # CONFIG_SUN_PARTITION is not set
+# CONFIG_KARMA_PARTITION is not set
 # CONFIG_EFI_PARTITION is not set

 #
 # Native Language Support
 #
 # CONFIG_NLS is not set
+
+#
+# Distributed Lock Manager
+#
+# CONFIG_DLM is not set
 # CONFIG_SCC_ENET is not set
-CONFIG_FEC_ENET=y
-# CONFIG_USE_MDIO is not set
+# CONFIG_FEC_ENET is not set

 #
 # CPM2 Options
 #
-CONFIG_SCC_CONSOLE=y
-CONFIG_FCC1_ENET=y
-# CONFIG_FCC2_ENET is not set
-# CONFIG_FCC3_ENET is not set

 #
 # Library routines
 #
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
 # CONFIG_CRC32 is not set
 # CONFIG_LIBCRC32C is not set
+CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+# CONFIG_PROFILING is not set

 #
 # Kernel hacking
 #
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
+CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_DEBUG_BUGVERBOSE is not set
 # CONFIG_KGDB_CONSOLE is not set

 #
 # Security options
 #
+# CONFIG_KEYS is not set
 # CONFIG_SECURITY is not set

 #
 # Cryptographic options
 #
-# CONFIG_CRYPTO is not set
+CONFIG_CRYPTO=y
+CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_BLKCIPHER=y
+CONFIG_CRYPTO_MANAGER=y
+# CONFIG_CRYPTO_HMAC is not set
+# CONFIG_CRYPTO_XCBC is not set
+# CONFIG_CRYPTO_NULL is not set
+# CONFIG_CRYPTO_MD4 is not set
+CONFIG_CRYPTO_MD5=y
+# CONFIG_CRYPTO_SHA1 is not set
+# CONFIG_CRYPTO_SHA256 is not set
+# CONFIG_CRYPTO_SHA512 is not set
+# CONFIG_CRYPTO_WP512 is not set
+# CONFIG_CRYPTO_TGR192 is not set
+# CONFIG_CRYPTO_GF128MUL is not set
+CONFIG_CRYPTO_ECB=y
+CONFIG_CRYPTO_CBC=y
+CONFIG_CRYPTO_PCBC=y
+# CONFIG_CRYPTO_LRW is not set
+CONFIG_CRYPTO_DES=y
+# CONFIG_CRYPTO_FCRYPT is not set
+# CONFIG_CRYPTO_BLOWFISH is not set
+# CONFIG_CRYPTO_TWOFISH is not set
+# CONFIG_CRYPTO_SERPENT is not set
+# CONFIG_CRYPTO_AES is not set
+# CONFIG_CRYPTO_CAST5 is not set
+# CONFIG_CRYPTO_CAST6 is not set
+# CONFIG_CRYPTO_TEA is not set
+# CONFIG_CRYPTO_ARC4 is not set
+# CONFIG_CRYPTO_KHAZAD is not set
+# CONFIG_CRYPTO_ANUBIS is not set
+# CONFIG_CRYPTO_DEFLATE is not set
+# CONFIG_CRYPTO_MICHAEL_MIC is not set
+# CONFIG_CRYPTO_CRC32C is not set
+# CONFIG_CRYPTO_CAMELLIA is not set
+
+#
+# Hardware crypto devices
+#
diff --git a/arch/ppc/platforms/mpc8272ads_setup.c b/arch/ppc/platforms/mpc8272ads_setup.c
index 0bc0676..47f4b38 100644
--- a/arch/ppc/platforms/mpc8272ads_setup.c
+++ b/arch/ppc/platforms/mpc8272ads_setup.c
@@ -18,6 +18,7 @@
 #include <linux/ioport.h>
 #include <linux/fs_enet_pd.h>
 #include <linux/platform_device.h>
+#include <linux/phy.h>

 #include <asm/io.h>
 #include <asm/mpc8260.h>
@@ -30,10 +31,10 @@

 #include "pq2ads_pd.h"

-static void init_fcc1_ioports(void);
-static void init_fcc2_ioports(void);
-static void init_scc1_uart_ioports(void);
-static void init_scc4_uart_ioports(void);
+static void init_fcc1_ioports(struct fs_platform_info*);
+static void init_fcc2_ioports(struct fs_platform_info*);
+static void init_scc1_uart_ioports(struct fs_uart_platform_info*);
+static void init_scc4_uart_ioports(struct fs_uart_platform_info*);

 static struct fs_uart_platform_info mpc8272_uart_pdata[] = {
 	[fsid_scc1_uart] = {
@@ -103,7 +104,7 @@ static struct fs_platform_info mpc82xx_enet_pdata[] = {
 	},
 };

-static void init_fcc1_ioports(struct fs_platform_info*)
+static void init_fcc1_ioports(struct fs_platform_info* pdata)
 {
 	struct io_port *io;
 	u32 tempval;
@@ -144,7 +145,7 @@ static void init_fcc1_ioports(struct fs_platform_info*)
 	iounmap(immap);
 }

-static void init_fcc2_ioports(struct fs_platform_info*)
+static void init_fcc2_ioports(struct fs_platform_info* pdata)
 {
 	cpm2_map_t* immap = ioremap(CPM_MAP_ADDR, sizeof(cpm2_map_t));
 	u32 *bcsr = ioremap(BCSR_ADDR+12, sizeof(u32));
@@ -229,7 +230,7 @@ static void mpc8272ads_fixup_uart_pdata(struct platform_device *pdev,
 	}
 }

-static void init_scc1_uart_ioports(struct fs_uart_platform_info*)
+static void init_scc1_uart_ioports(struct fs_uart_platform_info* pdata)
 {
 	cpm2_map_t* immap = ioremap(CPM_MAP_ADDR, sizeof(cpm2_map_t));

@@ -246,7 +247,7 @@ static void init_scc1_uart_ioports(struct fs_uart_platform_info*)
 	iounmap(immap);
 }

-static void init_scc4_uart_ioports(struct fs_uart_platform_info*)
+static void init_scc4_uart_ioports(struct fs_uart_platform_info* pdata)
 {
 	cpm2_map_t* immap = ioremap(CPM_MAP_ADDR, sizeof(cpm2_map_t));

diff --git a/arch/ppc/platforms/mpc866ads_setup.c b/arch/ppc/platforms/mpc866ads_setup.c
index 5b05d4b..7ce5364 100644
--- a/arch/ppc/platforms/mpc866ads_setup.c
+++ b/arch/ppc/platforms/mpc866ads_setup.c
@@ -21,6 +21,7 @@
 #include <linux/fs_enet_pd.h>
 #include <linux/fs_uart_pd.h>
 #include <linux/mii.h>
+#include <linux/phy.h>

 #include <asm/delay.h>
 #include <asm/io.h>
@@ -37,10 +38,10 @@

 extern unsigned char __res[];

-static void setup_fec1_ioports(void);
-static void setup_scc1_ioports(void);
-static void setup_smc1_ioports(void);
-static void setup_smc2_ioports(void);
+static void setup_fec1_ioports(struct fs_platform_info*);
+static void setup_scc1_ioports(struct fs_platform_info*);
+static void setup_smc1_ioports(struct fs_uart_platform_info*);
+static void setup_smc2_ioports(struct fs_uart_platform_info*);

 static struct fs_mii_fec_platform_info	mpc8xx_mdio_fec_pdata;

@@ -137,7 +138,7 @@ void __init board_init(void)
 	iounmap(bcsr_io);
 }

-static void setup_fec1_ioports(struct fs_platform_info*)
+static void setup_fec1_ioports(struct fs_platform_info* pdata)
 {
 	immap_t *immap = (immap_t *) IMAP_ADDR;

@@ -145,7 +146,7 @@ static void setup_fec1_ioports(struct fs_platform_info*)
 	setbits16(&immap->im_ioport.iop_pddir, 0x1fff);
 }

-static void setup_scc1_ioports(struct fs_platform_info*)
+static void setup_scc1_ioports(struct fs_platform_info* pdata)
 {
 	immap_t *immap = (immap_t *) IMAP_ADDR;
 	unsigned *bcsr_io;
@@ -194,7 +195,7 @@ static void setup_scc1_ioports(struct fs_platform_info*)

 }

-static void setup_smc1_ioports(struct fs_uart_platform_info*)
+static void setup_smc1_ioports(struct fs_uart_platform_info* pdata)
 {
 	immap_t *immap = (immap_t *) IMAP_ADDR;
 	unsigned *bcsr_io;
@@ -216,7 +217,7 @@ static void setup_smc1_ioports(struct fs_uart_platform_info*)

 }

-static void setup_smc2_ioports(struct fs_uart_platform_info*)
+static void setup_smc2_ioports(struct fs_uart_platform_info* pdata)
 {
 	immap_t *immap = (immap_t *) IMAP_ADDR;
 	unsigned *bcsr_io;
diff --git a/arch/ppc/platforms/mpc885ads_setup.c b/arch/ppc/platforms/mpc885ads_setup.c
index f8161f3..87deaef 100644
--- a/arch/ppc/platforms/mpc885ads_setup.c
+++ b/arch/ppc/platforms/mpc885ads_setup.c
@@ -35,13 +35,13 @@
 #include <asm/ppc_sys.h>

 extern unsigned char __res[];
-static void setup_smc1_ioports(void);
-static void setup_smc2_ioports(void);
+static void setup_smc1_ioports(struct fs_uart_platform_info*);
+static void setup_smc2_ioports(struct fs_uart_platform_info*);

 static struct fs_mii_fec_platform_info	mpc8xx_mdio_fec_pdata;
-static void setup_fec1_ioports(void);
-static void setup_fec2_ioports(void);
-static void setup_scc3_ioports(void);
+static void setup_fec1_ioports(struct fs_platform_info*);
+static void setup_fec2_ioports(struct fs_platform_info*);
+static void setup_scc3_ioports(struct fs_platform_info*);

 static struct fs_uart_platform_info mpc885_uart_pdata[] = {
 	[fsid_smc1_uart] = {
@@ -161,7 +161,7 @@ void __init board_init(void)
 #endif
 }

-static void setup_fec1_ioports(struct fs_platform_info*)
+static void setup_fec1_ioports(struct fs_platform_info* pdata)
 {
 	immap_t *immap = (immap_t *) IMAP_ADDR;

@@ -181,7 +181,7 @@ static void setup_fec1_ioports(struct fs_platform_info*)
 	clrbits32(&immap->im_cpm.cp_cptr, 0x00000100);
 }

-static void setup_fec2_ioports(struct fs_platform_info*)
+static void setup_fec2_ioports(struct fs_platform_info* pdata)
 {
 	immap_t *immap = (immap_t *) IMAP_ADDR;

@@ -193,7 +193,7 @@ static void setup_fec2_ioports(struct fs_platform_info*)
 	clrbits32(&immap->im_cpm.cp_cptr, 0x00000080);
 }

-static void setup_scc3_ioports(struct fs_platform_info*)
+static void setup_scc3_ioports(struct fs_platform_info* pdata)
 {
 	immap_t *immap = (immap_t *) IMAP_ADDR;
 	unsigned *bcsr_io;
@@ -315,7 +315,7 @@ static void __init mpc885ads_fixup_scc_enet_pdata(struct platform_device *pdev,
 	mpc885ads_fixup_enet_pdata(pdev, fsid_scc1 + pdev->id - 1);
 }

-static void setup_smc1_ioports(struct fs_uart_platform_info*)
+static void setup_smc1_ioports(struct fs_uart_platform_info* pdata)
 {
         immap_t *immap = (immap_t *) IMAP_ADDR;
         unsigned *bcsr_io;
@@ -335,7 +335,7 @@ static void setup_smc1_ioports(struct fs_uart_platform_info*)
         clrbits16(&immap->im_cpm.cp_pbodr, iobits);
 }

-static void setup_smc2_ioports(struct fs_uart_platform_info*)
+static void setup_smc2_ioports(struct fs_uart_platform_info* pdata)
 {
         immap_t *immap = (immap_t *) IMAP_ADDR;
         unsigned *bcsr_io;
