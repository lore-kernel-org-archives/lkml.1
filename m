Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYBXNNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYBXNNA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 08:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYBXNMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 08:12:50 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:50319 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbYBXNMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 08:12:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jUFudEMS8rymelMDXG1bpKPA+c7jd+ZsVJY7FTRIOO0ws7EybpVKxs9HuRnC4r1Sqld9ea1sPE97wu/wCgTA9WElLQUWP6wG5Up8qUUfe60/PcgX1a/eW3jxa3oBg3V52PO/xXXtBgs5qN5Si1CyiYuzwMbZUN7MsaO4DopDPGI=
Message-ID: <998d0e4a0802240512t859c5a1y3c30bd401530a43@mail.gmail.com>
Date: Sun, 24 Feb 2008 14:12:47 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: "Rik van Riel" <riel@redhat.com>, "Mike Galbraith" <efault@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Please, put 64-bit counter per task and incr.by.one each ctxt switch.
In-Reply-To: <20080223232651.41dffa72@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998d0e4a0802231908h37978d07wa5379d5c01b2c2ee@mail.gmail.com>
	 <20080223221750.429cf0d9@bree.surriel.com>
	 <998d0e4a0802232008w5c6566f0se15ab749ec6f1ceb@mail.gmail.com>
	 <20080223232651.41dffa72@bree.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning :)

On 2008/2/24, Rik van Riel <riel@redhat.com> wrote:
> OK, one last reply on the (overly optimistic?) assumption that you are not a troll.
>  > +++ linux-2.6_git-20080224/include/linux/sched.h        2008-02-24
>  > 04:50:18.000000000 +0100
>  > @@ -1007,6 +1007,12 @@
>  >         struct hlist_head preempt_notifiers;
>  >  #endif
>  >
>  > +       unsigned long long ctxt_switch_counts; /* 64-bit switches' count */
>  > +       /* ToDo:
>  > +        *  To implement a poller/clock for CPU-scheduler that only reads
>  > +        *   these counts of context switches of the runqueue's tasks.
>  > +        *  No problem if this poller/clock is not implemented. */
>
> So you're introducing a statistic, but have not yet written any code
>  that uses it?

It's statistic, yes, but it's a very important parameter for the CPU-scheduler.
The CPU-scheduler will know the number of context switches of each task
 before of to take a blind decision into infinitum!.

Statistically, there are tasks X that have higher context switches and
tasks Y that have lower context switches in the last sized interval with the
 historical formula "(alpha-1)*prev + alpha*current" 0 < alpha < 1.
(measure this value V as a velocity of number of ctxt-switches/second too)

      Put more weight to X than to Y for more interactivity that X want.
      (X will have more higher V and Y more lower V).
      With an exception for avoid the eternal humble, to do sin(x) behaviour
       after of a long period of humble (later to modify the weights).

The missing code has to be implemented between everybodies because
1. Users wann't lose interactivity in overloaded CPU.
2. There are much code of CPU-schedulers bad organizated that i wann't
     touch it.

>  > +       p->ctxt_switch_counts = 0ULL; /* task's 64-bit counter inited 0 */
>
> Because we can all read C, there is no need to tell people in comments
>  what the code does.  Comments are there to explain why the code does
>  things, if an explanation is needed.

OK.

>  > >  > I will explain your later why of it.
>  > >
>  > > ... and explain exactly why the kernel needs this extra code.
>  >
>  > One reason: for the objective of gain interactivity, it's an issue that
>  >  CFS fair scheduler lacks it.

> Your patch does not actually help interactivity, because all it does
>  is add an irq spinlock in a hot path (bad idea) and a counter which
>  nothing reads.

Then remove the lock/unlock of the task that i'd put it,
i'm not sure if it's secure because i didn't read all the control of the road.

On 2008/2/24, Mike Galbraith <efault@gmx.de> wrote:
>  > One reason: for the objective of gain interactivity, it's an issue that
>  >  CFS fair scheduler lacks it.
>
> A bug report would be a much better first step toward resolution of any
>  interactivity issues you're seeing than posts which do nothing but
>  suggest that there may be a problem.
>
>  First define the problem, _then_ fix it.

It's blind eternal problem in overloaded CPU scenario in the desktops.
