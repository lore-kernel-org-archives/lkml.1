Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbYBGUZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbYBGUZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759606AbYBGUZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:25:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56176 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164AbYBGUY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:24:59 -0500
Subject: Re: MM kernels 2.6.24-rc*-mm*, 2.6.24-mm1: gnome-terminal stuck in
	tty_poll
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "J. K. Cliburn" <jacliburn@bellsouth.net>, Zan Lynx <zlynx@acm.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1202413744.6274.26.camel@lappy>
References: <1202326722.7488.46.camel@localhost>
	 <47AA68AA.3090009@bellsouth.net>
	 <20080206182329.b0956b4a.akpm@linux-foundation.org>
	 <1202413744.6274.26.camel@lappy>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 21:24:47 +0100
Message-Id: <1202415887.6274.40.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-07 at 20:49 +0100, Peter Zijlstra wrote:
> On Wed, 2008-02-06 at 18:23 -0800, Andrew Morton wrote:
> > On Wed, 06 Feb 2008 20:10:50 -0600 "J. K. Cliburn" <jacliburn@bellsouth.net> wrote:
> > 
> > > Zan Lynx wrote:
> > > 
> > > > gnome-terminal gets stuck.
> > > 
> > > I began seeing this very thing around 2.6.24 time.  (Fedora 8, vanilla 
> > > kernel.)  I could usually cause the gnome terminal to hang if I rapidly 
> > > resized the window while executing make check-headers.

Weird, .24 proper doesn't have that patch. What exact fedora kernel was
that (so I can look at it).

> > > Over a couple of days I bisected it down to this commit:
> > > 
> > > Commit:     37bb6cb4097e29ffee970065b74499cbf10603a3
> > > Parent:     d3d74453c34f8fd87674a8cf5b8a327c68f22e99
> > > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > AuthorDate: Fri Jan 25 21:08:32 2008 +0100
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Fri Jan 25 21:08:32 2008 +0100
> > > 
> > >      hrtimer: unlock hrtimer_wakeup
> > > 
> > >      hrtimer_wakeup creates a
> > > 
> > >        base->lock
> > >          rq->lock
> > > 
> > >      lock dependancy. Avoid this by switching to HRTIMER_CB_IRQSAFE_NO_SOFTIRQ
> > >      which doesn't hold base->lock.
> > > 
> > >      This fully untangles hrtimer locks from the scheduler locks, and allows
> > >      hrtimer usage in the scheduler proper.
> > > 
> > >      Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > >      Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > ---
> > >   kernel/hrtimer.c |    4 +++-
> > >   1 files changed, 3 insertions(+), 1 deletions(-)


Which is even weirder, because the provided trace indicates
schedule_timeout()
        
        Call Trace:
         [schedule_timeout+149/208] schedule_timeout+0x95/0xd0
         [<ffffffff8057dde5>] schedule_timeout+0x95/0xd0
         [tty_poll+145/160] tty_poll+0x91/0xa0
         [<ffffffff80430f11>] tty_poll+0x91/0xa0
         [do_sys_poll+617/880] do_sys_poll+0x269/0x370
         [<ffffffff802bbe69>] do_sys_poll+0x269/0x370
         [__pollwait+0/304] __pollwait+0x0/0x130
         [<ffffffff802bcb30>] __pollwait+0x0/0x130
        
[ weird trace format this ]

which uses the other timer API, and should not be affected by
hrtimer_wakeup().

/me puzzled...


