Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbZBCNgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbZBCNgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZBCNgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:36:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58138 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbZBCNgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:36:05 -0500
Date: Tue, 3 Feb 2009 14:33:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kaz Kylheku <kkylheku@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
Message-ID: <20090203133313.GA5679@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com> <20090201174159.4a52e15c.akpm@linux-foundation.org> <20090202064509.GA20237@redhat.com> <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com> <20090202165606.GA13346@redhat.com> <498754EF.8090604@redhat.com> <3f43f78b0902021239s21566f76hf7f59850b2dbf45a@mail.gmail.com> <3f43f78b0902021839j1eb1eb04u49be47277c99900d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f43f78b0902021839j1eb1eb04u49be47277c99900d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02, Kaz Kylheku wrote:
>
> On Mon, Feb 2, 2009 at 12:39 PM, Kaz Kylheku <kkylheku@gmail.com> wrote:
> > On Mon, Feb 2, 2009 at 12:17 PM, Ulrich Drepper <drepper@redhat.com> wrote:
> >> The userlevel context of the
> >> thread is not usable anymore.  It will have run all kinds of
> >> destructors.  The current behavior is AFAIK that the main thread won't
> >> react to any signal anymore.  That is absolutely required.
> >
> > Hey Ulrich,
> >
> > Thanks for articulating that requirement. I think it can be met by
> > extending the patch a little bit.
>
> I've now done that.
>
> The exiting thread leader, if there are still other
> threads alive, gets its own private signal handler array in which
> every action is set to SIG_IGN, using the ignore_signals
> function.
>
> I experimented with blocking signals, but that approach
> breaks the test case of being able to attach GDB to the
> exiting thread.
>
> As part of the patch, I found it convenient to extend the
> incomplete sys_unshare functionality w.r.t. signal handlers,
> rather than reinvent the wheel.

This is wrong, we can not and must not unshare ->sighand.

> Cheers ...
>
> http://sourceware.org/bugzilla/attachment.cgi?id=3702
> http://sourceware.org/bugzilla/attachment.cgi?id=3705

This adds multiple problems. Just for example, fs/proc/ takes
leader->sighand->siglock to protect the list of sub-threads.
Of course this doesn't work any longer after unsharing. And
there are numerous similar problems.

ignore_signals() in do_leader_exit() is not right too. This
thread group should hangle the group-wide signals even if
the main thread exits.

atomic_read(&sigh->count) in unshare_sighand() is racy, and
in fact bogus. (yes, the whole unshare_sighand() is bogus,
it never populates new_sighp).

The changing of ->sighand in do_unshare() is very wrong, we
can free the sighand_struct which is currently locked/used/etc.


Kaz, I don't really understand why you are trying to add these
complications to the kernel :(

If the thread exits - it should exit. Yes, we have problems
with the exited main thread, we should fix them.

Yes, gdb refuses to attach to the dead thread (I didn't check
this myself, but I think you are right). But there is nothing
wrong here, because we can't ptrace this thread. But, gdb
_can_ ptrace the process, and it can see it have other threads.

OK, if nothing else. Let's suppose your patch is correct. What
about robust futexes? How can we delay exit_robust_list() ?
I don't think we can.

Oleg.

