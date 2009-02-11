Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbZBKKEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbZBKKEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZBKKEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:04:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34524 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZBKKEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:04:37 -0500
Date: Wed, 11 Feb 2009 11:04:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: Re: [PATCH] softlockup: ensure the task has been switched out once
Message-ID: <20090211100432.GF20518@elte.hu>
References: <4991a557.1ade660a.582e.7835@mx.google.com> <20090210181504.GI7332@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210181504.GI7332@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Singh Baines <msb@google.com> wrote:

> Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > When we check if a task has been switched out since the last scan, we might
> > have a race condition on the following scenario:
> > 
> > _ the task is freshly created and scheduled
> > _ it puts its state to TASK_UNINTERRUPTIBLE and is not yet switched out
> > _ check_hung_task() scans this task and will report a false positive because
> >   t->nvcsw + t->nivcsw == t->last_switch_count == 0
> > 
> > Add a check for such cases.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/hung_task.c |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> > index 0c924de..022a492 100644
> > --- a/kernel/hung_task.c
> > +++ b/kernel/hung_task.c
> > @@ -72,7 +72,13 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
> >  {
> >  	unsigned long switch_count = t->nvcsw + t->nivcsw;
> >  
> > -	if (t->flags & PF_FROZEN)
> > +	/*
> > +	 * Ensure the task is not frozen.
> > +	 * Also, when a freshly created task is scheduled once, changes
> > +	 * its state to TASK_UNINTERRUPTIBLE without having ever been
> > +	 * switched out once, it musn't be checked.
> > +	 */
> > +	if (unlikely(t->flags & PF_FROZEN || !switch_count))
> >  		return;
> >  
> >  	if (switch_count != t->last_switch_count) {
> > -- 
> > 1.6.1
> > 
> > 
> 
> 
> Looks good to me. Thanks for fixing this!
> 
> Acked-by: Mandeep Singh Baines <msb@google.com>

Applied to tip:core/softlockup, thanks guys!

	Ingo
