Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZLRONI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZLRONI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZLRONG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:13:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:56172 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZLRONB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:13:01 -0500
Subject: Re: High load average on idle machine running 2.6.32
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Suisani <sickpig@opinioni.net>
Cc: James Pearson <james-p@moving-picture.com>, linux-kernel@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>
In-Reply-To: <4B2B871C.3040300@opinioni.net>
References: <4B1D8C5D.9040900@moving-picture.com>
	 <4B2121E2.2030900@moving-picture.com> <4B267A9C.6010804@moving-picture.com>
	 <4B2B871C.3040300@opinioni.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 15:12:31 +0100
Message-ID: <1261145551.20899.208.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 14:43 +0100, Andrea Suisani wrote:

> >>> Strangely, when I run 'iftop' (from 
> >>> http://www.ex-parrot.com/pdw/iftop/) using the 2.6.32 kernel, the 
> >>> load average drops to below 0.5  - stop running iftop, and the load 
> >>> average climbs again ...

This is the thing that puzzles me most..

> >> Also, if I 'hot-unplug' CPUs 1 to 7, the load average drops to 0 - 
> >> when I re-enable theses CPUs, the load average climbs.

Very curious too

> >> I guess this is a problem with my particular config - or maybe because 
> >> I'm using NFS-root (the root file system is readonly), or using a 
> >> non-module kernel?

Russell, you grumbled something like this on IRC, are you too using
NFS-root?

> > I gave 'git bisect' a go - which appears to suggest that my problem 
> > started at:
> > 
> > % git bisect bad
> > d7c33c4930f569caf6b2ece597432853c4151a45 is first bad commit
> > commit d7c33c4930f569caf6b2ece597432853c4151a45
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Fri Sep 11 12:45:38 2009 +0200
> > 
> >     sched: Fix task affinity for select_task_rq_fair
> > 
> >     While merging select_task_rq_fair() and sched_balance_self() I made
> >     a mistake that leads to testing the wrong task affinty.
> > 
> >     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >     LKML-Reference: <new-submission>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > :040000 040000 3d7aa3e193c7faf9c7ebbb1443c6f63269d86d04 
> > 9cfb647eb5d80f156fd8a495da68f765c3fdd772 M      kernel

> > So I guess, it is not just one patch that has caused the issue I'm 
> > seeing, which I guess is to be expected as the above patch was part of 
> > the 'scheduler updates for v2.6.32' patch set 

Right, so the thing that seems most likely to cause such funnies is the
introduction of TASK_WAKING state in .32, during development we had a
brief period where we saw what you described, but I haven't seen it
after:

commit eb24073bc1fe3e569a855cf38d529fb650c35524
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Sep 16 21:09:13 2009 +0200

    sched: Fix TASK_WAKING & loadaverage breakage

> > I guess as no one else has reported this issue - it must be something to 
> > do with my set up - could using NFS-root affect how the load average is 
> > calculated?

So the thing that contributes to load is TASK_UNINTERRUPTIBLE sleeps
(and !PF_FREEZING) as tested by task_contributes_to_load().

Are you seeing a matching number of tasks being stuck in 'D' state when
the load is high? If so, how are these tasks affected by iftop/hotplug?



