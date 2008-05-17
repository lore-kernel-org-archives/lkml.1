Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYEQKsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYEQKsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 06:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYEQKs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 06:48:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:25010 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYEQKsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 06:48:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=Bj5R3s8TCpPICpM2lubrD/ddQXOMHD8fFdignx39qPFu9dlNUtrSzUQUO8QHGR3YU4AZ8xldzRii5QnnRkWBBAKtboMETH1THCFvdZpaXNvc4LD8fVDpeg0/2mYYIt/2sepkzfJotfzzN0kCvq52AsU+PimiE4+tUjtQACVYs10=
Message-ID: <386072610805170348l1dd1162ew5d961b707d154f0@mail.gmail.com>
Date: Sat, 17 May 2008 18:48:20 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin arch/serial driver fixing and updates for 2.6.26-rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: b2e5df9a18e89c19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/Kconfig                       |   12 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig |  348 ++++++++++++----------
 arch/blackfin/configs/BF548-EZKIT_defconfig |  416 +++++++++++++++------------
 arch/blackfin/configs/IP0X_defconfig        |    2 +-
 arch/blackfin/kernel/bfin_dma_5xx.c         |   11 +
 arch/blackfin/kernel/bfin_gpio.c            |   19 ++
 arch/blackfin/kernel/bfin_ksyms.c           |    2 +
 arch/blackfin/kernel/traps.c                |   20 +-
 arch/blackfin/lib/checksum.c                |   21 +-
 arch/blackfin/lib/ins.S                     |   21 ++-
 arch/blackfin/lib/outs.S                    |   16 +-
 arch/blackfin/mach-bf533/boards/stamp.c     |   24 +-
 drivers/serial/8250.c                       |    5 +-
 drivers/serial/8250.h                       |    5 +
 drivers/serial/Kconfig                      |    2 +-
 include/asm-blackfin/bfin-global.h          |    4 +-
 include/asm-blackfin/checksum.h             |   29 +-
 include/asm-blackfin/gpio.h                 |    1 -
 include/asm-blackfin/io.h                   |    2 +
 include/asm-blackfin/mach-bf561/dma.h       |    8 +-
 include/asm-blackfin/serial.h               |    5 +
 21 files changed, 561 insertions(+), 412 deletions(-)
 create mode 100644 include/asm-blackfin/serial.h

Al Viro (1):
      [Blackfin] arch: Blackfin checksum annotations

Cliff Cai (1):
      Blackfin arch: enable a choice to provide 4M DMA memory

Javier Herrero (2):
      8250 Serial Driver: Added support for 8250-class UARTs in HV
Sistemas H8606 board
      Blackfin serial driver: add extra IRQ flag for 8250 serial driver

Michael Hennerich (5):
      Blackfin arch: Check for Anomaly 05000182
      Blackfin arch: Sync channel defines with struct dma_register
dma_io_base_addr.
      Blackfin arch: Add workaround to read edge triggered GPIOs
      Blackfin arch: IO Port functions to read/write unalligned memory
      Blackfin arch: update boards defconfig files

Mike Frysinger (3):
      [Blackfin] arch: rename bf5xx-flash to bfin-async-flash
      Blackfin arch: cleanup the icplb/dcplb multiple hit checks
      Blackfin SPORTS UART Driver: converting BFIN->BLACKFIN

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index fd57085..b87634e 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -479,16 +479,6 @@ comment "Memory Setup"

 comment "Misc"

-config ENET_FLASH_PIN
-	int "PF port/pin used for flash and ethernet sharing"
-	depends on (BFIN533_STAMP)
-	default  0
-	help
-	  PF port/pin used for flash and ethernet sharing to allow other PF
-	  pins to be used on other platforms without having to touch common
-	  code.
-	  For example: PF0 --> 0,PF1 --> 1,PF2 --> 2, etc.
-
 choice
 	prompt "Blackfin Exception Scratch Register"
 	default BFIN_SCRATCH_REG_RETN
@@ -695,6 +685,8 @@ choice
 	prompt "Uncached SDRAM region"
 	default DMA_UNCACHED_1M
 	depends on BFIN_DMA_5XX
+config DMA_UNCACHED_4M
+	bool "Enable 4M DMA region"
 config DMA_UNCACHED_2M
 	bool "Enable 2M DMA region"
 config DMA_UNCACHED_1M
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig
b/arch/blackfin/configs/BF527-EZKIT_defconfig
index 64876df..5e6fb9d 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -1,6 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.16
+# Linux kernel version: 2.6.24.7
+# Fri May 16 10:02:29 2008
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -13,35 +14,34 @@ CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
-CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

 #
-# Code maturity level options
+# General setup
 #
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-
-#
-# General setup
-#
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SYSVIPC=y
-# CONFIG_IPC_NS is not set
 CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_UTS_NS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
 # CONFIG_AUDIT is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+CONFIG_FAIR_GROUP_SCHED=y
+CONFIG_FAIR_USER_SCHED=y
+# CONFIG_FAIR_CGROUP_SCHED is not set
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
 CONFIG_BLK_DEV_INITRD=y
@@ -64,32 +64,24 @@ CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_EVENTFD=y
 CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
-# CONFIG_NP2 is not set
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
+CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
 CONFIG_TINY_SHMEM=y
 CONFIG_BASE_SMALL=0
-
-#
-# Loadable module support
-#
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
-
-#
-# Block layer
-#
 CONFIG_BLOCK=y
 # CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
 # CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set

 #
 # IO Schedulers
@@ -141,7 +133,6 @@ CONFIG_BF_REV_0_0=y
 # CONFIG_BF_REV_ANY is not set
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BF52x=y
-CONFIG_BFIN_SINGLE_CORE=y
 CONFIG_MEM_MT48LC32M16A2TG_75=y
 CONFIG_BFIN527_EZKIT=y

@@ -227,12 +218,14 @@ CONFIG_IRQ_USB_DMA=11
 # Board customizations
 #
 # CONFIG_CMDLINE_BOOL is not set
+CONFIG_BOOT_LOAD=0x1000

 #
 # Clock/PLL Setup
 #
 CONFIG_CLKIN_HZ=25000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
+CONFIG_MAX_MEM_SIZE=512
 CONFIG_MAX_VCO_HZ=600000000
 CONFIG_MIN_VCO_HZ=50000000
 CONFIG_MAX_SCLK_HZ=133333333
@@ -246,13 +239,17 @@ CONFIG_HZ_250=y
 # CONFIG_HZ_300 is not set
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=250
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+# CONFIG_CYCLES_CLOCKSOURCE is not set
+# CONFIG_TICK_ONESHOT is not set
+# CONFIG_NO_HZ is not set
+# CONFIG_HIGH_RES_TIMERS is not set
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y

 #
-# Memory Setup
+# Misc
 #
-CONFIG_MAX_MEM_SIZE=512
-CONFIG_MEM_ADD_WIDTH=10
-CONFIG_BOOT_LOAD=0x1000
 CONFIG_BFIN_SCRATCH_REG_RETN=y
 # CONFIG_BFIN_SCRATCH_REG_RETE is not set
 # CONFIG_BFIN_SCRATCH_REG_CYCLES is not set
@@ -288,12 +285,14 @@ CONFIG_FLATMEM_MANUAL=y
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
-CONFIG_LARGE_ALLOCS=y
+CONFIG_VIRT_TO_BUS=y
 # CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
+# CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
 # CONFIG_DMA_UNCACHED_NONE is not set
@@ -338,10 +337,6 @@ CONFIG_BANK_3=0xFFC0
 #
 # CONFIG_PCI is not set
 # CONFIG_ARCH_SUPPORTS_MSI is not set
-
-#
-# PCCARD (PCMCIA/CardBus) support
-#
 # CONFIG_PCCARD is not set

 #
@@ -357,9 +352,15 @@ CONFIG_BINFMT_ZFLAT=y
 # Power management options
 #
 # CONFIG_PM is not set
+CONFIG_SUSPEND_UP_POSSIBLE=y
 # CONFIG_PM_WAKEUP_BY_GPIO is not set

 #
+# CPU Frequency scaling
+#
+# CONFIG_CPU_FREQ is not set
+
+#
 # Networking
 #
 CONFIG_NET=y
@@ -395,6 +396,7 @@ CONFIG_SYN_COOKIES=y
 CONFIG_INET_XFRM_MODE_TRANSPORT=y
 CONFIG_INET_XFRM_MODE_TUNNEL=y
 CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_LRO is not set
 CONFIG_INET_DIAG=y
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
@@ -421,10 +423,6 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_LAPB is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
 # CONFIG_NET_SCHED is not set

 #
@@ -444,6 +442,7 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_MAC80211 is not set
 # CONFIG_IEEE80211 is not set
 # CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set

 #
 # Device Drivers
@@ -452,14 +451,11 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 #
 # Generic Driver Options
 #
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 # CONFIG_FW_LOADER is not set
 # CONFIG_SYS_HYPERVISOR is not set
-
-#
-# Connector - unified userspace <-> kernelspace linker
-#
 # CONFIG_CONNECTOR is not set
 CONFIG_MTD=y
 # CONFIG_MTD_DEBUG is not set
@@ -479,6 +475,7 @@ CONFIG_MTD_BLOCK=y
 # CONFIG_INFTL is not set
 # CONFIG_RFD_FTL is not set
 # CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set

 #
 # RAM/ROM/Flash chip drivers
@@ -542,39 +539,27 @@ CONFIG_MTD_NAND_IDS=m
 # CONFIG_MTD_NAND_DISKONCHIP is not set
 # CONFIG_MTD_NAND_NANDSIM is not set
 # CONFIG_MTD_NAND_PLATFORM is not set
