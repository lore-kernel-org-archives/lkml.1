Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZBICIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZBICIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 21:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbZBICIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 21:08:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42470 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbZBICIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 21:08:12 -0500
Date: Mon, 9 Feb 2009 03:05:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace_detach: the wrong wakeup breaks the
	ERESTARTxxx logic
Message-ID: <20090209020515.GA28280@redhat.com>
References: <20090208184724.GA27074@redhat.com> <20090209013455.CB996FC330@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209013455.CB996FC330@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08, Roland McGrath wrote:
>
> > This is because ptrace_detach does:
> >
> > 	if (!child->exit_state)
> > 		wake_up_process(child);
>
> I'm pretty sure that all these uses of wake_up_process were just blindly
> copied from an original use in ptrace code (what's now ptrace_resume).
> That original use just dates from the beforetime, the long long ago.
> (I don't think it indicates any coherent original intent.)
>
> It's many kinds of wrong.  It's also always been wrong in case of a
> simultaneous SIGKILL that already woke the child, which has then blocked on
> some mutex or semaphore or whatnot.  I don't know what the stated general
> policy about spurious wakeups from schedule() is supposed to be.  Perhaps
> to be pedantic, the sys_pause() code has been wrong to return without
> checking signal_pending().

Yes, I thought about fixing sys_pause() too, but I'm afraid we can have
the similar code.

> Frankly, I've always been afraid of strange cruft that might unexpectedly
> turn out to rely on this "wrong" (unconditional) wake-up.  Probably the
> things like that historically were all just to do with the stopped/traced
> bookkeeping and would be covered by explicitly dealing with PTRACE_CONT vs
> group stop et al.  But FWIW my reaction to fiddling the wake_up_process
> bogons in the past has been, "Be afraid."

Yes, I am afraid, seriously ;)

This can reveal other subtle problems, of course. But there is another reason
why this wakeup is wrong. It clearly breaks the SIGNAL_GROUP_STOPPED logic
in ptrace_untrace().

Oleg.

