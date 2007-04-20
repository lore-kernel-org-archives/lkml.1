Return-Path: <linux-kernel-owner+w=401wt.eu-S2993306AbXDTSCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993306AbXDTSCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993310AbXDTSCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:02:51 -0400
Received: from mail.screens.ru ([213.234.233.54]:42066 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993306AbXDTSCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:02:49 -0400
Date: Fri, 20 Apr 2007 22:02:08 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mingo@elte.hu, vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC PATCH 1/2] Fix PF_NOFREEZE and freezeable race
Message-ID: <20070420180208.GA721@tv-sign.ru>
References: <20070419120131.GB13435@in.ibm.com> <20070419120234.GA17069@in.ibm.com> <200704192339.30783.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704192339.30783.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19, Rafael J. Wysocki wrote:
> 
> On Thursday, 19 April 2007 14:02, Gautham R Shenoy wrote:
> > This patch fixes the race pointed out by Oleg Nesterov.
> > 
> > * Freezer marks a thread as freezeable. 
> > * The thread now marks itself PF_NOFREEZE causing it to
> >   freeze on calling try_to_freeze(). Thus the task is frozen, even though
> >   it doesn't want to.
> > * Subsequent thaw_processes() will also fail to thaw the task since it is 
> >   marked PF_NOFREEZE.
> > 
> > Avoid this problem by checking the current task's PF_NOFREEZE status in the 
> > refrigerator before marking current as frozen.
> > 
> > Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> 
> Looks good, although I'm not sure if we don't need to call recalc_sigpending()
> for tasks that turn out to be PF_NOFREEZE.

I agree, we should clear TIF_SIGPENDING. It is not so critical for user-space
tasks, but for the kernel thread it may remain pending forever, causing subtle
failures.

Gautham, isn't it possible to make a more simpler patch ? Just add PF_NOFREEZE
check to frozen_process,

	static inline void frozen_process(struct task_struct *p)
	{
		if (!unlikely(current->flags & PF_NOFREEZE)) {
			p->flags |= PF_FROZEN;
			wmb();
		}
		clear_tsk_thread_flag(p, TIF_FREEZE);
	}

No?

Oleg.

