Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbXFMB2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbXFMB2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 21:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbXFMB1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 21:27:54 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41463 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbXFMB1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 21:27:53 -0400
Date: Tue, 12 Jun 2007 18:27:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070613012746.GH8544@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070609210507.GA29194@elte.hu> <20070611011954.GG27982@linux.vnet.ibm.com> <20070611073634.GB32446@elte.hu> <20070611144401.GA9102@linux.vnet.ibm.com> <20070611153855.GA21136@elte.hu> <20070611155527.GD9102@linux.vnet.ibm.com> <20070611171806.GH9102@linux.vnet.ibm.com> <20070611204427.GK9102@linux.vnet.ibm.com> <20070611221803.GL9102@linux.vnet.ibm.com> <20070612213758.GA6173@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612213758.GA6173@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 11:37:58PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Not a biggie for me, since I can easily do the taskset commands to 
> > force the processes to spread out, but I am worried that casual users 
> > of rcutorture won't know to do this -- thus not really torturing RCU. 
> > It would not be hard to modify rcutorture to affinity the tasks so as 
> > to spread them, but this seems a bit ugly.
> 
> does it get any better if you renice them from +19 to 0? (and then back 
> to +19?)

Interesting!

That did spread them evenly across two CPUs, but not across all four.

I took a look at CFS, which seems to operate in terms of milliseconds.
Since the rcu_torture_reader() code enters the scheduler on each
interation, it would not give CFS millisecond-scale bursts of CPU
consumption, perhaps not allowing it to do reasonable load balancing.

So I inserted the following code at the beginning of rcu_torture_reader():

	set_user_nice(current, 19);
	set_user_nice(current, 0);
	for (idx = 0; idx < 1000; idx++) {
		udelay(10);
	}
	set_user_nice(current, 19);

This worked much better:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
18600 root      39  19     0    0    0 R   50  0.0   0:09.57 rcu_torture_rea    
18599 root      39  19     0    0    0 R   50  0.0   0:09.56 rcu_torture_rea    
18598 root      39  19     0    0    0 R   49  0.0   0:10.33 rcu_torture_rea    
18602 root      39  19     0    0    0 R   49  0.0   0:10.34 rcu_torture_rea    
18596 root      39  19     0    0    0 R   47  0.0   0:09.48 rcu_torture_rea    
18601 root      39  19     0    0    0 R   46  0.0   0:09.56 rcu_torture_rea    
18595 root      39  19     0    0    0 R   45  0.0   0:09.23 rcu_torture_rea    
18597 root      39  19     0    0    0 R   44  0.0   0:10.92 rcu_torture_rea    
18590 root      39  19     0    0    0 R   10  0.0   0:02.23 rcu_torture_wri    
18591 root      39  19     0    0    0 D    2  0.0   0:00.34 rcu_torture_fak    
18592 root      39  19     0    0    0 D    2  0.0   0:00.35 rcu_torture_fak    
18593 root      39  19     0    0    0 D    2  0.0   0:00.35 rcu_torture_fak    
18594 root      39  19     0    0    0 D    2  0.0   0:00.33 rcu_torture_fak    
18603 root      15  -5     0    0    0 S    1  0.0   0:00.06 rcu_torture_sta    

(The first eight tasks are readers, while the last six tasks are update
and statistics threads that don't consume so much CPU, so the above is
pretty close to optimal.)

I stopped and restarted rcutorture several times, and it spread nicely
each time, at least aside from the time that makewhatis decided to fire
up just as I started rcutorture.

But this is admittedly a -very- crude hack.

One approach would be to make them all spin until a few milliseconds
after the last one was created.  I would like to spread the readers
separately from the other tasks, which could be done by taking a two-stage
approach, spreading the writer and fakewriter tasks first, then spreading
the readers.  This seems a bit nicer, and I will play with it a bit.

In the meantime, thoughts on more-maintainable ways of making this work?

						Thanx, Paul
