Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYH3Jur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYH3Jur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 05:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbYH3Jui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 05:50:38 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:56479 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYH3Juh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 05:50:37 -0400
Message-ID: <48B91790.6000602@hypersurf.com>
Date: Sat, 30 Aug 2008 02:49:04 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] Various arch/powerpc changes to support the 750GX
 cpufreq driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes various changes necessary to support the cpufreq driver for
the PowerPC 750GX. Highlights include adding entries to recognize the 750GX to
the cputable (This includes the ... unfortunate pvr that the 750GX used in the
PowerLogix PowerForce 750GX => 0x0008 0203). The PLL switch in idle_6xx.S
during sleep (or nap) was also removed (I tried to add ability to disable this
but the result would not boot?).

My name is Kevin Diggs and I approve this patch.

Signed-off-by: Kevin Diggs <kevdig@hypersurf.com>


Index: arch/powerpc/kernel/Makefile
===================================================================
--- arch/powerpc/kernel/Makefile.orig	2008-08-13 02:19:18.000000000 -0700
+++ arch/powerpc/kernel/Makefile	2008-08-14 02:50:18.000000000 -0700
@@ -17,6 +17,7 @@ obj-y				:= cputable.o ptrace.o syscalls
  				   init_task.o process.o systbl.o idle.o \
  				   signal.o
  obj-y				+= vdso32/
+obj-y				+= cpu/
  obj-$(CONFIG_PPC64)		+= setup_64.o sys_ppc32.o \
  				   signal_64.o ptrace32.o \
  				   paca.o cpu_setup_ppc970.o \
Index: arch/powerpc/kernel/cputable.c
===================================================================
--- arch/powerpc/kernel/cputable.c.orig	2008-08-13 02:19:19.000000000 -0700
+++ arch/powerpc/kernel/cputable.c	2008-08-14 03:00:51.000000000 -0700
@@ -42,9 +42,11 @@ extern void __setup_cpu_604(unsigned lon
  extern void __setup_cpu_750(unsigned long offset, struct cpu_spec* spec);
  extern void __setup_cpu_750cx(unsigned long offset, struct cpu_spec* spec);
  extern void __setup_cpu_750fx(unsigned long offset, struct cpu_spec* spec);
+extern void __setup_cpu_750gx(unsigned long offset, struct cpu_spec* spec);
  extern void __setup_cpu_7400(unsigned long offset, struct cpu_spec* spec);
  extern void __setup_cpu_7410(unsigned long offset, struct cpu_spec* spec);
  extern void __setup_cpu_745x(unsigned long offset, struct cpu_spec* spec);
+
  #endif /* CONFIG_PPC32 */
  #ifdef CONFIG_PPC64
  extern void __setup_cpu_ppc970(unsigned long offset, struct cpu_spec* spec);
@@ -660,7 +662,7 @@ static struct cpu_spec __initdata cpu_sp
  		.machine_check		= machine_check_generic,
  		.platform		= "ppc750",
  	},
