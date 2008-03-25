Return-Path: <linux-kernel-owner+w=401wt.eu-S1760387AbYCYV16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387AbYCYV16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759591AbYCYV1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:27:34 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:64949 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759460AbYCYV1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:27:31 -0400
From: York Sun <yorksun@freescale.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       a.p.zijlstra@chello.nl, York Sun <yorksun@freescale.com>
Subject: [PATCH 2/2 v3] Add DIU platform code for MPC8610HPCD
Date: Tue, 25 Mar 2008 16:27:18 -0500
Message-Id: <1206480438819-git-send-email-yorksun@freescale.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12064804383051-git-send-email-yorksun@freescale.com>
References: <120648043867-git-send-email-yorksun@freescale.com>
 <12064804383051-git-send-email-yorksun@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform code to support Freescale DIU. The platform code includes
framebuffer memory allocation, pixel format, monitor port, etc.

Signed-off-by: York Sun <yorksun@freescale.com>
---
This patch enables Freescale DIU driver for MPC8610HPCD board.

 arch/powerpc/configs/mpc8610_hpcd_defconfig |  198 +++++++++++++++++++++++----
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c  |  190 ++++++++++++++++++++++++-
 arch/powerpc/sysdev/fsl_soc.c               |   41 ++++++
 arch/powerpc/sysdev/fsl_soc.h               |   23 +++
 4 files changed, 414 insertions(+), 38 deletions(-)

diff --git a/arch/powerpc/configs/mpc8610_hpcd_defconfig b/arch/powerpc/configs/mpc8610_hpcd_defconfig
index 2500ef4..98cef01 100644
--- a/arch/powerpc/configs/mpc8610_hpcd_defconfig
+++ b/arch/powerpc/configs/mpc8610_hpcd_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.24-rc4
-# Thu Dec  6 16:48:56 2007
+# Linux kernel version: 2.6.25-rc5
+# Tue Mar 25 16:10:42 2008
 #
 # CONFIG_PPC64 is not set
 
@@ -29,6 +29,7 @@ CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_TIME_VSYSCALL=y
 CONFIG_GENERIC_CLOCKEVENTS=y
 CONFIG_GENERIC_HARDIRQS=y
+# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
 CONFIG_IRQ_PER_CPU=y
 CONFIG_RWSEM_XCHGADD_ALGORITHM=y
 CONFIG_ARCH_HAS_ILOG2_U32=y
@@ -65,16 +66,20 @@ CONFIG_LOCALVERSION=""
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_USER_NS is not set
-# CONFIG_PID_NS is not set
 # CONFIG_AUDIT is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CGROUPS is not set
+CONFIG_GROUP_SCHED=y
 # CONFIG_FAIR_GROUP_SCHED is not set
+# CONFIG_RT_GROUP_SCHED is not set
+CONFIG_USER_SCHED=y
+# CONFIG_CGROUP_SCHED is not set
 CONFIG_SYSFS_DEPRECATED=y
+CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_RELAY is not set
+# CONFIG_NAMESPACES is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
@@ -88,11 +93,13 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
 CONFIG_VM_EVENT_COUNTERS=y
@@ -100,6 +107,13 @@ CONFIG_SLUB_DEBUG=y
 # CONFIG_SLAB is not set
 CONFIG_SLUB=y
 # CONFIG_SLOB is not set
+# CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set
+CONFIG_HAVE_OPROFILE=y
+CONFIG_HAVE_KPROBES=y
+CONFIG_HAVE_KRETPROBES=y
+CONFIG_PROC_PAGE_MONITOR=y
+CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
@@ -122,6 +136,7 @@ CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
+CONFIG_CLASSIC_RCU=y
 
 #
 # Platform support
@@ -130,14 +145,15 @@ CONFIG_DEFAULT_IOSCHED="deadline"
 # CONFIG_PPC_82xx is not set
 # CONFIG_PPC_83xx is not set
 CONFIG_PPC_86xx=y
-# CONFIG_PPC_MPC52xx is not set
-# CONFIG_PPC_MPC5200 is not set
+# CONFIG_PPC_MPC512x is not set
+# CONFIG_PPC_MPC5121 is not set
 # CONFIG_PPC_CELL is not set
 # CONFIG_PPC_CELL_NATIVE is not set
 # CONFIG_PQ2ADS is not set
 # CONFIG_MPC8641_HPCN is not set
 CONFIG_MPC8610_HPCD=y
 CONFIG_MPC8610=y
