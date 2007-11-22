Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbXKVSwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbXKVSwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 13:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbXKVSwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 13:52:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:35241 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbXKVSwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 13:52:06 -0500
Date: Thu, 22 Nov 2007 19:52:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: nohz and strange sleep latencies
Message-ID: <20071122185238.GA1821@elf.ucw.cz>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu> <20071120105458.GA1597@elf.ucw.cz> <20071120205454.GD10008@elte.hu> <alpine.LFD.0.9999.0711202345520.25057@localhost.localdomain> <20071120225246.GA24380@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120225246.GA24380@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > to me this has the feeling of lapic breakage in C2 mode. Does it get any 
> > > better if you boot with 'nolapic'? (but that might in turn turn off 
> > > high-res timers and nohz in essence) Thomas, any ideas?
> > 
> > Hmm, lapic is considered unstable in c2 by default. You have to tell 
> > the kernel that you trust it in C2 on the command line.
> 
> yeah, i was wondering about that too. ACPI enumerated them properly at a 
> certain stage:
> 
>  ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
>  ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> 
> but perhaps somehow we miss this fact and fail to turn off the lapic 
> clockevents drivers?

Ok, I guess I'm lost. If I offline second CPU, I immediately get
1000Hz timer tick... is that expected?

I'm trying to decide when system is idle (lets say that means "no user
task is scheduled to wakeup within 10 seconds)... I added some
instrumentation to nohz subsystem, but it does not behave like I'd
expect: even if I run "while true; do sleep .01; done" loop, I see
nohz preparing for 5 seconds sleep... while it seems obvious that it
can only be 10msec sleep, and with max_cstate=1, it works that
way... Plus, nte->start_pid seems to contain some random numbers :-(.

What am I doing wrong?

(Patch for illustration, I can generate full diff against vanilla,
but...)
								Pavel

+++ b/kernel/time/tick-sched.c
@@ -229,11 +232,13 @@ void tick_nohz_stop_sched_tick(void)
 		if (delta_jiffies > 1)
 			cpu_set(cpu, nohz_cpu_mask);
 
+		{
+			int user_wait = get_next_timer_interrupt(last_jiffies, 1) - last_jiffies;
+
+			if ((user_wait > HZ/10) && (num_online_cpus() == 1))
+				printk("NOHZ: user ready for %d:%d sec wait (kernel %d:%d sec wait), naughty %d\n", user_wait/HZ, user_wait%HZ, delta_jiffies/HZ, delta_jiffies%HZ, naughty_pid);
+		}
+
 		/*
 		 * nohz_stop_sched_tick can be called several times before
 		 * the nohz_restart_sched_tick is called. This happens when
+++ b/kernel/timer.c
@@ -691,6 +693,12 @@ static unsigned long __next_timer_interr
 			if (tbase_get_deferrable(nte->base))
 				continue;
 
+			if (flags && (nte->start_pid < 1))
+				continue;
+
+			if (flags)
+				naughty_pid = nte->start_pid;
+
 			found = 1;
 			expires = nte->expires;
 			/* Look at the cascade bucket(s)? */



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
