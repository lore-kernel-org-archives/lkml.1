Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316Ab0A1ORV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab0A1ORV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 09:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924Ab0A1ORU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 09:17:20 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:48046 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752799Ab0A1ORT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 09:17:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjQBAHYqYUtLd/sX/2dsb2JhbAAIgy/HWYIZAY09gSqCOVkE
X-IronPort-AV: E=Sophos;i="4.49,359,1262581200"; 
   d="scan'208";a="54738697"
Message-ID: <4B619C6D.9030205@teksavvy.com>
Date: Thu, 28 Jan 2010 09:17:17 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mel Gorman <mel@csn.ul.ie>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1,
References: <4B5FA147.5040802@teksavvy.com> <4B610FDA.50104@teksavvy.com> <4B6113C7.201@teksavvy.com> <201001281152.20352.rjw@sisk.pl> <4B61964F.6060307@teksavvy.com>
In-Reply-To: <4B61964F.6060307@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Rafael J. Wysocki wrote:
>> Have you attached a (2.6.31.x) dmesg output from the failing box 
>> somewhere
>> or have I just missed it?
> ..
> 
> The log from failing on 2.6.32.5 was linked to originally:
> 
>   http://rtr.ca/2.6.32_page_alloc_fail_logs.txt
> Here's the subsequent revert reboot back to 2.6.32.12:
> 
>   http://rtr.ca/2.6.31.12_ok_logs.txt
> 
> In the time available thus far, I haven't managed to get 2.6.32.5
> to boot/run on anything else, using either a UP kernel, or "nosmp",
> along with "mem=512M".
> 
> With a bit of luck, I'll have another similar VIA C7 box delivered here 
> by tonight,
> and should be able to boot/run that off a cloned disk image from the 
> original system.
> 
> Then we can poke at things a bit more.
> If the box works, it will be 100% at our disposal.
> 
> Note that it's far too slow for practical direct use of git-bisect,
> taking hours to rebuild its own kernels.  It might be possible,
> with a fair bit of effort, to arrange a quad-core box to do the
> kernel compiles for it, though.
..

Rather than wasting time trying to bisect a full major kernel revision,
I think instead I'll just focus on mm/page_alloc.c.

It appears the biggest changes were to get_page_from_freelist(),
so perhaps we'll just revert that one function and see how the
clone system behaves.

In the meanwhile, here's the diff -u of the two .config files:


--- 2.6.31/linux/.config	2010-01-26 21:38:36.000000000 -0500
+++ 2.6.32/linux/.config	2010-01-26 20:57:44.928354653 -0500
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.31.12
-# Tue Jan 26 21:38:36 2010
+# Linux kernel version: 2.6.32.6
+# Tue Jan 26 20:57:44 2010
 #
 # CONFIG_64BIT is not set
 CONFIG_X86_32=y
@@ -16,7 +16,6 @@
 CONFIG_LOCKDEP_SUPPORT=y
 CONFIG_STACKTRACE_SUPPORT=y
 CONFIG_HAVE_LATENCYTOP_SUPPORT=y
-CONFIG_FAST_CMPXCHG_LOCAL=y
 CONFIG_MMU=y
 CONFIG_ZONE_DMA=y
 CONFIG_GENERIC_ISA_DMA=y
@@ -33,7 +32,8 @@
 CONFIG_ARCH_HAS_DEFAULT_IDLE=y
 CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
-CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
+CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
+CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
 # CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
 CONFIG_ARCH_HIBERNATION_POSSIBLE=y
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
@@ -76,11 +76,12 @@
 #
 # RCU Subsystem
 #
-CONFIG_CLASSIC_RCU=y
-# CONFIG_TREE_RCU is not set
-# CONFIG_PREEMPT_RCU is not set
+CONFIG_TREE_RCU=y
+# CONFIG_TREE_PREEMPT_RCU is not set
+# CONFIG_RCU_TRACE is not set
+CONFIG_RCU_FANOUT=8
+# CONFIG_RCU_FANOUT_EXACT is not set
 # CONFIG_TREE_RCU_TRACE is not set
-# CONFIG_PREEMPT_RCU_TRACE is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
@@ -123,21 +124,20 @@
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
 CONFIG_AIO=y
-CONFIG_HAVE_PERF_COUNTERS=y
+CONFIG_HAVE_PERF_EVENTS=y
 
 #
-# Performance Counters
+# Kernel Performance Events And Counters
 #
+# CONFIG_PERF_EVENTS is not set
 # CONFIG_PERF_COUNTERS is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_PCI_QUIRKS=y
-CONFIG_STRIP_ASM_SYMS=y
 CONFIG_COMPAT_BRK=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
 # CONFIG_PROFILING is not set
