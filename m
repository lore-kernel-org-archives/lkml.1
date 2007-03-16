Return-Path: <linux-kernel-owner+w=401wt.eu-S933580AbXCPLkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbXCPLkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933586AbXCPLkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:40:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42156 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933580AbXCPLkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:40:07 -0400
Date: Fri, 16 Mar 2007 03:39:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>
Subject: Re: [2.6.20] BUG: workqueue leaked lock
Message-Id: <20070316033912.8780a9cd.akpm@linux-foundation.org>
In-Reply-To: <1174034480.7124.16.camel@twins>
References: <20070313165014.GE31960@vanheusden.com>
	<20070315110628.8bd2c07b.akpm@linux-foundation.org>
	<1174034480.7124.16.camel@twins>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 09:41:20 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2007-03-15 at 11:06 -0800, Andrew Morton wrote:
> > > On Tue, 13 Mar 2007 17:50:14 +0100 Folkert van Heusden <folkert@vanheusden.com> wrote:
> > > ...
> > > [ 1756.728209] BUG: workqueue leaked lock or atomic: nfsd4/0x00000000/3577
> > > [ 1756.728271]     last function: laundromat_main+0x0/0x69 [nfsd]
> > > [ 1756.728392] 2 locks held by nfsd4/3577:
> > > [ 1756.728435]  #0:  (client_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
> > > [ 1756.728679]  #1:  (&inode->i_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
> > > [ 1756.728923]  [<c1003d57>] show_trace_log_lvl+0x1a/0x30
> > > [ 1756.729015]  [<c1003d7f>] show_trace+0x12/0x14
> > > [ 1756.729103]  [<c1003e79>] dump_stack+0x16/0x18
> > > [ 1756.729187]  [<c102c2e8>] run_workqueue+0x167/0x170
> > > [ 1756.729276]  [<c102c437>] worker_thread+0x146/0x165
> > > [ 1756.729368]  [<c102f797>] kthread+0x97/0xc4
> > > [ 1756.729456]  [<c1003bdb>] kernel_thread_helper+0x7/0x10
> > > [ 1756.729547]  =======================
> > > [ 1792.436492] svc: unknown version (0 for prog 100003, nfsd)
> > > [ 1846.683648] BUG: workqueue leaked lock or atomic: nfsd4/0x00000000/3577
> > > [ 1846.683701]     last function: laundromat_main+0x0/0x69 [nfsd]
> > > [ 1846.683832] 2 locks held by nfsd4/3577:
> > > [ 1846.683885]  #0:  (client_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
> > > [ 1846.683980]  #1:  (&inode->i_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
> > > [ 1846.683988]  [<c1003d57>] show_trace_log_lvl+0x1a/0x30
> > > [ 1846.683994]  [<c1003d7f>] show_trace+0x12/0x14
> > > [ 1846.683997]  [<c1003e79>] dump_stack+0x16/0x18
> > > [ 1846.684001]  [<c102c2e8>] run_workqueue+0x167/0x170
> > > [ 1846.684006]  [<c102c437>] worker_thread+0x146/0x165
> > > [ 1846.684012]  [<c102f797>] kthread+0x97/0xc4
> > > [ 1846.684023]  [<c1003bdb>] kernel_thread_helper+0x7/0x10
> > 
> > Oleg, that's a fairly incomprehensible message we have in there.  Can you
> > please explain what it means?
> 
> I think I'm responsible for this message (commit
> d5abe669172f20a4129a711de0f250a4e07db298); what is says is that the
> function executed by the workqueue (here laundromat_main) leaked an
> atomic context or is still holding locks (2 locks in this case).
> 

OK.  That's not necessarily a bug: one could envisage a (weird) piece of
code which takes a lock then releases it on a later workqueue invokation. 
But I'm not sure that nfs4_laundromat() is actually supposed to be doing
anything like that.

Then again, maybe it is: it seems to be waddling through a directory under
the control of a little state machine, with timeouts.

Neil: help?
