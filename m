Return-Path: <linux-kernel-owner+w=401wt.eu-S1762018AbXEPNgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762018AbXEPNgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760234AbXEPNft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:35:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2060 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754497AbXEPNfq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:35:46 -0400
Date: Tue, 15 May 2007 16:52:46 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: tglx@linutronix.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>, linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-ID: <20070515165245.GG6816@ucw.cz>
References: <20070430102837.748238000@linutronix.de> <20070511132846.5ebf4437.akpm@linux-foundation.org> <200705112302.47726.rjw@sisk.pl> <200705112309.15996.rjw@sisk.pl> <20070511235607.83ad0eb5.akpm@linux-foundation.org> <1178959563.22481.126.camel@localhost.localdomain> <20070512020056.a24cf472.akpm@linux-foundation.org> <1178961489.22481.133.camel@localhost.localdomain> <20070512030754.90488f79.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070512030754.90488f79.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > It's peculiar that the hang happens when acpi_evaluate_object() hits its
> > > return statement.  Any theories there?
> > 
> > Only stack or memory corruption come into mind, but I have no clue how
> > this is related to the resume logic changes.
> 
> So I had the brilliant idea of turning on some kernel debugging.  It's
> a shame that CONFIG_SOFTWARE_SUSPEND disables CONFIG_DEBUG_PAGEALLOC.

We now switch to separate page tables for hibernation, IIRC, so we may
be able to get DEBUG_PAGEALLOC to work. I'll take a look.

> [   73.533454] swsusp: Basic memory bitmaps created
> [   73.550429] Stopping tasks ... BUG: at kernel/lockdep.c:2414 check_flags()
> [   73.550988]  [<c0104c14>] show_trace_log_lvl+0x1a/0x30
> [   73.551143]  [<c0105769>] show_trace+0x12/0x14
> [   73.551279]  [<c01057c1>] dump_stack+0x15/0x17
> [   73.551412]  [<c0132732>] check_flags+0x93/0x13d
> [   73.551554]  [<c0135558>] lock_acquire+0x28/0x7f
> [   73.551691]  [<c0310e35>] _spin_lock+0x2b/0x38
> [   73.551827]  [<c013dc43>] refrigerator+0x16/0xc7
> [   73.551965]  [<c0125d2e>] get_signal_to_deliver+0x32/0x387
> [   73.552124]  [<c010336d>] do_notify_resume+0x91/0x6a9
> [   73.552271]  [<c0103df1>] work_notifysig+0x13/0x1a
> [   73.552413]  =======================
> [   73.552507] irq event stamp: 3075
> [   73.552595] hardirqs last  enabled at (3075): [<c0103e51>] syscall_exit_work+0x11/0x26
> [   73.552821] hardirqs last disabled at (3074): [<c0103d35>] syscall_exit+0x9/0x1a
> [   73.553046] softirqs last  enabled at (2778): [<c01209f2>] __do_softirq+0x92/0x9a
> [   73.553255] softirqs last disabled at (2693): [<c0120a27>] do_softirq+0x2d/0x46
> [   73.559504] done.
> [   73.559569] Shrinking memory...  -done (0 pages freed)
> [   73.646511] Freed 0 kbytes in 0.08 seconds (0.00 MB/s)
> [   73.649595] platform sonypi: freeze
> [   73.649707] platform bluetooth: freeze
> [   73.649817] usb_endpoint usbdev5.1_ep81: PM: suspend 0->1, parent 5-0:1.0 already 2
> [   73.650023] hub 5-0:1.0: PM: suspend 2-->1
> 
> <snippage>
> 
> [   73.739499] ipw2200 0000:06:0b.0: freeze
> [   73.743860] eth1: Going into suspend...
> [   73.748444] e100 0000:06:08.0: freeze
> 
> at this point I lost netconsole (earlier testing was without netconsole
> btw)

Commenting out e100's suspend routine might do the trick.

> void refrigerator(void)
> {
> 	/* Hmm, should we be allowed to suspend when there are realtime
> 	   processes around? */
> 	long save;
> 
> -->	task_lock(current);
> 	if (freezing(current)) {
> 		frozen_process();
> 		task_unlock(current);
> 	} else {
> 
> 
> I don't really know what lockdep is complaining about there.  I assume I'm
> not supposed to, given that whoever wrote that couldn't be bothered
> documenting any of it.

> I _think_ it means that lockdep believes that local irqs are enabled
> (according to its state tracking), only it turns out that they're not.


Huh, running refrigerator with interrupts disabled? I do not think we
are doing _that_.

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