-# CONFIG_MARKERS is not set
 CONFIG_HAVE_OPROFILE=y
 # CONFIG_KPROBES is not set
 CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
@@ -151,7 +151,7 @@
 #
 # GCOV-based kernel profiling
 #
-# CONFIG_SLOW_WORK is not set
+CONFIG_SLOW_WORK=y
 CONFIG_HAVE_GENERIC_DMA_COHERENT=y
 CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
@@ -217,6 +217,7 @@
 # CONFIG_MVIAC7 is not set
 # CONFIG_MPSC is not set
 # CONFIG_MCORE2 is not set
+# CONFIG_MATOM is not set
 # CONFIG_GENERIC_CPU is not set
 # CONFIG_X86_GENERIC is not set
 CONFIG_X86_CPU=y
@@ -250,7 +251,6 @@
 # CONFIG_PREEMPT is not set
 # CONFIG_X86_UP_APIC is not set
 # CONFIG_X86_MCE is not set
-# CONFIG_X86_ANCIENT_MCE is not set
 CONFIG_VM86=y
 # CONFIG_TOSHIBA is not set
 # CONFIG_I8K is not set
@@ -283,6 +283,7 @@
 CONFIG_VIRT_TO_BUS=y
 CONFIG_HAVE_MLOCK=y
 CONFIG_HAVE_MLOCKED_PAGE_BIT=y
+# CONFIG_KSM is not set
 CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
 # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
 # CONFIG_X86_RESERVE_LOW_64K is not set
@@ -313,6 +314,7 @@
 # CONFIG_PM_DEBUG is not set
 # CONFIG_SUSPEND is not set
 # CONFIG_HIBERNATION is not set
+# CONFIG_PM_RUNTIME is not set
 CONFIG_ACPI=y
 CONFIG_ACPI_PROCFS=y
 CONFIG_ACPI_PROCFS_POWER=y
@@ -324,6 +326,7 @@
 CONFIG_ACPI_FAN=m
 CONFIG_ACPI_DOCK=y
 CONFIG_ACPI_PROCESSOR=m
+# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
 CONFIG_ACPI_THERMAL=m
 # CONFIG_ACPI_CUSTOM_DSDT is not set
 CONFIG_ACPI_BLACKLIST_YEAR=0
@@ -332,6 +335,7 @@
 CONFIG_X86_PM_TIMER=y
 CONFIG_ACPI_CONTAINER=m
 # CONFIG_ACPI_SBS is not set
+# CONFIG_SFI is not set
 
 #
 # CPU Frequency scaling
@@ -626,6 +630,7 @@
 #
 # CONFIG_IP_DCCP_DEBUG is not set
 # CONFIG_IP_SCTP is not set
+# CONFIG_RDS is not set
 # CONFIG_TIPC is not set
 # CONFIG_ATM is not set
 CONFIG_STP=m
@@ -723,6 +728,7 @@
 # Generic Driver Options
 #
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+# CONFIG_DEVTMPFS is not set
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 CONFIG_FW_LOADER=y
@@ -816,6 +822,7 @@
 # CONFIG_SCSI_OSD_INITIATOR is not set
 CONFIG_ATA=y
 # CONFIG_ATA_NONSTANDARD is not set
+CONFIG_ATA_VERBOSE_ERROR=y
 CONFIG_ATA_ACPI=y
 # CONFIG_SATA_PMP is not set
 # CONFIG_SATA_AHCI is not set
@@ -839,6 +846,7 @@
 # CONFIG_PATA_ALI is not set
 # CONFIG_PATA_AMD is not set
 # CONFIG_PATA_ARTOP is not set
+# CONFIG_PATA_ATP867X is not set
 # CONFIG_PATA_ATIIXP is not set
 # CONFIG_PATA_CMD640_PCI is not set
 # CONFIG_PATA_CMD64X is not set
@@ -871,6 +879,7 @@
 # CONFIG_PATA_PDC_OLD is not set
 # CONFIG_PATA_QDI is not set
 # CONFIG_PATA_RADISYS is not set
+# CONFIG_PATA_RDC is not set
 # CONFIG_PATA_RZ1000 is not set
 # CONFIG_PATA_SC1200 is not set
 # CONFIG_PATA_SERVERWORKS is not set
@@ -973,6 +982,7 @@
 # CONFIG_SUNDANCE is not set
 # CONFIG_TLAN is not set
 # CONFIG_KS8842 is not set
+# CONFIG_KS8851_MLL is not set
 CONFIG_VIA_RHINE=y
 # CONFIG_VIA_RHINE_MMIO is not set
 # CONFIG_SC92031 is not set
@@ -1005,12 +1015,7 @@
 # CONFIG_JME is not set
 # CONFIG_NETDEV_10000 is not set
 # CONFIG_TR is not set
