Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZD2MA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZD2MA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZD2MAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:00:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43000 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbZD2MAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:00:12 -0400
Date: Wed, 29 Apr 2009 13:55:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Message-ID: <20090429115550.GA25368@redhat.com>
References: <20090429102511.GA10767@redhat.com> <20090429065809.GA477@redhat.com> <20090428223025.GA11997@redhat.com> <alpine.LRH.2.00.0904291024001.5246@tundra.namei.org> <7242.1240999370@redhat.com> <7150.1241003840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7150.1241003840@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > I suspect we should pass SIGKILL
> >
> > Or we can fliter out SIGKILLs, yes.
>
> How about the attached patch?

Heh. I did the very similar patch. It wasn't sent because I'd like to
understand flush_signal_handlers + sigemptyset first.

But,

> @@ -2398,11 +2398,14 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
>  		memset(&itimer, 0, sizeof itimer);
>  		for (i = 0; i < 3; i++)
>  			do_setitimer(i, &itimer, NULL);
> -		flush_signals(current);
>  		spin_lock_irq(&current->sighand->siglock);
> -		flush_signal_handlers(current, 1);
> -		sigemptyset(&current->blocked);
> -		recalc_sigpending();
> +		if (!sigismember(&current->pending.signal, SIGKILL) &&
> +		    !sigismember(&current->signal->shared_pending.signal,
> +				 SIGKILL)) {

No, no. Just

		if (!(current->signal->flags & SIGNAL_GROUP_EXIT))
			__flush_signals();

is enough and more clean imho. The fact that we _really_ have the pending
SIGKILL is just the implementation detail (and perhaps this we be changed
eventually).

No need to check ->shared_pending + ->pending. We can't have SIGKILL
(shared or not) without SIGNAL_GROUP_EXIT.

Oleg.

