Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbXJ3Jfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbXJ3Jfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbXJ3Jeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:34:37 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:36640 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758304AbXJ3Jee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:34:34 -0400
Date: Tue, 30 Oct 2007 10:34:23 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] CRIS architecture: Correct compile errors
Message-ID: <20071030093423.GO11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected and improved NMI and IRQ handling.
Corrects compile errors and the following:

- Remove oldset parameter from do_signal and do_notify_resume.

- Modified to fit new consolidated IRQ handling code.

- Reverse check order between external nmi and watchdog nmi to avoid false
  watchdog oops in case of a glitch on the nmi pin.

- Return from an pin-generated NMI the same way as for other interrupts.

- Moved blocking of ethernet rx/tx irq from ethernet interrupt handler to
  low-level asm interrupt handlers.  Fixed in the multiple interrupt
  handler also.

- Add space for thread local storage in thread_info struct.

- Add NO_DMA to Kconfig, and include arch specific Kconfig using arch
  independent path. Include subsystem Kconfigs for pcmcia, usb, i2c,
  rtc and pci.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 arch/cris/Kconfig                  |   15 ++++++++-
 arch/cris/arch-v10/drivers/Kconfig |    1 
 arch/cris/arch-v10/kernel/entry.S  |   41 ++++++++++++-------------
 arch/cris/arch-v10/kernel/irq.c    |   59 +++++++++++++++++++++++++++++++++++--
 arch/cris/kernel/process.c         |    5 +++
 arch/cris/kernel/ptrace.c          |    6 +--
 include/asm-cris/thread_info.h     |    9 ++++-
 7 files changed, 107 insertions(+), 29 deletions(-)

diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/arch/cris/arch-v10/kernel/entry.S linux-2.6.23/arch/cris/arch-v10/kernel/entry.S
--- clean_linux-2.6.23/arch/cris/arch-v10/kernel/entry.S	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/arch-v10/kernel/entry.S	2007-10-17 11:15:19.000000000 +0200
@@ -500,9 +257,8 @@
 	;; deal with pending signals and notify-resume requests
 
 	move.d	$r9, $r10	; do_notify_resume syscall/irq param
-	moveq	0, $r11		; oldset param - 0 in this case
-	move.d	$sp, $r12	; the regs param
-	move.d  $r1, $r13	; the thread_info_flags parameter
+	move.d	$sp, $r11	; the regs param
+	move.d  $r1, $r12	; the thread_info_flags parameter
 	jsr	do_notify_resume
 	
 	ba _Rexit
@@ -678,13 +434,19 @@
 	push	$r10		; push orig_r10
 	clear.d [$sp=$sp-4]	; frametype == 0, normal frame
 
+	;; If there is a glitch on the NMI pin shorter than ~100ns 
+	;; (i.e. non-active by the time we get here) then the nmi_pin bit
+	;; in R_IRQ_MASK0_RD will already be cleared.  The watchdog_nmi bit
+	;; is cleared by us however (when feeding the watchdog), which is why
+	;; we use that bit to determine what brought us here.
+	
 	move.d	[R_IRQ_MASK0_RD], $r1 ; External NMI or watchdog?
-	and.d   0x80000000, $r1
-	beq	wdog
+	and.d   (1<<30), $r1
+	bne	wdog
 	move.d  $sp, $r10
 	jsr	handle_nmi
 	setf m			; Enable NMI again
-	retb			; Return from NMI
+	ba	_Rexit		; Return the standard way
 	nop
 wdog:
 #if defined(CONFIG_ETRAX_WATCHDOG) && !defined(CONFIG_SVINTO_SIM)
@@ -775,22 +537,9 @@
 	push	$r10		; push orig_r10
 	clear.d [$sp=$sp-4]	; frametype == 0, normal frame
 	
