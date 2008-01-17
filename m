Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbYAQNYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbYAQNYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYAQNYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:24:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55584 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbYAQNYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:24:32 -0500
Subject: Re: runqueue locks in schedule()
From: Peter Zijlstra <peterz@infradead.org>
To: stephane eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, ia64 <linux-ia64@vger.kernel.org>,
       Stephane Eranian <eranian@gmail.com>,
       Corey J Ashford <cjashfor@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <7c86c4470801161629t3870da59hb6ac371c44126b07@mail.gmail.com>
References: <7c86c4470801161629t3870da59hb6ac371c44126b07@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 14:24:26 +0100
Message-Id: <1200576266.28661.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ At the very least CC'ing the scheduler maintainer would be
helpful :-) ]

On Wed, 2008-01-16 at 16:29 -0800, stephane eranian wrote:
> Hello,
> 
> As suggested by people on this list, I have changed perfmon2 to use
> the high resolution timers as the interface to allow timeout-based
> event set multiplexing. This works around the problems I had with
> tickless-enabled kernels.
> 
> Multiplexing is supported in per-thread as well. In that case, the
> timeout measures virtual time. When the thread is context switched
> out, we need to save the remainder of the timeout and cancel the
> timer. When the thread is context switched in, we need to reinstall
> the timer. These timer save/restore operations have to be done in the
> switch_to() code near the end of schedule().
> 
> There are situations where hrtimer_start() may end up trying to
> acquire the runqueue lock. This happens on a context switch where the
> current thread is blocking (not preempted) and the new timeout happens
> to be either in the past or just expiring. We've run into such
> situations with simple tests.
> 
> On all architectures, but IA-64, it seems thet the runqueue lock is
> held until the end of schedule(). On IA-64, the lock is released
> BEFORE switch_to() for some reason I don't quite remember. That may
> not even be needed anymore.
> 
> The early unlocking is controlled by a macro named
> __ARCH_WANT_UNLOCKED_CTXSW. Defining this macros on X86 (or PPC) fixed
> our problem.
> 
> It is not clear to me why the runqueue lock needs to be held up until
> the end of schedule() on some platforms and not on others. Not that
> releasing the lock earlier does not necessarily introduce more
> overhead because the lock is never re-acquired later in the schedule()
> function.
> 
> Question:
>    - is it safe to release the lock before switch_to() on all architectures?

I had similar problem when using hrtimers from the scheduler, I extended
the HRTIMER_CB_IRQSAFE_NO_SOFTIRQ time type to run with cpu_base->lock
unlocked.

http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-sched-devel.git;a=commitdiff;h=7e7cbd617833dde5b442e03f69aac39d17d02ec7
http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-sched-devel.git;a=commitdiff;h=45d10aad580a5cdd376e80848aeeaaaf1f97cc18
http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-sched-devel.git;a=commitdiff;h=5ae5d6c5850d4735798bc0e4526d8c61199e9f93

As for your __ARCH_WANT_UNLOCKED_CTXSW question I have to defer to Ingo,
as I'm unaware of the arch ramifications there.



