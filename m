Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbXKMHfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbXKMHfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 02:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbXKMHff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:35:35 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44862 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbXKMHfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:35:33 -0500
Date: Tue, 13 Nov 2007 13:18:05 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: Revert for cgroups CPU accounting subsystem patch
Message-ID: <20071113074805.GA13499@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com> <20071113060038.GC3359@linux.vnet.ibm.com> <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 10:05:24PM -0800, Paul Menage wrote:
> On Nov 12, 2007 10:00 PM, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> >         On second thoughts, this may be a usefull controller of its own.
> > Say I just want to "monitor" usage (for accounting purpose) of a group of
> > tasks, but don't want to control their cpu consumption, then cpuacct
> > controller would come in handy.
> >
> 
> That's plausible, but having two separate ways of tracking and
> reporting the CPU usage of a cgroup seems wrong.
> 
> How bad would it be in your suggested case if you just give each
> cgroup the same weight?

That's still introducing a deviation from the normal behavior we would
have had we allowed all tasks to be part of the same "control" group/runqueue.

For ex: using nice value to vary bandwidth between tasks makes sense if
they are all part of the same group.

Also an application with more tasks will get more cpu power (as intended)
compared to another app with less tasks, provided they are all
part of the same group.

Regarding your concern about tracking cpu usage in different ways, it
could be mitigated if we have cpuacct controller track usage as per
information present in a task's sched entity structure
(tsk->se.sum_exec_runtime) i.e call cpuacct_charge() from
__update_curr() which would accumulate the execution time of the 
group in a SMP friendly manner (i.e dump it in a per-cpu per-group counter 
first and then aggregate to a global per-group counter).

This will let account and control grouping to be independent if desired.

What do you think?

> So there would be fair scheduling between
> cgroups, which seems as reasonable as any other choice in the event
> that the CPU is contended.

-- 
Regards,
vatsa
