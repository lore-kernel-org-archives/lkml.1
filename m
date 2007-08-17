Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbXHQUHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbXHQUHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbXHQUHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:07:39 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:6710 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbXHQUHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:07:38 -0400
X-IronPort-AV: i="4.19,277,1183348800"; 
   d="scan'208"; a="37380151:sNHT46713359"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [draft] Blackfin Early Printk implmentation
Date: Fri, 17 Aug 2007 16:07:32 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Gerd Hoffmann" <kraxel@redhat.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Bryan Wu" <bryan.wu@analog.com>,
       "Sonic Zhang" <sonic.adi@gmail.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <200708152234.06734.rgetz@blackfin.uclinux.org> <200708171336.40159.rgetz@blackfin.uclinux.org> <20070817175911.GA22046@uranus.ravnborg.org>
In-Reply-To: <20070817175911.GA22046@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171607.32849.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 17 Aug 2007 20:07:32.0113 (UTC) FILETIME=[3EB21810:01C7E10A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17 Aug 2007 13:59, Sam Ravnborg pondered:
> That seems to explain why I could not follow your code changes.
> A more fine grained splitup would have helped here.

Sorry - see below. These aren't proper patches anymore, since it was
faster for me to split them by hand (but should be OK for review).
I will resend later properly.

> I noticed that you copied the actual early_printk code from x86_64.
> What was preventing you from just using the x86_64 code here?

Some was borrowed - but not much. since we don't support vga, or 16550 UARTs
(Blackfin has it's own on-chip UART), I don't think this would work. 

> A simple
> #include <arch/x86_64/boot/early_printk.c>
> in the blackfin early_printk should do the trick.

Maybe I'm missing something - but I don't think so. Every one who implements
implements direct IO to the hardware (except me, since I put it into the driver
file, and force Sonic - the serial driver developer - to maintain it forever).

Most of the other early printks talks directly to the hardware.

> Thinking that all should do the same so maybe alpha ought to change...

When I looked at all the printk implementations, I thought they were all
kind of hokey, and not very common - but what do you want for a debug interface
that lasts less than 5 seconds?

./arch/x86_64/kernel/early_printk.c
./arch/blackfin/kernel/early_printk.c
./arch/sh64/kernel/early_printk.c
./arch/sh/kernel/early_printk.c
./arch/i386/kernel/early_printk.c
./arch/mips/kernel/early_printk.c

I didn't see an alpha implementation - where is it done?

-Robin

> So this patch does three things at least:

> -> delete cruft emulating early printk

Index: linux-2.6.x/arch/blackfin/Kconfig
===================================================================
--- linux-2.6.x/arch/blackfin/Kconfig	(revision 3568)
+++ linux-2.6.x/arch/blackfin/Kconfig	(working copy)
@@ -1040,24 +1040,6 @@
 	  also relocates the irq_panic() function to L1 memory, (which is
 	  un-cached).
 
-config DEBUG_KERNEL_START
-	bool "Debug Kernel Startup"
-	depends on DEBUG_KERNEL
-	help
-	  Say Y here to put in an mini-execption handler before the kernel
-	  replaces the bootloader exception handler. This will stop kernels
-	  from dieing at startup with no visible error messages.
-
-config DEBUG_SERIAL_EARLY_INIT
-	bool "Initialize serial driver early"
-	default n
-	depends on SERIAL_BFIN
-	help
-	  Say Y here if you want to get kernel output early when kernel
-	  crashes before the normal console initialization. If this option
-	  is enable, console output will always go to the ttyBF0, no matter
-	  what kernel boot paramters you set.
-
 config DEBUG_HUNT_FOR_ZERO
 	bool "Catch NULL pointer reads/writes"
 	default y
@@ -1165,6 +1147,20 @@
 	  Say Y here to disable hardware tracing in some known "jumpy" pieces
 	  of code so that the trace buffer will extend further back.
 
Index: linux-2.6.x/arch/blackfin/mach-bf533/head.S
===================================================================
--- linux-2.6.x/arch/blackfin/mach-bf533/head.S	(revision 3568)
+++ linux-2.6.x/arch/blackfin/mach-bf533/head.S	(working copy)
@@ -35,9 +35,6 @@
 #include <asm/mach-common/clocks.h>
 #include <asm/mach/mem_init.h>
 #endif
-#if CONFIG_DEBUG_KERNEL_START
-#include <asm/mach-common/def_LPBlackfin.h>
-#endif
 
 .global __rambase
 .global __ramstart
@@ -104,36 +101,6 @@
 	P0 = R1;
 	R0 = R1;
 
-#if CONFIG_DEBUG_KERNEL_START
-
-/*
- * Set up a temporary Event Vector Table, so if something bad happens before
- * the kernel is fully started, it doesn't vector off into the bootloaders
- * table
- */
-	P0.l = lo(EVT2);
-	P0.h = hi(EVT2);
-	P1.l = lo(EVT15);
-	P1.h = hi(EVT15);
-	P2.l = debug_kernel_start_trap;
-	P2.h = debug_kernel_start_trap;
-
-	RTS = P2;
-	RTI = P2;
-	RTX = P2;
-	RTN = P2;
-	RTE = P2;
-
-.Lfill_temp_vector_table:
-	[P0++] = P2;	/* Core Event Vector Table */
-	CC = P0 == P1;
-	if !CC JUMP .Lfill_temp_vector_table
-	P0 = r0;
-	P1 = r0;
-	P2 = r0;
-
-#endif
-
 	p0.h = hi(FIO_MASKA_C);
 	p0.l = lo(FIO_MASKA_C);
 	r0 = 0xFFFF(Z);
@@ -519,216 +492,6 @@
 	RTS;
 ENDPROC(_bfin_reset)
 
-#if CONFIG_DEBUG_KERNEL_START
-debug_kernel_start_trap:
-	/* Set up a temp stack in L1 - SDRAM might not be working  */
-	P0.L = lo(L1_DATA_A_START + 0x100);
-	P0.H = hi(L1_DATA_A_START + 0x100);
-	SP = P0;
-
-	/* Make sure the Clocks are the way I think they should be */
-	r0 = CONFIG_VCO_MULT & 63;       /* Load the VCO multiplier         */
-	r0 = r0 << 9;                    /* Shift it over,                  */
-	r1 = CLKIN_HALF;                 /* Do we need to divide CLKIN by 2?*/
-	r0 = r1 | r0;
-	r1 = PLL_BYPASS;                 /* Bypass the PLL?                 */
-	r1 = r1 << 8;                    /* Shift it over                   */
-	r0 = r1 | r0;                    /* add them all together           */
-
-	p0.h = hi(PLL_CTL);
-	p0.l = lo(PLL_CTL);              /* Load the address                */
-	cli r2;                          /* Disable interrupts              */
-	ssync;
-	w[p0] = r0.l;                    /* Set the value                   */
-	idle;                            /* Wait for the PLL to stablize    */
-	sti r2;                          /* Enable interrupts               */
-
-.Lcheck_again1:
-	p0.h = hi(PLL_STAT);
-	p0.l = lo(PLL_STAT);
-	R0 = W[P0](Z);
-	CC = BITTST(R0,5);
-	if ! CC jump .Lcheck_again1;
-
-	/* Configure SCLK & CCLK Dividers */
-	r0 = (CONFIG_CCLK_ACT_DIV | CONFIG_SCLK_DIV);
-	p0.h = hi(PLL_DIV);
-	p0.l = lo(PLL_DIV);
-	w[p0] = r0.l;
-	ssync;
-
-	/* Make sure UART is enabled - you can never be sure */
-
-/*
- * Setup for console. Argument comes from the menuconfig
- */
-
-#ifdef CONFIG_BAUD_9600
-#define CONSOLE_BAUD_RATE       9600
-#elif CONFIG_BAUD_19200
-#define CONSOLE_BAUD_RATE       19200
-#elif CONFIG_BAUD_38400
-#define CONSOLE_BAUD_RATE       38400
-#elif CONFIG_BAUD_57600
-#define CONSOLE_BAUD_RATE       57600
-#elif CONFIG_BAUD_115200
-#define CONSOLE_BAUD_RATE       115200
-#endif
-
-	p0.h = hi(UART_GCTL);
-	p0.l = lo(UART_GCTL);
-	r0 = 0x00(Z);
-	w[p0] = r0.L;   /* To Turn off UART clocks */
-	ssync;
-
-	p0.h = hi(UART_LCR);
-	p0.l = lo(UART_LCR);
-	r0 = 0x83(Z);
-	w[p0] = r0.L;   /* To enable DLL writes */
-	ssync;
-
-	R1 = (((CONFIG_CLKIN_HZ * CONFIG_VCO_MULT) / CONFIG_SCLK_DIV) / (CONSOLE_BAUD_RATE * 16));
-
-	p0.h = hi(UART_DLL);
-	p0.l = lo(UART_DLL);
-	r0 = 0xFF(Z);
-	r0 = R1 & R0;
-	w[p0] = r0.L;
-	ssync;
-
-	p0.h = hi(UART_DLH);
-	p0.l = lo(UART_DLH);
-	r1 >>= 8 ;
-	w[p0] = r1.L;
-	ssync;
-
-	p0.h = hi(UART_GCTL);
-	p0.l = lo(UART_GCTL);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;   /* To enable UART clock */
-	ssync;
-
-	p0.h = hi(UART_LCR);
-	p0.l = lo(UART_LCR);
-	r0 = 0x03(Z);
-	w[p0] = r0.L;   /* To Turn on UART */
-	ssync;
-
-	p0.h = hi(UART_GCTL);
-	p0.l = lo(UART_GCTL);
-	r0 = 0x01(Z);
-	w[p0] = r0.L;   /* To Turn on UART Clocks */
-	ssync;
-
-	P0.h = hi(UART_THR);
-	P0.l = lo(UART_THR);
-	P1.h = hi(UART_LSR);
-	P1.l = lo(UART_LSR);
-
-	R0.L = 'K';
-	call .Lwait_char;
-	R0.L='e';
-	call .Lwait_char;
-	R0.L='r';
-	call .Lwait_char;
-	R0.L='n'
-	call .Lwait_char;
-	R0.L='e'
-	call .Lwait_char;
-	R0.L='l';
-	call .Lwait_char;
-	R0.L=' ';
-	call .Lwait_char;
-	R0.L='c';
-	call .Lwait_char;
-	R0.L='r';
-	call .Lwait_char;
-	R0.L='a';
-	call .Lwait_char;
-	R0.L='s';
-	call .Lwait_char;
-	R0.L='h';
-	call .Lwait_char;
-	R0.L='\r';
-	call .Lwait_char;
-	R0.L='\n';
-	call .Lwait_char;
-
-	R0.L='S';
-	call .Lwait_char;
-	R0.L='E';
-	call .Lwait_char;
-	R0.L='Q'
-	call .Lwait_char;
-	R0.L='S'
-	call .Lwait_char;
-	R0.L='T';
-	call .Lwait_char;
-	R0.L='A';
-	call .Lwait_char;
-	R0.L='T';
-	call .Lwait_char;
-	R0.L='=';
-	call .Lwait_char;
-	R2 = SEQSTAT;
-	call .Ldump_reg;
-
-	R0.L=' ';
-	call .Lwait_char;
-	R0.L='R';
-	call .Lwait_char;
-	R0.L='E'
-	call .Lwait_char;
-	R0.L='T'
-	call .Lwait_char;
-	R0.L='X';
-	call .Lwait_char;
-	R0.L='=';
-	call .Lwait_char;
-	R2 = RETX;
-	call .Ldump_reg;
-
-	R0.L='\r';
-	call .Lwait_char;
-	R0.L='\n';
-	call .Lwait_char;
-
-.Ldebug_kernel_start_trap_done:
-	JUMP    .Ldebug_kernel_start_trap_done;
-.Ldump_reg:
-	R3 = 32;
-	R4 = 0x0F;
-	R5 = ':';  /* one past 9 */
-
-.Ldump_reg2:
-	R0 = R2;
-	R3 += -4;
-	R0 >>>= R3;
-	R0 = R0 & R4;
-	R0 += 0x30;
-	CC = R0 <= R5;
-	if CC JUMP .Ldump_reg1;
-	R0 += 7;
-
-.Ldump_reg1:
-	R1.l = W[P1];
-	CC = BITTST(R1, 5);
-	if !CC JUMP .Ldump_reg1;
-	W[P0] = r0;
-
-	CC = R3 == 0;
-	if !CC JUMP .Ldump_reg2
-	RTS;
-
-.Lwait_char:
-	R1.l = W[P1];
-	CC = BITTST(R1, 5);
-	if !CC JUMP .Lwait_char;
-	W[P0] = r0;
-	RTS;
-
-#endif  /* CONFIG_DEBUG_KERNEL_START  */
-
 .data
 
 /*
Index: linux-2.6.x/arch/blackfin/kernel/setup.c
===================================================================
--- linux-2.6.x/arch/blackfin/kernel/setup.c	(revision 3568)
+++ linux-2.6.x/arch/blackfin/kernel/setup.c	(working copy)
@@ -192,29 +187,6 @@
 	}
 #endif
 
-#ifdef DEBUG_SERIAL_EARLY_INIT
-	bfin_console_init();	/* early console registration */
-	/* this give a chance to get printk() working before crash. */
-#endif
-


> -> add an early excaption handler

Index: linux-2.6.x/include/asm-blackfin/irq_handler.h
===================================================================
--- linux-2.6.x/include/asm-blackfin/irq_handler.h	(revision 3568)
+++ linux-2.6.x/include/asm-blackfin/irq_handler.h	(working copy)
@@ -1,3 +1,24 @@
+/*
+ * File:         include/asm-blackfin/irq_handler.h
+ *
+ * Description:  function prototypes for interrupt handler routines
+ *
+ * Modified:
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
 #ifndef _IRQ_HANDLER_H
 #define _IRQ_HANDLER_H
 
@@ -22,6 +43,7 @@
 asmlinkage void init_exception_buff(void);
 asmlinkage void trap_c(struct pt_regs *fp);
 asmlinkage void ex_replaceable(void);
+asmlinkage void early_trap(void);
 
 extern void *ex_table[];
 extern void return_from_exception(void);
Index: linux-2.6.x/arch/blackfin/kernel/early_printk.c
===================================================================
--- linux-2.6.x/arch/blackfin/kernel/early_printk.c	(revision 0)
+++ linux-2.6.x/arch/blackfin/kernel/early_printk.c	(revision 0)
+/*
+ * Set up a temporary Event Vector Table, so if something bad happens before
+ * the kernel is fully started, it doesn't vector off into somewhere we don't
+ * know
+ */
+
+asmlinkage void __init init_early_exception_vectors(void)
+{
+	/* cannot program in software:
+	 * evt0 - emulation (jtag)
+	 * evt1 - reset
+	 */
+	bfin_write_EVT2(early_trap);
+	bfin_write_EVT3(early_trap);
+	bfin_write_EVT5(early_trap);
+	bfin_write_EVT6(early_trap);
+	bfin_write_EVT7(early_trap);
+	bfin_write_EVT8(early_trap);
+	bfin_write_EVT9(early_trap);
+	bfin_write_EVT10(early_trap);
+	bfin_write_EVT11(early_trap);
+	bfin_write_EVT12(early_trap);
+	bfin_write_EVT13(early_trap);
+	bfin_write_EVT14(early_trap);
+	bfin_write_EVT15(early_trap);
+
+	/* Set all the return from interupt, exception, NMI to a known place
+	 * so if we do a RETI, RETX or RETN by mistake - we go somewhere known
+	 * Note - don't change RETS - we are in a subroutine, or
+	 * RETE - since it might screw up if emulator is attached
+	 */
+
+	asm("RETI = %0; RETX = %0; RETN = %0;\n" : : "p"(early_trap));
+}
+
+asmlinkage void __init early_trap_c(struct pt_regs *fp, void *retaddr)
+{
+	unsigned int serial_port = DEFAULT_PORT;
+	unsigned int cflag = DEFAULT_CFLAG;
+
+	/* This can happen before the uart is initialized, so initialize
+	 * the UART now
+	 */
+	if (!early_console_initialized) {
+		bfin_earlyserial_init(serial_port, cflag);
+	}
+
+	dump_bfin_regs(fp, retaddr);
+	dump_bfin_trace_buffer();
+
+	panic("Died early");
+}
Index: linux-2.6.x/arch/blackfin/mach-bf533/head.S
===================================================================
--- linux-2.6.x/arch/blackfin/mach-bf533/head.S	(revision 3568)
+++ linux-2.6.x/arch/blackfin/mach-bf533/head.S	(working copy)
@@ -214,6 +181,12 @@
 	fp = sp;
 	usp = sp;
 
+#ifdef CONFIG_EARLY_PRINTK
+	SP += -12;
+	call _init_early_exception_vectors;
+	SP += 12;
+#endif
+
 	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
 	call _bf53x_relocate_l1_mem;
 #if CONFIG_BFIN_KERNEL_CLOCK

Index: linux-2.6.x/arch/blackfin/mach-bf561/head.S
===================================================================
--- linux-2.6.x/arch/blackfin/mach-bf561/head.S	(revision 3568)
+++ linux-2.6.x/arch/blackfin/mach-bf561/head.S	(working copy)
@@ -169,6 +169,12 @@
 	fp = sp;
 	usp = sp;
 
+#ifdef CONFIG_EARLY_PRINTK
+	SP += -12;
+	call _init_early_exception_vectors;
+	SP += 12;
+#endif
+
 	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
 	call _bf53x_relocate_l1_mem;
 #if CONFIG_BFIN_KERNEL_CLOCK
Index: linux-2.6.x/arch/blackfin/mach-bf537/head.S
===================================================================
--- linux-2.6.x/arch/blackfin/mach-bf537/head.S	(revision 3568)
+++ linux-2.6.x/arch/blackfin/mach-bf537/head.S	(working copy)
@@ -224,6 +224,12 @@
 	fp = sp;
 	usp = sp;
 
+#ifdef CONFIG_EARLY_PRINTK
+	SP += -12;
+	call _init_early_exception_vectors;
+	SP += 12;
+#endif
+
 	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
 	call _bf53x_relocate_l1_mem;
 #if CONFIG_BFIN_KERNEL_CLOCK
Index: linux-2.6.x/arch/blackfin/mach-bf548/head.S
===================================================================
--- linux-2.6.x/arch/blackfin/mach-bf548/head.S	(revision 3568)
+++ linux-2.6.x/arch/blackfin/mach-bf548/head.S	(working copy)
@@ -125,6 +125,12 @@
 	FP = SP;
 	USP = SP;
 
+#ifdef CONFIG_EARLY_PRINTK
+	SP += -12;
+	call _init_early_exception_vectors;
+	SP += 12;
+#endif
+
 	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
 	call _bf53x_relocate_l1_mem;
 #if CONFIG_BFIN_KERNEL_CLOCK
Index: linux-2.6.x/arch/blackfin/mach-common/entry.S
===================================================================
--- linux-2.6.x/arch/blackfin/mach-common/entry.S	(revision 3568)
+++ linux-2.6.x/arch/blackfin/mach-common/entry.S	(working copy)
@@ -803,14 +803,57 @@
 .section .l1.data.B
 #endif
 ENTRY(_trace_buff_offset)
-        .long 0;
+	.long 0;
 ALIGN
 ENTRY(_software_trace_buff)
 	.rept ((1 << CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN)*256);
 	.long 0
 	.endr
+#endif /* CONFIG_DEBUG_BFIN_HWTRACE_EXPAND */
+
+#ifdef CONFIG_EARLY_PRINTK
+#ifdef CONFIG_EXCPT_IRQ_SYSC_L1
+.section .l1.text
+#else
+.text
 #endif
 
+ENTRY(_early_trap)
+	SAVE_ALL_SYS
+	trace_buffer_stop(p0, r0);
+
+	/* Turn caches off, to ensure we don't get double exceptions */
+
+	P4.L = LO(IMEM_CONTROL);
+	P4.H = HI(IMEM_CONTROL);
+
+	R5 = [P4];              /* Control Register*/
+	BITCLR(R5,ENICPLB_P);
+	CLI R1;
+	SSYNC;          /* SSYNC required before writing to IMEM_CONTROL. */
+	.align 8;
+	[P4] = R5;
+	SSYNC;
+
+	P4.L = LO(DMEM_CONTROL);
+	P4.H = HI(DMEM_CONTROL);
+	R5 = [P4];
+	BITCLR(R5,ENDCPLB_P);
+	SSYNC;          /* SSYNC required before writing to DMEM_CONTROL. */
+	.align 8;
+	[P4] = R5;
+	SSYNC;
+	STI R1;
+
+	r0 = sp;        /* stack frame pt_regs pointer argument ==> r0 */
+	r1 = RETX;
+
+	SP += -12;
+	call _early_trap_c;
+	SP += 12;
+ENDPROC(_early_trap)
+#endif /* CONFIG_EARLY_PRINTK */
+
 /*
  * Put these in the kernel data section - that should always be covered by
  * a CPLB. This is needed to ensure we don't get double fault conditions


> -> adds early_printk





Index: linux-2.6.x/include/asm-blackfin/early_printk.h
===================================================================
--- linux-2.6.x/include/asm-blackfin/early_printk.h	(revision 0)
+++ linux-2.6.x/include/asm-blackfin/early_printk.h	(revision 0)
@@ -0,0 +1,28 @@
+/*
+ * File:         include/asm-blackfin/early_printk.h
+ * Author:       Robin Getz <rgetz@blackfin.uclinux.org
+ *
+ * Created:      14Aug2007
+ * Description:  function prototpyes for early printk
+ *
+ * Modified:
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifdef CONFIG_EARLY_PRINTK
+extern int setup_early_printk(char *);
+#else
+#define setup_early_printk(fmt) do { } while (0)
+#endif /* CONFIG_EARLY_PRINTK */

Index: linux-2.6.x/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.x/Documentation/kernel-parameters.txt	(revision 3568)
+++ linux-2.6.x/Documentation/kernel-parameters.txt	(working copy)
@@ -34,6 +34,7 @@
 	APIC	APIC support is enabled.
 	APM	Advanced Power Management support is enabled.
 	AX25	Appropriate AX.25 support is enabled.
+	BLACKFIN Blackfin architecture is enabled.
 	CD	Appropriate CD support is enabled.
 	DRM	Direct Rendering Management support is enabled.
 	EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
@@ -558,7 +559,7 @@
 
 	dtc3181e=	[HW,SCSI]
 
-	earlyprintk=	[IA-32,X86-64,SH]
+	earlyprintk=	[IA-32,X86-64,SH,BLACKFIN]
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]

Index: linux-2.6.x/arch/blackfin/kernel/early_printk.c
===================================================================
--- linux-2.6.x/arch/blackfin/kernel/early_printk.c	(revision 0)
+++ linux-2.6.x/arch/blackfin/kernel/early_printk.c	(revision 0)
@@ -0,0 +1,210 @@
+/*
+ * File:         arch/blackfin/kernel/early_printk.c
+ * Based on:     arch/x86_64/kernel/early_printk.c
+ * Author:       Robin Getz <rgetz@blackfin.uclinux.org
+ *
+ * Created:      14Aug2007
+ * Description:  allow a console to be used for early printk
+ *
+ * Modified:
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/serial_core.h>
+#include <linux/console.h>
+#include <linux/string.h>
+#include <asm/blackfin.h>
+#include <asm/irq_handler.h>
+#include <asm/early_printk.h>
+
+extern struct console *bfin_earlyserial_init(unsigned int port,
+						unsigned int cflag);
+extern int bfin_earlyserial_disable(void);
+
+static struct console *early_console_initialized;
+
+/* Default console
+ * Port n == ttyBFn
+ * cflags == UART output modes
+ */
+#define DEFAULT_PORT 0
+#define DEFAULT_CFLAG CS8|B57600
+
+int __init setup_early_printk(char *buf)
+{
+	int baud, bit;
+	char parity;
+	unsigned int serial_port = DEFAULT_PORT;
+	unsigned int cflag = DEFAULT_CFLAG;
+
+	/* Crashing in here would be really bad, so check both the var
+	   and the pointer before we start using it
+	 */
+	if (!buf)
+		return 0;
+
+	if (!*buf)
+		return 0;
+
+	if (early_console_initialized)
+		return 0;
+
+	if (!strncmp(buf, "serial", 6)) {
+		buf += 7;
+		if (!strncmp(buf, "ttyBF", 5)) {
+			buf += 5;
+			serial_port = simple_strtoul(buf, &buf, 10);
+			buf++;
+		}
+
+		cflag = 0;
+		baud = simple_strtoul(buf, &buf, 10);
+		switch (baud) {
+		case 1200:
+			cflag |= B1200;
+			break;
+		case 2400:
+			cflag |= B2400;
+			break;
+		case 4800:
+			cflag |= B4800;
+			break;
+		case 9600:
+			cflag |= B9600;
+			break;
+		case 19200:
+			cflag |= B19200;
+			break;
+		case 38400:
+			cflag |= B38400;
+			break;
+		case 115200:
+			cflag |= B115200;
+			break;
+		default:
+			cflag |= B57600;
+		}
+
+		parity = buf[0];
+		buf++;
+		switch (parity) {
+		case 'e':
+			cflag |= PARENB;
+			break;
+		case 'o':
+			cflag |= PARODD;
+			break;
+		}
+
+		bit = simple_strtoul(buf, &buf, 10);
+		switch (bit) {
+		case 5:
+			cflag |= CS5;
+			break;
+		case 6:
+			cflag |= CS5;
+			break;
+		case 7:
+			cflag |= CS5;
+			break;
+		default:
+			cflag |= CS8;
+		}
+
+		early_console_initialized = bfin_earlyserial_init(serial_port,
+			cflag);
+	} else if (!strncmp(buf, "vga", 3)) {
+		/* TODO: add framebuffer console support? */
+	}
+
+	if (early_console_initialized)
+		printk(KERN_INFO "Early Printk Support Enabled on %s%d\n",
+			early_console_initialized->name,
+			early_console_initialized->index);
+
+	return 0;
+}
+
+int __init disable_early_printk(void)
+{
+	if (!early_console_initialized)
+		return 0;
+
+	printk(KERN_INFO "Unregister %s%d\n", early_console_initialized->name,
+		early_console_initialized->index);
+	unregister_console(early_console_initialized);
+	early_console_initialized = NULL;
+	return 0;
+}
+
+late_initcall(disable_early_printk);

Based on Mike's and Gerd's earlier comments I missed (until Mike poked me),
I will move the disable_early_printk into printk.c as a common function (and
a separate patch)

Index: linux-2.6.x/arch/blackfin/kernel/Makefile
===================================================================
--- linux-2.6.x/arch/blackfin/kernel/Makefile	(revision 3568)
+++ linux-2.6.x/arch/blackfin/kernel/Makefile	(working copy)
@@ -15,3 +15,4 @@
 obj-$(CONFIG_BFIN_DMA_5XX)           += bfin_dma_5xx.o
 obj-$(CONFIG_DUAL_CORE_TEST_MODULE)  += dualcore_test.o
 obj-$(CONFIG_KGDB)                   += kgdb.o
+obj-$(CONFIG_EARLY_PRINTK)           += early_printk.o
Index: linux-2.6.x/arch/blackfin/Kconfig
===================================================================
--- linux-2.6.x/arch/blackfin/Kconfig	(revision 3568)
+++ linux-2.6.x/arch/blackfin/Kconfig	(working copy)
@@ -1165,6 +1147,20 @@
 	  Say Y here to disable hardware tracing in some known "jumpy" pieces
 	  of code so that the trace buffer will extend further back.
 
+config EARLY_PRINTK
+	bool "Early printk" 
+	default n
+	help
+	  This option enables special console drivers which allow the kernel
+	  to print messages very early in the bootup process.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized. After enabling this
+	  feature, you must add "earlyprintk=serial,ttyBF0,57600" to the
+	  command line (bootargs). It is safe to say Y here in all cases, as
+	  all of this lives in the init section and is thrown away after the
+	  kernel boots completely.
+
 config DUAL_CORE_TEST_MODULE
 	tristate "Dual Core Test Module"
 	depends on (BF561)

Index: linux-2.6.x/drivers/serial/bfin_5xx.c
===================================================================
--- linux-2.6.x/drivers/serial/bfin_5xx.c	(revision 3568)
+++ linux-2.6.x/drivers/serial/bfin_5xx.c	(working copy)
@@ -961,31 +961,7 @@
 }
 
 #ifdef CONFIG_SERIAL_BFIN_CONSOLE
