Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbYKTCF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbYKTCF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 21:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYKTCFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 21:05:50 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37908 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYKTCFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 21:05:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
References: <20081118175901.GA17134@redhat.com>
	<20081119185148.DC1D31544EB@magilla.localdomain>
Date: Wed, 19 Nov 2008 18:00:12 -0800
In-Reply-To: <20081119185148.DC1D31544EB@magilla.localdomain> (Roland
	McGrath's message of "Wed, 19 Nov 2008 10:51:48 -0800 (PST)")
Message-ID: <m1skpncg2b.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Roland McGrath <roland@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0054]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/2] protect /sbin/init from unwanted signals more
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:

> The effect is fine, but that seems like a kludgey way to do it.
> I really don't think the sigaction case matters--certainly it will never
> come up with SIGKILL.  What about just this instead?
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -66,6 +66,15 @@ static int sig_ignored(struct task_struct *t, int sig)
>  		return 0;
>  
>  	handler = sig_handler(t, sig);
> +
> +	/*
> +	 * For init, short-circuit any signal without a handler.
> +	 * We won't allow them to be delivered, so don't even queue them.
> +	 */
> +	if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
> +	    (handler == SIG_IGN || handler == SIG_DFL))
> +		return 1;
> +
>  	if (!sig_handler_ignored(handler, sig))
>  		return 0;
>  
> With that, I wonder if the SIGNAL_UNKILLABLE checks in get_signal_to_deliver
> and complete_signal are needed at all.  Hmm, I guess we do because this
> doesn't affect blocked signals, so they might be unblocked and delivered.
> (Note that since it doesn't affect blocked signals, this doesn't break init
> using sigwait if it wanted to.)

Ah.  That answers the question I had bouncing in the back of my head.

My original analysis of the situation was that we should not send blocked signals.
Treating handler != SIG_DFL as a permission check.  Not as an optimization.

Mostly because it is more consistent and uniform.

inits today don't do anything with blocked signals.  They explicitly ignore all signals,
they don't want to deal with an enable those they do.

Which I guess means in practice only SIGKILL and SIGSTOP are especially interesting,
and we can't block those so worrying about blocked signals is no big deal.

Which reminds me.  I need to retest, but I had a case where I had a trivial init
that set all signal handlers to SIG_IGN so it could ignore SIGCHLD.  And not
all of it's children were getting reaped automagically.  Do we have a bug in
the reparenting/reaping logic?

Eric

