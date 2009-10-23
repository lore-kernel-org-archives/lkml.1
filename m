Return-Path: <linux-kernel-owner+w=401wt.eu-S1751400AbZJWJXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbZJWJXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 05:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZJWJXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 05:23:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:60397 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751204AbZJWJXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 05:23:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+oaK5/gvOoRFuzAAxOwrlsBUPHyK/CWLbn70CkXk
	kEKeb5P+HS6ezD
Subject: Re: Intermittent early panic in try_to_wake_up
From: Mike Galbraith <efault@gmx.de>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AE0EBBD.6090005@gmail.com>
References: <4AE0EBBD.6090005@gmail.com>
Content-Type: text/plain
Date: Fri, 23 Oct 2009 11:23:01 +0200
Message-Id: <1256289781.22979.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 20:33 -0300, Kevin Winchester wrote:
> Hi,
> 
> A week or two ago I saw a panic on boot in try_to_wake_up, but it was not
> reproducible and I had not written down any trace information.  This
> evening I saw it twice more, but then on the third boot things worked fine.
> This time I copied down the stack trace:
> 
> try_to_wake_up+0x2e/0x102
> wake_up_process+0x10/0x12
> kthread_create+0x88/0x12c
> ?ksoftirqd+0x00/0xb7
> cpu_callback+0x42/0x8f
> ?spawn_ksoftirqd+0x0/0x39
> spawn_ksoftirqd+0x17/0x39
> do_one_initcall+0x58/0x147
> 
> The first time it happened, I remember checking the git logs and it was
> shortly after:
> 
> commit f5dc37530ba8a35aae0f7f4f13781d1904f71e94
> Author: Mike Galbraith <efault@gmx.de>
> Date:   Fri Oct 9 08:35:03 2009 +0200
> 
>     sched: Update the clock of runqueue select_task_rq() selected
>     
>     In try_to_wake_up(), we update the runqueue clock, but
>     select_task_rq() may select a different runqueue than the one we
>     updated, leaving the new runqueue's clock stale for a bit.
>     
>     This patch cures occasional huge latencies reported by latencytop
>     when coming out of idle on a mostly idle NO_HZ box.
>     
>     Signed-off-by: Mike Galbraith <efault@gmx.de>
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     LKML-Reference: <1255070103.7639.30.camel@marge.simson.net>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ...so perhaps that has something to do with it.

I don't think that's very likely.  Box did explode near my grubby
fingerprints though.

> Config below.  Any help would be appreciated.

Building with your config, try_to_wake_up+0x2e is around..

(gdb) list *try_to_wake_up+0x2e
0xffffffff81029107 is in try_to_wake_up (kernel/sched.c:2324).
2319            this_cpu = get_cpu();
2320
2321            smp_wmb();
2322            rq = orig_rq = task_rq_lock(p, &flags);
2323            update_rq_clock(rq);
2324            if (!(p->state & state))
2325                    goto out;
2326
2327            if (p->se.on_rq)
2328                    goto out_running;

I don't see how any of that can explode without something very bad
having happened to ksoftirqd before we tried to wake it.

	-Mike

