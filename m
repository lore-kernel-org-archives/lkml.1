Return-Path: <linux-kernel-owner+w=401wt.eu-S934356AbZDAVr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356AbZDAVr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZDAVrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:47:19 -0400
Received: from mout.perfora.net ([74.208.4.194]:54640 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbZDAVrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:47:17 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: linux-kernel@vger.kernel.org
Cc: avorontsov@ru.mvista.com, Marcel Ziswiler <marcel@ziswiler.com>
Subject: [PATCH] QE USB Host Integration for MPC832x
Date: Wed,  1 Apr 2009 23:46:36 +0200
Message-Id: <1238622396-9768-1-git-send-email-marcel@ziswiler.com>
X-Mailer: git-send-email 1.6.0.6
X-Provags-ID: V01U2FsdGVkX18j1k7PDzMwqOBxrPbCdxvwSJi69lBSbmEh0V1
 9yDruVhrpjOhXYgrB3ErrXCwFckf3YaNEk3lXvpvKTIT37RDd5
 Px1z4N7XAx5m+EtXFz7oT8EP2YqC7gU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Open issues:
- MPC832x_MDS seems to lie about BCSR12_USMODE bit.
- How to use qe_setbrg() with an external clock pin? Hard-coded for now.
- How to properly allocate USB pram on MPC832x as standard layout won't work.
- Detects USB device plugged in but then hangs.

Please CC me personally when answering/commenting my posting, thanks.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
---
 arch/powerpc/boot/dts/mpc832x_mds.dts           |   74 ++++-
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig |  361 ++++++++++++-----------
 arch/powerpc/platforms/83xx/Kconfig             |    1 +
 arch/powerpc/platforms/83xx/mpc832x_mds.c       |   66 ++++
 arch/powerpc/sysdev/qe_lib/qe.c                 |   10 +-
 drivers/usb/host/fhci-hcd.c                     |    9 +
 6 files changed, 336 insertions(+), 185 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc832x_mds.dts b/arch/powerpc/boot/dts/mpc832x_mds.dts
index 57c595b..f306edf 100644
--- a/arch/powerpc/boot/dts/mpc832x_mds.dts
+++ b/arch/powerpc/boot/dts/mpc832x_mds.dts
@@ -59,9 +59,36 @@
 		reg = <0x00000000 0x08000000>;
 	};
 
-	bcsr@f8000000 {
-		compatible = "fsl,mpc8323mds-bcsr";
-		reg = <0xf8000000 0x8000>;
+	localbus@e0005000 {
+		#address-cells = <2>;
+		#size-cells = <1>;
+		compatible = "fsl,mpc8323-localbus", "fsl,pq2pro-localbus",
+			     "simple-bus";
+		reg = <0xe0005000 0xd8>;
+		ranges = <0 0 0xfe000000 0x02000000
+		          1 0 0xf8000000 0x00008000>;
+
+		flash@0,0 {
+			compatible = "cfi-flash";
+			reg = <0 0 0x2000000>;
+			bank-width = <2>;
+			device-width = <1>;
+		};
+
+		bcsr@1,0 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+ 			compatible = "fsl,mpc8323mds-bcsr";
+			reg = <1 0 0x8000>;
+			ranges = <0 1 0 0x8000>;
+
+			bcsr12: gpio-controller@c {
+				#gpio-cells = <2>;
+				compatible = "fsl,mpc8323mds-bcsr-gpio";
+				reg = <0xc 1>;
+				gpio-controller;
+			};
+		};
 	};
 
 	soc8323@e0000000 {
@@ -238,6 +265,14 @@
 			};
 
 		};
+
+		qe_pio_a: gpio-controller@1400 {
+			#gpio-cells = <2>;
+			compatible = "fsl,mpc8360-qe-pario-bank",
+				     "fsl,mpc8323-qe-pario-bank";
+			reg = <0x1400 0x18>;
+			gpio-controller;
+		};
 	};
 
 	qe@e0100000 {
@@ -282,11 +317,25 @@
 		};
 
 		usb@6c0 {
-			compatible = "qe_udc";
-			reg = <0x6c0 0x40 0x8b00 0x100>;
-			interrupts = <11>;
+			compatible = "fsl,mpc8360-qe-usb",
+				     "fsl,mpc8323-qe-usb";
+			/* QUICC Engine Parameter RAM Base Addresses (Suggested
+			   Value for User Configuration) Table 19-2 page 778 */
+			reg = <0x6c0 0x40 0x700 0x100>;
+			interrupts = <11>; /* Encoding the Interrupt Vector
+					      Table 18-12 page 760 */
 			interrupt-parent = <&qeic>;
-			mode = "slave";
+			/* Clock Source Options - Internal Clock Generators
+			   Table 20-2 page 804 */
+			fsl,fullspeed-clock = "brg10";
+			fsl,lowspeed-clock = "brg10";
+			gpios = <&qe_pio_a  8 0   /* USBOE */
+				 &qe_pio_a  1 0   /* USBTXP */
+				 &qe_pio_a  0 0   /* USBTXN */
+				 &qe_pio_a  4 0   /* USBRXP */
+				 &qe_pio_a  5 0   /* USBRXN */
+				 &bcsr12    5 0   /* SPEED */
+				 &bcsr12    4 1>; /* POWER */
 		};
 
 		enet0: ucc@2200 {
@@ -335,7 +384,6 @@
 			pio-handle = < &pio5 >;
 		};
 
