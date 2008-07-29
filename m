Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYG2Oqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYG2Oqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758801AbYG2OqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:46:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:60961 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758655AbYG2OqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:46:06 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Removal of the deprecated cli() sti() functions.
Date: Tue, 29 Jul 2008 10:46:03 -0400
Message-Id: <1217342763-19568-1-git-send-email-mark.asselstine@windriver.com>
X-Mailer: git-send-email 1.5.5.1
X-OriginalArrivalTime: 29 Jul 2008 14:46:05.0007 (UTC) FILETIME=[D40685F0:01C8F189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions have been deprecated for some time now
but remained until all legacy callers could be removed.
With a few commits in 2.6.26 this has happened so now
we can remove these deprecated functions.

Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>
---
 Documentation/00-INDEX            |    2 -
 Documentation/cli-sti-removal.txt |  133 -------------------------------------
 include/linux/interrupt.h         |   29 --------
 3 files changed, 0 insertions(+), 164 deletions(-)
 delete mode 100644 Documentation/cli-sti-removal.txt

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 6de7130..5b5aba4 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -89,8 +89,6 @@ cciss.txt
 	- info, major/minor #'s for Compaq's SMART Array Controllers.
 cdrom/
 	- directory with information on the CD-ROM drivers that Linux has.
-cli-sti-removal.txt
-	- cli()/sti() removal guide.
 computone.txt
 	- info on Computone Intelliport II/Plus Multiport Serial Driver.
 connector/
diff --git a/Documentation/cli-sti-removal.txt b/Documentation/cli-sti-removal.txt
deleted file mode 100644
index 60932b0..0000000
--- a/Documentation/cli-sti-removal.txt
+++ /dev/null
@@ -1,133 +0,0 @@
-
-#### cli()/sti() removal guide, started by Ingo Molnar <mingo@redhat.com>
-
-
-as of 2.5.28, five popular macros have been removed on SMP, and
-are being phased out on UP:
-
- cli(), sti(), save_flags(flags), save_flags_cli(flags), restore_flags(flags)
-
-until now it was possible to protect driver code against interrupt
-handlers via a cli(), but from now on other, more lightweight methods
-have to be used for synchronization, such as spinlocks or semaphores.
-
-for example, driver code that used to do something like:
-
-	struct driver_data;
-
-	irq_handler (...)
-	{
-		....
-		driver_data.finish = 1;
-		driver_data.new_work = 0;
-		....
-	}
-
-	...
-
-	ioctl_func (...)
-	{
-		...
-		cli();
-		...
-		driver_data.finish = 0;
-		driver_data.new_work = 2;
-		...
-		sti();
-		...
-	}
-
-was SMP-correct because the cli() function ensured that no
-interrupt handler (amongst them the above irq_handler()) function
-would execute while the cli()-ed section is executing.
-
-but from now on a more direct method of locking has to be used:
-
-	DEFINE_SPINLOCK(driver_lock);
-	struct driver_data;
-
-	irq_handler (...)
-	{
-		unsigned long flags;
-		....
-		spin_lock_irqsave(&driver_lock, flags);
-		....
-		driver_data.finish = 1;
-		driver_data.new_work = 0;
-		....
-		spin_unlock_irqrestore(&driver_lock, flags);
-		....
-	}
-
-	...
-
-	ioctl_func (...)
-	{
-		...
-		spin_lock_irq(&driver_lock);
-		...
-		driver_data.finish = 0;
-		driver_data.new_work = 2;
-		...
-		spin_unlock_irq(&driver_lock);
-		...
-	}
-
-the above code has a number of advantages:
-
-- the locking relation is easier to understand - actual lock usage
-  pinpoints the critical sections. cli() usage is too opaque.
-  Easier to understand means it's easier to debug.
-
-- it's faster, because spinlocks are faster to acquire than the
-  potentially heavily-used IRQ lock. Furthermore, your driver does
-  not have to wait eg. for a big heavy SCSI interrupt to finish,
-  because the driver_lock spinlock is only used by your driver.
-  cli() on the other hand was used by many drivers, and extended
-  the critical section to the whole IRQ handler function - creating
-  serious lock contention.
-
- 
-to make the transition easier, we've still kept the cli(), sti(),
-save_flags(), save_flags_cli() and restore_flags() macros defined
-on UP systems - but their usage will be phased out until 2.6 is
-released.
-
-drivers that want to disable local interrupts (interrupts on the
-current CPU), can use the following five macros:
-
-  local_irq_disable(), local_irq_enable(), local_save_flags(flags),
-  local_irq_save(flags), local_irq_restore(flags)
-
-but beware, their meaning and semantics are much simpler, far from
-that of the old cli(), sti(), save_flags(flags) and restore_flags(flags)
-SMP meaning:
-
-    local_irq_disable()       => turn local IRQs off
-
-    local_irq_enable()        => turn local IRQs on
-
-    local_save_flags(flags)   => save the current IRQ state into flags. The
-                                 state can be on or off. (on some
-                                 architectures there's even more bits in it.)
-
-    local_irq_save(flags)     => save the current IRQ state into flags and
-                                 disable interrupts.
-
-    local_irq_restore(flags)  => restore the IRQ state from flags.
-
-(local_irq_save can save both irqs on and irqs off state, and
-local_irq_restore can restore into both irqs on and irqs off state.)
-
-another related change is that synchronize_irq() now takes a parameter:
-synchronize_irq(irq). This change too has the purpose of making SMP
-synchronization more lightweight - this way you can wait for your own
-interrupt handler to finish, no need to wait for other IRQ sources.
-
-
-why were these changes done? The main reason was the architectural burden
-of maintaining the cli()/sti() interface - it became a real problem. The
-new interrupt system is much more streamlined, easier to understand, debug,
-and it's also a bit faster - the same happened to it that will happen to
-cli()/sti() using drivers once they convert to spinlocks :-)
-
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 62aa4f8..58ff4e7 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -223,35 +223,6 @@ static inline int disable_irq_wake(unsigned int irq)
 #define or_softirq_pending(x)  (local_softirq_pending() |= (x))
 #endif
 
-/*
- * Temporary defines for UP kernels, until all code gets fixed.
- */
-#ifndef CONFIG_SMP
-static inline void __deprecated cli(void)
-{
-	local_irq_disable();
-}
-static inline void __deprecated sti(void)
-{
-	local_irq_enable();
-}
-static inline void __deprecated save_flags(unsigned long *x)
-{
-	local_save_flags(*x);
-}
-#define save_flags(x) save_flags(&x)
-static inline void __deprecated restore_flags(unsigned long x)
-{
-	local_irq_restore(x);
-}
-
-static inline void __deprecated save_and_cli(unsigned long *x)
-{
-	local_irq_save(*x);
-}
-#define save_and_cli(x)	save_and_cli(&x)
-#endif /* CONFIG_SMP */
-
 /* Some architectures might implement lazy enabling/disabling of
  * interrupts. In some cases, such as stop_machine, we might want
  * to ensure that after a local_irq_disable(), interrupts have
-- 
1.5.5.1

