Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbXKSX3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbXKSX3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXKSX3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:29:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:45991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbXKSX3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:29:40 -0500
Date: Mon, 19 Nov 2007 15:22:52 -0800
From: Greg KH <gregkh@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Greg KH <greg@kroah.com>, David <david@unsolicited.net>,
       Ingo Molnar <mingo@elte.hu>,
       Javier Kohen <jkohen@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
Message-ID: <20071119232252.GC3528@suse.de>
References: <1195323695.5240.16.camel@null.tough.com.ar> <20071117191211.GA12757@kroah.com> <473F498D.9090703@unsolicited.net> <20071117203705.GA21045@kroah.com> <473F88B0.1030309@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473F88B0.1030309@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 04:34:56PM -0800, Jeremy Fitzhardinge wrote:
> Greg KH wrote:
> > Great, thanks for tracking this down.
> >
> > Ingo, this corrisponds to changeset
> > a115d5caca1a2905ba7a32b408a6042b20179aaa in mainline.  Is that patch
> > incorrect?  Should this patch in the -stable tree be reverted?
> >   
> 
> Hm, I've never observed a problem with this in mainline. 
> 
> Ah.  The significant difference between 2.6.23 and -git is that the
> former used sched_clock as the softlockup timebase, versus cpu_clock in
> git.  If sched_clock() is tsc-based, and the tsc isn't stable when using
> cpufreq, then the softlockup with get confused and fire spuriously. 
> Ingo's fix to reporting exposed the fact that softlockup is terminally
> broken in that kernel.
> 
> I think the best course for now is to revert it, since softlockup is
> hardly a critical feature.  The proper fixes would either be to backport
> cpu_clock() to 2.6.23, or make it go back to using ticks.

Can you try applying the patch below to see if that solves the problem
for you?

thanks,

greg k-h

-------------

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 18 Nov 2007 01:55:38 +0100
Subject: softlockup watchdog fixes and cleanups
To: Greg KH <greg@kroah.com>
Cc: David <david@unsolicited.net>, Jeremy Fitzhardinge <jeremy@goop.org>, gregkh@suse.de, Javier Kohen <jkohen@users.sourceforge.net>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <20071118005538.GD26865@elte.hu>
Content-Disposition: inline

From: Ingo Molnar <mingo@elte.hu>


This is a merge of commits a5f2ce3c6024a5bb895647b6bd88ecae5001020a and
43581a10075492445f65234384210492ff333eba in mainline to fix a warning in
the 2.6.23.3 kernel release.

softlockup watchdog: style cleanups

kernel/softirq.c grew a few style uncleanlinesses in the past few
months, clean that up. No functional changes:

text    data     bss     dec     hex filename
1126      76       4    1206     4b6 softlockup.o.before
1129      76       4    1209     4b9 softlockup.o.after

( the 3 bytes .text increase is due to the "<1>" appended to one of
the printk messages. )

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


softlockup: improve debug output

Improve the debuggability of kernel lockups by enhancing the debug
output of the softlockup detector: print the task that causes the lockup
and try to print a more intelligent backtrace.

The old format was:

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

The new format is:

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

Note that in the old format we only knew that some system call locked
up, we didnt know _which_. With the new format we know that it's at a
specific place in sys_prctl(). [which was where i created an artificial
kernel lockup to test the new format.]

This is also useful if the lockup happens in user-space - the user-space
EIP (and other registers) will be printed too. (such a lockup would
either suggest that the task was running at SCHED_FIFO:99 and looping
for more than 10 seconds, or that the softlockup detector has a
false-positive.)

The task name is printed too first, just in case we dont manage to print
a useful backtrace.

[satyam@infradead.org: fix warning]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 kernel/softlockup.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -15,13 +15,16 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 
+#include <asm/irq_regs.h>
+
 static DEFINE_SPINLOCK(print_lock);
 
 static DEFINE_PER_CPU(unsigned long, touch_timestamp);
 static DEFINE_PER_CPU(unsigned long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
-static int did_panic = 0;
+static int did_panic;
+int softlockup_thresh = 10;
 
 static int
 softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
@@ -70,6 +73,7 @@ void softlockup_tick(void)
 	int this_cpu = smp_processor_id();
 	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
 	unsigned long print_timestamp;
+	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
 
 	if (touch_timestamp == 0) {
@@ -99,21 +103,26 @@ void softlockup_tick(void)
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable 10+ seconds delays: */
-	if (now > (touch_timestamp + 10)) {
-		per_cpu(print_timestamp, this_cpu) = touch_timestamp;
+	if (now <= (touch_timestamp + softlockup_thresh))
+		return;
+
+	per_cpu(print_timestamp, this_cpu) = touch_timestamp;
 
-		spin_lock(&print_lock);
-		printk(KERN_ERR "BUG: soft lockup detected on CPU#%d!\n",
-			this_cpu);
+	spin_lock(&print_lock);
+	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
+			this_cpu, now - touch_timestamp,
+			current->comm, current->pid);
+	if (regs)
+		show_regs(regs);
+	else
 		dump_stack();
-		spin_unlock(&print_lock);
-	}
+	spin_unlock(&print_lock);
 }
 
 /*
  * The watchdog thread - runs every second and touches the timestamp.
  */
-static int watchdog(void * __bind_cpu)
+static int watchdog(void *__bind_cpu)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
@@ -151,13 +160,13 @@ cpu_callback(struct notifier_block *nfb,
 		BUG_ON(per_cpu(watchdog_task, hotcpu));
 		p = kthread_create(watchdog, hcpu, "watchdog/%d", hotcpu);
 		if (IS_ERR(p)) {
-			printk("watchdog for %i failed\n", hotcpu);
+			printk(KERN_ERR "watchdog for %i failed\n", hotcpu);
 			return NOTIFY_BAD;
 		}
-  		per_cpu(touch_timestamp, hotcpu) = 0;
-  		per_cpu(watchdog_task, hotcpu) = p;
+		per_cpu(touch_timestamp, hotcpu) = 0;
+		per_cpu(watchdog_task, hotcpu) = p;
 		kthread_bind(p, hotcpu);
- 		break;
+		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		wake_up_process(per_cpu(watchdog_task, hotcpu));
@@ -177,7 +186,7 @@ cpu_callback(struct notifier_block *nfb,
 		kthread_stop(p);
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
- 	}
+	}
 	return NOTIFY_OK;
 }
 
