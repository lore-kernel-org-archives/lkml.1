Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbXHAVPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbXHAVPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbXHAVPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:15:12 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:40598 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbXHAVPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:15:10 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Gregory Haskins <ghaskins@novell.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070801205053.GA263@tv-sign.ru>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net>
	 <1185940340.2636.97.camel@imap.mvista.com>
	 <1185987663.12034.99.camel@twins> <20070801181253.GA90@tv-sign.ru>
	 <1185992994.2636.142.camel@imap.mvista.com>
	 <20070801201802.GA225@tv-sign.ru>
	 <1186000468.2636.168.camel@imap.mvista.com>
	 <20070801205053.GA263@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 17:13:03 -0400
Message-Id: <1186002783.9513.228.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 00:50 +0400, Oleg Nesterov wrote:
> On 08/01, Daniel Walker wrote:
> >
> > On Thu, 2007-08-02 at 00:18 +0400, Oleg Nesterov wrote:
> > > On 08/01, Daniel Walker wrote:
> > > >
> > > > On Wed, 2007-08-01 at 22:12 +0400, Oleg Nesterov wrote:
> > > > 
> > > > > And I personally think it is not very useful, even if it was correct.
> > > > > You can create your own workqueue and change the priority of cwq->thread.
> > > > 
> > > > This change is more dynamic than than just setting a single priority ..
> > > > There was some other work going on around this, so it's not totally
> > > > clear what the benefits are ..
> > > 
> > > Yes, I see. But still I think the whole idea is broken, not just the
> > > implementation.
> > 
> > It's translating priorities through the work queues, which doesn't seem
> > to happen with the current implementation. A high priority, say
> > SCHED_FIFO priority 99, task may have to wait for a nice -5 work queue
> > to finish..
> 
> Why should that task wait?

I assume "that task" = the RT99 task?  If so, that is precisely the
question.  It shouldn't wait.  ;)  With mainline, it is simply queued
with every other request.  There could be an RT40, and a SCHED_NORMAL in
front of it in the queue that will get processed first.  In addition,
the system could suffer from a priority inversion if some unrelated but
lower priority task (say RT98) was blocking the workqueue thread from
making forward progress on the nice -5 job. 

To clarify: when a design utilizes a singlethread per workqueue (such as
in both mainline and this patch), the RT99 will always have to wait
behind any already dispatched jobs.  That is a given.  However, with
Daniels patch, two things happen in addition to normal processing.

1) The RT99 task would move ahead in the queue of anything else that was
also scheduled on the workqueue that is < RT99.

2) The priority of the workqueue task would be temporarily elevated to
RT99 so that the currently dispatched task will complete at the same
priority as the waiter.  This prevents inversion.

HTH
-Greg

