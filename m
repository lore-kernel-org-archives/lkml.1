Return-Path: <linux-kernel-owner+w=401wt.eu-S932829AbXGLMJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbXGLMJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932620AbXGLMIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:08:44 -0400
Received: from rex.snapgear.com ([203.143.235.140]:38178 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764685AbXGLMIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:08:41 -0400
Date: Thu, 12 Jul 2007 22:07:50 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707121207.l6CC7oLh026562@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove cruft from setup code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the m68knommu/kernel/setup.c. It is just full of old junk.

. removed unused includes
. removed unused conditional code (with unused defines)
. removed unused code
. removed unused function prototypes and variables
. remove old/wrong comments
. retabed code that was inconsistently formated
. correct copyrights

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/kernel/setup.c linux-2.6.22-uc0/arch/m68knommu/kernel/setup.c
--- linux-2.6.22/arch/m68knommu/kernel/setup.c	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/kernel/setup.c	2007-07-12 15:27:00.000000000 +1000
@@ -1,8 +1,8 @@
 /*
  *  linux/arch/m68knommu/kernel/setup.c
  *
- *  Copyright (C) 1999-2004  Greg Ungerer (gerg@snapgear.com)
- *  Copyright (C) 1998,1999  D. Jeff Dionne <jeff@lineo.ca>
+ *  Copyright (C) 1999-2007  Greg Ungerer (gerg@snapgear.com)
+ *  Copyright (C) 1998,1999  D. Jeff Dionne <jeff@uClinux.org>
  *  Copyleft  ()) 2000       James D. Schettine {james@telos-systems.com}
  *  Copyright (C) 1998       Kenneth Albanowski <kjahds@kjahds.com>
  *  Copyright (C) 1995       Hamish Macdonald
@@ -20,17 +20,13 @@
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/fs.h>
 #include <linux/fb.h>
 #include <linux/module.h>
 #include <linux/console.h>
-#include <linux/genhd.h>
 #include <linux/errno.h>
 #include <linux/string.h>
-#include <linux/major.h>
 #include <linux/bootmem.h>
 #include <linux/seq_file.h>
-#include <linux/root_dev.h>
 #include <linux/init.h>
 
 #include <asm/setup.h>
@@ -46,34 +42,14 @@
 
 char __initdata command_line[COMMAND_LINE_SIZE];
 
-/* setup some dummy routines */
-static void dummy_waitbut(void)
-{
-}
-
-void (*mach_sched_init) (irq_handler_t handler);
-void (*mach_tick)( void );
-/* machine dependent keyboard functions */
-int (*mach_keyb_init) (void);
-int (*mach_kbdrate) (struct kbd_repeat *);
-void (*mach_kbd_leds) (unsigned int);
-/* machine dependent irq functions */
-void (*mach_init_IRQ) (void);
-irq_handler_t mach_default_handler;
-int (*mach_get_irq_list) (struct seq_file *, void *);
-void (*mach_process_int) (int irq, struct pt_regs *fp);
-void (*mach_trap_init) (void);
 /* machine dependent timer functions */
-unsigned long (*mach_gettimeoffset) (void);
-void (*mach_gettod) (int*, int*, int*, int*, int*, int*);
-int (*mach_hwclk) (int, struct rtc_time*);
-int (*mach_set_clock_mmss) (unsigned long);
-void (*mach_mksound)( unsigned int count, unsigned int ticks );
-void (*mach_reset)( void );
-void (*waitbut)(void) = dummy_waitbut;
-void (*mach_debug_init)(void);
-void (*mach_halt)( void );
-void (*mach_power_off)( void );
+void (*mach_gettod)(int*, int*, int*, int*, int*, int*);
+int (*mach_set_clock_mmss)(unsigned long);
+
+/* machine dependent reboot functions */
+void (*mach_reset)(void);
+void (*mach_halt)(void);
+void (*mach_power_off)(void);
 
 
 #ifdef CONFIG_M68000
@@ -134,13 +110,6 @@
 	#define	CPU "UNKNOWN"
 #endif
 
-/* (es) */
-/* note: why is this defined here?  the must be a better place to put this */
-#if defined( CONFIG_TELOS) || defined( CONFIG_UCDIMM ) || defined( CONFIG_UCSIMM ) || defined(CONFIG_DRAGEN2) || (defined( CONFIG_PILOT ) && defined( CONFIG_M68328 ))
-#define CAT_ROMARRAY
-#endif
-/* (/es) */
-
 extern int _stext, _etext, _sdata, _edata, _sbss, _ebss, _end;
 extern int _ramstart, _ramend;
 
@@ -148,15 +117,8 @@
 {
 	int bootmap_size;
 
-#if defined(CAT_ROMARRAY) && defined(DEBUG)
-	extern int __data_rom_start;
-	extern int __data_start;
-	int *romarray = (int *)((int) &__data_rom_start +
-			      (int)&_edata - (int)&__data_start);
-#endif
-
 	memory_start = PAGE_ALIGN(_ramstart);
-	memory_end = _ramend; /* by now the stack is part of the init task */
+	memory_end = _ramend;
 
 	init_mm.start_code = (unsigned long) &_stext;
 	init_mm.end_code = (unsigned long) &_etext;
@@ -218,15 +185,9 @@
 		"BSS=0x%06x-0x%06x\n", (int) &_stext, (int) &_etext,
 		(int) &_sdata, (int) &_edata,
 		(int) &_sbss, (int) &_ebss);
-	printk(KERN_DEBUG "KERNEL -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x "
-		"STACK=0x%06x-0x%06x\n",
-#ifdef CAT_ROMARRAY
-		(int) romarray, ((int) romarray) + romarray[2],
-#else
+	printk(KERN_DEBUG "MEMORY -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x\n ",
 		(int) &_ebss, (int) memory_start,
-#endif
-		(int) memory_start, (int) memory_end,
-		(int) memory_end, (int) _ramend);
+		(int) memory_start, (int) memory_end);
 #endif
 
 	/* Keep a copy of command line */
@@ -268,32 +229,33 @@
 /*
  *	Get CPU information for use by the procfs.
  */
-
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
-    char *cpu, *mmu, *fpu;
-    u_long clockfreq;
+	char *cpu, *mmu, *fpu;
+	u_long clockfreq;
 
-    cpu = CPU;
-    mmu = "none";
-    fpu = "none";
+	cpu = CPU;
+	mmu = "none";
+	fpu = "none";
 
 #ifdef CONFIG_COLDFIRE
-    clockfreq = (loops_per_jiffy*HZ)*3;
+	clockfreq = (loops_per_jiffy * HZ) * 3;
 #else
-    clockfreq = (loops_per_jiffy*HZ)*16;
+	clockfreq = (loops_per_jiffy * HZ) * 16;
 #endif
 
-    seq_printf(m, "CPU:\t\t%s\n"
-		   "MMU:\t\t%s\n"
-		   "FPU:\t\t%s\n"
-		   "Clocking:\t%lu.%1luMHz\n"
-		   "BogoMips:\t%lu.%02lu\n"
-		   "Calibration:\t%lu loops\n",
-		   cpu, mmu, fpu,
-		   clockfreq/1000000,(clockfreq/100000)%10,
-		   (loops_per_jiffy*HZ)/500000,((loops_per_jiffy*HZ)/5000)%100,
-		   (loops_per_jiffy*HZ));
+	seq_printf(m, "CPU:\t\t%s\n"
+		      "MMU:\t\t%s\n"
+		      "FPU:\t\t%s\n"
+		      "Clocking:\t%lu.%1luMHz\n"
+		      "BogoMips:\t%lu.%02lu\n"
+		      "Calibration:\t%lu loops\n",
+		      cpu, mmu, fpu,
+		      clockfreq / 1000000,
+		      (clockfreq / 100000) % 10,
+		      (loops_per_jiffy * HZ) / 500000,
+		      ((loops_per_jiffy * HZ) / 5000) % 100,
+		      (loops_per_jiffy * HZ));
 
 	return 0;
 }
@@ -320,12 +282,3 @@
 	.show	= show_cpuinfo,
 };
 
-void arch_gettod(int *year, int *mon, int *day, int *hour,
-		 int *min, int *sec)
-{
-	if (mach_gettod)
-		mach_gettod(year, mon, day, hour, min, sec);
-	else
-		*year = *mon = *day = *hour = *min = *sec = 0;
-}
-
