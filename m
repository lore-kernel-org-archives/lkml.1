Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbZAHOej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbZAHOej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757484AbZAHOeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:34:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60979 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045AbZAHOea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:34:30 -0500
Date: Thu, 8 Jan 2009 15:32:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090108143220.GA8717@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107205322.5F8C7FC3E0@magilla.sf.frob.com> <a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07, Ulrich Drepper wrote:
>
> On Wed, Jan 7, 2009 at 12:53 PM, Roland McGrath <roland@redhat.com> wrote:
> > Do we really need another one for this?  How about using signalfd plus
> > setting the child's exit_signal to a queuing (SIGRTMIN+n) signal instead of
> > SIGCHLD?  It's slightly more magical for the userland process to know to do
> > that (fork -> clone SIGRTMIN).  But compared to adding a syscall we don't
> > really have to add, maybe better.
>
> Since waitfd shouldn't consume the child termination notification
> waitfd should be more widely usable than the wait*() interfaces.

yes, it doesn't eat the notification (SIGCHLD), but it reaps a
zombie, clears ->exit_code TASK_STOPPED/TASK_TRACED tasks, clears
SIGNAL_STOP_CONTINUED.

> I.e., it's not necessary to restrict the use to parents.  Any process
> with the same UID should be allowed to call waitfd.  This would allow
> some new user cases.

I don't see how it is possible to implement this...

The parent can sleep on ->wait_chldexit and it will be notified, but
how can we wait for the unrelated process with the same UID ?

Even if sys_waitfd() uses P_PID, we can't use task->parent->signal->wait_chldexit,
task->parent can exit before task exits.


Or I misunderstood you?

Oleg.

