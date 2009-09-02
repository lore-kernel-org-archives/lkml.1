Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbZIBQso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbZIBQso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 12:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZIBQso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 12:48:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57242 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbZIBQsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 12:48:43 -0400
Date: Wed, 2 Sep 2009 09:48:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tree rcu: call_rcu scalability problem?
Message-ID: <20090902164844.GJ6774@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090902094835.GB12251@wotan.suse.de> <20090902122756.GC12251@wotan.suse.de> <20090902151927.GA6774@linux.vnet.ibm.com> <20090902162451.GB28052@wotan.suse.de> <20090902163705.GI6774@linux.vnet.ibm.com> <20090902164504.GD28052@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902164504.GD28052@wotan.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 06:45:04PM +0200, Nick Piggin wrote:
> On Wed, Sep 02, 2009 at 09:37:05AM -0700, Paul E. McKenney wrote:
> > On Wed, Sep 02, 2009 at 06:24:51PM +0200, Nick Piggin wrote:
> > > On Wed, Sep 02, 2009 at 08:19:27AM -0700, Paul E. McKenney wrote:
> > > > On Wed, Sep 02, 2009 at 02:27:56PM +0200, Nick Piggin wrote:
> > > > > On Wed, Sep 02, 2009 at 11:48:35AM +0200, Nick Piggin wrote:
> > > > > > Hi Paul,
> > > > > > 
> > > > > > I'm testing out scalability of some vfs code paths, and I'm seeing
> > > > > > a problem with call_rcu. This is a 2s8c opteron system, so nothing
> > > > > > crazy.
> > > > > > 
> > > > > > I'll show you the profile results for 1-8 threads:
> > > > > > 
> > > > > > 1:
> > > > > >  29768 total                                      0.0076
> > > > > >  15550 default_idle                              48.5938
> > > > > >   1340 __d_lookup                                 3.6413
> > > > > >    954 __link_path_walk                           0.2559
> > > > > >    816 system_call_after_swapgs                   8.0792
> > > > > >    680 kmem_cache_alloc                           1.4167
> > > > > >    669 dput                                       1.1946
> > > > > >    591 __call_rcu                                 2.0521
> > > > > > 
> > > > > > 2:
> > > > > >  56733 total                                      0.0145
> > > > > >  20074 default_idle                              62.7313
> > > > > >   3075 __call_rcu                                10.6771
> > > > > >   2650 __d_lookup                                 7.2011
> > > > > >   2019 dput                                       3.6054
> > > > > > 
> > > > > > 4:
> > > > > >  98889 total                                      0.0253
> > > > > >  21759 default_idle                              67.9969
> > > > > >  10994 __call_rcu                                38.1736
> > > > > >   5185 __d_lookup                                14.0897
> > > > > >   4475 dput                                       7.9911
> > > > 
> > > > Four threads runs on one socket but 8 threads runs on two sockets,
> > > > I take it?
> > > 
> > > Yes.
> > > 
> > > 
> > > > > > 8:
> > > > > > 170391 total                                      0.0437
> > > > > >  31815 __call_rcu                               110.4688
> > > > > >  12958 dput                                      23.1393
> > > > > >  10417 __d_lookup                                28.3071
> > > > > > 
> > > > > > Of course there are other scalability factors involved too, but
> > > > > > __call_rcu is taking 54 times more CPU to do 8 times the amount
> > > > > > of work from 1-8 threads, or a factor of 6.7 slowdown.
> > > > > > 
> > > > > > This is with tree RCU.
> > > > > 
> > > > > It seems like nearly 2/3 of the cost is here:
> > > > >         /* Add the callback to our list. */
> > > > >         *rdp->nxttail[RCU_NEXT_TAIL] = head; <<<
> > > > >         rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
> > > > 
> > > > Hmmm...  That certainly is not the first list of code in call_rcu() that
> > > > would come to mind...
> > > 
> > > It's weird. I *think* I read the asm right, but oprofile maybe is
> > > not attributing the cost to the right instruction.
> > > 
> > > 
> > > > > In loading the pointer to the next tail pointer. If I'm reading the profile
> > > > > correctly. Can't see why that should be a probem though...
> > > > 
> > > > The usual diagnosis would be false sharing.
> > > 
> > > Hmm that's possible yes.
> > > 
> > > 
> > > > Hmmm...  What is the workload?  CPU-bound?  If CONFIG_PREEMPT=n, I might
> > > > expect interference from force_quiescent_state(), except that it should
> > > > run only every few clock ticks.  So this seems quite unlikely.
> > > 
> > > It's CPU bound and preempt=y.
> > > 
> > > Workload is just 8 processes running a loop of close(open("file$i")) as
> > > I said though you probably won't be able to reproduce it on a vanilla
> > > kernel.
> > 
> > OK, so you are executing call_rcu() a -lot-!!!
> 
> Oh yeah. The combined frequency in the 8 proc case is once per 270ns, so
> nearly half a million times per second per core.

Woo-hoo!!!  ;-)

> It's not *slow* by any means, but it is increasing much faster than other
> functions on the profile so I just want to understand what is happening.

Understood and agreed.

> > Could you also please try CONFIG_RCU_TRACE=y, and send me the contents of
> > the files in the "rcu" subdirectory in debugfs?  Please take a snapshot
> > of these files, run your test for a fixed time interval (perhaps ten
> > seconds, but please tell me how long), then take a second snapshot.
> 
> Will do.

							Thanx, Paul
