Return-Path: <linux-kernel-owner+w=401wt.eu-S1764794AbZFORSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764794AbZFORSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZFORSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:18:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56198 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbZFORSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:18:04 -0400
Date: Mon, 15 Jun 2009 19:13:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Use copy_wait_opts_to_user() in
	wait_task_continued()
Message-ID: <20090615171325.GA8711@redhat.com>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com> <1242048349-2766-6-git-send-email-v.mayatskih@gmail.com> <20090615165536.GC7425@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615165536.GC7425@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15, Oleg Nesterov wrote:
>
> On 05/11, Vitaly Mayatskikh wrote:
> >
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -1416,19 +1416,16 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
> >  	get_task_struct(p);
> >  	read_unlock(&tasklist_lock);
> >
> > -	if (!wo->wo_info) {
> > -		retval = wo->wo_rusage
> > -			? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
> > -		put_task_struct(p);
> > -		if (!retval && wo->wo_stat)
> > -			retval = put_user(0xffff, wo->wo_stat);
> > -		if (!retval)
> > -			retval = pid;
> > -	} else {
> > -		retval = wait_noreap_copyout(wo, p, pid, uid,
> > -					     CLD_CONTINUED, SIGCONT);
> > -		BUG_ON(retval == 0);
> > -	}
> > +	retval = copy_wait_opts_to_user(wo, p, pid, uid,
> > +					CLD_CONTINUED, SIGCONT, SIGCHLD);
> > +	put_task_struct(p);
> > +
> > +	if (!retval && wo->wo_stat)
> > +		retval = put_user(0xffff, wo->wo_stat);
>
> This adds another user-visible change. Before the patch, we ignore
> ->wo_stat if ->wo_info != NULL.

Ugh! sorry I was wrong.

->wo_info != NULL means waitid() which sets ->wo_stat = NULL, so this
change is correct.

> I could send the fixes for 3 and 4, but unfortunately Vitaly has
> the vacation now. I think it is better to drop
>
> 	wait_task_-cleanups-split-wait_noreap_copyout.patch
> 	wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch
> 	wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch
> 	wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch
> 	wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch
>
> patches, and wait for Vitaly to redo/resend.

Still I think this would be right :/


Unless Vitaly can see my emails and reply.

Oleg.

