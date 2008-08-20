Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYHTBnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYHTBnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYHTBnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:43:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:48906 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbYHTBnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:43:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,238,1217833200"; 
   d="scan'208";a="35503980"
Subject: [PATCH -mm -v2 2/2] Fix a race condtion of oops_in_progress
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 20 Aug 2008 09:42:58 +0800
Message-Id: <1219196578.5663.129.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a race condition of oops_in_progress. Which may be
changed on multiple CPU simultaneously, but it is changed via
non-atomic operation ++/--. This patch changes the definition of
oops_in_process from int to atomic_t, and accessing method to atomic
operations.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/blackfin/kernel/traps.c            |   14 +++++++-------
 arch/cris/arch-v32/kernel/time.c        |    4 ++--
 arch/cris/kernel/traps.c                |    6 +++---
 arch/cris/mm/fault.c                    |    6 +++---
 arch/ia64/kernel/mca.c                  |    6 +++---
 arch/mn10300/mm/fault.c                 |    4 ++--
 arch/parisc/kernel/traps.c              |    4 ++--
 arch/s390/kernel/setup.c                |    6 +++---
 arch/s390/mm/fault.c                    |    4 ++--
 drivers/char/vt.c                       |    2 +-
 drivers/mtd/mtdoops.c                   |    2 +-
 drivers/parisc/led.c                    |    2 +-
 drivers/serial/8250.c                   |    2 +-
 drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
 drivers/serial/sunhv.c                  |    4 ++--
 drivers/serial/sunsab.c                 |    2 +-
 drivers/serial/sunsu.c                  |    2 +-
 drivers/serial/sunzilog.c               |    2 +-
 drivers/serial/uartlite.c               |    4 ++--
 drivers/video/aty/radeonfb.h            |    2 +-
 include/linux/console.h                 |    3 ++-
 include/linux/kernel.h                  |    4 +++-
 kernel/printk.c                         |   10 +++++-----
 kernel/sched.c                          |    3 ++-
 lib/bust_spinlocks.c                    |    4 ++--
 25 files changed, 54 insertions(+), 50 deletions(-)