-	{	/* 750GX */
+	{	/* 750GX rev 1.x */
  		.pvr_mask		= 0xffff0000,
  		.pvr_value		= 0x70020000,
  		.cpu_name		= "750GX",
@@ -669,7 +671,33 @@ static struct cpu_spec __initdata cpu_sp
  		.icache_bsize		= 32,
  		.dcache_bsize		= 32,
  		.num_pmcs		= 4,
-		.cpu_setup		= __setup_cpu_750fx,
+		.cpu_setup		= __setup_cpu_750gx,
+		.machine_check		= machine_check_generic,
+		.platform		= "ppc750",
+	},
+	{	/* 750GX (rev 2.3, as used on PowerLogix 750GX upgrade card */
+		.pvr_mask		= 0xffffffff,
+		.pvr_value		= 0x00080203,
+		.cpu_name		= "750GX",
+		.cpu_features		= CPU_FTRS_750GX,
+		.cpu_user_features	= COMMON_USER | PPC_FEATURE_PPC_LE,
+		.icache_bsize		= 32,
+		.dcache_bsize		= 32,
+		.num_pmcs		= 4,
+		.cpu_setup		= __setup_cpu_750gx,
+		.machine_check		= machine_check_generic,
+		.platform		= "ppc750",
+	},
+	{	/* 750GX (All revs >= 2.0) */
+		.pvr_mask		= 0xffffff00,
+		.pvr_value		= 0x70020200,
+		.cpu_name		= "750GX",
+		.cpu_features		= CPU_FTRS_750GX,
+		.cpu_user_features	= COMMON_USER | PPC_FEATURE_PPC_LE,
+		.icache_bsize		= 32,
+		.dcache_bsize		= 32,
+		.num_pmcs		= 4,
+		.cpu_setup		= __setup_cpu_750gx,
  		.machine_check		= machine_check_generic,
  		.platform		= "ppc750",
  	},
Index: arch/powerpc/kernel/cpu_setup_6xx.S
===================================================================
--- arch/powerpc/kernel/cpu_setup_6xx.S.orig	2008-08-13 02:19:19.000000000 -0700
+++ arch/powerpc/kernel/cpu_setup_6xx.S	2008-08-14 02:44:30.000000000 -0700
@@ -53,6 +53,14 @@ _GLOBAL(__setup_cpu_750fx)
  	bl	setup_750fx
  	mtlr	r4
  	blr
+_GLOBAL(__setup_cpu_750gx)
+	mflr	r4
+	bl	__init_fpu_registers
+	bl	setup_common_caches
+	bl	setup_750_7400_hid0
+	bl	setup_750gx
+	mtlr	r4
+	blr
  _GLOBAL(__setup_cpu_7400)
  	mflr	r4
  	bl	__init_fpu_registers
@@ -200,6 +208,11 @@ setup_750cx:
  setup_750fx:
  	blr

+/* 750gx specific
+ */
+setup_750gx:
+	blr
+
  /* MPC 745x
   * Enable Store Gathering (SGE), Branch Folding (FOLD)
   * Branch History Table (BHTE), Branch Target ICache (BTIC)
Index: arch/powerpc/kernel/idle_6xx.S
===================================================================
--- arch/powerpc/kernel/idle_6xx.S.orig	2008-02-25 18:10:30.000000000 -0800
+++ arch/powerpc/kernel/idle_6xx.S	2008-08-14 02:44:30.000000000 -0700
@@ -45,11 +45,6 @@ BEGIN_FTR_SECTION
  	addis	r6,r5, nap_save_msscr0@ha
  	stw	r4,nap_save_msscr0@l(r6)
  END_FTR_SECTION_IFSET(CPU_FTR_NAP_DISABLE_L2_PR)
-BEGIN_FTR_SECTION
-	mfspr	r4,SPRN_HID1
-	addis	r6,r5,nap_save_hid1@ha
-	stw	r4,nap_save_hid1@l(r6)
-END_FTR_SECTION_IFSET(CPU_FTR_DUAL_PLL_750FX)
  	blr

  /*
@@ -107,18 +102,6 @@ BEGIN_FTR_SECTION
  	dcbf	0,r4
  END_FTR_SECTION_IFSET(CPU_FTR_NAP_DISABLE_L2_PR)
  2:
-BEGIN_FTR_SECTION
-	/* Go to low speed mode on some 750FX */
-	lis	r4,powersave_lowspeed@ha
-	lwz	r4,powersave_lowspeed@l(r4)
-	cmpwi	0,r4,0
-	beq	1f
-	mfspr	r4,SPRN_HID1
-	oris	r4,r4,0x0001
-	mtspr	SPRN_HID1,r4
-1:	
-END_FTR_SECTION_IFSET(CPU_FTR_DUAL_PLL_750FX)
-
  	/* Go to NAP or DOZE now */	
  	mfspr	r4,SPRN_HID0
  	lis	r5,(HID0_NAP|HID0_SLEEP)@h
@@ -178,20 +161,9 @@ BEGIN_FTR_SECTION
  	isync
  1:
  END_FTR_SECTION_IFSET(CPU_FTR_NAP_DISABLE_L2_PR)
-BEGIN_FTR_SECTION
-	addis	r9,r11,(nap_save_hid1-KERNELBASE)@ha
-	lwz	r9,nap_save_hid1@l(r9)
-	mtspr	SPRN_HID1, r9
-END_FTR_SECTION_IFSET(CPU_FTR_DUAL_PLL_750FX)
  	b	transfer_to_handler_cont

  	.data

  _GLOBAL(nap_save_msscr0)
  	.space	4*NR_CPUS
-
-_GLOBAL(nap_save_hid1)
-	.space	4*NR_CPUS
-
-_GLOBAL(powersave_lowspeed)
-	.long	0
Index: arch/powerpc/platforms/powermac/feature.c
===================================================================
--- arch/powerpc/platforms/powermac/feature.c.orig	2008-08-13 00:54:02.000000000 -0700
+++ arch/powerpc/platforms/powermac/feature.c	2008-08-14 02:44:30.000000000 -0700
@@ -48,10 +48,6 @@
  #define DBG(fmt...)
  #endif

-#ifdef CONFIG_6xx
-extern int powersave_lowspeed;
-#endif
-
  extern int powersave_nap;
  extern struct device_node *k2_skiplist[2];

@@ -2534,11 +2530,6 @@ found:
  		break;
  	}