-
 		mdio@2320 {
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -366,6 +414,16 @@
 			interrupts = <32 0x8 33 0x8>; //high:32 low:33
 			interrupt-parent = <&ipic>;
 		};
+
+		timer@440 {
+			compatible = "fsl,mpc8323-qe-gtm",
+				     "fsl,qe-gtm", "fsl,gtm";
+			reg = <0x440 0x40>;
+			interrupts = <12 13 14 15>;
+			interrupt-parent = <&qeic>;
+			/* filled by u-boot */
+			clock-frequency = <0>;
+		};
 	};
 
 	pci0: pci@e0008500 {
diff --git a/arch/powerpc/configs/83xx/mpc832x_mds_defconfig b/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
index fb17de5..d525341 100644
--- a/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.29-rc2
-# Mon Jan 26 15:35:50 2009
+# Linux kernel version: 2.6.29
+# Wed Apr  1 23:15:17 2009
 #
 # CONFIG_PPC64 is not set
 
@@ -40,6 +40,7 @@ CONFIG_ARCH_HAS_ILOG2_U32=y
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_GPIO=y
 # CONFIG_ARCH_NO_VIRT_TO_BUS is not set
 CONFIG_PPC=y
 CONFIG_EARLY_PRINTK=y
@@ -73,6 +74,15 @@ CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
 # CONFIG_AUDIT is not set
+
+#
+# RCU Subsystem
+#
+CONFIG_CLASSIC_RCU=y
+# CONFIG_TREE_RCU is not set
+# CONFIG_PREEMPT_RCU is not set
+# CONFIG_TREE_RCU_TRACE is not set
+# CONFIG_PREEMPT_RCU_TRACE is not set
 # CONFIG_IKCONFIG is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_GROUP_SCHED=y
@@ -89,6 +99,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
+CONFIG_ANON_INODES=y
 CONFIG_EMBEDDED=y
 CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
@@ -96,10 +107,8 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
-CONFIG_ANON_INODES=y
 # CONFIG_EPOLL is not set
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
@@ -107,8 +116,8 @@ CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
 CONFIG_AIO=y
 CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_PCI_QUIRKS=y
 CONFIG_SLUB_DEBUG=y
+CONFIG_COMPAT_BRK=y
 # CONFIG_SLAB is not set
 CONFIG_SLUB=y
 # CONFIG_SLOB is not set
@@ -147,11 +156,6 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
-# CONFIG_TREE_RCU is not set
-# CONFIG_PREEMPT_RCU is not set
-# CONFIG_TREE_RCU_TRACE is not set
-# CONFIG_PREEMPT_RCU_TRACE is not set
 # CONFIG_FREEZER is not set
 
 #
@@ -196,7 +200,7 @@ CONFIG_IPIC=y
 # CONFIG_CPU_FREQ is not set
 # CONFIG_TAU is not set
 CONFIG_QUICC_ENGINE=y
-# CONFIG_QE_GPIO is not set
+CONFIG_QE_GPIO=y
 # CONFIG_FSL_ULI1575 is not set
 # CONFIG_SIMPLE_GPIO is not set
 # CONFIG_MCU_MPC8349EMITX is not set
@@ -261,20 +265,15 @@ CONFIG_ISA_DMA_API=y
 #
 CONFIG_ZONE_DMA=y
 CONFIG_GENERIC_ISA_DMA=y
-CONFIG_PPC_INDIRECT_PCI=y
 CONFIG_FSL_SOC=y
-CONFIG_FSL_PCI=y
+CONFIG_FSL_LBC=y
+CONFIG_FSL_GTM=y
 CONFIG_PPC_PCI_CHOICE=y
-CONFIG_PCI=y
-CONFIG_PCI_DOMAINS=y
-CONFIG_PCI_SYSCALL=y
-# CONFIG_PCIEPORTBUS is not set
-CONFIG_ARCH_SUPPORTS_MSI=y
-# CONFIG_PCI_MSI is not set
-# CONFIG_PCI_LEGACY is not set
-# CONFIG_PCI_STUB is not set
+# CONFIG_PCI is not set
+# CONFIG_PCI_DOMAINS is not set
+# CONFIG_PCI_SYSCALL is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
 # CONFIG_PCCARD is not set
-# CONFIG_HOTPLUG_PCI is not set
 # CONFIG_HAS_RAPIDIO is not set
 
 #
@@ -389,19 +388,16 @@ CONFIG_PREVENT_FIRMWARE_BUILD=y
 # CONFIG_CONNECTOR is not set
 # CONFIG_MTD is not set
 CONFIG_OF_DEVICE=y
+CONFIG_OF_GPIO=y
 CONFIG_OF_I2C=y
 # CONFIG_PARPORT is not set
 CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_FD is not set
-# CONFIG_BLK_CPQ_DA is not set
-# CONFIG_BLK_CPQ_CISS_DA is not set
-# CONFIG_BLK_DEV_DAC960 is not set
-# CONFIG_BLK_DEV_UMEM is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_BLK_DEV_CRYPTOLOOP is not set
 # CONFIG_BLK_DEV_NBD is not set
-# CONFIG_BLK_DEV_SX8 is not set
+# CONFIG_BLK_DEV_UB is not set
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=32768
@@ -410,14 +406,16 @@ CONFIG_BLK_DEV_RAM_SIZE=32768
 # CONFIG_ATA_OVER_ETH is not set
 # CONFIG_BLK_DEV_HD is not set
 CONFIG_MISC_DEVICES=y
-# CONFIG_PHANTOM is not set
-# CONFIG_EEPROM_93CX6 is not set
-# CONFIG_SGI_IOC4 is not set
-# CONFIG_TIFM_CORE is not set
 # CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
-# CONFIG_HP_ILO is not set
 # CONFIG_C2PORT is not set
+
+#
+# EEPROM support
+#
+# CONFIG_EEPROM_AT24 is not set
+# CONFIG_EEPROM_LEGACY is not set
+# CONFIG_EEPROM_93CX6 is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
@@ -460,59 +458,11 @@ CONFIG_SCSI_WAIT_SCAN=m
 # CONFIG_SCSI_SRP_ATTRS is not set
 CONFIG_SCSI_LOWLEVEL=y
 # CONFIG_ISCSI_TCP is not set
-# CONFIG_SCSI_CXGB3_ISCSI is not set
-# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
-# CONFIG_SCSI_3W_9XXX is not set
-# CONFIG_SCSI_ACARD is not set
-# CONFIG_SCSI_AACRAID is not set
-# CONFIG_SCSI_AIC7XXX is not set
-# CONFIG_SCSI_AIC7XXX_OLD is not set
-# CONFIG_SCSI_AIC79XX is not set
-# CONFIG_SCSI_AIC94XX is not set
-# CONFIG_SCSI_DPT_I2O is not set
-# CONFIG_SCSI_ADVANSYS is not set
-# CONFIG_SCSI_ARCMSR is not set
-# CONFIG_MEGARAID_NEWGEN is not set
-# CONFIG_MEGARAID_LEGACY is not set
-# CONFIG_MEGARAID_SAS is not set
-# CONFIG_SCSI_HPTIOP is not set
-# CONFIG_SCSI_BUSLOGIC is not set
 # CONFIG_LIBFC is not set
-# CONFIG_FCOE is not set
-# CONFIG_SCSI_DMX3191D is not set
-# CONFIG_SCSI_EATA is not set
-# CONFIG_SCSI_FUTURE_DOMAIN is not set
-# CONFIG_SCSI_GDTH is not set
-# CONFIG_SCSI_IPS is not set
-# CONFIG_SCSI_INITIO is not set
-# CONFIG_SCSI_INIA100 is not set
-# CONFIG_SCSI_MVSAS is not set
-# CONFIG_SCSI_STEX is not set
-# CONFIG_SCSI_SYM53C8XX_2 is not set
-# CONFIG_SCSI_QLOGIC_1280 is not set
-# CONFIG_SCSI_QLA_FC is not set
-# CONFIG_SCSI_QLA_ISCSI is not set
-# CONFIG_SCSI_LPFC is not set
-# CONFIG_SCSI_DC395x is not set
-# CONFIG_SCSI_DC390T is not set
-# CONFIG_SCSI_NSP32 is not set
 # CONFIG_SCSI_DEBUG is not set
-# CONFIG_SCSI_SRP is not set
 # CONFIG_SCSI_DH is not set
 # CONFIG_ATA is not set
 # CONFIG_MD is not set
-# CONFIG_FUSION is not set
-
-#
-# IEEE 1394 (FireWire) support
-#
-
-#
-# Enable only one of the two stacks, unless you know what you are doing
-#
-# CONFIG_FIREWIRE is not set
-# CONFIG_IEEE1394 is not set
-# CONFIG_I2O is not set
 # CONFIG_MACINTOSH_DRIVERS is not set
 CONFIG_NETDEVICES=y
 # CONFIG_DUMMY is not set
@@ -521,7 +471,6 @@ CONFIG_NETDEVICES=y
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
 # CONFIG_VETH is not set
-# CONFIG_ARCNET is not set
 CONFIG_PHYLIB=y
 
 #
@@ -544,12 +493,7 @@ CONFIG_DAVICOM_PHY=y
 # CONFIG_MDIO_BITBANG is not set
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
-# CONFIG_HAPPYMEAL is not set
-# CONFIG_SUNGEM is not set
-# CONFIG_CASSINI is not set
-# CONFIG_NET_VENDOR_3COM is not set
-# CONFIG_NET_TULIP is not set
-# CONFIG_HP100 is not set
+# CONFIG_DNET is not set
 # CONFIG_IBM_NEW_EMAC_ZMII is not set
 # CONFIG_IBM_NEW_EMAC_RGMII is not set
 # CONFIG_IBM_NEW_EMAC_TAH is not set
@@ -557,53 +501,14 @@ CONFIG_MII=y
 # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
-# CONFIG_NET_PCI is not set
 # CONFIG_B44 is not set
-# CONFIG_ATL2 is not set
 CONFIG_NETDEV_1000=y
-# CONFIG_ACENIC is not set
-# CONFIG_DL2K is not set
-# CONFIG_E1000 is not set
-# CONFIG_E1000E is not set
-# CONFIG_IP1000 is not set
-# CONFIG_IGB is not set
-# CONFIG_NS83820 is not set
-# CONFIG_HAMACHI is not set
-# CONFIG_YELLOWFIN is not set
-# CONFIG_R8169 is not set
-# CONFIG_SIS190 is not set
-# CONFIG_SKGE is not set
-# CONFIG_SKY2 is not set
-# CONFIG_VIA_VELOCITY is not set
-# CONFIG_TIGON3 is not set
-# CONFIG_BNX2 is not set
 # CONFIG_GIANFAR is not set
 CONFIG_UCC_GETH=y
 # CONFIG_UGETH_MAGIC_PACKET is not set
 # CONFIG_UGETH_TX_ON_DEMAND is not set
 # CONFIG_MV643XX_ETH is not set
-# CONFIG_QLA3XXX is not set
-# CONFIG_ATL1 is not set
-# CONFIG_ATL1E is not set
-# CONFIG_JME is not set
 CONFIG_NETDEV_10000=y
-# CONFIG_CHELSIO_T1 is not set
-CONFIG_CHELSIO_T3_DEPENDS=y
-# CONFIG_CHELSIO_T3 is not set
-# CONFIG_ENIC is not set
-# CONFIG_IXGBE is not set
-# CONFIG_IXGB is not set
-# CONFIG_S2IO is not set
-# CONFIG_MYRI10GE is not set
-# CONFIG_NETXEN_NIC is not set
-# CONFIG_NIU is not set
-# CONFIG_MLX4_EN is not set
-# CONFIG_MLX4_CORE is not set
-# CONFIG_TEHUTI is not set
-# CONFIG_BNX2X is not set
-# CONFIG_QLGE is not set
-# CONFIG_SFC is not set
-# CONFIG_TR is not set
 
 #
 # Wireless LAN
@@ -615,12 +520,18 @@ CONFIG_CHELSIO_T3_DEPENDS=y
 #
 # Enable WiMAX (Networking options) to see the WiMAX drivers
 #
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
-# CONFIG_FDDI is not set
-# CONFIG_HIPPI is not set
 # CONFIG_PPP is not set
 # CONFIG_SLIP is not set
-# CONFIG_NET_FC is not set
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
@@ -664,14 +575,12 @@ CONFIG_INPUT=y
 # CONFIG_VT is not set
 CONFIG_DEVKMEM=y
 # CONFIG_SERIAL_NONSTANDARD is not set
-# CONFIG_NOZOMI is not set
 
 #
 # Serial drivers
 #
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
-CONFIG_SERIAL_8250_PCI=y
 CONFIG_SERIAL_8250_NR_UARTS=4
 CONFIG_SERIAL_8250_RUNTIME_UARTS=4
 # CONFIG_SERIAL_8250_EXTENDED is not set
@@ -682,7 +591,6 @@ CONFIG_SERIAL_8250_RUNTIME_UARTS=4
 # CONFIG_SERIAL_UARTLITE is not set
 CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
-# CONFIG_SERIAL_JSM is not set
 # CONFIG_SERIAL_OF_PLATFORM is not set
 # CONFIG_SERIAL_QE is not set
 CONFIG_UNIX98_PTYS=y
@@ -694,10 +602,8 @@ CONFIG_LEGACY_PTY_COUNT=256
 CONFIG_HW_RANDOM=y
 # CONFIG_NVRAM is not set
 # CONFIG_R3964 is not set
-# CONFIG_APPLICOM is not set
 # CONFIG_RAW_DRIVER is not set
 # CONFIG_TCG_TPM is not set
-CONFIG_DEVPORT=y
 CONFIG_I2C=y
 CONFIG_I2C_BOARDINFO=y
 CONFIG_I2C_CHARDEV=y
@@ -708,26 +614,9 @@ CONFIG_I2C_HELPER_AUTO=y
 #
 
 #
-# PC SMBus host controller drivers
-#
-# CONFIG_I2C_ALI1535 is not set
-# CONFIG_I2C_ALI1563 is not set
-# CONFIG_I2C_ALI15X3 is not set
-# CONFIG_I2C_AMD756 is not set
-# CONFIG_I2C_AMD8111 is not set
-# CONFIG_I2C_I801 is not set
-# CONFIG_I2C_ISCH is not set
-# CONFIG_I2C_PIIX4 is not set
-# CONFIG_I2C_NFORCE2 is not set
-# CONFIG_I2C_SIS5595 is not set
-# CONFIG_I2C_SIS630 is not set
-# CONFIG_I2C_SIS96X is not set
-# CONFIG_I2C_VIA is not set
-# CONFIG_I2C_VIAPRO is not set
-
-#
 # I2C system bus drivers (mostly embedded / system-on-chip)
 #
+# CONFIG_I2C_GPIO is not set
 CONFIG_I2C_MPC=y
 # CONFIG_I2C_OCORES is not set
 # CONFIG_I2C_SIMTEC is not set
@@ -737,11 +626,7 @@ CONFIG_I2C_MPC=y
 #
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_TAOS_EVM is not set
-
-#
-# Graphics adapter I2C/DDC channel drivers
-#
-# CONFIG_I2C_VOODOO3 is not set
+# CONFIG_I2C_TINY_USB is not set
 
 #
 # Other I2C/SMBus bus drivers
@@ -753,8 +638,6 @@ CONFIG_I2C_MPC=y
 # Miscellaneous I2C Chip support
 #
 # CONFIG_DS1682 is not set
-# CONFIG_EEPROM_AT24 is not set
-# CONFIG_EEPROM_LEGACY is not set
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_PCF8575 is not set
 # CONFIG_SENSORS_PCA9539 is not set
@@ -767,7 +650,29 @@ CONFIG_I2C_MPC=y
 # CONFIG_I2C_DEBUG_CHIP is not set
 # CONFIG_SPI is not set
 CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
-# CONFIG_GPIOLIB is not set
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
+CONFIG_GPIOLIB=y
+# CONFIG_GPIO_SYSFS is not set
+
+#
+# Memory mapped GPIO expanders:
+#
+# CONFIG_GPIO_XILINX is not set
+
+#
+# I2C GPIO expanders:
+#
+# CONFIG_GPIO_MAX732X is not set
+# CONFIG_GPIO_PCA953X is not set
+# CONFIG_GPIO_PCF857X is not set
+
+#
+# PCI GPIO expanders:
+#
+
+#
+# SPI GPIO expanders:
+#
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
 CONFIG_HWMON=y
@@ -786,7 +691,6 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_ADT7475 is not set
 # CONFIG_SENSORS_ATXP1 is not set
 # CONFIG_SENSORS_DS1621 is not set
-# CONFIG_SENSORS_I5K_AMB is not set
 # CONFIG_SENSORS_F71805F is not set
 # CONFIG_SENSORS_F71882FG is not set
 # CONFIG_SENSORS_F75375S is not set
@@ -809,16 +713,13 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_MAX6650 is not set
 # CONFIG_SENSORS_PC87360 is not set
 # CONFIG_SENSORS_PC87427 is not set
-# CONFIG_SENSORS_SIS5595 is not set
 # CONFIG_SENSORS_DME1737 is not set
 # CONFIG_SENSORS_SMSC47M1 is not set
 # CONFIG_SENSORS_SMSC47M192 is not set
 # CONFIG_SENSORS_SMSC47B397 is not set
 # CONFIG_SENSORS_ADS7828 is not set
 # CONFIG_SENSORS_THMC50 is not set
-# CONFIG_SENSORS_VIA686A is not set
 # CONFIG_SENSORS_VT1211 is not set
-# CONFIG_SENSORS_VT8231 is not set
 # CONFIG_SENSORS_W83781D is not set
 # CONFIG_SENSORS_W83791D is not set
 # CONFIG_SENSORS_W83792D is not set
@@ -837,14 +738,12 @@ CONFIG_WATCHDOG=y
 # Watchdog Device Drivers
 #
 # CONFIG_SOFT_WATCHDOG is not set
-# CONFIG_ALIM7101_WDT is not set
 # CONFIG_8xxx_WDT is not set
 
 #
-# PCI-based Watchdog Cards
+# USB-based Watchdog Cards
 #
-# CONFIG_PCIPCWATCHDOG is not set
-# CONFIG_WDTPCI is not set
+# CONFIG_USBPCWATCHDOG is not set
 CONFIG_SSB_POSSIBLE=y
 
 #
@@ -858,6 +757,7 @@ CONFIG_SSB_POSSIBLE=y
 # CONFIG_MFD_CORE is not set
 # CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
+# CONFIG_TPS65010 is not set
 # CONFIG_TWL4030_CORE is not set
 # CONFIG_MFD_TMIO is not set
 # CONFIG_PMIC_DA903X is not set
@@ -881,12 +781,11 @@ CONFIG_SSB_POSSIBLE=y
 # Multimedia drivers
 #
 CONFIG_DAB=y
+# CONFIG_USB_DABUSB is not set
 
 #
 # Graphics support
 #
-# CONFIG_AGP is not set
-# CONFIG_DRM is not set
 # CONFIG_VGASTATE is not set
 CONFIG_VIDEO_OUTPUT_CONTROL=m
 # CONFIG_FB is not set
@@ -901,38 +800,148 @@ CONFIG_HID_SUPPORT=y
 CONFIG_HID=y
 # CONFIG_HID_DEBUG is not set
 # CONFIG_HIDRAW is not set
+
+#
+# USB Input Devices
+#
+CONFIG_USB_HID=y
 # CONFIG_HID_PID is not set
+# CONFIG_USB_HIDDEV is not set
 
 #
 # Special HID drivers
 #
 CONFIG_HID_COMPAT=y
+# CONFIG_HID_A4TECH is not set
+# CONFIG_HID_APPLE is not set
+# CONFIG_HID_BELKIN is not set
+# CONFIG_HID_CHERRY is not set
+# CONFIG_HID_CHICONY is not set
+# CONFIG_HID_CYPRESS is not set
+# CONFIG_HID_EZKEY is not set
+# CONFIG_HID_GYRATION is not set
+# CONFIG_HID_LOGITECH is not set
+# CONFIG_HID_MICROSOFT is not set
+# CONFIG_HID_MONTEREY is not set
+# CONFIG_HID_NTRIG is not set
+# CONFIG_HID_PANTHERLORD is not set
+# CONFIG_HID_PETALYNX is not set
+# CONFIG_HID_SAMSUNG is not set
+# CONFIG_HID_SONY is not set
+# CONFIG_HID_SUNPLUS is not set
+# CONFIG_GREENASIA_FF is not set
+# CONFIG_HID_TOPSEED is not set
+# CONFIG_THRUSTMASTER_FF is not set
+# CONFIG_ZEROPLUS_FF is not set
 CONFIG_USB_SUPPORT=y
 CONFIG_USB_ARCH_HAS_HCD=y
-CONFIG_USB_ARCH_HAS_OHCI=y
+# CONFIG_USB_ARCH_HAS_OHCI is not set
 CONFIG_USB_ARCH_HAS_EHCI=y
-# CONFIG_USB is not set
+CONFIG_USB=y
+# CONFIG_USB_DEBUG is not set
+# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
+
+#
+# Miscellaneous USB options
+#
+CONFIG_USB_DEVICEFS=y
+CONFIG_USB_DEVICE_CLASS=y
+# CONFIG_USB_DYNAMIC_MINORS is not set
+# CONFIG_USB_OTG is not set
 # CONFIG_USB_OTG_WHITELIST is not set
 # CONFIG_USB_OTG_BLACKLIST_HUB is not set
+CONFIG_USB_MON=y
+# CONFIG_USB_WUSB is not set
+# CONFIG_USB_WUSB_CBAF is not set
 
 #
-# Enable Host or Gadget support to see Inventra options
+# USB Host Controller Drivers
 #
+# CONFIG_USB_C67X00_HCD is not set
+# CONFIG_USB_EHCI_HCD is not set
+# CONFIG_USB_OXU210HP_HCD is not set
+# CONFIG_USB_ISP116X_HCD is not set
+# CONFIG_USB_ISP1760_HCD is not set
+CONFIG_USB_FHCI_HCD=y
+# CONFIG_USB_SL811_HCD is not set
+# CONFIG_USB_R8A66597_HCD is not set
+# CONFIG_USB_HWA_HCD is not set
+
+#
+# USB Device Class drivers
+#
+# CONFIG_USB_ACM is not set
+# CONFIG_USB_PRINTER is not set
+# CONFIG_USB_WDM is not set
+# CONFIG_USB_TMC is not set
 
 #
 # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
 #
+
+#
+# see USB_STORAGE Help for more information
+#
+CONFIG_USB_STORAGE=y
+# CONFIG_USB_STORAGE_DEBUG is not set
+# CONFIG_USB_STORAGE_DATAFAB is not set
+# CONFIG_USB_STORAGE_FREECOM is not set
+# CONFIG_USB_STORAGE_ISD200 is not set
+# CONFIG_USB_STORAGE_USBAT is not set
+# CONFIG_USB_STORAGE_SDDR09 is not set
+# CONFIG_USB_STORAGE_SDDR55 is not set
+# CONFIG_USB_STORAGE_JUMPSHOT is not set
+# CONFIG_USB_STORAGE_ALAUDA is not set
+# CONFIG_USB_STORAGE_ONETOUCH is not set
+# CONFIG_USB_STORAGE_KARMA is not set
+# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
+# CONFIG_USB_LIBUSUAL is not set
+
+#
+# USB Imaging devices
+#
+# CONFIG_USB_MDC800 is not set
+# CONFIG_USB_MICROTEK is not set
+
+#
+# USB port drivers
+#
+# CONFIG_USB_SERIAL is not set
+
+#
+# USB Miscellaneous drivers
+#
+# CONFIG_USB_EMI62 is not set
+# CONFIG_USB_EMI26 is not set
+# CONFIG_USB_ADUTUX is not set
+# CONFIG_USB_SEVSEG is not set
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
+# CONFIG_USB_LD is not set
+# CONFIG_USB_TRANCEVIBRATOR is not set
+# CONFIG_USB_IOWARRIOR is not set
+# CONFIG_USB_TEST is not set
+# CONFIG_USB_ISIGHTFW is not set
+# CONFIG_USB_VST is not set
 # CONFIG_USB_GADGET is not set
 
 #
 # OTG and related infrastructure
 #
-# CONFIG_UWB is not set
+# CONFIG_USB_GPIO_VBUS is not set
 # CONFIG_MMC is not set
 # CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
 # CONFIG_ACCESSIBILITY is not set
-# CONFIG_INFINIBAND is not set
 # CONFIG_EDAC is not set
 CONFIG_RTC_LIB=y
 CONFIG_RTC_CLASS=y
@@ -1106,6 +1115,7 @@ CONFIG_PARTITION_ADVANCED=y
 # CONFIG_DLM is not set
 CONFIG_UCC_FAST=y
 CONFIG_UCC=y
+CONFIG_QE_USB=y
 
 #
 # Library routines
@@ -1259,7 +1269,6 @@ CONFIG_CRYPTO_DES=y
 #
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRYPTO_HW=y
-# CONFIG_CRYPTO_DEV_HIFN_795X is not set
 # CONFIG_CRYPTO_DEV_TALITOS is not set
 # CONFIG_PPC_CLOCK is not set
 CONFIG_PPC_LIB_RHEAP=y
diff --git a/arch/powerpc/platforms/83xx/Kconfig b/arch/powerpc/platforms/83xx/Kconfig
index 83c664a..68a2aeb 100644
--- a/arch/powerpc/platforms/83xx/Kconfig
+++ b/arch/powerpc/platforms/83xx/Kconfig
@@ -20,6 +20,7 @@ config MPC832x_MDS
 	bool "Freescale MPC832x MDS"
 	select DEFAULT_UIMAGE
 	select PPC_MPC832x
+	select FSL_LBC
 	help
 	  This option enables support for the MPC832x MDS evaluation board.
 
diff --git a/arch/powerpc/platforms/83xx/mpc832x_mds.c b/arch/powerpc/platforms/83xx/mpc832x_mds.c
index ec0b401..e9baae5 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_mds.c
@@ -12,6 +12,7 @@
 
 #include <linux/stddef.h>
 #include <linux/kernel.h>
+#include <linux/compiler.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/reboot.h>
@@ -37,6 +38,7 @@
 #include <asm/udbg.h>
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
+#include <sysdev/simple_gpio.h>
 #include <asm/qe.h>
 #include <asm/qe_ic.h>
 
@@ -86,6 +88,16 @@ static void __init mpc832x_sys_setup_arch(void)
 
 		for (np = NULL; (np = of_find_node_by_name(np, "ucc")) != NULL;)
 			par_io_of_config(np);
+#ifdef CONFIG_QE_USB
+		/* Must fixup Par IO before QE GPIO chips are registered. */
+		par_io_config_pin(0,  8, 1, 0, 3, 0);   /* PA8 for USBOE */
+		par_io_config_pin(0,  1, 1, 0, 3, 0);   /* PA1 for USBTP */
+		par_io_config_pin(0,  0, 1, 0, 3, 0);   /* PA0 for USBTN */
+		par_io_config_pin(0,  6, 2, 0, 3, 0);   /* PA6 for USBRXD */
+		par_io_config_pin(0,  4, 2, 1, 3, 0);   /* PA4 for USBRP */
+		par_io_config_pin(0,  5, 2, 1, 3, 0);   /* PA5 for USBRN */
+		par_io_config_pin(0, 14, 2, 0, 1, 0);   /* PA14 for BRG10/CLK11*/
+#endif /* CONFIG_QE_USB */
 	}
 
 	if ((np = of_find_compatible_node(NULL, "network", "ucc_geth"))
@@ -119,6 +131,60 @@ static int __init mpc832x_declare_of_platform_devices(void)
 }
 machine_device_initcall(mpc832x_mds, mpc832x_declare_of_platform_devices);
 