+# CONFIG_IPIC is not set
 CONFIG_MPIC=y
 # CONFIG_MPIC_WEIRD is not set
 # CONFIG_PPC_I8259 is not set
@@ -148,7 +164,6 @@ CONFIG_MPIC=y
 # CONFIG_PPC_INDIRECT_IO is not set
 # CONFIG_GENERIC_IOMAP is not set
 # CONFIG_CPU_FREQ is not set
-# CONFIG_CPM2 is not set
 # CONFIG_FSL_ULI1575 is not set
 
 #
@@ -164,12 +179,16 @@ CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 # CONFIG_HZ_300 is not set
 CONFIG_HZ_1000=y
 CONFIG_HZ=1000
+# CONFIG_SCHED_HRTICK is not set
 CONFIG_PREEMPT_NONE=y
 # CONFIG_PREEMPT_VOLUNTARY is not set
 # CONFIG_PREEMPT is not set
 CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
+# CONFIG_IOMMU_HELPER is not set
 CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
+CONFIG_ARCH_HAS_WALK_MEMORY=y
+CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
 CONFIG_ARCH_FLATMEM_ENABLE=y
 CONFIG_ARCH_POPULATES_NODE_MAP=y
 CONFIG_SELECT_MEMORY_MODEL=y
@@ -188,10 +207,7 @@ CONFIG_VIRT_TO_BUS=y
 CONFIG_PROC_DEVICETREE=y
 # CONFIG_CMDLINE_BOOL is not set
 # CONFIG_PM is not set
-CONFIG_SUSPEND_UP_POSSIBLE=y
-CONFIG_HIBERNATION_UP_POSSIBLE=y
 # CONFIG_SECCOMP is not set
-# CONFIG_WANT_DEVICE_TREE is not set
 CONFIG_ISA_DMA_API=y
 
 #
@@ -243,6 +259,7 @@ CONFIG_XFRM=y
 CONFIG_XFRM_USER=y
 # CONFIG_XFRM_SUB_POLICY is not set
 # CONFIG_XFRM_MIGRATE is not set
+# CONFIG_XFRM_STATISTICS is not set
 # CONFIG_NET_KEY is not set
 CONFIG_INET=y
 # CONFIG_IP_MULTICAST is not set
@@ -311,6 +328,7 @@ CONFIG_IPV6_SIT=y
 #
 # CONFIG_NET_PKTGEN is not set
 # CONFIG_HAMRADIO is not set
+# CONFIG_CAN is not set
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set
@@ -357,7 +375,7 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=131072
-CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+# CONFIG_BLK_DEV_XIP is not set
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
 CONFIG_MISC_DEVICES=y
@@ -365,6 +383,8 @@ CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
 # CONFIG_SGI_IOC4 is not set
 # CONFIG_TIFM_CORE is not set
+# CONFIG_ENCLOSURE_SERVICES is not set
+CONFIG_HAVE_IDE=y
 CONFIG_IDE=y
 CONFIG_IDE_MAX_HWIFS=4
 # CONFIG_BLK_DEV_IDE is not set
@@ -432,6 +452,7 @@ CONFIG_SCSI_LOWLEVEL=y
 # CONFIG_SCSI_IPS is not set
 # CONFIG_SCSI_INITIO is not set
 # CONFIG_SCSI_INIA100 is not set
+# CONFIG_SCSI_MVSAS is not set
 # CONFIG_SCSI_STEX is not set
 # CONFIG_SCSI_SYM53C8XX_2 is not set
 # CONFIG_SCSI_IPR is not set
@@ -462,6 +483,7 @@ CONFIG_SATA_AHCI=y
 # CONFIG_SATA_VIA is not set
 # CONFIG_SATA_VITESSE is not set
 # CONFIG_SATA_INIC162X is not set
+# CONFIG_SATA_FSL is not set
 CONFIG_PATA_ALI=y
 # CONFIG_PATA_AMD is not set
 # CONFIG_PATA_ARTOP is not set
@@ -485,6 +507,7 @@ CONFIG_PATA_ALI=y
 # CONFIG_PATA_MPIIX is not set
 # CONFIG_PATA_OLDPIIX is not set
 # CONFIG_PATA_NETCELL is not set
+# CONFIG_PATA_NINJA32 is not set
 # CONFIG_PATA_NS87410 is not set
 # CONFIG_PATA_NS87415 is not set
 # CONFIG_PATA_OPTI is not set
@@ -518,7 +541,6 @@ CONFIG_DUMMY=y
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
 # CONFIG_VETH is not set
