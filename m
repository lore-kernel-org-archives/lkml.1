Return-Path: <linux-kernel-owner+w=401wt.eu-S934703AbYEVIna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934703AbYEVIna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933660AbYEVInM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:43:12 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:59576 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933218AbYEVInG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:43:06 -0400
Date: Thu, 22 May 2008 04:43:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 256 current references to "bad" CONFIG variables
Message-ID: <alpine.LFD.1.10.0805220426170.28308@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  at the moment, with a fully "git pull"ed source tree, there are
exactly 256 (what a great number) tests of variables of the form
"CONFIG_whatever" for which there is no corresponding Kconfig variable
definition anywhere in the tree.  (patches to handle some of these are
already in the pipeline, but i thought i'd just give a progress report
on the tree as it exists right now.)

  an *old* version of this script output, broken down by directory for
convenience, can be seen here:

  http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables

  if you want to generate this output for some sub-tree, here's the
script (and, no, i don't want your advice on programming style -- i
*know* it's hacky :-):

===== cut here =====

#!/bin/sh

DIR=${1-*}

CVARS=$(find ${DIR} -name "*.[ch]" |    \
        xargs ifnames |                 \
        grep "^CONFIG_" |               \
        cut -d' ' -f1 |                 \
        sed "s/^CONFIG_//" |            \
        sed "s/_MODULE$//" |            \
        sort -u)

kcfiles=$(find . -name "Kconfig*")

for cv in ${CVARS} ; do
	egrep -q "^[[:space:]]*config[[:space:]]+${cv}\b" ${kcfiles} ||
        grep -q "^menuconfig *${cv}$" ${kcfiles} ||
	egrep -qr "^[[:space:]]*#[[:space:]]*define[[:space:]]+CONFIG_${cv}\b" * || {
                echo ">>>>> ${cv}"
                grep -rwn "CONFIG_${cv}" *
                grep -rwn "${cv}" *
        }
done

===== stop cutting here =====

  just run the script from the top of the source tree, and feed it the
subtree you want to examine, as in, say, the "drivers/video"
directory:

$ checkbadconfigs.sh drivers/video
>>>>> FB_68328_INVERT
drivers/video/68328fb.c:53:#if defined(CONFIG_FB_68328_INVERT)
>>>>> FB_OMAP_MANUAL_UPDATE
drivers/video/omap/omapfb_main.c:44:#ifdef CONFIG_FB_OMAP_MANUAL_UPDATE
>>>>> FB_SOFT_CURSOR
arch/arm/configs/shannon_defconfig:627:CONFIG_FB_SOFT_CURSOR=y
arch/arm/configs/simpad_defconfig:699:# CONFIG_FB_SOFT_CURSOR is not set
arch/arm/configs/integrator_defconfig:631:CONFIG_FB_SOFT_CURSOR=y
arch/arm/configs/h3600_defconfig:682:CONFIG_FB_SOFT_CURSOR=y
arch/arm/configs/pxa255-idp_defconfig:553:CONFIG_FB_SOFT_CURSOR=y
arch/arm/configs/h7202_defconfig:523:# CONFIG_FB_SOFT_CURSOR is not set
arch/arm/configs/lpd7a400_defconfig:585:CONFIG_FB_SOFT_CURSOR=y
arch/arm/configs/mainstone_defconfig:557:CONFIG_FB_SOFT_CURSOR=y
arch/arm/configs/footbridge_defconfig:877:CONFIG_FB_SOFT_CURSOR=y
arch/arm/configs/shark_defconfig:661:CONFIG_FB_SOFT_CURSOR=y
arch/arm/configs/clps7500_defconfig:608:CONFIG_FB_SOFT_CURSOR=y
arch/arm/configs/realview_defconfig:539:CONFIG_FB_SOFT_CURSOR=y
arch/arm/configs/jornada720_defconfig:713:# CONFIG_FB_SOFT_CURSOR is not set
arch/arm/configs/netwinder_defconfig:691:CONFIG_FB_SOFT_CURSOR=y
drivers/video/sis/sis_main.c:1912:#ifdef CONFIG_FB_SOFT_CURSOR
$

  each "bad" CONFIG reference is followed by a tree-wide grep for
every place it's used.

  FWIW, here's the normalized and sorted list:

403
440GR
68328_SERIAL_UART2
ACORNSCSI_CONSTANTS
AD9960
ADS
ADS8260
AIC7XXX_PROC_STATS
ALMA_ANS
AP1000
ARCH_GUMSTIX_ORIG
ARCH_H1900
ARCH_H5400
ARCH_HAS_ASYNC_TX_FIND_CHANNEL
ARCH_INNOKOM
ARCH_OMAP3
ARCH_OMAP3430
ARCH_OMAP34XX
ARCH_PCM027
ARCH_PNX010X
ARCH_RAMSES
ARM_KS8695_ETHER
AS_CFI
AS_CFI_SIGNAL_FRAME
AT91SAM9_WATCHDOG
AT91_SLOW_CLOCK
AX88180
BCM947XX
BCM_CS4297A_CSWARM
BEFS_RW
BF535
BFIN_CFPCMCIA
BFIN_SIR
BFIN_SIR0
BFIN_SIR1
BFIN_SIR2
BFIN_SIR3
BIG_ENDIAN
BLK_DEV_DAVINCI
BLK_DEV_FLASH
BLK_DEV_MFM
BT_BNEP_DEBUG
BT_CMTP_DEBUG
BT_HCIBCM203X_DEBUG
BT_HCIBFUSB_DEBUG
BT_HCIBPA10X_DEBUG
BT_HCIBTSDIO_DEBUG
BT_HCIBTUSB_DEBUG
BT_HCI_CORE_DEBUG
BT_HCI_SOCK_DEBUG
BT_HCIUART_DEBUG
BT_HCIUSB_DEBUG
BT_HCIUSB_ZERO_PACKET
BT_HCIVHCI_DEBUG
BT_HIDP_DEBUG
BT_L2CAP_DEBUG
BT_RFCOMM_DEBUG
BT_SCO_DEBUG
BT_SOCK_DEBUG
BUFFER_DEBUG
CASSINI_MULTICAST_REG_WRITE
CASSINI_NAPI
CASSINI_QGE_DEBUG
CBUS_TAHVO_USB
CHELSIO_T1_COUGAR
CHIP_M32310
CHIP_MP
CHIP_XNUX2
CHIP_XNUX2_MP
CHIP_XNUX_MP
CHR_DEV_FLASH
CHRONTEL_7003
CIFS_QUOTA
CONSOLE
CONSOLE_115200
CONSOLE_19200
CONSOLE_9600
CPU_S3C2400
CPU_S3C2413
CPU_SUBTYPE_ST40
DCACHE_DISABLED
DEBUG_BRINGUP
DEBUG_PAGE_TYPE
DRAGONIXVZ
DUET
DVB_DIBCOM_DEBUG
ETRAX_DEBUG_PORT4
ETRAX_EXTERN_PB6CLK_ENABLED
ETRAX_KGB_PORT2
ETRAX_NETWORK_RED_ON_NO_CONNECTION
ETRAX_RS485_LTC1387
ETRAX_RS485_ON_PORT_G
ETRAX_RTC_READONLY
ETRAX_SERIAL_PROC_ENTRY
EVB64260
EXCITE_FCAP_GPI
FB_68328_INVERT
FB_BF537_LQ035
FB_BFIN_7393
FB_HITACHI_TX09
FB_OMAP_MANUAL_UPDATE
FB_PXA_MODULES
FB_RPX
FB_S1D135XX
FB_SOFT_CURSOR
FEC_PACKETHOOK
FLASH_SPEED_BHT
GDBSTUB_CONSOLE
GG2
GILBARCO
GILBARCONAP
GPIOEXPANDER_OMAP
H8048
H8300_AKI3068NET
HARD_PPS
HT_LEVEL_TRIGGER
HYMOD
ICACHE_DISABLED
IDC_AK4524
IDE_PXA_CF
IOMMU
IPAQ_HANDHELD
IP_ROUTE_PERVASIVE
JOYSTICK_AD7142
JULIETTE
KDB_MODULES
KEYBOARD_OPENCORES
KEYBOARD_PXA27x_MODULES
KGDB_MPSC
KGDB_UART
KUP4K
LAB
LEDS_OMAP_DEBUG
LPFC_DEBUG_FS
M32RPCC_SLOT2
M68000
M68EZ328ADS
MACH_LPD79520
MACH_OMAP_H4_OTG
MCBSP_DEBUG
MEMHOLE
MEM_MT48LC16M8A2TG_75
MEMORY_HOTPLUG_RESERVE
MPC821
MPC8315_DS
MPC8555
MPC860
MPC860T
MPC8xx_SECOND_ETH_SCC1
MTD_2PARTS_IPAQ
MTD_BFIN_ASYNC
MTD_PB1550_BOOT
MTD_PB1550_USER
MTD_SUPERH_RESERVE
MV64360_SRAM_CACHE_COHERENT
NCR53C8XX_PREFETCH
NETTA
NETWINDER_TX_DMA_PROBLEMS
NO_ATA_LEGACY
OMAP_ARM_96MHZ
OMAP_BOOT_TAG
OMAP_DSP
OMAP_IR
OMAP_MMU_FWK
OMAP_MUX_ERRORS
OMAP_STI
OPEN_FIRMWARE
OUT_OF_LINE_PFN_TO_PAGE
PBX
PCMCIA_XXS1500
PMCTWILED
PM_LEGACY
PP04
PPC_INDIRECT_PCI_BE
PREEMPT_BKL
PROCESSOR_NS9750
PROC_MM
PRxK
REMOTE_DEBUG
RM9K_GE
ROMFS_MTD_FS
RPXTOUCH
SA1100_CT6001
SA1100_JORNADA56X
SA1101
SCSI_ACORNSCSI_LINK
SCSI_DC395x_TRMS1040_TRADMAP
SCSI_G_NCR5380_MEM
SCSI_NCR53C8XX_DISABLE_MPARITY_CHECK
SCSI_NCR53C8XX_DISABLE_PARITY_CHECK
SCSI_NCR53C8XX_FORCE_SYNC_NEGO
SCSI_NCR53C8XX_IARB
SCSI_NCR53C8XX_INTEGRITY_CHECK
SCSI_NCR53C8XX_NO_WORD_TRANSFERS
SCSI_NCR53C8XX_TAGGED_QUEUE
SDH_BFIN
SENSORS_AD7414
SERIAL_CPM_ALT_SMC2
SGI_IP35
SHARE_SHLIB_CORE
SH_HICOSH4
SIBYTE_BCM1480_PROF
SIR_BFIN_DMA
SMALL_TASKS
SMC91111
SMP_750
SMSC911X
SND_AT91_AC97
SND_BLACKFIN_AD1836
SND_DEBUG_ROM
SND_HPET
SND_SOC_WM8731_SPI
SOC_AU1000_FREQUENCY
SOUND_AEDSP16_MSS
SOUND_AEDSP16_SBPRO
SOUND_AU1X00
SOUND_SOFTOSS
SPI_ADC_BF533
SPI_MMC
SQUASHFS
SX1_OLD_FLASH
TOUCHSCREEN_AD7877
TTY_LOG
TWI_KEYPAD
TWI_LCD
UART0_TTYS2
UNALIGNED_USER
UNWIND_INFO
USB_EHCI_SPLIT_ISO
USB_GADGET_IMX
USB_GADGET_MPC8272
USB_GADGET_MQ11XX
USB_GADGET_MUSB_HDRC
USB_GADGET_MUSBHSFC
USB_GADGET_N9604
USB_GADGET_SA1100
USB_GADGET_SUPERH
USB_ISP1362_HCD
USB_MUSB_HDRC
USB_MUSB_HDRC_HCD
USB_MUSB_OTG
USB_NET2272
USB_SL811_BFIN_USE_VBUS
USE_INTERNAL_TIMER
USE_MIXARTLOADER
USE_PCXHRLOADER
USE_VXLOADER
V850E2_V850E2S
VIDEO_400_HACK
VIDEO_AT91_ISI
WANPIPE_MULTPPP
WD33C93_PIO
X86_CMPXCHG64
XEN_BACKEND
XFS_DMAPI
XFS_TRACE



rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
