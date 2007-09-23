Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbXIWTT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbXIWTT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 15:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbXIWTTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 15:19:50 -0400
Received: from echo.digadd.de ([195.47.195.234]:39988 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750829AbXIWTTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 15:19:49 -0400
Message-ID: <46F6BC10.1030305@digadd.de>
Date: Sun, 23 Sep 2007 22:18:40 +0300
From: "Christian P. Schmidt" <charlie@digadd.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>
Subject: Re: Memory allocation problem with 2.6.22 after suspend/resume cycle
References: <46F53793.3020102@digadd.de> <200709231503.47727.rjw@sisk.pl> <46F69224.2020003@digadd.de> <200709232028.05423.rjw@sisk.pl>
In-Reply-To: <200709232028.05423.rjw@sisk.pl>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------060602060709050909090509"
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060602060709050909090509
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Rafael J. Wysocki wrote:
> On Sunday, 23 September 2007 18:19, Christian P. Schmidt wrote:
>> Rafael J. Wysocki wrote:
>>> On Sunday, 23 September 2007 14:38, Christian P. Schmidt wrote:
>>>> Rafael J. Wysocki wrote:
>>>>> On Saturday, 22 September 2007 17:41, Christian P. Schmidt wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> I'm having a strange problem, of course not reproducible. Sometimes
>>>>>> after a suspend (to ram) and resume cycle, the kernel will try to free
>>>>>> all memory. This means, all running applications are flushed to swap (as
>>>>>> long as it is available), caches and buffers stay at around 15MB each.
>>>>>>
>>>>>> The following video (traded quality for bandwidth) shows what happens on
>>>>>> the way from no swap to "swapon -a" (that's the unreadable thing in the
>>>>>> small shell): http://digadd.de/swapping.avi
>>>>>>
>>>>>> The system:
>>>>>> Linux dnnote 2.6.22.5 #1 SMP PREEMPT Sat Aug 25 18:39:21 AST 2007 x86_64
>>>>>> Intel(R) Core(TM)2 CPU T7400 @ 2.16GHz GenuineIntel GNU/Linux
>>>>> Are you using an ATI binary graphics driver?
>>>> Yes. I do not (yet) have a choice... can't wait for the open source drivers.
>>> That, most probably, is the source of the problem.  Please see:
>>> http://bugzilla.kernel.org/show_bug.cgi?id=8943
>> I do however not agree with Andrew's conclusion, as the memory is not
>> "used", so I wouldn't expect a memory leak. As soon as I turn swapping
>> off everything is loaded again, and works. If there was a leak it should
>> use the memory, shouldn't it?
>> If the problem would be 100% reproducible I could try without, but as
>> is, I have up to two weeks with 2-3 cycles daily (sometimes more, as I
>> receive untraceable SERR from my PCI-E WLAN after which I do not receive
>> interrupts any more - only a suspend/resume cycle helps...) before the
>> problem occurs.
>>
>> Anyway, is there a way of unloading the module temporarily without
>> shutting X down?
> 
> I don't know.
> 
> Can you try another version of the ATI driver?  The reporter of this bugzilla
> entry did that and it apparently helped him:
> http://bugzilla.kernel.org/show_bug.cgi?id=8943#c4

That driver is even more broken, produces artifacts all over the place.
I'll rather wait for the open source work to be done and live with the
situation.

>>>>>> A 32bit Kernel is unable to suspend/resume at all. No idea why. dmesg
>>>>>> shows nothing, logs show nothing. Any ideas for debugging are welcome.
>>>>> Well, that's interesting.
>>>>>
>>>>> Can you try in the minimal configuration (ie. boot with init=/bin/bash,
>>>>> mount /sys, mount /proc and run "echo mem > /sys/power/disk)?
>>>> Which? the 32bit or the 64bit?
>>> 32-bit, but please do that without the ATI driver.
>> Did it. As before, suspends, but when I resume, I hear the CD-ROM spin
>> up, the backlight comes on, and nothing more. The system is a Lenovo
>> Thinkpad T60 8744-4XG, BIOS 1.09.
> 
> Are you 100% sure that your 32-bit kernel configuration reflects the 64-bit
> one?  In particular, do you have CONFIG_NO_HZ set in the 32-bit .config?

In both, not. 1000Hz timer, SMP support, hotplug CPU support are
enabled. I attached a diff (from the 64bit to the 32bit). Maybe I'm
missing something.

> Also, would you be able to repeat this test with the latest -git kernel
> (currently 2.6.23-rc7-git4)?

Not that I'd really care about the 32bit support, but someone else will.
Also, the 32bit version has problems with the SATA DVD-RW; it hangs for
several seconds resetting the port (same kernel version, both 2.6.22.5),
while the 64bit hasn't. Funny ;)
Sadly, I know that 2.6.23 breaks/will break all the external modules I
rely on. Anyway, I'll give it a shot later.

Regards,
Chris

> Greetings,
> Rafael


--------------060602060709050909090509
Content-Type: text/plain;
 name="config.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="config.diff"

--- /boot/config-2.6.22.5	2007-08-25 18:39:30.000000000 +0300
+++ config-2.6.22.5	2007-09-23 16:34:33.000000000 +0300
@@ -1,33 +1,26 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.22.5
-# Sat Aug 25 18:35:55 2007
+# Mon Sep  3 15:45:00 2007
 #
-CONFIG_X86_64=y
-CONFIG_64BIT=y
-CONFIG_X86=y
+CONFIG_X86_32=y
 CONFIG_GENERIC_TIME=y
-CONFIG_GENERIC_TIME_VSYSCALL=y
-CONFIG_ZONE_DMA32=y
+CONFIG_CLOCKSOURCE_WATCHDOG=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
 CONFIG_LOCKDEP_SUPPORT=y
 CONFIG_STACKTRACE_SUPPORT=y
 CONFIG_SEMAPHORE_SLEEPERS=y
+CONFIG_X86=y
 CONFIG_MMU=y
 CONFIG_ZONE_DMA=y
-CONFIG_RWSEM_GENERIC_SPINLOCK=y
-CONFIG_GENERIC_HWEIGHT=y
-CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_X86_CMPXCHG=y
-CONFIG_EARLY_PRINTK=y
+CONFIG_QUICKLIST=y
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_IOMAP=y
+CONFIG_GENERIC_BUG=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_ARCH_MAY_HAVE_PC_FDC=y
-CONFIG_ARCH_POPULATES_NODE_MAP=y
 CONFIG_DMI=y
-CONFIG_AUDIT_ARCH=y
-CONFIG_GENERIC_BUG=y
-# CONFIG_ARCH_HAS_ILOG2_U32 is not set
-# CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
@@ -102,7 +95,9 @@
 # Block layer
 #
 CONFIG_BLOCK=y
+# CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
 
 #
 # IO Schedulers
@@ -120,77 +115,135 @@
 #
 # Processor type and features
 #
+CONFIG_TICK_ONESHOT=y
+# CONFIG_NO_HZ is not set
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_SMP=y
 CONFIG_X86_PC=y
-# CONFIG_X86_VSMP is not set
-# CONFIG_MK8 is not set
-# CONFIG_MPSC is not set
+# CONFIG_X86_ELAN is not set
+# CONFIG_X86_VOYAGER is not set
+# CONFIG_X86_NUMAQ is not set
+# CONFIG_X86_SUMMIT is not set
+# CONFIG_X86_BIGSMP is not set
+# CONFIG_X86_VISWS is not set
+# CONFIG_X86_GENERICARCH is not set
+# CONFIG_X86_ES7000 is not set
+# CONFIG_PARAVIRT is not set
+# CONFIG_M386 is not set
+# CONFIG_M486 is not set
+# CONFIG_M586 is not set
+# CONFIG_M586TSC is not set
+# CONFIG_M586MMX is not set
+# CONFIG_M686 is not set
+# CONFIG_MPENTIUMII is not set
+# CONFIG_MPENTIUMIII is not set
+# CONFIG_MPENTIUMM is not set
 CONFIG_MCORE2=y
-# CONFIG_GENERIC_CPU is not set
-CONFIG_X86_L1_CACHE_BYTES=64
+# CONFIG_MPENTIUM4 is not set
+# CONFIG_MK6 is not set
+# CONFIG_MK7 is not set
+# CONFIG_MK8 is not set
+# CONFIG_MCRUSOE is not set
+# CONFIG_MEFFICEON is not set
+# CONFIG_MWINCHIPC6 is not set
+# CONFIG_MWINCHIP2 is not set
+# CONFIG_MWINCHIP3D is not set
+# CONFIG_MGEODEGX1 is not set
+# CONFIG_MGEODE_LX is not set
+# CONFIG_MCYRIXIII is not set
+# CONFIG_MVIAC3_2 is not set
+# CONFIG_MVIAC7 is not set
+# CONFIG_X86_GENERIC is not set
+CONFIG_X86_CMPXCHG=y
 CONFIG_X86_L1_CACHE_SHIFT=6
-CONFIG_X86_INTERNODE_CACHE_BYTES=64
-CONFIG_X86_TSC=y
+CONFIG_X86_XADD=y
+CONFIG_RWSEM_XCHGADD_ALGORITHM=y
+# CONFIG_ARCH_HAS_ILOG2_U32 is not set
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_X86_WP_WORKS_OK=y
+CONFIG_X86_INVLPG=y
+CONFIG_X86_BSWAP=y
+CONFIG_X86_POPAD_OK=y
 CONFIG_X86_GOOD_APIC=y
-# CONFIG_MICROCODE is not set
-CONFIG_X86_MSR=y
-CONFIG_X86_CPUID=y
-CONFIG_X86_HT=y
-CONFIG_X86_IO_APIC=y
-CONFIG_X86_LOCAL_APIC=y
-CONFIG_MTRR=y
-CONFIG_SMP=y
+CONFIG_X86_INTEL_USERCOPY=y
+CONFIG_X86_USE_PPRO_CHECKSUM=y
+CONFIG_X86_TSC=y
+CONFIG_X86_MINIMUM_CPU_MODEL=4
+CONFIG_HPET_TIMER=y
+CONFIG_HPET_EMULATE_RTC=y
+CONFIG_NR_CPUS=2
 CONFIG_SCHED_SMT=y
 CONFIG_SCHED_MC=y
 # CONFIG_PREEMPT_NONE is not set
 # CONFIG_PREEMPT_VOLUNTARY is not set
 CONFIG_PREEMPT=y
 CONFIG_PREEMPT_BKL=y
-# CONFIG_NUMA is not set
-CONFIG_ARCH_SPARSEMEM_ENABLE=y
+CONFIG_X86_LOCAL_APIC=y
+CONFIG_X86_IO_APIC=y
+CONFIG_X86_MCE=y
+CONFIG_X86_MCE_NONFATAL=y
+CONFIG_X86_MCE_P4THERMAL=y
+CONFIG_VM86=y
+# CONFIG_TOSHIBA is not set
+# CONFIG_I8K is not set
+# CONFIG_X86_REBOOTFIXUPS is not set
+CONFIG_MICROCODE=y
+CONFIG_MICROCODE_OLD_INTERFACE=y
+CONFIG_X86_MSR=y
+CONFIG_X86_CPUID=y
+
+#
+# Firmware Drivers
+#
+# CONFIG_EDD is not set
+# CONFIG_DELL_RBU is not set
+# CONFIG_DCDBAS is not set
+# CONFIG_NOHIGHMEM is not set
+CONFIG_HIGHMEM4G=y
+# CONFIG_HIGHMEM64G is not set
+CONFIG_PAGE_OFFSET=0xC0000000
+CONFIG_HIGHMEM=y
 CONFIG_ARCH_FLATMEM_ENABLE=y
+CONFIG_ARCH_SPARSEMEM_ENABLE=y
+CONFIG_ARCH_SELECT_MEMORY_MODEL=y
+CONFIG_ARCH_POPULATES_NODE_MAP=y
 CONFIG_SELECT_MEMORY_MODEL=y
 CONFIG_FLATMEM_MANUAL=y
 # CONFIG_DISCONTIGMEM_MANUAL is not set
 # CONFIG_SPARSEMEM_MANUAL is not set
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
-# CONFIG_SPARSEMEM_STATIC is not set
+CONFIG_SPARSEMEM_STATIC=y
 CONFIG_SPLIT_PTLOCK_CPUS=4
 CONFIG_RESOURCES_64BIT=y
 CONFIG_ZONE_DMA_FLAG=1
-CONFIG_NR_CPUS=2
-CONFIG_HOTPLUG_CPU=y
-CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
-CONFIG_HPET_TIMER=y
-CONFIG_HPET_EMULATE_RTC=y
-CONFIG_IOMMU=y
-# CONFIG_CALGARY_IOMMU is not set
-CONFIG_SWIOTLB=y
-CONFIG_X86_MCE=y
-CONFIG_X86_MCE_INTEL=y
-# CONFIG_X86_MCE_AMD is not set
-# CONFIG_KEXEC is not set
-# CONFIG_CRASH_DUMP is not set
-# CONFIG_RELOCATABLE is not set
-CONFIG_PHYSICAL_START=0x200000
+CONFIG_NR_QUICK=1
+# CONFIG_HIGHPTE is not set
+# CONFIG_MATH_EMULATION is not set
+CONFIG_MTRR=y
+# CONFIG_EFI is not set
+CONFIG_IRQBALANCE=y
 CONFIG_SECCOMP=y
-# CONFIG_CC_STACKPROTECTOR is not set
 # CONFIG_HZ_100 is not set
 # CONFIG_HZ_250 is not set
 # CONFIG_HZ_300 is not set
 CONFIG_HZ_1000=y
 CONFIG_HZ=1000
-CONFIG_K8_NB=y
-CONFIG_GENERIC_HARDIRQS=y
-CONFIG_GENERIC_IRQ_PROBE=y
-CONFIG_ISA_DMA_API=y
-CONFIG_GENERIC_PENDING_IRQ=y
+# CONFIG_KEXEC is not set
+# CONFIG_CRASH_DUMP is not set
+CONFIG_PHYSICAL_START=0x100000
+# CONFIG_RELOCATABLE is not set
+CONFIG_PHYSICAL_ALIGN=0x100000
+CONFIG_HOTPLUG_CPU=y
+# CONFIG_COMPAT_VDSO is not set
+CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
 
 #
-# Power management options
+# Power management options (ACPI, APM)
 #
 CONFIG_PM=y
-CONFIG_PM_LEGACY=y
+# CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
 # CONFIG_PM_SYSFS_DEPRECATED is not set
 # CONFIG_SOFTWARE_SUSPEND is not set
@@ -208,8 +261,9 @@
 CONFIG_ACPI_BATTERY=y
 CONFIG_ACPI_BUTTON=y
 CONFIG_ACPI_VIDEO=y
-# CONFIG_ACPI_FAN is not set
-# CONFIG_ACPI_DOCK is not set
+CONFIG_ACPI_FAN=y
+CONFIG_ACPI_DOCK=y
+CONFIG_ACPI_BAY=y
 CONFIG_ACPI_PROCESSOR=y
 CONFIG_ACPI_HOTPLUG_CPU=y
 CONFIG_ACPI_THERMAL=y
@@ -223,6 +277,7 @@
 CONFIG_X86_PM_TIMER=y
 CONFIG_ACPI_CONTAINER=y
 # CONFIG_ACPI_SBS is not set
+# CONFIG_APM is not set
 
 #
 # CPU Frequency scaling
@@ -243,20 +298,35 @@
 #
 # CPUFreq processor drivers
 #
+CONFIG_X86_ACPI_CPUFREQ=y
+# CONFIG_X86_POWERNOW_K6 is not set
+# CONFIG_X86_POWERNOW_K7 is not set
 # CONFIG_X86_POWERNOW_K8 is not set
+# CONFIG_X86_GX_SUSPMOD is not set
 # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
-CONFIG_X86_ACPI_CPUFREQ=y
+# CONFIG_X86_SPEEDSTEP_ICH is not set
+# CONFIG_X86_SPEEDSTEP_SMI is not set
+# CONFIG_X86_P4_CLOCKMOD is not set
+# CONFIG_X86_CPUFREQ_NFORCE2 is not set
+# CONFIG_X86_LONGRUN is not set
+# CONFIG_X86_LONGHAUL is not set
+# CONFIG_X86_E_POWERSAVER is not set
 
 #
 # shared options
 #
-CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
+# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
 # CONFIG_X86_SPEEDSTEP_LIB is not set
 
 #
-# Bus options (PCI etc.)
+# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
 CONFIG_PCI=y
+# CONFIG_PCI_GOBIOS is not set
+# CONFIG_PCI_GOMMCONFIG is not set
+# CONFIG_PCI_GODIRECT is not set
+CONFIG_PCI_GOANY=y
+CONFIG_PCI_BIOS=y
 CONFIG_PCI_DIRECT=y
 CONFIG_PCI_MMCONFIG=y
 CONFIG_PCIEPORTBUS=y
@@ -265,6 +335,10 @@
 CONFIG_PCI_MSI=y
 CONFIG_PCI_DEBUG=y
 # CONFIG_HT_IRQ is not set
+CONFIG_ISA_DMA_API=y
+# CONFIG_ISA is not set
+# CONFIG_MCA is not set
+# CONFIG_SCx200 is not set
 
 #
 # PCCARD (PCMCIA/CardBus) support
@@ -291,14 +365,11 @@
 # CONFIG_HOTPLUG_PCI is not set
 
 #
-# Executable file formats / Emulations
+# Executable file formats
 #
 CONFIG_BINFMT_ELF=y
+# CONFIG_BINFMT_AOUT is not set
 # CONFIG_BINFMT_MISC is not set
-CONFIG_IA32_EMULATION=y
-CONFIG_IA32_AOUT=y
-CONFIG_COMPAT=y
-CONFIG_SYSVIPC_COMPAT=y
 
 #
 # Networking
@@ -546,6 +617,7 @@
 # CONFIG_SIGMATEL_FIR is not set
 CONFIG_NSC_FIR=m
 # CONFIG_WINBOND_FIR is not set
+# CONFIG_TOSHIBA_FIR is not set
 # CONFIG_SMC_IRCC_FIR is not set
 # CONFIG_ALI_FIR is not set
 # CONFIG_VLSI_FIR is not set
@@ -654,7 +726,6 @@
 # CONFIG_SONY_LAPTOP is not set
 CONFIG_THINKPAD_ACPI=m
 CONFIG_THINKPAD_ACPI_DEBUG=y
-CONFIG_THINKPAD_ACPI_DOCK=y
 CONFIG_THINKPAD_ACPI_BAY=y
 CONFIG_IDE=y
 CONFIG_BLK_DEV_IDE=y
@@ -738,6 +809,8 @@
 # CONFIG_SCSI_AIC7XXX_OLD is not set
 # CONFIG_SCSI_AIC79XX is not set
 # CONFIG_SCSI_AIC94XX is not set
+# CONFIG_SCSI_DPT_I2O is not set
+# CONFIG_SCSI_ADVANSYS is not set
 # CONFIG_SCSI_ARCMSR is not set
 # CONFIG_MEGARAID_NEWGEN is not set
 # CONFIG_MEGARAID_LEGACY is not set
@@ -760,13 +833,16 @@
 # CONFIG_SCSI_LPFC is not set
 # CONFIG_SCSI_DC395x is not set
 # CONFIG_SCSI_DC390T is not set
+# CONFIG_SCSI_NSP32 is not set
 # CONFIG_SCSI_DEBUG is not set
 # CONFIG_SCSI_SRP is not set
 
 #
 # PCMCIA SCSI adapter support
 #
+# CONFIG_PCMCIA_AHA152X is not set
 # CONFIG_PCMCIA_FDOMAIN is not set
+# CONFIG_PCMCIA_NINJA_SCSI is not set
 # CONFIG_PCMCIA_QLOGIC is not set
 # CONFIG_PCMCIA_SYM53C500 is not set
 CONFIG_ATA=y
@@ -796,6 +872,7 @@
 # CONFIG_PATA_CMD64X is not set
 # CONFIG_PATA_CS5520 is not set
 # CONFIG_PATA_CS5530 is not set
+# CONFIG_PATA_CS5535 is not set
 # CONFIG_PATA_CYPRESS is not set
 # CONFIG_PATA_EFAR is not set
 # CONFIG_ATA_GENERIC is not set
@@ -1011,6 +1088,7 @@
 # CONFIG_INPUT_TOUCHSCREEN is not set
 CONFIG_INPUT_MISC=y
 # CONFIG_INPUT_PCSPKR is not set
+# CONFIG_INPUT_WISTRON_BTNS is not set
 # CONFIG_INPUT_ATLAS_BTNS is not set
 # CONFIG_INPUT_ATI_REMOTE is not set
 # CONFIG_INPUT_ATI_REMOTE2 is not set
@@ -1073,11 +1151,18 @@
 CONFIG_RTC=y
 # CONFIG_R3964 is not set
 # CONFIG_APPLICOM is not set
+# CONFIG_SONYPI is not set
 CONFIG_AGP=y
-CONFIG_AGP_AMD64=y
+# CONFIG_AGP_ALI is not set
+# CONFIG_AGP_ATI is not set
+# CONFIG_AGP_AMD is not set
+# CONFIG_AGP_AMD64 is not set
 # CONFIG_AGP_INTEL is not set
+# CONFIG_AGP_NVIDIA is not set
 # CONFIG_AGP_SIS is not set
+# CONFIG_AGP_SWORKS is not set
 # CONFIG_AGP_VIA is not set
+# CONFIG_AGP_EFFICEON is not set
 # CONFIG_DRM is not set
 
 #
@@ -1088,20 +1173,22 @@
 # CONFIG_CARDMAN_4040 is not set
 # CONFIG_MWAVE is not set
 # CONFIG_PC8736x_GPIO is not set
+# CONFIG_NSC_GPIO is not set
+# CONFIG_CS5535_GPIO is not set
 # CONFIG_RAW_DRIVER is not set
 CONFIG_HPET=y
 # CONFIG_HPET_RTC_IRQ is not set
 CONFIG_HPET_MMAP=y
-# CONFIG_HANGCHECK_TIMER is not set
+CONFIG_HANGCHECK_TIMER=y
 
 #
 # TPM devices
 #
-CONFIG_TCG_TPM=m
-CONFIG_TCG_TIS=m
-CONFIG_TCG_NSC=m
-CONFIG_TCG_ATMEL=m
-CONFIG_TCG_INFINEON=m
+CONFIG_TCG_TPM=y
+CONFIG_TCG_TIS=y
+CONFIG_TCG_NSC=y
+CONFIG_TCG_ATMEL=y
+CONFIG_TCG_INFINEON=y
 # CONFIG_TELCLOCK is not set
 CONFIG_DEVPORT=y
 CONFIG_I2C=y
@@ -1132,6 +1219,7 @@
 # CONFIG_I2C_PROSAVAGE is not set
 # CONFIG_I2C_SAVAGE4 is not set
 # CONFIG_I2C_SIMTEC is not set
+# CONFIG_SCx200_ACB is not set
 # CONFIG_I2C_SIS5595 is not set
 # CONFIG_I2C_SIS630 is not set
 # CONFIG_I2C_SIS96X is not set
@@ -1307,6 +1395,7 @@
 # CONFIG_SND_CMIPCI is not set
 # CONFIG_SND_CS4281 is not set
 # CONFIG_SND_CS46XX is not set
+# CONFIG_SND_CS5535AUDIO is not set
 # CONFIG_SND_DARLA20 is not set
 # CONFIG_SND_GINA20 is not set
 # CONFIG_SND_LAYLA20 is not set
@@ -1575,14 +1664,9 @@
 #
 # Virtualization
 #
-# CONFIG_KVM is not set
-
-#
-# Firmware Drivers
-#
-# CONFIG_EDD is not set
-# CONFIG_DELL_RBU is not set
-# CONFIG_DCDBAS is not set
+CONFIG_KVM=y
+CONFIG_KVM_INTEL=y
+# CONFIG_KVM_AMD is not set
 
 #
 # File systems
@@ -1794,6 +1878,7 @@
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
+# CONFIG_DEBUG_HIGHMEM is not set
 CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
@@ -1802,10 +1887,14 @@
 # CONFIG_FORCED_INLINING is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
-# CONFIG_DEBUG_RODATA is not set
-# CONFIG_IOMMU_DEBUG is not set
+CONFIG_EARLY_PRINTK=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 # CONFIG_DEBUG_STACK_USAGE is not set
+# CONFIG_DEBUG_RODATA is not set
+# CONFIG_4KSTACKS is not set
+CONFIG_X86_FIND_SMP_CONFIG=y
+CONFIG_X86_MPPARSE=y
+CONFIG_DOUBLEFAULT=y
 
 #
 # Security options
@@ -1826,7 +1915,7 @@
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_MD4 is not set
 CONFIG_CRYPTO_MD5=y
-CONFIG_CRYPTO_SHA1=m
+CONFIG_CRYPTO_SHA1=y
 CONFIG_CRYPTO_SHA256=y
 CONFIG_CRYPTO_SHA512=y
 # CONFIG_CRYPTO_WP512 is not set
@@ -1842,14 +1931,14 @@
 CONFIG_CRYPTO_BLOWFISH=y
 # CONFIG_CRYPTO_TWOFISH is not set
 CONFIG_CRYPTO_TWOFISH_COMMON=y
-CONFIG_CRYPTO_TWOFISH_X86_64=y
+CONFIG_CRYPTO_TWOFISH_586=y
 # CONFIG_CRYPTO_SERPENT is not set
 # CONFIG_CRYPTO_AES is not set
-CONFIG_CRYPTO_AES_X86_64=y
+CONFIG_CRYPTO_AES_586=y
 # CONFIG_CRYPTO_CAST5 is not set
 # CONFIG_CRYPTO_CAST6 is not set
 # CONFIG_CRYPTO_TEA is not set
-CONFIG_CRYPTO_ARC4=m
+CONFIG_CRYPTO_ARC4=y
 # CONFIG_CRYPTO_KHAZAD is not set
 # CONFIG_CRYPTO_ANUBIS is not set
 # CONFIG_CRYPTO_DEFLATE is not set
@@ -1861,6 +1950,8 @@
 #
 # Hardware crypto devices
 #
+# CONFIG_CRYPTO_DEV_PADLOCK is not set
+# CONFIG_CRYPTO_DEV_GEODE is not set
 
 #
 # Library routines
@@ -1877,3 +1968,11 @@
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_GENERIC_PENDING_IRQ=y
+CONFIG_X86_SMP=y
+CONFIG_X86_HT=y
+CONFIG_X86_BIOS_REBOOT=y
+CONFIG_X86_TRAMPOLINE=y
+CONFIG_KTIME_SCALAR=y

--------------060602060709050909090509--