-# CONFIG_IP1000 is not set
 # CONFIG_ARCNET is not set
 CONFIG_PHYLIB=y
 
@@ -534,6 +556,7 @@ CONFIG_PHYLIB=y
 # CONFIG_SMSC_PHY is not set
 # CONFIG_BROADCOM_PHY is not set
 # CONFIG_ICPLUS_PHY is not set
+# CONFIG_REALTEK_PHY is not set
 # CONFIG_FIXED_PHY is not set
 # CONFIG_MDIO_BITBANG is not set
 CONFIG_NET_ETHERNET=y
@@ -574,6 +597,7 @@ CONFIG_8139TOO_PIO=y
 # CONFIG_8139TOO_TUNE_TWISTER is not set
 # CONFIG_8139TOO_8129 is not set
 # CONFIG_8139_OLD_RX_RESET is not set
+# CONFIG_R6040 is not set
 # CONFIG_SIS900 is not set
 # CONFIG_EPIC100 is not set
 # CONFIG_SUNDANCE is not set
@@ -585,6 +609,9 @@ CONFIG_NETDEV_1000=y
 # CONFIG_DL2K is not set
 # CONFIG_E1000 is not set
 # CONFIG_E1000E is not set
+# CONFIG_E1000E_ENABLED is not set
+# CONFIG_IP1000 is not set
+# CONFIG_IGB is not set
 # CONFIG_NS83820 is not set
 # CONFIG_HAMACHI is not set
 # CONFIG_YELLOWFIN is not set
@@ -610,6 +637,7 @@ CONFIG_NETDEV_10000=y
 # CONFIG_NIU is not set
 # CONFIG_MLX4_CORE is not set
 # CONFIG_TEHUTI is not set
+# CONFIG_BNX2X is not set
 # CONFIG_TR is not set
 
 #
@@ -623,7 +651,6 @@ CONFIG_NETDEV_10000=y
 # CONFIG_PPP is not set
 # CONFIG_SLIP is not set
 # CONFIG_NET_FC is not set
-# CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
@@ -674,6 +701,7 @@ CONFIG_VT_CONSOLE=y
 CONFIG_HW_CONSOLE=y
 # CONFIG_VT_HW_CONSOLE_BINDING is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
+# CONFIG_NOZOMI is not set
 
 #
 # Serial drivers
@@ -748,14 +776,12 @@ CONFIG_I2C_MPC=y
 #
 # Miscellaneous I2C Chip support
 #
-# CONFIG_SENSORS_DS1337 is not set
-# CONFIG_SENSORS_DS1374 is not set
 # CONFIG_DS1682 is not set
 # CONFIG_SENSORS_EEPROM is not set
 # CONFIG_SENSORS_PCF8574 is not set
-# CONFIG_SENSORS_PCA9539 is not set
+# CONFIG_PCF8575 is not set
 # CONFIG_SENSORS_PCF8591 is not set
-# CONFIG_SENSORS_M41T00 is not set
+# CONFIG_TPS65010 is not set
 # CONFIG_SENSORS_MAX6875 is not set
 # CONFIG_SENSORS_TSL2550 is not set
 # CONFIG_I2C_DEBUG_CORE is not set
@@ -771,6 +797,7 @@ CONFIG_I2C_MPC=y
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
 # CONFIG_HWMON is not set
+CONFIG_THERMAL=y
 # CONFIG_WATCHDOG is not set
 
 #
@@ -798,7 +825,56 @@ CONFIG_DAB=y
 # CONFIG_DRM is not set
 # CONFIG_VGASTATE is not set
 CONFIG_VIDEO_OUTPUT_CONTROL=y