-	/* On CPUs that support it (750FX), lowspeed by default during
-	 * NAP mode
-	 */
-	powersave_lowspeed = 1;
-
  #else /* CONFIG_POWER4 */
  	powersave_nap = 1;
  #endif  /* CONFIG_POWER4 */
Index: arch/powerpc/platforms/Kconfig
===================================================================
--- arch/powerpc/platforms/Kconfig.orig	2008-08-13 02:19:26.000000000 -0700
+++ arch/powerpc/platforms/Kconfig	2008-08-14 02:44:30.000000000 -0700
@@ -174,7 +174,7 @@ config GENERIC_IOMAP
  	bool
  	default n

-source "drivers/cpufreq/Kconfig"
+source "arch/powerpc/kernel/cpu/cpufreq/Kconfig"

  menu "CPU Frequency drivers"
  	depends on CPU_FREQ
Index: arch/powerpc/platforms/Kconfig.cputype
===================================================================
--- arch/powerpc/platforms/Kconfig.cputype.orig	2008-08-13 02:19:26.000000000 -0700
+++ arch/powerpc/platforms/Kconfig.cputype	2008-08-14 02:44:30.000000000 -0700
@@ -234,4 +234,34 @@ config NOT_COHERENT_CACHE
  config CHECK_CACHE_COHERENCY
  	bool

+config PPC_750GX_DUAL_PLL_IF
+	tristate 'Add interface for 750GX PLL' if 6xx
+	---help---
+	  This adds code to provide control of the pll config register in IBM
+	  750GX (and FX?). This is also needed by the cpufreq driver for the
+	  750GX. At least one of the interfaces below must be selected.
+
+	  If in doubt, say N here.
+
+config PPC_750GX_DUAL_PLL_IF_HRTIMER
+	bool "Use HRtimer for PLL lock delay"
+	depends on PPC_750GX_DUAL_PLL_IF
+	default n
+	help
+	  Uses HRtimers for lower latency on PLL locks.
+
+config PPC_750GX_DUAL_PLL_IF_CPU_FREQ
+	bool "Include CPUFreq interface"
+	depends on PPC_750GX_DUAL_PLL_IF
+	default n
+	help
+	  Include code to provide CPUFreq driver API.
+
+config PPC_750GX_DUAL_PLL_IF_SYSFS
+	bool "Include sysfs interface"
+	depends on PPC_750GX_DUAL_PLL_IF
+	default n
+	help
+	  Include code to provide sysfs interface.
+
  endmenu
Index: include/asm-powerpc/cputable.h
===================================================================
--- include/asm-powerpc/cputable.h.orig	2008-08-13 00:56:46.000000000 -0700
+++ include/asm-powerpc/cputable.h	2008-08-14 02:44:30.000000000 -0700
@@ -263,7 +263,8 @@ extern void do_feature_fixups(unsigned l
  #define CPU_FTRS_750FX2	(CPU_FTRS_750 | CPU_FTR_NO_DPM)
  #define CPU_FTRS_750FX	(CPU_FTRS_750 | CPU_FTR_DUAL_PLL_750FX | \
  		CPU_FTR_HAS_HIGH_BATS)
-#define CPU_FTRS_750GX	(CPU_FTRS_750FX)
+#define CPU_FTRS_750GX	(CPU_FTRS_750 | CPU_FTR_DUAL_PLL_750FX | \
+		CPU_FTR_HAS_HIGH_BATS)
  #define CPU_FTRS_7400_NOTAU	(CPU_FTR_COMMON | \
  	    CPU_FTR_MAYBE_CAN_DOZE | CPU_FTR_USE_TB | CPU_FTR_L2CR | \
  	    CPU_FTR_ALTIVEC_COMP | CPU_FTR_HPTE_TABLE | \
