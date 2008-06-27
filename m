Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbYF0MDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbYF0MDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbYF0L6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:10 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:16284 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbYF0L5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:55 -0400
X-SourceIP: 62.163.52.83
Message-Id: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:09 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/30] SMP-group balancer - take 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Another go at SMP fairness for group scheduling.

This code needs some serious testing,..

However on my system performance doesn't tank as much as it used to.
I've ran sysbench and volanomark benchmarks.

The machine is a Quad core (Intel Q9450) with 4GB of RAM.
Fedora9 - x86_64

sysbench-0.4.8 + postgresql-8.3.3
volanomark-2.5.0.9 + openjdk-1.6.0

I've used cgroup group scheduling.

cgroup:/ - means all tasks are in the root group
cgroup:/foo - means all tasks are in a subgroup

mkdir /cgroup/foo
for i in `cat /cgroup/tasks`; do
  echo $i > /cgroup/foo/tasks
done

The patches are against: tip/auto-sched-next of a few days ago.

---

.25

[root@twins sysbench-0.4.8]# ./doit-psql-256-60sec 
  1:     transactions:                        50514  (841.90 per sec.)
  2:     transactions:                        98745  (1645.73 per sec.)
  4:     transactions:                        192682 (3211.31 per sec.)
  8:     transactions:                        192082 (3201.26 per sec.)
 16:     transactions:                        188891 (3147.95 per sec.)
 32:     transactions:                        182364 (3039.12 per sec.)
 64:     transactions:                        169412 (2822.94 per sec.)
128:     transactions:                        139505 (2323.95 per sec.)
256:     transactions:                        131516 (2188.98 per sec.)

[root@twins vmark]# LOOP_CLIENT_COUNT=1000 ./loopclient.sh 2>&1 | grep Average
Average throughput = 113350 messages per second
Average throughput = 112230 messages per second
Average throughput = 113125 messages per second


.26-rc

cgroup:/

[root@twins sysbench-0.4.8]# ./doit-psql-256-60sec 
  1:     transactions:                        50553  (842.54 per sec.)
  2:     transactions:                        98625  (1643.74 per sec.)
  4:     transactions:                        191351 (3189.12 per sec.)
  8:     transactions:                        193525 (3225.32 per sec.)
 16:     transactions:                        190516 (3175.10 per sec.)
 32:     transactions:                        186914 (3114.96 per sec.)
 64:     transactions:                        178940 (2981.78 per sec.)
128:     transactions:                        156430 (2606.00 per sec.)
256:     transactions:                        134929 (2246.63 per sec.)

[root@twins vmark]# LOOP_CLIENT_COUNT=1000 ./loopclient.sh 2>&1 | grep Average
Average throughput = 124089 messages per second
Average throughput = 121962 messages per second
Average throughput = 121223 messages per second


cgroup:/foo

[root@twins sysbench-0.4.8]# ./doit-psql-256-60sec 
  1:     transactions:                        50246  (837.43 per sec.)
  2:     transactions:                        97466  (1624.41 per sec.)
  4:     transactions:                        179609 (2993.43 per sec.)
  8:     transactions:                        190931 (3182.07 per sec.)
 16:     transactions:                        189882 (3164.50 per sec.)
 32:     transactions:                        184649 (3077.14 per sec.)
 64:     transactions:                        178200 (2969.46 per sec.)
128:     transactions:                        158835 (2646.14 per sec.)
256:     transactions:                        142100 (2366.51 per sec.)

[root@twins vmark]# LOOP_CLIENT_COUNT=1000 ./loopclient.sh 2>&1 | grep Average
Average throughput = 117789 messages per second
Average throughput = 118154 messages per second
Average throughput = 118945 messages per second


.26-rc-smp-group

cgroup:/

[root@twins sysbench-0.4.8]# ./doit-psql-256-60sec 
  1:     transactions:                        50137  (835.61 per sec.)
  2:     transactions:                        97406  (1623.41 per sec.)
  4:     transactions:                        170755 (2845.88 per sec.)
  8:     transactions:                        187406 (3123.35 per sec.)
 16:     transactions:                        186865 (3114.18 per sec.)
 32:     transactions:                        183559 (3059.03 per sec.)
 64:     transactions:                        176834 (2946.70 per sec.)
128:     transactions:                        158882 (2647.04 per sec.)
256:     transactions:                        145081 (2415.81 per sec.)

[root@twins vmark]# LOOP_CLIENT_COUNT=1000 ./loopclient.sh 2>&1 | grep Average
Average throughput = 121499 messages per second
Average throughput = 120181 messages per second
Average throughput = 119775 messages per second


cgroup:/foo

[root@twins sysbench-0.4.8]# ./doit-psql-256-60sec 
  1:     transactions:                        49564  (826.06 per sec.)
  2:     transactions:                        96642  (1610.67 per sec.)
  4:     transactions:                        183081 (3051.29 per sec.)
  8:     transactions:                        187553 (3125.79 per sec.)
 16:     transactions:                        185435 (3090.45 per sec.)
 32:     transactions:                        182314 (3038.25 per sec.)
 64:     transactions:                        174527 (2908.22 per sec.)
128:     transactions:                        159321 (2654.24 per sec.)
256:     transactions:                        140167 (2333.82 per sec.)

[root@twins vmark]# LOOP_CLIENT_COUNT=1000 ./loopclient.sh 2>&1 | grep Average
Average throughput = 130208 messages per second
Average throughput = 129086 messages per second
Average throughput = 129362 messages per second


-- 

