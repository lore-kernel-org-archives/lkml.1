Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYCVQd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYCVQd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 12:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYCVQds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 12:33:48 -0400
Received: from www.tglx.de ([62.245.132.106]:32793 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbYCVQds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 12:33:48 -0400
Date: Sat, 22 Mar 2008 17:32:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gabriel C <crazy@frugalware.org>
cc: Gabriel C <nix.or.die@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
In-Reply-To: <47E5221B.5040900@frugalware.org>
Message-ID: <alpine.LFD.1.00.0803221730560.3781@apollo.tec.linutronix.de>
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com> <47E3D322.1090902@googlemail.com>
 <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org> <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org> <47E420C5.1050407@frugalware.org>
 <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de> <47E42FAB.6000906@frugalware.org> <alpine.LFD.1.00.0803212302390.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de> <47E50AF9.5070801@frugalware.org>
 <alpine.LFD.1.00.0803221441370.3781@apollo.tec.linutronix.de> <47E5221B.5040900@frugalware.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Gabriel C wrote:
> Thomas Gleixner wrote:
> > On Sat, 22 Mar 2008, Gabriel C wrote:
> >  > Now some time later CPU1 gets woken by an interrupt/IPI and runs the
> >>> timer wheel. At this point the pm_timer which is the reference clock
> >>> has already wrapped around, so the watchdog thinks that there is a
> >>> huge time difference and marks the TSC unstable.
> >>>
> >>> Aside of that watchdog issue this also affects the other users of
> >>> add_timer_on(): e.g. queue_delayed_work_on().
> >>>
> >>> Can you please apply the patch below and verify it with Andi's
> >>> watchdog patch applied ? 
> >>
> >> Did that , git head , Andi's + your patch but TSC is still marked unstable.
> > 
> > Doh, stupid me. We do not reevaluate the timer wheel, when we just
> > wake up via the smp_reschedule IPI when the resched flag on the other
> > CPU is not set. That's a separate vector which is not going through
> > irq_enter() / irq_exit(). 
> > 
> > Does the patch below solve the problem ?
> 
> With this one TSC is fine but now I get a warning on boot :

Good. It confirms my assumptions about the root cause.

> [    0.041037] ------------[ cut here ]------------
> [    0.041052] WARNING: at arch/x86/kernel/smp_32.c:562 native_smp_call_function_mask+0x23/0x11e()

Grr. I'll work out a solution for that one.

Thanks,

	tglx
