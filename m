Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYLPKST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYLPKST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 05:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYLPKSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 05:18:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55903 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbYLPKSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 05:18:09 -0500
Date: Tue, 16 Dec 2008 11:16:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: roland@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, bastian@waldi.eu.org,
       sukadev@us.ibm.com, Albert Cahalan <acahalan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Fix si_pid in send_signal() for SEND_SIG_NOINFO
Message-ID: <20081216101621.GA2784@redhat.com>
References: <20081213024129.GB4256@us.ibm.com> <20081215143723.GA22386@redhat.com> <20081215203715.GC11958@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215203715.GC11958@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15, Sukadev Bhattiprolu wrote:
>
> Oleg Nesterov [oleg@redhat.com] wrote:
> | On 12/12, Sukadev Bhattiprolu wrote:
> | >
> | > --- a/kernel/signal.c
> | > +++ b/kernel/signal.c
> | > @@ -856,7 +856,8 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
> | >  			q->info.si_signo = sig;
> | >  			q->info.si_errno = 0;
> | >  			q->info.si_code = SI_USER;
> | > -			q->info.si_pid = task_pid_vnr(current);
> | > +			q->info.si_pid = task_tgid_nr_ns(current,
> | > +							task_active_pid_ns(t));
> |
> | I agree with the patch, but you also changed "pid" to "tgid",
> | and the changelog says nothing about this.
>
> Yes, I should have mentioned it in the changelog.
> |
> | Actually, this looks more correct to me, but did you check we
> | don't break something?
>
> Besides running some tests and LTP and posting as [rfc] not sure how
> else to check for breakage :-) Appreciate any pointers to tests for
> signals.
>
> I had seen an earlier version of this patch which mentioned that
> POSIX requires tgid rather than pid. And that looked logical to
> me

Let me repeat, I think this is more correct too, and personally
I agree with this change.

But I do not know if this change is "safe", please see below.

> and did not know about follow requirement on pdeath_signal.

Sorry for confusion, I didn't mean this will confuse the users
of ->pdeath_signal, I just do not know. But they need the
notificatation about the thread, not process.

> | For example, ->pdeath_signal. Note that we send it even if we
> | re-parent to sub-thread, not to our init. Yes, yes, yes. This
> | is imho very ugly and we should stop doing this. But we have
> | users which claim they need exactly this behaviour.
>
> Ok. so should I change it to task_pid_nr_ns() ?

I don't know. I vote for your patch as is. (but please update
the changelog).

> Would that still
> be correct for say the SIGPIPE from pipe_write() ?

Again, I don't know.

But. Let's suppose we have the user-space application which
uses .si_pid to figure out which thread hits SIGPIPE. Yes,
this is ugly because the signal is thread-specific, but this
works until this patch.

Actually, I don't understand most of (all?) users of
send_signal(SIGXXX, current, 0), SEND_SIG_PRIV looks more
logical to me. Or, _perhaps_, we need yet another SEND_SIG_SELF
which sets .si_pid = task_pid_vnr(target).

Oleg.

