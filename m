Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbZBESl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbZBESl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZBESlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:41:19 -0500
Received: from smtp-out.google.com ([216.239.33.17]:18611 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZBESlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:41:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-gmailtapped-by:x-gmailtapped;
	b=EG0nKEPvWS2DAR+aknHDjZtrporJzXHf+LDS7JYhnhosgPbnLAHh63PPeaEhr+qfX
	S7+u4pqmHjxWSsPDgLp1Q==
Date: Thu, 5 Feb 2009 10:40:03 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: Re: [PATCH 2/2 v4] softlockup: check all tasks in hung_task
Message-ID: <20090205184003.GB10819@google.com>
References: <20090204194339.GB22608@elte.hu> <20090205043548.GA18933@google.com> <20090205143453.GG28443@elte.hu> <20090205094834.0dd9cfaa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205094834.0dd9cfaa.akpm@linux-foundation.org>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.25.146.78
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 5 Feb 2009 15:34:53 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > Subject: [PATCH] softlockup: check all tasks in hung_task
> > 
> > Impact: extend the scope of hung-task checks
> > 
> 
> A nanonit:
> 
> > +static const int hung_task_batching = 1024;
> 
> static const definitions look pretty but they're a bit misleading.
> 
> >  static void check_hung_uninterruptible_tasks(unsigned long timeout)
> >  {
> > +	int batch_count = hung_task_batching;
> >  	int max_count = sysctl_hung_task_check_count;
> >  	unsigned long now = get_timestamp();
> >  	struct task_struct *g, *t;
> > @@ -131,6 +159,13 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
> >  	do_each_thread(g, t) {
> >  		if (!--max_count)
> >  			goto unlock;
> > +		if (!--batch_count) {
> > +			batch_count = hung_task_batching;
> > +			rcu_lock_break(g, t);
> > +			/* Exit if t or g was unhashed during refresh. */
> > +			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
> > +				goto unlock;
> > +		}
> >  		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
> >  		if (t->state == TASK_UNINTERRUPTIBLE)
> >  			check_hung_task(t, now, timeout);
> 
> The reader of this area of the code will expect that hung_task_batching
> is a variable.  It _looks_ like the value of that variable can be altered
> at any time by some other thread.  It _looks_ like this code will explode
> if someone has accidentally set hung_task_batching to zero, etc.
> 

The code would not break if hung_task_batching was exported out as a sysctl.

If hung_task_batching is set to zero at any time, the behavior will be
to process all tasks in one batch. This seems like a reasonable behavior
for the  zero case. It is also consistent with the behavior of
sysctl_hung_task_check_count.

Maybe a comment should be added by the declaration of both variables explaining
the zero behavior?

> But none of that is actually true, because hung_task_batching is, surprisingly,
> a compile-time constant.
> 
> All this misleadingness would be fixed if it were called
> HUNG_TASK_BATCHING.  But then it wouldn't be pretty.
> 
