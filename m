Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbYBSNLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbYBSNLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYBSNLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:11:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:55363 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYBSNLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:11:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hz8idOXFvxj0+0CHj6lp5PEv/NbxddzSwR5Dlqeo1tLHK786Lp3NATJZC+Wpk+R4BGBkglu6+iTxuMS124wrX1rmBJOjfH88ams9c8f5+D2UGoZRiQWswwH7wN4rozeVREYJmszOT1DXh/eQbftnunYB6iRC3qenu75PXbSQsHk=
Message-ID: <b647ffbd0802190511u44fc8353wa4cbb290bcf371ae@mail.gmail.com>
Date: Tue, 19 Feb 2008 14:11:30 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH, RFC] kthread: (possibly) a missing memory barrier in kthread_stop()
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Rusty Russel" <rusty@rustcorp.com.au>
In-Reply-To: <20080219130033.GK24479@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203375817.7619.73.camel@earth>
	 <20080219130033.GK24479@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/2008, Andy Whitcroft <apw@shadowen.org> wrote:
> [ ... ]
>
> > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > index 0ac8878..5167110 100644
> > --- a/kernel/kthread.c
> > +++ b/kernel/kthread.c
> > @@ -211,6 +211,10 @@ int kthread_stop(struct task_struct *k)
> >
> >       /* Now set kthread_should_stop() to true, and wake it up. */
> >       kthread_stop_info.k = k;
> > +
> > +     /* The previous store operation must not get ahead of the wakeup. */
> > +     smp_mb();
> > +
> >       wake_up_process(k);
> >       put_task_struct(k);
>
> The rules as written do seem to support your theory.  The CPU has every
> right to delay the .k = k as late as the UNLOCK operation.
>
> On the read-side there is a full barrier implied by the
> set_current_state(TASK_INTERRUPTIBLE), however this synchronises us with
> the current global state, which may well not have the updated version
> of .k.

yes.

>
> That seems to imply that a write memory barrier would be sufficient to
> cover this.
>
> So three comments.  First, should this not be an smp_wmb.

No. We also need to be sure that ".k = k" is updated by the moment we
check for a state of the task in try_to_wake_up(), so that's write vs.
read ops.

The point is that a 'kthread' loop does :

(1) set TASK_INTERRUPTIBLE
(2) check for .k == k

and kthread_stop() must do it in the _reverse_ order:

(1) .k = k
(2) check for a task state and wakeup if necessary.

Only this way we ensure that a wakeup is not lost.

>  Second, this
> memory barrier is paired with the barrier in
> set_current_state(TASK_INTERRUPTIBLE) and that probabally should be
> documented as part of this patch.  Finally, I think the comment as is is
> hard to understand I got the sense of it backwards on first reading;
> perhaps something like this:
>
>         /*
>          * Ensure kthread_stop_info.k is visible before wakeup, paired
>          * with barrier in set_current_state().
>          */

Yes, I'll try to come up with a better description.


>
> -apw
>

-- 
Best regards,
Dmitry Adamushko