+#ifdef CONFIG_QE_USB
+static int __init mpc832x_usb_cfg(void)
+{
+	u8 __iomem *bcsr;
+	struct device_node *np;
+	const char *mode;
+	int ret = 0;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,mpc8323mds-bcsr");
+	if (!np)
+		return -ENODEV;
+
+	bcsr = of_iomap(np, 0);
+	of_node_put(np);
+	if (!bcsr)
+		return -ENOMEM;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,mpc8323-qe-usb");
+	if (!np) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+#define BCSR12_USBMASK	0x0f
+#define BCSR12_nUSBEN	0x08 /* 1 - Disable, 0 - Enable			*/
+#define BCSR12_USBSPEED	0x04 /* 1 - Full, 0 - Low			*/
+#define BCSR12_USBMODE	0x02 /* 1 - Host, 0 - Function			*/
+#define BCSR12_nUSBVCC	0x01 /* 1 - gets VBUS, 0 - supplies VBUS 	*/
+
+	clrsetbits_8(&bcsr[12], BCSR12_USBMASK, BCSR12_USBSPEED);
+
+	mode = of_get_property(np, "mode", NULL);
+	if (mode && !strcmp(mode, "peripheral")) {
+		setbits8(&bcsr[12], BCSR12_nUSBVCC);
+		qe_usb_clock_set(QE_CLK21, 48000000);
+	} else {
+//Userguide lies about this!
+//		setbits8(&bcsr[12], BCSR12_USBMODE);
+		/*
+		 * The BCSR GPIOs are used to control power and
+		 * speed of the USB transceiver. This is needed for
+		 * the USB Host only.
+		 */
+		simple_gpiochip_init("fsl,mpc8323mds-bcsr-gpio");
+	}
+
+	of_node_put(np);
+err:
+	iounmap(bcsr);
+	return ret;
+}
+machine_arch_initcall(mpc832x_mds, mpc832x_usb_cfg);
+#endif /* CONFIG_QE_USB */
+
 static void __init mpc832x_sys_init_IRQ(void)
 {
 	struct device_node *np;
diff --git a/arch/powerpc/sysdev/qe_lib/qe.c b/arch/powerpc/sysdev/qe_lib/qe.c
index 01bce37..3342f77 100644
--- a/arch/powerpc/sysdev/qe_lib/qe.c
+++ b/arch/powerpc/sysdev/qe_lib/qe.c
@@ -200,7 +200,11 @@ int qe_setbrg(enum qe_clock brg, unsigned int rate, unsigned int multiplier)
 	if ((brg < QE_BRG1) || (brg > QE_BRG16))
 		return -EINVAL;
 
-	divisor = qe_get_brg_clk() / (rate * multiplier);
+#define USB_CLOCK      48000000
+	if(brg == QE_BRG10) 
+		divisor = USB_CLOCK / (rate * multiplier);
+	else
+		divisor = qe_get_brg_clk() / (rate * multiplier);
 
 	if (divisor > QE_BRGC_DIVISOR_MAX + 1) {
 		div16 = QE_BRGC_DIV16;
@@ -216,6 +220,10 @@ int qe_setbrg(enum qe_clock brg, unsigned int rate, unsigned int multiplier)
 	tempval = ((divisor - 1) << QE_BRGC_DIVISOR_SHIFT) |
 		QE_BRGC_ENABLE | div16;
 
+#define BRGC_EXTC_CLK11 0x00004000
+	if(brg == QE_BRG10)
+		tempval |= BRGC_EXTC_CLK11;
+
 	out_be32(&qe_immr->brg.brgc[brg - QE_BRG1], tempval);
 
 	return 0;
diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
index ba622cc..ba26d19 100644
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -620,12 +620,21 @@ static int __devinit of_fhci_probe(struct of_device *ofdev,
 		goto err_pram;
 	}
 
+#ifdef CONFIG_MPC832x_MDS
+	pram_addr = qe_muram_alloc(FHCI_PRAM_SIZE, 64);
+#else
 	pram_addr = cpm_muram_alloc_fixed(iprop[2], FHCI_PRAM_SIZE);
+#endif
 	if (IS_ERR_VALUE(pram_addr)) {
 		dev_err(dev, "failed to allocate usb pram\n");
 		ret = -ENOMEM;
 		goto err_pram;
 	}
+#ifdef CONFIG_MPC832x_MDS
+	/* Section 19.3.1.1.1 Assign page Command */
+	qe_issue_cmd(QE_ASSIGN_PAGE_TO_DEVICE, QE_CR_SUBBLOCK_USB,
+		     QE_CR_PROTOCOL_UNSPECIFIED, pram_addr);
+#endif
 	fhci->pram = cpm_muram_addr(pram_addr);
 
 	/* GPIOs and pins */
-- 
1.6.0.6

