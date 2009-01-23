Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZAWT0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZAWT0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZAWTZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:25:56 -0500
Received: from cmpxchg.org ([85.214.51.133]:33142 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbZAWTZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:25:56 -0500
Date: Fri, 23 Jan 2009 20:24:55 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v4] wait: prevent waiter starvation in __wait_on_bit_lock
Message-ID: <20090123192454.GA23107@cmpxchg.org>
References: <20090117215110.GA3300@redhat.com> <20090118013802.GA12214@cmpxchg.org> <20090118023211.GA14539@redhat.com> <20090120203131.GA20985@cmpxchg.org> <20090121143602.GA16584@redhat.com> <20090121213813.GB23270@cmpxchg.org> <20090122202550.GA5726@redhat.com> <20090123095904.GA22890@cmpxchg.org> <20090123113541.GB12684@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123113541.GB12684@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 12:35:41PM +0100, Oleg Nesterov wrote:
> On 01/23, Johannes Weiner wrote:
> >
> > On Thu, Jan 22, 2009 at 09:25:50PM +0100, Oleg Nesterov wrote:
> > > On 01/21, Johannes Weiner wrote:
> > > >
> > > 	int finish_wait_xxx(wait_queue_head_t *q, wait_queue_t *wait)
> > > 	{
> > > 		unsigned long flags;
> > > 		int woken;
> > >
> > > 		__set_current_state(TASK_RUNNING);
> > > 		spin_lock_irqsave(&q->lock, flags);
> > > 		woken = list_empty(&wait->task_list);
> > > 		list_del_init(&wait->task_list);
> > > 		spin_unlock_irqrestore(&q->lock, flags);
> > >
> > > 		return woken;
> > > 	}
> >
> > Hehe, there is only n solutions to this problem.  I had thought about
> > that too, even written it down.  But I was not sure if taking the
> > spinlock, toggling irqs and (re)storing the flags is better than an
> > untaken branch. ;)
> 
> Yes. Fortunately, this is "unlikely" path.
> 
> > > 		if (test_bit(q->key.bit_nr, q->key.flags)) {
> > > 			if ((ret = (*action)(q->key.flags))) {
> > > 				if (finish_wait_xxx(...))
> > > 					__wake_up_bit(...);
> > > 				return ret;
> > > 			}
> > > 		}
> >
> > If you don't mind putting a second finish_wait() in there (you still
> > need the one after the loop, right?), we can fix up my version to not
> > check ret twice but do finish_wait() as you describe and then the
> > test_bit() && wake up:
> >
> > 	do {
> > 		if (test_bit())
> > 			if ((ret = action())) {
> > 				finish_wait()
> > 				smp_rmb()
> > 				if (!test_bit())
> > 					__wake_up_bit()
> 
> Yes sure. Except this wakeup can be false.
> 
> > > 	int finish_wait_yyy(wait_queue_head_t *q, wait_queue_t *wait,
> > > 				int mode, void *key)
> > > 	{
> > > 		unsigned long flags;
> > > 		int woken;
> > >
> > > 		__set_current_state(TASK_RUNNING);
> > > 		spin_lock_irqsave(&q->lock, flags);
> > > 		woken = list_empty(&wait->task_list);
> > > 		if (woken)
> > > 			__wake_up_common(q, mode, 1, key);
> > > 		else
> > > 			list_del_init(&wait->task_list);
> > > 		spin_unlock_irqrestore(&q->lock, flags);
> > >
> > > 		return woken;
> > > 	}
> > >
> > > Perhaps a bit too much for this particular case, but I am thinking
> > > about other cases when we need to abort the exclusive wait.
> > >
> > > For example, don't we have the similar problems with
> > > wait_event_interruptible_exclusive() ?
> >
> > Yeah, we do IIUC.  Then having finish_wait() extended is probably a
> > good idea.
> 
> Yes.
> 
> It is no that I think this new helper is really needed for this
> particular case, personally I agree with the patch you sent.
> 
> But if we have other places with the similar problem, then perhaps
> it is better to introduce the special finish_wait_exclusive() or
> whatever.

Agreed.  I will whip up another series that adds
finish_wait_exclusive() and adjusts the problematic callsites.

	Hannes