-# CONFIG_FB is not set
+CONFIG_FB=y
+# CONFIG_FIRMWARE_EDID is not set
+# CONFIG_FB_DDC is not set
+CONFIG_FB_CFB_FILLRECT=y
+CONFIG_FB_CFB_COPYAREA=y
+CONFIG_FB_CFB_IMAGEBLIT=y
+# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
+# CONFIG_FB_SYS_FILLRECT is not set
+# CONFIG_FB_SYS_COPYAREA is not set
+# CONFIG_FB_SYS_IMAGEBLIT is not set
+# CONFIG_FB_SYS_FOPS is not set
+CONFIG_FB_DEFERRED_IO=y
+# CONFIG_FB_SVGALIB is not set
+# CONFIG_FB_MACMODES is not set
+# CONFIG_FB_BACKLIGHT is not set
+# CONFIG_FB_MODE_HELPERS is not set
+# CONFIG_FB_TILEBLITTING is not set
+
+#
+# Frame buffer hardware drivers
+#
+# CONFIG_FB_CIRRUS is not set
+# CONFIG_FB_PM2 is not set
+# CONFIG_FB_CYBER2000 is not set
+# CONFIG_FB_OF is not set
+# CONFIG_FB_CT65550 is not set
+# CONFIG_FB_ASILIANT is not set
+# CONFIG_FB_IMSTT is not set
+# CONFIG_FB_VGA16 is not set
+# CONFIG_FB_S1D13XXX is not set
+# CONFIG_FB_NVIDIA is not set
+# CONFIG_FB_RIVA is not set
+# CONFIG_FB_MATROX is not set
+# CONFIG_FB_RADEON is not set
+# CONFIG_FB_ATY128 is not set
+# CONFIG_FB_ATY is not set
+# CONFIG_FB_S3 is not set
+# CONFIG_FB_SAVAGE is not set
+# CONFIG_FB_SIS is not set
+# CONFIG_FB_NEOMAGIC is not set
+# CONFIG_FB_KYRO is not set
+# CONFIG_FB_3DFX is not set
+# CONFIG_FB_VOODOO1 is not set
+# CONFIG_FB_VT8623 is not set
+# CONFIG_FB_TRIDENT is not set
+# CONFIG_FB_ARK is not set
+# CONFIG_FB_PM3 is not set
+CONFIG_FB_FSL_DIU=y
+# CONFIG_FB_IBM_GXT4500 is not set
+# CONFIG_FB_VIRTUAL is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
@@ -812,6 +888,16 @@ CONFIG_VIDEO_OUTPUT_CONTROL=y
 CONFIG_VGA_CONSOLE=y
 # CONFIG_VGACON_SOFT_SCROLLBACK is not set
 CONFIG_DUMMY_CONSOLE=y
+CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
+# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
+# CONFIG_FONTS is not set
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+CONFIG_LOGO=y
+CONFIG_LOGO_LINUX_MONO=y
+CONFIG_LOGO_LINUX_VGA16=y
+CONFIG_LOGO_LINUX_CLUT224=y
 
 #
 # Sound
@@ -859,6 +945,7 @@ CONFIG_SND_VERBOSE_PROCFS=y
 # CONFIG_SND_BT87X is not set
 # CONFIG_SND_CA0106 is not set
 # CONFIG_SND_CMIPCI is not set
+# CONFIG_SND_OXYGEN is not set
 # CONFIG_SND_CS4281 is not set
 # CONFIG_SND_CS46XX is not set
 # CONFIG_SND_CS5530 is not set
@@ -884,6 +971,7 @@ CONFIG_SND_VERBOSE_PROCFS=y
 # CONFIG_SND_HDA_INTEL is not set
 # CONFIG_SND_HDSP is not set
 # CONFIG_SND_HDSPM is not set
+# CONFIG_SND_HIFIER is not set
 # CONFIG_SND_ICE1712 is not set
 # CONFIG_SND_ICE1724 is not set
 # CONFIG_SND_INTEL8X0 is not set
@@ -901,6 +989,7 @@ CONFIG_SND_VERBOSE_PROCFS=y
 # CONFIG_SND_TRIDENT is not set
 # CONFIG_SND_VIA82XX is not set
 # CONFIG_SND_VIA82XX_MODEM is not set
+# CONFIG_SND_VIRTUOSO is not set
 # CONFIG_SND_VX222 is not set
 # CONFIG_SND_YMFPCI is not set
 
@@ -929,6 +1018,10 @@ CONFIG_SND_SOC_MPC8610_HPCD=y
 CONFIG_SND_SOC_CS4270=y
 CONFIG_SND_SOC_CS4270_VD33_ERRATA=y
 
+#
+# Open Sound System
+#
+# CONFIG_SOUND_PRIME is not set
 CONFIG_HID_SUPPORT=y
 CONFIG_HID=y
 # CONFIG_HID_DEBUG is not set
@@ -942,16 +1035,14 @@ CONFIG_USB_ARCH_HAS_EHCI=y
 #
 # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
 #
-
-#
-# USB Gadget Support
-#
 # CONFIG_USB_GADGET is not set
 # CONFIG_MMC is not set
+# CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
 # CONFIG_INFINIBAND is not set
 # CONFIG_EDAC is not set
 # CONFIG_RTC_CLASS is not set