+# CONFIG_MTD_ALAUDA is not set
 # CONFIG_MTD_ONENAND is not set

 #
 # UBI - Unsorted block images
 #
 # CONFIG_MTD_UBI is not set
-
-#
-# Parallel port support
-#
 # CONFIG_PARPORT is not set
-
-#
-# Plug and Play support
-#
-# CONFIG_PNPACPI is not set
-
-#
-# Block devices
-#
+CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_COW_COMMON is not set
 # CONFIG_BLK_DEV_LOOP is not set
 # CONFIG_BLK_DEV_NBD is not set
+# CONFIG_BLK_DEV_UB is not set
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
-
-#
-# Misc devices
-#
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
 # CONFIG_IDE is not set

 #
@@ -582,22 +567,18 @@ CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 #
 # CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
+# CONFIG_SCSI_DMA is not set
 # CONFIG_SCSI_NETLINK is not set
 # CONFIG_ATA is not set
-
-#
-# Multi-device support (RAID and LVM)
-#
 # CONFIG_MD is not set
-
-#
-# Network device support
-#
 CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
+# CONFIG_VETH is not set
 CONFIG_PHYLIB=y

 #
@@ -611,21 +592,24 @@ CONFIG_PHYLIB=y
 # CONFIG_VITESSE_PHY is not set
 # CONFIG_SMSC_PHY is not set
 # CONFIG_BROADCOM_PHY is not set
+# CONFIG_ICPLUS_PHY is not set
 # CONFIG_FIXED_PHY is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
+# CONFIG_MDIO_BITBANG is not set
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
-# CONFIG_SMC91X is not set
 CONFIG_BFIN_MAC=y
 CONFIG_BFIN_MAC_USE_L1=y
 CONFIG_BFIN_TX_DESC_NUM=10
 CONFIG_BFIN_RX_DESC_NUM=20
 CONFIG_BFIN_MAC_RMII=y
+# CONFIG_SMC91X is not set
 # CONFIG_SMSC911X is not set
 # CONFIG_DM9000 is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -635,6 +619,15 @@ CONFIG_NETDEV_10000=y
 #
 # CONFIG_WLAN_PRE80211 is not set
 # CONFIG_WLAN_80211 is not set
+
+#
+# USB Network Adapters
+#
+# CONFIG_USB_CATC is not set
+# CONFIG_USB_KAWETH is not set
+# CONFIG_USB_PEGASUS is not set
+# CONFIG_USB_RTL8150 is not set
+# CONFIG_USB_USBNET is not set
 # CONFIG_WAN is not set
 # CONFIG_PPP is not set
 # CONFIG_SLIP is not set
@@ -642,15 +635,7 @@ CONFIG_NETDEV_10000=y
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
-
-#
-# ISDN subsystem
-#
 # CONFIG_ISDN is not set
-
-#
-# Telephony Support
-#
 # CONFIG_PHONE is not set

 #
@@ -665,7 +650,6 @@ CONFIG_INPUT=y
 #
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_JOYDEV is not set
-# CONFIG_INPUT_TSDEV is not set
 # CONFIG_INPUT_EVDEV is not set
 # CONFIG_INPUT_EVBUG is not set

@@ -697,7 +681,6 @@ CONFIG_INPUT_MISC=y
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
@@ -706,7 +689,7 @@ CONFIG_BFIN_OTP=y
 # CONFIG_BFIN_SPORT is not set
 # CONFIG_BFIN_TIMER_LATENCY is not set
 # CONFIG_TWI_LCD is not set
-# CONFIG_AD5304 is not set
+# CONFIG_SIMPLE_GPIO is not set
 # CONFIG_VT is not set
 # CONFIG_SERIAL_NONSTANDARD is not set

@@ -735,27 +718,11 @@ CONFIG_UNIX98_PTYS=y
 # CAN, the car bus and industrial fieldbus
 #
 # CONFIG_CAN4LINUX is not set
-
-#
-# IPMI
-#
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_WATCHDOG=y
-# CONFIG_WATCHDOG_NOWAYOUT is not set
-
-#
-# Watchdog Device Drivers
-#
-# CONFIG_SOFT_WATCHDOG is not set
-CONFIG_BFIN_WDT=y
 CONFIG_HW_RANDOM=y
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
-
-#
-# TPM devices
-#
 # CONFIG_TCG_TPM is not set
 CONFIG_I2C=y
 CONFIG_I2C_BOARDINFO=y
@@ -777,21 +744,24 @@ CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=50
 # CONFIG_I2C_OCORES is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_SIMTEC is not set
+# CONFIG_I2C_TAOS_EVM is not set
 # CONFIG_I2C_STUB is not set
+# CONFIG_I2C_TINY_USB is not set

 #
 # Miscellaneous I2C Chip support
 #
 # CONFIG_SENSORS_DS1337 is not set
 # CONFIG_SENSORS_DS1374 is not set
+# CONFIG_DS1682 is not set
 # CONFIG_SENSORS_AD5252 is not set
 # CONFIG_SENSORS_EEPROM is not set
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_SENSORS_PCF8575 is not set
-# CONFIG_SENSORS_PCA9543 is not set
 # CONFIG_SENSORS_PCA9539 is not set
 # CONFIG_SENSORS_PCF8591 is not set
 # CONFIG_SENSORS_MAX6875 is not set
+# CONFIG_SENSORS_TSL2550 is not set
 # CONFIG_I2C_DEBUG_CORE is not set
 # CONFIG_I2C_DEBUG_ALGO is not set
 # CONFIG_I2C_DEBUG_BUS is not set
@@ -814,14 +784,11 @@ CONFIG_SPI_BFIN=y
 #
 # CONFIG_SPI_AT25 is not set
 # CONFIG_SPI_SPIDEV is not set
-
-#
-# Dallas's 1-wire bus
-#
+# CONFIG_SPI_TLE62X0 is not set
 # CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
 CONFIG_HWMON=y
 # CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_ABITUGURU is not set
 # CONFIG_SENSORS_AD7418 is not set
 # CONFIG_SENSORS_ADM1021 is not set
 # CONFIG_SENSORS_ADM1025 is not set
@@ -829,12 +796,12 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_ADM1029 is not set
 # CONFIG_SENSORS_ADM1031 is not set
 # CONFIG_SENSORS_ADM9240 is not set
-# CONFIG_SENSORS_ASB100 is not set
+# CONFIG_SENSORS_ADT7470 is not set
 # CONFIG_SENSORS_ATXP1 is not set
 # CONFIG_SENSORS_DS1621 is not set
 # CONFIG_SENSORS_F71805F is not set
-# CONFIG_SENSORS_FSCHER is not set
-# CONFIG_SENSORS_FSCPOS is not set
+# CONFIG_SENSORS_F71882FG is not set
+# CONFIG_SENSORS_F75375S is not set
 # CONFIG_SENSORS_GL518SM is not set
 # CONFIG_SENSORS_GL520SM is not set
 # CONFIG_SENSORS_IT87 is not set
@@ -849,13 +816,16 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_LM87 is not set
 # CONFIG_SENSORS_LM90 is not set
 # CONFIG_SENSORS_LM92 is not set
+# CONFIG_SENSORS_LM93 is not set
 # CONFIG_SENSORS_MAX1619 is not set
 # CONFIG_SENSORS_MAX6650 is not set
 # CONFIG_SENSORS_PC87360 is not set
 # CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_DME1737 is not set
 # CONFIG_SENSORS_SMSC47M1 is not set
 # CONFIG_SENSORS_SMSC47M192 is not set
 # CONFIG_SENSORS_SMSC47B397 is not set
+# CONFIG_SENSORS_THMC50 is not set
 # CONFIG_SENSORS_VT1211 is not set
 # CONFIG_SENSORS_W83781D is not set
 # CONFIG_SENSORS_W83791D is not set
@@ -865,6 +835,25 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_W83627HF is not set
 # CONFIG_SENSORS_W83627EHF is not set
 # CONFIG_HWMON_DEBUG_CHIP is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
+
+#
+# USB-based Watchdog Cards
+#
+# CONFIG_USBPCWATCHDOG is not set
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set

 #
 # Multifunction device drivers
@@ -881,72 +870,133 @@ CONFIG_HWMON=y
 #
 # Graphics support
 #
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
+# CONFIG_FB is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set

 #
 # Display device support
 #
 # CONFIG_DISPLAY_SUPPORT is not set
-# CONFIG_VGASTATE is not set
-# CONFIG_FB is not set

 #
 # Sound
 #
 # CONFIG_SOUND is not set
-
-#
-# HID Devices
-#
+CONFIG_HID_SUPPORT=y
 CONFIG_HID=y
 # CONFIG_HID_DEBUG is not set
+# CONFIG_HIDRAW is not set

 #
-# USB support
+# USB Input Devices
 #
+CONFIG_USB_HID=y
+# CONFIG_USB_HIDINPUT_POWERBOOK is not set
+# CONFIG_HID_FF is not set
+# CONFIG_USB_HIDDEV is not set
+CONFIG_USB_SUPPORT=y
 CONFIG_USB_ARCH_HAS_HCD=y
 # CONFIG_USB_ARCH_HAS_OHCI is not set
 # CONFIG_USB_ARCH_HAS_EHCI is not set
