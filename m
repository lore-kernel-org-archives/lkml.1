Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZETSVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZETSVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZETSV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:21:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46676 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbZETSV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:21:26 -0400
Date: Wed, 20 May 2009 20:21:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Split wait_noreap_copyout()
Message-ID: <20090520182118.GA10692@elte.hu>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com> <1242048349-2766-2-git-send-email-v.mayatskih@gmail.com> <87tz3fssv1.wl%vmayatsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tz3fssv1.wl%vmayatsk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vitaly Mayatskikh <v.mayatskih@gmail.com> wrote:

> At Mon, 11 May 2009 15:25:50 +0200, Vitaly Mayatskikh wrote:
> > 
> > Move getrusage() and put_user() code from wait_noreap_copyout()
> > to copy_wait_opts_to_user(). The same code is spreaded across all
> > wait_task_*() routines, it's better to reuse one copy.
> > 
> > Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
> > ---
> >  kernel/exit.c |   39 +++++++++++++++++++++++----------------
> >  1 files changed, 23 insertions(+), 16 deletions(-)
> > 
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index 25782da..9546362 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -1123,27 +1123,34 @@ static int eligible_child(struct wait_opts *wo, struct task_struct *p)
> >  	return 1;
> >  }
> >  
> > -static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
> > -				pid_t pid, uid_t uid, int why, int status)
> > +static int copy_wait_opts_to_user(struct wait_opts *wo, struct task_struct *p,
> > +				  pid_t pid, uid_t uid, int why, int status, int signal)
> >  {
> > -	struct siginfo __user *infop;
> > +	struct siginfo __user *infop = wo->wo_info;
> >  	int retval = wo->wo_rusage
> >  		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
> >  
> > +	if (!retval && infop) {
> > +		retval = put_user(signal, &infop->si_signo);
> ...
> > +static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
> > +				pid_t pid, uid_t uid, int why, int status)
> > +{
> > +	int retval = copy_wait_opts_to_user(wo, p, pid, uid, why, status, SIGCHLD);
> >  	put_task_struct(p);
> > -	infop = wo->wo_info;
> > -	if (!retval)
> > -		retval = put_user(SIGCHLD, &infop->si_signo);
> ...
> 
> Oleg has pointed me to broken behaviour here. Previously
> wait_noreap_copyout was doing unconditional put_user and was returning
> EFAULT when infop is NULL. Now it uses copy_wait_opts_to_user, which
> checks infop and return NULL in the same case. This change is visible
> from userspace in waitid() function.
> 
> There're 2 opportunities how to deal with new behaviour:
> 
> 1. Assume wait_task_zombie had a bug previously, and let this patch go.
> 2. Fix copy_wait_opts_to_user to old behaviour by something like:
> 
> 	if (!retval && (infop || WNOWAIT)) {
> 
> What's your opinion?

I'd suggest a variant of 2: keep this large-ish patch an equivalent 
transformation - i.e. an impact: cleanup type of change.

Then queue up a patch that removes this quirk. Should this change 
break any user-space, the quirk can be reinstated promptly, without 
affecting the cleanups. It will also be a very clear, easy target to 
bisect to - not obscured by clean-up details.

Does this sound good to you?

	Ingo