+# CONFIG_DMADEVICES is not set
 
 #
 # Userspace I/O
@@ -970,6 +1061,7 @@ CONFIG_EXT3_FS_XATTR=y
 # CONFIG_EXT3_FS_SECURITY is not set
 # CONFIG_EXT4DEV_FS is not set
 CONFIG_JBD=y
+# CONFIG_JBD_DEBUG is not set
 CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
@@ -977,11 +1069,9 @@ CONFIG_FS_MBCACHE=y
 # CONFIG_XFS_FS is not set
 # CONFIG_GFS2_FS is not set
 # CONFIG_OCFS2_FS is not set
-# CONFIG_MINIX_FS is not set
-# CONFIG_ROMFS_FS is not set
+# CONFIG_DNOTIFY is not set
 # CONFIG_INOTIFY is not set
 # CONFIG_QUOTA is not set
-# CONFIG_DNOTIFY is not set
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
 # CONFIG_FUSE_FS is not set
@@ -1023,8 +1113,10 @@ CONFIG_TMPFS=y
 # CONFIG_EFS_FS is not set
 # CONFIG_CRAMFS is not set
 # CONFIG_VXFS_FS is not set
+# CONFIG_MINIX_FS is not set
 # CONFIG_HPFS_FS is not set
 # CONFIG_QNX4FS_FS is not set
+# CONFIG_ROMFS_FS is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
 CONFIG_NETWORK_FILESYSTEMS=y
@@ -1114,7 +1206,6 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_KOI8_U is not set
 # CONFIG_NLS_UTF8 is not set
 # CONFIG_DLM is not set
-# CONFIG_UCC_SLOW is not set
 
 #
 # Library routines
@@ -1130,7 +1221,7 @@ CONFIG_PLIST=y
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y
-# CONFIG_INSTRUMENTATION is not set
+CONFIG_HAVE_LMB=y
 
 #
 # Kernel hacking
@@ -1140,7 +1231,7 @@ CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
-# CONFIG_DEBUG_FS is not set
+CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_SHIRQ=y
@@ -1149,6 +1240,7 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
 # CONFIG_SLUB_DEBUG_ON is not set
+# CONFIG_SLUB_STATS is not set
 # CONFIG_DEBUG_RT_MUTEXES is not set
 # CONFIG_RT_MUTEX_TESTER is not set
 # CONFIG_DEBUG_SPINLOCK is not set
@@ -1162,14 +1254,15 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
+# CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
 # CONFIG_DEBUG_STACKOVERFLOW is not set
 # CONFIG_DEBUG_STACK_USAGE is not set
 # CONFIG_DEBUG_PAGEALLOC is not set
 # CONFIG_DEBUGGER is not set
+# CONFIG_VIRQ_DEBUG is not set
 # CONFIG_BDI_SWITCH is not set
 # CONFIG_PPC_EARLY_DEBUG is not set
 
@@ -1179,5 +1272,50 @@ CONFIG_FORCED_INLINING=y
 # CONFIG_KEYS is not set
 # CONFIG_SECURITY is not set
 # CONFIG_SECURITY_FILE_CAPABILITIES is not set
-# CONFIG_CRYPTO is not set
+CONFIG_CRYPTO=y
+# CONFIG_CRYPTO_SEQIV is not set
+# CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_HMAC is not set
+# CONFIG_CRYPTO_XCBC is not set
+# CONFIG_CRYPTO_NULL is not set
+# CONFIG_CRYPTO_MD4 is not set
+# CONFIG_CRYPTO_MD5 is not set
+# CONFIG_CRYPTO_SHA1 is not set
+# CONFIG_CRYPTO_SHA256 is not set
+# CONFIG_CRYPTO_SHA512 is not set
+# CONFIG_CRYPTO_WP512 is not set
+# CONFIG_CRYPTO_TGR192 is not set
+# CONFIG_CRYPTO_GF128MUL is not set
+# CONFIG_CRYPTO_ECB is not set
+# CONFIG_CRYPTO_CBC is not set
+# CONFIG_CRYPTO_PCBC is not set
+# CONFIG_CRYPTO_LRW is not set
+# CONFIG_CRYPTO_XTS is not set
+# CONFIG_CRYPTO_CTR is not set
+# CONFIG_CRYPTO_GCM is not set
+# CONFIG_CRYPTO_CCM is not set
+# CONFIG_CRYPTO_CRYPTD is not set
+# CONFIG_CRYPTO_DES is not set
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
+# CONFIG_CRYPTO_SEED is not set
+# CONFIG_CRYPTO_SALSA20 is not set
+# CONFIG_CRYPTO_DEFLATE is not set
+# CONFIG_CRYPTO_MICHAEL_MIC is not set
+# CONFIG_CRYPTO_CRC32C is not set
+# CONFIG_CRYPTO_CAMELLIA is not set
+# CONFIG_CRYPTO_AUTHENC is not set
+# CONFIG_CRYPTO_LZO is not set
+CONFIG_CRYPTO_HW=y
+# CONFIG_CRYPTO_DEV_HIFN_795X is not set
 # CONFIG_PPC_CLOCK is not set