-	moveq	2, $r2		; first bit we care about is the timer0 irq
-	move.d	[R_VECT_MASK_RD], $r0; read the irq bits that triggered the multiple irq
-	move.d	$r0, [R_VECT_MASK_CLR] ; Block all active IRQs
-1:	
-	btst	$r2, $r0	; check for the irq given by bit r2
-	bpl	2f
-	move.d  $r2, $r10	; First argument to do_IRQ
-	move.d  $sp, $r11	; second argument to do_IRQ
-	jsr	do_IRQ
-2:
-	addq	1, $r2		; next vector bit
-	cmp.b	32, $r2
-	bne	1b	; process all irq's up to and including number 31
-	moveq	0, $r9  ; make ret_from_intr realise we came from an ir
+	move.d  $sp, $r10
+	jsr	do_multiple_IRQ
 	
-	move.d	$r0, [R_VECT_MASK_SET] ;  Unblock all the IRQs
 	jump    ret_from_intr
 
 do_sigtrap:
@@ -837,6 +586,13 @@
 	ba	do_sigtrap		; SIGTRAP the offending process. 
 	pop	$dccr			; Restore dccr in delay slot.
 	
+	.global kernel_execve
+kernel_execve:
+	move.d __NR_execve, $r9
+	break 13
+	ret
+	nop
+	
 	.data
 
 hw_bp_trigs:
diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/arch/cris/arch-v10/kernel/irq.c linux-2.6.23/arch/cris/arch-v10/kernel/irq.c
--- clean_linux-2.6.23/arch/cris/arch-v10/kernel/irq.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/arch-v10/kernel/irq.c	2007-10-22 13:43:39.000000000 +0200
@@ -12,10 +11,16 @@
  */
 
 #include <asm/irq.h>
+#include <asm/current.h>
 #include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 
+/* From kgdb.c. */
+extern void kgdb_init(void);
+extern void breakpoint(void);
+
 #define mask_irq(irq_nr) (*R_VECT_MASK_CLR = 1 << (irq_nr));
 #define unmask_irq(irq_nr) (*R_VECT_MASK_SET = 1 << (irq_nr));
 
@@ -75,8 +80,8 @@
 BUILD_IRQ(13, 0x2000)
 void mmu_bus_fault(void);      /* IRQ 14 is the bus fault interrupt */
 void multiple_interrupt(void); /* IRQ 15 is the multiple IRQ interrupt */
-BUILD_IRQ(16, 0x10000)
-BUILD_IRQ(17, 0x20000)
+BUILD_IRQ(16, 0x10000 | 0x20000)  /* ethernet tx interrupt needs to block rx */
+BUILD_IRQ(17, 0x20000 | 0x10000)  /* ...and vice versa */
 BUILD_IRQ(18, 0x40000)
 BUILD_IRQ(19, 0x80000)
 BUILD_IRQ(20, 0x100000)
@@ -147,6 +152,55 @@
 void do_sigtrap(void); /* from entry.S */
 void gdb_handle_breakpoint(void); /* from entry.S */
 
+extern void do_IRQ(int irq, struct pt_regs * regs);
+
+/* Handle multiple IRQs */
+void do_multiple_IRQ(struct pt_regs* regs)
+{
+	int bit;
+	unsigned masked;
+	unsigned mask;
+	unsigned ethmask = 0;
+	
+	/* Get interrupts to mask and handle */
+	mask = masked = *R_VECT_MASK_RD;
+	
+	/* Never mask timer IRQ */
+	mask &= ~(IO_MASK(R_VECT_MASK_RD, timer0));
+
+	/* 
+	 * If either ethernet interrupt (rx or tx) is active then block 
+	 * the other one too. Unblock afterwards also.
+	 */
+	if (mask & 
+	    (IO_STATE(R_VECT_MASK_RD, dma0, active) |
+	     IO_STATE(R_VECT_MASK_RD, dma1, active))) {
+		ethmask = (IO_MASK(R_VECT_MASK_RD, dma0) |
+			   IO_MASK(R_VECT_MASK_RD, dma1));
+	}
+
+	/* Block them */
+	*R_VECT_MASK_CLR = (mask | ethmask);
+
+	/* An extra irq_enter here to prevent softIRQs to run after
+	 * each do_IRQ. This will decrease the interrupt latency. 
+	 */
+	irq_enter();
+
+	/* Handle all IRQs */
+	for (bit = 2; bit < 32; bit++) {
+		if (masked & (1 << bit)) {
+			do_IRQ(bit, regs);
+		}
+	}
+
+	/* This irq_exit() will trigger the soft IRQs. */
+	irq_exit();
+
+	/* Unblock the IRQs again */
+	*R_VECT_MASK_SET = (masked | ethmask);
+}
+
 /* init_IRQ() is called by start_kernel and is responsible for fixing IRQ masks and
    setting the irq vector table.
 */
diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/arch/cris/kernel/process.c linux-2.6.23/arch/cris/kernel/process.c
--- clean_linux-2.6.23/arch/cris/kernel/process.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/kernel/process.c	2007-10-23 10:52:21.000000000 +0200
@@ -195,6 +95,11 @@
  */
 void (*pm_idle)(void);
 
+extern void default_idle(void);
+
+void (*pm_power_off)(void);
+EXPORT_SYMBOL(pm_power_off);
+
 /*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
--- clean_linux-2.6.23/arch/cris/arch-v10/drivers/Kconfig	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/arch-v10/drivers/Kconfig	2007-10-26 16:40:32.000000000 +0200
@@ -2,6 +2,7 @@
 	bool "Ethernet support"
 	depends on ETRAX_ARCH_V10
 	select NET_ETHERNET
+	select MII
 	help
 	  This option enables the ETRAX 100LX built-in 10/100Mbit Ethernet
 	  controller.
diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/include/asm-cris/thread_info.h linux-2.6.23/include/asm-cris/thread_info.h
--- clean_linux-2.6.23/include/asm-cris/thread_info.h	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/include/asm-cris/thread_info.h	2007-10-22 17:26:07.000000000 +0200
@@ -32,6 +32,7 @@
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	__u32			tls;		/* TLS for this thread */
 
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thead
@@ -79,14 +80,18 @@
  * - other flags in MSW
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_SIGPENDING		1	/* signal pending */
-#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
+#define TIF_SIGPENDING		2	/* signal pending */
+#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
--- clean_linux-2.6.23/arch/cris/kernel/ptrace.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/kernel/ptrace.c	2007-10-17 10:04:27.000000000 +0200
@@ -81,13 +27,13 @@
 /* notification of userspace execution resumption
  * - triggered by current->work.notify_resume
  */
-extern int do_signal(int canrestart, sigset_t *oldset, struct pt_regs *regs);
+extern int do_signal(int canrestart, struct pt_regs *regs);
 
 
-void do_notify_resume(int canrestart, sigset_t *oldset, struct pt_regs *regs, 
+void do_notify_resume(int canrestart, struct pt_regs *regs, 
 		      __u32 thread_info_flags  )
 {
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
-		do_signal(canrestart,oldset,regs);
+		do_signal(canrestart,regs);
 }
diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/arch/cris/Kconfig linux-2.6.23/arch/cris/Kconfig
--- clean_linux-2.6.23/arch/cris/Kconfig	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/Kconfig	2007-10-22 14:35:26.000000000 +0200
@@ -13,6 +13,10 @@
 	bool
 	default y
 
+config NO_DMA
+	bool
+	default y
+
 config RWSEM_GENERIC_SPINLOCK
 	bool
 	default y
@@ -149,7 +241,8 @@
 
 # bring in ETRAX built-in drivers
 menu "Drivers for built-in interfaces"
-source arch/cris/arch-v10/drivers/Kconfig
+# arch/cris/arch is a symlink to correct arch (arch-v10 or arch-v32)
+source arch/cris/arch/drivers/Kconfig
 
 endmenu
 
@@ -180,6 +273,10 @@
 
 source "drivers/telephony/Kconfig"
 
+source "drivers/i2c/Kconfig"
+
+source "drivers/rtc/Kconfig"
+
 #
 # input before char - char/joystick depends on it. As does USB.
 #
@@ -194,6 +291,10 @@
 
 source "sound/Kconfig"
 
+source "drivers/pcmcia/Kconfig"
+
+source "drivers/pci/Kconfig"
+
 source "drivers/usb/Kconfig"
 
 source "arch/cris/Kconfig.debug"

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
