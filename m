Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbZIBRuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbZIBRuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 13:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZIBRuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 13:50:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbZIBRuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 13:50:11 -0400
Date: Wed, 2 Sep 2009 19:50:13 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tree rcu: call_rcu scalability problem?
Message-ID: <20090902175013.GH28052@wotan.suse.de>
References: <20090902094835.GB12251@wotan.suse.de> <20090902122756.GC12251@wotan.suse.de> <20090902151927.GA6774@linux.vnet.ibm.com> <20090902162451.GB28052@wotan.suse.de> <20090902163705.GI6774@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902163705.GI6774@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 09:37:05AM -0700, Paul E. McKenney wrote:
> On Wed, Sep 02, 2009 at 06:24:51PM +0200, Nick Piggin wrote:
> > > > In loading the pointer to the next tail pointer. If I'm reading the profile
> > > > correctly. Can't see why that should be a probem though...
> > > 
> > > The usual diagnosis would be false sharing.
> > 
> > Hmm that's possible yes.

OK, padding 64 bytes (cacheline size) at the start and end of struct rcu_data
does not help.

I wonder if the cycles aren't being attributed to the right instruction?
Interesting thing is this queueing part seems to be the same in rcuclassic
too, which seems to run faster.

I'll try to run it on a bigger machine and see if it becomes more
pronounced. But I might not get around to that tonight.


> > > Hmmm...  What is the workload?  CPU-bound?  If CONFIG_PREEMPT=n, I might
> > > expect interference from force_quiescent_state(), except that it should
> > > run only every few clock ticks.  So this seems quite unlikely.
> > 
> > It's CPU bound and preempt=y.
> > 
> > Workload is just 8 processes running a loop of close(open("file$i")) as
> > I said though you probably won't be able to reproduce it on a vanilla
> > kernel.
> 
> OK, so you are executing call_rcu() a -lot-!!!
> 
> Could you also please try CONFIG_RCU_TRACE=y, and send me the contents of
> the files in the "rcu" subdirectory in debugfs?  Please take a snapshot
> of these files, run your test for a fixed time interval (perhaps ten
> seconds, but please tell me how long), then take a second snapshot.

Attached, old/* vs new/*. Interval was 22s.

