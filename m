Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbXLVJxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbXLVJxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 04:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbXLVJxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 04:53:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750700AbXLVJxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 04:53:04 -0500
Subject: Re: [PATCH] kthread: run kthreadd with max priority SCHED_FIFO
From: Jon Masters <jcm@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Schmidt <mschmidt@redhat.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <20071222013021.db2528cb.akpm@linux-foundation.org>
References: <20071217234314.540b59bd@hammerfall>
	 <20071222013021.db2528cb.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Sat, 22 Dec 2007 04:52:50 -0500
Message-Id: <1198317171.24423.47.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-22 at 01:30 -0800, Andrew Morton wrote:
> On Mon, 17 Dec 2007 23:43:14 +0100 Michal Schmidt <mschmidt@redhat.com> wrote:
> 
> > kthreadd, the creator of other kernel threads, runs as a normal
> > priority task. This is a potential for priority inversion when a task
> > wants to spawn a high-priority kernel thread. A middle priority
> > SCHED_FIFO task can block kthreadd's execution indefinitely and thus
> > prevent the timely creation of the high-priority kernel thread.
> >     
> > This causes a practical problem. When a runaway real-time task is
> > eating 100% CPU and we attempt to put the CPU offline, sometimes we
> > block while waiting for the creation of the highest-priority
> > "kstopmachine" thread. 
> > 
> > The fix is to run kthreadd with the highest possible SCHED_FIFO
> > priority. Its children must still run as slightly negatively reniced
> > SCHED_NORMAL tasks.
> 
> Did you hit this problem with the stock kernel, or have you been working on
> other stuff?

This kind of problem is *far* more likely to happen on the -RT kernel
(more example cases), but it's also a general problem too.

> A locked-up SCHED_FIFO process will cause kernel threads all sorts of
> problems.  You've hit one instance, but there will be others.  (pdflush
> stops working, for one).

Right. Agreed that this is just one "fix" out of many possibly needed,
if upstream wants to address this kind of problem.

> The general approach we've taken to this is "don't do that".  Yes, we could
> boost lots of kernel threads in the way which this patch does but this
> actually takes control *away* from userspace.  Userspace no longer has the
> ability to guarantee itself minimum possible latency without getting
> preempted by kernel threads.
> 
> And yes, giving userspace this minimum-latency capability does imply that
> userspace has a responsibility to not 100% starve kernel threads.  It's a
> reasonable compromise, I think?

So, user tasks running with SCHED_FIFO should be able to lock a system?
I guess I see both sides of this argument - yes, it's userspace at
fault, but in other cases when userspace is at fault, we take action
(OOM, segfault, others). Isn't this situation just another case where
the kernel needs to avoid the evils of userland going awry?

Jon.


