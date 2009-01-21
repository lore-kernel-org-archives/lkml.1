Return-Path: <linux-kernel-owner+w=401wt.eu-S1764165AbZAULmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764165AbZAULmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756703AbZAULmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:42:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39234 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbZAULmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:42:39 -0500
Date: Wed, 21 Jan 2009 12:42:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep and debug objects together are broken?
Message-ID: <20090121114229.GA10606@elte.hu>
References: <20090120085559.GB19505@wotan.suse.de> <19f34abd0901201311t2425056dia6182812f7270297@mail.gmail.com> <20090121071950.GM24891@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121071950.GM24891@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0491]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> On Tue, Jan 20, 2009 at 10:11:47PM +0100, Vegard Nossum wrote:
> > On Tue, Jan 20, 2009 at 9:55 AM, Nick Piggin <npiggin@suse.de> wrote:
> > > Hi,
> > >
> > > I've had a problem frustrating my testing because lockdep was silently turning
> > > itself off... I patched out the code to disable lockdep after the first error,
> > > and it started showing up weird errors. kernel/fork.c:990 seemed to be the
> > > first to trigger (hard irqs disabled) from a call_usermodehelper call. Later,
> > > migration thread was reported to try to unlock rq->lock although it was
> > > holding no locks. Then init was reported to return to userspace without
> > > releasing an objectdebug hash lock.
> > >
> > > All that went away and everything seemed to work properly with debug objects
> > > configured out.
> > >
> > > I didn't get too far in trying to debug the problem. But it should be easy
> > > enough to reproduce (if not, I can post traces or test patches).
> > 
> > I just built a kernel with lockdep and debugobjects enabled, and
> > everything seemed fine. I think you should post your kernel version,
> > config, and the lockdep patch (if needed -- it didn't seem to turn
> > itself off here).
> 
> Are you sure? Ie. sysrq+D a still works properly? In that case, you
> wouldn't need the lockdep patch because it just prevents the feature from being
> switched off.
> 
> I'll have to dig a bit further, then. The annoying thing is that
> lockdep turns itself off at the drop of a hat (and this particular
> problem seems to happen without any backtraces), so it invalidates
> all your lockdep testing if you don't realise it has turned itself
> off.
> 
> Is there a way to re-arm lockdep? That would be neat.

Not at the moment, and it looks somewhat complicated. All lock state 
freezes the moment lockdep disarms itself. That's very much a key design 
element: rarely will you see any real lockdep-inflicted crash - even if it 
has a bug it is self-disabling itself and running for the door very 
efficiently.

So by the time you'd rearm, there's a lot of tasks with no proper locking 
state built up. We might be able to re-arm via stop_machine_run perhaps.

	Ingo
