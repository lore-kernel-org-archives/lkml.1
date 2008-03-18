Return-Path: <linux-kernel-owner+w=401wt.eu-S933366AbYCSXgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366AbYCSXgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939580AbYCSWGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:06:51 -0400
Received: from smtp113.sbc.mail.re2.yahoo.com ([68.142.229.92]:33184 "HELO
	smtp113.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762735AbYCSWGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:06:49 -0400
X-YMail-OSG: wmeheIYVM1lBABSCSnWys3gP1G1qi4TrnH_o6Nf0CtuWeoKDKNHQJfA_MeRqwV4VxlOB6haC1FwSu3ctUN_kJRU4ag--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 18 Mar 2008 15:03:04 -0500
From: serge@hallyn.com
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Tsuji <a-tsuji@bk.jp.nec.com>,
       Roland McGrath <roland@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH] signals: check_kill_permission: check session under
	tasklist_lock
Message-ID: <20080318200304.GA23859@vino.hallyn.com>
References: <20080304185745.GA8482@tv-sign.ru> <47DE5665.2030802@bk.jp.nec.com> <20080317170124.GA115@tv-sign.ru> <20080318144431.GA3384@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318144431.GA3384@tv-sign.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@tv-sign.ru):
> (on top of signals-cleanup-security_task_kill-usage-implementation.patch)
> 
> This wasn't documented, but as Atsushi Tsuji <a-tsuji@bk.jp.nec.com> pointed
> out check_kill_permission() needs tasklist_lock for task_session_nr().
> I missed this fact when removed tasklist from the callers.
> 
> Change check_kill_permission() to take tasklist_lock for the SIGCONT case.
> Re-order security checks so that we take tasklist_lock only if/when it is
> actually needed. This is a minimal fix for now, tasklist will be removed
> later.
> 
> Also change the code to use task_session() instead of task_session_nr().
> 
> Also, remove the SIGCONT check from cap_task_kill(), it is bogus (and the
> whole function is bogus. Serge, Eric, why it is still alive?).
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> --- 25/kernel/signal.c~CKP_TAKE_TASKLIST	2008-03-18 14:47:00.000000000 +0300
> +++ 25/kernel/signal.c	2008-03-18 17:25:19.000000000 +0300
> @@ -533,6 +533,7 @@ static int rm_from_queue(unsigned long m
>  static int check_kill_permission(int sig, struct siginfo *info,
>  				 struct task_struct *t)
>  {
> +	struct pid *sid;
>  	int error;
>  
>  	if (!valid_signal(sig))
> @@ -545,11 +546,24 @@ static int check_kill_permission(int sig
>  	if (error)
>  		return error;
>  
> -	if (((sig != SIGCONT) || (task_session_nr(current) != task_session_nr(t)))
> -	    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
> -	    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
> -	    && !capable(CAP_KILL))
> -		return -EPERM;
> +	if ((current->euid ^ t->suid) && (current->euid ^ t->uid) &&
> +	    (current->uid  ^ t->suid) && (current->uid  ^ t->uid) &&
> +	    !capable(CAP_KILL)) {
> +		switch (sig) {
> +		case SIGCONT:
> +			read_lock(&tasklist_lock);
> +			sid = task_session(t);
> +			read_unlock(&tasklist_lock);
> +			/*
> +			 * We don't return the error if sid == NULL. The
> +			 * task was unhashed, the caller must notice this.
> +			 */
> +			if (!sid || sid == task_session(current))
> +				break;

Nice, in addition to a bugfix this is also far more readable.

> +		default:
> +			return -EPERM;
> +		}
> +	}
>  
>  	return security_task_kill(t, info, sig, 0);
>  }
> --- 25/security/commoncap.c~CKP_TAKE_TASKLIST	2008-03-18 17:07:02.000000000 +0300
> +++ 25/security/commoncap.c	2008-03-18 17:21:10.000000000 +0300
> @@ -552,10 +552,6 @@ int cap_task_kill(struct task_struct *p,
>  	if (p->uid == current->uid)
>  		return 0;
>  
> -	/* sigcont is permitted within same session */
> -	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
> -		return 0;
> -
>  	if (secid)
>  		/*
>  		 * Signal sent as a particular user.

Note that cap_task_kill() should be gone anyway.  What tree were you
basing this on?

thanks,
-serge