-# CONFIG_USB is not set
+CONFIG_USB=y
+# CONFIG_USB_DEBUG is not set
+
+#
+# Miscellaneous USB options
+#
+# CONFIG_USB_DEVICEFS is not set
+CONFIG_USB_DEVICE_CLASS=y
+# CONFIG_USB_DYNAMIC_MINORS is not set
+# CONFIG_USB_OTG is not set
+# CONFIG_USB_OTG_WHITELIST is not set
+CONFIG_USB_OTG_BLACKLIST_HUB=y
+
+#
+# USB Host Controller Drivers
+#
+# CONFIG_USB_ISP116X_HCD is not set
+# CONFIG_USB_ISP1362_HCD is not set
+# CONFIG_USB_ISP1760_HCD is not set
+# CONFIG_USB_SL811_HCD is not set
+# CONFIG_USB_R8A66597_HCD is not set
+CONFIG_USB_MUSB_HDRC=y
+CONFIG_USB_MUSB_SOC=y

 #
-# Enable Host or Gadget support to see Inventra options
+# Blackfin high speed USB support
 #
+CONFIG_USB_MUSB_HOST=y
+# CONFIG_USB_MUSB_PERIPHERAL is not set
+# CONFIG_USB_MUSB_OTG is not set
+CONFIG_USB_MUSB_HDRC_HCD=y
+CONFIG_MUSB_PIO_ONLY=y
+CONFIG_USB_MUSB_LOGLEVEL=0
+
+#
+# USB Device Class drivers
+#
+# CONFIG_USB_ACM is not set
+# CONFIG_USB_PRINTER is not set

 #
 # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
 #

 #
-# USB Gadget Support
+# may also be needed; see USB_STORAGE Help for more information
 #
-# CONFIG_USB_GADGET is not set
-# CONFIG_MMC is not set
+# CONFIG_USB_LIBUSUAL is not set

 #
-# LED devices
+# USB Imaging devices
 #
-# CONFIG_NEW_LEDS is not set
+# CONFIG_USB_MDC800 is not set
+CONFIG_USB_MON=y

 #
-# LED drivers
+# USB port drivers
 #

 #
-# LED Triggers
+# USB Serial Converter support
 #
+# CONFIG_USB_SERIAL is not set

 #
-# InfiniBand support
+# USB Miscellaneous drivers
 #
+# CONFIG_USB_EMI62 is not set
+# CONFIG_USB_EMI26 is not set
+# CONFIG_USB_ADUTUX is not set
+# CONFIG_USB_AUERSWALD is not set
+# CONFIG_USB_RIO500 is not set
+# CONFIG_USB_LEGOTOWER is not set
+# CONFIG_USB_LCD is not set
+# CONFIG_USB_BERRY_CHARGE is not set
+# CONFIG_USB_LED is not set
+# CONFIG_USB_CYPRESS_CY7C63 is not set
+# CONFIG_USB_CYTHERM is not set
+# CONFIG_USB_PHIDGET is not set
+# CONFIG_USB_IDMOUSE is not set
+# CONFIG_USB_FTDI_ELAN is not set
+# CONFIG_USB_APPLEDISPLAY is not set
+# CONFIG_USB_SISUSBVGA is not set
+# CONFIG_USB_LD is not set
+# CONFIG_USB_TRANCEVIBRATOR is not set
+# CONFIG_USB_IOWARRIOR is not set

 #
-# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+# USB DSL modem support
 #

 #
-# Real Time Clock
+# USB Gadget Support
 #
+# CONFIG_USB_GADGET is not set
+# CONFIG_MMC is not set
+# CONFIG_NEW_LEDS is not set
 CONFIG_RTC_LIB=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_HCTOSYS=y
@@ -966,6 +1016,7 @@ CONFIG_RTC_INTF_DEV=y
 # I2C RTC drivers
 #
 # CONFIG_RTC_DRV_DS1307 is not set
+# CONFIG_RTC_DRV_DS1374 is not set
 # CONFIG_RTC_DRV_DS1672 is not set
 # CONFIG_RTC_DRV_MAX6900 is not set
 # CONFIG_RTC_DRV_RS5C372 is not set
@@ -973,6 +1024,7 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_X1205 is not set
 # CONFIG_RTC_DRV_PCF8563 is not set
 # CONFIG_RTC_DRV_PCF8583 is not set
+# CONFIG_RTC_DRV_M41T80 is not set

 #
 # SPI RTC drivers
@@ -984,8 +1036,10 @@ CONFIG_RTC_INTF_DEV=y
 # Platform RTC drivers
 #
 # CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
 # CONFIG_RTC_DRV_DS1742 is not set
 # CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
 # CONFIG_RTC_DRV_V3020 is not set

 #
@@ -994,22 +1048,9 @@ CONFIG_RTC_INTF_DEV=y
 CONFIG_RTC_DRV_BFIN=y

 #
-# DMA Engine support
-#
-# CONFIG_DMA_ENGINE is not set
-
-#
-# DMA Clients
+# Userspace I/O
 #
-
-#
-# DMA Devices
-#
-
-#
-# PBX support
-#
-# CONFIG_PBX is not set
+# CONFIG_UIO is not set

 #
 # File systems
@@ -1054,7 +1095,6 @@ CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 # CONFIG_TMPFS is not set
 # CONFIG_HUGETLB_PAGE is not set
-CONFIG_RAMFS=y
 # CONFIG_CONFIGFS_FS is not set

 #
@@ -1080,10 +1120,12 @@ CONFIG_YAFFS_SHORT_NAMES_IN_RAM=y
 CONFIG_JFFS2_FS=m
 CONFIG_JFFS2_FS_DEBUG=0
 CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
 # CONFIG_JFFS2_SUMMARY is not set
 # CONFIG_JFFS2_FS_XATTR is not set
 # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
 CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
 CONFIG_JFFS2_RTIME=y
 # CONFIG_JFFS2_RUBIN is not set
 # CONFIG_CRAMFS is not set
@@ -1092,10 +1134,7 @@ CONFIG_JFFS2_RTIME=y
 # CONFIG_QNX4FS_FS is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
+CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=m
 CONFIG_NFS_V3=y
 # CONFIG_NFS_V3_ACL is not set
@@ -1115,17 +1154,12 @@ CONFIG_SMB_FS=m
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set

 #
 # Partition Types
 #
 # CONFIG_PARTITION_ADVANCED is not set
 CONFIG_MSDOS_PARTITION=y
-
-#
-# Native Language Support
-#
 CONFIG_NLS=m
 CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_CODEPAGE_437 is not set
@@ -1166,21 +1200,16 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_KOI8_R is not set
 # CONFIG_NLS_KOI8_U is not set
 # CONFIG_NLS_UTF8 is not set
-
-#
-# Distributed Lock Manager
-#
 # CONFIG_DLM is not set
-
-#
-# Profiling support
-#
+CONFIG_INSTRUMENTATION=y
 # CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set

 #
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
@@ -1188,6 +1217,7 @@ CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_SAMPLES is not set
 CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
@@ -1207,11 +1237,8 @@ CONFIG_ACCESS_CHECK=y
 # CONFIG_KEYS is not set
 CONFIG_SECURITY=y
 # CONFIG_SECURITY_NETWORK is not set
-CONFIG_SECURITY_CAPABILITIES=m
-
-#
-# Cryptographic options
-#
+# CONFIG_SECURITY_CAPABILITIES is not set
+# CONFIG_SECURITY_ROOTPLUG is not set
 # CONFIG_CRYPTO is not set

 #
@@ -1222,6 +1249,7 @@ CONFIG_CRC_CCITT=m
 # CONFIG_CRC16 is not set
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=m
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig
b/arch/blackfin/configs/BF548-EZKIT_defconfig
index 5bfdfb2..1ff2ff4 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.16
+# Linux kernel version: 2.6.24.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -13,35 +13,34 @@ CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
-CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

 #
-# Code maturity level options
+# General setup
 #
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-
-#
-# General setup
-#
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SYSVIPC=y
-# CONFIG_IPC_NS is not set
 CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_UTS_NS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
 # CONFIG_AUDIT is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+CONFIG_FAIR_GROUP_SCHED=y
+CONFIG_FAIR_USER_SCHED=y
+# CONFIG_FAIR_CGROUP_SCHED is not set
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
 CONFIG_BLK_DEV_INITRD=y
@@ -64,32 +63,24 @@ CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_EVENTFD=y
 CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
-# CONFIG_NP2 is not set
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
+CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
 CONFIG_TINY_SHMEM=y
 CONFIG_BASE_SMALL=0
-
-#
-# Loadable module support
-#
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
-
-#
-# Block layer
-#
 CONFIG_BLOCK=y
 # CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
 # CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set

 #
 # IO Schedulers
@@ -141,7 +132,6 @@ CONFIG_BF_REV_0_0=y
 # CONFIG_BF_REV_ANY is not set
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BF54x=y
-CONFIG_BFIN_SINGLE_CORE=y
 CONFIG_IRQ_PLL_WAKEUP=7
 CONFIG_IRQ_RTC=8
 CONFIG_IRQ_SPORT0_RX=9
@@ -169,6 +159,7 @@ CONFIG_IRQ_TIMER8=11
 CONFIG_IRQ_TIMER9=11
 CONFIG_IRQ_TIMER10=11
 CONFIG_BFIN548_EZKIT=y
+# CONFIG_BFIN548_BLUETECHNIX_CM is not set

 #
 # BF548 Specific Configuration
@@ -262,12 +253,14 @@ CONFIG_PINT3_ASSIGN=0x02020303
 # Board customizations
 #
 # CONFIG_CMDLINE_BOOL is not set
+CONFIG_BOOT_LOAD=0x1000

 #
 # Clock/PLL Setup
 #
 CONFIG_CLKIN_HZ=25000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