--- a/lib/bust_spinlocks.c
+++ b/lib/bust_spinlocks.c
@@ -17,12 +17,12 @@
 void __attribute__((weak)) bust_spinlocks(int yes)
 {
 	if (yes) {
-		++oops_in_progress;
+		atomic_inc(&oops_in_progress);
 	} else {
 #ifdef CONFIG_VT
 		unblank_screen();
 #endif
-		if (--oops_in_progress == 0)
+		if (atomic_dec_and_test(&oops_in_progress))
 			wake_up_klogd();
 	}
 }
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -183,7 +183,7 @@ done:
 asmlinkage void double_fault_c(struct pt_regs *fp)
 {
 	console_verbose();
-	oops_in_progress = 1;
+	atomic_set(&oops_in_progress, 1);
 	printk(KERN_EMERG "\n" KERN_EMERG "Double Fault\n");
 	dump_bfin_process(fp);
 	dump_bfin_mem(fp);
@@ -221,11 +221,11 @@ asmlinkage void trap_c(struct pt_regs *f
 #endif
 	){
 		console_verbose();
-		oops_in_progress = 1;
+		atomic_set(&oops_in_progress, 1);
 	} else if (current) {
 		if (current->mm == NULL) {
 			console_verbose();
-			oops_in_progress = 1;
+			atomic_set(&oops_in_progress, 1);
 		}
 	}
 
@@ -510,7 +510,7 @@ asmlinkage void trap_c(struct pt_regs *f
 #endif
 			dump_bfin_trace_buffer();
 
-		if (oops_in_progress) {
+		if (atomic_read(&oops_in_progress)) {
 			/* Dump the current kernel stack */
 			printk(KERN_NOTICE "\n" KERN_NOTICE "Kernel Stack\n");
 			show_stack(current, NULL);
@@ -852,7 +852,7 @@ void dump_bfin_process(struct pt_regs *f
 	 * stack all the time, so do this until we fix that */
 	unsigned int context = bfin_read_IPEND();
 
-	if (oops_in_progress)
+	if (atomic_read(&oops_in_progress))
 		printk(KERN_EMERG "Kernel OOPS in progress\n");
 
 	if (context & 0x0020 && (fp->seqstat & SEQSTAT_EXCAUSE) == VEC_HWERR)
@@ -934,7 +934,7 @@ void dump_bfin_mem(struct pt_regs *fp)
 
 	/* Hardware error interrupts can be deferred */
 	if (unlikely(sti && (fp->seqstat & SEQSTAT_EXCAUSE) == VEC_HWERR &&
-	    oops_in_progress)){
+	    atomic_read(&oops_in_progress))) {
 		printk(KERN_NOTICE "Looks like this was a deferred error - sorry\n");
 #ifndef CONFIG_DEBUG_HWERR
 		printk(KERN_NOTICE "The remaining message may be meaningless\n"
@@ -1123,7 +1123,7 @@ void panic_cplb_error(int cplb_panic, st
 		break;
 	}
 
-	oops_in_progress = 1;
+	atomic_set(&oops_in_progress, 1);
 
 	dump_bfin_process(fp);
 	dump_bfin_mem(fp);
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -170,7 +170,7 @@ handle_watchdog_bite(struct pt_regs* reg
 #if defined(CONFIG_ETRAX_WATCHDOG)
 	extern int cause_of_death;
 
-	oops_in_progress = 1;
+	atomic_set(&oops_in_progress, 1);
 	printk(KERN_WARNING "Watchdog bite\n");
 
 	/* Check if forced restart or unexpected watchdog */
@@ -191,7 +191,7 @@ handle_watchdog_bite(struct pt_regs* reg
 	stop_watchdog();
 	printk(KERN_WARNING "Oops: bitten by watchdog\n");
 	show_registers(regs);
-	oops_in_progress = 0;
+	atomic_set(&oops_in_progress, 0);
 #ifndef CONFIG_ETRAX_WATCHDOG_NICE_DOGGY
 	reset_watchdog();
 #endif
--- a/arch/cris/kernel/traps.c
+++ b/arch/cris/kernel/traps.c
@@ -164,10 +164,10 @@ void
 oops_nmi_handler(struct pt_regs *regs)
 {
 	stop_watchdog();
-	oops_in_progress = 1;
+	atomic_set(&oops_in_progress, 1);
 	printk("NMI!\n");
 	show_registers(regs);
-	oops_in_progress = 0;
+	atomic_set(&oops_in_progress, 0);
 }
 
 static int __init
@@ -223,7 +223,7 @@ die_if_kernel(const char *str, struct pt
 
 	show_registers(regs);
 
-	oops_in_progress = 0;
+	atomic_set(&oops_in_progress, 0);
 
 #ifdef CONFIG_ETRAX_WATCHDOG_NICE_DOGGY
 	reset_watchdog();
--- a/arch/cris/mm/fault.c
+++ b/arch/cris/mm/fault.c
@@ -223,8 +223,8 @@ do_page_fault(unsigned long address, str
 	 * terminate things with extreme prejudice.
 	 */
 
-	if (!oops_in_progress) {
-		oops_in_progress = 1;
+	if (!atomic_read(&oops_in_progress)) {
+		atomic_set(&oops_in_progress, 1);
 		if ((unsigned long) (address) < PAGE_SIZE)
 			printk(KERN_ALERT "Unable to handle kernel NULL "
 				"pointer dereference");
@@ -233,7 +233,7 @@ do_page_fault(unsigned long address, str
 				" at virtual address %08lx\n", address);
 
 		die_if_kernel("Oops", regs, (writeaccess << 1) | protection);
-		oops_in_progress = 0;
+		atomic_set(&oops_in_progress, 0);
 	}
 
 	do_exit(SIGKILL);
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -187,7 +187,7 @@ static unsigned long mlogbuf_timestamp =
 
 static int loglevel_save = -1;
 #define BREAK_LOGLEVEL(__console_loglevel)		\
-	oops_in_progress = 1;				\
+	atomic_set(&oops_in_progress, 1);		\
 	if (loglevel_save < 0)				\
 		loglevel_save = __console_loglevel;	\
 	__console_loglevel = 15;
@@ -198,7 +198,7 @@ static int loglevel_save = -1;
 		loglevel_save = -1;			\
 	}						\
 	mlogbuf_finished = 0;				\
-	oops_in_progress = 0;
+	atomic_set(&oops_in_progress, 0);
 
 /*
  * Push messages into buffer, print them later if not urgent.
@@ -215,7 +215,7 @@ void ia64_mca_printk(const char *fmt, ..
 	va_end(args);
 
 	/* Copy the output into mlogbuf */
-	if (oops_in_progress) {
+	if (atomic_read(&oops_in_progress)) {
 		/* mlogbuf was abandoned, use printk directly instead. */
 		printk(temp_buf);
 	} else {
--- a/arch/mn10300/mm/fault.c
+++ b/arch/mn10300/mm/fault.c
@@ -39,7 +39,7 @@
 void bust_spinlocks(int yes)
 {
 	if (yes) {
-		oops_in_progress = 1;
+		atomic_set(&oops_in_progress, 1);
 #ifdef CONFIG_SMP
 		/* Many serial drivers do __global_cli() */
 		global_irq_lock = 0;
@@ -49,7 +49,7 @@ void bust_spinlocks(int yes)
 #ifdef CONFIG_VT
 		unblank_screen();
 #endif
-		oops_in_progress = 0;
+		atomic_set(&oops_in_progress, 0);
 		/*
 		 * OK, the message is on the console.  Now we call printk()
 		 * without oops_in_progress set so that printk will give klogd
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -246,7 +246,7 @@ void die_if_kernel(char *str, struct pt_
 		return;
 	}
 
-	oops_in_progress = 1;
+	atomic_set(&oops_in_progress, 1);
 
 	/* Amuse the user in a SPARC fashion */
 	if (err) printk(
@@ -438,7 +438,7 @@ void parisc_terminate(char *msg, struct 
 {
 	static DEFINE_SPINLOCK(terminate_lock);
 
-	oops_in_progress = 1;
+	atomic_set(&oops_in_progress, 1);
 
 	set_eiem(0);
 	local_irq_disable();
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -240,7 +240,7 @@ static inline void setup_zfcpdump(unsign
 
 void machine_restart(char *command)
 {
-	if ((!in_interrupt() && !in_atomic()) || oops_in_progress)
+	if ((!in_interrupt() && !in_atomic()) || atomic_read(&oops_in_progress))
 		/*
 		 * Only unblank the console if we are called in enabled
 		 * context or a bust_spinlocks cleared the way for us.
@@ -251,7 +251,7 @@ void machine_restart(char *command)
 
 void machine_halt(void)
 {
-	if (!in_interrupt() || oops_in_progress)
+	if (!in_interrupt() || atomic_read(&oops_in_progress))
 		/*
 		 * Only unblank the console if we are called in enabled
 		 * context or a bust_spinlocks cleared the way for us.
@@ -262,7 +262,7 @@ void machine_halt(void)
 
 void machine_power_off(void)
 {
-	if (!in_interrupt() || oops_in_progress)
+	if (!in_interrupt() || atomic_read(&oops_in_progress))
 		/*
 		 * Only unblank the console if we are called in enabled
 		 * context or a bust_spinlocks cleared the way for us.
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -81,11 +81,11 @@ static inline int notify_page_fault(stru
 void bust_spinlocks(int yes)
 {
 	if (yes) {
-		oops_in_progress = 1;
+		atomic_set(&oops_in_progress, 1);
 	} else {
 		int loglevel_save = console_loglevel;
 		console_unblank();
-		oops_in_progress = 0;
+		atomic_set(&oops_in_progress, 0);
 		/*
 		 * OK, the message is on the console.  Now we call printk()
 		 * without oops_in_progress set so that printk will give klogd
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -3639,7 +3639,7 @@ void do_unblank_screen(int leaving_gfx)
 	 * context for the sake of the low level drivers, except in the special
 	 * case of oops_in_progress
 	 */
-	if (!oops_in_progress)
+	if (!atomic_read(&oops_in_progress))
 		might_sleep();
 
 	WARN_CONSOLE_UNLOCKED();
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -341,7 +341,7 @@ mtdoops_console_write(struct console *co
 	struct mtd_info *mtd = cxt->mtd;
 	unsigned long flags;
 
-	if (!oops_in_progress) {
+	if (!atomic_read(&oops_in_progress)) {
 		mtdoops_console_sync();
 		return;
 	}
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -464,7 +464,7 @@ static void led_work_func (struct work_s
 	if (likely(led_diskio))   currentleds |= led_get_diskio_activity();
 
 	/* blink all LEDs twice a second if we got an Oops (HPMC) */
-	if (unlikely(oops_in_progress)) 
+	if (unlikely(atomic_read(&oops_in_progress)))
 		currentleds = (count_HZ<=(HZ/2)) ? 0 : 0xff;
 
 	if (currentleds != lastleds)
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2553,7 +2553,7 @@ serial8250_console_write(struct console 
 	if (up->port.sysrq) {
 		/* serial8250_handle_port() already took the lock */
 		locked = 0;
-	} else if (oops_in_progress) {
+	} else if (atomic_read(&oops_in_progress)) {
 		locked = spin_trylock(&up->port.lock);
 	} else
 		spin_lock(&up->port.lock);
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -1120,7 +1120,7 @@ static void cpm_uart_console_write(struc
 	cbd_t __iomem *bdp, *bdbase;
 	unsigned char *cp;
 	unsigned long flags;
-	int nolock = oops_in_progress;
+	int nolock = atomic_read(&oops_in_progress);
 
 	if (unlikely(nolock)) {
 		local_irq_save(flags);
--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -435,7 +435,7 @@ static void sunhv_console_write_paged(st
 	local_irq_save(flags);
 	if (port->sysrq) {
 		locked = 0;
-	} else if (oops_in_progress) {
+	} else if (atomic_read(&oops_in_progress)) {
 		locked = spin_trylock(&port->lock);
 	} else
 		spin_lock(&port->lock);
@@ -494,7 +494,7 @@ static void sunhv_console_write_bychar(s
 	local_irq_save(flags);
 	if (port->sysrq) {
 		locked = 0;
-	} else if (oops_in_progress) {
+	} else if (atomic_read(&oops_in_progress)) {
 		locked = spin_trylock(&port->lock);
 	} else
 		spin_lock(&port->lock);
--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -852,7 +852,7 @@ static void sunsab_console_write(struct 
 	local_irq_save(flags);
 	if (up->port.sysrq) {
 		locked = 0;
-	} else if (oops_in_progress) {
+	} else if (atomic_read(&oops_in_progress)) {
 		locked = spin_trylock(&up->port.lock);
 	} else
 		spin_lock(&up->port.lock);
--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -1296,7 +1296,7 @@ static void sunsu_console_write(struct c
 	local_irq_save(flags);
 	if (up->port.sysrq) {
 		locked = 0;
-	} else if (oops_in_progress) {
+	} else if (atomic_read(&oops_in_progress)) {
 		locked = spin_trylock(&up->port.lock);
 	} else
 		spin_lock(&up->port.lock);
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -1154,7 +1154,7 @@ sunzilog_console_write(struct console *c
 	local_irq_save(flags);
 	if (up->port.sysrq) {
 		locked = 0;
-	} else if (oops_in_progress) {
+	} else if (atomic_read(&oops_in_progress)) {
 		locked = spin_trylock(&up->port.lock);
 	} else
 		spin_lock(&up->port.lock);
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -368,9 +368,9 @@ static void ulite_console_write(struct c
 	unsigned int ier;
 	int locked = 1;
 
-	if (oops_in_progress) {
+	if (atomic_read(&oops_in_progress))
 		locked = spin_trylock_irqsave(&port->lock, flags);
-	} else
+	else
 		spin_lock_irqsave(&port->lock, flags);
 
 	/* save and disable interrupt */
--- a/drivers/video/aty/radeonfb.h
+++ b/drivers/video/aty/radeonfb.h
@@ -380,7 +380,7 @@ struct radeonfb_info {
  */
 static inline void _radeon_msleep(struct radeonfb_info *rinfo, unsigned long ms)
 {
-	if (rinfo->no_schedule || oops_in_progress)
+	if (rinfo->no_schedule || atomic_read(&oops_in_progress))
 		mdelay(ms);
 	else
 		msleep(ms);
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -142,7 +142,8 @@ void vcs_remove_sysfs(struct tty_struct 
 
 /* Some debug stub to catch some of the obvious races in the VT code */
 #if 1
-#define WARN_CONSOLE_UNLOCKED()	WARN_ON(!is_console_locked() && !oops_in_progress)
+#define WARN_CONSOLE_UNLOCKED()	\
+	WARN_ON(!is_console_locked() && !atomic_read(&oops_in_progress))
 #else
 #define WARN_CONSOLE_UNLOCKED()
 #endif
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -18,6 +18,7 @@
 #include <linux/ratelimit.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
+#include <asm/atomic_def.h>
 
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
@@ -231,7 +232,8 @@ static inline void console_verbose(void)
 
 extern void bust_spinlocks(int yes);
 extern void wake_up_klogd(void);
-extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
+/* If set, an oops, panic(), BUG() or die() is in progress */
+extern atomic_t oops_in_progress;
 extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -64,7 +64,7 @@ int console_printk[4] = {
  * Low level drivers may need that to know if they can schedule in
  * their unblank() callback or not. So let's export it.
  */
-int oops_in_progress;
+atomic_t oops_in_progress;
 EXPORT_SYMBOL(oops_in_progress);
 
 /*
@@ -248,7 +248,7 @@ int log_buf_copy(char *dest, int idx, in
 	int ret, max;
 	bool took_lock = false;
 
-	if (!oops_in_progress) {
+	if (!atomic_read(&oops_in_progress)) {
 		spin_lock_irq(&logbuf_lock);
 		took_lock = true;
 	}
@@ -688,7 +688,7 @@ asmlinkage int vprintk(const char *fmt, 
 		 * recursion and return - but flag the recursion so that
 		 * it can be printed at the next appropriate moment:
 		 */
-		if (!oops_in_progress) {
+		if (!atomic_read(&oops_in_progress)) {
 			recursion_bug = 1;
 			goto out_restore_irqs;
 		}
@@ -984,7 +984,7 @@ int is_console_locked(void)
 
 void wake_up_klogd(void)
 {
-	if (!oops_in_progress && waitqueue_active(&log_wait))
+	if (!atomic_read(&oops_in_progress) && waitqueue_active(&log_wait))
 		wake_up_interruptible(&log_wait);
 }
 
@@ -1067,7 +1067,7 @@ void console_unblank(void)
 	 * console_unblank can no longer be called in interrupt context unless
 	 * oops_in_progress is set to 1..
 	 */
-	if (oops_in_progress) {
+	if (atomic_read(&oops_in_progress)) {
 		if (!down_try(&console_sem))
 			return;
 	} else
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8111,7 +8111,8 @@ void __might_sleep(char *file, int line)
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	if ((in_atomic() || irqs_disabled()) &&
-	    system_state == SYSTEM_RUNNING && !oops_in_progress) {
+	    system_state == SYSTEM_RUNNING &&
+	    !atomic_read(&oops_in_progress)) {
 		if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
 			return;
 		prev_jiffy = jiffies;


