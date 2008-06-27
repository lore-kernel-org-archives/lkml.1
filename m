Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbYF0Reo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbYF0Reo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYF0Ree
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:34:34 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52086 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYF0Red (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:34:33 -0400
Date: Fri, 27 Jun 2008 23:03:55 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/30] SMP-group balancer - take 3
Message-ID: <20080627173355.GA11381@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080627114109.724249622@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627114109.724249622@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 01:41:09PM +0200, Peter Zijlstra wrote:
> Hi,
> 
> Another go at SMP fairness for group scheduling.
> 
> This code needs some serious testing,..
> 
> However on my system performance doesn't tank as much as it used to.
> I've ran sysbench and volanomark benchmarks.
> 
> The machine is a Quad core (Intel Q9450) with 4GB of RAM.
> Fedora9 - x86_64
> 
> sysbench-0.4.8 + postgresql-8.3.3
> volanomark-2.5.0.9 + openjdk-1.6.0
> 
> I've used cgroup group scheduling.
> 
> cgroup:/ - means all tasks are in the root group
> cgroup:/foo - means all tasks are in a subgroup
> 
> mkdir /cgroup/foo
> for i in `cat /cgroup/tasks`; do
>   echo $i > /cgroup/foo/tasks
> done
> 
> The patches are against: tip/auto-sched-next of a few days ago.
> 
> ---
> 
> .25
> 
> [root@twins sysbench-0.4.8]# ./doit-psql-256-60sec 
>   1:     transactions:                        50514  (841.90 per sec.)
>   2:     transactions:                        98745  (1645.73 per sec.)
>   4:     transactions:                        192682 (3211.31 per sec.)
>   8:     transactions:                        192082 (3201.26 per sec.)
>  16:     transactions:                        188891 (3147.95 per sec.)
>  32:     transactions:                        182364 (3039.12 per sec.)
>  64:     transactions:                        169412 (2822.94 per sec.)
> 128:     transactions:                        139505 (2323.95 per sec.)
> 256:     transactions:                        131516 (2188.98 per sec.)
> 
> [root@twins vmark]# LOOP_CLIENT_COUNT=1000 ./loopclient.sh 2>&1 | grep Average
> Average throughput = 113350 messages per second
> Average throughput = 112230 messages per second
> Average throughput = 113125 messages per second
> 
> 
> .26-rc
> 
> cgroup:/
> 
> [root@twins sysbench-0.4.8]# ./doit-psql-256-60sec 
>   1:     transactions:                        50553  (842.54 per sec.)
>   2:     transactions:                        98625  (1643.74 per sec.)
>   4:     transactions:                        191351 (3189.12 per sec.)
>   8:     transactions:                        193525 (3225.32 per sec.)
>  16:     transactions:                        190516 (3175.10 per sec.)
>  32:     transactions:                        186914 (3114.96 per sec.)
>  64:     transactions:                        178940 (2981.78 per sec.)
> 128:     transactions:                        156430 (2606.00 per sec.)
> 256:     transactions:                        134929 (2246.63 per sec.)
> 
> [root@twins vmark]# LOOP_CLIENT_COUNT=1000 ./loopclient.sh 2>&1 | grep Average
> Average throughput = 124089 messages per second
> Average throughput = 121962 messages per second
> Average throughput = 121223 messages per second
> 
> 
> cgroup:/foo
> 
> [root@twins sysbench-0.4.8]# ./doit-psql-256-60sec 
>   1:     transactions:                        50246  (837.43 per sec.)
>   2:     transactions:                        97466  (1624.41 per sec.)
>   4:     transactions:                        179609 (2993.43 per sec.)
>   8:     transactions:                        190931 (3182.07 per sec.)
>  16:     transactions:                        189882 (3164.50 per sec.)
>  32:     transactions:                        184649 (3077.14 per sec.)
>  64:     transactions:                        178200 (2969.46 per sec.)
> 128:     transactions:                        158835 (2646.14 per sec.)
> 256:     transactions:                        142100 (2366.51 per sec.)
> 
> [root@twins vmark]# LOOP_CLIENT_COUNT=1000 ./loopclient.sh 2>&1 | grep Average
> Average throughput = 117789 messages per second
> Average throughput = 118154 messages per second
> Average throughput = 118945 messages per second
> 
> 
> .26-rc-smp-group
> 
> cgroup:/
> 
> [root@twins sysbench-0.4.8]# ./doit-psql-256-60sec 
>   1:     transactions:                        50137  (835.61 per sec.)
>   2:     transactions:                        97406  (1623.41 per sec.)
>   4:     transactions:                        170755 (2845.88 per sec.)
>   8:     transactions:                        187406 (3123.35 per sec.)
>  16:     transactions:                        186865 (3114.18 per sec.)
>  32:     transactions:                        183559 (3059.03 per sec.)
>  64:     transactions:                        176834 (2946.70 per sec.)
> 128:     transactions:                        158882 (2647.04 per sec.)
> 256:     transactions:                        145081 (2415.81 per sec.)
> 
> [root@twins vmark]# LOOP_CLIENT_COUNT=1000 ./loopclient.sh 2>&1 | grep Average
> Average throughput = 121499 messages per second
> Average throughput = 120181 messages per second
> Average throughput = 119775 messages per second
> 
> 
> cgroup:/foo
> 
> [root@twins sysbench-0.4.8]# ./doit-psql-256-60sec 
>   1:     transactions:                        49564  (826.06 per sec.)
>   2:     transactions:                        96642  (1610.67 per sec.)
>   4:     transactions:                        183081 (3051.29 per sec.)
>   8:     transactions:                        187553 (3125.79 per sec.)
>  16:     transactions:                        185435 (3090.45 per sec.)
>  32:     transactions:                        182314 (3038.25 per sec.)
>  64:     transactions:                        174527 (2908.22 per sec.)
> 128:     transactions:                        159321 (2654.24 per sec.)
> 256:     transactions:                        140167 (2333.82 per sec.)
> 
> [root@twins vmark]# LOOP_CLIENT_COUNT=1000 ./loopclient.sh 2>&1 | grep Average
> Average throughput = 130208 messages per second
> Average throughput = 129086 messages per second
> Average throughput = 129362 messages per second