-
-#
-# Wireless LAN
-#
-# CONFIG_WLAN_PRE80211 is not set
-# CONFIG_WLAN_80211 is not set
+# CONFIG_WLAN is not set
 
 #
 # Enable WiMAX (Networking options) to see the WiMAX drivers
@@ -1063,6 +1068,7 @@
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
+# CONFIG_VMXNET3 is not set
 # CONFIG_ISDN is not set
 # CONFIG_PHONE is not set
 
@@ -1088,9 +1094,13 @@
 # Input Device Drivers
 #
 CONFIG_INPUT_KEYBOARD=y
+# CONFIG_KEYBOARD_ADP5588 is not set
 CONFIG_KEYBOARD_ATKBD=y
+# CONFIG_QT2160 is not set
 # CONFIG_KEYBOARD_LKKBD is not set
+# CONFIG_KEYBOARD_MAX7359 is not set
 # CONFIG_KEYBOARD_NEWTON is not set
+# CONFIG_KEYBOARD_OPENCORES is not set
 # CONFIG_KEYBOARD_STOWAWAY is not set
 # CONFIG_KEYBOARD_SUNKBD is not set
 # CONFIG_KEYBOARD_XTKBD is not set
@@ -1102,6 +1112,7 @@
 CONFIG_MOUSE_PS2_LIFEBOOK=y
 CONFIG_MOUSE_PS2_TRACKPOINT=y
 # CONFIG_MOUSE_PS2_ELANTECH is not set
+# CONFIG_MOUSE_PS2_SENTELIC is not set
 # CONFIG_MOUSE_PS2_TOUCHKIT is not set
 # CONFIG_MOUSE_SERIAL is not set
 # CONFIG_MOUSE_APPLETOUCH is not set
@@ -1125,6 +1136,7 @@
 CONFIG_INPUT_YEALINK=m
 # CONFIG_INPUT_CM109 is not set
 CONFIG_INPUT_UINPUT=m
+# CONFIG_INPUT_WINBOND_CIR is not set
 
 #
 # Hardware I/O ports
@@ -1224,6 +1236,7 @@
 CONFIG_DEVPORT=y
 CONFIG_I2C=m
 CONFIG_I2C_BOARDINFO=y
+CONFIG_I2C_COMPAT=y
 # CONFIG_I2C_CHARDEV is not set
 CONFIG_I2C_HELPER_AUTO=y
 CONFIG_I2C_ALGOBIT=m
@@ -1251,6 +1264,11 @@
 CONFIG_I2C_VIAPRO=m
 
 #
+# ACPI drivers
+#
+# CONFIG_I2C_SCMI is not set
+
+#
 # I2C system bus drivers (mostly embedded / system-on-chip)
 #
 # CONFIG_I2C_OCORES is not set
@@ -1282,9 +1300,6 @@
 # Miscellaneous I2C Chip support
 #
 # CONFIG_DS1682 is not set
-# CONFIG_SENSORS_PCF8574 is not set
-# CONFIG_PCF8575 is not set
-# CONFIG_SENSORS_PCA9539 is not set
 # CONFIG_SENSORS_TSL2550 is not set
 # CONFIG_I2C_DEBUG_CORE is not set
 # CONFIG_I2C_DEBUG_ALGO is not set
@@ -1320,6 +1335,7 @@
 # CONFIG_ALIM1535_WDT is not set
 # CONFIG_ALIM7101_WDT is not set
 # CONFIG_SC520_WDT is not set
+# CONFIG_SBC_FITPC2_WATCHDOG is not set
 # CONFIG_EUROTECH_WDT is not set
 # CONFIG_IB700_WDT is not set
 # CONFIG_IBMASR is not set
@@ -1377,6 +1393,7 @@
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_MFD_TMIO is not set
 # CONFIG_MFD_WM8400 is not set
+# CONFIG_MFD_WM831X is not set
 # CONFIG_MFD_WM8350_I2C is not set
 # CONFIG_MFD_PCF50633 is not set
 # CONFIG_AB3100_CORE is not set
@@ -1397,6 +1414,7 @@
 # CONFIG_AGP_SWORKS is not set
 CONFIG_AGP_VIA=m
 # CONFIG_AGP_EFFICEON is not set
+CONFIG_VGA_ARB=y
 CONFIG_DRM=m
 # CONFIG_DRM_TDFX is not set
 # CONFIG_DRM_R128 is not set
@@ -1480,6 +1498,7 @@
 # CONFIG_LOGO is not set
 CONFIG_SOUND=m
 CONFIG_SOUND_OSS_CORE=y
+CONFIG_SOUND_OSS_CORE_PRECLAIM=y
 CONFIG_SND=m
 CONFIG_SND_TIMER=m
 CONFIG_SND_PCM=m
