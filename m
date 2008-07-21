Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbYGUTNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbYGUTNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbYGUTNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:13:21 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:37914 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbYGUTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:13:20 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: eric miao <eric.y.miao@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jack Ren <jack.ren@marvell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] sched: do not stop ticks when cpu is not idle
References: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com>
	<20080718102446.GV6875@elte.hu>
	<alpine.LFD.1.10.0807181548290.4316@apollo.tec.linutronix.de>
	<f17812d70807180738r75696e0ak120a884328b68ed3@mail.gmail.com>
	<alpine.LFD.1.10.0807181647500.4316@apollo.tec.linutronix.de>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 21 Jul 2008 12:13:09 -0700
In-Reply-To: <alpine.LFD.1.10.0807181647500.4316@apollo.tec.linutronix.de>
Message-ID: <87abgb3vay.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Fri, 18 Jul 2008, eric miao wrote:
> > On Fri, Jul 18, 2008 at 9:52 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > >> Thomas, Peter, Dmitry, do you concur with the analysis? (commit below)
> > >
> > > Yes. I did not understand the issue when Jack pointed it out to me,
> > > but with Erics explanation it's really clear. Thanks for tracking that
> > > down.
> > 
> > Actually, Jack did most of the analysis and came up with this quick
> > fix.
> > 
> > >
> > >> It looks a bit ugly to me in the middle of schedule() - is there no wait
> > >> to solve this within kernel/time/*.c ?
> > >
> > > Hmm, yes. I think the proper fix is to enable the tick stop mechanism
> > > in the idle loop and disable it before we go to schedule. That takes
> > > an additional parameter to tick_nohz_stop_sched_tick(), but we then
> > > gain a very clear section where the nohz mimic can be active.
> > >
> > > I'll whip up a patch.
> > 
> > Sounds great, thanks.
> 
> Hey, thanks for tracking that down. I was banging my head against the
> wall when I understood the problem.
> 
> I tried to pinpoint the occasional softlockup bug reports, but I
> probably stared too long into that code so I just saw what I expected
> to see.
> 
> Can you give the patch below a try please ?

Hi Thomas,

I've seen weird timer behavior on both i386 and x86_64 on SMP
machines.  By weird I mean:

 - time stops for a few hours, then resumes as if nothing happened;

 - time flows too fast or slow (4x faster to 2x slower depending on
   phase of the moon);

 - the last one I've seen (yesterday), was: 
      sleep(1) sleeps for 1 second, but
      select(0, NULL, NULL, NULL, 0.5) sleeps for nine seconds.

I have been trying to track this problem for a few weeks now, without
success.  Booting a CONFIG_NO_HZ-enabled kernel with "highres=off
nohz=off" does not make a difference.  However booting a kernel with
CONFIG_NO_HZ and CONFIG_HIGH_RES_TIMERS disabled seems to be working
(I cannot garantee that since I've been using that for 48h so far, but
sometimes the problem takes a few days to manifest itself).

After a cursory reading of your patch, it looks to me that the race
could happen on a kernel compiled with CONFIG_NO_HZ and
CONFIG_HIGH_RES_TIMERS and booted with "nohz=off highres=off".  Can
you confirm that?

If you need more details (dmesg, lspci, etc), I have posted some
details on LKML ( http://lkml.org/lkml/2008/7/9/330 ) and I have a bug
posted on the Fedora/RH bugzilla (
https://bugzilla.redhat.com/show_bug.cgi?id=451824 ).

Phil.