Some fairness numbers from tip/master

kernel compiles with even number of threads
/cgroup/a
[dhaval@mordor a]$ time make -j8
real    1m53.033s
user    1m28.785s
sys     0m22.224s

/cgroup/b
[dhaval@mordor b]$ time make -j16
real    1m51.826s
user    1m29.022s
sys     0m21.911s

kernel compile with odd number of threads
/cgroup/a
[dhaval@mordor a]$ time make -j7
real    1m49.441s
user    1m26.962s
sys     0m21.698s

/cgroup/b
[dhaval@mordor b]$ time make -j13
real    1m50.418s
user    1m26.888s
sys     0m21.508s

Running infinite loops in parallel (5 in one group, 2 in another)

8789 - 8793 belong to /cgroup/a
8794, 8795 belong /cgroup/b

When we start.

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
 8795 dhaval    20   0  1720  264  212 R 54.6  0.0   0:06.31 test              
 8794 dhaval    20   0  1720  264  212 R 45.6  0.0   0:06.91 test              
 8790 dhaval    20   0  1720  264  212 R 23.0  0.0   0:07.29 test              
 8789 dhaval    20   0  1720  260  212 R 22.6  0.0   0:07.80 test              
 8791 dhaval    20   0  1720  264  212 R 18.3  0.0   0:07.28 test              
 8792 dhaval    20   0  1720  260  212 R 18.3  0.0   0:07.01 test              
 8793 dhaval    20   0  1720  260  212 R 18.0  0.0   0:06.93 test              

After sometime

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
 8794 dhaval    20   0  1720  264  212 R 49.9  0.0   0:46.98 test              
 8795 dhaval    20   0  1720  264  212 R 49.9  0.0   0:52.61 test              
 8793 dhaval    20   0  1720  260  212 R 20.3  0.0   0:24.96 test              
 8789 dhaval    20   0  1720  260  212 R 20.0  0.0   0:24.83 test              
 8790 dhaval    20   0  1720  264  212 R 20.0  0.0   0:24.32 test              
 8791 dhaval    20   0  1720  264  212 R 20.0  0.0   0:23.29 test              
 8792 dhaval    20   0  1720  260  212 R 20.0  0.0   0:25.04 test              

But these numbers are not very stable. Also it takes a long time (~1min)
to converge here.

The results look really good though.

-- 
regards,
Dhaval
