Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbXFWOmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbXFWOmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 10:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbXFWOmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 10:42:02 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:59940 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755521AbXFWOl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 10:41:59 -0400
Date: Sat, 23 Jun 2007 16:41:43 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: [GIT PULL] AVR32 fixes
Message-ID: <20070623164143.2bba7104@dhcp-255-175.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'for-linus' branch of

  git://www.atmel.no/~hskinnemoen/linux/kernel/avr32.git for-linus

to receive the following updates.

The status of the various SL*B allocators on AVR32 is now as follows:
  * SLAB works, but debugging is effectively disabled due to
    ARCH_KMALLOC_MINALIGN.
  * SLUB works, including debugging.
  * SLOB seems to ignore ARCH_KMALLOC_MINALIGN, so it breaks DMA
    (SPI in particular is affected by this.)

So since SLUB is currently the allocator that works best on AVR32, I've
enabled it by default for both ATSTK1002 and ATNGW100. Big thanks to
Christoph for fixing the ARCH_KMALLOC_MINALIGN vs. CONFIG_SLUB_DEBUG
issue.

David Brownell (1):
      [AVR32] Initialize dma_mask and dma_coherent_mask

Haavard Skinnemoen (2):
      [AVR32] Fix bug in invalidate_dcache_region()
      [AVR32] Update defconfigs

ben.nizette@iinet.net.au (1):
      [AVR32] NGW100, Remove relics of the old USART mapping scheme

 arch/avr32/boards/atngw100/setup.c     |    3 -
 arch/avr32/configs/atngw100_defconfig  |  152 ++++++++-------------------
 arch/avr32/configs/atstk1002_defconfig |  180 +++++++++++++------------------
 arch/avr32/mach-at32ap/at32ap7000.c    |   12 ++
 arch/avr32/mm/cache.c                  |   14 +--
 5 files changed, 136 insertions(+), 225 deletions(-)

diff --git a/arch/avr32/boards/atngw100/setup.c b/arch/avr32/boards/atngw100/setup.c
index 9bc37d4..6c4dc0a 100644
--- a/arch/avr32/boards/atngw100/setup.c
+++ b/arch/avr32/boards/atngw100/setup.c
@@ -94,9 +94,6 @@ static void __init set_hw_addr(struct platform_device *pdev)
 	clk_put(pclk);
 }
 