+CONFIG_PPC_LIB_RHEAP=y
diff --git a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
index 0b07485..3288a3e 100644
--- a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
+++ b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
@@ -3,6 +3,7 @@
  *
  * Initial author: Xianghua Xiao <x.xiao@freescale.com>
  * Recode: Jason Jin <jason.jin@freescale.com>
+ *         York Sun <yorksun@freescale.com>
  *
  * Rewrite the interrupt routing. remove the 8259PIC support,
  * All the integrated device in ULI use sideband interrupt.
@@ -38,6 +39,8 @@
 #include <sysdev/fsl_pci.h>
 #include <sysdev/fsl_soc.h>
 
+static unsigned char *pixis_bdcfg0, *pixis_arch;
+
 static struct of_device_id __initdata mpc8610_ids[] = {
 	{ .compatible = "fsl,mpc8610-immr", },
 	{}
@@ -52,8 +55,7 @@ static int __init mpc8610_declare_of_platform_devices(void)
 }
 machine_device_initcall(mpc86xx_hpcd, mpc8610_declare_of_platform_devices);
 
-void __init
-mpc86xx_hpcd_init_irq(void)
+void __init mpc86xx_hpcd_init_irq(void)
 {
 	struct mpic *mpic1;
 	struct device_node *np;
@@ -161,12 +163,158 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AL, 0x5229, quirk_uli5229);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, 0x5288, final_uli5288);
 #endif /* CONFIG_PCI */
 
