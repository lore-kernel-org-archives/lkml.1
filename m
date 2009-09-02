Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbZIBQYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbZIBQYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 12:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZIBQYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 12:24:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:54362 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbZIBQYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 12:24:50 -0400
Date: Wed, 2 Sep 2009 18:24:51 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tree rcu: call_rcu scalability problem?
Message-ID: <20090902162451.GB28052@wotan.suse.de>
References: <20090902094835.GB12251@wotan.suse.de> <20090902122756.GC12251@wotan.suse.de> <20090902151927.GA6774@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902151927.GA6774@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 08:19:27AM -0700, Paul E. McKenney wrote:
> On Wed, Sep 02, 2009 at 02:27:56PM +0200, Nick Piggin wrote:
> > On Wed, Sep 02, 2009 at 11:48:35AM +0200, Nick Piggin wrote:
> > > Hi Paul,
> > > 
> > > I'm testing out scalability of some vfs code paths, and I'm seeing
> > > a problem with call_rcu. This is a 2s8c opteron system, so nothing
> > > crazy.
> > > 
> > > I'll show you the profile results for 1-8 threads:
> > > 
> > > 1:
> > >  29768 total                                      0.0076
> > >  15550 default_idle                              48.5938
> > >   1340 __d_lookup                                 3.6413
> > >    954 __link_path_walk                           0.2559
> > >    816 system_call_after_swapgs                   8.0792
> > >    680 kmem_cache_alloc                           1.4167
> > >    669 dput                                       1.1946
> > >    591 __call_rcu                                 2.0521
> > > 
> > > 2:
> > >  56733 total                                      0.0145
> > >  20074 default_idle                              62.7313
> > >   3075 __call_rcu                                10.6771
> > >   2650 __d_lookup                                 7.2011
> > >   2019 dput                                       3.6054
> > > 
> > > 4:
> > >  98889 total                                      0.0253
> > >  21759 default_idle                              67.9969
> > >  10994 __call_rcu                                38.1736
> > >   5185 __d_lookup                                14.0897
> > >   4475 dput                                       7.9911
> 
> Four threads runs on one socket but 8 threads runs on two sockets,
> I take it?

Yes.

 
> > > 8:
> > > 170391 total                                      0.0437
> > >  31815 __call_rcu                               110.4688
> > >  12958 dput                                      23.1393
> > >  10417 __d_lookup                                28.3071
> > > 
> > > Of course there are other scalability factors involved too, but
> > > __call_rcu is taking 54 times more CPU to do 8 times the amount
> > > of work from 1-8 threads, or a factor of 6.7 slowdown.
> > > 
> > > This is with tree RCU.
> > 
> > It seems like nearly 2/3 of the cost is here:
> >         /* Add the callback to our list. */
> >         *rdp->nxttail[RCU_NEXT_TAIL] = head; <<<
> >         rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
> 
> Hmmm...  That certainly is not the first list of code in call_rcu() that
> would come to mind...

It's weird. I *think* I read the asm right, but oprofile maybe is
not attributing the cost to the right instruction.


> > In loading the pointer to the next tail pointer. If I'm reading the profile
> > correctly. Can't see why that should be a probem though...
> 
> The usual diagnosis would be false sharing.

Hmm that's possible yes.


> Hmmm...  What is the workload?  CPU-bound?  If CONFIG_PREEMPT=n, I might
> expect interference from force_quiescent_state(), except that it should
> run only every few clock ticks.  So this seems quite unlikely.

It's CPU bound and preempt=y.

Workload is just 8 processes running a loop of close(open("file$i")) as
I said though you probably won't be able to reproduce it on a vanilla
kernel.


> Could you please try padding the beginning and end of struct rcu_data
> with a few hundred bytes and rerunning?  Just in case there is a shared
> per-CPU variable either before or after rcu_data in your memory layout?

OK I'll try that.

