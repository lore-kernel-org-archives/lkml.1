Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbZKWJ5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbZKWJ5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbZKWJ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:57:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437AbZKWJ5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:57:12 -0500
Date: Mon, 23 Nov 2009 10:52:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fix granularity of task_u/stime(), v2
Message-ID: <20091123095246.GA25978@dhcp-lab-161.englab.brq.redhat.com>
References: <1257778154.4108.341.camel@laptop> <4AF8FD3C.2090008@jp.fujitsu.com> <4AF8FE76.406@jp.fujitsu.com> <20091111121150.GA2549@dhcp-lab-161.englab.brq.redhat.com> <4AFB5019.7030901@jp.fujitsu.com> <4AFB77C2.8080705@jp.fujitsu.com> <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com> <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 03:49:19PM +0100, Stanislaw Gruszka wrote:
> On Thu, Nov 12, 2009 at 01:33:45PM +0900, Hidetoshi Seto wrote:
> > Originally task_s/utime() were designed to return clock_t but later
> > changed to return cputime_t by following commit:
> > 
> >   commit efe567fc8281661524ffa75477a7c4ca9b466c63
> >   Author: Christian Borntraeger <borntraeger@de.ibm.com>
> >   Date:   Thu Aug 23 15:18:02 2007 +0200
> > 
> > It only changed the type of return value, but not the implementation.
> > As the result the granularity of task_s/utime() is still that of
> > clock_t, not that of cputime_t.
> > 
> > So using task_s/utime() in __exit_signal() makes values accumulated
> > to the signal struct to be rounded and coarse grained.
> > 
> > This patch removes casts to clock_t in task_u/stime(), to keep
> > granularity of cputime_t over the calculation.
> > 
> > v2:
> >   Use div_u64() to avoid error "undefined reference to `__udivdi3`"
> >   on some 32bit systems.
> > 
> > Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> > ---
> >  kernel/sched.c |   22 +++++++++++++---------
> >  1 files changed, 13 insertions(+), 9 deletions(-)
> 
> Patch not fix the issue on my system. I test it alone, together with 
> 
> posix-cpu-timers: avoid do_sys_times() races with __exit_signal(
> 
> and (further) together with
>  
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -248,8 +248,8 @@ void thread_group_cputime(struct task_struct *tsk,
> struct task_cputime *times)
> 
>         t = tsk;
>         do {
> -               times->utime = cputime_add(times->utime, t->utime);
> -               times->stime = cputime_add(times->stime, t->stime);
> +               times->utime = cputime_add(times->utime, task_utime(t));
> +               times->stime = cputime_add(times->stime, task_stime(t));
>                 times->sum_exec_runtime += t->se.sum_exec_runtime;
> 
>                 t = next_thread(t);
> 
> What only changed was probability to enter the issue.

I was wrong here, that combination fix the problem on my system. I don't
know how I was testing it before, perhaps I booted wrong kernel.

Stanislaw
