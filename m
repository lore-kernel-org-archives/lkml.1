Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390Ab0ANRsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab0ANRsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 12:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341Ab0ANRsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 12:48:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52371 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab0ANRsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 12:48:35 -0500
Date: Thu, 14 Jan 2010 17:48:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 20/40] arm,kgdb: Add hook to catch an oops with debugger
Message-ID: <20100114174821.GB21385@n2100.arm.linux.org.uk>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com> <1263481176-1897-21-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263481176-1897-21-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 08:59:16AM -0600, Jason Wessel wrote:
> Add in a low level hook to catch calls to die() in the debugger.
> 
> After the debugger is done, the standard system rules will be in play
> for the original exception.
> 
> The kdb debugger wants a chance to catch these sorts of exceptions for
> analysis.

NAK.  I have a similar patch which implements the hook properly - but
with one caveat.  It needs a review to ensure that its safe to return
from die().  Until that's established, this patch can not be merged.

Please also ensure that the linux-arm-kernel list is copied with ARM
patches.

diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
index d65b2f5..5b66e51 100644
--- a/arch/arm/include/asm/system.h
+++ b/arch/arm/include/asm/system.h
@@ -73,8 +73,7 @@ extern unsigned int mem_fclk_21285;
 
 struct pt_regs;
 
-void die(const char *msg, struct pt_regs *regs, int err)
-		__attribute__((noreturn));
+void die(const char *msg, struct pt_regs *regs, int err);
 
 struct siginfo;
 void arm_notify_die(const char *str, struct pt_regs *regs, struct siginfo *info,
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index f838f36..29a0f4a 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -12,15 +12,17 @@
  *  'linux/arch/arm/lib/traps.S'.  Mostly a debugging aid, but will probably
  *  kill the offending process.
  */
-#include <linux/module.h>
 #include <linux/signal.h>
-#include <linux/spinlock.h>
 #include <linux/personality.h>
 #include <linux/kallsyms.h>
-#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
 #include <linux/hardirq.h>
+#include <linux/kdebug.h>
+#include <linux/module.h>
+#include <linux/kexec.h>
+#include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/uaccess.h>
 
 #include <asm/atomic.h>
 #include <asm/cacheflush.h>
@@ -224,14 +226,21 @@ void show_stack(struct task_struct *tsk, unsigned long *sp)
 #define S_SMP ""
 #endif
 
-static void __die(const char *str, int err, struct thread_info *thread, struct pt_regs *regs)
+static int __die(const char *str, int err, struct thread_info *thread, struct pt_regs *regs)
 {
 	struct task_struct *tsk = thread->task;
 	static int die_counter;
+	int ret;
 
 	printk(KERN_EMERG "Internal error: %s: %x [#%d]" S_PREEMPT S_SMP "\n",
 	       str, err, ++die_counter);
 	sysfs_printk_last_file();
+
+	/* trap and error numbers are mostly meaningless on ARM */
+	ret = notify_die(DIE_OOPS, str, regs, err, tsk->thread.trap_no, SIGSEGV);
+	if (ret == NOTIFY_STOP)
+		return ret;
+
 	print_modules();
 	__show_regs(regs);
 	printk(KERN_EMERG "Process %.*s (pid: %d, stack limit = 0x%p)\n",
@@ -243,6 +252,8 @@ static void __die(const char *str, int err, struct thread_info *thread, struct p
 		dump_backtrace(regs, tsk);
 		dump_instr(KERN_EMERG, regs);
 	}
+
+	return ret;
 }
 
 DEFINE_SPINLOCK(die_lock);
@@ -250,16 +261,21 @@ DEFINE_SPINLOCK(die_lock);
 /*
  * This function is protected against re-entrancy.
  */
-NORET_TYPE void die(const char *str, struct pt_regs *regs, int err)
+void die(const char *str, struct pt_regs *regs, int err)
 {
 	struct thread_info *thread = current_thread_info();
+	int ret;
 
 	oops_enter();
 
 	spin_lock_irq(&die_lock);
 	console_verbose();
 	bust_spinlocks(1);
-	__die(str, err, thread, regs);
+	ret = __die(str, err, thread, regs);
+
+	if (regs && kexec_should_crash(thread->task))
+		crash_kexec(regs);
+
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die_lock);
@@ -267,11 +283,10 @@ NORET_TYPE void die(const char *str, struct pt_regs *regs, int err)
 
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
-
 	if (panic_on_oops)
 		panic("Fatal exception");
-
-	do_exit(SIGSEGV);
+	if (ret != NOTIFY_STOP)
+		do_exit(SIGSEGV);
 }
 
 void arm_notify_die(const char *str, struct pt_regs *regs,
