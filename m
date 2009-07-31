Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZGaVEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZGaVEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZGaVEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:04:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42993 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbZGaVEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:04:46 -0400
Date: Fri, 31 Jul 2009 22:52:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@gmail.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       roland <roland@redhat.com>
Subject: Re: [RFC][PATCH] fcntl: F_[SG]ETOWN_TID
Message-ID: <20090731205246.GA3457@redhat.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com> <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com> <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249029320.6391.72.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Peter Zijlstra wrote:
>
> In order to direct the SIGIO signal to a particular thread of a
> multi-threaded application we cannot, like suggested by the manpage, put
> a TID into the regular fcntl(F_SETOWN) call. It will still be send to
> the whole process of which that thread is part.
>
> Since people do want to properly direct SIGIO we introduce F_SETOWN_TID,
> which functions similarly to F_SETOWN, except positive arguments are
> interpreted as TIDs and negative arguments are interpreted as PIDs.

I think this is correct. But,

> @@ -431,6 +474,7 @@ static void send_sigio_to_task(struct task_struct *p,
>  			       int fd,
>  			       int reason)
>  {
> +	int (*send_sig)(int, struct siginfo *, struct task_struct *);
>  	/*
>  	 * F_SETSIG can change ->signum lockless in parallel, make
>  	 * sure we read it once and use the same value throughout.
> @@ -440,6 +484,8 @@ static void send_sigio_to_task(struct task_struct *p,
>  	if (!sigio_perm(p, fown, signum))
>  		return;
>
> +	send_sig = fown->task_only ? send_sig_info : group_send_sig_info;

this is ugly.

I do not blame your patch, I blame signal.c which has a lot of helpers
to send a signal but it is never possible to find the right one.

I think we need a new trivial helper,

	int xxx(int sig, struct siginfo *info, struct task_struct *p, bool group)
	{
		unsigned long flags;
		int ret = -ESRCH;

		if (lock_task_sighand(p, &flags)) {
			ret = send_signal(sig, info, p, group);
			unlock_task_sighand(p, &flags);
		}

		return ret;
	}

send_sigio_to_task() can just do: send_signal(..., !fown->task_only).

group_send_sig_info(), send_sig_info() should use this helper too.


Also. without the new helper, F_SETOWN does check_kill_permission()
while F_SETOWN_TID does not. This doesn't really matter, but this
looks a bit odd.

Note that send_sigio_to_task() does not need check_kill_permission().
We use either SEND_SIG_PRIV or SI_FROMKERNEL() signals, so we never
actually check permissions. Even if we did, it would be just wrong
to deny the signal here using current_cred().


Peter, may I suggest to to re-diff your patch on top of the trivial
patch I am going to send a bit later today?

Oleg.

