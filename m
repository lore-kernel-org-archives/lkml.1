Return-Path: <linux-kernel-owner+w=401wt.eu-S1761119AbYF0QbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761119AbYF0QbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYF0QbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:31:05 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34995 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbYF0QbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:31:03 -0400
Date: Fri, 27 Jun 2008 20:33:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch] make siginfo_t si_utime + si_sstime report times in USER_HZ, not HZ
Message-ID: <20080627163333.GB508@tv-sign.ru>
References: <cfd18e0f0806250749od875635r9e533d9f834bd8c4@mail.gmail.com> <20080625153806.GA499@tv-sign.ru> <cfd18e0f0806260809n4370c6eqc07c05ff93029658@mail.gmail.com> <cfd18e0f0806270106s5088327dja804c973bee117d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0806270106s5088327dja804c973bee117d@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27, Michael Kerrisk wrote:
>
> On Thu, Jun 26, 2008 at 5:09 PM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
> > On Wed, Jun 25, 2008 at 5:38 PM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> >> On 06/25, Michael Kerrisk wrote:
> >>>
> >>> --- /home/mtk/ARCHIVE/KERNEL/linux-2.6.26-rc7/kernel/signal.c.orig    2008-06-24
> >>> 16:20:39.000000000 +0200
> >>> +++ /home/mtk/ARCHIVE/KERNEL/linux-2.6.26-rc7/kernel/signal.c 2008-06-24
> >>> 16:22:17.000000000 +0200
> >>> @@ -1379,10 +1379,9 @@
> >>>
> >>>       info.si_uid = tsk->uid;
> >>>
> >>> -     /* FIXME: find out whether or not this is supposed to be c*time. */
> >>> -     info.si_utime = cputime_to_jiffies(cputime_add(tsk->utime,
> >>> +     info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
> >>>                                                      tsk->signal->utime));
> >>> -     info.si_stime = cputime_to_jiffies(cputime_add(tsk->stime,
> >>> +     info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
> >>>                                                      tsk->signal->stime));
> >>>
> >>>       info.si_status = tsk->exit_code & 0x7f;
> >>> @@ -1450,9 +1449,8 @@
> >>>
> >>>       info.si_uid = tsk->uid;
> >>>
> >>> -     /* FIXME: find out whether or not this is supposed to be c*time. */
> >>> -     info.si_utime = cputime_to_jiffies(tsk->utime);
> >>> -     info.si_stime = cputime_to_jiffies(tsk->stime);
> >>> +     info.si_utime = cputime_to_clock_t(tsk->utime);
> >>> +     info.si_stime = cputime_to_clock_t(tsk->stime);
> >>>
> >>>       info.si_code = why;
> >>>       switch (why) {
> >>
> >> This looks like the obviously good fix to me.
> >
> > Tested now, and it does what I expect.
> >
> >> The patch also deletes the comment about signal_struct->cXtime,
> >> this also looks right: why should we use cutime/cstime ?
> >
> > Hmmm -- maybe I was wrong to delete that comment.  I think the point
> > of the comment was: should the time returned vie these fields of the
> > signinfo structure also include the times for (grand)children of the
> > process that had terminated and been wait()ed for.  My first take on
> > that was "no".  But now I'm not 100% sure.  A quick test on Solaris 8
> > suggests that these fields *do* include the times of waited for
> > children.  (None of this is specified in POSIX.1, which doesn't
> > specify si_utime and si_stime.)  I've not yet tested FreeBSD (not sure
> > if it supports these fields or not).
> 
> So, FreeBSD doesn't implement these fields.  A more extensive test
> (see below) on Solaris (8) shows that it does indeed include the times
> of waited-for children in the si_utime and si_stime fields.
> 
> I'm not sure if we should emulate that behavior or not - it'd be easy
> enough to do so of course.  Thoughts, anyone?

Well, I don't know. But since POSIX says nothing, perhaps there is
no reason to change the historical behaviour?

Anyway, I think you were right to kill this comment, it is very old
(from 2.4.26 at least), and confusing. It looks as if it suggests
to use signal->cXtime _instead_ of utime/stime.


Hmm. do_notify_parent_cldstop() only uses tsk->xtime even if we report
CLD_STOPPED, but tsk is the "random" thread which does finish_stop().
I don't know what is the supposed behaviour in that case... but unlikely
we should use signal->cXtime, another reason to kill the comment ;)

Oleg.

