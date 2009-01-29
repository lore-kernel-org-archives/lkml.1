Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbZA2XQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbZA2XQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZA2XQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:16:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:43492 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbZA2XQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:16:20 -0500
Message-ID: <49823866.5060008@kernel.org>
Date: Thu, 29 Jan 2009 15:14:46 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: allow 8 more cpus could be used
References: <49822B1D.9070708@kernel.org> <20090129224236.GD1465@elte.hu> <4982315F.20705@kernel.org> <20090129230827.GA29611@elte.hu>
In-Reply-To: <20090129230827.GA29611@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Ingo Molnar wrote:
>>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>> Impact: fix left out MARCO
>>>>
>>>> X86_PC will be always enabled. so need to check if we have bigsmp 
>>>> support built in before cut off more than 8 cpus.
>>> ah, that's a leftover reference to X86_PC. It can now be removed, together 
>>> with the Kconfig X86_PC option.
>>>
>>>> -#if defined(CONFIG_X86_PC) && defined(CONFIG_X86_32)
>>>> +#if defined(CONFIG_X86_PC) && !defined(CONFIG_X86_BIGSMP)
>>>>  	if (def_to_bigsmp && nr_cpu_ids > 8) {
>>>>  		unsigned int cpu;
>>>>  		unsigned nr;
>>> Could you please send a patch that removes both X86_PC and X86_BIGSMP - 
>>> and removes the above cutoff code too, so that it will be built-in all the 
>>> time?
>> sure. maybe we could keep X86_BIGSMP for a while. So someone don't 
>> enable BIGSMP for small system?
> 
> yeah, we can certainly keep it - the code to conditionalize it is there 
> and isnt causing problems really.

it seems X86_PC will always to 'y'

we may remove it, just use x86 to replace it etc.

[PATCH] x86: remove X86_PC macro

Impact: fix cutoff and remove left over MACRO

X86_PC is default, so don't need it any more.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 861dcc3..7f81f68 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -262,9 +262,6 @@ config X86_MPPARSE
 	  For old smp systems that do not have proper acpi support. Newer systems
 	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
 
-config X86_PC
-	def_bool y
-
 config X86_NON_STANDARD
 	bool "Support for non-standard x86 platforms"
 	help
@@ -1020,7 +1017,6 @@ config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
 	depends on SMP
 	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)
-	default n if X86_PC
 	default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
 	help
 	  Enable NUMA (Non Uniform Memory Access) support.
@@ -1123,7 +1119,7 @@ config ARCH_SPARSEMEM_DEFAULT
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_PC) || X86_32_NON_STANDARD
+	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_32) || X86_32_NON_STANDARD
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index edba00d..739bce9 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -188,7 +188,6 @@ CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_SMP=y
 CONFIG_X86_FIND_SMP_CONFIG=y
 CONFIG_X86_MPPARSE=y
-CONFIG_X86_PC=y
 # CONFIG_X86_ELAN is not set
 # CONFIG_X86_VOYAGER is not set
 # CONFIG_X86_GENERICARCH is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 322dd27..02b514e 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -187,7 +187,6 @@ CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_SMP=y
 CONFIG_X86_FIND_SMP_CONFIG=y
 CONFIG_X86_MPPARSE=y
-CONFIG_X86_PC=y
 # CONFIG_X86_ELAN is not set
 # CONFIG_X86_VOYAGER is not set
 # CONFIG_X86_GENERICARCH is not set
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index fc80bc1..2912fa3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1000,7 +1000,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 {
 	preempt_disable();
 
-#if defined(CONFIG_X86_PC) && defined(CONFIG_X86_32)
+#ifndef CONFIG_X86_BIGSMP
 	if (def_to_bigsmp && nr_cpu_ids > 8) {
 		unsigned int cpu;
 		unsigned nr;
diff --git a/drivers/eisa/Kconfig b/drivers/eisa/Kconfig
index c064657..2705284 100644
--- a/drivers/eisa/Kconfig
+++ b/drivers/eisa/Kconfig
@@ -3,7 +3,7 @@
 #
 config EISA_VLB_PRIMING
 	bool "Vesa Local Bus priming"
-	depends on X86_PC && EISA
+	depends on X86 && EISA
 	default n
 	---help---
 	  Activate this option if your system contains a Vesa Local
@@ -24,11 +24,11 @@ config EISA_PCI_EISA
 	  When in doubt, say Y.
 
 # Using EISA_VIRTUAL_ROOT on something other than an Alpha or
-# an X86_PC may lead to crashes...
+# an X86 may lead to crashes...
 
 config EISA_VIRTUAL_ROOT
 	bool "EISA virtual root device"
-	depends on EISA && (ALPHA || X86_PC)
+	depends on EISA && (ALPHA || X86)
 	default y
 	---help---
 	  Activate this option if your system only have EISA bus
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 3556168..ea2638b 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -13,11 +13,11 @@ menuconfig INPUT_KEYBOARD
 if INPUT_KEYBOARD
 
 config KEYBOARD_ATKBD
-	tristate "AT keyboard" if EMBEDDED || !X86_PC
+	tristate "AT keyboard" if EMBEDDED || !X86
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86_PC
+	select SERIO_I8042 if X86
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you want to use a standard AT or PS/2 keyboard. Usually
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index 093c8c1..9bef935 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -17,7 +17,7 @@ config MOUSE_PS2
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86_PC
+	select SERIO_I8042 if X86
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you have a PS/2 mouse connected to your system. This
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 9289236..2ff8879 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -273,7 +273,7 @@ config MTD_NAND_CAFE
 
 config MTD_NAND_CS553X
 	tristate "NAND support for CS5535/CS5536 (AMD Geode companion chip)"
-	depends on X86_32 && (X86_PC || X86_32_NON_STANDARD)
+	depends on X86_32
 	help
 	  The CS553x companion chips for the AMD Geode processor
 	  include NAND flash controllers with built-in hardware ECC
diff --git a/sound/drivers/Kconfig b/sound/drivers/Kconfig
index 99cc41a..491e0d7 100644
--- a/sound/drivers/Kconfig
+++ b/sound/drivers/Kconfig
@@ -33,7 +33,7 @@ if SND_DRIVERS
 
 config SND_PCSP
 	tristate "PC-Speaker support (READ HELP!)"
-	depends on PCSPKR_PLATFORM && X86_PC && HIGH_RES_TIMERS
+	depends on PCSPKR_PLATFORM && X86 && HIGH_RES_TIMERS
 	depends on INPUT
 	depends on EXPERIMENTAL
 	select SND_PCM