-static void bfin_serial_console_putchar(struct uart_port *port, int ch)
-{
-	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-	while (!(UART_GET_LSR(uart) & THRE))
-		barrier();
-	UART_PUT_CHAR(uart, ch);
-	SSYNC();
-}
-
 /*
- * Interrupts are disabled on entering
- */
-static void
-bfin_serial_console_write(struct console *co, const char *s, unsigned int count)
-{
-	struct bfin_serial_port *uart = &bfin_serial_ports[co->index];
-	int flags = 0;
-
-	spin_lock_irqsave(&uart->port.lock, flags);
-	uart_console_write(&uart->port, s, count, bfin_serial_console_putchar);
-	spin_unlock_irqrestore(&uart->port.lock, flags);
-
-}
-
-/*
  * If the port was already initialised (eg, by a boot loader),
  * try to determine the current setup.
  */
@@ -1037,19 +1013,25 @@
 	}
 	pr_debug("%s:baud = %d, parity = %c, bits= %d\n", __FUNCTION__, *baud, *parity, *bits);
 }
+#endif
 
+#if defined (CONFIG_SERIAL_BFIN_CONSOLE) || defined (CONFIG_EARLY_PRINTK)
+static struct uart_driver bfin_serial_reg;
+
 static int __init
 bfin_serial_console_setup(struct console *co, char *options)
 {
 	struct bfin_serial_port *uart;
+# ifdef CONFIG_SERIAL_BFIN_CONSOLE
 	int baud = 57600;
 	int bits = 8;
 	int parity = 'n';
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+#  ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	int flow = 'r';
-#else
+#  else
 	int flow = 'n';
-#endif
+#  endif
+# endif
 
 	/*
 	 * Check whether an invalid uart number has been specified, and
@@ -1060,15 +1042,45 @@
 		co->index = 0;
 	uart = &bfin_serial_ports[co->index];
 
+# ifdef CONFIG_SERIAL_BFIN_CONSOLE
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
 	else
 		bfin_serial_console_get_options(uart, &baud, &parity, &bits);
 
 	return uart_set_options(&uart->port, co, baud, parity, bits, flow);
+# else
+	return 0;
+# endif
 }
+#endif /* defined (CONFIG_SERIAL_BFIN_CONSOLE) ||
+				 defined (CONFIG_EARLY_PRINTK) */
 
-static struct uart_driver bfin_serial_reg;
+#ifdef CONFIG_SERIAL_BFIN_CONSOLE
+static void bfin_serial_console_putchar(struct uart_port *port, int ch)
+{
+	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
+	while (!(UART_GET_LSR(uart) & THRE))
+		barrier();
+	UART_PUT_CHAR(uart, ch);
+	SSYNC();
+}
+
+/*
+ * Interrupts are disabled on entering
+ */
+static void
+bfin_serial_console_write(struct console *co, const char *s, unsigned int count)
+{
+	struct bfin_serial_port *uart = &bfin_serial_ports[co->index];
+	int flags = 0;
+
+	spin_lock_irqsave(&uart->port.lock, flags);
+	uart_console_write(&uart->port, s, count, bfin_serial_console_putchar);
+	spin_unlock_irqrestore(&uart->port.lock, flags);
+
+}
+
 static struct console bfin_serial_console = {
 	.name		= BFIN_SERIAL_NAME,
 	.write		= bfin_serial_console_write,
@@ -1094,8 +1106,70 @@
 #define BFIN_SERIAL_CONSOLE	&bfin_serial_console
 #else
 #define BFIN_SERIAL_CONSOLE	NULL
+#endif /* CONFIG_SERIAL_BFIN_CONSOLE */
+
+
+#ifdef CONFIG_EARLY_PRINTK
+static __init void early_serial_putc(struct uart_port *port, int ch)
+{
+	unsigned timeout = 0xffff;
+	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
+
+	while ((!(UART_GET_LSR(uart) & THRE)) && --timeout)
+		cpu_relax();
+	UART_PUT_CHAR(uart, ch);
+}
+
+static __init void early_serial_write(struct console *con, const char *s,
+					unsigned int n)
+{
+	struct bfin_serial_port *uart = &bfin_serial_ports[con->index];
+	unsigned int i;
+
+	for (i = 0; i < n; i++, s++) {
+		if (*s == '\n')
+			early_serial_putc(&uart->port, '\r');
+		early_serial_putc(&uart->port, *s);
+	}
+}
+
+static struct __init console bfin_early_serial_console = {
+	.name = "early_ttyBF",
+	.write = early_serial_write,
+	.device = uart_console_device,
+	.flags = CON_PRINTBUFFER | CON_BOOT,
+	.setup = bfin_serial_console_setup,
+	.index = -1,
+	.data  = &bfin_serial_reg,
+};
+
+struct console __init *bfin_earlyserial_init(unsigned int port,
+						unsigned int cflag)
+{
+	struct bfin_serial_port *uart;
+	struct ktermios t;
+
+	if (port == -1 || port >= nr_ports)
+		port = 0;
+	bfin_serial_init_ports();
+	bfin_early_serial_console.index = port;
+	register_console(&bfin_early_serial_console);
+#ifdef CONFIG_KGDB_UART
+	kgdb_entry_state = 0;
+	init_kgdb_uart();
 #endif
+	uart = &bfin_serial_ports[port];
+	t.c_cflag = cflag;
+	t.c_iflag = 0;
+	t.c_oflag = 0;
+	t.c_lflag = ICANON;
+	t.c_line = port;
+	bfin_serial_set_termios(&uart->port, &t, &t);
+	return &bfin_early_serial_console;
+}
 
+#endif /* CONFIG_SERIAL_BFIN_CONSOLE */
+
 static struct uart_driver bfin_serial_reg = {
 	.owner			= THIS_MODULE,
 	.driver_name		= "bfin-uart",


This is a helper to the above - make sure that earlyprintk is parsed as early
as possible. Otherwise there is some time between when kernel exception table
is filled in, and early_parm is evaluated - if a crash happens between this
time, nothing will be printed out.

Index: linux-2.6.x/arch/blackfin/kernel/setup.c
===================================================================
--- linux-2.6.x/arch/blackfin/kernel/setup.c	(revision 3568)
+++ linux-2.6.x/arch/blackfin/kernel/setup.c	(working copy)
@@ -44,6 +44,7 @@
 #include <asm/blackfin.h>
 #include <asm/cplbinit.h>
 #include <asm/fixed_code.h>
+#include <asm/early_printk.h>
 
 u16 _bfin_swrst;
 
@@ -134,7 +135,6 @@
 	unsigned int memsize;
 	for (;;) {
 		if (c == ' ') {
-
 			if (!memcmp(to, "mem=", 4)) {
 				to += 4;
 				memsize = memparse(to, &to);
@@ -157,8 +157,10 @@
 							    1;
 					}
 				}
+			} else if (!memcmp(to, "earlyprintk=", 12)) {
+				to += 12;
+				setup_early_printk(to);
 			}
-
 		}
 		c = *(to++);
 		if (!c)
@@ -177,14 +179,7 @@
 #ifdef CONFIG_DUMMY_CONSOLE
 	conswitchp = &dummy_con;
 #endif
-	cclk = get_cclk();
-	sclk = get_sclk();
 
-#if !defined(CONFIG_BFIN_KERNEL_CLOCK)
-	if (ANOMALY_05000273 && cclk == sclk)
-		panic("ANOMALY 05000273, SCLK can not be same as CCLK");
-#endif
-
 #ifdef BF561_FAMILY
 	if (ANOMALY_05000266) {
 		bfin_read_IMDMA_D0_IRQ_STATUS();
@@ -192,29 +187,6 @@
 	}
 #endif
 
-#ifdef DEBUG_SERIAL_EARLY_INIT
-	bfin_console_init();	/* early console registration */
-	/* this give a chance to get printk() working before crash. */
-#endif
-
-	printk(KERN_INFO "Hardware Trace ");
-	if (bfin_read_TBUFCTL() & 0x1 )
-		printk("Active ");
-	else
-		printk("Off ");
-	if (bfin_read_TBUFCTL() & 0x2)
-		printk("and Enabled\n");
-	else
-	printk("and Disabled\n");
-
-
-#if defined(CONFIG_CHR_DEV_FLASH) || defined(CONFIG_BLK_DEV_FLASH)
-	/* we need to initialize the Flashrom device here since we might
-	 * do things with flash early on in the boot
-	 */
-	flash_probe();
-#endif
-
 #if defined(CONFIG_CMDLINE_BOOL)
 	strncpy(&command_line[0], CONFIG_CMDLINE, sizeof(command_line));
 	command_line[sizeof(command_line) - 1] = 0;
@@ -229,8 +201,36 @@
 	physical_mem_end = 0;
 	_ramend = CONFIG_MEM_SIZE * 1024 * 1024;
 
+	/* We parse command line early, to set memory limits and get
+	 * early_printk earlier than normal
+	 */
 	parse_cmdline_early(&command_line[0]);
 
+#if defined(CONFIG_CHR_DEV_FLASH) || defined(CONFIG_BLK_DEV_FLASH)
+	/* we need to initialize the Flashrom device here since we might
+	 * do things with flash early on in the boot
+	 */
+	flash_probe();
+#endif
+
+	cclk = get_cclk();
+	sclk = get_sclk();
+
+#if !defined(CONFIG_BFIN_KERNEL_CLOCK)
+	if (ANOMALY_05000273 && cclk < (sclk *2))
+		panic("ANOMALY 05000273: CCLK must be >= 2*SCLK ");
+#endif
+
+	printk(KERN_INFO "Hardware Trace ");
+	if (bfin_read_TBUFCTL() & 0x1 )
+		printk("Active ");
+	else
+		printk("Off ");
+	if (bfin_read_TBUFCTL() & 0x2)
+		printk("and Enabled\n");
+	else
+		printk("and Disabled\n");
+
 	if (physical_mem_end == 0)
 		physical_mem_end = _ramend;
 
@@ -298,13 +298,16 @@
 	 * 05000263 - Hardware loop corrupted when taking an ICPLB exception
 	 */
 #if (defined(CONFIG_DEBUG_HUNT_FOR_ZERO))
-	if (memory_end >= 56 * 1024 * 1024)
+	if (memory_end >= 56 * 1024 * 1024) {
 		memory_end = 56 * 1024 * 1024;
+		printk(KERN_NOTICE "Warning: limiting memory to %liMB due to hardware anomaly 05000263\n", memory_end >> 20);
+	}
 #else
-	if (memory_end >= 60 * 1024 * 1024)
+	if (memory_end >= 60 * 1024 * 1024) {
 		memory_end = 60 * 1024 * 1024;
+		printk(KERN_NOTICE "Warning: limiting memory to %liMB due to hardware anomaly 05000263\n", memory_end >> 20);
+	}
 #endif				/* CONFIG_DEBUG_HUNT_FOR_ZERO */
-	printk(KERN_NOTICE "Warning: limiting memory to %liMB due to hardware anomaly 05000263\n", memory_end >> 20);
 #endif				/* ANOMALY_05000263 */
 
 #if !defined(CONFIG_MTD_UCLINUX)
@@ -340,9 +343,6 @@
 	printk(KERN_INFO "Processor Speed: %lu MHz core clock and %lu Mhz System Clock\n",
 	       cclk / 1000000,  sclk / 1000000);
 
-	if (ANOMALY_05000273 && (cclk >> 1) <= sclk)
-		printk("\n\n\nANOMALY_05000273: CCLK must be >= 2*SCLK !!!\n\n\n");
-
 	printk(KERN_INFO "Board Memory: %ldMB\n", physical_mem_end >> 20);
 	printk(KERN_INFO "Kernel Managed Memory: %ldMB\n", _ramend >> 20);


