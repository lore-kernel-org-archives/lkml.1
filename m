Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbXHAVee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbXHAVee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbXHAVeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:34:20 -0400
Received: from mail.screens.ru ([213.234.233.54]:43069 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbXHAVeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:34:18 -0400
Date: Thu, 2 Aug 2007 01:34:22 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070801213422.GA280@tv-sign.ru>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net> <1185940340.2636.97.camel@imap.mvista.com> <1185987663.12034.99.camel@twins> <20070801181253.GA90@tv-sign.ru> <1185992994.2636.142.camel@imap.mvista.com> <20070801201802.GA225@tv-sign.ru> <1186000468.2636.168.camel@imap.mvista.com> <20070801205053.GA263@tv-sign.ru> <1186002783.9513.228.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186002783.9513.228.camel@ghaskins-t60p.haskins.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Gregory Haskins wrote:
>
> On Thu, 2007-08-02 at 00:50 +0400, Oleg Nesterov wrote:
> > On 08/01, Daniel Walker wrote:
> > >
> > > It's translating priorities through the work queues, which doesn't seem
> > > to happen with the current implementation. A high priority, say
> > > SCHED_FIFO priority 99, task may have to wait for a nice -5 work queue
> > > to finish..
> > 
> > Why should that task wait?
> 
> I assume "that task" = the RT99 task?  If so, that is precisely the
> question.  It shouldn't wait.  ;)  With mainline, it is simply queued
> with every other request.  There could be an RT40, and a SCHED_NORMAL in
> front of it in the queue that will get processed first.  In addition,
> the system could suffer from a priority inversion if some unrelated but
> lower priority task (say RT98) was blocking the workqueue thread from
> making forward progress on the nice -5 job. 
> 
> To clarify: when a design utilizes a singlethread per workqueue (such as
> in both mainline and this patch), the RT99 will always have to wait
> behind any already dispatched jobs.

It is not that "RT99 will always have to wait". But yes, the work_struct
queued by RT99 has to wait.

> That is a given.  However, with
> Daniels patch, two things happen in addition to normal processing.

Yes, I see what the patch does,

> 1) The RT99 task would move ahead in the queue of anything else that was
> also scheduled on the workqueue that is < RT99.

this itself is wrong, breaks flush_workqueue() semantics

> 2) The priority of the workqueue task would be temporarily elevated to
> RT99 so that the currently dispatched task will complete at the same
> priority as the waiter.

_Which_ waiter? I can't understand at all why work_struct should "inherit"
the priority of the task which queued it. This looks just wrong to me,
even if could implement this safely.

Oleg.

