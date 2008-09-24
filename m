Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbYIXQw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbYIXQw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYIXQwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:52:50 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:52420 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbYIXQwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:52:50 -0400
Date: Wed, 24 Sep 2008 20:58:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Chad Zanonie <chad.zanonie@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       rientjes@google.com
Subject: Re: + mm-oom-killer-kills-more-than-needed.patch added to -mm tree
Message-ID: <20080924165842.GA5355@tv-sign.ru>
References: <200809222238.m8MMcgAp001695@imap1.linux-foundation.org> <20080923124035.GA253@tv-sign.ru> <2137b82d0809231025n359b3f59h53714d5acabd2107@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2137b82d0809231025n359b3f59h53714d5acabd2107@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23, Chad Zanonie wrote:
>
> On Tue, Sep 23, 2008 at 5:40 AM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > On 09/22, Andrew Morton wrote:
> >>
> >> ------------------------------------------------------
> >> Subject: mm: oom-killer kills more than needed
> >> From: "Chad Zanonie" <chad.zanonie@gmail.com>
> >>
> >> Possibility exists for an exiting application to be in between marking its
> >> mm NULL and calling mmput when out_of_memory is invoked.
> >> select_bad_process() will continue past this process as opposed to
> >> returning -1UL due to its mm being NULL.  This causes the oom killer in
> >> certain scenarios to not only kill the memory culprit, but also kill the
> >> runner up.
> >>
> >> EXIT_DEAD seems to be the only flag that guarantees that mmput() has
> >> finished.
> >
> > I don't think this is right.
> >
> > Let's suppose we have a single zombie. Now select_bad_process() always
> > returns -1 ? IOW, doesn't this means that, say,
> >
> >        $ perl -e 'fork && sleep'
> >
> > disables oom-kill completely and forever?
>
> Ugh, looks like my description was slightly incorrect. I don't mean
> for it to return -1 upon noticing a null mm. I mean for
> select_bad_process to not skip (continue) over processes that haven't
> provably finished unmapping their memory

Yes I see. But if select_bad_process() sees the PF_EXITING task it returns
-1 (unless the task == current). So, with this change select_bad_process()
will return -1 more often, because it doesn't skip the tasks without ->mm.
And of course, !mm implies PF_EXITING.

I don't claim this is wrong. Unless we use EXIT_DEAD as the patch did, in
that case the 'fork && sleep' above really disables oom-kill.

I must admit I don't understand why this change is good but this does not
matter, I don't understand oom-kill anyway (but I think it has numerous
bugs ;).

> Before I propagate this blunder anymore, I've found the root of my mistake.
>
> I really mean TASK_DEAD, not EXIT_DEAD.
>
> (p->state & TASK_DEAD)

Yes, this should work. But I think this "defers" the decision too far.

You can check "p->exit_state != 0". But still this is a bit strange,
and needs a comment. For example, you can check p->files == NULL with
the same effect to verify that the task has already passed
exit_mm()->mmput().

The task can spend a lot of time before it sets TASK_DEAD or ->exit_state,
and again, during this time oom-kill will be "disabled". Contrary,
the window between "tsk->mm = NULL;" and mmput() in exit_mm() is very
small. Well, unless CONFIG_MM_OWNER.


In short, I can't judge this patch, but could you please improve the
changelog?

Oleg.

