Return-Path: <linux-kernel-owner+w=401wt.eu-S1751341AbXCUIAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbXCUIAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 04:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbXCUIAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 04:00:41 -0400
Received: from poczta.o2.pl ([193.17.41.142]:40557 "EHLO poczta.o2.pl"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751341AbXCUIAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 04:00:40 -0400
Date: Wed, 21 Mar 2007 09:05:10 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J\. Bruce Fields" <bfields@fieldses.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070321080510.GA1939@ff.dom.local>
References: <17918.11420.155569.991473@notabene.brown> <20070320093753.GA1751@ff.dom.local> <20070320160759.GA107@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320160759.GA107@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 07:07:59PM +0300, Oleg Nesterov wrote:
> On 03/20, Jarek Poplawski wrote:
...
> > >>> On Thu, 2007-03-15 at 11:06 -0800, Andrew Morton wrote:
> > >>>>> On Tue, 13 Mar 2007 17:50:14 +0100 Folkert van Heusden <folkert@vanheusden.com> wrote:
> > >>>>> ...
> > >>>>> [ 1756.728209] BUG: workqueue leaked lock or atomic: nfsd4/0x00000000/3577
> > >>>>> [ 1756.728271]     last function: laundromat_main+0x0/0x69 [nfsd]
> > >>>>> [ 1756.728392] 2 locks held by nfsd4/3577:
> > >>>>> [ 1756.728435]  #0:  (client_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
> > >>>>> [ 1756.728679]  #1:  (&inode->i_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
> > >>>>> [ 1756.728923]  [<c1003d57>] show_trace_log_lvl+0x1a/0x30
> > >>>>> [ 1756.729015]  [<c1003d7f>] show_trace+0x12/0x14
> > >>>>> [ 1756.729103]  [<c1003e79>] dump_stack+0x16/0x18
> > >>>>> [ 1756.729187]  [<c102c2e8>] run_workqueue+0x167/0x170
> > >>>>> [ 1756.729276]  [<c102c437>] worker_thread+0x146/0x165
> > >>>>> [ 1756.729368]  [<c102f797>] kthread+0x97/0xc4
> > >>>>> [ 1756.729456]  [<c1003bdb>] kernel_thread_helper+0x7/0x10
> > >>>>> [ 1756.729547]  =======================
...
> > This check is valid with keventd, but it looks like nfsd runs
> > kthread by itself. I'm not sure it's illegal to hold locks then,
> 
> nfsd creates laundry_wq by itself, yes, but cwq->thread runs with
> lockdep_depth() == 0. Unless we have a bug with lockdep_depth(),
> lockdep_depth() != 0 means that work->func() returns with a lock
> held (or it can flush its own workqueue under lock, but in that case
> we should have a different trace).

IMHO you can only say this thread is supposed to run with
lockdep_depth() == 0. lockdep_depth is counted within a process,
which starts before f(), so the only way to say f() leaked locks
is to check these locks before and after f().

> 
> Personally I agree with Andrew:
> >
> > > OK.  That's not necessarily a bug: one could envisage a (weird) piece of
> > > code which takes a lock then releases it on a later workqueue invokation.

But this code is named here as laundromat_main and it doesn't
seem to work like this.

> 
> > @@ -323,13 +324,15 @@ static void run_workqueue(struct cpu_wor
> >  		BUG_ON(get_wq_data(work) != cwq);
> >  		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
> >  			work_release(work);
> > +		ld = lockdep_depth(current);
> > +
> >  		f(work);
> >  
> > -		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
> > +		if (unlikely(in_atomic() || (ld -= lockdep_depth(current)))) {
> 
> and with this change we will also have a BUG report on "then releases it on a
> later workqueue invokation".

Then we could say at least this code is weird (buggy - in my opinion).
This patch doesn't change the way the "standard" code is treated,
so I cannot see any possibility to get it worse then now.

Regards,
Jarek P.