@@ -1501,6 +1520,7 @@
 # CONFIG_SND_VERBOSE_PRINTK is not set
 # CONFIG_SND_DEBUG is not set
 CONFIG_SND_VMASTER=y
+CONFIG_SND_DMA_SGBUF=y
 CONFIG_SND_RAWMIDI_SEQ=m
 # CONFIG_SND_OPL3_LIB_SEQ is not set
 # CONFIG_SND_OPL4_LIB_SEQ is not set
@@ -1599,7 +1619,6 @@
 CONFIG_AC97_BUS=m
 CONFIG_HID_SUPPORT=y
 CONFIG_HID=m
-# CONFIG_HID_DEBUG is not set
 CONFIG_HIDRAW=y
 
 #
@@ -1623,6 +1642,7 @@
 CONFIG_HID_EZKEY=m
 CONFIG_HID_KYE=m
 CONFIG_HID_GYRATION=m
+CONFIG_HID_TWINHAN=m
 CONFIG_HID_KENSINGTON=m
 CONFIG_HID_LOGITECH=m
 # CONFIG_LOGITECH_FF is not set
@@ -1676,6 +1696,7 @@
 # CONFIG_USB_OXU210HP_HCD is not set
 # CONFIG_USB_ISP116X_HCD is not set
 # CONFIG_USB_ISP1760_HCD is not set
+# CONFIG_USB_ISP1362_HCD is not set
 CONFIG_USB_OHCI_HCD=m
 # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
 # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
@@ -1855,8 +1876,8 @@
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 # CONFIG_EXT3_FS_XATTR is not set
 CONFIG_EXT4_FS=y
-# CONFIG_EXT4DEV_COMPAT is not set
 # CONFIG_EXT4_FS_XATTR is not set
+# CONFIG_EXT4_DEBUG is not set
 CONFIG_JBD=y
 CONFIG_JBD2=y
 # CONFIG_REISERFS_FS is not set
@@ -1865,6 +1886,7 @@
 # CONFIG_XFS_FS is not set
 # CONFIG_OCFS2_FS is not set
 # CONFIG_BTRFS_FS is not set
+# CONFIG_NILFS2_FS is not set
 CONFIG_FILE_LOCKING=y
 CONFIG_FSNOTIFY=y
 CONFIG_DNOTIFY=y
@@ -2003,6 +2025,7 @@
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_FRAME_WARN=0
 CONFIG_MAGIC_SYSRQ=y
+CONFIG_STRIP_ASM_SYMS=y
 CONFIG_UNUSED_SYMBOLS=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
@@ -2039,6 +2062,7 @@
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 # CONFIG_DEBUG_NOTIFIERS is not set
+# CONFIG_DEBUG_CREDENTIALS is not set
 CONFIG_ARCH_WANT_FRAME_POINTERS=y
 # CONFIG_FRAME_POINTER is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
@@ -2046,6 +2070,7 @@
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
+# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
@@ -2057,7 +2082,7 @@
 CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
-CONFIG_HAVE_FTRACE_SYSCALLS=y
+CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
 CONFIG_TRACING_SUPPORT=y
 # CONFIG_FTRACE is not set
 # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
@@ -2118,7 +2143,7 @@
 CONFIG_CRYPTO_PCOMP=m
 CONFIG_CRYPTO_MANAGER=m
 CONFIG_CRYPTO_MANAGER2=m
-CONFIG_CRYPTO_GF128MUL=m
+CONFIG_CRYPTO_GF128MUL=y
 CONFIG_CRYPTO_NULL=m
 CONFIG_CRYPTO_WORKQUEUE=m
 CONFIG_CRYPTO_CRYPTD=m
@@ -2129,7 +2154,7 @@
 # Authenticated Encryption with Associated Data
 #
 CONFIG_CRYPTO_CCM=m
-CONFIG_CRYPTO_GCM=m
+# CONFIG_CRYPTO_GCM is not set
 CONFIG_CRYPTO_SEQIV=m
 
 #
@@ -2148,12 +2173,14 @@
 #
 CONFIG_CRYPTO_HMAC=m
 CONFIG_CRYPTO_XCBC=m
+CONFIG_CRYPTO_VMAC=m
 
 #
 # Digest
 #
 CONFIG_CRYPTO_CRC32C=m
 # CONFIG_CRYPTO_CRC32C_INTEL is not set
+# CONFIG_CRYPTO_GHASH is not set
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
@@ -2208,7 +2235,6 @@
 # CONFIG_CRYPTO_DEV_GEODE is not set
 # CONFIG_CRYPTO_DEV_HIFN_795X is not set
 CONFIG_HAVE_KVM=y
-CONFIG_HAVE_KVM_IRQCHIP=y
 # CONFIG_VIRTUALIZATION is not set
 # CONFIG_BINARY_PRINTF is not set
 
