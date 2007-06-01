Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbXFALMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbXFALMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 07:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbXFALMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 07:12:16 -0400
Received: from rex.snapgear.com ([203.143.235.140]:48561 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750719AbXFALMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 07:12:15 -0400
Date: Fri, 1 Jun 2007 21:11:21 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200706011111.l51BBLji023569@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: remove cruft from setup code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clean out cruft.

. remove include files not needed
. remove not used CAT_ROMARRAY code
. remove generic machine pointers not used
. remove unused functions
. fix email address in copyrights

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---



diff -Naur linux-2.6.21/arch/m68knommu/kernel/setup.c linux-2.6.21-uc0/arch/m68knommu/kernel/setup.c
--- linux-2.6.21/arch/m68knommu/kernel/setup.c	2007-05-01 17:12:41.000000000 +1000
+++ linux-2.6.21-uc0/arch/m68knommu/kernel/setup.c	2007-05-01 17:16:11.000000000 +1000
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
@@ -46,34 +42,19 @@
 
 char __initdata command_line[COMMAND_LINE_SIZE];
 
-/* setup some dummy routines */
-static void dummy_waitbut(void)
-{
-}
+void (*mach_trap_init)(void);
 
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
+void (*mach_sched_init)(irq_handler_t handler);
+void (*mach_tick)(void);
+void (*mach_gettod)(int*, int*, int*, int*, int*, int*);
+int (*mach_set_clock_mmss)(unsigned long);
+unsigned long (*mach_gettimeoffset)(void);
+
+/* machine dependent reboot functions */
+void (*mach_reset)(void);
+void (*mach_halt)(void);
+void (*mach_power_off)(void);
 
 
 #ifdef CONFIG_M68000
@@ -134,13 +115,6 @@
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
 
@@ -148,15 +122,8 @@
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
@@ -220,11 +192,7 @@
 		(int) &_sbss, (int) &_ebss);
 	printk(KERN_DEBUG "KERNEL -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x "
 		"STACK=0x%06x-0x%06x\n",
-#ifdef CAT_ROMARRAY
-		(int) romarray, ((int) romarray) + romarray[2],
-#else
 		(int) &_ebss, (int) memory_start,
-#endif
 		(int) memory_start, (int) memory_end,
 		(int) memory_end, (int) _ramend);
 #endif
