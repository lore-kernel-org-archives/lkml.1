Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZEUOSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZEUOSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZEUOR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:17:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46113 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbZEUOR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:17:58 -0400
Date: Thu, 21 May 2009 16:12:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Split wait_noreap_copyout()
Message-ID: <20090521141250.GC14149@redhat.com>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com> <1242048349-2766-2-git-send-email-v.mayatskih@gmail.com> <87tz3fssv1.wl%vmayatsk@redhat.com> <20090520182118.GA10692@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520182118.GA10692@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, Ingo Molnar wrote:
>
> * Vitaly Mayatskikh <v.mayatskih@gmail.com> wrote:
>
> > 2. Fix copy_wait_opts_to_user to old behaviour by something like:
> >
> > 	if (!retval && (infop || WNOWAIT)) {
> >
> > What's your opinion?
>
> I'd suggest a variant of 2: keep this large-ish patch an equivalent
> transformation - i.e. an impact: cleanup type of change.
>
> Then queue up a patch that removes this quirk.

Yes, this would be the best option.

The problem is, it is not trivial to keep the current behaviour and
make the patch which looks like a cleanup, not uglification.

copy_wait_opts_to_user() needs the new "called_from_wait_task_continued"
argument, and it should do

	if (called_from_wait_task_continued && !wo->wo_info)
		return -EFAULT;

Or we should add

	if (!infop && WNOWAIT)
		return -EFAULT;

to all callers except wait_task_continued().


Roland thinks that "-EFAULT -> success" change is acceptable, and I think
the same. So, to me the best option is just  change the changelog of this
patch and that is all.

Or. We can make a trivial patch which adds the behavior change first:

	Changelog: always accept the NULL infop, because it is not
	possible to understand the current behaviour ;)

	User-visible change! needs Acks!

	--- a/kernel/exit.c
	+++ b/kernel/exit.c
	@@ -1126,24 +1126,26 @@ static int eligible_child(struct wait_op
	 static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
					pid_t pid, uid_t uid, int why, int status)
	 {
	-	struct siginfo __user *infop;
		int retval = wo->wo_rusage
			? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
	-
		put_task_struct(p);
	-	infop = wo->wo_info;
	-	if (!retval)
	-		retval = put_user(SIGCHLD, &infop->si_signo);
	-	if (!retval)
	-		retval = put_user(0, &infop->si_errno);
	-	if (!retval)
	-		retval = put_user((short)why, &infop->si_code);
	-	if (!retval)
	-		retval = put_user(pid, &infop->si_pid);
	-	if (!retval)
	-		retval = put_user(uid, &infop->si_uid);
	-	if (!retval)
	-		retval = put_user(status, &infop->si_status);
	+
	+	if (wo->wo_info) {
	+		struct siginfo __user *infop = wo->wo_info;
	+
	+		if (!retval)
	+			retval = put_user(SIGCHLD, &infop->si_signo);
	+		if (!retval)
	+			retval = put_user(0, &infop->si_errno);
	+		if (!retval)
	+			retval = put_user((short)why, &infop->si_code);
	+		if (!retval)
	+			retval = put_user(pid, &infop->si_pid);
	+		if (!retval)
	+			retval = put_user(uid, &infop->si_uid);
	+		if (!retval)
	+			retval = put_user(status, &infop->si_status);
	+	}
		if (!retval)
			retval = pid;
		return retval;

And then redo Vitaly's patches on top of this change.

What do you and Vitaly think?

Oleg.

