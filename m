Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbYB0EVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbYB0EVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 23:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYB0EVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 23:21:35 -0500
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:35717 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753365AbYB0EVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 23:21:34 -0500
X-YMail-OSG: Lk6duNcVM1mkeTqqO4PJoZ9VzKhTSxvkgBT_gc7pQ3raVx7.miRPCEbBXAoqevxvScI0oXPaJJISHrr2dlI5Bz3LAr2I0FXSMRsbxahx18oEej8E.kc48jvr7gR1gWn267NIIZi1pHu2VTTR73k8LUK6j2qHfLZrMi8-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 26 Feb 2008 22:18:48 -0600
From: serge@hallyn.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, Andrew Morgan <morgan@kernel.org>
Subject: Re: Fw: [PATCH 1/1] file capabilities: simplify signal check
Message-ID: <20080227041848.GB8959@vino.hallyn.com>
References: <20080223000237.518aace0.akpm@linux-foundation.org> <m17igu6e73.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17igu6e73.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > um, is that code namespace-clean?
> 
> Choke, gag.
> 
> There are uid namespace issues but since no one has finished the
> uid namespace that I am aware of that is minor.
> 
> However the code does not appear clean/maintainable.  The normal linux
> signal sending policy has already been enforce before we get to this
> point.
> 
> So unless I am totally mistaken the code should read:
> 
> int cap_task_kill(struct task_struct *p, struct siginfo *info,
>                                 int sig, u32 secid)
> {
>         if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
>                 return 0;
> 
>         if (!cap_issubset(p->cap_permitted, current->cap_permitted))
>                 return -EPERM;
> 
> 	return 0;
> }
> 
> Although doing it that way violates:
>        /*
>          * Running a setuid root program raises your capabilities.
>          * Killing your own setuid root processes was previously
>          * allowed.
>          * We must preserve legacy signal behavior in this case.
>          */
> 
> 
> Which says to me the code should really read:
> int cap_task_kill(struct task_struct *p, struct siginfo *info,
>                                 int sig, u32 secid)
> {
> 	return 0;
> }
> 
> The entire point of defining cap_task_kill under
> CONFIG_SECURITY_FILE_CAPABLITIES appears to be deny killing processes
> with more caps.

... and owned by the same uid, since the case of owned by a different
uid is handled earlier.

> Killing processes that we could ordinarily kill 
> which have more caps appears to be precisely the case we have decided
> to allow.

Yes, although it might be a good idea to be stricter when
issecure(SECURE_NOROOT), which will become meaningful when Andrew
Morgan's per-process securebits patch gets more use.

> So the patched version of cap_task_kill appears to be an
> expensive way of doing nothing, just waiting for someone to complain
> about the last couple of cases it denies until it is truly a noop.

Yes, the only difference right now is that some of the euid/uid/suid
combos aren't allowed for in cap_task_kill().  If we're not going to
be stricter with SECURE_NOROOT, then I plan to try to remove
cap_task_kill() and just apologize for the huge mess it caused.

-serge

> > Thanks.
> >
> > Begin forwarded message:
> >
> > Date: Wed, 20 Feb 2008 10:15:50 -0600
> > From: "Serge E. Hallyn" <serue@us.ibm.com>
> > To: lkml <linux-kernel@vger.kernel.org>
> > Subject: [PATCH 1/1] file capabilities: simplify signal check
> >
> >
> >>From bd076c7245d02be0cc01b7c09bd7170ec5946492 Mon Sep 17 00:00:00 2001
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Date: Sun, 17 Feb 2008 20:28:07 -0500
> > Subject: [PATCH 1/1] file capabilities: simplify signal check
> >
> > Simplify the uid equivalence check in cap_task_kill().  Anyone
> > can kill a process owned by the same uid.
> >
> > Without this patch wireshark is reported to fail.
> >
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
> > ---
> >  security/commoncap.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index 5aba826..bb0c095 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -552,7 +552,7 @@ int cap_task_kill(struct task_struct *p, struct siginfo
> > *info,
> >  	 * allowed.
> >  	 * We must preserve legacy signal behavior in this case.
> >  	 */
> > -	if (p->euid == 0 && p->uid == current->uid)
> > +	if (p->uid == current->uid)
> >  		return 0;
> >  
> >  	/* sigcont is permitted within same session */
> > -- 
> > 1.5.1.1.GIT
> 
> So it looks to me like we should just give up trying to deny a few
> cases now.
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 5aba826..c1d1fd7 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -540,41 +540,6 @@ int cap_task_setnice (struct task_struct *p, int nice)
>  	return cap_safe_nice(p);
>  }
>  
> -int cap_task_kill(struct task_struct *p, struct siginfo *info,
> -				int sig, u32 secid)
> -{
> -	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
> -		return 0;
> -
> -	/*
> -	 * Running a setuid root program raises your capabilities.
> -	 * Killing your own setuid root processes was previously
> -	 * allowed.
> -	 * We must preserve legacy signal behavior in this case.
> -	 */
> -	if (p->euid == 0 && p->uid == current->uid)
> -		return 0;
> -
> -	/* sigcont is permitted within same session */
> -	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
> -		return 0;
> -
> -	if (secid)
> -		/*
> -		 * Signal sent as a particular user.
> -		 * Capabilities are ignored.  May be wrong, but it's the
> -		 * only thing we can do at the moment.
> -		 * Used only by usb drivers?
> -		 */
> -		return 0;
> -	if (cap_issubset(p->cap_permitted, current->cap_permitted))
> -		return 0;
> -	if (capable(CAP_KILL))
> -		return 0;
> -
> -	return -EPERM;
> -}
> -
>  /*
>   * called from kernel/sys.c for prctl(PR_CABSET_DROP)
>   * done without task_capability_lock() because it introduces
> @@ -605,13 +570,13 @@ int cap_task_setnice (struct task_struct *p, int nice)
>  {
>  	return 0;
>  }
> +#endif
> +
>  int cap_task_kill(struct task_struct *p, struct siginfo *info,
>  				int sig, u32 secid)
>  {
>  	return 0;
>  }
> -#endif
> -
>  void cap_task_reparent_to_init (struct task_struct *p)
>  {
>  	cap_set_init_eff(p->cap_effective);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
