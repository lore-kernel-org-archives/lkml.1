Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXDMPbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXDMPbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 11:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbXDMPbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 11:31:46 -0400
Received: from mail25.syd.optusnet.com.au ([211.29.133.166]:57947 "EHLO
	mail25.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbXDMPbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 11:31:46 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] scheduler: first timeslice of the exiting thread
Date: Sat, 14 Apr 2007 01:31:12 +1000
User-Agent: KMail/1.9.5
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
References: <877isozllw.wl%takeuchi_satoru@jp.fujitsu.com> <20070408230927.9a49c504.akpm@linux-foundation.org>
In-Reply-To: <20070408230927.9a49c504.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704140131.12500.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007 16:09, Andrew Morton wrote:
> On Sat, 07 Apr 2007 16:31:39 +0900 Satoru Takeuchi 
<takeuchi_satoru@jp.fujitsu.com> wrote:
> > When I was examining the following program ...
> >
> >   1. There are a large amount of small jobs takes several msecs,
> >      and the number of job increases constantly.
> >   2. The process creates a thread or a process per job (I examined both
> >      the thread model and the process model).
> >   3. Each child process/thread does the assigned job and exit
> > immediately.
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
> >  b) Doesn't add extra field and have thread's parent the creater, which
> > is same as process creation. However it has many side effects, for
> > example, we also need to change sys_getppid() implementation.
> >
> > What do you think? Any comments are welcome.
>
> This comes at an awkward time, because we might well merge the
> staircase/deadline work into 2.6.22, and I think it rewrites the part of
> the scheduler which is causing the problems you're observing.
>
> Has anyone verified that SD fixes this problem and the one at
> http://lkml.org/lkml/2007/4/7/21 ?

No, SD does nothing different in this regard. There is no notion of who made 
the thread and who the remaining timeslice should go to. As you say, some 
decision on sched_exit should probably be used to decide where to send it. In 
the absence of yet more fields in task_struct, the easiest thing to do would 
be to check if the the thread id is equal to the pid and if not, send it to 
the pid (or any parent of that if it no longer exists). Whether it's worth 
adding yet another field to task_struct to track this or not I do not have 
enough information to make an informed choice in this regard. Either way I'm 
low on patch-creation cycles so please feel free to provide your solution.

-- 
-ck
