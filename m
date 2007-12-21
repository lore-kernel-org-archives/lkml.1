Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbXLUKaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbXLUKaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 05:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXLUKan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 05:30:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42281 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXLUKal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 05:30:41 -0500
Date: Fri, 21 Dec 2007 11:27:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trond.myklebust@fys.uio.no, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-ID: <20071221102727.GB22452@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org> <20071220145415.f737e7f3.akpm@linux-foundation.org> <20071220234759.GA29776@elte.hu> <20071220161934.0f55029a.akpm@linux-foundation.org> <20071221003035.GA10123@elte.hu> <20071220164000.58c43b42.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220164000.58c43b42.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > raw_local_save_flags() doesn't disable interrupts?
> > 
> > argh. Indeed! (I wanted us to fix that misleading name eons ago, to 
> 
> The naming of those functions is truly awful and it goes back to year 0.
> 
> > *_save_flags_only(), but some stupid bikeshed painting discussion 
> > prevented it from ever happening.)
> 
> local_read_flags().
> 
> > that should have been raw_local_irq_save(flags)!
> 
> So raw_local_save_flags() and raw_local_irq_save() have different semantics.
> 
> omigawd, what have we done?

i really tried to get this fixed years ago - but did not think of 
local_read_flags as a solution. The patch below fixes this.

(if it's too burdensome to carry right now then i can regenerate this 
patch in 30 seconds in the 2.6.25 merge window - but please remind me 
then. Perhaps put in a patch into your queue that adds a comment to 
remind me :-) )

	Ingo

-------------->
Subject: rename: local_save_flags => local_read_flags
From: Ingo Molnar <mingo@elte.hu>

The bug in commit c0a698b744 could have been avoided if
local_save_flags and local_irq_save wasnt so similarly
named. The syntax is similar as well.

rename all local_save_flags variants to local_read_flags,
as suggested by Andrew Morton.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/cli-sti-removal.txt  |    4 ++--
 arch/cris/arch-v10/mm/fault.c      |    2 +-
 arch/cris/arch-v10/mm/tlb.c        |    2 +-
 arch/cris/arch-v32/kernel/time.c   |    2 +-
 arch/cris/arch-v32/kernel/traps.c  |    2 +-
 arch/powerpc/kernel/traps.c        |    2 +-
 arch/x86/kernel/apm_32.c           |    2 +-
 arch/x86/kernel/io_apic_32.c       |    2 +-
 arch/x86/kernel/io_apic_64.c       |    2 +-
 arch/x86/kernel/setup64.c          |    2 +-
 arch/xtensa/mm/tlb.c               |    6 +++---
 drivers/block/ataflop.c            |    2 +-
 drivers/scsi/arm/acornscsi.c       |    2 +-
 drivers/scsi/atari_NCR5380.c       |    2 +-
 drivers/scsi/sun3_NCR5380.c        |    2 +-
 drivers/serial/68328serial.c       |    2 +-
 drivers/serial/crisv10.c           |    2 +-
 drivers/serial/mcfserial.c         |    2 +-
 include/asm-alpha/system.h         |    2 +-
 include/asm-arm/irqflags.h         |    4 ++--
 include/asm-avr32/irqflags.h       |   10 +++++-----
 include/asm-blackfin/system.h      |    4 ++--
 include/asm-cris/arch-v10/system.h |    4 ++--
 include/asm-cris/arch-v32/system.h |    4 ++--
 include/asm-frv/system.h           |    8 ++++----
 include/asm-h8300/system.h         |    2 +-
 include/asm-ia64/system.h          |    6 +++---
 include/asm-m32r/system.h          |    4 ++--
 include/asm-m68k/system.h          |    6 +++---
 include/asm-m68knommu/system.h     |    6 +++---
 include/asm-mips/irqflags.h        |    6 +++---
 include/asm-parisc/system.h        |    4 ++--
 include/asm-powerpc/hw_irq.h       |    4 ++--
 include/asm-powerpc/irqflags.h     |    2 +-
 include/asm-powerpc/spinlock.h     |    2 +-
 include/asm-s390/irqflags.h        |    2 +-
 include/asm-sh/irqflags.h          |    8 ++++----
 include/asm-sh64/system.h          |    4 ++--
 include/asm-sparc/irqflags.h       |    2 +-
 include/asm-sparc64/irqflags.h     |   10 +++++-----
 include/asm-um/system-generic.h    |    8 ++++----
 include/asm-v850/system.h          |    6 +++---
 include/asm-x86/irqflags.h         |   12 ++++++------
 include/asm-x86/paravirt.h         |    4 ++--
 include/asm-xtensa/system.h        |    4 ++--
 include/linux/ide.h                |    2 +-
 include/linux/interrupt.h          |    2 +-
 include/linux/irqflags.h           |    4 ++--
 48 files changed, 94 insertions(+), 94 deletions(-)

Index: linux-x86.q/Documentation/cli-sti-removal.txt
===================================================================
--- linux-x86.q.orig/Documentation/cli-sti-removal.txt
+++ linux-x86.q/Documentation/cli-sti-removal.txt
@@ -96,7 +96,7 @@ released.
 drivers that want to disable local interrupts (interrupts on the
 current CPU), can use the following five macros:
 
-  local_irq_disable(), local_irq_enable(), local_save_flags(flags),
+  local_irq_disable(), local_irq_enable(), local_read_flags(flags),
   local_irq_save(flags), local_irq_restore(flags)
 
 but beware, their meaning and semantics are much simpler, far from
@@ -107,7 +107,7 @@ SMP meaning:
 
     local_irq_enable()        => turn local IRQs on
 