-struct platform_device *at32_usart_map[1];
-unsigned int at32_nr_usarts = 1;
-
 void __init setup_board(void)
 {
 	at32_map_usart(1, 0);	/* USART 1: /dev/ttyS0, DB9 */
diff --git a/arch/avr32/configs/atngw100_defconfig b/arch/avr32/configs/atngw100_defconfig
index c254ffc..49493ad 100644
--- a/arch/avr32/configs/atngw100_defconfig
+++ b/arch/avr32/configs/atngw100_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.21-rc6
-# Thu Apr 12 16:35:07 2007
+# Linux kernel version: 2.6.22-rc5
+# Sat Jun 23 15:40:05 2007
 #
 CONFIG_AVR32=y
 CONFIG_GENERIC_GPIO=y
@@ -40,6 +40,7 @@ CONFIG_BSD_PROCESS_ACCT_V3=y
 # CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
+CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
 CONFIG_BLK_DEV_INITRD=y
@@ -57,14 +58,20 @@ CONFIG_BUG=y
 CONFIG_ELF_CORE=y
 # CONFIG_BASE_FULL is not set
 CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
+CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
-CONFIG_SLAB=y
 CONFIG_VM_EVENT_COUNTERS=y
+# CONFIG_SLUB_DEBUG is not set
+# CONFIG_SLAB is not set
+CONFIG_SLUB=y
+# CONFIG_SLOB is not set
 CONFIG_RT_MUTEXES=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=1
-# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -148,6 +155,7 @@ CONFIG_CMDLINE=""
 #
 # Bus options
 #
+# CONFIG_ARCH_SUPPORTS_MSI is not set
 
 #
 # PCCARD (PCMCIA/CardBus) support
@@ -168,7 +176,6 @@ CONFIG_NET=y
 #
 # Networking options
 #
-# CONFIG_NETDEBUG is not set
 CONFIG_PACKET=y
 CONFIG_PACKET_MMAP=y
 CONFIG_UNIX=y
@@ -212,14 +219,11 @@ CONFIG_INET_TCP_DIAG=y
 CONFIG_TCP_CONG_CUBIC=y
 CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_TCP_MD5SIG is not set
-
-#
-# IP: Virtual Server Configuration
-#
 # CONFIG_IP_VS is not set
 CONFIG_IPV6=y
 # CONFIG_IPV6_PRIVACY is not set
 # CONFIG_IPV6_ROUTER_PREF is not set
+# CONFIG_IPV6_OPTIMISTIC_DAD is not set
 CONFIG_INET6_AH=y
 CONFIG_INET6_ESP=y
 CONFIG_INET6_IPCOMP=y
@@ -242,8 +246,6 @@ CONFIG_NETFILTER=y
 #
 # CONFIG_NETFILTER_NETLINK is not set
 CONFIG_NF_CONNTRACK_ENABLED=m
-CONFIG_NF_CONNTRACK_SUPPORT=y
-# CONFIG_IP_NF_CONNTRACK_SUPPORT is not set
 CONFIG_NF_CONNTRACK=m
 CONFIG_NF_CT_ACCT=y
 CONFIG_NF_CONNTRACK_MARK=y
@@ -357,20 +359,8 @@ CONFIG_IP6_NF_TARGET_REJECT=m
 CONFIG_IP6_NF_MANGLE=m
 CONFIG_IP6_NF_TARGET_HL=m
 CONFIG_IP6_NF_RAW=m
-
-#
-# DCCP Configuration (EXPERIMENTAL)
-#
 # CONFIG_IP_DCCP is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
 # CONFIG_IP_SCTP is not set
-
-#
-# TIPC Configuration (EXPERIMENTAL)
-#
 # CONFIG_TIPC is not set
 # CONFIG_ATM is not set
 # CONFIG_BRIDGE is not set
@@ -397,7 +387,16 @@ CONFIG_NET_CLS_ROUTE=y
 # CONFIG_HAMRADIO is not set
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
+# CONFIG_AF_RXRPC is not set
+
+#
+# Wireless
+#
+# CONFIG_CFG80211 is not set
+# CONFIG_WIRELESS_EXT is not set
+# CONFIG_MAC80211 is not set
 # CONFIG_IEEE80211 is not set
+# CONFIG_RFKILL is not set
 
 #
 # Device Drivers
@@ -417,10 +416,6 @@ CONFIG_STANDALONE=y
 # Connector - unified userspace <-> kernelspace linker
 #
 # CONFIG_CONNECTOR is not set
-
-#
-# Memory Technology Devices (MTD)
-#
 CONFIG_MTD=y
 # CONFIG_MTD_DEBUG is not set
 # CONFIG_MTD_CONCAT is not set
@@ -464,7 +459,6 @@ CONFIG_MTD_CFI_UTIL=y
 # CONFIG_MTD_RAM is not set
 # CONFIG_MTD_ROM is not set
 # CONFIG_MTD_ABSENT is not set
-# CONFIG_MTD_OBSOLETE_CHIPS is not set
 
 #
 # Mapping drivers for chip access
@@ -492,16 +486,13 @@ CONFIG_MTD_DATAFLASH=y
 # CONFIG_MTD_DOC2000 is not set
 # CONFIG_MTD_DOC2001 is not set
 # CONFIG_MTD_DOC2001PLUS is not set
-
-#
-# NAND Flash Device Drivers
-#
 # CONFIG_MTD_NAND is not set
+# CONFIG_MTD_ONENAND is not set
 
 #
-# OneNAND Flash Device Drivers
+# UBI - Unsorted block images
 #
-# CONFIG_MTD_ONENAND is not set
+# CONFIG_MTD_UBI is not set
 
 #
 # Parallel port support
@@ -530,10 +521,7 @@ CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 #
 # Misc devices
 #
-
-#
-# ATA/ATAPI/MFM/RLL support
-#
+# CONFIG_BLINK is not set
 # CONFIG_IDE is not set
 
 #
@@ -542,10 +530,6 @@ CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
 # CONFIG_SCSI_NETLINK is not set
-
-#
-# Serial ATA (prod) and Parallel ATA (experimental) drivers
-#
 # CONFIG_ATA is not set
 
 #
@@ -554,19 +538,6 @@ CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_MD is not set
 
 #
-# Fusion MPT device support
-#
-# CONFIG_FUSION is not set
-
-#
-# IEEE 1394 (FireWire) support
-#
-
-#
-# I2O device support
-#
-
-#
 # Network device support
 #
 CONFIG_NETDEVICES=y
@@ -574,10 +545,6 @@ CONFIG_NETDEVICES=y
 # CONFIG_BONDING is not set
 # CONFIG_EQUALIZER is not set
 CONFIG_TUN=m
-
-#
-# PHY device support
-#
 # CONFIG_PHYLIB is not set
 
 #
@@ -586,27 +553,14 @@ CONFIG_TUN=m
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
 CONFIG_MACB=y
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
 
 #
-# Ethernet (1000 Mbit)
-#
-
-#
-# Ethernet (10000 Mbit)
-#
-
-#
-# Token Ring devices
-#
-
-#
-# Wireless LAN (non-hamradio)
-#
-# CONFIG_NET_RADIO is not set
-
-#
-# Wan interfaces
+# Wireless LAN
 #
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
 # CONFIG_WAN is not set
 CONFIG_PPP=m
 # CONFIG_PPP_MULTILINK is not set
@@ -671,15 +625,10 @@ CONFIG_UNIX98_PTYS=y
 # IPMI
 #
 # CONFIG_IPMI_HANDLER is not set
-
-#
-# Watchdog Cards
-#
 # CONFIG_WATCHDOG is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_RTC is not set
 # CONFIG_GEN_RTC is not set
-# CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
 
@@ -687,10 +636,6 @@ CONFIG_UNIX98_PTYS=y
 # TPM devices
 #
 # CONFIG_TCG_TPM is not set
-
-#
-# I2C support
-#
 # CONFIG_I2C is not set
 
 #
@@ -710,17 +655,13 @@ CONFIG_SPI_ATMEL=y
 # SPI Protocol Masters
 #
 # CONFIG_SPI_AT25 is not set
+# CONFIG_SPI_SPIDEV is not set
 
 #
 # Dallas's 1-wire bus
 #
 # CONFIG_W1 is not set
-
-#
-# Hardware Monitoring support
-#
 # CONFIG_HWMON is not set
-# CONFIG_HWMON_VID is not set
 
 #
 # Multifunction device drivers
@@ -731,16 +672,19 @@ CONFIG_SPI_ATMEL=y
 # Multimedia devices
 #
 # CONFIG_VIDEO_DEV is not set
+# CONFIG_DVB_CORE is not set
+# CONFIG_DAB is not set
 
 #
-# Digital Video Broadcasting Devices
+# Graphics support
 #
-# CONFIG_DVB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
-# Graphics support
+# Display device support
 #
-# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+# CONFIG_DISPLAY_SUPPORT is not set
+# CONFIG_VGASTATE is not set
 # CONFIG_FB is not set
 
 #
@@ -763,10 +707,6 @@ CONFIG_SPI_ATMEL=y
 # USB Gadget Support
 #
 # CONFIG_USB_GADGET is not set
-
-#
-# MMC/SD Card support
-#
 # CONFIG_MMC is not set
 
 #
@@ -809,14 +749,6 @@ CONFIG_SPI_ATMEL=y
 #
 
 #
-# Auxiliary Display support
-#
-
-#
-# Virtualization
-#
-
-#
 # File systems
 #
 CONFIG_EXT2_FS=y
@@ -911,6 +843,7 @@ CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_BIND34 is not set
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 CONFIG_SMB_FS=m
@@ -993,11 +926,9 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_SHIRQ is not set
-CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
-# CONFIG_DEBUG_SLAB is not set
 # CONFIG_DEBUG_RT_MUTEXES is not set
 # CONFIG_RT_MUTEX_TESTER is not set
 # CONFIG_DEBUG_SPINLOCK is not set
@@ -1044,6 +975,7 @@ CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_PCBC=m
 # CONFIG_CRYPTO_LRW is not set
+# CONFIG_CRYPTO_CRYPTD is not set
 CONFIG_CRYPTO_DES=y
 # CONFIG_CRYPTO_FCRYPT is not set
 # CONFIG_CRYPTO_BLOWFISH is not set
@@ -1072,6 +1004,7 @@ CONFIG_CRYPTO_DEFLATE=y
 CONFIG_BITREVERSE=y
 CONFIG_CRC_CCITT=m
 # CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
@@ -1083,3 +1016,4 @@ CONFIG_TEXTSEARCH_FSM=m
 CONFIG_PLIST=y
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
diff --git a/arch/avr32/configs/atstk1002_defconfig b/arch/avr32/configs/atstk1002_defconfig
index 77dace9..3b977fd 100644
--- a/arch/avr32/configs/atstk1002_defconfig
+++ b/arch/avr32/configs/atstk1002_defconfig
@@ -1,9 +1,10 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.20-rc6
-# Fri Jan 26 13:12:59 2007
+# Linux kernel version: 2.6.22-rc5
+# Sat Jun 23 15:32:08 2007
 #
 CONFIG_AVR32=y
+CONFIG_GENERIC_GPIO=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_HARDIRQS_SW_RESEND=y
 CONFIG_GENERIC_IRQ_PROBE=y
@@ -13,6 +14,7 @@ CONFIG_GENERIC_TIME=y
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_GENERIC_BUG=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
@@ -30,19 +32,22 @@ CONFIG_LOCALVERSION=""
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
 # CONFIG_IPC_NS is not set
+CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_TASKSTATS=y
 CONFIG_TASK_DELAY_ACCT=y
+# CONFIG_TASK_XACCT is not set
 # CONFIG_UTS_NS is not set
 CONFIG_AUDIT=y
 # CONFIG_IKCONFIG is not set
+CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_RELAY=y
+CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
-# CONFIG_TASK_XACCT is not set
 CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
 # CONFIG_SYSCTL_SYSCALL is not set
@@ -55,14 +60,20 @@ CONFIG_BUG=y
 CONFIG_ELF_CORE=y
 # CONFIG_BASE_FULL is not set
 CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
+CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
-CONFIG_SLAB=y
 CONFIG_VM_EVENT_COUNTERS=y
+# CONFIG_SLUB_DEBUG is not set
+# CONFIG_SLAB is not set
+CONFIG_SLUB=y
+# CONFIG_SLOB is not set
 CONFIG_RT_MUTEXES=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=1
-# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -105,7 +116,15 @@ CONFIG_PLATFORM_AT32AP=y
 CONFIG_CPU_AT32AP7000=y
 CONFIG_BOARD_ATSTK1002=y
 CONFIG_BOARD_ATSTK1000=y
+# CONFIG_BOARD_ATNGW100 is not set
 CONFIG_LOADER_U_BOOT=y
+
+#
+# Atmel AVR32 AP options
+#
+# CONFIG_AP7000_32_BIT_SMC is not set
+CONFIG_AP7000_16_BIT_SMC=y
+# CONFIG_AP7000_8_BIT_SMC is not set
 CONFIG_LOAD_ADDRESS=0x10000000
 CONFIG_ENTRY_ADDRESS=0x90000000
 CONFIG_PHYS_OFFSET=0x10000000
@@ -127,6 +146,7 @@ CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=0
 # CONFIG_OWNERSHIP_TRACE is not set
 # CONFIG_HZ_100 is not set
 CONFIG_HZ_250=y
@@ -138,6 +158,7 @@ CONFIG_CMDLINE=""
 #
 # Bus options
 #
+# CONFIG_ARCH_SUPPORTS_MSI is not set
 
 #
 # PCCARD (PCMCIA/CardBus) support
@@ -158,7 +179,6 @@ CONFIG_NET=y
 #
 # Networking options
 #
-# CONFIG_NETDEBUG is not set
 CONFIG_PACKET=y
 CONFIG_PACKET_MMAP=y
 CONFIG_UNIX=y
@@ -194,20 +214,8 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_INET6_TUNNEL is not set
 # CONFIG_NETWORK_SECMARK is not set
 # CONFIG_NETFILTER is not set
-
-#
-# DCCP Configuration (EXPERIMENTAL)
-#
 # CONFIG_IP_DCCP is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
 # CONFIG_IP_SCTP is not set
-
-#
-# TIPC Configuration (EXPERIMENTAL)
-#
 # CONFIG_TIPC is not set
 # CONFIG_ATM is not set
 # CONFIG_BRIDGE is not set
@@ -233,7 +241,16 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_HAMRADIO is not set
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
+# CONFIG_AF_RXRPC is not set
+
+#
+# Wireless
+#
+# CONFIG_CFG80211 is not set
+# CONFIG_WIRELESS_EXT is not set
+# CONFIG_MAC80211 is not set
 # CONFIG_IEEE80211 is not set
+# CONFIG_RFKILL is not set
 
 #
 # Device Drivers
@@ -246,16 +263,13 @@ CONFIG_STANDALONE=y
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 # CONFIG_DEBUG_DRIVER is not set
+# CONFIG_DEBUG_DEVRES is not set
 # CONFIG_SYS_HYPERVISOR is not set
 
 #
 # Connector - unified userspace <-> kernelspace linker
 #
 # CONFIG_CONNECTOR is not set
-
-#
-# Memory Technology Devices (MTD)
-#
 CONFIG_MTD=y
 # CONFIG_MTD_DEBUG is not set
 # CONFIG_MTD_CONCAT is not set
@@ -299,7 +313,6 @@ CONFIG_MTD_CFI_UTIL=y
 # CONFIG_MTD_RAM is not set
 # CONFIG_MTD_ROM is not set
 # CONFIG_MTD_ABSENT is not set
-# CONFIG_MTD_OBSOLETE_CHIPS is not set
 
 #
 # Mapping drivers for chip access
@@ -325,16 +338,13 @@ CONFIG_MTD_PHYSMAP_BANKWIDTH=2
 # CONFIG_MTD_DOC2000 is not set
 # CONFIG_MTD_DOC2001 is not set
 # CONFIG_MTD_DOC2001PLUS is not set
-
-#
-# NAND Flash Device Drivers
-#
 # CONFIG_MTD_NAND is not set
+# CONFIG_MTD_ONENAND is not set
 
 #
-# OneNAND Flash Device Drivers
+# UBI - Unsorted block images
 #
-# CONFIG_MTD_ONENAND is not set
+# CONFIG_MTD_UBI is not set
 
 #
 # Parallel port support
@@ -344,6 +354,7 @@ CONFIG_MTD_PHYSMAP_BANKWIDTH=2
 #
 # Plug and Play support
 #
+# CONFIG_PNPACPI is not set
 
 #
 # Block devices
@@ -356,18 +367,13 @@ CONFIG_BLK_DEV_RAM=m
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
-CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
 
 #
 # Misc devices
 #
-# CONFIG_TIFM_CORE is not set
-
-#
-# ATA/ATAPI/MFM/RLL support
-#
+# CONFIG_BLINK is not set
 # CONFIG_IDE is not set
 
 #
@@ -376,10 +382,6 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
 # CONFIG_SCSI_NETLINK is not set
-
-#
-# Serial ATA (prod) and Parallel ATA (experimental) drivers
-#
 # CONFIG_ATA is not set
 
 #
@@ -388,19 +390,6 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_MD is not set
 
 #
-# Fusion MPT device support
-#
-# CONFIG_FUSION is not set
-
-#
-# IEEE 1394 (FireWire) support
-#
-
-#
-# I2O device support
-#
-
-#
 # Network device support
 #
 CONFIG_NETDEVICES=y
@@ -408,10 +397,6 @@ CONFIG_DUMMY=y
 # CONFIG_BONDING is not set
 # CONFIG_EQUALIZER is not set
 CONFIG_TUN=m
-
-#
-# PHY device support
-#
 # CONFIG_PHYLIB is not set
 
 #
@@ -420,27 +405,14 @@ CONFIG_TUN=m
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
 CONFIG_MACB=y
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
 
 #
-# Ethernet (1000 Mbit)
-#
-
-#
-# Ethernet (10000 Mbit)
-#
-
-#
-# Token Ring devices
-#
-
-#
-# Wireless LAN (non-hamradio)
-#
-# CONFIG_NET_RADIO is not set
-
-#
-# Wan interfaces
+# Wireless LAN
 #
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
 # CONFIG_WAN is not set
 CONFIG_PPP=m
 # CONFIG_PPP_MULTILINK is not set
@@ -505,15 +477,10 @@ CONFIG_UNIX98_PTYS=y
 # IPMI
 #
 # CONFIG_IPMI_HANDLER is not set
-
-#
-# Watchdog Cards
-#
 # CONFIG_WATCHDOG is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_RTC is not set
 # CONFIG_GEN_RTC is not set
-# CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
 
@@ -521,10 +488,6 @@ CONFIG_UNIX98_PTYS=y
 # TPM devices
 #
 # CONFIG_TCG_TPM is not set
-
-#
-# I2C support
-#
 # CONFIG_I2C is not set
 
 #
@@ -537,29 +500,31 @@ CONFIG_UNIX98_PTYS=y
 # Dallas's 1-wire bus
 #
 # CONFIG_W1 is not set
+# CONFIG_HWMON is not set
 
 #
-# Hardware Monitoring support
+# Multifunction device drivers
 #
-# CONFIG_HWMON is not set
-# CONFIG_HWMON_VID is not set
+# CONFIG_MFD_SM501 is not set
 
 #
 # Multimedia devices
 #
 # CONFIG_VIDEO_DEV is not set
+# CONFIG_DVB_CORE is not set
+# CONFIG_DAB is not set
 
 #
-# Digital Video Broadcasting Devices
+# Graphics support
 #
-# CONFIG_DVB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
-# Graphics support
+# Display device support
 #
-# CONFIG_FIRMWARE_EDID is not set
+# CONFIG_DISPLAY_SUPPORT is not set
+# CONFIG_VGASTATE is not set
 # CONFIG_FB is not set
-# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
 # Sound
@@ -581,10 +546,6 @@ CONFIG_UNIX98_PTYS=y
 # USB Gadget Support
 #
 # CONFIG_USB_GADGET is not set
-
-#
-# MMC/SD Card support
-#
 # CONFIG_MMC is not set
 
 #
@@ -627,10 +588,6 @@ CONFIG_UNIX98_PTYS=y
 #
 
 #
-# Virtualization
-#
-
-#
 # File systems
 #
 CONFIG_EXT2_FS=m
@@ -712,8 +669,20 @@ CONFIG_JFFS2_RTIME=y
 #
 # Network File Systems
 #
-# CONFIG_NFS_FS is not set
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
+CONFIG_ROOT_NFS=y
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_BIND34 is not set
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
 # CONFIG_CIFS is not set
 # CONFIG_NCP_FS is not set
@@ -787,15 +756,14 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
-# CONFIG_DEBUG_SLAB is not set
+# CONFIG_TIMER_STATS is not set
 # CONFIG_DEBUG_RT_MUTEXES is not set
 # CONFIG_RT_MUTEX_TESTER is not set
 # CONFIG_DEBUG_SPINLOCK is not set
 # CONFIG_DEBUG_MUTEXES is not set
-# CONFIG_DEBUG_RWSEMS is not set
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
@@ -806,6 +774,7 @@ CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_FRAME_POINTER=y
 CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
+# CONFIG_FAULT_INJECTION is not set
 # CONFIG_KPROBES is not set
 
 #
@@ -825,10 +794,13 @@ CONFIG_FORCED_INLINING=y
 CONFIG_BITREVERSE=y
 CONFIG_CRC_CCITT=m
 # CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
 CONFIG_AUDIT_GENERIC=y
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=y
 CONFIG_PLIST=y
-CONFIG_IOMAP_COPY=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
diff --git a/arch/avr32/mach-at32ap/at32ap7000.c b/arch/avr32/mach-at32ap/at32ap7000.c
index 1d2bf34..4dda42d 100644
--- a/arch/avr32/mach-at32ap/at32ap7000.c
+++ b/arch/avr32/mach-at32ap/at32ap7000.c
@@ -9,6 +9,7 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
 #include <linux/spi/spi.h>
 
 #include <asm/io.h>
@@ -45,19 +46,30 @@
 		.flags		= IORESOURCE_IRQ,	\
 	}
 