-static void __init
-mpc86xx_hpcd_setup_arch(void)
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
+
+static u32 get_busfreq(void)
 {
-#ifdef CONFIG_PCI
-	struct device_node *np;
+	struct device_node *node;
+
+	u32 fs_busfreq = 0;
+	node = of_find_node_by_type(NULL, "cpu");
+	if (node) {
+		unsigned int size;
+		const unsigned int *prop =
+			of_get_property(node, "bus-frequency", &size);
+		if (prop)
+			fs_busfreq = *prop;
+		of_node_put(node);
+	};
+	return fs_busfreq;
+}
+
+unsigned int mpc8610hpcd_get_pixel_format(unsigned int bits_per_pixel,
+						int monitor_port)
+{
+	static const unsigned long pixelformat[][3] = {
+		{0x88882317, 0x88083218, 0x65052119},
+		{0x88883316, 0x88082219, 0x65053118},
+	};
+	unsigned int pix_fmt, arch_monitor;
+
+	arch_monitor = ((*pixis_arch == 0x01) && (monitor_port == 0))? 0 : 1;
+		/* DVI port for board version 0x01 */
+
+	if (bits_per_pixel == 32)
+		pix_fmt = pixelformat[arch_monitor][0];
+	else if (bits_per_pixel == 24)
+		pix_fmt = pixelformat[arch_monitor][1];
+	else if (bits_per_pixel == 16)
+		pix_fmt = pixelformat[arch_monitor][2];
+	else
+		pix_fmt = pixelformat[1][0];
+
+	return pix_fmt;
+}
+
+void mpc8610hpcd_set_gamma_table(int monitor_port, char *gamma_table_base)
+{
+	int i;
+	if (monitor_port == 2) {		/* dual link LVDS */
+		for (i = 0; i < 256*3; i++)
+			gamma_table_base[i] = (gamma_table_base[i] << 2) |
+					 ((gamma_table_base[i] >> 6) & 0x03);
+	}
+}
+
+void mpc8610hpcd_set_monitor_port(int monitor_port)
+{
+	static const u8 bdcfg[] = {0xBD, 0xB5, 0xA5};
+	if (monitor_port < 3)
+		*pixis_bdcfg0 = bdcfg[monitor_port];
+}
+
+void mpc8610hpcd_set_pixel_clock(unsigned int pixclock)
+{
+	u32 __iomem *clkdvdr;
+	u32 temp;
+	/* variables for pixel clock calcs */
+	ulong  bestval, bestfreq, speed_ccb, minpixclock, maxpixclock;
+	ulong pixval;
+	long err;
+	int i;
+
+	clkdvdr = ioremap(get_immrbase() + 0xe0800, sizeof(u32));
+	if (!clkdvdr) {
+		printk(KERN_ERR "Err: can't map clock divider register!\n");
+		return;
+	}
+
+	/* Pixel Clock configuration */
+	pr_debug("DIU: Bus Frequency = %d\n", get_busfreq());
+	speed_ccb = get_busfreq();
+
+	/* Calculate the pixel clock with the smallest error */
+	/* calculate the following in steps to avoid overflow */
+	pr_debug("DIU pixclock in ps - %d\n", pixclock);
+	temp = 1000000000/pixclock;
+	temp *= 1000;
+	pixclock = temp;
+	pr_debug("DIU pixclock freq - %u\n", pixclock);
+
+	temp = pixclock * 5 / 100;
+	pr_debug("deviation = %d\n", temp);
+	minpixclock = pixclock - temp;
+	maxpixclock = pixclock + temp;
+	pr_debug("DIU minpixclock - %lu\n", minpixclock);
+	pr_debug("DIU maxpixclock - %lu\n", maxpixclock);
+	pixval = speed_ccb/pixclock;
+	pr_debug("DIU pixval = %lu\n", pixval);
+
+	err = 100000000;
+	bestval = pixval;
+	pr_debug("DIU bestval = %lu\n", bestval);
+
+	bestfreq = 0;
+	for (i = -1; i <= 1; i++) {
+		temp = speed_ccb / ((pixval+i) + 1);
+		pr_debug("DIU test pixval i= %d, pixval=%lu, temp freq. = %u\n",
+							i, pixval, temp);
+		if ((temp < minpixclock) || (temp > maxpixclock))
+			pr_debug("DIU exceeds monitor range (%lu to %lu)\n",
+				minpixclock, maxpixclock);
+		else if (abs(temp - pixclock) < err) {
+		  pr_debug("Entered the else if block %d\n", i);
+			err = abs(temp - pixclock);
+			bestval = pixval+i;
+			bestfreq = temp;
+		}
+	}
+
+	pr_debug("DIU chose = %lx\n", bestval);
+	pr_debug("DIU error = %ld\n NomPixClk ", err);
+	pr_debug("DIU: Best Freq = %lx\n", bestfreq);
+	/* Modify PXCLK in GUTS CLKDVDR */
+	pr_debug("DIU: Current value of CLKDVDR = 0x%08x\n", (*clkdvdr));
+	temp = (*clkdvdr) & 0x2000FFFF;
+	*clkdvdr = temp;		/* turn off clock */
+	*clkdvdr = temp | 0x80000000 | (((bestval) & 0x1F) << 16);
+	pr_debug("DIU: Modified value of CLKDVDR = 0x%08x\n", (*clkdvdr));
+	iounmap(clkdvdr);
+}
+
+ssize_t mpc8610hpcd_show_monitor_port(int monitor_port, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE,
+			"%c0 - DVI\n"
+			"%c1 - Single link LVDS\n"
+			"%c2 - Dual link LVDS\n",
+			monitor_port == 0 ? '*' : ' ',
+			monitor_port == 1 ? '*' : ' ',
+			monitor_port == 2 ? '*' : ' ');
+}
+
+int mpc8610hpcd_set_sysfs_monitor_port(int val)
+{
+	return val < 3 ? val : 0;
+}
+
 #endif