-    local_save_flags(flags)   => save the current IRQ state into flags. The
+    local_read_flags(flags)   => save the current IRQ state into flags. The
                                  state can be on or off. (on some
                                  architectures there's even more bits in it.)
 
Index: linux-x86.q/arch/cris/arch-v10/mm/fault.c
===================================================================
--- linux-x86.q.orig/arch/cris/arch-v10/mm/fault.c
+++ linux-x86.q/arch/cris/arch-v10/mm/fault.c
@@ -80,7 +80,7 @@ handle_mmu_bus_fault(struct pt_regs *reg
 	 * do_page_fault may have flushed the TLB so we have to restore
 	 * the MMU registers.
 	 */
-	local_save_flags(flags);
+	local_read_flags(flags);
 	local_irq_disable();
 	pmd = (pmd_t *)(pgd + pgd_index(address));
 	if (pmd_none(*pmd))
Index: linux-x86.q/arch/cris/arch-v10/mm/tlb.c
===================================================================
--- linux-x86.q.orig/arch/cris/arch-v10/mm/tlb.c
+++ linux-x86.q/arch/cris/arch-v10/mm/tlb.c
@@ -147,7 +147,7 @@ dump_tlb_all(void)
 	
 	printk("TLB dump. LO is: pfn | reserved | global | valid | kernel | we  |\n");
 
-	local_save_flags(flags);
+	local_read_flags(flags);
 	local_irq_disable();
 	for(i = 0; i < NUM_TLB_ENTRIES; i++) {
 		*R_TLB_SELECT = ( IO_FIELD(R_TLB_SELECT, index, i) );
Index: linux-x86.q/arch/cris/arch-v32/kernel/time.c
===================================================================
--- linux-x86.q.orig/arch/cris/arch-v32/kernel/time.c
+++ linux-x86.q/arch/cris/arch-v32/kernel/time.c
@@ -336,7 +336,7 @@ time_init(void)
 	   driver or infrastructure support yet.  */
         {
           unsigned long flags;
-          local_save_flags(flags);
+          local_read_flags(flags);
           flags |= (1<<30); /* NMI M flag is at bit 30 */
           local_irq_restore(flags);
         }
Index: linux-x86.q/arch/cris/arch-v32/kernel/traps.c
===================================================================
--- linux-x86.q.orig/arch/cris/arch-v32/kernel/traps.c
+++ linux-x86.q/arch/cris/arch-v32/kernel/traps.c
@@ -153,7 +153,7 @@ die_if_kernel(const char *str, struct pt
 void arch_enable_nmi(void)
 {
 	unsigned long flags;
-	local_save_flags(flags);
+	local_read_flags(flags);
 	flags |= (1<<30); /* NMI M flag is at bit 30 */
 	local_irq_restore(flags);
 }
Index: linux-x86.q/arch/powerpc/kernel/traps.c
===================================================================
--- linux-x86.q.orig/arch/powerpc/kernel/traps.c
+++ linux-x86.q/arch/powerpc/kernel/traps.c
@@ -122,7 +122,7 @@ int die(const char *str, struct pt_regs 
 		if (machine_is(powermac))
 			pmac_backlight_unblank();
 	} else {
-		local_save_flags(flags);
+		local_read_flags(flags);
 	}
 
 	if (++die.lock_owner_depth < 3) {
Index: linux-x86.q/arch/x86/kernel/apm_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/apm_32.c
+++ linux-x86.q/arch/x86/kernel/apm_32.c
@@ -535,7 +535,7 @@ static inline void apm_restore_cpus(cpum
 static inline unsigned long __apm_irq_save(void)
 {
 	unsigned long flags;
-	local_save_flags(flags);
+	local_read_flags(flags);
 	if (apm_info.allow_ints) {
 		if (irqs_disabled_flags(flags))
 			local_irq_enable();
Index: linux-x86.q/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/io_apic_32.c
+++ linux-x86.q/arch/x86/kernel/io_apic_32.c
@@ -1885,7 +1885,7 @@ static int __init timer_irq_works(void)
 	if (no_timer_check)
 		return 1;
 
-	local_save_flags(flags);
+	local_read_flags(flags);
 	local_irq_enable();
 	/* Let ten ticks pass... */
 	mdelay((10 * 1000) / HZ);
Index: linux-x86.q/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/io_apic_64.c
+++ linux-x86.q/arch/x86/kernel/io_apic_64.c
@@ -1284,7 +1284,7 @@ static int __init timer_irq_works(void)
 	unsigned long t1 = jiffies;
 	unsigned long flags;
 
-	local_save_flags(flags);
+	local_read_flags(flags);
 	local_irq_enable();
 	/* Let ten ticks pass... */
 	mdelay((10 * 1000) / HZ);
Index: linux-x86.q/arch/x86/kernel/setup64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/setup64.c
+++ linux-x86.q/arch/x86/kernel/setup64.c
@@ -292,5 +292,5 @@ void __cpuinit cpu_init (void)
 
 	fpu_init(); 
 
-	raw_local_save_flags(kernel_eflags);
+	raw_local_read_flags(kernel_eflags);
 }
Index: linux-x86.q/arch/xtensa/mm/tlb.c
===================================================================
--- linux-x86.q.orig/arch/xtensa/mm/tlb.c
+++ linux-x86.q/arch/xtensa/mm/tlb.c
@@ -65,7 +65,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 {
 	if (mm == current->active_mm) {
 		int flags;
-		local_save_flags(flags);
+		local_read_flags(flags);
 		__get_new_mmu_context(mm);
 		__load_mmu_context(mm);
 		local_irq_restore(flags);
@@ -95,7 +95,7 @@ void flush_tlb_range (struct vm_area_str
 	printk("[tlbrange<%02lx,%08lx,%08lx>]\n",
 			(unsigned long)mm->context, start, end);
 #endif
-	local_save_flags(flags);
+	local_read_flags(flags);
 
 	if (end-start + (PAGE_SIZE-1) <= _TLB_ENTRIES << PAGE_SHIFT) {
 		int oldpid = get_rasid_register();
@@ -129,7 +129,7 @@ void flush_tlb_page (struct vm_area_stru
 	if(mm->context == NO_CONTEXT)
 		return;
 
-	local_save_flags(flags);
+	local_read_flags(flags);
 
        	oldpid = get_rasid_register();
 
Index: linux-x86.q/drivers/block/ataflop.c
===================================================================
--- linux-x86.q.orig/drivers/block/ataflop.c
+++ linux-x86.q/drivers/block/ataflop.c
@@ -1476,7 +1476,7 @@ void do_fd_request(struct request_queue 
 	stdma_lock(floppy_irq, NULL);
 
 	atari_disable_irq( IRQ_MFP_FDC );
-	local_save_flags(flags);	/* The request function is called with ints
+	local_read_flags(flags);	/* The request function is called with ints
 	local_irq_disable();		 * disabled... so must save the IPL for later */ 
 	redo_fd_request();
 	local_irq_restore(flags);
Index: linux-x86.q/drivers/scsi/arm/acornscsi.c
===================================================================
--- linux-x86.q.orig/drivers/scsi/arm/acornscsi.c
+++ linux-x86.q/drivers/scsi/arm/acornscsi.c
@@ -316,7 +316,7 @@ acornscsi_csdelay(unsigned int cs)
 
     target_jiffies = jiffies + 1 + cs * HZ / 100;
 
-    local_save_flags(flags);
+    local_read_flags(flags);
     local_irq_enable();
 
     while (time_before(jiffies, target_jiffies)) barrier();
Index: linux-x86.q/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux-x86.q.orig/drivers/scsi/atari_NCR5380.c
+++ linux-x86.q/drivers/scsi/atari_NCR5380.c
@@ -1066,7 +1066,7 @@ static void NCR5380_main(struct work_str
 		return;
 	main_running = 1;
 
-	local_save_flags(flags);
+	local_read_flags(flags);
 	do {
 		local_irq_disable();	/* Freeze request queues */
 		done = 1;
Index: linux-x86.q/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux-x86.q.orig/drivers/scsi/sun3_NCR5380.c
+++ linux-x86.q/drivers/scsi/sun3_NCR5380.c
@@ -1063,7 +1063,7 @@ static void NCR5380_main (struct work_st
     	return;
     main_running = 1;
 
-    local_save_flags(flags);
+    local_read_flags(flags);
     do {
 	local_irq_disable(); /* Freeze request queues */
 	done = 1;
Index: linux-x86.q/drivers/serial/68328serial.c
===================================================================
--- linux-x86.q.orig/drivers/serial/68328serial.c
+++ linux-x86.q/drivers/serial/68328serial.c
@@ -746,7 +746,7 @@ static int rs_write(struct tty_struct * 
 	if (!tty || !info->xmit_buf)
 		return 0;
 
-	local_save_flags(flags);
+	local_read_flags(flags);
 	while (1) {
 		local_irq_disable();		
 		c = min_t(int, count, min(SERIAL_XMIT_SIZE - info->xmit_cnt - 1,
Index: linux-x86.q/drivers/serial/crisv10.c
===================================================================
--- linux-x86.q.orig/drivers/serial/crisv10.c
+++ linux-x86.q/drivers/serial/crisv10.c
@@ -3166,7 +3166,7 @@ static int rs_raw_write(struct tty_struc
 	SIMCOUT(buf, count);
 	return count;
 #endif
-	local_save_flags(flags);
+	local_read_flags(flags);
 	DFLOW(DEBUG_LOG(info->line, "write count %i ", count));
 	DFLOW(DEBUG_LOG(info->line, "ldisc %i\n", tty->ldisc.chars_in_buffer(tty)));
 
Index: linux-x86.q/drivers/serial/mcfserial.c
===================================================================
--- linux-x86.q.orig/drivers/serial/mcfserial.c
+++ linux-x86.q/drivers/serial/mcfserial.c
@@ -770,7 +770,7 @@ static int mcfrs_write(struct tty_struct
 	if (!tty || !info->xmit_buf)
 		return 0;
 	
-	local_save_flags(flags);
+	local_read_flags(flags);
 	while (1) {
 		local_irq_disable();		
 		c = min(count, (int) min(((int)SERIAL_XMIT_SIZE) - info->xmit_cnt - 1,
Index: linux-x86.q/include/asm-alpha/system.h
===================================================================
--- linux-x86.q.orig/include/asm-alpha/system.h
+++ linux-x86.q/include/asm-alpha/system.h
@@ -281,7 +281,7 @@ extern int __min_ipl;
 
 #define local_irq_disable()			do { setipl(IPL_MAX); barrier(); } while(0)
 #define local_irq_enable()			do { barrier(); setipl(IPL_MIN); } while(0)
-#define local_save_flags(flags)	((flags) = rdps())
+#define local_read_flags(flags)	((flags) = rdps())
 #define local_irq_save(flags)	do { (flags) = swpipl(IPL_MAX); barrier(); } while(0)
 #define local_irq_restore(flags)	do { barrier(); setipl(flags); barrier(); } while(0)
 
Index: linux-x86.q/include/asm-arm/irqflags.h
===================================================================
--- linux-x86.q.orig/include/asm-arm/irqflags.h
+++ linux-x86.q/include/asm-arm/irqflags.h
@@ -106,10 +106,10 @@
 /*
  * Save the current interrupt enable state.
  */
-#define raw_local_save_flags(x)					\
+#define raw_local_read_flags(x)					\
 	({							\
 	__asm__ __volatile__(					\
-	"mrs	%0, cpsr		@ local_save_flags"	\
+	"mrs	%0, cpsr		@ local_read_flags"	\
 	: "=r" (x) : : "memory", "cc");				\
 	})
 
Index: linux-x86.q/include/asm-avr32/irqflags.h
===================================================================
--- linux-x86.q.orig/include/asm-avr32/irqflags.h
+++ linux-x86.q/include/asm-avr32/irqflags.h
@@ -10,13 +10,13 @@
 
 #include <asm/sysreg.h>
 
-static inline unsigned long __raw_local_save_flags(void)
+static inline unsigned long __raw_local_read_flags(void)
 {
 	return sysreg_read(SR);
 }
 
-#define raw_local_save_flags(x)					\
-	do { (x) = __raw_local_save_flags(); } while (0)
+#define raw_local_read_flags(x)					\
+	do { (x) = __raw_local_read_flags(); } while (0)
 
 /*
  * This will restore ALL status register flags, not only the interrupt
@@ -48,14 +48,14 @@ static inline int raw_irqs_disabled_flag
 
 static inline int raw_irqs_disabled(void)
 {
-	unsigned long flags = __raw_local_save_flags();
+	unsigned long flags = __raw_local_read_flags();
 
 	return raw_irqs_disabled_flags(flags);
 }
 
 static inline unsigned long __raw_local_irq_save(void)
 {
-	unsigned long flags = __raw_local_save_flags();
+	unsigned long flags = __raw_local_read_flags();
 
 	raw_local_irq_disable();
 
Index: linux-x86.q/include/asm-blackfin/system.h
===================================================================
--- linux-x86.q.orig/include/asm-blackfin/system.h
+++ linux-x86.q/include/asm-blackfin/system.h
@@ -92,7 +92,7 @@ extern unsigned long irq_flags;
 	)
 #endif
 
-#define local_save_flags(x) \
+#define local_read_flags(x) \
 	__asm__ __volatile__( \
 		"cli %0;" \
 		"sti %0;" \
@@ -117,7 +117,7 @@ extern unsigned long irq_flags;
 #define	irqs_disabled()				\
 ({						\
 	unsigned long flags;			\
-	local_save_flags(flags);		\
+	local_read_flags(flags);		\
 	!irqs_enabled_from_flags(flags);	\
 })
 
Index: linux-x86.q/include/asm-cris/arch-v10/system.h
===================================================================
--- linux-x86.q.orig/include/asm-cris/arch-v10/system.h
+++ linux-x86.q/include/asm-cris/arch-v10/system.h
@@ -45,7 +45,7 @@ struct __xchg_dummy { unsigned long a[10
 #define __xg(x) ((struct __xchg_dummy *)(x))
 
 /* interrupt control.. */
-#define local_save_flags(x)	__asm__ __volatile__ ("move $ccr,%0" : "=rm" (x) : : "memory");
+#define local_read_flags(x)	__asm__ __volatile__ ("move $ccr,%0" : "=rm" (x) : : "memory");
 #define local_irq_restore(x) 	__asm__ __volatile__ ("move %0,$ccr" : : "rm" (x) : "memory");
 #define local_irq_disable() 	__asm__ __volatile__ ( "di" : : :"memory");
 #define local_irq_enable()	__asm__ __volatile__ ( "ei" : : :"memory");
@@ -53,7 +53,7 @@ struct __xchg_dummy { unsigned long a[10
 #define irqs_disabled()			\
 ({					\
 	unsigned long flags;		\
-	local_save_flags(flags);	\
+	local_read_flags(flags);	\
 	!(flags & (1<<5));		\
 })
 
Index: linux-x86.q/include/asm-cris/arch-v32/system.h
===================================================================
--- linux-x86.q.orig/include/asm-cris/arch-v32/system.h
+++ linux-x86.q/include/asm-cris/arch-v32/system.h
@@ -45,7 +45,7 @@ struct __xchg_dummy { unsigned long a[10
 #define __xg(x) ((struct __xchg_dummy *)(x))
 
 /* Used for interrupt control. */
-#define local_save_flags(x) \
+#define local_read_flags(x) \
 	__asm__ __volatile__ ("move $ccs, %0" : "=rm" (x) : : "memory");
 
 #define local_irq_restore(x) \
@@ -58,7 +58,7 @@ struct __xchg_dummy { unsigned long a[10
 ({				\
 	unsigned long flags;	\
 				\
-	local_save_flags(flags);\
+	local_read_flags(flags);\
 	!(flags & (1 << I_CCS_BITNR));	\
 })
 
Index: linux-x86.q/include/asm-frv/system.h
===================================================================
--- linux-x86.q.orig/include/asm-frv/system.h
+++ linux-x86.q/include/asm-frv/system.h
@@ -70,7 +70,7 @@ do {								\
 		     );						\
 } while(0)
 
-#define local_save_flags(flags)					\
+#define local_read_flags(flags)					\
 do {								\
 	typecheck(unsigned long, flags);			\
 	asm volatile("movsg ccr,%0"				\
@@ -86,12 +86,12 @@ do {								\
 } while(0)
 
 #define irqs_disabled() \
-	({unsigned long flags; local_save_flags(flags); flags; })
+	({unsigned long flags; local_read_flags(flags); flags; })
 
 #define	local_irq_save(flags)			\
 do {						\
 	typecheck(unsigned long, flags);	\
-	local_save_flags(flags);		\
+	local_read_flags(flags);		\
 	local_irq_disable();			\
 } while(0)
 
@@ -137,7 +137,7 @@ do {							\
 		     : "memory");			\
 } while(0)
 
-#define __local_save_flags(flags)		\
+#define __local_read_flags(flags)		\
 do {						\
 	typecheck(unsigned long, flags);	\
 	asm("movsg psr,%0"			\
Index: linux-x86.q/include/asm-h8300/system.h
===================================================================
--- linux-x86.q.orig/include/asm-h8300/system.h
+++ linux-x86.q/include/asm-h8300/system.h
@@ -72,7 +72,7 @@ asmlinkage void resume(void);
 #define local_irq_enable()      __sti()
 #define local_irq_save(x)	({ __save_flags(x); local_irq_disable(); })
 #define local_irq_restore(x)	__restore_flags(x)
-#define local_save_flags(x)     __save_flags(x)
+#define local_read_flags(x)     __save_flags(x)
 
 /*
  * Force strict CPU ordering.
Index: linux-x86.q/include/asm-ia64/system.h
===================================================================
--- linux-x86.q.orig/include/asm-ia64/system.h
+++ linux-x86.q/include/asm-ia64/system.h
@@ -160,7 +160,7 @@ do {								\
 do {								\
 	unsigned long old_psr, psr = (x);			\
 								\
-	local_save_flags(old_psr);				\
+	local_read_flags(old_psr);				\
 	__local_irq_restore(psr);				\
 	if ((old_psr & IA64_PSR_I) && !(psr & IA64_PSR_I))	\
 		__save_ip();					\
@@ -173,12 +173,12 @@ do {								\
 #endif /* !CONFIG_IA64_DEBUG_IRQ */
 
 #define local_irq_enable()	({ ia64_stop(); ia64_ssm(IA64_PSR_I); ia64_srlz_d(); })
-#define local_save_flags(flags)	({ ia64_stop(); (flags) = ia64_getreg(_IA64_REG_PSR); })
+#define local_read_flags(flags)	({ ia64_stop(); (flags) = ia64_getreg(_IA64_REG_PSR); })
 
 #define irqs_disabled()				\
 ({						\
 	unsigned long __ia64_id_flags;		\
-	local_save_flags(__ia64_id_flags);	\
+	local_read_flags(__ia64_id_flags);	\
 	(__ia64_id_flags & IA64_PSR_I) == 0;	\
 })
 
Index: linux-x86.q/include/asm-m32r/system.h
===================================================================
--- linux-x86.q.orig/include/asm-m32r/system.h
+++ linux-x86.q/include/asm-m32r/system.h
@@ -84,7 +84,7 @@ static inline void local_irq_disable(voi
 }
 #endif	/* CONFIG_CHIP_M32102 || CONFIG_CHIP_M32104 */
 
-#define local_save_flags(x) \
+#define local_read_flags(x) \
 	__asm__ __volatile__("mvfc %0,psw" : "=r"(x) : /* no input */)
 
 #define local_irq_restore(x) \
@@ -115,7 +115,7 @@ static inline void local_irq_disable(voi
 #define irqs_disabled()					\
 	({						\
 		unsigned long flags;			\
-		local_save_flags(flags);		\
+		local_read_flags(flags);		\
 		!(flags & 0x40);			\
 	})
 
Index: linux-x86.q/include/asm-m68k/system.h
===================================================================
--- linux-x86.q.orig/include/asm-m68k/system.h
+++ linux-x86.q/include/asm-m68k/system.h
@@ -73,18 +73,18 @@ asmlinkage void resume(void);
 })
 #endif
 #define local_irq_disable() asm volatile ("oriw  #0x0700,%%sr": : : "memory")
-#define local_save_flags(x) asm volatile ("movew %%sr,%0":"=d" (x) : : "memory")
+#define local_read_flags(x) asm volatile ("movew %%sr,%0":"=d" (x) : : "memory")
 #define local_irq_restore(x) asm volatile ("movew %0,%%sr": :"d" (x) : "memory")
 
 static inline int irqs_disabled(void)
 {
 	unsigned long flags;
-	local_save_flags(flags);
+	local_read_flags(flags);
 	return flags & ~ALLOWINT;
 }
 
 /* For spinlocks etc */
-#define local_irq_save(x)	({ local_save_flags(x); local_irq_disable(); })
+#define local_irq_save(x)	({ local_read_flags(x); local_irq_disable(); })
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
Index: linux-x86.q/include/asm-m68knommu/system.h
===================================================================
--- linux-x86.q.orig/include/asm-m68knommu/system.h
+++ linux-x86.q/include/asm-m68knommu/system.h
@@ -79,18 +79,18 @@ asmlinkage void resume(void);
 #define local_irq_disable() asm volatile ("oriw  #0x0700,%%sr": : : "memory")
 #endif
 
-#define local_save_flags(x) asm volatile ("movew %%sr,%0":"=d" (x) : : "memory")
+#define local_read_flags(x) asm volatile ("movew %%sr,%0":"=d" (x) : : "memory")
 #define local_irq_restore(x) asm volatile ("movew %0,%%sr": :"d" (x) : "memory")
 
 /* For spinlocks etc */
 #ifndef local_irq_save
-#define local_irq_save(x) do { local_save_flags(x); local_irq_disable(); } while (0)
+#define local_irq_save(x) do { local_read_flags(x); local_irq_disable(); } while (0)
 #endif
 
 #define	irqs_disabled()			\
 ({					\
 	unsigned long flags;		\
-	local_save_flags(flags);	\
+	local_read_flags(flags);	\
 	((flags & 0x0700) == 0x0700);	\
 })
 
Index: linux-x86.q/include/asm-mips/irqflags.h
===================================================================
--- linux-x86.q.orig/include/asm-mips/irqflags.h
+++ linux-x86.q/include/asm-mips/irqflags.h
@@ -97,7 +97,7 @@ static inline void raw_local_irq_disable
 }
 
 __asm__(
-	"	.macro	raw_local_save_flags flags			\n"
+	"	.macro	raw_local_read_flags flags			\n"
 	"	.set	push						\n"
 	"	.set	reorder						\n"
 #ifdef CONFIG_MIPS_MT_SMTC
@@ -108,9 +108,9 @@ __asm__(
 	"	.set	pop						\n"
 	"	.endm							\n");
 
-#define raw_local_save_flags(x)						\
+#define raw_local_read_flags(x)						\
 __asm__ __volatile__(							\
-	"raw_local_save_flags %0"					\
+	"raw_local_read_flags %0"					\
 	: "=r" (x))
 
 __asm__(
Index: linux-x86.q/include/asm-parisc/system.h
===================================================================
--- linux-x86.q.orig/include/asm-parisc/system.h
+++ linux-x86.q/include/asm-parisc/system.h
@@ -49,7 +49,7 @@ extern struct task_struct *_switch_to(st
 } while(0)
 
 /* interrupt control */
-#define local_save_flags(x)	__asm__ __volatile__("ssm 0, %0" : "=r" (x) : : "memory")
+#define local_read_flags(x)	__asm__ __volatile__("ssm 0, %0" : "=r" (x) : : "memory")
 #define local_irq_disable()	__asm__ __volatile__("rsm %0,%%r0\n" : : "i" (PSW_I) : "memory" )
 #define local_irq_enable()	__asm__ __volatile__("ssm %0,%%r0\n" : : "i" (PSW_I) : "memory" )
 
@@ -61,7 +61,7 @@ extern struct task_struct *_switch_to(st
 #define irqs_disabled()			\
 ({					\
 	unsigned long flags;		\
-	local_save_flags(flags);	\
+	local_read_flags(flags);	\
 	(flags & PSW_I) == 0;		\
 })
 
Index: linux-x86.q/include/asm-powerpc/hw_irq.h
===================================================================
--- linux-x86.q.orig/include/asm-powerpc/hw_irq.h
+++ linux-x86.q/include/asm-powerpc/hw_irq.h
@@ -43,7 +43,7 @@ extern void local_irq_restore(unsigned l
 extern void iseries_handle_interrupts(void);
 
 #define local_irq_enable()	local_irq_restore(1)
-#define local_save_flags(flags)	((flags) = local_get_flags())
+#define local_read_flags(flags)	((flags) = local_get_flags())
 #define local_irq_save(flags)	((flags) = local_irq_disable())
 
 #define irqs_disabled()		(local_get_flags() == 0)
@@ -105,7 +105,7 @@ static inline void local_irq_save_ptr(un
 	__asm__ __volatile__("": : :"memory");
 }
 
-#define local_save_flags(flags)	((flags) = mfmsr())
+#define local_read_flags(flags)	((flags) = mfmsr())
 #define local_irq_save(flags)	local_irq_save_ptr(&flags)
 #define irqs_disabled()		((mfmsr() & MSR_EE) == 0)
 
Index: linux-x86.q/include/asm-powerpc/irqflags.h
===================================================================
--- linux-x86.q.orig/include/asm-powerpc/irqflags.h
+++ linux-x86.q/include/asm-powerpc/irqflags.h
@@ -11,7 +11,7 @@
 #define _ASM_IRQFLAGS_H
 
 /*
- * Get definitions for raw_local_save_flags(x), etc.
+ * Get definitions for raw_local_read_flags(x), etc.
  */
 #include <asm-powerpc/hw_irq.h>
 
Index: linux-x86.q/include/asm-powerpc/spinlock.h
===================================================================
--- linux-x86.q.orig/include/asm-powerpc/spinlock.h
+++ linux-x86.q/include/asm-powerpc/spinlock.h
@@ -126,7 +126,7 @@ static void __inline__ __raw_spin_lock_f
 	while (1) {
 		if (likely(__spin_trylock(lock) == 0))
 			break;
-		local_save_flags(flags_dis);
+		local_read_flags(flags_dis);
 		local_irq_restore(flags);
 		do {
 			HMT_low();
Index: linux-x86.q/include/asm-s390/irqflags.h
===================================================================
--- linux-x86.q.orig/include/asm-s390/irqflags.h
+++ linux-x86.q/include/asm-s390/irqflags.h
@@ -83,7 +83,7 @@ static inline unsigned long raw_local_ir
 	return __raw_local_irq_stnsm(0xfc);
 }
 
-#define raw_local_save_flags(x)						\
+#define raw_local_read_flags(x)						\
 do {									\
 	typecheck(unsigned long, x);					\
 	(x) = __raw_local_irq_stosm(0x00);				\
Index: linux-x86.q/include/asm-sh/irqflags.h
===================================================================
--- linux-x86.q.orig/include/asm-sh/irqflags.h
+++ linux-x86.q/include/asm-sh/irqflags.h
@@ -62,7 +62,7 @@ static inline void clear_bl_bit(void)
 	);
 }
 
-static inline unsigned long __raw_local_save_flags(void)
+static inline unsigned long __raw_local_read_flags(void)
 {
 	unsigned long flags;
 
@@ -77,8 +77,8 @@ static inline unsigned long __raw_local_
 	return flags;
 }
 
-#define raw_local_save_flags(flags) \
-		do { (flags) = __raw_local_save_flags(); } while (0)
+#define raw_local_read_flags(flags) \
+		do { (flags) = __raw_local_read_flags(); } while (0)
 
 static inline int raw_irqs_disabled_flags(unsigned long flags)
 {
@@ -87,7 +87,7 @@ static inline int raw_irqs_disabled_flag
 
 static inline int raw_irqs_disabled(void)
 {
-	unsigned long flags = __raw_local_save_flags();
+	unsigned long flags = __raw_local_read_flags();
 
 	return raw_irqs_disabled_flags(flags);
 }
Index: linux-x86.q/include/asm-sh64/system.h
===================================================================
--- linux-x86.q.orig/include/asm-sh64/system.h
+++ linux-x86.q/include/asm-sh64/system.h
@@ -96,7 +96,7 @@ static __inline__ void local_irq_disable
 			     : "r" (__dummy1));
 }
 
-#define local_save_flags(x) 						\
+#define local_read_flags(x) 						\
 (__extension__ ({	unsigned long long __dummy=SR_MASK_LL;		\
 	__asm__ __volatile__(						\
 		"getcon	" __SR ", %0\n\t"				\
@@ -123,7 +123,7 @@ static __inline__ void local_irq_disable
 #define irqs_disabled()			\
 ({					\
 	unsigned long flags;		\
-	local_save_flags(flags);	\
+	local_read_flags(flags);	\
 	(flags != 0);			\
 })
 
Index: linux-x86.q/include/asm-sparc/irqflags.h
===================================================================
--- linux-x86.q.orig/include/asm-sparc/irqflags.h
+++ linux-x86.q/include/asm-sparc/irqflags.h
@@ -24,7 +24,7 @@ static inline unsigned long getipl(void)
         return retval;
 }
 
-#define raw_local_save_flags(flags) ((flags) = getipl())
+#define raw_local_read_flags(flags) ((flags) = getipl())
 #define raw_local_irq_save(flags)   ((flags) = __raw_local_irq_save())
 #define raw_local_irq_disable()     ((void) __raw_local_irq_save())
 #define raw_irqs_disabled()         ((getipl() & PSR_PIL) != 0)
Index: linux-x86.q/include/asm-sparc64/irqflags.h
===================================================================
--- linux-x86.q.orig/include/asm-sparc64/irqflags.h
+++ linux-x86.q/include/asm-sparc64/irqflags.h
@@ -12,7 +12,7 @@
 
 #ifndef __ASSEMBLY__
 
-static inline unsigned long __raw_local_save_flags(void)
+static inline unsigned long __raw_local_read_flags(void)
 {
 	unsigned long flags;
 
@@ -24,8 +24,8 @@ static inline unsigned long __raw_local_
 	return flags;
 }
 
-#define raw_local_save_flags(flags) \
-		do { (flags) = __raw_local_save_flags(); } while (0)
+#define raw_local_read_flags(flags) \
+		do { (flags) = __raw_local_read_flags(); } while (0)
 
 static inline void raw_local_irq_restore(unsigned long flags)
 {
@@ -64,7 +64,7 @@ static inline int raw_irqs_disabled_flag
 
 static inline int raw_irqs_disabled(void)
 {
-	unsigned long flags = __raw_local_save_flags();
+	unsigned long flags = __raw_local_read_flags();
 
 	return raw_irqs_disabled_flags(flags);
 }
@@ -74,7 +74,7 @@ static inline int raw_irqs_disabled(void
  */
 static inline unsigned long __raw_local_irq_save(void)
 {
-	unsigned long flags = __raw_local_save_flags();
+	unsigned long flags = __raw_local_read_flags();
 
 	raw_local_irq_disable();
 
Index: linux-x86.q/include/asm-um/system-generic.h
===================================================================
--- linux-x86.q.orig/include/asm-um/system-generic.h
+++ linux-x86.q/include/asm-um/system-generic.h
@@ -8,7 +8,7 @@
 #undef local_irq_restore
 #undef local_irq_disable
 #undef local_irq_enable
-#undef local_save_flags
+#undef local_read_flags
 #undef local_irq_restore
 #undef local_irq_enable
 #undef local_irq_disable
@@ -23,12 +23,12 @@ extern int get_signals(void);
 extern void block_signals(void);
 extern void unblock_signals(void);
 
-#define local_save_flags(flags) do { typecheck(unsigned long, flags); \
+#define local_read_flags(flags) do { typecheck(unsigned long, flags); \
 				     (flags) = get_signals(); } while(0)
 #define local_irq_restore(flags) do { typecheck(unsigned long, flags); \
 				      set_signals(flags); } while(0)
 
-#define local_irq_save(flags) do { local_save_flags(flags); \
+#define local_irq_save(flags) do { local_read_flags(flags); \
                                    local_irq_disable(); } while(0)
 
 #define local_irq_enable() unblock_signals()
@@ -37,7 +37,7 @@ extern void unblock_signals(void);
 #define irqs_disabled()                 \
 ({                                      \
         unsigned long flags;            \
-        local_save_flags(flags);        \
+        local_read_flags(flags);        \
         (flags == 0);                   \
 })
 
Index: linux-x86.q/include/asm-v850/system.h
===================================================================
--- linux-x86.q.orig/include/asm-v850/system.h
+++ linux-x86.q/include/asm-v850/system.h
@@ -37,14 +37,14 @@ extern void *switch_thread (struct threa
 #define local_irq_enable()	__asm__ __volatile__ ("ei")
 #define local_irq_disable()	__asm__ __volatile__ ("di")
 
-#define local_save_flags(flags) \
+#define local_read_flags(flags) \
   __asm__ __volatile__ ("stsr %1, %0" : "=r" (flags) : "i" (SR_PSW))
 #define local_restore_flags(flags) \
   __asm__ __volatile__ ("ldsr %0, %1" :: "r" (flags), "i" (SR_PSW))
 
 /* For spinlocks etc */
 #define	local_irq_save(flags) \
-  do { local_save_flags (flags); local_irq_disable (); } while (0) 
+  do { local_read_flags (flags); local_irq_disable (); } while (0) 
 #define local_irq_restore(flags) \
   local_restore_flags (flags);
 
@@ -52,7 +52,7 @@ extern void *switch_thread (struct threa
 static inline int irqs_disabled (void)
 {
 	unsigned flags;
-	local_save_flags (flags);
+	local_read_flags (flags);
 	return !!(flags & 0x20);
 }
 
Index: linux-x86.q/include/asm-x86/irqflags.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/irqflags.h
+++ linux-x86.q/include/asm-x86/irqflags.h
@@ -60,7 +60,7 @@ static inline void native_halt(void)
 #else
 #ifndef __ASSEMBLY__
 
-static inline unsigned long __raw_local_save_flags(void)
+static inline unsigned long __raw_local_read_flags(void)
 {
 	return native_save_fl();
 }
@@ -103,7 +103,7 @@ static inline void halt(void)
  */
 static inline unsigned long __raw_local_irq_save(void)
 {
-	unsigned long flags = __raw_local_save_flags();
+	unsigned long flags = __raw_local_read_flags();
 
 	raw_local_irq_disable();
 
@@ -131,8 +131,8 @@ static inline unsigned long __raw_local_
 #endif /* CONFIG_PARAVIRT */
 
 #ifndef __ASSEMBLY__
-#define raw_local_save_flags(flags) \
-		do { (flags) = __raw_local_save_flags(); } while (0)
+#define raw_local_read_flags(flags) \
+		do { (flags) = __raw_local_read_flags(); } while (0)
 
 #define raw_local_irq_save(flags) \
 		do { (flags) = __raw_local_irq_save(); } while (0)
@@ -144,7 +144,7 @@ static inline int raw_irqs_disabled_flag
 
 static inline int raw_irqs_disabled(void)
 {
-	unsigned long flags = __raw_local_save_flags();
+	unsigned long flags = __raw_local_read_flags();
 
 	return raw_irqs_disabled_flags(flags);
 }
@@ -165,7 +165,7 @@ static inline void trace_hardirqs_fixup_
 
 static inline void trace_hardirqs_fixup(void)
 {
-	unsigned long flags = __raw_local_save_flags();
+	unsigned long flags = __raw_local_read_flags();
 
 	trace_hardirqs_fixup_flags(flags);
 }
Index: linux-x86.q/include/asm-x86/paravirt.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/paravirt.h
+++ linux-x86.q/include/asm-x86/paravirt.h
@@ -1124,7 +1124,7 @@ extern struct paravirt_patch_site __para
 #define PV_FLAGS_ARG "D"
 #endif
 
-static inline unsigned long __raw_local_save_flags(void)
+static inline unsigned long __raw_local_read_flags(void)
 {
 	unsigned long f;
 
@@ -1176,7 +1176,7 @@ static inline unsigned long __raw_local_
 {
 	unsigned long f;
 
-	f = __raw_local_save_flags();
+	f = __raw_local_read_flags();
 	raw_local_irq_disable();
 	return f;
 }
Index: linux-x86.q/include/asm-xtensa/system.h
===================================================================
--- linux-x86.q.orig/include/asm-xtensa/system.h
+++ linux-x86.q/include/asm-xtensa/system.h
@@ -17,7 +17,7 @@
 
 /* interrupt control */
 
-#define local_save_flags(x)						\
+#define local_read_flags(x)						\
 	__asm__ __volatile__ ("rsr %0,"__stringify(PS) : "=a" (x));
 #define local_irq_restore(x)	do {					\
 	__asm__ __volatile__ ("wsr %0, "__stringify(PS)" ; rsync" 	\
@@ -42,7 +42,7 @@ static inline void local_irq_enable(void
 static inline int irqs_disabled(void)
 {
 	unsigned long flags;
-	local_save_flags(flags);
+	local_read_flags(flags);
 	return flags & 0xf;
 }
 
Index: linux-x86.q/include/linux/ide.h
===================================================================
--- linux-x86.q.orig/include/linux/ide.h
+++ linux-x86.q/include/linux/ide.h
@@ -1394,7 +1394,7 @@ extern struct mutex ide_cfg_mtx;
  * ide_drive_t->hwif: constant, no locking
  */
 
-#define local_irq_set(flags)	do { local_save_flags((flags)); local_irq_enable_in_hardirq(); } while (0)
+#define local_irq_set(flags)	do { local_read_flags((flags)); local_irq_enable_in_hardirq(); } while (0)
 
 extern struct bus_type ide_bus_type;
 
Index: linux-x86.q/include/linux/interrupt.h
===================================================================
--- linux-x86.q.orig/include/linux/interrupt.h
+++ linux-x86.q/include/linux/interrupt.h
@@ -213,7 +213,7 @@ static inline void __deprecated sti(void
 }
 static inline void __deprecated save_flags(unsigned long *x)
 {
-	local_save_flags(*x);
+	local_read_flags(*x);
 }
 #define save_flags(x) save_flags(&x)
 static inline void __deprecated restore_flags(unsigned long x)
Index: linux-x86.q/include/linux/irqflags.h
===================================================================
--- linux-x86.q.orig/include/linux/irqflags.h
+++ linux-x86.q/include/linux/irqflags.h
@@ -80,13 +80,13 @@
 		raw_safe_halt();				\
 	} while (0)
 
-#define local_save_flags(flags)		raw_local_save_flags(flags)
+#define local_read_flags(flags)		raw_local_read_flags(flags)
 
 #define irqs_disabled()						\
 ({								\
 	unsigned long flags;					\
 								\
-	raw_local_save_flags(flags);				\
+	raw_local_read_flags(flags);				\
 	raw_irqs_disabled_flags(flags);				\
 })
 
