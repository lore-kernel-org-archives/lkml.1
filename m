Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYDGVyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYDGVyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYDGVyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:54:23 -0400
Received: from twin.jikos.cz ([213.151.79.26]:50791 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbYDGVyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:54:23 -0400
Date: Mon, 7 Apr 2008 23:54:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
In-Reply-To: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804072348050.26562@twin.jikos.cz>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CCs added ]

On Mon, 7 Apr 2008, Zdenek Kabelac wrote:

> This has appeared in my kernel log:

The two patches below should fix these, shouldn't they?

>  hwsleep-0322 [00] enter_sleep_state     : Entering sleep state [S3]
> BUG: using smp_processor_id() in preemptible [00000000] code: pm-suspend/18791
> caller is do_machine_check+0xa9/0x500

From: Jiri Kosina <jkosina@suse.cz>

x86: fix possible race in do_machine_check()

It is not safe to call smp_processor_id() in cases we are not sure someone 
will not reschedule us.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 9a699ed..bf92375 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -189,6 +189,7 @@ void do_machine_check(struct pt_regs * regs, long error_code)
 	 * error.
 	 */
 	int kill_it = 0;
+	unsigned long flags;
 
 	atomic_inc(&mce_entry);
 
@@ -199,6 +200,8 @@ void do_machine_check(struct pt_regs * regs, long error_code)
 		goto out2;
 
 	memset(&m, 0, sizeof(struct mce));
+
+	local_irq_save(flags);
 	m.cpu = smp_processor_id();
 	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
 	/* if the restart IP is not valid, we're done for */
@@ -315,6 +318,7 @@ void do_machine_check(struct pt_regs * regs, long error_code)
 	wrmsrl(MSR_IA32_MCG_STATUS, 0);
  out2:
 	atomic_dec(&mce_entry);
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_X86_MCE_INTEL

> Extended CMOS year: 2000
> BUG: using smp_processor_id() in preemptible [00000000] code: pm-suspend/18791
> caller is retrigger_next_event+0x1c/0xf0
> Pid: 18791, comm: pm-suspend Not tainted 2.6.25-rc8 #32

From: Jiri Kosina <jkosina@suse.cz>

hrtimer: fix possible race in retrigger_next_event()

It is not safe to perform per-cpu variable read and use it later in cases 
we are not sure someone will not reschedule us.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 98bee01..c008096 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -486,6 +486,7 @@ static void retrigger_next_event(void *arg)
 	struct hrtimer_cpu_base *base;
 	struct timespec realtime_offset;
 	unsigned long seq;
+	unsigned long flags;
 
 	if (!hrtimer_hres_active())
 		return;
@@ -497,6 +498,7 @@ static void retrigger_next_event(void *arg)
 					-wall_to_monotonic.tv_nsec);
 	} while (read_seqretry(&xtime_lock, seq));
 
+	local_irq_save(flags);
 	base = &__get_cpu_var(hrtimer_bases);
 
 	/* Adjust CLOCK_REALTIME offset */
@@ -506,6 +508,7 @@ static void retrigger_next_event(void *arg)
 
 	hrtimer_force_reprogram(base);
 	spin_unlock(&base->lock);
+	local_irq_restore(flags);
 }
 
 /*
