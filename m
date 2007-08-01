Return-Path: <linux-kernel-owner+w=401wt.eu-S1762413AbXHAS0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762413AbXHAS0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760097AbXHAS0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:26:44 -0400
Received: from mail.screens.ru ([213.234.233.54]:54555 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760065AbXHAS0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:26:42 -0400
Date: Wed, 1 Aug 2007 22:26:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Daniel Walker <dwalker@mvista.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070801182658.GB90@tv-sign.ru>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net> <1185940340.2636.97.camel@imap.mvista.com> <1185987663.12034.99.camel@twins> <1185988243.2636.126.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185988243.2636.126.camel@imap.mvista.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Daniel Walker wrote:
>
> On Wed, 2007-08-01 at 19:01 +0200, Peter Zijlstra wrote:
> > >  static void insert_work(struct cpu_workqueue_struct *cwq,
> > >  				struct work_struct *work, int tail)
> > >  {
> > > +	int prio = current->normal_prio;
> > > +
> > >  	set_wq_data(work, cwq);
> > >  	/*
> > >  	 * Ensure that we get the right work->data if we see the
> > >  	 * result of list_add() below, see try_to_grab_pending().
> > >  	 */
> > >  	smp_wmb();
> > > -	if (tail)
> > > -		list_add_tail(&work->entry, &cwq->worklist);
> > > -	else
> > > -		list_add(&work->entry, &cwq->worklist);
> > > +	plist_node_init(&work->entry, prio);
> > > +	plist_add(&work->entry, &cwq->worklist);
> > 
> > perhaps we ought to handle tail, perhaps not, not sure what the
> > consequences are.
> 
> The plist doesn't distinguish since it's a sorted list. There is no way
> to force something to the back of the list ..
> 
> It seems like the "tail" option was the old way to prioritize..  I think
> It could be removed since we're always priority ordering now anyway..

No, the "tail" option has nothing to do with prioritize, we can't remove
it. Please look at the code.

Also, flush_workqueue() must not be delayed by the new incoming work_struct's,
the change like this breaks this assumption.

Oleg.

