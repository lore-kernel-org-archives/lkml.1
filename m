Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZKJSZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZKJSZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZKJSZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:25:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZKJSZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:25:56 -0500
Date: Tue, 10 Nov 2009 19:24:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: utime/stime decreasing on thread exit
Message-ID: <20091110182415.GB6066@dhcp-lab-161.englab.brq.redhat.com>
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com> <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop> <20091109172020.GA7751@redhat.com> <1257787903.4108.345.camel@laptop> <20091109192355.GA13724@redhat.com> <20091110104452.GB2391@dhcp-lab-161.englab.brq.redhat.com> <20091110174008.GA12909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110174008.GA12909@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 06:40:08PM +0100, Oleg Nesterov wrote:
> > One other exception is:
> > fastpath_timer_check() -> thread_group_cputimer() -> thread_group_cputime()
> >
> > We can solve this like that:
> >
> > --- a/kernel/posix-cpu-timers.c
> > +++ b/kernel/posix-cpu-timers.c
> > @@ -1375,13 +1375,8 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
> >  	}
> >
> >  	sig = tsk->signal;
> > -	if (!task_cputime_zero(&sig->cputime_expires)) {
> > -		struct task_cputime group_sample;
> > -
> > -		thread_group_cputimer(tsk, &group_sample);
> > -		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
> > -			return 1;
> > -	}
> > +	if (!task_cputime_zero(&sig->cputime_expires))
> > +		return 1;
> >
> >  	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
> >  }
> >
> > Or stay with task_cputime_expired() but only if cputimer is currently running.
> 
> Oh. I forgot this code completely, can't comment.
> 
> Can't we ensure that fastpath_timer_check() never do while_each_thread() ?

Removing possibility to call while_each_tread() from fastpath_timer_check()
was exactly my intension here, perhaps I was not clear.

> IOW, if sig->cputime_expires != 0 then ->running must be true.
> At least, shouldn't stop_process_timers() clear sig->cputime_expires ?

I'm going to think about that. However as far seems, checking ->running
explicitly and goto slow patch when is not true is safer solution.

Stanislaw
