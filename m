Return-Path: <linux-kernel-owner+w=401wt.eu-S1764515AbYAaP7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764515AbYAaP7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758076AbYAaP7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:59:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51248 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161AbYAaP7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:59:07 -0500
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during
	suspend/hibernation on x86-64 (bisected)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <200801280226.22013.rjw@sisk.pl>
References: <200801272229.48955.rjw@sisk.pl> <20080127215904.GB2686@elte.hu>
	 <200801280226.22013.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 16:58:48 +0100
Message-Id: <1201795128.32654.22.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 02:26 +0100, Rafael J. Wysocki wrote:
> On Sunday, 27 of January 2008, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > Hi,
> > > 
> > > 2.6.24-git3 adds a 5 - 10 sec delay to the suspend and hibernation 
> > > code paths (probably related to the disabling of nonboot CPUs), which 
> > > is !@#$%^&*() annoying.
> > > 
> > > It's 100% reproducible on my HP nx6325 and bisection idendified the 
> > > following commit as the first bad one:
> > > 
> > > commit 764a9d6fe4b52995c8aba277e3634385699354f4
> > > Author: Steven Rostedt <srostedt@redhat.com>
> > > Date:   Fri Jan 25 21:08:04 2008 +0100
> > > 
> > >     sched: track highest prio task queued
> > 
> > hm, this patch is a NOP, so it's weird that it has an effect.
> > 
> > Do you have serial logging enabled perhaps? If the following WARN_ON() 
> > triggers:
> > 
> > +               WARN_ON(p->prio < rq->rt.highest_prio);
> > 
> > then perhaps that can cause a 5-10 seconds delay. (that's how much time 
> > it takes to printk a warning on the slowest serial settings)
> > 
> > but if you use suspend, then any such printks would be preserved in the 
> > dmesg, right? If the WARN_ON() triggers, and if you remove it, do things 
> > get faster?
> 
> No, this isn't the WARN_ON().
> 
> > this does have the feel of being scheduling related, but are you 
> > absolutely sure about the precise identity of the patch?
> 
> Actually, not quite.  That's why I have verified it and found that another
> patch is really responsible for the issue, namely:
> 
> commit 82a1fcb90287052aabfa235e7ffc693ea003fe69
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Jan 25 21:08:02 2008 +0100
> 
>     softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks
> 
> Reverting this commit (it reverts with some minor modifications) fixes the
> problem for me.

I can seem to reproduce this:

[root@opteron cpu1]# time echo 0 > online

real    0m6.230s
user    0m0.000s
sys     0m0.010s
[root@opteron cpu1]# echo 1 > online
[root@opteron cpu1]# time echo 0 > online

real    0m7.966s
user    0m0.000s
sys     0m0.011s


I'll have a look at it.

