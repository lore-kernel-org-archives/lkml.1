Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYKTTAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYKTTAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYKTTAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:00:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46042 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbYKTTAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:00:44 -0500
Date: Thu, 20 Nov 2008 21:00:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] protect /sbin/init from unwanted signals more
Message-ID: <20081120200050.GA24467@redhat.com>
References: <20081118175901.GA17134@redhat.com> <20081119185148.DC1D31544EB@magilla.localdomain> <m1skpncg2b.fsf@frodo.ebiederm.org> <20081120145234.GA3325@redhat.com> <m13ahm9slb.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13ahm9slb.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > On 11/19, Eric W. Biederman wrote:
> >>
> >> Roland McGrath <roland@redhat.com> writes:
> >>
> >> > With that, I wonder if the SIGNAL_UNKILLABLE checks in get_signal_to_deliver
> >> > and complete_signal are needed at all.  Hmm, I guess we do because this
> >> > doesn't affect blocked signals, so they might be unblocked and delivered.
> >> > (Note that since it doesn't affect blocked signals, this doesn't break init
> >> > using sigwait if it wanted to.)
> >>
> >> Ah.  That answers the question I had bouncing in the back of my head.
> >
> > Even worse. The signal can be dequeued even before unblocked by the target.
> > complete_signal() can "redirect" this signal to another thread wich doesn't
> > block it.
>
> The signal handlers should still be the same.

Yes sure. and the handler can be SIG_DFL.

In short, if we have any reason (we do have) to check sig_kernel_ignore()
in get_signal_to_deliver(), then we have the same reason to check
SIGNAL_UNKILLABLE too.

> >> Which reminds me.  I need to retest, but I had a case where I had a trivial
> > init
> >> that set all signal handlers to SIG_IGN so it could ignore SIGCHLD.  And not
> >> all of it's children were getting reaped automagically.  Do we have a bug in
> >> the reparenting/reaping logic?
> >
> > Ah... I thought this was already fixed... shouldn't reparent_thread()
> > check task_detached() after do_notify() ? like ptrace_exit() does.
>
> Like I said I need to retest.  I was on a 2.6.26 fedora kernel base.
> So if there have been recent bug fixes things may have changed.

I bet the bug is still here.

The fix should be simple, except we can't trust ptrace_reparented().

I'll send the patch, but first I'd like to do another one. Since
I stopped my attempts to understand the orphaned pgrps a long
ago, I hope you can review ;)

Oleg.

