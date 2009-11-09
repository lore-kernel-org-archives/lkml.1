Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZKIIbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZKIIbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZKIIbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:31:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33446 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbZKIIbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:31:42 -0500
Date: Mon, 9 Nov 2009 09:31:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Dasgupta, Romit" <romit@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/1] PM: Thaws refrigerated and to be exited kernel
 threads
Message-ID: <20091109083133.GB4818@elf.ucw.cz>
References: <B85A65D85D7EB246BE421B3FB0FBB59301DE31F934@dbde02.ent.ti.com>
 <20091107165421.GA1630@ucw.cz>
 <B85A65D85D7EB246BE421B3FB0FBB59301DE31FCF1@dbde02.ent.ti.com>
 <20091108082727.GC16482@elf.ucw.cz>
 <B85A65D85D7EB246BE421B3FB0FBB59301DE31FD10@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301DE31FD10@dbde02.ent.ti.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-11-08 16:40:07, Dasgupta, Romit wrote:
> (Resending with 80 column restriction) 

Thanks.

> > > > > @@ -49,7 +50,7 @@ void refrigerator(void)
> > > > >
> > > > >  	for (;;) {
> > > > >  		set_current_state(TASK_UNINTERRUPTIBLE);
> > > > > -		if (!frozen(current))
> > > > > +		if (!frozen(current) || (!current->mm 
> > && kthread_should_stop()))
> > > > >  			break;
> > > > >  		schedule();
> > > > 
> > > > Well, what if the thread does some processing before 
> > stopping? That
> > > > would break refrigerator assumptions...
> > > 
> > > The suspend thread will block until the 'to be stopped' 
> > thread clears up. That is what any call to kthread_stop would 
> > boil down to. The target thread would anyway be out of the 
> > refrigerator so I am not sure what assumption you mean here. 
> > Eventually, the target thread would clear up and wake up the 
> > suspend thread and then things would go on as usual.
> > 
> > (Please format to 80 columns).
> > 
> > No, I do not get it.
> > 
> > Lets say we have
> > 
> > evil_data_writer thread that needs to be stopped becuase it writes to
> > filesystem
> > 
> > nofreeze random_stopper thread
> > 
> > now we create the suspend image, and start writing it out. But that's
> > okay, evil_data_writer is stopped so it can't do no harm. But now
> > random_stopper decides to thread_stop() the evil_data_writer, and this
> > new code allows it to exit the refrigerator, *do some writing*, and
> > then stop.
> > 
> > That's bad, right?
> evil_data_writer will enter refrigerator after invoking 'try_to_freeze'. This 
> should be followed by a call to kthread_should_stop. There it decides if it 

Really? I believe the "ktrhead_should_stop" is new rule, and code does
not seem to follow it. Actually, for example audit does not seem to
use kthread_should_stop() at all...

./kernel/rtmutex-tester.c-
./kernel/rtmutex-tester.c-		/* Wait for the next command to be executed */
./kernel/rtmutex-tester.c-		schedule();
./kernel/rtmutex-tester.c:		try_to_freeze();
./kernel/rtmutex-tester.c-
./kernel/rtmutex-tester.c-		if (signal_pending(current))
./kernel/rtmutex-tester.c-			flush_signals(current);
--
./kernel/slow-work.c-			schedule();
./kernel/slow-work.c-		finish_wait(&slow_work_thread_wq, &wait);
./kernel/slow-work.c-
./kernel/slow-work.c:		try_to_freeze();
./kernel/slow-work.c-
./kernel/slow-work.c-		vsmax = vslow_work_proportion;
./kernel/slow-work.c-		vsmax *= atomic_read(&slow_work_thread_count);
--
./kernel/audit.c-			add_wait_queue(&kauditd_wait, &wait);
./kernel/audit.c-
./kernel/audit.c-			if (!skb_queue_len(&audit_skb_queue)) {
./kernel/audit.c:				try_to_freeze();
./kernel/audit.c-				schedule();
./kernel/audit.c-			}
./kernel/audit.c-
--
./kernel/signal.c-	/* Now we don't run again until woken by SIGCONT or SIGKILL */
./kernel/signal.c-	do {
./kernel/signal.c-		schedule();
./kernel/signal.c:	} while (try_to_freeze());
./kernel/signal.c-
./kernel/signal.c-	tracehook_finish_jctl();
./kernel/signal.c-	current->exit_code = 0;
--
./kernel/signal.c-	 * Now that we woke up, it's crucial if we're supposed to be
./kernel/signal.c-	 * frozen that we freeze now before running anything substantial.
./kernel/signal.c-	 */
./kernel/signal.c:	try_to_freeze();
./kernel/signal.c-
./kernel/signal.c-	spin_lock_irq(&sighand->siglock);
./kernel/signal.c-	/*
--
./net/core/pktgen.c-			t->control &= ~(T_REMDEV);
./net/core/pktgen.c-		}
./net/core/pktgen.c-
./net/core/pktgen.c:		try_to_freeze();
./net/core/pktgen.c-
./net/core/pktgen.c-		set_current_state(TASK_INTERRUPTIBLE);
./net/core/pktgen.c-	}
--
./net/sunrpc/svc_xprt.c-
./net/sunrpc/svc_xprt.c-		time_left = schedule_timeout(timeout);
./net/sunrpc/svc_xprt.c-
./net/sunrpc/svc_xprt.c:		try_to_freeze();
./net/sunrpc/svc_xprt.c-
./net/sunrpc/svc_xprt.c-		spin_lock_bh(&pool->sp_lock);
./net/sunrpc/svc_xprt.c-		remove_wait_queue(&rqstp->rq_wait, &wait);
--
./arch/m32r/kernel/signal.c-	if (!user_mode(regs))
./arch/m32r/kernel/signal.c-		return 1;
./arch/m32r/kernel/signal.c-
./arch/m32r/kernel/signal.c:	if (try_to_freeze()) 
./arch/m32r/kernel/signal.c-		goto no_signal;
./arch/m32r/kernel/signal.c-
./arch/m32r/kernel/signal.c-	if (!oldset)
--
./arch/h8300/kernel/signal.c-	if ((regs->ccr & 0x10))
./arch/h8300/kernel/signal.c-		return 1;
./arch/h8300/kernel/signal.c-
./arch/h8300/kernel/signal.c:	if (try_to_freeze())
./arch/h8300/kernel/signal.c-		goto no_signal;
./arch/h8300/kernel/signal.c-
./arch/h8300/kernel/signal.c-	current->thread.esp0 = (unsigned long) regs;
--
./arch/powerpc/platforms/ps3/device-init.c-
./arch/powerpc/platforms/ps3/device-init.c-	/* Loop here processing the requested notification events. */
./arch/powerpc/platforms/ps3/device-init.c-	do {
./arch/powerpc/platforms/ps3/device-init.c:		try_to_freeze();
./arch/powerpc/platforms/ps3/device-init.c-
./arch/powerpc/platforms/ps3/device-init.c-		memset(notify_event, 0, sizeof(*notify_event));
./arch/powerpc/platforms/ps3/device-init.c-
--
./arch/powerpc/platforms/83xx/suspend.c-{
./arch/powerpc/platforms/83xx/suspend.c-	while (1) {
./arch/powerpc/platforms/83xx/suspend.c-		wait_event_interruptible(agent_wq, pci_pm_state >= 2);
./arch/powerpc/platforms/83xx/suspend.c:		try_to_freeze();
./arch/powerpc/platforms/83xx/suspend.c-
./arch/powerpc/platforms/83xx/suspend.c-		if (signal_pending(current) || pci_pm_state < 2)
./arch/powerpc/platforms/83xx/suspend.c-			continue;
--
./arch/blackfin/kernel/signal.c-
./arch/blackfin/kernel/signal.c-	current->thread.esp0 = (unsigned long)regs;
./arch/blackfin/kernel/signal.c-
./arch/blackfin/kernel/signal.c:	if (try_to_freeze())
./arch/blackfin/kernel/signal.c-		goto no_signal;
./arch/blackfin/kernel/signal.c-
./arch/blackfin/kernel/signal.c-	if (test_thread_flag(TIF_RESTORE_SIGMASK))
--
./arch/frv/kernel/signal.c-	if (!user_mode(__frame))
./arch/frv/kernel/signal.c-		return;
./arch/frv/kernel/signal.c-
./arch/frv/kernel/signal.c:	if (try_to_freeze())
./arch/frv/kernel/signal.c-		goto no_signal;
./arch/frv/kernel/signal.c-
./arch/frv/kernel/signal.c-	if (test_thread_flag(TIF_RESTORE_SIGMASK))
--
./arch/arm/kernel/signal.c-	if (!user_mode(regs))
./arch/arm/kernel/signal.c-		return;
./arch/arm/kernel/signal.c-
./arch/arm/kernel/signal.c:	if (try_to_freeze())
./arch/arm/kernel/signal.c-		goto no_signal;
./arch/arm/kernel/signal.c-
./arch/arm/kernel/signal.c-	single_step_clear(current);
--
./arch/sh/kernel/signal_32.c-	if (!user_mode(regs))
./arch/sh/kernel/signal_32.c-		return;
./arch/sh/kernel/signal_32.c-
./arch/sh/kernel/signal_32.c:	if (try_to_freeze())
./arch/sh/kernel/signal_32.c-		goto no_signal;
./arch/sh/kernel/signal_32.c-
./arch/sh/kernel/signal_32.c-	if (test_thread_flag(TIF_RESTORE_SIGMASK))
...

									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
