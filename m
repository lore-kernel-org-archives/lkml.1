Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbXFKWS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbXFKWS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbXFKWSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:18:13 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50389 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbXFKWSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:18:09 -0400
Date: Mon, 11 Jun 2007 15:18:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070611221803.GL9102@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070609210507.GA29194@elte.hu> <20070611011954.GG27982@linux.vnet.ibm.com> <20070611073634.GB32446@elte.hu> <20070611144401.GA9102@linux.vnet.ibm.com> <20070611153855.GA21136@elte.hu> <20070611155527.GD9102@linux.vnet.ibm.com> <20070611171806.GH9102@linux.vnet.ibm.com> <20070611204427.GK9102@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611204427.GK9102@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 01:44:27PM -0700, Paul E. McKenney wrote:
> On Mon, Jun 11, 2007 at 10:18:06AM -0700, Paul E. McKenney wrote:
> > On Mon, Jun 11, 2007 at 08:55:27AM -0700, Paul E. McKenney wrote:
> > > On Mon, Jun 11, 2007 at 05:38:55PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > > hm, what affinity do they start out with? Could they all be pinned 
> > > > > > to CPU#0 by default?
> > > > > 
> > > > > They start off with affinity masks of 0xf on a 4-CPU system.  I would 
> > > > > expect them to load-balance across the four CPUs, but they stay all on 
> > > > > the same CPU until long after I lose patience (many minutes).
> > > > 
> > > > ugh. Would be nice to figure out why this happens. I enabled rcutorture 
> > > > on a dual-core CPU and all the threads are spread evenly.
> > > 
> > > Here is the /proc/cpuinfo in case this helps.  I am starting up a test
> > > on a dual-core CPU to see if that works better.
> > 
> > And this quickly load-balanced to put a pair of readers on each CPU.
> > Later, it moved one of the readers so that it is now running with
> > one reader on one of the CPUs, and the remaining three readers on the
> > other CPU.
> > 
> > Argh...  this is with 2.6.21-rt1...  Need to reboot with 2.6.21.4-rt12...
> 
> OK, here are a couple of snapshots from "top" on a two-way system.
> It seems to cycle back and forth between these two states.

And on the 4-CPU box:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
 3112 root      39  19     0    0    0 R 11.6  0.0   0:44.34 rcu_torture_rea   
 3114 root      39  19     0    0    0 R 11.6  0.0   0:44.34 rcu_torture_rea   
 3115 root      39  19     0    0    0 R 11.6  0.0   0:44.34 rcu_torture_rea   
 3116 root      39  19     0    0    0 R 11.6  0.0   0:44.34 rcu_torture_rea   
 3109 root      39  19     0    0    0 R 11.3  0.0   0:44.33 rcu_torture_rea   
 3110 root      39  19     0    0    0 R 11.3  0.0   0:44.33 rcu_torture_rea   
 3111 root      39  19     0    0    0 R 11.3  0.0   0:44.34 rcu_torture_rea   
 3113 root      39  19     0    0    0 R 11.3  0.0   0:44.34 rcu_torture_rea   
 3108 root      39  19     0    0    0 D  6.0  0.0   0:24.35 rcu_torture_wri   

All are on CPU zero:

elm3b6:~# cat /proc/3109/stat | awk '{print $(NF-3)}'
0
elm3b6:~# cat /proc/3110/stat | awk '{print $(NF-3)}'
0
elm3b6:~# cat /proc/3111/stat | awk '{print $(NF-3)}'
0
elm3b6:~# cat /proc/3112/stat | awk '{print $(NF-3)}'
0
elm3b6:~# cat /proc/3113/stat | awk '{print $(NF-3)}'
0
elm3b6:~# cat /proc/3114/stat | awk '{print $(NF-3)}'
0
elm3b6:~# cat /proc/3115/stat | awk '{print $(NF-3)}'
0
elm3b6:~# cat /proc/3116/stat | awk '{print $(NF-3)}'
0
elm3b6:~# cat /proc/3108/stat | awk '{print $(NF-3)}'
0

All have their affinity masks at f (allowing them to run on all CPUs):

elm3b6:~# taskset -p 3109
pid 3109's current affinity mask: f
elm3b6:~# taskset -p 3110
pid 3110's current affinity mask: f
elm3b6:~# taskset -p 3111
pid 3111's current affinity mask: f
elm3b6:~# taskset -p 3112
pid 3112's current affinity mask: f
elm3b6:~# taskset -p 3113
pid 3113's current affinity mask: f
elm3b6:~# taskset -p 3114
pid 3114's current affinity mask: f
elm3b6:~# taskset -p 3115
pid 3115's current affinity mask: f
elm3b6:~# taskset -p 3116
pid 3116's current affinity mask: f
elm3b6:~# taskset -p 3108
pid 3108's current affinity mask: f

Not a biggie for me, since I can easily do the taskset commands to
force the processes to spread out, but I am worried that casual users
of rcutorture won't know to do this -- thus not really torturing RCU.
It would not be hard to modify rcutorture to affinity the tasks so as
to spread them, but this seems a bit ugly.

						Thanx, Paul
