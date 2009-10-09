Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbZJIHxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbZJIHxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZJIHxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:53:13 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:44565 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbZJIHxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YpGeRLg1HjuwhPni/FnIrcoBFLPvAZtpdtCYJFDhJj2eIT+3t2pXh6yDaVrJAeiIUh
         8yfAGrt8+qODdfrfXcn7N/HOQPqmv/KN1HmX1tHXuU7jQvGPlGYX5eYcSnGuX6YSNz76
         NBz29pwSDcQoYyNdIo5nt748adg9q3cmFhuic=
MIME-Version: 1.0
In-Reply-To: <a5b3ea7b0910082255x5767726du4721d2ee38df38fa@mail.gmail.com>
References: <a5b3ea7b0910082255x5767726du4721d2ee38df38fa@mail.gmail.com>
Date: Fri, 9 Oct 2009 08:52:35 +0100
Message-ID: <9b2b86520910090052n267f94ebj7619b6c5b94b3539@mail.gmail.com>
Subject: Re: select system call's implementation may have some bug, need your 
	help and confirm !!!
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: wu Jianfeng <stormplayer@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/9/09, wu Jianfeng <stormplayer@gmail.com> wrote:
> A process may sleep for ever when he call select system call.
> In detail, if the process was scheduled out just at the point it set
> its state to TASK_INTERRUPTIBLE.
>
> The events that cause the process to be scheduled out is(in preempt kernel)
> :
> 1) time interrupt and the process's time slice is exhausted.
> 2) an interrupt accured, and wake up another process with high priority.
>
> see the comments after "##"
>
> int do_select(int n, fd_set_bits *fds, s64 *timeout)
> {
> struct poll_wqueues table;
> poll_table *wait;
> int retval, i;
>
> rcu_read_lock();
> retval = max_select_fd(n, fds);
> rcu_read_unlock();
>
> if (retval < 0)
> return retval;
> n = retval;
>
> poll_initwait(&table);
> wait = &table.pt;
> if (!*timeout)
> wait = NULL;
> retval = 0;
> for (;;) {
> unsigned long *rinp, *routp, *rexp, *inp, *outp, *exp;
> long __timeout;
>
> set_current_state(TASK_INTERRUPTIBLE);
> ## here set the process state TASK_INTERRUPTIBLE
>
>  ## if  the process was scheduled out here, then the process will
> never can be waked up, because it has not been attached to any file 's
> wait queue.

I'm not sure about that, but if you look at the current code (e.g. in
linus' git tree) you will see this code has been changed.  Now
set_current_state() is only called from poll_schedule_timeout(), and
it won't suffer from the problem you suggested:


int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
			  ktime_t *expires, unsigned long slack)
{
	int rc = -EINTR;

	set_current_state(state);
	if (!pwq->triggered)
		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
	__set_current_state(TASK_RUNNING);


I don't know the specific reason this was changed.  Try looking at the
git history if you're still curious.

Regards
Alan
