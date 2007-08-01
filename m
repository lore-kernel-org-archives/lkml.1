Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbXHAWWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbXHAWWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXHAWWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:22:06 -0400
Received: from mail.screens.ru ([213.234.233.54]:35774 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbXHAWWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:22:03 -0400
Date: Thu, 2 Aug 2007 02:22:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070801222201.GA316@tv-sign.ru>
References: <1185940340.2636.97.camel@imap.mvista.com> <1185987663.12034.99.camel@twins> <20070801181253.GA90@tv-sign.ru> <1185992994.2636.142.camel@imap.mvista.com> <20070801201802.GA225@tv-sign.ru> <1186000468.2636.168.camel@imap.mvista.com> <20070801205053.GA263@tv-sign.ru> <1186002783.9513.228.camel@ghaskins-t60p.haskins.net> <20070801213422.GA280@tv-sign.ru> <1186005598.9513.261.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186005598.9513.261.camel@ghaskins-t60p.haskins.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Gregory Haskins wrote:
>
> On Thu, 2007-08-02 at 01:34 +0400, Oleg Nesterov wrote:
> > On 08/01, Gregory Haskins wrote:
> > >
> > > On Thu, 2007-08-02 at 00:50 +0400, Oleg Nesterov wrote:
> > > > On 08/01, Daniel Walker wrote:
> > > > >
> > > > > It's translating priorities through the work queues, which doesn't seem
> > > > > to happen with the current implementation. A high priority, say
> > > > > SCHED_FIFO priority 99, task may have to wait for a nice -5 work queue
> > > > > to finish..
> > > > 
> > > > Why should that task wait?
> > > 
> > > I assume "that task" = the RT99 task?  If so, that is precisely the
> > > question.  It shouldn't wait.  ;)  With mainline, it is simply queued
> > > with every other request.  There could be an RT40, and a SCHED_NORMAL in
> > > front of it in the queue that will get processed first.  In addition,
> > > the system could suffer from a priority inversion if some unrelated but
> > > lower priority task (say RT98) was blocking the workqueue thread from
> > > making forward progress on the nice -5 job. 
> > > 
> > > To clarify: when a design utilizes a singlethread per workqueue (such as
> > > in both mainline and this patch), the RT99 will always have to wait
> > > behind any already dispatched jobs.
> > 
> > It is not that "RT99 will always have to wait". But yes, the work_struct
> > queued by RT99 has to wait.
> 
> Agreed.  We are talking only within the scope of workqueues here.
> 
> 
> > > 1) The RT99 task would move ahead in the queue of anything else that was
> > > also scheduled on the workqueue that is < RT99.
> > 
> > this itself is wrong, breaks flush_workqueue() semantics
> 
> Perhaps in Daniels patch.

No.

> However, IIUC the point of flush_workqueue() is a barrier only relative
> to your own submissions, correct?.  E.g. to make sure *your* requests
> are finished, not necessarily the entire queue.

No,

> If flush_workqueue is supposed to behave differently than I describe,
> then I agree its broken even in my original patch.

The comment near flush_workqueue() says:

	* We sleep until all works which were queued on entry have been handled,
	* but we are not livelocked by new incoming ones.

> > > 2) The priority of the workqueue task would be temporarily elevated to
> > > RT99 so that the currently dispatched task will complete at the same
> > > priority as the waiter.
> > 
> > _Which_ waiter?
> 
> The RT99 task that submitted the request.

Now, again, why do you think this task should wait?

> >  I can't understand at all why work_struct should "inherit"
> > the priority of the task which queued it. 
> 
> Think about it:  If you are an RT99 task and you have work to do,
> shouldn't *all* of the work you need be done at RT99 if possible. 

No, I don't think so. Quite opposite, I think sometimes it makes
sense to "offload" some low-priority work from RT99 to workqueue
thread exactly because it has no rt policy.

And what about queue_work() from irq? Why should that work take a
"random" priority?

> Why
> should something like a measly RT98 task block you from completing your
> work. ;) The fact that you need to do some work via a workqueue (perhaps
> because you need specific cpu routing) is inconsequential, IMHO.

In that case I think it is better to create a special workqueue
and raise its priority.

Oleg.

