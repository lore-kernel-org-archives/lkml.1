Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZJBE5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZJBE5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 00:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbZJBE5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 00:57:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34095 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZJBE5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 00:57:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Oct 2009 13:55:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH 0/2] memcg: improving scalability by reducing lock
 contention at charge/uncharge
Message-Id: <20091002135531.3b5abf5c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch is against mmotm + softlimit fix patches.
(which are now in -rc git tree.)

In the latest -rc series, the kernel avoids accessing res_counter when
cgroup is root cgroup. This helps scalabilty when memcg is not used.

It's necessary to improve scalabilty even when memcg is used. This patch
is for that. Previous Balbir's work shows that the biggest obstacles for
better scalabilty is memcg's res_counter. Then, there are 2 ways.

(1) make counter scale well.
(2) avoid accessing core counter as much as possible.

My first direction was (1). But no, there is no counter which is free
from false sharing when it needs system-wide fine grain synchronization.
And res_counter has several functionality...this makes (1) difficult.
spin_lock (in slow path) around counter means tons of invalidation will
happen even when we just access counter without modification.

This patch series is for (2). This implements charge/uncharge in bached manner.
This coalesces access to res_counter at charge/uncharge using nature of
access locality.

Tested for a month. And I got good reorts from Balbir and Nishimura, thanks.
One concern is that this adds some members to the bottom of task_struct.
Better idea is welcome.

Following is test result of continuous page-fault on my 8cpu box(x86-64).

A loop like this runs on all cpus in parallel for 60secs. 
==
        while (1) {
                x = mmap(NULL, MEGA, PROT_READ|PROT_WRITE,
                        MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);

                for (off = 0; off < MEGA; off += PAGE_SIZE)
                        x[off]=0;
                munmap(x, MEGA);
        }
==
please see # of page faults. I think this is good improvement.


[Before]
 Performance counter stats for './runpause.sh' (5 runs):

  474539.756944  task-clock-msecs         #      7.890 CPUs    ( +-   0.015% )
          10284  context-switches         #      0.000 M/sec   ( +-   0.156% )
             12  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
       18425800  page-faults              #      0.039 M/sec   ( +-   0.107% )
  1486296285360  cycles                   #   3132.080 M/sec   ( +-   0.029% )
   380334406216  instructions             #      0.256 IPC     ( +-   0.058% )
     3274206662  cache-references         #      6.900 M/sec   ( +-   0.453% )
     1272947699  cache-misses             #      2.682 M/sec   ( +-   0.118% )

   60.147907341  seconds time elapsed   ( +-   0.010% )

[After]
 Performance counter stats for './runpause.sh' (5 runs):

  474658.997489  task-clock-msecs         #      7.891 CPUs    ( +-   0.006% )
          10250  context-switches         #      0.000 M/sec   ( +-   0.020% )
             11  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
       33177858  page-faults              #      0.070 M/sec   ( +-   0.152% )
  1485264748476  cycles                   #   3129.120 M/sec   ( +-   0.021% )
   409847004519  instructions             #      0.276 IPC     ( +-   0.123% )
     3237478723  cache-references         #      6.821 M/sec   ( +-   0.574% )
     1182572827  cache-misses             #      2.491 M/sec   ( +-   0.179% )

   60.151786309  seconds time elapsed   ( +-   0.014% )

Regards,
-Kame

