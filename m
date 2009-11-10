Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbZKJT2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbZKJT2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757859AbZKJT2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:28:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757847AbZKJT2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:28:38 -0500
Date: Tue, 10 Nov 2009 20:23:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: utime/stime decreasing on thread exit
Message-ID: <20091110192327.GA16325@redhat.com>
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com> <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop> <20091109172020.GA7751@redhat.com> <1257787903.4108.345.camel@laptop> <20091109192355.GA13724@redhat.com> <20091110104452.GB2391@dhcp-lab-161.englab.brq.redhat.com> <20091110174008.GA12909@redhat.com> <20091110182415.GB6066@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110182415.GB6066@dhcp-lab-161.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10, Stanislaw Gruszka wrote:
>
> On Tue, Nov 10, 2009 at 06:40:08PM +0100, Oleg Nesterov wrote:
> > >
> > > Or stay with task_cputime_expired() but only if cputimer is currently running.
> >
> > Oh. I forgot this code completely, can't comment.
> >
> > Can't we ensure that fastpath_timer_check() never do while_each_thread() ?
>
> Removing possibility to call while_each_tread() from fastpath_timer_check()
> was exactly my intension here, perhaps I was not clear.

Yes, yes, I understand.

I meant, perhaps we can ensure this shouldn't happen "by design", instead
of checking ->running in fastpath_timer_check().

> > IOW, if sig->cputime_expires != 0 then ->running must be true.
> > At least, shouldn't stop_process_timers() clear sig->cputime_expires ?
>
> I'm going to think about that. However as far seems, checking ->running
> explicitly and goto slow patch when is not true is safer solution.

Yes, agreed.


Still. check_process_timers() updates sig->cputime_expires at the end,
but it never clears it. For example,

	if (sched_expires != 0 &&
	    (sig->cputime_expires.sched_exp == 0 ||
	     sig->cputime_expires.sched_exp > sched_expires))
		sig->cputime_expires.sched_exp = sched_expires;

Why?

Now suppose that (say) sig->cputime_expires.sched_exp != 0, there are
no cpu timers, ->running == F.

In this case fastpath_timer_check() always returns T and triggers the
slow path which does nothing, not good.

But yes, I agree, probably we should start with the simple/safe change
as you suggested.

Oleg.

