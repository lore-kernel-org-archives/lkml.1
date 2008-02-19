Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbYBSJxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbYBSJxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYBSJxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:53:30 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:35321 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYBSJx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:53:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YQLsgAWLPER6sl26cUpTQKzDuXO67nRyRjH1Pje9cBfrtvQVLeaT24YSPG8V0g302nGmx4W0sJs0J3rBNHSXTvwrvcJFbXRVBObHftNdtG9aBv9djMYGe7VAsEQwjEfjoJjL5BFyKTlpimjwfDYy4vXz2qoXs8/DVnohmK+MzZU=
Message-ID: <b647ffbd0802190153m3c93b500k3773e74fdd5a0f59@mail.gmail.com>
Date: Tue, 19 Feb 2008 10:53:28 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH, RFC] kthread: (possibly) a missing memory barrier in kthread_stop()
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rusty Russel" <rusty@rustcorp.com.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1203413060.10858.82.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203375817.7619.73.camel@earth>
	 <200802191744.45281.nickpiggin@yahoo.com.au>
	 <1203413060.10858.82.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/2008, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  [ ... ]
> > >
> > > From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> > > Subject: kthread: add a memory barrier to kthread_stop()
> > >
> > > 'kthread' threads do a check in the following order:
> > > - set_current_state(TASK_INTERRUPTIBLE);
> > > - kthread_should_stop();
> > >
> > > and set_current_state() implies an smp_mb().
> > >
> > > on another side (kthread_stop), wake_up_process() is not guaranteed to
> > > act as a full mb.
> > >
> > > 'kthread_stop_info.k' must be visible before wake_up_process() checks
> > > for/modifies a state of the 'kthread' task.
> > >
> > >
> > > Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> > >
> > >
> > > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > > index 0ac8878..5167110 100644
> > > --- a/kernel/kthread.c
> > > +++ b/kernel/kthread.c
> > > @@ -211,6 +211,10 @@ int kthread_stop(struct task_struct *k)
> > >
> > >     /* Now set kthread_should_stop() to true, and wake it up. */
> > >     kthread_stop_info.k = k;
> > > +
> > > +   /* The previous store operation must not get ahead of the wakeup. */
> > > +   smp_mb();
>
> Does this not also imply you need a matching barrier in
> kthread_should_stop() ?

Yes, but only when it's used in combination with something that alters
a state of the task.

So it's rather a question of the interface-design.

We currently impose a requirement on how a main loop of 'kthread'
threads (ok, so it seems to dictate a policy :-) has to be orginized.
Namely, the following sequence must be kept in order:

(1) set_current_task(TASK_INTERRUPTIBLE);
(2) kthread_should_stop()
...
- schedule()

and (1) already provides a mb which becomes a "matching barrier" on
the kthread_should_stop() side.


-- 
Best regards,
Dmitry Adamushko