+CONFIG_MAX_MEM_SIZE=512
 CONFIG_MAX_VCO_HZ=600000000
 CONFIG_MIN_VCO_HZ=50000000
 CONFIG_MAX_SCLK_HZ=133333333
@@ -281,14 +274,17 @@ CONFIG_HZ_250=y
 # CONFIG_HZ_300 is not set
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=250
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+# CONFIG_CYCLES_CLOCKSOURCE is not set
+# CONFIG_TICK_ONESHOT is not set
+# CONFIG_NO_HZ is not set
+# CONFIG_HIGH_RES_TIMERS is not set
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y

 #
-# Memory Setup
+# Misc
 #
-CONFIG_MAX_MEM_SIZE=512
-# CONFIG_MEM_MT46V32M16_6T is not set
-CONFIG_MEM_MT46V32M16_5B=y
-CONFIG_BOOT_LOAD=0x1000
 CONFIG_BFIN_SCRATCH_REG_RETN=y
 # CONFIG_BFIN_SCRATCH_REG_RETE is not set
 # CONFIG_BFIN_SCRATCH_REG_CYCLES is not set
@@ -324,12 +320,14 @@ CONFIG_FLATMEM_MANUAL=y
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
-CONFIG_LARGE_ALLOCS=y
+CONFIG_VIRT_TO_BUS=y
 # CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
+# CONFIG_DMA_UNCACHED_4M is not set
 CONFIG_DMA_UNCACHED_2M=y
 # CONFIG_DMA_UNCACHED_1M is not set
 # CONFIG_DMA_UNCACHED_NONE is not set
@@ -377,10 +375,6 @@ CONFIG_EBIU_FCTLVAL=0x6
 #
 # CONFIG_PCI is not set
 # CONFIG_ARCH_SUPPORTS_MSI is not set
-
-#
-# PCCARD (PCMCIA/CardBus) support
-#
 # CONFIG_PCCARD is not set

 #
@@ -396,6 +390,7 @@ CONFIG_BINFMT_ZFLAT=y
 # Power management options
 #
 # CONFIG_PM is not set
+CONFIG_SUSPEND_UP_POSSIBLE=y
 # CONFIG_PM_WAKEUP_BY_GPIO is not set

 #
@@ -439,6 +434,7 @@ CONFIG_SYN_COOKIES=y
 CONFIG_INET_XFRM_MODE_TRANSPORT=y
 CONFIG_INET_XFRM_MODE_TUNNEL=y
 CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_LRO is not set
 CONFIG_INET_DIAG=y
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
@@ -465,10 +461,6 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_LAPB is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
 # CONFIG_NET_SCHED is not set

 #
@@ -488,6 +480,7 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_MAC80211 is not set
 # CONFIG_IEEE80211 is not set
 # CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set

 #
 # Device Drivers
@@ -496,14 +489,11 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 #
 # Generic Driver Options
 #
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 # CONFIG_FW_LOADER is not set
 # CONFIG_SYS_HYPERVISOR is not set
-
-#
-# Connector - unified userspace <-> kernelspace linker
-#
 # CONFIG_CONNECTOR is not set
 CONFIG_MTD=y
 # CONFIG_MTD_DEBUG is not set
@@ -523,6 +513,7 @@ CONFIG_MTD_BLOCK=y
 # CONFIG_INFTL is not set
 # CONFIG_RFD_FTL is not set
 # CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set

 #
 # RAM/ROM/Flash chip drivers
@@ -587,39 +578,27 @@ CONFIG_MTD_NAND_BF5XX_HWECC=y
 # CONFIG_MTD_NAND_DISKONCHIP is not set
 # CONFIG_MTD_NAND_NANDSIM is not set
 # CONFIG_MTD_NAND_PLATFORM is not set
+# CONFIG_MTD_ALAUDA is not set
 # CONFIG_MTD_ONENAND is not set

 #
 # UBI - Unsorted block images
 #
 # CONFIG_MTD_UBI is not set
-
-#
-# Parallel port support
-#
 # CONFIG_PARPORT is not set
-
-#
-# Plug and Play support
-#
-# CONFIG_PNPACPI is not set
-
-#
-# Block devices
-#
+CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_COW_COMMON is not set
 # CONFIG_BLK_DEV_LOOP is not set
 # CONFIG_BLK_DEV_NBD is not set
+# CONFIG_BLK_DEV_UB is not set
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
-
-#
-# Misc devices
-#
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
 # CONFIG_IDE is not set

 #
@@ -627,6 +606,7 @@ CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 #
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
+CONFIG_SCSI_DMA=y
 # CONFIG_SCSI_TGT is not set
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
@@ -657,43 +637,35 @@ CONFIG_SCSI_WAIT_SCAN=m
 # CONFIG_SCSI_SPI_ATTRS is not set
 # CONFIG_SCSI_FC_ATTRS is not set
 # CONFIG_SCSI_ISCSI_ATTRS is not set
-# CONFIG_SCSI_SAS_ATTRS is not set
 # CONFIG_SCSI_SAS_LIBSAS is not set
-
-#
-# SCSI low-level drivers
-#
+# CONFIG_SCSI_SRP_ATTRS is not set
+CONFIG_SCSI_LOWLEVEL=y
 # CONFIG_ISCSI_TCP is not set
 # CONFIG_SCSI_DEBUG is not set
 CONFIG_ATA=y
 # CONFIG_ATA_NONSTANDARD is not set
 # CONFIG_PATA_PLATFORM is not set
 CONFIG_PATA_BF54X=y
-CONFIG_PATA_BF54X_DMA=y
-
-#
-# Multi-device support (RAID and LVM)
-#
 # CONFIG_MD is not set
-
-#
-# Network device support
-#
 CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
+# CONFIG_VETH is not set
 # CONFIG_PHYLIB is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
 # CONFIG_SMC91X is not set
 CONFIG_SMSC911X=y
 # CONFIG_DM9000 is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -703,6 +675,15 @@ CONFIG_NETDEV_10000=y
 #
 # CONFIG_WLAN_PRE80211 is not set
 # CONFIG_WLAN_80211 is not set
+
+#
+# USB Network Adapters
+#
+# CONFIG_USB_CATC is not set
+# CONFIG_USB_KAWETH is not set
+# CONFIG_USB_PEGASUS is not set
+# CONFIG_USB_RTL8150 is not set
+# CONFIG_USB_USBNET is not set
 # CONFIG_WAN is not set
 # CONFIG_PPP is not set
 # CONFIG_SLIP is not set
@@ -710,15 +691,7 @@ CONFIG_NETDEV_10000=y
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
-
-#
-# ISDN subsystem
-#
 # CONFIG_ISDN is not set
-
-#
-# Telephony Support
-#
 # CONFIG_PHONE is not set

 #
@@ -733,9 +706,6 @@ CONFIG_INPUT=y
 #
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_JOYDEV is not set
-CONFIG_INPUT_TSDEV=m
-CONFIG_INPUT_TSDEV_SCREEN_X=240
-CONFIG_INPUT_TSDEV_SCREEN_Y=320
 CONFIG_INPUT_EVDEV=m
 CONFIG_INPUT_EVBUG=m

@@ -758,6 +728,7 @@ CONFIG_KEYBOARD_BFIN=y
 CONFIG_INPUT_TOUCHSCREEN=y
 # CONFIG_TOUCHSCREEN_ADS7846 is not set
 CONFIG_TOUCHSCREEN_AD7877=m
+# CONFIG_TOUCHSCREEN_FUJITSU is not set
 # CONFIG_TOUCHSCREEN_GUNZE is not set
 # CONFIG_TOUCHSCREEN_ELO is not set
 # CONFIG_TOUCHSCREEN_MTOUCH is not set
@@ -787,7 +758,6 @@ CONFIG_INPUT_MISC=y
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
@@ -796,7 +766,7 @@ CONFIG_BFIN_OTP=y
 # CONFIG_BFIN_SPORT is not set
 # CONFIG_BFIN_TIMER_LATENCY is not set
 # CONFIG_TWI_LCD is not set
-# CONFIG_AD5304 is not set
+# CONFIG_SIMPLE_GPIO is not set
 CONFIG_VT=y
 CONFIG_VT_CONSOLE=y
 CONFIG_HW_CONSOLE=y
@@ -830,27 +800,11 @@ CONFIG_UNIX98_PTYS=y
 # CAN, the car bus and industrial fieldbus
 #
 # CONFIG_CAN4LINUX is not set
-
-#
-# IPMI
-#
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_WATCHDOG=y
-# CONFIG_WATCHDOG_NOWAYOUT is not set
-
-#
-# Watchdog Device Drivers
-#
-# CONFIG_SOFT_WATCHDOG is not set
-CONFIG_BFIN_WDT=y
 CONFIG_HW_RANDOM=y
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
-
-#
-# TPM devices
-#
 # CONFIG_TCG_TPM is not set
 CONFIG_I2C=y
 CONFIG_I2C_BOARDINFO=y
@@ -872,21 +826,24 @@ CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=50
 # CONFIG_I2C_OCORES is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_SIMTEC is not set
+# CONFIG_I2C_TAOS_EVM is not set
 # CONFIG_I2C_STUB is not set
+# CONFIG_I2C_TINY_USB is not set

 #
 # Miscellaneous I2C Chip support
 #
 # CONFIG_SENSORS_DS1337 is not set
 # CONFIG_SENSORS_DS1374 is not set
+# CONFIG_DS1682 is not set
 # CONFIG_SENSORS_AD5252 is not set
 # CONFIG_SENSORS_EEPROM is not set
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_SENSORS_PCF8575 is not set
-# CONFIG_SENSORS_PCA9543 is not set
 # CONFIG_SENSORS_PCA9539 is not set
 # CONFIG_SENSORS_PCF8591 is not set
 # CONFIG_SENSORS_MAX6875 is not set