+
+static void __init mpc86xx_hpcd_setup_arch(void)
+{
+	struct resource r;
+	struct device_node *np;
+
 	if (ppc_md.progress)
 		ppc_md.progress("mpc86xx_hpcd_setup_arch()", 0);
 
@@ -183,6 +331,33 @@ mpc86xx_hpcd_setup_arch(void)
 		}
         }
 #endif
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
+	preallocate_diu_videomemory();
+	diu_ops.get_pixel_format	= mpc8610hpcd_get_pixel_format;
+	diu_ops.set_gamma_table		= mpc8610hpcd_set_gamma_table;
+	diu_ops.set_monitor_port	= mpc8610hpcd_set_monitor_port;
+	diu_ops.set_pixel_clock		= mpc8610hpcd_set_pixel_clock;
+	diu_ops.show_monitor_port	= mpc8610hpcd_show_monitor_port;
+	diu_ops.set_sysfs_monitor_port	= mpc8610hpcd_set_sysfs_monitor_port;
+#endif
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,fpga-pixis");
+	if (np) {
+		of_address_to_resource(np, 0, &r);
+		of_node_put(np);
+		pixis_bdcfg0 = ioremap(r.start + 0x00000008, sizeof(u8));
+		if (!pixis_bdcfg0) {
+			printk(KERN_ERR "Err: can't map FPGA cfg register!\n");
+			return;
+		}
+		pixis_arch = ioremap(r.start + 0x00000001, sizeof(u8));
+		if (!pixis_arch) {
+			printk(KERN_ERR "Err: can't map FPGA arch register!\n");
+			return;
+		}
+	} else
+		printk(KERN_ERR "Err: "
+				"can't find device node 'fsl,fpga-pixis'\n");
 
 	printk("MPC86xx HPCD board from Freescale Semiconductor\n");
 }
@@ -200,8 +375,7 @@ static int __init mpc86xx_hpcd_probe(void)
 	return 0;
 }
 
-long __init
-mpc86xx_time_init(void)
+long __init mpc86xx_time_init(void)
 {
 	unsigned int temp;
 
diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 2c5388c..38a52c9 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -1438,3 +1438,44 @@ void fsl_rstcr_restart(char *cmd)
 	while (1) ;
 }
 #endif
+
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
+struct platform_diu_data_ops diu_ops = {
+	.diu_size = 1280 * 1024 * 4,	/* default one 1280x1024 buffer */
+};
+EXPORT_SYMBOL(diu_ops);
+
+int __init preallocate_diu_videomemory(void)
+{
+	pr_debug("diu_size=%lu\n", diu_ops.diu_size);
+
+	diu_ops.diu_mem = __alloc_bootmem(diu_ops.diu_size, 8, 0);
+	if (!diu_ops.diu_mem) {
+		printk(KERN_ERR "fsl-diu: cannot allocate %lu bytes\n",
+			diu_ops.diu_size);
+		return -ENOMEM;
+	}
+
+	printk(KERN_INFO "%s: diu_mem=%p\n", __func__, diu_ops.diu_mem);
+
+	rh_init(&diu_ops.diu_rh_info, 4096, ARRAY_SIZE(diu_ops.diu_rh_block),
+		diu_ops.diu_rh_block);
+	return rh_attach_region(&diu_ops.diu_rh_info,
+				(unsigned long) diu_ops.diu_mem,
+				diu_ops.diu_size);
+}
+
+static int __init early_parse_diufb(char *p)
+{
+	if (!p)
+		return 1;
+
+	diu_ops.diu_size = _ALIGN_UP(memparse(p, &p), 8);
+
+	printk(KERN_INFO "%s: diu_size=%lu\n", __func__, diu_ops.diu_size);
+
+	return 0;
+}
+early_param("diufb", early_parse_diufb);
+
+#endif
diff --git a/arch/powerpc/sysdev/fsl_soc.h b/arch/powerpc/sysdev/fsl_soc.h
index 63e7db3..bdc6ca1 100644
--- a/arch/powerpc/sysdev/fsl_soc.h
+++ b/arch/powerpc/sysdev/fsl_soc.h
@@ -16,5 +16,28 @@ extern int fsl_spi_init(struct spi_board_info *board_infos,
 			void (*deactivate_cs)(u8 cs, u8 polarity));
 
 extern void fsl_rstcr_restart(char *cmd);
+
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
+#include <linux/bootmem.h>
+#include <asm/rheap.h>
+struct platform_diu_data_ops {
+	rh_block_t diu_rh_block[16];
+	rh_info_t diu_rh_info;
+	unsigned long diu_size;
+	void *diu_mem;
+
+	unsigned int (*get_pixel_format) (unsigned int bits_per_pixel,
+		int monitor_port);
+	void (*set_gamma_table) (int monitor_port, char *gamma_table_base);
+	void (*set_monitor_port) (int monitor_port);
+	void (*set_pixel_clock) (unsigned int pixclock);
+	ssize_t (*show_monitor_port) (int monitor_port, char *buf);
+	int (*set_sysfs_monitor_port) (int val);
+};
+
+extern struct platform_diu_data_ops diu_ops;
+int __init preallocate_diu_videomemory(void);
+#endif
+
 #endif
 #endif
-- 
1.5.2.2

