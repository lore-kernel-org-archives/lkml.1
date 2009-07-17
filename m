Return-Path: <linux-kernel-owner+w=401wt.eu-S934539AbZGQMuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934539AbZGQMuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 08:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934525AbZGQMuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 08:50:16 -0400
Received: from www.tglx.de ([62.245.132.106]:54062 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934503AbZGQMuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 08:50:15 -0400
Date: Fri, 17 Jul 2009 14:48:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rafael Wysocki <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Nathan Lynch <ntl@pobox.com>,
       Nigel Cunningham <nigel@tuxonice.net>, stable@kernel.org,
       containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org, Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [patch 2/2] sched: fix nr_uninterruptible accounting of frozen
 tasks really
In-Reply-To: <1247833910.15751.61.camel@twins>
Message-ID: <alpine.LFD.2.00.0907171441020.11571@localhost.localdomain>
References: <20090717121545.489258927@linutronix.de>  <20090717122103.225652146@linutronix.de> <1247833910.15751.61.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, Peter Zijlstra wrote:

> On Fri, 2009-07-17 at 12:25 +0000, Thomas Gleixner wrote:
> > plain text document attachment (freezer-fix-accounting-for-real.patch)
> > commit e3c8ca8336 (sched: do not count frozen tasks toward load) broke
> > the nr_uninterruptible accounting on freeze/thaw. On freeze the task
> > is excluded from accounting with a check for (task->flags &
> > PF_FROZEN), but that flag is cleared before the task is thawed. So
> > while we prevent that the freezing task with state
> > TASK_UNINTERRUPTIBLE is accounted to nr_uninterruptible we decrement
> > nr_uninterruptible on thaw.
> > 
> > Use a separate flag which is handled by the freezing task itself. Set
> > it before calling the scheduler with TASK_UNINTERRUPTIBLE state and
> > clear it after we return from frozen state.
> 
> Right, so I'm wondering why we don't fully revert e3c8ca8336 to begin
> with.

Fine with me, but it seems that the cgroup folks have some luser space
stuff looking at proc/loadavg which goes berserk when loadavg
increases rapidly due to freezing. OTOH that stuff seems to be
oblivious to the fact that the commit in question brings loadavg
irreversibly to 0 when you do enough freeze/thaw cycles.

So either we revert or apply the fix, which keeps the accounting
straight and solves the freezer loadavg thing. No strong opinion on
that.

Thanks,

	tglx