+/* REVISIT these assume *every* device supports DMA, but several
+ * don't ... tc, smc, pio, rtc, watchdog, pwm, ps2, and more.
+ */
 #define DEFINE_DEV(_name, _id)					\
+static u64 _name##_id##_dma_mask = DMA_32BIT_MASK;		\
 static struct platform_device _name##_id##_device = {		\
 	.name		= #_name,				\
 	.id		= _id,					\
+	.dev		= {					\
+		.dma_mask = &_name##_id##_dma_mask,		\
+		.coherent_dma_mask = DMA_32BIT_MASK,		\
+	},							\
 	.resource	= _name##_id##_resource,		\
 	.num_resources	= ARRAY_SIZE(_name##_id##_resource),	\
 }
 #define DEFINE_DEV_DATA(_name, _id)				\
+static u64 _name##_id##_dma_mask = DMA_32BIT_MASK;		\
 static struct platform_device _name##_id##_device = {		\
 	.name		= #_name,				\
 	.id		= _id,					\
 	.dev		= {					\
+		.dma_mask = &_name##_id##_dma_mask,		\
 		.platform_data	= &_name##_id##_data,		\
+		.coherent_dma_mask = DMA_32BIT_MASK,		\
 	},							\
 	.resource	= _name##_id##_resource,		\
 	.num_resources	= ARRAY_SIZE(_name##_id##_resource),	\
diff --git a/arch/avr32/mm/cache.c b/arch/avr32/mm/cache.c
index 8f7b1c3..c1233c6 100644
--- a/arch/avr32/mm/cache.c
+++ b/arch/avr32/mm/cache.c
@@ -23,7 +23,6 @@
 void invalidate_dcache_region(void *start, size_t size)
 {
 	unsigned long v, begin, end, linesz, mask;
-	int flush = 0;
 
 	linesz = boot_cpu_data.dcache.linesz;
 	mask = linesz - 1;
@@ -32,24 +31,21 @@ void invalidate_dcache_region(void *start, size_t size)
 	 * instead of invalidating ... never discard valid data!
 	 */
 	begin = (unsigned long)start;
-	end = begin + size - 1;
+	end = begin + size;
 
 	if (begin & mask) {
 		flush_dcache_line(start);
 		begin += linesz;
-		flush = 1;
 	}
-	if ((end & mask) != mask) {
+	if (end & mask) {
 		flush_dcache_line((void *)end);
-		end -= linesz;
-		flush = 1;
+		end &= ~mask;
 	}
 
 	/* remaining cachelines only need invalidation */
-	for (v = begin; v <= end; v += linesz)
+	for (v = begin; v < end; v += linesz)
 		invalidate_dcache_line((void *)v);
-	if (flush)
-		flush_write_buffer();
+	flush_write_buffer();
 }
 
 void clean_dcache_region(void *start, size_t size)
