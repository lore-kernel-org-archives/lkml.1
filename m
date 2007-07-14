Return-Path: <linux-kernel-owner+w=401wt.eu-S1765506AbXGNUya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765506AbXGNUya (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764878AbXGNUyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:54:09 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59092 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764672AbXGNUyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:54:07 -0400
Subject: Re: [PATCH -rt 2/5] Thread Migration Preemption - v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070714204841.GA179@tv-sign.ru>
References: <20070714175733.194012000@chello.nl>
	 <20070714175839.641246000@chello.nl> <20070714171646.GB746@tv-sign.ru>
	 <1184438694.5284.69.camel@lappy> <1184440051.5284.72.camel@lappy>
	 <20070714204841.GA179@tv-sign.ru>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 22:53:38 +0200
Message-Id: <1184446418.5284.86.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 00:48 +0400, Oleg Nesterov wrote:
> On 07/14, Peter Zijlstra wrote:
> 
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -288,6 +288,7 @@ struct rq {
> >  
> >  	struct task_struct *migration_thread;
> >  	struct list_head migration_queue;
> > +	struct list_head delayed_migration_queue;
> >  #endif
> 
> I think this could be simplified a bit.
> 
> delayed_migration_queue can be a local variable in migration_thread(), then
> 
> >  #ifdef CONFIG_SCHEDSTATS
> > @@ -5623,6 +5624,11 @@ static int migration_thread(void *data)
> >  		head = &rq->migration_queue;
> >  
> >  		if (list_empty(head)) {
> > +			/*
> > +			 * we got a wakeup, give the delayed list another shot.
> > +			 */
> > +			if (current->state != TASK_INTERRUPTIBLE)
> > +				list_splice(&rq->delayed_migration_queue, head);
> 
> No need to check TASK_INTERRUPTIBLE, just do list_splice() unconditionally and
> call schedule().

Yes, I got my head in a twist on that one. You are quite right!