+# CONFIG_SENSORS_TSL2550 is not set
 # CONFIG_I2C_DEBUG_CORE is not set
 # CONFIG_I2C_DEBUG_ALGO is not set
 # CONFIG_I2C_DEBUG_BUS is not set
@@ -909,14 +866,11 @@ CONFIG_SPI_BFIN=y
 #
 # CONFIG_SPI_AT25 is not set
 # CONFIG_SPI_SPIDEV is not set
-
-#
-# Dallas's 1-wire bus
-#
+# CONFIG_SPI_TLE62X0 is not set
 # CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
 CONFIG_HWMON=y
 # CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_ABITUGURU is not set
 # CONFIG_SENSORS_AD7418 is not set
 # CONFIG_SENSORS_ADM1021 is not set
 # CONFIG_SENSORS_ADM1025 is not set
@@ -924,12 +878,12 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_ADM1029 is not set
 # CONFIG_SENSORS_ADM1031 is not set
 # CONFIG_SENSORS_ADM9240 is not set
-# CONFIG_SENSORS_ASB100 is not set
+# CONFIG_SENSORS_ADT7470 is not set
 # CONFIG_SENSORS_ATXP1 is not set
 # CONFIG_SENSORS_DS1621 is not set
 # CONFIG_SENSORS_F71805F is not set
-# CONFIG_SENSORS_FSCHER is not set
-# CONFIG_SENSORS_FSCPOS is not set
+# CONFIG_SENSORS_F71882FG is not set
+# CONFIG_SENSORS_F75375S is not set
 # CONFIG_SENSORS_GL518SM is not set
 # CONFIG_SENSORS_GL520SM is not set
 # CONFIG_SENSORS_IT87 is not set
@@ -944,13 +898,16 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_LM87 is not set
 # CONFIG_SENSORS_LM90 is not set
 # CONFIG_SENSORS_LM92 is not set
+# CONFIG_SENSORS_LM93 is not set
 # CONFIG_SENSORS_MAX1619 is not set
 # CONFIG_SENSORS_MAX6650 is not set
 # CONFIG_SENSORS_PC87360 is not set
 # CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_DME1737 is not set
 # CONFIG_SENSORS_SMSC47M1 is not set
 # CONFIG_SENSORS_SMSC47M192 is not set
 # CONFIG_SENSORS_SMSC47B397 is not set
+# CONFIG_SENSORS_THMC50 is not set
 # CONFIG_SENSORS_VT1211 is not set
 # CONFIG_SENSORS_W83781D is not set
 # CONFIG_SENSORS_W83791D is not set
@@ -960,6 +917,25 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_W83627HF is not set
 # CONFIG_SENSORS_W83627EHF is not set
 # CONFIG_HWMON_DEBUG_CHIP is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
+
+#
+# USB-based Watchdog Cards
+#
+# CONFIG_USBPCWATCHDOG is not set
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set

 #
 # Multifunction device drivers
@@ -972,23 +948,20 @@ CONFIG_HWMON=y
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
 CONFIG_DAB=y
+# CONFIG_USB_DABUSB is not set

 #
 # Graphics support
 #
-# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
-
-#
-# Display device support
-#
-# CONFIG_DISPLAY_SUPPORT is not set
 # CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
 CONFIG_FB=y
 CONFIG_FIRMWARE_EDID=y
 # CONFIG_FB_DDC is not set
 CONFIG_FB_CFB_FILLRECT=y
 CONFIG_FB_CFB_COPYAREA=y
 CONFIG_FB_CFB_IMAGEBLIT=y
+# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
 # CONFIG_FB_SYS_FILLRECT is not set
 # CONFIG_FB_SYS_COPYAREA is not set
 # CONFIG_FB_SYS_IMAGEBLIT is not set
@@ -1003,18 +976,24 @@ CONFIG_FB_DEFERRED_IO=y
 #
 # Frame buffer hardware drivers
 #
-# CONFIG_FB_BFIN_7171 is not set
-# CONFIG_FB_BFIN_7393 is not set
 CONFIG_FB_BF54X_LQ043=y
 # CONFIG_FB_BFIN_T350MCQB is not set
+# CONFIG_FB_BFIN_7393 is not set
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set

 #
 # Console display driver support
 #
 CONFIG_DUMMY_CONSOLE=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
 # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
 CONFIG_FONTS=y
 # CONFIG_FONT_8x8 is not set
@@ -1065,10 +1044,21 @@ CONFIG_SND_VERBOSE_PROCFS=y
 # CONFIG_SND_MPU401 is not set

 #
+# SPI devices
+#
+
+#
 # ALSA Blackfin devices
 #
 # CONFIG_SND_BLACKFIN_AD1836 is not set
 # CONFIG_SND_BFIN_AD73311 is not set
+# CONFIG_SND_BFIN_AD73322 is not set
+
+#
+# USB devices
+#
+# CONFIG_SND_USB_AUDIO is not set
+# CONFIG_SND_USB_CAIAQ is not set

 #
 # System on Chip audio support
@@ -1084,6 +1074,10 @@ CONFIG_SND_BF5XX_SOC_BF548_EZKIT=y
 CONFIG_SND_BF5XX_SPORT_NUM=0
 CONFIG_SND_BF5XX_HAVE_COLD_RESET=y
 CONFIG_SND_BF5XX_RESET_GPIO_NUM=19
+
+#
+# SoC Audio support for SuperH
+#
 CONFIG_SND_SOC_AD1980=y

 #
@@ -1091,72 +1085,152 @@ CONFIG_SND_SOC_AD1980=y
 #
 # CONFIG_SOUND_PRIME is not set
 CONFIG_AC97_BUS=y
-
-#
-# HID Devices
-#
-CONFIG_HID=m
+CONFIG_HID_SUPPORT=y
+CONFIG_HID=y
 # CONFIG_HID_DEBUG is not set
+# CONFIG_HIDRAW is not set

 #
-# USB support
+# USB Input Devices
 #
+CONFIG_USB_HID=y
+# CONFIG_USB_HIDINPUT_POWERBOOK is not set
+# CONFIG_HID_FF is not set
+# CONFIG_USB_HIDDEV is not set
+CONFIG_USB_SUPPORT=y
 CONFIG_USB_ARCH_HAS_HCD=y
 # CONFIG_USB_ARCH_HAS_OHCI is not set
 # CONFIG_USB_ARCH_HAS_EHCI is not set
-# CONFIG_USB is not set
+CONFIG_USB=y
+# CONFIG_USB_DEBUG is not set
+
+#
+# Miscellaneous USB options
+#
+# CONFIG_USB_DEVICEFS is not set
+CONFIG_USB_DEVICE_CLASS=y
+# CONFIG_USB_DYNAMIC_MINORS is not set
+# CONFIG_USB_OTG is not set
+# CONFIG_USB_OTG_WHITELIST is not set
+CONFIG_USB_OTG_BLACKLIST_HUB=y

 #
-# Enable Host or Gadget support to see Inventra options
+# USB Host Controller Drivers
 #
+# CONFIG_USB_ISP116X_HCD is not set
+# CONFIG_USB_ISP1362_HCD is not set
+# CONFIG_USB_ISP1760_HCD is not set
+# CONFIG_USB_SL811_HCD is not set
+# CONFIG_USB_R8A66597_HCD is not set
+CONFIG_USB_MUSB_HDRC=y
+CONFIG_USB_MUSB_SOC=y
+
+#
+# Blackfin high speed USB support
+#
+CONFIG_USB_MUSB_HOST=y
+# CONFIG_USB_MUSB_PERIPHERAL is not set
+# CONFIG_USB_MUSB_OTG is not set
+CONFIG_USB_MUSB_HDRC_HCD=y
+# CONFIG_MUSB_PIO_ONLY is not set
+# CONFIG_USB_INVENTRA_DMA is not set
+# CONFIG_USB_TI_CPPI_DMA is not set
+CONFIG_USB_MUSB_LOGLEVEL=0
+
+#
+# USB Device Class drivers
+#
+# CONFIG_USB_ACM is not set
+# CONFIG_USB_PRINTER is not set

 #
 # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
 #

 #
-# USB Gadget Support
+# may also be needed; see USB_STORAGE Help for more information
 #
-# CONFIG_USB_GADGET is not set
-CONFIG_MMC=m
-# CONFIG_MMC_DEBUG is not set
-# CONFIG_MMC_UNSAFE_RESUME is not set
+CONFIG_USB_STORAGE=m
+# CONFIG_USB_STORAGE_DEBUG is not set
+# CONFIG_USB_STORAGE_DATAFAB is not set
+# CONFIG_USB_STORAGE_FREECOM is not set
+# CONFIG_USB_STORAGE_ISD200 is not set
+# CONFIG_USB_STORAGE_DPCM is not set
+# CONFIG_USB_STORAGE_USBAT is not set
+# CONFIG_USB_STORAGE_SDDR09 is not set
+# CONFIG_USB_STORAGE_SDDR55 is not set
+# CONFIG_USB_STORAGE_JUMPSHOT is not set
+# CONFIG_USB_STORAGE_ALAUDA is not set
+# CONFIG_USB_STORAGE_ONETOUCH is not set
+# CONFIG_USB_STORAGE_KARMA is not set
+# CONFIG_USB_LIBUSUAL is not set

 #
-# MMC/SD Card Drivers
+# USB Imaging devices
 #
-CONFIG_MMC_BLOCK=m
+# CONFIG_USB_MDC800 is not set
+# CONFIG_USB_MICROTEK is not set
+CONFIG_USB_MON=y

 #
