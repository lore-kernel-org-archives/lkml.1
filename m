Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbXCTQEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbXCTQEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbXCTQEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:04:25 -0400
Received: from mail.screens.ru ([213.234.233.54]:54253 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbXCTQEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:04:24 -0400
Date: Tue, 20 Mar 2007 19:07:59 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070320160759.GA107@tv-sign.ru>
References: <17918.11420.155569.991473@notabene.brown> <20070320093753.GA1751@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320093753.GA1751@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20, Jarek Poplawski wrote:
>
> >> On Fri, 16 Mar 2007 09:41:20 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >>
> >>> On Thu, 2007-03-15 at 11:06 -0800, Andrew Morton wrote:
> >>>>> On Tue, 13 Mar 2007 17:50:14 +0100 Folkert van Heusden <folkert@vanheusden.com> wrote:
> >>>>> ...
> >>>>> [ 1756.728209] BUG: workqueue leaked lock or atomic: nfsd4/0x00000000/3577
> >>>>> [ 1756.728271]     last function: laundromat_main+0x0/0x69 [nfsd]
> >>>>> [ 1756.728392] 2 locks held by nfsd4/3577:
> >>>>> [ 1756.728435]  #0:  (client_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
> >>>>> [ 1756.728679]  #1:  (&inode->i_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
> >>>>> [ 1756.728923]  [<c1003d57>] show_trace_log_lvl+0x1a/0x30
> >>>>> [ 1756.729015]  [<c1003d7f>] show_trace+0x12/0x14
> >>>>> [ 1756.729103]  [<c1003e79>] dump_stack+0x16/0x18
> >>>>> [ 1756.729187]  [<c102c2e8>] run_workqueue+0x167/0x170
> >>>>> [ 1756.729276]  [<c102c437>] worker_thread+0x146/0x165
> >>>>> [ 1756.729368]  [<c102f797>] kthread+0x97/0xc4
> >>>>> [ 1756.729456]  [<c1003bdb>] kernel_thread_helper+0x7/0x10
> >>>>> [ 1756.729547]  =======================
> ...
> >>> I think I'm responsible for this message (commit
> >>> d5abe669172f20a4129a711de0f250a4e07db298); what is says is that the
> >>> function executed by the workqueue (here laundromat_main) leaked an
> >>> atomic context or is still holding locks (2 locks in this case).
> 
> This check is valid with keventd, but it looks like nfsd runs
> kthread by itself. I'm not sure it's illegal to hold locks then,

nfsd creates laundry_wq by itself, yes, but cwq->thread runs with
lockdep_depth() == 0. Unless we have a bug with lockdep_depth(),
lockdep_depth() != 0 means that work->func() returns with a lock
held (or it can flush its own workqueue under lock, but in that case
we should have a different trace).

Personally I agree with Andrew:
>
> > OK.  That's not necessarily a bug: one could envisage a (weird) piece of
> > code which takes a lock then releases it on a later workqueue invokation.

> @@ -323,13 +324,15 @@ static void run_workqueue(struct cpu_wor
>  		BUG_ON(get_wq_data(work) != cwq);
>  		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
>  			work_release(work);
> +		ld = lockdep_depth(current);
> +
>  		f(work);
>  
> -		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
> +		if (unlikely(in_atomic() || (ld -= lockdep_depth(current)))) {

and with this change we will also have a BUG report on "then releases it on a
later workqueue invokation".

Btw. __nfs4_state_shutdown() does cancel_delayed_work(&laundromat_work).
This is unneeded and imho confusing. laundry_wq was already destroyed,
it would be BUG to have a pending delayed work.

Oleg.

