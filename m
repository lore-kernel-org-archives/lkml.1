Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZCFPr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZCFPr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZCFPrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:47:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37921 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZCFPrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:47:17 -0500
Subject: Re: [RFC][PATCH]: wait: don't resched in prepare_to_wait()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090306154144.GA7841@redhat.com>
References: <1236350377.6326.389.camel@laptop>
	 <20090306154144.GA7841@redhat.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 16:47:04 +0100
Message-Id: <1236354424.6326.460.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 16:41 +0100, Oleg Nesterov wrote:
> On 03/06, Peter Zijlstra wrote:
> >
> > After prepare to wait, we either call schedule() or find !cond in which
> > case we'll call finish_wait() which contains another preemption check.
> >
> > @@ -73,7 +73,9 @@ prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
> >  	if (list_empty(&wait->task_list))
> >  		__add_wait_queue(q, wait);
> >  	set_current_state(state);
> > +	preempt_disable();
> >  	spin_unlock_irqrestore(&q->lock, flags);
> > +	preempt_enable_no_resched();
> 
> But this only helps if the task gets TIF_NEED_RESCHED while it was in
> spin_lock_irqsave() section, right? This window should be very small
> unless we have the contention.
> 
> Or do you have something else in mind?

No, that was exactly it, we then get preempted only to go to sleep right
afterwards, which would cause a schedule anyway.

So its avoiding a schedule.

