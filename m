Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbXFKUot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbXFKUot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbXFKUob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:44:31 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45010 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbXFKUo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:44:29 -0400
Date: Mon, 11 Jun 2007 13:44:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070611204427.GK9102@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070609210507.GA29194@elte.hu> <20070611011954.GG27982@linux.vnet.ibm.com> <20070611073634.GB32446@elte.hu> <20070611144401.GA9102@linux.vnet.ibm.com> <20070611153855.GA21136@elte.hu> <20070611155527.GD9102@linux.vnet.ibm.com> <20070611171806.GH9102@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611171806.GH9102@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 10:18:06AM -0700, Paul E. McKenney wrote:
> On Mon, Jun 11, 2007 at 08:55:27AM -0700, Paul E. McKenney wrote:
> > On Mon, Jun 11, 2007 at 05:38:55PM +0200, Ingo Molnar wrote:
> > > 
> > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > > hm, what affinity do they start out with? Could they all be pinned 
> > > > > to CPU#0 by default?
> > > > 
> > > > They start off with affinity masks of 0xf on a 4-CPU system.  I would 
> > > > expect them to load-balance across the four CPUs, but they stay all on 
> > > > the same CPU until long after I lose patience (many minutes).
> > > 
> > > ugh. Would be nice to figure out why this happens. I enabled rcutorture 
> > > on a dual-core CPU and all the threads are spread evenly.
> > 
> > Here is the /proc/cpuinfo in case this helps.  I am starting up a test
> > on a dual-core CPU to see if that works better.
> 
> And this quickly load-balanced to put a pair of readers on each CPU.
> Later, it moved one of the readers so that it is now running with
> one reader on one of the CPUs, and the remaining three readers on the
> other CPU.
> 
> Argh...  this is with 2.6.21-rt1...  Need to reboot with 2.6.21.4-rt12...

OK, here are a couple of snapshots from "top" on a two-way system.
It seems to cycle back and forth between these two states.

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
20126 root      39  19     0    0    0 R   47  0.0  11:38.62 rcu_torture_rea    
20129 root      39  19     0    0    0 R   47  0.0  13:28.06 rcu_torture_rea    
20127 root      39  19     0    0    0 R   43  0.0  12:39.83 rcu_torture_rea    
20128 root      39  19     0    0    0 R   43  0.0  11:50.58 rcu_torture_rea    
20121 root      39  19     0    0    0 R   10  0.0   2:59.69 rcu_torture_wri    
20123 root      39  19     0    0    0 D    2  0.0   0:28.52 rcu_torture_fak    
20125 root      39  19     0    0    0 D    2  0.0   0:28.47 rcu_torture_fak    
20122 root      39  19     0    0    0 D    1  0.0   0:28.38 rcu_torture_fak    
20124 root      39  19     0    0    0 D    1  0.0   0:28.41 rcu_torture_fak    

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
20129 root      39  19     0    0    0 R   80  0.0  14:46.56 rcu_torture_rea    
20126 root      39  19     0    0    0 R   33  0.0  12:52.70 rcu_torture_rea    
20128 root      39  19     0    0    0 R   33  0.0  13:01.50 rcu_torture_rea    
20127 root      39  19     0    0    0 R   33  0.0  13:49.68 rcu_torture_rea    
20121 root      39  19     0    0    0 R   13  0.0   3:16.82 rcu_torture_wri    
20122 root      39  19     0    0    0 R    2  0.0   0:31.16 rcu_torture_fak    
20123 root      39  19     0    0    0 R    2  0.0   0:31.25 rcu_torture_fak    
20124 root      39  19     0    0    0 D    2  0.0   0:31.23 rcu_torture_fak    
20125 root      39  19     0    0    0 R    2  0.0   0:31.25 rcu_torture_fak    
12907 root      20   0 12576 1068  796 R    1  0.0   0:08.55 top                

The "preferred" state is the first one.  But given that the readers
will consume all CPU available to them, the scheduler might not be
able to tell the difference.

Perhaps the fakewriters are confusing the scheduler, will try again on
a 4-CPU machine leaving them out.

						Thanx, Paul
