Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXHAUR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXHAUR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXHAURu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:17:50 -0400
Received: from mail.screens.ru ([213.234.233.54]:56255 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXHAURt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:17:49 -0400
Date: Thu, 2 Aug 2007 00:18:02 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Daniel Walker <dwalker@mvista.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070801201802.GA225@tv-sign.ru>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net> <1185940340.2636.97.camel@imap.mvista.com> <1185987663.12034.99.camel@twins> <20070801181253.GA90@tv-sign.ru> <1185992994.2636.142.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185992994.2636.142.camel@imap.mvista.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Daniel Walker wrote:
>
> On Wed, 2007-08-01 at 22:12 +0400, Oleg Nesterov wrote:
> 
> > And I personally think it is not very useful, even if it was correct.
> > You can create your own workqueue and change the priority of cwq->thread.
> 
> This change is more dynamic than than just setting a single priority ..
> There was some other work going on around this, so it's not totally
> clear what the benefits are ..

Yes, I see. But still I think the whole idea is broken, not just the
implementation.

What about delayed_work? insert_work() will use ->normal_prio of
the random interrupted process, while queue_work() uses current.

What if a niced thread queues the work? This work may have no chance
to run if workqueue is actively used.

And I don't understand why rt_mutex_setprio() is called just before
calling work->func(). This means that a high-priority work could
be delayed by the low-priority ->current_work.

> > > > @@ -168,7 +171,7 @@ int fastcall queue_work(struct workqueue
> > > >  	int ret = 0, cpu = raw_smp_processor_id();
> > > >  
> > > >  	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
> > > > -		BUG_ON(!list_empty(&work->entry));
> > > > +		BUG_ON(!plist_node_empty(&work->entry));
> > > >  		__queue_work(wq_per_cpu(wq, cpu), work);
> > > >  		ret = 1;
> > 
> > Side note, looks like you use some strange kernel. This raw_smp_processor_id()
> > above is wrong.
> 
> As the topic suggests , it's a Real Time kernel .. I can give you a link
> where to download it if you want.

Ok, thanks, I'll take a look. Still, we can't use raw_smp_processor_id()
unless we disabled cpu-hotplug.

Oleg.

