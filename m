Return-Path: <linux-kernel-owner+w=401wt.eu-S1762233AbYCXSRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762233AbYCXSRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbYCXSRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:17:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748AbYCXSRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:17:07 -0400
Date: Mon, 24 Mar 2008 11:16:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] printk vs rq->lock and xtime lock
In-Reply-To: <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803241108190.17905@woody.linux-foundation.org>
References: <20080324122424.671168000@chello.nl> <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 Mar 2008, Linus Torvalds wrote:
> 
> Right now, however, I think that for 2.6.25 I'll just remove the printk. 

So I just committed that patch, but I was also looking at just making 
'printk()' itself more robust against this kind of thing.

Quite frankly, the printk() console semaphore etc handling is very 
confusing, and it has obviously evolved over time. Here's a suggested 
cleanup patch that doesn't actually *fix* anything, but it makes the 
resulting code flow a heck of a lot more readable.

In particular, it would now easily and readably allow us to add other 
rules inside the new "can_use_console()" that disable the console flushing 
if (for example) the request queue lock is held, or xlock is held for 
writing.

[ The patch adds more lines than it removes, but that is largely due to 
  the comments and the fact that it moves some of the code into new helper 
  functions, which invariably adds a few lines for the function definition 
  etc.

  There are actually fewer lines of actual code, because it ends up using
  the already-existing "try_acquire_console_sem()", and it avoids one ugly 
  special case, and removes some trivial code duplication about releasing 
  the logbuf_lock by reorganizing things a bit ]

Comments? 

			Linus
---
 kernel/printk.c |   83 +++++++++++++++++++++++++++++++-----------------------
 1 files changed, 48 insertions(+), 35 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 9adc2a4..c46a20a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -616,6 +616,40 @@ asmlinkage int printk(const char *fmt, ...)
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int printk_cpu = UINT_MAX;
 
+/*
+ * Can we actually use the console at this time on this cpu?
+ *
+ * Console drivers may assume that per-cpu resources have
+ * been allocated. So unless they're explicitly marked as
+ * being able to cope (CON_ANYTIME) don't call them until
+ * this CPU is officially up.
+ */
+static inline int can_use_console(unsigned int cpu)
+{
+	return cpu_online(cpu) || have_callable_console();
+}
+
+/*
+ * Try to get console ownership to actually show the kernel
+ * messages from a 'printk'. Return true (and with the
+ * console_semaphore held, and 'console_locked' set) if it
+ * is successful, false otherwise.
+ *
+ * This gets called with the 'logbuf_lock' spinlock held and
+ * interrupts disabled. It should return with 'lockbuf_lock'
+ * released but interrupts still disabled.
+ */
+static int acquire_console_semaphore_for_printk(unsigned int cpu)
+{
+	int retval = 0;
+
+	if (can_use_console(cpu))
+		retval = !try_acquire_console_sem();
+	printk_cpu = UINT_MAX;
+	spin_unlock(&logbuf_lock);
+	return retval;
+}
+
 const char printk_recursion_bug_msg [] =
 			KERN_CRIT "BUG: recent printk recursion!\n";
 static int printk_recursion_bug;
@@ -725,43 +759,22 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 			log_level_unknown = 1;
 	}
 
-	if (!down_trylock(&console_sem)) {
-		/*
-		 * We own the drivers.  We can drop the spinlock and
-		 * let release_console_sem() print the text, maybe ...
-		 */
-		console_locked = 1;
-		printk_cpu = UINT_MAX;
-		spin_unlock(&logbuf_lock);
+	/*
+	 * Try to acquire and then immediately release the
+	 * console semaphore. The release will do all the
+	 * actual magic (print out buffers, wake up klogd,
+	 * etc). 
+	 *
+	 * The acquire_console_semaphore_for_printk() function
+	 * will release 'logbuf_lock' regardless of whether it
+	 * actually gets the semaphore or not.
+	 */
+	if (acquire_console_semaphore_for_printk(this_cpu))
+		release_console_sem();
 
-		/*
-		 * Console drivers may assume that per-cpu resources have
-		 * been allocated. So unless they're explicitly marked as
-		 * being able to cope (CON_ANYTIME) don't call them until
-		 * this CPU is officially up.
-		 */
-		if (cpu_online(smp_processor_id()) || have_callable_console()) {
-			console_may_schedule = 0;
-			release_console_sem();
-		} else {
-			/* Release by hand to avoid flushing the buffer. */
-			console_locked = 0;
-			up(&console_sem);
-		}
-		lockdep_on();
-		raw_local_irq_restore(flags);
-	} else {
-		/*
-		 * Someone else owns the drivers.  We drop the spinlock, which
-		 * allows the semaphore holder to proceed and to call the
-		 * console drivers with the output which we just produced.
-		 */
-		printk_cpu = UINT_MAX;
-		spin_unlock(&logbuf_lock);
-		lockdep_on();
+	lockdep_on();
 out_restore_irqs:
-		raw_local_irq_restore(flags);
-	}
+	raw_local_irq_restore(flags);
 
 	preempt_enable();
 	return printed_len;
