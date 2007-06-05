Return-Path: <linux-kernel-owner+w=401wt.eu-S1765567AbXFEThz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765567AbXFEThz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 15:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762839AbXFEThr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 15:37:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762764AbXFEThq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 15:37:46 -0400
Date: Tue, 5 Jun 2007 21:37:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Linux 2.6.22-rc4
Message-ID: <20070605193718.GB24877@elte.hu>
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org> <4665B169.2030803@googlemail.com> <alpine.LFD.0.98.0706051219560.4921@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706051219560.4921@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > this looks harmless
> > 
> > [ 116.733327] PM: suspend-to-disk mode set to 'shutdown' [ 
> > 116.738849] swsusp: Basic memory bitmaps created [ 116.745353] 
> > Stopping tasks ... WARNING: at 
> > /home/devel/linux-git/kernel/lockdep.c:2414 check_flags()

> > [  116.755052] irq event stamp: 69
> > [  116.755060] hardirqs last  enabled at (69): [<c04040f9>] syscall_exit_work+0x11/0x26
> > [  116.755084] hardirqs last disabled at (68): [<c0403fdd>] syscall_exit+0x9/0x1a
> > [  116.755109] softirqs last  enabled at (0): [<c042150c>] copy_process+0x4dd/0x1286
> > [  116.755139] softirqs last disabled at (0): [<00000000>] 0x0
> > [  116.945776] done.

> Well, it's harmless in the sense that "yeah, the system still works", 
> but it does seem to be a real bug. We have hardware interrupts 
> disabled when we _think_ we should have them on, so our irq tracking 
> is off.
> 
> Ingo, do you see what's up? It looks like we got a signal to a process 
> that just got created, is the setup stuff for "tsk->hardirqs_enabled" 
> perhaps off a bit?

hm. I cannot see the source of the bug at the moment, but here's my 
analysis so far:

the last event that irqtrace got was #69, and that was a 'hardirqs on' 
in syscall_exit_work. After that we did a 'hardirqs off' without 
properly tracking that via irqtrace. Next time we got an irqtrace event 
(event 70) the assert caught up with us and turned off lockdep and 
backed out of that function. This was in:

 > [  116.754957]  [<c043c3e5>] check_flags+0x95/0x143
 > [  116.754967]  [<c043f158>] lock_acquire+0x29/0x82
 > [  116.754977]  [<c06313a7>] _spin_lock+0x35/0x42
 > [  116.754990]  [<c044894a>] refrigerator+0x14/0xc6
 > [  116.755002]  [<c042d4b3>] get_signal_to_deliver+0x33/0x397
 > [  116.755016]  [<c0403597>] do_notify_resume+0x94/0x6ed
 > [  116.755029]  [<c0404099>] work_notifysig+0x13/0x1a

isnt the refrigerator() suspend related? Perhaps suspend disables irqs 
somewhere that we forgot to track?

a new thread gets its hardirqs_enabled this way:

 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
         p->hardirqs_enabled = 1;
 #else
         p->hardirqs_enabled = 0;
 #endif

on i386 __ARCH_WANT_INTERRUPTS_ON_CTXSW is off so it starts with 0. We 
set this up in copy_process() so there's no chance this task can run 
without this initialized.

	Ingo