-# MMC/SD Host Controller Drivers
+# USB port drivers
 #
-CONFIG_SDH_BFIN=m
-# CONFIG_SPI_MMC is not set

 #
-# LED devices
+# USB Serial Converter support
 #
-# CONFIG_NEW_LEDS is not set
+# CONFIG_USB_SERIAL is not set

 #
-# LED drivers
+# USB Miscellaneous drivers
 #
+# CONFIG_USB_EMI62 is not set
+# CONFIG_USB_EMI26 is not set
+# CONFIG_USB_ADUTUX is not set
+# CONFIG_USB_AUERSWALD is not set
+# CONFIG_USB_RIO500 is not set
+# CONFIG_USB_LEGOTOWER is not set
+# CONFIG_USB_LCD is not set
+# CONFIG_USB_BERRY_CHARGE is not set
+# CONFIG_USB_LED is not set
+# CONFIG_USB_CYPRESS_CY7C63 is not set
+# CONFIG_USB_CYTHERM is not set
+# CONFIG_USB_PHIDGET is not set
+# CONFIG_USB_IDMOUSE is not set
+# CONFIG_USB_FTDI_ELAN is not set
+# CONFIG_USB_APPLEDISPLAY is not set
+# CONFIG_USB_SISUSBVGA is not set
+# CONFIG_USB_LD is not set
+# CONFIG_USB_TRANCEVIBRATOR is not set
+# CONFIG_USB_IOWARRIOR is not set

 #
-# LED Triggers
+# USB DSL modem support
 #

 #
-# InfiniBand support
+# USB Gadget Support
 #
+# CONFIG_USB_GADGET is not set
+CONFIG_MMC=m
+# CONFIG_MMC_DEBUG is not set
+# CONFIG_MMC_UNSAFE_RESUME is not set

 #
-# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+# MMC/SD Card Drivers
 #
+CONFIG_MMC_BLOCK=m
+CONFIG_MMC_BLOCK_BOUNCE=y
+# CONFIG_SDIO_UART is not set

 #
-# Real Time Clock
+# MMC/SD Host Controller Drivers
 #
+CONFIG_SDH_BFIN=m
+# CONFIG_SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND is not set
+# CONFIG_MMC_SPI is not set
+# CONFIG_SPI_MMC is not set
+# CONFIG_NEW_LEDS is not set
 CONFIG_RTC_LIB=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_HCTOSYS=y
@@ -1176,6 +1250,7 @@ CONFIG_RTC_INTF_DEV=y
 # I2C RTC drivers
 #
 # CONFIG_RTC_DRV_DS1307 is not set
+# CONFIG_RTC_DRV_DS1374 is not set
 # CONFIG_RTC_DRV_DS1672 is not set
 # CONFIG_RTC_DRV_MAX6900 is not set
 # CONFIG_RTC_DRV_RS5C372 is not set
@@ -1183,6 +1258,7 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_X1205 is not set
 # CONFIG_RTC_DRV_PCF8563 is not set
 # CONFIG_RTC_DRV_PCF8583 is not set
+# CONFIG_RTC_DRV_M41T80 is not set

 #
 # SPI RTC drivers
@@ -1194,8 +1270,10 @@ CONFIG_RTC_INTF_DEV=y
 # Platform RTC drivers
 #
 # CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
 # CONFIG_RTC_DRV_DS1742 is not set
 # CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
 # CONFIG_RTC_DRV_V3020 is not set

 #
@@ -1204,22 +1282,9 @@ CONFIG_RTC_INTF_DEV=y
 CONFIG_RTC_DRV_BFIN=y

 #
-# DMA Engine support
-#
-# CONFIG_DMA_ENGINE is not set
-
-#
-# DMA Clients
+# Userspace I/O
 #
-
-#
-# DMA Devices
-#
-
-#
-# PBX support
-#
-# CONFIG_PBX is not set
+# CONFIG_UIO is not set

 #
 # File systems
@@ -1280,7 +1345,6 @@ CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 # CONFIG_TMPFS is not set
 # CONFIG_HUGETLB_PAGE is not set
-CONFIG_RAMFS=y
 # CONFIG_CONFIGFS_FS is not set

 #
@@ -1306,10 +1370,12 @@ CONFIG_YAFFS_SHORT_NAMES_IN_RAM=y
 CONFIG_JFFS2_FS=m
 CONFIG_JFFS2_FS_DEBUG=0
 CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
 # CONFIG_JFFS2_SUMMARY is not set
 # CONFIG_JFFS2_FS_XATTR is not set
 # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
 CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
 CONFIG_JFFS2_RTIME=y
 # CONFIG_JFFS2_RUBIN is not set
 # CONFIG_CRAMFS is not set
@@ -1318,10 +1384,7 @@ CONFIG_JFFS2_RTIME=y
 # CONFIG_QNX4FS_FS is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
+CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=m
 CONFIG_NFS_V3=y
 # CONFIG_NFS_V3_ACL is not set
@@ -1352,7 +1415,6 @@ CONFIG_CIFS=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set

 #
 # Partition Types
@@ -1375,10 +1437,6 @@ CONFIG_MSDOS_PARTITION=y
 # CONFIG_KARMA_PARTITION is not set
 # CONFIG_EFI_PARTITION is not set
 # CONFIG_SYSV68_PARTITION is not set
-
-#
-# Native Language Support
-#
 CONFIG_NLS=y
 CONFIG_NLS_DEFAULT="iso8859-1"
 CONFIG_NLS_CODEPAGE_437=m
@@ -1419,21 +1477,16 @@ CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=m
-
-#
-# Distributed Lock Manager
-#
 # CONFIG_DLM is not set
-
-#
-# Profiling support
-#
+CONFIG_INSTRUMENTATION=y
 # CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set

 #
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
@@ -1441,6 +1494,7 @@ CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_SAMPLES is not set
 CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
@@ -1460,11 +1514,8 @@ CONFIG_ACCESS_CHECK=y
 # CONFIG_KEYS is not set
 CONFIG_SECURITY=y
 # CONFIG_SECURITY_NETWORK is not set
-CONFIG_SECURITY_CAPABILITIES=m
-
-#
-# Cryptographic options
-#
+# CONFIG_SECURITY_CAPABILITIES is not set
+# CONFIG_SECURITY_ROOTPLUG is not set
 # CONFIG_CRYPTO is not set

 #
@@ -1475,6 +1526,7 @@ CONFIG_CRC_CCITT=m
 # CONFIG_CRC16 is not set
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=m
diff --git a/arch/blackfin/configs/IP0X_defconfig
b/arch/blackfin/configs/IP0X_defconfig
index 5f6ff04..4384a67 100644
--- a/arch/blackfin/configs/IP0X_defconfig
+++ b/arch/blackfin/configs/IP0X_defconfig
@@ -212,7 +212,7 @@ CONFIG_HZ=250
 #
 # Memory Setup
 #
-CONFIG_MEM_SIZE=64
+CONFIG_MAX_MEM_SIZE=64
 CONFIG_MEM_ADD_WIDTH=10

 #
diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c
b/arch/blackfin/kernel/bfin_dma_5xx.c
index fd5448d..d54f190 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -90,6 +90,17 @@ int request_dma(unsigned int channel, char *device_id)
 {

 	pr_debug("request_dma() : BEGIN \n");
+
+#if defined(CONFIG_BF561) && ANOMALY_05000182
+	if (channel >= CH_IMEM_STREAM0_DEST && channel <= CH_IMEM_STREAM1_DEST) {
+		if (get_cclk() > 500000000) {
+			printk(KERN_WARNING
+			       "Request IMDMA failed due to ANOMALY 05000182\n");
+			return -EFAULT;
+		}
+	}
+#endif
+
 	mutex_lock(&(dma_ch[channel].dmalock));

 	if ((dma_ch[channel].chan_status == DMA_CHANNEL_REQUESTED)
diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index 7e8eaf4..b6d89d1 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -1130,6 +1130,25 @@ void bfin_gpio_irq_prepare(unsigned gpio)

 #else

+int gpio_get_value(unsigned gpio)
+{
+	unsigned long flags;
+	int ret;
+
+	if (unlikely(get_gpio_edge(gpio))) {
+		local_irq_save(flags);
+		set_gpio_edge(gpio, 0);
+		ret = get_gpio_data(gpio);
+		set_gpio_edge(gpio, 1);
+		local_irq_restore(flags);
+
+		return ret;
+	} else
+		return get_gpio_data(gpio);
+}
+EXPORT_SYMBOL(gpio_get_value);
+
+
 int gpio_direction_input(unsigned gpio)
 {
 	unsigned long flags;
diff --git a/arch/blackfin/kernel/bfin_ksyms.c
b/arch/blackfin/kernel/bfin_ksyms.c
index 053edff..4367330 100644
--- a/arch/blackfin/kernel/bfin_ksyms.c
+++ b/arch/blackfin/kernel/bfin_ksyms.c
@@ -90,7 +90,9 @@ EXPORT_SYMBOL(__umodsi3);
 EXPORT_SYMBOL(outsb);
 EXPORT_SYMBOL(insb);
 EXPORT_SYMBOL(outsw);
+EXPORT_SYMBOL(outsw_8);
 EXPORT_SYMBOL(insw);
+EXPORT_SYMBOL(insw_8);
 EXPORT_SYMBOL(outsl);
 EXPORT_SYMBOL(insl);
 EXPORT_SYMBOL(insl_16);
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 5b84707..7bfbd95 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -364,13 +364,13 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	/* 0x27 - Data CPLB Multiple Hits - Linux Trap Zero, handled here */
 	case VEC_CPLB_MHIT:
 		info.si_code = ILL_CPLB_MULHIT;
-#ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
 		sig = SIGSEGV;
-		printk(KERN_NOTICE "NULL pointer access (probably)\n");
-#else
-		sig = SIGILL;
-		printk(KERN_NOTICE EXC_0x27(KERN_NOTICE));
+#ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
+		if (saved_dcplb_fault_addr < (void *)FIXED_CODE_START)
+			printk(KERN_NOTICE "NULL pointer access\n");
+		else
 #endif
+			printk(KERN_NOTICE EXC_0x27(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x28 - Emulation Watchpoint, handled here */
@@ -419,13 +419,13 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	/* 0x2D - Instruction CPLB Multiple Hits, handled here */
 	case VEC_CPLB_I_MHIT:
 		info.si_code = ILL_CPLB_MULHIT;
-#ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
 		sig = SIGSEGV;
-		printk(KERN_NOTICE "Jump to address 0 - 0x0fff\n");
-#else
-		sig = SIGILL;
-		printk(KERN_NOTICE EXC_0x2D(KERN_NOTICE));
+#ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
+		if (saved_icplb_fault_addr < (void *)FIXED_CODE_START)
+			printk(KERN_NOTICE "Jump to NULL address\n");
+		else
 #endif
+			printk(KERN_NOTICE EXC_0x2D(KERN_NOTICE));
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x2E - Illegal use of Supervisor Resource, handled here */
diff --git a/arch/blackfin/lib/checksum.c b/arch/blackfin/lib/checksum.c
index 42768e0..5c87505 100644
--- a/arch/blackfin/lib/checksum.c
+++ b/arch/blackfin/lib/checksum.c
@@ -72,9 +72,9 @@ static unsigned short do_csum(const unsigned char
*buff, int len)
  *	This is a version of ip_compute_csum() optimized for IP headers,
  *	which always checksum on 4 octet boundaries.
  */
-unsigned short ip_fast_csum(unsigned char *iph, unsigned int ihl)
+__sum16 ip_fast_csum(unsigned char *iph, unsigned int ihl)
 {
-	return ~do_csum(iph, ihl * 4);
+	return (__force __sum16)~do_csum(iph, ihl * 4);
 }

 /*
@@ -89,7 +89,7 @@ unsigned short ip_fast_csum(unsigned char *iph,
unsigned int ihl)
  *
  * it's best to have buff aligned on a 32-bit boundary
  */
-unsigned int csum_partial(const unsigned char *buff, int len, unsigned int sum)
+__wsum csum_partial(const void *buff, int len, __wsum sum)
 {
 	/*
 	 * Just in case we get nasty checksum data...
@@ -109,22 +109,22 @@ unsigned int csum_partial(const unsigned char
*buff, int len, unsigned int sum)
  * this routine is used for miscellaneous IP-like checksums, mainly
  * in icmp.c
  */
-unsigned short ip_compute_csum(const unsigned char *buff, int len)
+__sum16 ip_compute_csum(const void *buff, int len)
 {
-	return ~do_csum(buff, len);
+	return (__force __sum16)~do_csum(buff, len);
 }

 /*
  * copy from fs while checksumming, otherwise like csum_partial
  */

-unsigned int
-csum_partial_copy_from_user(const unsigned char *src, unsigned char *dst,
-			    int len, int sum, int *csum_err)
+__wsum
+csum_partial_copy_from_user(const void __user *src, void *dst,
+			    int len, __wsum sum, int *csum_err)
 {
 	if (csum_err)
 		*csum_err = 0;
-	memcpy(dst, src, len);
+	memcpy(dst, (__force void *)src, len);
 	return csum_partial(dst, len, sum);
 }

@@ -132,8 +132,7 @@ csum_partial_copy_from_user(const unsigned char
*src, unsigned char *dst,
  * copy from ds while checksumming, otherwise like csum_partial
  */

-unsigned int csum_partial_copy(const unsigned char *src, unsigned char *dst,
-			       int len, int sum)
+__wsum csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
 {
 	memcpy(dst, src, len);
 	return csum_partial(dst, len, sum);
diff --git a/arch/blackfin/lib/ins.S b/arch/blackfin/lib/ins.S
index df7b883..eba2343 100644
--- a/arch/blackfin/lib/ins.S
+++ b/arch/blackfin/lib/ins.S
@@ -7,7 +7,7 @@
  * Description:  Implementation of ins{bwl} for BlackFin processors
using zero overhead loops.
  *
  * Modified:
- *               Copyright 2004-2006 Analog Devices Inc.
+ *               Copyright 2004-2008 Analog Devices Inc.
  *               Copyright (C) 2005 Bas Vermeulen, BuyWays BV <bas@buyways.nl>
  *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
@@ -63,6 +63,23 @@ ENTRY(_insw)
 	RTS;
 ENDPROC(_insw)

+ENTRY(_insw_8)
+	P0 = R0;	/* P0 = port */
+	cli R3;
+	P1 = R1;	/* P1 = address */
+	P2 = R2;	/* P2 = count */
+	SSYNC;
+	LSETUP( .Lword8_loop_s, .Lword8_loop_e) LC0 = P2;
+.Lword8_loop_s:  R0 = W[P0];
+		B[P1++] = R0;
+		R0 = R0 >> 8;
+		B[P1++] = R0;
+		NOP;
+.Lword8_loop_e: NOP;
+	sti R3;
+	RTS;
+ENDPROC(_insw_8)
+
 ENTRY(_insb)
 	P0 = R0;	/* P0 = port */
 	cli R3;
@@ -78,8 +95,6 @@ ENTRY(_insb)
 	RTS;
 ENDPROC(_insb)

-
-
 ENTRY(_insl_16)
 	P0 = R0;	/* P0 = port */
 	cli R3;
diff --git a/arch/blackfin/lib/outs.S b/arch/blackfin/lib/outs.S
index 4c3da8a..3daf960 100644
--- a/arch/blackfin/lib/outs.S
+++ b/arch/blackfin/lib/outs.S
@@ -7,7 +7,7 @@
  * Description:  Implementation of outs{bwl} for BlackFin processors
using zero overhead loops.
  *
  * Modified:     Copyright (C) 2005 Bas Vermeulen, BuyWays BV <bas@buyways.nl>
- *               Copyright 2004-2006 Analog Devices Inc.
+ *               Copyright 2004-2008 Analog Devices Inc.
  *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
@@ -63,3 +63,17 @@ ENTRY(_outsb)
 .Lbyte_loop_e: B[P0] = R0;
 	RTS;
 ENDPROC(_outsb)
+
+ENTRY(_outsw_8)
+	P0 = R0;	/* P0 = port */
+	P1 = R1;	/* P1 = address */
+	P2 = R2;	/* P2 = count */
+
+	LSETUP( .Lword8_loop_s, .Lword8_loop_e) LC0 = P2;
+.Lword8_loop_s: R1 = B[P1++];
+		R0 = B[P1++];
+		R0 = R0 << 8;
+		R0 = R0 + R1;
+.Lword8_loop_e: W[P0] = R0;
+	RTS;
+ENDPROC(_outsw)
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c
b/arch/blackfin/mach-bf533/boards/stamp.c
index 7fd35fb..ec05b23 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -111,7 +111,7 @@ static struct platform_device net2272_bfin_device = {
 };
 #endif

-#if defined(CONFIG_MTD_BF5xx) || defined(CONFIG_MTD_BF5xx_MODULE)
+#if defined(CONFIG_MTD_BFIN_ASYNC) || defined(CONFIG_MTD_BFIN_ASYNC_MODULE)
 static struct mtd_partition stamp_partitions[] = {
 	{
 		.name   = "Bootloader",
@@ -141,13 +141,17 @@ static struct resource stamp_flash_resource[] = {
 		.end   = 0x203fffff,
 		.flags = IORESOURCE_MEM,
 	}, {
-		.start = CONFIG_ENET_FLASH_PIN,
+		.start = 0x7BB07BB0,	/* AMBCTL0 setting when accessing flash */
+		.end   = 0x7BB07BB0,	/* AMBCTL1 setting when accessing flash */
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = GPIO_PF0,
 		.flags = IORESOURCE_IRQ,
 	}
 };

 static struct platform_device stamp_flash_device = {
-	.name          = "BF5xx-Flash",
+	.name          = "bfin-async-flash",
 	.id            = 0,
 	.dev = {
 		.platform_data = &stamp_flash_data,
@@ -595,7 +599,7 @@ static struct platform_device *stamp_devices[]
__initdata = {

 	&bfin_gpios_device,

-#if defined(CONFIG_MTD_BF5xx) || defined(CONFIG_MTD_BF5xx_MODULE)
+#if defined(CONFIG_MTD_BFIN_ASYNC) || defined(CONFIG_MTD_BFIN_ASYNC_MODULE)
 	&stamp_flash_device,
 #endif
 };
@@ -617,8 +621,8 @@ static int __init stamp_init(void)

 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
 	/* setup BF533_STAMP CPLD to route AMS3 to Ethernet MAC */
-	bfin_write_FIO_DIR(bfin_read_FIO_DIR() | (1 << CONFIG_ENET_FLASH_PIN));
-	bfin_write_FIO_FLAG_S(1 << CONFIG_ENET_FLASH_PIN);
+	bfin_write_FIO_DIR(bfin_read_FIO_DIR() | PF0);
+	bfin_write_FIO_FLAG_S(PF0);
 	SSYNC();
 #endif

@@ -636,8 +640,8 @@ arch_initcall(stamp_init);

 void native_machine_restart(char *cmd)
 {
-#define BIT_TO_SET (1 << CONFIG_ENET_FLASH_PIN)
-	bfin_write_FIO_INEN(~BIT_TO_SET);
-	bfin_write_FIO_DIR(BIT_TO_SET);
-	bfin_write_FIO_FLAG_C(BIT_TO_SET);
+	/* workaround pull up on cpld / flash pin not being strong enough */
+	bfin_write_FIO_INEN(~PF0);
+	bfin_write_FIO_DIR(PF0);
+	bfin_write_FIO_FLAG_C(PF0);
 }
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index a1ca9b7..1400ea6 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -43,6 +43,7 @@

 #include <asm/io.h>
 #include <asm/irq.h>
+#include <asm/serial.h>

 #include "8250.h"

@@ -92,8 +93,6 @@ static unsigned int nr_uarts =
CONFIG_SERIAL_8250_RUNTIME_UARTS;
  */
 #define CONFIG_HUB6 1

-#include <asm/serial.h>
-
 /*
  * SERIAL_PORT_DFNS tells us about built-in ports that have no
  * standard enumeration mechanism.   Platforms that can find all
@@ -1548,6 +1547,8 @@ static int serial_link_irq_chain(struct
uart_8250_port *up)
 		i->head = &up->list;
 		spin_unlock_irq(&i->lock);

+		irq_flags |= SERIAL_EXTRA_IRQ_FLAGS;
+
 		ret = request_irq(up->port.irq, serial8250_interrupt,
 				  irq_flags, "serial", i);
 		if (ret < 0)
diff --git a/drivers/serial/8250.h b/drivers/serial/8250.h
index 91bd28f..a10a40c 100644
--- a/drivers/serial/8250.h
+++ b/drivers/serial/8250.h
@@ -78,3 +78,8 @@ struct serial8250_config {
 #else
 #define ALPHA_KLUDGE_MCR 0
 #endif
+
+#ifndef SERIAL_EXTRA_IRQ_FLAGS
+#define SERIAL_EXTRA_IRQ_FLAGS 0
+#endif
+
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 62e6eb1..9bc4276 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1361,7 +1361,7 @@ config SERIAL_SC26XX_CONSOLE

 config SERIAL_BFIN_SPORT
 	tristate "Blackfin SPORT emulate UART (EXPERIMENTAL)"
-	depends on BFIN && EXPERIMENTAL
+	depends on BLACKFIN && EXPERIMENTAL
 	select SERIAL_CORE
 	help
 	  Enble support SPORT emulate UART on Blackfin series.
diff --git a/include/asm-blackfin/bfin-global.h
b/include/asm-blackfin/bfin-global.h
index 716df7c..a9248d8 100644
--- a/include/asm-blackfin/bfin-global.h
+++ b/include/asm-blackfin/bfin-global.h
@@ -37,7 +37,9 @@
 #include <linux/linkage.h>
 #include <linux/types.h>

-#if defined(CONFIG_DMA_UNCACHED_2M)
+#if defined(CONFIG_DMA_UNCACHED_4M)
+# define DMA_UNCACHED_REGION (4 * 1024 * 1024)
+#elif defined(CONFIG_DMA_UNCACHED_2M)
 # define DMA_UNCACHED_REGION (2 * 1024 * 1024)
 #elif defined(CONFIG_DMA_UNCACHED_1M)
 # define DMA_UNCACHED_REGION (1024 * 1024)
diff --git a/include/asm-blackfin/checksum.h b/include/asm-blackfin/checksum.h
index 2638f25..6f6af2b 100644
--- a/include/asm-blackfin/checksum.h
+++ b/include/asm-blackfin/checksum.h
@@ -15,7 +15,7 @@
  *
  * it's best to have buff aligned on a 32-bit boundary
  */
-unsigned int csum_partial(const unsigned char *buff, int len,
unsigned int sum);
+__wsum csum_partial(const void *buff, int len, __wsum sum);

 /*
  * the same as csum_partial, but copies from src while it
@@ -25,8 +25,8 @@ unsigned int csum_partial(const unsigned char *buff,
int len, unsigned int sum);
  * better 64-bit) boundary
  */

-unsigned int csum_partial_copy(const unsigned char *src, unsigned char *dst,
-			       int len, int sum);
+__wsum csum_partial_copy(const void *src, void *dst,
+			       int len, __wsum sum);

 /*
  * the same as csum_partial_copy, but copies from user space.
@@ -35,20 +35,19 @@ unsigned int csum_partial_copy(const unsigned char
*src, unsigned char *dst,
  * better 64-bit) boundary
  */

-extern unsigned int csum_partial_copy_from_user(const unsigned char *src,
-						unsigned char *dst, int len,
-						int sum, int *csum_err);
+extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
+					  int len, __wsum sum, int *csum_err);

 #define csum_partial_copy_nocheck(src, dst, len, sum)	\
 	csum_partial_copy((src), (dst), (len), (sum))

-unsigned short ip_fast_csum(unsigned char *iph, unsigned int ihl);
+__sum16 ip_fast_csum(unsigned char *iph, unsigned int ihl);

 /*
  *	Fold a partial checksum
  */

-static inline unsigned int csum_fold(unsigned int sum)
+static inline __sum16 csum_fold(__wsum sum)
 {
 	while (sum >> 16)
 		sum = (sum & 0xffff) + (sum >> 16);
@@ -60,9 +59,9 @@ static inline unsigned int csum_fold(unsigned int sum)
  * returns a 16-bit checksum, already complemented
  */

-static inline unsigned int
-csum_tcpudp_nofold(unsigned long saddr, unsigned long daddr, unsigned
short len,
-		   unsigned short proto, unsigned int sum)
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+		   unsigned short proto, __wsum sum)
 {

 	__asm__ ("%0 = %0 + %1;\n\t"
@@ -84,9 +83,9 @@ csum_tcpudp_nofold(unsigned long saddr, unsigned
long daddr, unsigned short len,
 	return (sum);
 }

-static inline unsigned short int
-csum_tcpudp_magic(unsigned long saddr, unsigned long daddr, unsigned short len,
-		  unsigned short proto, unsigned int sum)
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
+		  unsigned short proto, __wsum sum)
 {
 	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
 }
@@ -96,6 +95,6 @@ csum_tcpudp_magic(unsigned long saddr, unsigned long
daddr, unsigned short len,
  * in icmp.c
  */

-extern unsigned short ip_compute_csum(const unsigned char *buff, int len);
+extern __sum16 ip_compute_csum(const void *buff, int len);

 #endif				/* _BFIN_CHECKSUM_H */
diff --git a/include/asm-blackfin/gpio.h b/include/asm-blackfin/gpio.h
index 27ff532..ff95e9d 100644
--- a/include/asm-blackfin/gpio.h
+++ b/include/asm-blackfin/gpio.h
@@ -437,7 +437,6 @@ void gpio_set_value(unsigned gpio, int arg);
 int gpio_get_value(unsigned gpio);

 #ifndef BF548_FAMILY
-#define gpio_get_value(gpio) 		get_gpio_data(gpio)
 #define gpio_set_value(gpio, value)	set_gpio_data(gpio, value)
 #endif

diff --git a/include/asm-blackfin/io.h b/include/asm-blackfin/io.h
index 574fe56..cbbf7ff 100644
--- a/include/asm-blackfin/io.h
+++ b/include/asm-blackfin/io.h
@@ -117,10 +117,12 @@ static inline unsigned int readl(const volatile
void __iomem *addr)

 extern void outsb(unsigned long port, const void *addr, unsigned long count);
 extern void outsw(unsigned long port, const void *addr, unsigned long count);
+extern void outsw_8(unsigned long port, const void *addr, unsigned long count);
 extern void outsl(unsigned long port, const void *addr, unsigned long count);

 extern void insb(unsigned long port, void *addr, unsigned long count);
 extern void insw(unsigned long port, void *addr, unsigned long count);
+extern void insw_8(unsigned long port, void *addr, unsigned long count);
 extern void insl(unsigned long port, void *addr, unsigned long count);
 extern void insl_16(unsigned long port, void *addr, unsigned long count);

diff --git a/include/asm-blackfin/mach-bf561/dma.h
b/include/asm-blackfin/mach-bf561/dma.h
index 21d9820..8bc46cd 100644
--- a/include/asm-blackfin/mach-bf561/dma.h
+++ b/include/asm-blackfin/mach-bf561/dma.h
@@ -25,11 +25,11 @@
 #define CH_MEM_STREAM1_SRC      27	 /* RX */
 #define CH_MEM_STREAM2_DEST	28
 #define CH_MEM_STREAM2_SRC	29
-#define CH_MEM_STREAM3_SRC	30
-#define CH_MEM_STREAM3_DEST	31
+#define CH_MEM_STREAM3_DEST	30
+#define CH_MEM_STREAM3_SRC	31
 #define CH_IMEM_STREAM0_DEST	32
 #define CH_IMEM_STREAM0_SRC	33
-#define CH_IMEM_STREAM1_SRC	34
-#define CH_IMEM_STREAM1_DEST	35
+#define CH_IMEM_STREAM1_DEST	34
+#define CH_IMEM_STREAM1_SRC	35

 #endif
diff --git a/include/asm-blackfin/serial.h b/include/asm-blackfin/serial.h
new file mode 100644
index 0000000..994dd86
--- /dev/null
+++ b/include/asm-blackfin/serial.h
@@ -0,0 +1,5 @@
+/*
+ * include/asm-blackfin/serial.h
+ */
+
+#define SERIAL_EXTRA_IRQ_FLAGS IRQF_TRIGGER_HIGH
