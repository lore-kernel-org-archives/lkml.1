Return-Path: <linux-kernel-owner+w=401wt.eu-S1752963AbXCUPMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbXCUPMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbXCUPMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:12:23 -0400
Received: from mx10.go2.pl ([193.17.41.74]:60108 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752937AbXCUPMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:12:22 -0400
Date: Wed, 21 Mar 2007 16:16:51 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J\. Bruce Fields" <bfields@fieldses.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070321151651.GA4547@ff.dom.local>
References: <17918.11420.155569.991473@notabene.brown> <20070320093753.GA1751@ff.dom.local> <20070320160759.GA107@tv-sign.ru> <20070321080510.GA1939@ff.dom.local> <20070321144620.GC78@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321144620.GC78@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 05:46:20PM +0300, Oleg Nesterov wrote:
> On 03/21, Jarek Poplawski wrote:
> >
> > On Tue, Mar 20, 2007 at 07:07:59PM +0300, Oleg Nesterov wrote:
> > > On 03/20, Jarek Poplawski wrote:
> > ...
> > > > >>> On Thu, 2007-03-15 at 11:06 -0800, Andrew Morton wrote:
> > > > >>>>> On Tue, 13 Mar 2007 17:50:14 +0100 Folkert van Heusden <folkert@vanheusden.com> wrote:
> > > > >>>>> ...
> > > > >>>>> [ 1756.728209] BUG: workqueue leaked lock or atomic: nfsd4/0x00000000/3577
> > > > >>>>> [ 1756.728271]     last function: laundromat_main+0x0/0x69 [nfsd]
> > > > >>>>> [ 1756.728392] 2 locks held by nfsd4/3577:
> > > > >>>>> [ 1756.728435]  #0:  (client_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
> > > > >>>>> [ 1756.728679]  #1:  (&inode->i_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
> > > > >>>>> [ 1756.728923]  [<c1003d57>] show_trace_log_lvl+0x1a/0x30
> > > > >>>>> [ 1756.729015]  [<c1003d7f>] show_trace+0x12/0x14
> > > > >>>>> [ 1756.729103]  [<c1003e79>] dump_stack+0x16/0x18
> > > > >>>>> [ 1756.729187]  [<c102c2e8>] run_workqueue+0x167/0x170
> > > > >>>>> [ 1756.729276]  [<c102c437>] worker_thread+0x146/0x165
> > > > >>>>> [ 1756.729368]  [<c102f797>] kthread+0x97/0xc4
> > > > >>>>> [ 1756.729456]  [<c1003bdb>] kernel_thread_helper+0x7/0x10
> > > > >>>>> [ 1756.729547]  =======================
> > ...
> > > > This check is valid with keventd, but it looks like nfsd runs
> > > > kthread by itself. I'm not sure it's illegal to hold locks then,
> > > 
> > > nfsd creates laundry_wq by itself, yes, but cwq->thread runs with
> > > lockdep_depth() == 0. Unless we have a bug with lockdep_depth(),
> > > lockdep_depth() != 0 means that work->func() returns with a lock
> > > held (or it can flush its own workqueue under lock, but in that case
> > > we should have a different trace).
> > 
> > IMHO you can only say this thread is supposed to run with
> > lockdep_depth() == 0. lockdep_depth is counted within a process,
> > which starts before f(), so the only way to say f() leaked locks
> > is to check these locks before and after f().
> 
> Sorry, I can't understand you. lockdep_depth is counted within a process,
> which starts before f(), yes. This process is cwq->thread, it was forked
> during create_workqueue(). It does not take any locks directly, only by
> calling work->func(). laundry_wq doesn't differ from keventd_wq or any other
> wq in this sense. nfsd does not "runs kthread by itself", it inserts the
> work and wakes up cwq->thread.

I think we know how it all should start and go. If only analyzing
the code could be enough, this current check of lockdep_depth()
is unnecessary too, because laundromat_code code looks as good
as run_workqueue code. I send it for testing and I mean it -
something strange is going here, so some checks should be added
- I didn't say mine is the right and will certainly help.  So, if
you have another idea for looking after it, let us know.

> 
> > > Personally I agree with Andrew:
> > > >
> > > > > OK.  That's not necessarily a bug: one could envisage a (weird) piece of
> > > > > code which takes a lock then releases it on a later workqueue invokation.
> > 
> > But this code is named here as laundromat_main and it doesn't
> > seem to work like this.
> 
> This means we have a problem with leak detection.

I totally agree!

> 
> > > > +		ld = lockdep_depth(current);
> > > > +
> > > >  		f(work);
> > > >  
> > > > -		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
> > > > +		if (unlikely(in_atomic() || (ld -= lockdep_depth(current)))) {
> > > 
> > > and with this change we will also have a BUG report on "then releases it on a
> > > later workqueue invokation".
> > 
> > Then we could say at least this code is weird (buggy - in my opinion).
> > This patch doesn't change the way the "standard" code is treated,
> > so I cannot see any possibility to get it worse then now.
> 
> I didn't mean this patch makes things worse (except it conflicts with other
> patches in -mm tree). In fact, it may improve the diagnostics. My point is
> that this patch afaics has nothing to do with the discussed problem.

I thought you are trying to diagnose a bug and maybe Folkert could test,
if this patch makes any difference. Sorry, if I missed the real problem.

Cheers,
Jarek P.
