Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbXGQMMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbXGQMMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbXGQMM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:12:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43594 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757709AbXGQMM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:12:28 -0400
Date: Tue, 17 Jul 2007 14:12:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch] softlockup: improve debug output
Message-ID: <20070717121224.GA13482@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: softlockup: improve debug output
From: Ingo Molnar <mingo@elte.hu>

improve the debuggability of kernel lockups by enhancing the debug 
output of the softlockup detector: print the task that causes the lockup 
and try to print a more intelligent backtrace.

the old format was:

  BUG: soft lockup detected on CPU#1!
   [<c0105e4a>] show_trace_log_lvl+0x19/0x2e
   [<c0105f43>] show_trace+0x12/0x14
   [<c0105f59>] dump_stack+0x14/0x16
   [<c015f6bc>] softlockup_tick+0xbe/0xd0
   [<c013457d>] run_local_timers+0x12/0x14
   [<c01346b8>] update_process_times+0x3e/0x63
   [<c0145fb8>] tick_sched_timer+0x7c/0xc0
   [<c0140a75>] hrtimer_interrupt+0x135/0x1ba
   [<c011bde7>] smp_apic_timer_interrupt+0x6e/0x80
   [<c0105aa3>] apic_timer_interrupt+0x33/0x38
   [<c0104f8a>] syscall_call+0x7/0xb
   =======================

the new format is:

  BUG: soft lockup detected on CPU#1! [prctl:2363]

  Pid: 2363, comm:                prctl
  EIP: 0060:[<c013915f>] CPU: 1
  EIP is at sys_prctl+0x24/0x18c
   EFLAGS: 00000213    Not tainted  (2.6.22-cfs-v20 #26)
  EAX: 00000001 EBX: 000003e7 ECX: 00000001 EDX: f6df0000
  ESI: 000003e7 EDI: 000003e7 EBP: f6df0fb0 DS: 007b ES: 007b FS: 00d8
  CR0: 8005003b CR2: 4d8c3340 CR3: 3731d000 CR4: 000006d0
   [<c0105e4a>] show_trace_log_lvl+0x19/0x2e
   [<c0105f43>] show_trace+0x12/0x14
   [<c01040be>] show_regs+0x1ab/0x1b3
   [<c015f807>] softlockup_tick+0xef/0x108
   [<c013457d>] run_local_timers+0x12/0x14
   [<c01346b8>] update_process_times+0x3e/0x63
   [<c0145fcc>] tick_sched_timer+0x7c/0xc0
   [<c0140a89>] hrtimer_interrupt+0x135/0x1ba
   [<c011bde7>] smp_apic_timer_interrupt+0x6e/0x80
   [<c0105aa3>] apic_timer_interrupt+0x33/0x38
   [<c0104f8a>] syscall_call+0x7/0xb
   =======================

note that in the old format we only knew that some system call locked 
up, we didnt know _which_. With the new format we know that it's at a 
specific place in sys_prctl(). [which was where i created an artificial 
kernel lockup to test the new format.]

this is also useful if the lockup happens in user-space - the user-space 
EIP (and other registers) will be printed too. (such a lockup would 
either suggest that the task was running at SCHED_FIFO:99 and looping 
for more than 10 seconds, or that the softlockup detector has a 
false-positive.)

the task name is printed too first, just in case we dont manage to print 
a useful backtrace.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softlockup.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -14,6 +14,8 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 
+#include <asm/irq_regs.h>
+
 static DEFINE_SPINLOCK(print_lock);
 
 static DEFINE_PER_CPU(unsigned long, touch_timestamp);
@@ -69,6 +71,7 @@ void softlockup_tick(void)
 	int this_cpu = smp_processor_id();
 	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
 	unsigned long print_timestamp;
+	struct pt_regs *regs;
 	unsigned long now;
 
 	if (touch_timestamp == 0) {
@@ -98,15 +101,21 @@ void softlockup_tick(void)
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable 10+ seconds delays: */
-	if (now > (touch_timestamp + 10)) {
-		per_cpu(print_timestamp, this_cpu) = touch_timestamp;
+	if (now <= (touch_timestamp + 10))
+		return;
+
+	regs = get_irq_regs();
 
-		spin_lock(&print_lock);
-		printk(KERN_ERR "BUG: soft lockup detected on CPU#%d!\n",
-			this_cpu);
+	per_cpu(print_timestamp, this_cpu) = touch_timestamp;
+
+	spin_lock(&print_lock);
+	printk(KERN_ERR "BUG: soft lockup detected on CPU#%d! [%s:%d]\n",
+			this_cpu, current->comm, current->pid);
+	if (regs)
+		show_regs(regs);
+	else
 		dump_stack();
-		spin_unlock(&print_lock);
-	}
+	spin_unlock(&print_lock);
 }
 
 /*
