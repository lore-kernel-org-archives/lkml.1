Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZAJP7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZAJP7q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZAJP7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:59:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47746 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZAJP7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:59:36 -0500
Date: Sat, 10 Jan 2009 16:57:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Scott James Remnant <scott@canonical.com>
Cc: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090110155720.GA10954@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107205322.5F8C7FC3E0@magilla.sf.frob.com> <1231598714.11642.53.camel@quest>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231598714.11642.53.camel@quest>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Scott James Remnant wrote:
>
> On Wed, 2009-01-07 at 12:53 -0800, Roland McGrath wrote:
>
> > New syscall should have gone to linux-api, I think.
> >
> > Do we really need another one for this?  How about using signalfd plus
> > setting the child's exit_signal to a queuing (SIGRTMIN+n) signal instead of
> > SIGCHLD?  It's slightly more magical for the userland process to know to do
> > that (fork -> clone SIGRTMIN).  But compared to adding a syscall we don't
> > really have to add, maybe better.
> >
> This wouldn't help the init daemon case:
>
> - the exit_signal is set on the child, not on the parent.
>
>   While the init daemon could clone() every new process and set
>   exit_signal, this would not be set for processes reparented to init.
>
>   Even if we had a new syscall to change the exit_signal of a given
>   process, *and* had the init reparent notification patch, this still
>   wouldn't be sufficient; you'd have a race condition between the time
>   you were notified of the reparent, and the time you set exit_signal,
>   in which the child could die.
>
>   Since exit_signal is always reset to SIGCHLD before reparenting, this
>   could be done by resetting it to a different signal; but at this point
>   we're getting into a rather twisty method full of traps.
>
> - exit_signal is reset to SIGCHLD on exec().
>
>   Pretty much a plan-killer ;)

I can't understand why should we change ->exit_signal if we want to
use signalfd. Yes, SIGCHLD is not rt. So what?

We do not need multiple signals in queue if we want to reap multiple
zombies. Once we have a single SIGCHLD (reported by signalfd or
whatever) we can do do_wait(WNOHANG) in a loop.

Confused.

Oleg.

