Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZIHHsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZIHHsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 03:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZIHHsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 03:48:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbZIHHs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 03:48:29 -0400
Date: Tue, 8 Sep 2009 09:48:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090908074825.GA11413@elte.hu>
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907182629.GA3484@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> That's interesting. I tried to reproduce it on x86, but the 
> profile does not show any scheduler overhead at all on the server:

I've now simulated a saturated iperf server by adding an 
udelay(3000) to e1000_intr() in via the patch below.

There's no idle time left that way:

 Cpu(s):  0.0%us,  2.6%sy,  0.0%ni,  0.0%id,  0.0%wa, 93.2%hi,  4.2%si,  0.0%st
 Mem:   1021044k total,    93400k used,   927644k free,     5068k buffers
 Swap:  8193140k total,        0k used,  8193140k free,    25404k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                    
 1604 mingo     20   0 38300  956  724 S 99.4  0.1   3:15.07 iperf                      
  727 root      15  -5     0    0    0 S  0.2  0.0   0:00.41 kondemand/0                
 1226 root      20   0  6452  336  240 S  0.2  0.0   0:00.06 irqbalance                 
 1387 mingo     20   0 78872 1988 1300 S  0.2  0.2   0:00.23 sshd                       
 1657 mingo     20   0 12752 1128  800 R  0.2  0.1   0:01.34 top                        
    1 root      20   0 10320  684  572 S  0.0  0.1   0:01.79 init                       
    2 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 kthreadd                   

And the server is only able to saturate half of the 1 gigabit 
bandwidth:

 Client connecting to t, TCP port 5001
 TCP window size: 16.0 KByte (default)
 ------------------------------------------------------------
 [  3] local 10.0.1.19 port 50836 connected with 10.0.1.14 port 5001
 [ ID] Interval       Transfer     Bandwidth
 [  3]  0.0-10.0 sec    504 MBytes    423 Mbits/sec
 ------------------------------------------------------------
 Client connecting to t, TCP port 5001
 TCP window size: 16.0 KByte (default)
 ------------------------------------------------------------
 [  3] local 10.0.1.19 port 50837 connected with 10.0.1.14 port 5001
 [ ID] Interval       Transfer     Bandwidth
 [  3]  0.0-10.0 sec    502 MBytes    420 Mbits/sec


perf top is showing:

------------------------------------------------------------------------------
   PerfTop:   28517 irqs/sec  kernel:99.4% [100000 cycles],  (all, 1 CPUs)
------------------------------------------------------------------------------

             samples    pcnt   kernel function
             _______   _____   _______________

           139553.00 - 93.2% : delay_tsc
             2098.00 -  1.4% : hmac_digest
              561.00 -  0.4% : ip_call_ra_chain
              335.00 -  0.2% : neigh_alloc
              279.00 -  0.2% : __hash_conntrack
              257.00 -  0.2% : dev_activate
              186.00 -  0.1% : proc_tcp_available_congestion_control
              178.00 -  0.1% : e1000_get_regs
              167.00 -  0.1% : tcp_event_data_recv

delay_tsc() dominates, as expected. Still zero scheduler overhead 
and the contex-switch rate is well below 1000 per sec.

Then i booted v2.6.30 vanilla, added the udelay(3000) and got:

 [  5] local 10.0.1.14 port 5001 connected with 10.0.1.19 port 47026
 [  5]  0.0-10.0 sec    493 MBytes    412 Mbits/sec
 [  4] local 10.0.1.14 port 5001 connected with 10.0.1.19 port 47027
 [  4]  0.0-10.0 sec    520 MBytes    436 Mbits/sec
 [  5] local 10.0.1.14 port 5001 connected with 10.0.1.19 port 47028
 [  5]  0.0-10.0 sec    506 MBytes    424 Mbits/sec
 [  4] local 10.0.1.14 port 5001 connected with 10.0.1.19 port 47029
 [  4]  0.0-10.0 sec    496 MBytes    415 Mbits/sec

i.e. essentially the same throughput. (and this shows that using .30 
versus .31 did not materially impact iperf performance in this test, 
under these conditions and with this hardware)

The i applied the BFS patch to v2.6.30 and used the same 
udelay(3000) hack and got:

No measurable change in throughput.

Obviously, this test is not equivalent to your test - but it does 
show that even saturated iperf is getting scheduled just fine. (or, 
rather, does not get scheduled all that much.)

[  5] local 10.0.1.14 port 5001 connected with 10.0.1.19 port 38505
[  5]  0.0-10.1 sec    481 MBytes    401 Mbits/sec
[  4] local 10.0.1.14 port 5001 connected with 10.0.1.19 port 38506
[  4]  0.0-10.0 sec    505 MBytes    423 Mbits/sec
[  5] local 10.0.1.14 port 5001 connected with 10.0.1.19 port 38507
[  5]  0.0-10.0 sec    508 MBytes    426 Mbits/sec
[  4] local 10.0.1.14 port 5001 connected with 10.0.1.19 port 38508
[  4]  0.0-10.0 sec    486 MBytes    406 Mbits/sec

So either your MIPS system has some unexpected dependency on the 
scheduler, or there's something weird going on.

Mind poking on this one to figure out whether it's all repeatable 
and why that slowdown happens? Multiple attempts to reproduce it 
failed here for me.

	Ingo
