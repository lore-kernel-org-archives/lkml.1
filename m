Return-Path: <linux-kernel-owner+w=401wt.eu-S1759027AbYBKTLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027AbYBKTLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYBKTLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:11:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59807 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbYBKTLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:11:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Subject: Re: 2.6.24-git2: Oracle 11g VKTM process enters R state on startup and is unkillable [still broken in 2.6.25-rc1]
Date: Mon, 11 Feb 2008 20:09:30 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <5a4c581d0802110820l1fcbb1ffib874f268b4ab7eae@mail.gmail.com>
In-Reply-To: <5a4c581d0802110820l1fcbb1ffib874f268b4ab7eae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802112009.31018.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 11 of February 2008, Alessandro Suardi wrote:
> On Feb 9, 2008 6:10 PM, Alessandro Suardi <alessandro.suardi@gmail.com> wrote:
> > I finally had a bit of time to try out different kernel versions to find
> >  out where this began... and it's in 2.6.24-git2.
> >
> > What happens: Oracle 11g starts up and forks a number of so
> >  called background processes. Starting in  2.6.24-git2 the VKTM
> >  process never fully completes its initialization but gets in R state,
> >  never accumulating CPU, and can't be straced/gdb'd/killed.
> >
> > Sysrq-T reports for VKTM looks like this
> >
> > Feb  9 16:10:46 sandman kernel:  =======================
> > Feb  9 16:10:46 sandman kernel: oracle        R running   2684  2258      1
> > Feb  9 16:10:46 sandman kernel:        f591dfb0 00200086 f6bbc3c4
> > f6863cc0 c010547a 00000000 b794f62c b7b70600
> > Feb  9 16:10:46 sandman kernel:        b79453dc f591d000 c0103caa
> > b794f62c b7943708 b79453e4 b7b70600 b79453dc
> > Feb  9 16:10:46 sandman kernel:        bfb0dd5c b79500b0 0000007b
> > 0000007b c0320000 ffffffff 0e072d7a 00000073
> > Feb  9 16:10:46 sandman kernel: Call Trace:
> > Feb  9 16:10:46 sandman kernel:  [<c010547a>] ? do_IRQ+0xac/0xc1
> > Feb  9 16:10:46 sandman kernel:  [<c0103caa>] work_resched+0x5/0x16
> > Feb  9 16:10:46 sandman kernel:  [<c0320000>] ? pci_setup+0xb3/0x104
> > Feb  9 16:10:46 sandman kernel:  =======================
> >
> >
> > 2.6.24-git1 is okay
> > 2.6.24-git2 is bad
> > ...
> > 2.6.24-git20 is bad
> >
> > Only differences in kernel .config between -git1 and -git2 are
> >
> > [asuardi@sandman src]$ diff .config-2.6.24-git[12]
> > 3,4c3,4
> > < # Linux kernel version: 2.6.24-git1
> > < # Sat Jan 26 01:04:43 2008
> > ---
> > > # Linux kernel version: 2.6.24-git2
> > > # Sat Jan 26 12:10:15 2008
> > 121a122,123
> > > CONFIG_CLASSIC_RCU=y
> > > # CONFIG_PREEMPT_RCU is not set
> > 187a190
> > > # CONFIG_RCU_TRACE is not set
> > 230a234
> > > # CONFIG_SCHED_HRTICK is not set
> > 755a760
> > > # CONFIG_PATA_NINJA32 is not set
> > 1807a1813
> > > # CONFIG_LATENCYTOP is not set
> >
> > Symptom is similar to what Rafael reported here
> >
> >   http://www.ussg.iu.edu/hypermail/linux/kernel/0801.3/4114.html
> >
> >  and similarly VKTM attempts to run at elevated priority as normal
> >  user process (Oracle kernel binary is not setuid root).

Yes, I think this is the same problem.  Please try to unset CONFIG_GROUP_SCHED
and see if that helps.

> > Peter Zijlstra's patches mentioned in the above thread, at
> >
> >  http://programming.kicks-ass.net/kernel-patches/sched-rt-group ,
> >
> >  do not appear to be in -git20 yet.
> >
> >
> > I'm available for further testing. Thanks, ciao,
> 
> Only to add that 2.6.25-rc1 is still broken.

Yes, it is.

Thanks,
Rafael
