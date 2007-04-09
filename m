Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbXDIGuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbXDIGuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 02:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXDIGuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 02:50:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:38441 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753015AbXDIGuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 02:50:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+czApsm/ecuMrDpI0yDxDa+Mn5BD/VnWeIk7cBS9
	0IRwZV9D4GAlGS
Subject: Re: [BUG] scheduler: first timeslice of the exiting thread
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>
In-Reply-To: <20070408230927.9a49c504.akpm@linux-foundation.org>
References: <877isozllw.wl%takeuchi_satoru@jp.fujitsu.com>
	 <20070408230927.9a49c504.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 08:50:50 +0200
Message-Id: <1176101450.6355.144.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-08 at 23:09 -0700, Andrew Morton wrote:
> On Sat, 07 Apr 2007 16:31:39 +0900 Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:
> 
> > When I was examining the following program ...
> > 
> >   1. There are a large amount of small jobs takes several msecs,
> >      and the number of job increases constantly.
> >   2. The process creates a thread or a process per job (I examined both
> >      the thread model and the process model).
> >   3. Each child process/thread does the assigned job and exit immediately.
> > 
> > ... I found that the thread model's latency is longer than proess
> > model's one against my expectation. It's because of the current
> > sched_fork()/sched_exit() implementation as follows:
> > 
> >   a) On sched_fork, the creator share its timeslice with new process.
> >   b) On sched_exit, if the exiting process didn't exhaust its first
> >      timeslice yet, it gives its timeslice to the parent.
> > 
> > It has no problem on the process model since the creator is the parent.
> > However, on the thread model, the creator is not the parent, it is same
> > as the creator's parent. Hence, on this kind of program, the creator
> > can't retrieve shared timeslice and exausts its timeslice at a rate of
> > knots. In addition, somehow, the parent (typically shell?) gets extra
> > timeslice.
> > 
> > I believe it's a bug and the exiting process should give its timeslice
> > to the creator. Now I have some patch plan to fix this problem as follow:
> > 
> >  a) Add the field for the creator to task_struct. It needs extra memory.
> >  b) Doesn't add extra field and have thread's parent the creater, which is
> >     same as process creation. However it has many side effects, for example,
> >     we also need to change sys_getppid() implementation.
> > 
> > What do you think? Any comments are welcome.
> 
> This comes at an awkward time, because we might well merge the
> staircase/deadline work into 2.6.22, and I think it rewrites the part of
> the scheduler which is causing the problems you're observing.
> 
> Has anyone verified that SD fixes this problem and the one at
> http://lkml.org/lkml/2007/4/7/21 ?

Not verified either way in testing, but I believe this should be a
problem for SD as well because timeslice fork/exit handling is identical
with mainline.  Individual slices are much smaller than mainline, so
priority should drop rapidly, consuming bandwidth allotted for the
current rotation, sending the creator off to the expired array
prematurely.

	-Mike

