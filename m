Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbYKTNw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbYKTNw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 08:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYKTNwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 08:52:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35058 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbYKTNv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 08:51:59 -0500
Date: Thu, 20 Nov 2008 15:52:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] protect /sbin/init from unwanted signals more
Message-ID: <20081120145234.GA3325@redhat.com>
References: <20081118175901.GA17134@redhat.com> <20081119185148.DC1D31544EB@magilla.localdomain> <m1skpncg2b.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1skpncg2b.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Eric W. Biederman wrote:
>
> Roland McGrath <roland@redhat.com> writes:
>
> > With that, I wonder if the SIGNAL_UNKILLABLE checks in get_signal_to_deliver
> > and complete_signal are needed at all.  Hmm, I guess we do because this
> > doesn't affect blocked signals, so they might be unblocked and delivered.
> > (Note that since it doesn't affect blocked signals, this doesn't break init
> > using sigwait if it wanted to.)
>
> Ah.  That answers the question I had bouncing in the back of my head.

Even worse. The signal can be dequeued even before unblocked by the target.
complete_signal() can "redirect" this signal to another thread wich doesn't
block it.

> My original analysis of the situation was that we should not send blocked signals.
> Treating handler != SIG_DFL as a permission check.  Not as an optimization.
>
> Mostly because it is more consistent and uniform.
>
> inits today don't do anything with blocked signals.

(I guess you mean "with blocked SIG_DFL signals", otherwise this is
 too strong ;)

If init does exec and do not want to miss (say) SIGCHLD, the only option
is to block it before exec. And right after exec the handler is SIG_DFL.

> They explicitly ignore all signals,
> they don't want to deal with an enable those they do.

I do remember I had the (unrelated) bugreport which in particular showed
that user-space sends SIGUSR1 to init. Usually init has a handler and does
something in responce, but sometimes the handler is SIG_DFL. I don't
remember the distribution, ubuntu iirc.

Yes, this perhaps means init is not perfect, but still.

> Which reminds me.  I need to retest, but I had a case where I had a trivial init
> that set all signal handlers to SIG_IGN so it could ignore SIGCHLD.  And not
> all of it's children were getting reaped automagically.  Do we have a bug in
> the reparenting/reaping logic?

Ah... I thought this was already fixed... shouldn't reparent_thread()
check task_detached() after do_notify() ? like ptrace_exit() does.

Oleg.

