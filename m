Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZBRBCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZBRBCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZBRBCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:02:22 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53321 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZBRBCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:02:21 -0500
Date: Tue, 17 Feb 2009 17:02:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Damien Wyart <damien.wyart@free.fr>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090218010220.GW6761@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090216132151.GA17996@elte.hu> <20090216160613.GA6785@linux.vnet.ibm.com> <20090216185616.GB6785@linux.vnet.ibm.com> <20090216200923.GA28938@elte.hu> <20090216223944.GF6785@linux.vnet.ibm.com> <20090217043422.GA5836@nowhere> <20090217151046.GB6761@linux.vnet.ibm.com> <20090217223741.GC5194@nowhere> <20090217224826.GO6761@linux.vnet.ibm.com> <20090218003801.GD25856@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218003801.GD25856@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 01:38:01AM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > No, it was my confusion -- I later realized that your data 
> > above meant that the force-quiescent-state code path was not 
> > being heavily exercised. So no need for this trace!
> 
> Do you have any theory for why RCU was activated every 100-200 
> microseconds, resulting in 20% ksoftirqd CPU use - and why the 
> problem went away with classic-rcu?

RCU was activated every 100-200 microseconds because the x86 32-bit
idle loop would call rcu_pending() and rcu_check_callbacks() in a tight
loop under some conditions.  This was happening to both classic and
tree RCU, but classic RCU has a more exact rcu_pending() check, and so
classic RCU's rcu_pending() always returns false, so that classic RCU's
rcu_check_callbacks() was never invoked, so that the raise_softirq()
is never called, so that control never passed to ksoftirqd, so that
things like "uptime" could not see the activity.

But the activity was occurring with classic RCU nevertheless.

</useful information>

<aside>

Interestingly enough, this is actually a symptom of a theoretical bug
in classic RCU (noted by Manfred Spraul some months ago).  Classic RCU
assumes that interrupts from dynticks idle mode don't run long enough
to run through a full grace period (which, in absence of truly broken
driver code, they do not).  Therefore, classic RCU removes all dynticks
idle CPUs from considation at the beginning of each grace period, so
that classic RCU's rcu_pending() doesn't have to concern itself with
other dyntick-idle CPUs.

When rcu_pending() is invoked once per jiffy, the additional checking
that tree RCU must do is in the noise, but not so when called repeatedly
from the idle loop.

</aside>

							Thanx, Paul
