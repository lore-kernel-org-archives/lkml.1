Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbXHXUXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbXHXUXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 16:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbXHXUXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 16:23:31 -0400
Received: from main.gmane.org ([80.91.229.2]:33909 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbXHXUXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 16:23:30 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: CFS + Rhythmbox audio skipping
Date: Fri, 24 Aug 2007 20:23:16 +0000 (UTC)
Message-ID: <pan.2007.08.24.20.23.15@telenet.be>
References: <pan.2007.08.24.12.15.32@telenet.be>
	<20070824145743.GA24701@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: d54c1e7e8.access.telenet.be
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 16:57:43 +0200, Ingo Molnar wrote:

> * Frederik Himpe <fhimpe@telenet.be> wrote:
> 
>> Some time ago, it was already discussed here that Rhythmbox would
>> easily cause audio skipping when running with the CFS scheduler
>> (http:// bhhdoa.org.au/pipermail/ck/2007-June/007886.html). It was said
>> to be a Rhythmbox problem, for which someone needed to open a bug
>> report. Well, I just did this, but the developer says he cannot
>> reproduce this, and denies that Rhythmbox is making any X calls in its
>> audio playback thread, so this bug is blocked for the moment.
>> 
>> http://bugzilla.gnome.org/show_bug.cgi?id=467437
>> 
>> It seems that there are people who know better what is wrong exactly.
>> Can somebody give some more details about what Rhythmbox is doing
>> wrong, either here, either in the bug ticket?
> 
> could you first check whether CFS v20.3:
> 
>    http://people.redhat.com/mingo/cfs-scheduler/
> 
> is it still showing the same symptoms with rhythmbox? If yes, what kind
> of load of yours is typically causing the Rhythmbox skipping? x11perf?

Thanks for the hint.

2.6.22.5 with CFS v20.3 does not skip anymore. It was skipping when 
turning the desktop cube in compiz, or (without compiz) when scrolling in 
the output of less in a full-screen pseudo-transparant gnome-terminal, or 
when rapidly scrolling with Firefox in http://phoenity.com/newtedge/ (test 
case from the previous thread).

Now the kernel which I'm using normally, also had the high resolution 
timers patch for x86_64 applied. I tried applying it again to the current 
kernel, but it seems it has conflicts with current CFS so I could not test 
that. Could this feature cause audio skipping?

I'm attaching a full diff of 2.6.22.5-CFSv20.3 and my other kernel where I 
had this skipping:
--- .config     2007-08-24 21:38:56.420571574 +0200
+++ /boot/config-2.6.22.5-tmb-desktop-1mdv      2007-08-24 
01:28:35.000000000 +0200
@@ -1,13 +1,17 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.5
-# Fri Aug 24 20:42:08 2007
+# Linux kernel version: 2.6.22.5-tmb-desktop-1mdv
+# Thu Aug 23 19:05:43 2007
 #
 CONFIG_X86_64=y
 CONFIG_64BIT=y
 CONFIG_X86=y
 CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
+CONFIG_NONIRQ_WAKEUP=y
 CONFIG_GENERIC_TIME_VSYSCALL=y
+CONFIG_GENERIC_CMOS_UPDATE=y
 CONFIG_ZONE_DMA32=y
 CONFIG_LOCKDEP_SUPPORT=y
 CONFIG_STACKTRACE_SUPPORT=y
@@ -43,6 +47,7 @@
 CONFIG_LOCALVERSION=""
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SWAP=y
+CONFIG_SWAP_PREFETCH=y
 CONFIG_SYSVIPC=y
 CONFIG_IPC_NS=y
 CONFIG_SYSVIPC_SYSCTL=y
@@ -122,6 +127,10 @@
 #
 # Processor type and features
 #
+CONFIG_TICK_ONESHOT=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_X86_PC=y
 # CONFIG_X86_VSMP is not set
 # CONFIG_MK8 is not set
@@ -148,6 +157,7 @@
 CONFIG_PREEMPT_VOLUNTARY=y
 # CONFIG_PREEMPT is not set
 CONFIG_PREEMPT_BKL=y
+CONFIG_BADRAM=y
 # CONFIG_NUMA is not set
 CONFIG_ARCH_SPARSEMEM_ENABLE=y
 CONFIG_ARCH_FLATMEM_ENABLE=y
@@ -161,6 +171,7 @@
 CONFIG_SPLIT_PTLOCK_CPUS=4
 CONFIG_RESOURCES_64BIT=y
 CONFIG_ZONE_DMA_FLAG=1
+CONFIG_DYN_PAGEFLAGS=y
 CONFIG_NR_CPUS=32
 CONFIG_HOTPLUG_CPU=y
 CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
@@ -199,6 +210,30 @@
 # CONFIG_PM_SYSFS_DEPRECATED is not set
 CONFIG_SOFTWARE_SUSPEND=y
 CONFIG_PM_STD_PARTITION=""
+CONFIG_SUSPEND2_CORE=m
+
+#
+# Image Storage (you need at least one allocator)
+#
+CONFIG_SUSPEND2_FILE=m
+CONFIG_SUSPEND2_SWAP=m
+
+#
+# General Options
+#
+CONFIG_SUSPEND2_CRYPTO=m
+CONFIG_SUSPEND2_USERUI=m
+# CONFIG_SUSPEND2_KEEP_IMAGE is not set
+# CONFIG_SUSPEND2_REPLACE_SWSUSP is not set
+# CONFIG_SUSPEND2_CHECKSUM is not set
+CONFIG_SUSPEND2_DEFAULT_WAIT=10
+CONFIG_SUSPEND2_USERUI_EXPORTS=y
+CONFIG_SUSPEND2_SWAP_EXPORTS=y
+CONFIG_SUSPEND2_FILE_EXPORTS=y
+CONFIG_SUSPEND2_CRYPTO_EXPORTS=y
+CONFIG_SUSPEND2_CORE_EXPORTS=y
+CONFIG_SUSPEND2_EXPORTS=y
+CONFIG_SUSPEND2=y
 CONFIG_SUSPEND_SMP=y
 
 #
@@ -221,6 +256,7 @@
 CONFIG_ACPI_THERMAL=m
 CONFIG_ACPI_ASUS=m
 CONFIG_ACPI_TOSHIBA=m
+CONFIG_ACPI_CUSTOM_DSDT_INITRD=y
 CONFIG_ACPI_BLACKLIST_YEAR=0
 # CONFIG_ACPI_DEBUG is not set
 CONFIG_ACPI_EC=y
@@ -262,6 +298,17 @@
 CONFIG_X86_SPEEDSTEP_LIB=m
 
 #
+# CPU idle PM support
+#
+CONFIG_CPU_IDLE=y
+
+#
+# Governors
+#
+CONFIG_CPU_IDLE_GOV_LADDER=m
+CONFIG_CPU_IDLE_GOV_MENU=m
+
+#
 # Bus options (PCI etc.)
 #
 CONFIG_PCI=y
@@ -512,6 +559,7 @@
 CONFIG_IP_NF_IPTABLES=m
 CONFIG_IP_NF_MATCH_IPRANGE=m
 CONFIG_IP_NF_MATCH_TOS=m
+CONFIG_IP_NF_MATCH_PSD=m
 CONFIG_IP_NF_MATCH_RECENT=m
 CONFIG_IP_NF_MATCH_ECN=m
 CONFIG_IP_NF_MATCH_AH=m
@@ -542,6 +590,8 @@
 CONFIG_IP_NF_TARGET_ECN=m
 CONFIG_IP_NF_TARGET_TTL=m
 CONFIG_IP_NF_TARGET_CLUSTERIP=m
+CONFIG_IP_NF_TARGET_IFWLOG=m
+# CONFIG_IP_NF_SET is not set
 CONFIG_IP_NF_RAW=m
 CONFIG_IP_NF_ARPTABLES=m
 CONFIG_IP_NF_ARPFILTER=m
@@ -1084,6 +1134,7 @@
 CONFIG_THINKPAD_ACPI=m
 # CONFIG_THINKPAD_ACPI_DEBUG is not set
 CONFIG_THINKPAD_ACPI_BAY=y
+CONFIG_EEPROM_93CX6=m
 CONFIG_IDE=m
 CONFIG_IDE_MAX_HWIFS=4
 CONFIG_BLK_DEV_IDE=m
@@ -1151,6 +1202,7 @@
 CONFIG_BLK_DEV_TRM290=m
 CONFIG_BLK_DEV_VIA82CXXX=m
 CONFIG_BLK_DEV_TC86C001=m
+CONFIG_BLK_DEV_MARVELL=m
 # CONFIG_IDE_ARM is not set
 CONFIG_BLK_DEV_IDEDMA=y
 # CONFIG_IDEDMA_IVB is not set
@@ -1594,6 +1646,42 @@
 # CONFIG_BCM43XX_PIO_MODE is not set
 CONFIG_ZD1211RW=m
 # CONFIG_ZD1211RW_DEBUG is not set
+CONFIG_BCM43XX_MAC80211=m
+CONFIG_BCM43XX_MAC80211_PCI=y
+CONFIG_BCM43XX_MAC80211_PCMCIA=y
+CONFIG_BCM43XX_MAC80211_DEBUG=y
+CONFIG_BCM43XX_MAC80211_DMA=y
+CONFIG_BCM43XX_MAC80211_PIO=y
+CONFIG_BCM43XX_MAC80211_DMA_AND_PIO_MODE=y
+# CONFIG_BCM43XX_MAC80211_DMA_MODE is not set
+# CONFIG_BCM43XX_MAC80211_PIO_MODE is not set
+CONFIG_RT2X00=m
+CONFIG_RT2X00_LIB=m
+CONFIG_RT2X00_LIB_PCI=m
+CONFIG_RT2X00_LIB_USB=m
+CONFIG_RT2X00_LIB_FIRMWARE=y
+CONFIG_RT2X00_LIB_RFKILL=m
+CONFIG_RT2400PCI=m
+CONFIG_RT2400PCI_RFKILL=y
+CONFIG_RT2500PCI=m
+CONFIG_RT2500PCI_RFKILL=y
+CONFIG_RT61PCI=m
+CONFIG_RT61PCI_RFKILL=y
+CONFIG_RT2500USB=m
+CONFIG_RT73USB=m
+# CONFIG_RT2X00_DEBUG is not set
+CONFIG_ADM8211=m
+CONFIG_P54_COMMON=m
+CONFIG_P54_USB=m
+CONFIG_P54_PCI=m
+CONFIG_ZD1211RW_MAC80211=m
+# CONFIG_ZD1211RW_MAC80211_DEBUG is not set
+CONFIG_RTL818X=y
+CONFIG_RTL8187=m
+CONFIG_IWLWIFI=y
+CONFIG_IWLWIFI_DEBUG=y
+CONFIG_IWL4965=m
+CONFIG_IWL3945=m
 
 #
 # USB Network Adapters
@@ -1912,6 +2000,7 @@
 CONFIG_RIO=m
 CONFIG_RIO_OLDPCI=y
 CONFIG_STALDRV=y
+# CONFIG_NOZOMI is not set
 
 #
 # Serial drivers
@@ -2194,6 +2283,16 @@
 # CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
+# Sonics Silicon Backplane
+#
+CONFIG_SSB=m
+CONFIG_SSB_PCIHOST=y
+CONFIG_SSB_PCMCIAHOST=y
+# CONFIG_SSB_SILENT is not set
+CONFIG_SSB_DEBUG=y
+CONFIG_SSB_DRIVER_PCICORE=y
+
+#
 # Multifunction device drivers
 #
 CONFIG_MFD_SM501=m
@@ -3077,6 +3176,7 @@
 CONFIG_EDD=y
 CONFIG_DELL_RBU=m
 CONFIG_DCDBAS=m
+CONFIG_DMIID=y
 
 #
 # File systems
@@ -3099,6 +3199,8 @@
 CONFIG_JBD2=m
 # CONFIG_JBD2_DEBUG is not set
 CONFIG_FS_MBCACHE=y
+CONFIG_REISER4_FS=m
+# CONFIG_REISER4_DEBUG is not set
 CONFIG_REISERFS_FS=m
 # CONFIG_REISERFS_CHECK is not set
 # CONFIG_REISERFS_PROC_INFO is not set
@@ -3171,12 +3273,19 @@
 CONFIG_CONFIGFS_FS=m
 
 #
+# Layered filesystems
+#
+CONFIG_ECRYPT_FS=m
+CONFIG_UNION_FS=m
+# CONFIG_UNION_FS_XATTR is not set
+# CONFIG_UNION_FS_DEBUG is not set
+
+#
 # Miscellaneous filesystems
 #
 CONFIG_ADFS_FS=m
 # CONFIG_ADFS_FS_RW is not set
 CONFIG_AFFS_FS=m
-CONFIG_ECRYPT_FS=m
 CONFIG_HFS_FS=m
 CONFIG_HFSPLUS_FS=m
 CONFIG_BEFS_FS=m
@@ -3195,6 +3304,10 @@
 CONFIG_JFFS2_RTIME=y
 # CONFIG_JFFS2_RUBIN is not set
 CONFIG_CRAMFS=y
+CONFIG_SQUASHFS=m
+# CONFIG_SQUASHFS_EMBEDDED is not set
+CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
+# CONFIG_SQUASHFS_VMALLOC is not set
 CONFIG_VXFS_FS=m
 CONFIG_HPFS_FS=m
 CONFIG_QNX4FS_FS=m
@@ -3345,6 +3458,7 @@
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_SHIRQ is not set
 # CONFIG_DETECT_SOFTLOCKUP is not set
+# CONFIG_SCHED_DEBUG is not set
 # CONFIG_SCHEDSTATS is not set
 CONFIG_TIMER_STATS=y
 # CONFIG_DEBUG_SLAB is not set
@@ -3381,6 +3495,7 @@
 CONFIG_SECURITY_CAPABILITIES=m
 CONFIG_SECURITY_ROOTPLUG=m
 # CONFIG_SECURITY_SELINUX is not set
+CONFIG_SECURITY_APPARMOR=m
 
 #
 # Cryptographic options
@@ -3423,6 +3538,7 @@
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_DEFLATE=m
+CONFIG_CRYPTO_LZF=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_CRC32C=m
 CONFIG_CRYPTO_CAMELLIA=m
@@ -3454,3 +3570,22 @@
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y
+
+#
+# Unofficial 3rd party kernel additions
+#
+CONFIG_NDISWRAPPER=m
+# CONFIG_ACERHK is not set
+CONFIG_ACER_ACPI=m
+CONFIG_QC_USB=m
+CONFIG_IPW3945=m
+# CONFIG_IPW3945_DEBUG is not set
+CONFIG_IPW3945_MONITOR=y
+CONFIG_IPW3945_PROMISCUOUS=y
+CONFIG_IEEE80211_RADIOTAP=y
+# CONFIG_RT2400 is not set
+# CONFIG_RT2500 is not set
+# CONFIG_RT2570 is not set
+# CONFIG_RT61 is not set
+# CONFIG_RT73 is not set
+CONFIG_BLK_DEV_DRBD=m


