Return-Path: <linux-kernel-owner+w=401wt.eu-S932927Ab0AGBEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab0AGBEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932800Ab0AGBEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:04:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34068 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680Ab0AGBEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:04:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 10:00:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-Id: <20100107100054.e56b709a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LFD.2.00.1001060119010.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>
	<20100104182813.753545361@chello.nl>
	<20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
	<20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001042052210.3630@localhost.localdomain>
	<20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
	<20100106092212.c8766aa8.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001051718100.3630@localhost.localdomain>
	<20100106115233.5621bd5e.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001051917000.3630@localhost.localdomain>
	<20100106125625.b02c1b3a.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001052007090.3630@localhost.localdomain>
	<20100106160614.ff756f82.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001060119010.3630@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010 01:39:17 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 6 Jan 2010, KAMEZAWA Hiroyuki wrote:
> >
> >      9.08%  multi-fault-all  [kernel]                  [k] down_read_trylock
<snip>
> That way, it will do the cmpxchg first, and if it wasn't unlocked and had 
> other readers active, it will end up doing an extra cmpxchg, but still 
> hopefully avoid the extra bus cycles.
> 
> So it might be worth testing this trivial patch on top of my other one.
> 
Test: on 8-core/2-socket x86-64
  while () {
	touch memory
	barrier
	madvice DONTNEED all range by cpu 0
	barrier
  }

<Before> (cut from my post)
> [root@bluextal memory]#  /root/bin/perf stat -e page-faults,cache-misses --repeat 5 ./multi-fault-all 8
> 
>  Performance counter stats for './multi-fault-all 8' (5 runs):
> 
>        33029186  page-faults                ( +-   0.146% )
>       348698659  cache-misses               ( +-   0.149% )
> 
>    60.002876268  seconds time elapsed   ( +-   0.001% )
>     41.51%  multi-fault-all  [kernel]                  [k] clear_page_c
>      9.08%  multi-fault-all  [kernel]                  [k] down_read_trylock
>      6.23%  multi-fault-all  [kernel]                  [k] up_read
>      6.17%  multi-fault-all  [kernel]                  [k] __mem_cgroup_try_charg


<After>
[root@bluextal memory]#  /root/bin/perf stat -e page-faults,cache-misses --repeat 5 ./multi-fault-all 8

 Performance counter stats for './multi-fault-all 8' (5 runs):

       33782787  page-faults                ( +-   2.650% )
      332753197  cache-misses               ( +-   0.477% )

   60.003984337  seconds time elapsed   ( +-   0.004% )

# Samples: 1014408915089
#
# Overhead          Command             Shared Object  Symbol
# ........  ...............  ........................  ......
#
    44.42%  multi-fault-all  [kernel]                  [k] clear_page_c
     7.73%  multi-fault-all  [kernel]                  [k] down_read_trylock
     6.65%  multi-fault-all  [kernel]                  [k] __mem_cgroup_try_char
     6.15%  multi-fault-all  [kernel]                  [k] up_read
     4.87%  multi-fault-all  [kernel]                  [k] handle_mm_fault
     3.70%  multi-fault-all  [kernel]                  [k] __rmqueue
     3.69%  multi-fault-all  [kernel]                  [k] __mem_cgroup_commit_c
     2.35%  multi-fault-all  [kernel]                  [k] bad_range


yes, it seems slightly improved, at least on this test.
but page-fault-throughput test score is within error range.


Thanks,
-Kame



