Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbXIFGja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbXIFGja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 02:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbXIFGjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 02:39:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34414 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbXIFGjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 02:39:22 -0400
Date: Thu, 6 Sep 2007 12:22:31 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Use show_regs() to improve __schedule_bug() output
In-Reply-To: <20070902122835.GA27438@elte.hu>
Message-ID: <alpine.LFD.0.999.0709061208120.26804@enigma.security.iitk.ac.in>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0709020439290.20781@enigma.security.iitk.ac.in>
 <alpine.LFD.0.999.0709021803060.24993@enigma.security.iitk.ac.in>
 <20070902122835.GA27438@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,


On Sun, 2 Sep 2007, Ingo Molnar wrote:
> 
> Thanks! Not sure how that bug slipped in, in my tree it does this:
> 
>  +       struct pt_regs *regs;
>  ...
>  +       regs = get_irq_regs();

You're very right indeed -- this bit was absent from -rc4-mm1's
softlockup-improve-debug-output.patch but now that I looked at your
original patch at http://lkml.org/lkml/2007/7/17/180, it becomes
obvious this was simply a mismerge issue after all :-)

[ Andrew, feel free to ignore my patch in case you just resolve
  the mismerge by yourself. ]


BTW would something similar would be useful in __schedule_bug() too?
I sure think so -- I'm not sure if EIP holds anything useful there,
but CPU#, EFLAGS and the init_utsname() stuff would be definitely
helpful ...


[PATCH] sched: Use show_regs() to improve __schedule_bug() output

A full register dump along with stack backtrace would make the "scheduling
while atomic" message more helpful. Use show_regs() instead of dump_stack()
for this. We already know we're atomic in here (that is why this function
was called) so show_regs()'s atomicity expectations are guaranteed.

Also, modify the output of the "BUG: scheduling while atomic:" header a bit
to keep task->comm and task->pid together and preempt_count() after them.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 kernel/sched.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b533d6d..4fb07c1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -63,6 +63,7 @@
 #include <linux/unistd.h>
 
 #include <asm/tlb.h>
+#include <asm/irq_regs.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -3404,12 +3405,19 @@ EXPORT_SYMBOL(sub_preempt_count);
  */
 static noinline void __schedule_bug(struct task_struct *prev)
 {
-	printk(KERN_ERR "BUG: scheduling while atomic: %s/0x%08x/%d\n",
-		prev->comm, preempt_count(), prev->pid);
+	struct pt_regs *regs = get_irq_regs();
+
+	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
+		prev->comm, prev->pid, preempt_count());
+
 	debug_show_held_locks(prev);
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
-	dump_stack();
+
+	if (regs)
+		show_regs(regs);
+	else
+		dump_stack();
 }
 
 /*
