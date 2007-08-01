Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbXHASN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbXHASN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbXHASNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:13:18 -0400
Received: from mail.screens.ru ([213.234.233.54]:52802 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbXHASNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:13:17 -0400
Date: Wed, 1 Aug 2007 22:12:53 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070801181253.GA90@tv-sign.ru>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net> <1185940340.2636.97.camel@imap.mvista.com> <1185987663.12034.99.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185987663.12034.99.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Peter Zijlstra wrote:
>
> On Tue, 2007-07-31 at 20:52 -0700, Daniel Walker wrote:
> 
> >  static void insert_work(struct cpu_workqueue_struct *cwq,
> >  				struct work_struct *work, int tail)
> >  {
> > +	int prio = current->normal_prio;
> > +
> >  	set_wq_data(work, cwq);
> >  	/*
> >  	 * Ensure that we get the right work->data if we see the
> >  	 * result of list_add() below, see try_to_grab_pending().
> >  	 */
> >  	smp_wmb();
> > -	if (tail)
> > -		list_add_tail(&work->entry, &cwq->worklist);
> > -	else
> > -		list_add(&work->entry, &cwq->worklist);
> > +	plist_node_init(&work->entry, prio);
> > +	plist_add(&work->entry, &cwq->worklist);

Sorry, this patch is completely wrong. It immediately breaks
flush_workqueue/cancel_workqueue functions.

And I personally think it is not very useful, even if it was correct.
You can create your own workqueue and change the priority of cwq->thread.

> > @@ -168,7 +171,7 @@ int fastcall queue_work(struct workqueue
> >  	int ret = 0, cpu = raw_smp_processor_id();
> >  
> >  	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
> > -		BUG_ON(!list_empty(&work->entry));
> > +		BUG_ON(!plist_node_empty(&work->entry));
> >  		__queue_work(wq_per_cpu(wq, cpu), work);
> >  		ret = 1;

Side note, looks like you use some strange kernel. This raw_smp_processor_id()
above is wrong.

Oleg.

